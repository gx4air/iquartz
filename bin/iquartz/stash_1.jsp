stash1之后
<%--
  Created by IntelliJ IDEA.
  User: air
  Date: 14-8-18
  Time: 下午1:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="utf-8">
    <title>欢迎使用</title>
    <link rel="stylesheet" href="css/app.css"/>
    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/prettify.js"></script>
    <script src="js/validate.js"></script>
    <script src="js/bootbox.js"></script>
    <script type="text/javascript">
        <%
            String jobName = request.getParameter("jobName");
        %>
        var jobName = '<%=jobName%>';


        function submitForm(){

            //验证Cron表达式
            var v = $('#expression').val();
            if(v==''){
                var cronDiv = $('#cronDiv');

                cronDiv.addClass('error');
                var cronSpan = $('#cronSpan');

                cronSpan.attr("class", "help-inline")
                cronSpan.html('Cron表达式不能为空，请输入');

                return;
            } else if(!isCronExpress(v)){

                var cronDiv = $('#cronDiv');

                cronDiv.addClass('error');
                var cronSpan = $('#cronSpan');

                cronSpan.attr("class", "help-inline")
                cronSpan.html('Cron表达式格式不正确，请重新输入');
                return;

            } else {

                var cronDiv = $('#cronDiv');
                cronDiv.attr("class", "control-group");
                var cronSpan = $('#cronSpan');
                cronSpan.html('');
            }

            $('#jobName').val(jobName);

            //提交Form

            $('#addTriggerForm').submit();

        }



        function excute(command, triggerName, jobName) {
                var result = "";
                $.ajax({
                    type: "GET",
                    url: "/iquartz/triggerController/"+ command +"Trigger.do?triggerName="+triggerName+"&jobName="+jobName,
                    async:false,
                    success: function (data) {
                        result = data;
                    }
                });
                alert(result);
                /*var msg = '';
                if(result){
                    msg = '任务成功删除';
                }else{
                    msg = '任务删除失败';
                }

                bootbox.dialog(
                        '<em>'+msg+'</em>',
                        [{
                            "label" : "OK" ,
                            callback: function() {
                                location.reload();
                            }
                }]);*/
        }


        $(document).ready(function () {

            //TODO 请求后台获取jobList


            $.ajax({
                type: "POST",
                url: "/iquartz/jobController/listJobs.do",
                async: false,
                success: function (data) {
                    //TODO 包装数据到左侧列表
                    <%--<li class="ember-view active">
                                                    <a href="/iquartz/triggers.jsp?jobName=job1">
                <span class="ember-view service-health health-status-LIVE" rel="HealthTooltip"
                        ></span>&nbsp;
                                                        <span>job1</span>
                                                    </a>
                                                </li>
                <li class="ember-view">

                                                    <a href="/iquartz/triggers.jsp?jobName=job2">
                <span class="ember-view service-health health-status-LIVE" rel="HealthTooltip"
                      ></span>&nbsp;
                                                        <span>job2</span>
                                                    </a>
                                                </li>--%>
                    var ul = $('#jobListUl');

                    for (var i = 0; i < data.length; i++) {
                        var li = $('<li>');

                        if (jobName == 'null' && i == 0 || jobName != 'null' && jobName == data[i]) {
                            li.addClass('ember-view active');
                            jobName = data[i];
                        } else {
                            li.addClass('ember-view');
                        }

                        var a = $('<a>');
                        a.attr('href', '/iquartz/triggers.jsp?jobName=' + data[i]);
                        var span = $('<span class="ember-view service-health health-status-LIVE" rel="HealthTooltip"></span>&nbsp;<span>' + data[i] + '</span>');
                        span.appendTo(a);

                        a.appendTo(li);

                        li.appendTo(ul);
                    }

                }
            });


            //TODO 根據JobName獲取Trigger信息

            $.ajax({
                type: "GET",
                url: "/iquartz/triggerController/listTriggers.do?jobName=" + jobName,
                async: false,
                success: function (data) {
                    /*<tr>
                     <td>job_trigger1</td>
                     <td>12 12 12 * * *</td>
                     <td>2014-7-1 12:12:12</td>
                     <td>正常</td>
                     <td>2014-7-2 12:12:12</td>
                     <td>等待执行</td>
                     <td>
                     <div class="btn-group">
                     <a class="btn dropdown-toggle" data-toggle="dropdown"
                     href="#">
                     操作
                     <span class="caret"></span>
                     </a>
                     <ul class="dropdown-menu">
                     <li><a href="/iquartz/triggerController/pauseTrigger?triggerName=">暂停</a></li>
                     <li><a href="#">停止</a></li>
                     <li><a href="#">恢复</a></li>
                     <li><a href="#">删除</a></li>
                     </ul>
                     </div>
                     </td>
                     </tr>*/
                    var table = $('#triggerTable');

                    for (var i = 0; i < data.length; i++) {
                        var tr = $('<tr>');

                        var last = '';

                        if(data[i].lastTime==''){
                            last = '';
                        } else{
                            if(data[i].lastExecute){
                                last = '成功';
                            }else{
                                last = '失败';
                            }
                        }

                        var tds = $('<td>' + data[i].triggerName + '</td>'
                                + '<td>' + data[i].expression + '</td>'
                                + '<td>' + data[i].lastTime + '</td>'
                                + '<td>' + last + '</td>'
                                + '<td>' + data[i].nextTime + '</td>'
                                + '<td>' + data[i].state + '</td>'
                        );
                        var td = $('<td>');
                        var div = $('<div>');
                        div.addClass('btn-group');
                        var a = $('<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">操作<span class="caret"></span></a>');
                        var ul = $('<ul>');
                        ul.addClass('dropdown-menu');
                        var li1 = $('<li>');
                        var a1 = $('<a href="?jobName=' + jobName + '" onclick="excute(\'pause\',\'' + data[0].triggerName + '\',\'' + jobName + '\')">暂停</a>');
                        a1.appendTo(li1);

                        var li2 = $('<li>');
                        var a2 = $('<a href="?jobName=' + jobName + '" onclick="excute(\'interrupt\',\'' + data[0].triggerName + '\',\'' + jobName + '\')">停止</a>');
                        a2.appendTo(li2);
                        var li3 = $('<li>');
                        var a3 = $('<a href="?jobName=' + jobName + '" onclick="excute(\'resume\',\'' + data[0].triggerName + '\',\'' + jobName + '\')">恢复</a>');
                        a3.appendTo(li3);
                        var li4 = $('<li>');
                        var a4 = $('<a href="?jobName=' + jobName + '" onclick="excute(\'delete\',\'' + data[0].triggerName + '\',\'' + jobName + '\')">删除</a>');
                        a4.appendTo(li4);

                        li1.appendTo(ul);
                        li2.appendTo(ul);
                        li3.appendTo(ul);
                        li4.appendTo(ul);

                        a.appendTo(div);
                        ul.appendTo(div);

                        div.appendTo(td);

                        tds.appendTo(tr);
                        td.appendTo(tr);

                        tr.appendTo(triggerTable);

                    }

                }
            });


        });


    </script>
</head>

<body onload="prettyPrint()">

<div id="wrapper" class="ember-application">
    <!-- ApplicationView -->
    <div id="ember2173" class="ember-view">

        <div id="main">
            <div id="top-nav">
                <div class="navbar navbar-static-top">
                    <div class="navbar-inner">
                        <div class="container">
                            <a href="" class="logo" target="index.js"><img src="img/logo.jpg"></a>
                            <a class="brand" href="index.jsp" alt="定时框架" title="定时框架"><span
                                    id="i18n-5">定时框架</span></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container">
                <div id="content" style="background: white">
                    <div id="ember2224" class="ember-view">
                        <div id="ember2188" class="ember-view">

                            <div id="main-nav">
                                <div class="navbar">
                                    <div class="navbar-inner">
                                        <ul id="ember2708" class="ember-view nav">
                                            <li id="ember2711" class="ember-view span2 active">

                                                <a href="triggers.jsp">
                                                    定时器
                                                </a>
                                            </li>
                                            <li id="ember2712" class="ember-view span2">

                                                <a href="jobs.jsp">
                                                    任务
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div id="ember2775" class="ember-view">
                                <div id="ember2197" class="ember-view">
                                    <div class="row-fluid">
                                        <div class="services-menu well span2" style="padding: 8px 0">
                                            <ul class="ember-view nav nav-list nav-services" id="jobListUl">

                                            </ul>
                                        </div>

                                        <div class="span10" id="detail">
                                            <div class="ember-view accordion-group common-config-category">
                                                <div class="accordion-heading">
                                                    <a class="accordion-toggle">添加定时器</a>
                                                </div>

                                                <form class="form-horizontal" autocomplete="off" id="addTriggerForm"
                                                      action="/iquartz/triggerController/addTrigger.do"
                                                        method="POST"
                                                        >
                                                    <input type="hidden" name="jobName" id="jobName" />
                                                    <div class="control-group" id="cronDiv">
                                                        <label class="control-label">执行时间</label>

                                                        <div class="controls">
                                                            <input id="expression" name="expression"
                                                                   class="ember-view ember-text-field"
                                                                   type="text" value="">
                                                            <span class="help-inline">0 0/5 * * * ?</span>
                                                            <span class="help-inline hidden" id="cronSpan"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group">
                                                        <label class="control-label">立即执行</label>

                                                        <div class="controls">
                                                            <input id="instant" name="instant"
                                                                   class="ember-view ember-checkbox"
                                                                   type="checkbox" >
                                                            <span class="help-inline"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group">
                                                        <div class="controls">
                                                            <button type="button" class="btn btn-primary"
                                                                    onclick="submitForm()"><span
                                                                    id="3107">保存</span></button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="ember-view accordion-group common-config-category">
                                                <div class="accordion-heading">
                                                    <a class="accordion-toggle">定时器列表</a>
                                                </div>

                                                <table class="table">
                                                    <thead>
                                                    <tr class="ember-view">
                                                        <th class="ember-view col0">编号</th>
                                                        <th class="ember-view col1">执行时间表达式</th>
                                                        <th class="ember-view col2">上次执行时间</th>
                                                        <th class="ember-view col2">上次执行结果</th>
                                                        <th class="ember-view col3">下次执行时间</th>
                                                        <th class="ember-view col4">目前状态</th>
                                                        <th class="ember-view col5 "></th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="triggerTable">


                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>


                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>
</div>


</body>
</html>