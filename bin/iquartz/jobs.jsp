<%--
  Created by IntelliJ IDEA.
  User: air
  Date: 14-8-18
  Time: 下午7:39
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
    <script src="js/bootbox.js"></script>
    <script type="text/javascript">

        <%
            String jobName = request.getParameter("jobName");
        %>
        var jobName = '<%=jobName%>';


        function deleteJob(){

            var result = '';
            if(jobName=='null'){
                return;
            }
            $.ajax({
                type: "POST",
                url: "/iquartz/jobController/deleteJob.do?jobName="+jobName,
                async: false,
                success: function (data) {
                    result = data;

                }
            });
            var msg = '';
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
                    }]);
        }


        function f(logId){
            var log = '' ;

            $.ajax({
                type: "GET",
                url: "/iquartz/jobController/getLog.do?logId="+logId,
                async: false,
                success: function (data) {
                    log = data.exception;
                }
            });

            bootbox.dialog(
                    '<em>'+log+'</em>',
                    [{
                        "label" : "OK"
                     }]);
        }

        $(document).ready(function () {

            $.ajax({
                type: "POST",
                url: "/iquartz/jobController/listJobs.do",
                async: false,
                success: function (data) {
                    //TODO 包装数据到左侧列表
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
                        a.attr('href', '/iquartz/jobs.jsp?jobName=' + data[i]);
                        var span = $('<span class="ember-view service-health health-status-LIVE" rel="HealthTooltip"></span>&nbsp;<span>' + data[i] + '</span>');
                        span.appendTo(a);

                        a.appendTo(li);

                        li.appendTo(ul);
                    }

                }
            });


            //TODO 根據JobName獲取Job信息
            if(jobName!='null'){
                $.ajax({
                    type: "GET",
                    url: "/iquartz/jobController/getJob.do?jobName=" + jobName,
                    async: false,
                    success: function (data) {
                        $('#i18n-1541').html(data.jobName);
                        $('#i18n-1530').html(data.description);
                        if (data.statefull) {
                            $('#i18n-1531').html("是");
                        } else {
                            $('#i18n-1531').html("否");
                        }

                        var triggersTbody = $('#i18n-1532');

                        var triggers = data.triggers;

                        for (var i = 0; i < triggers.length; i++) {

                            var tr = $('<tr><td>' + triggers[i].triggerName + '</td><td>触发时间表达式:</td>' + '<td>' + triggers[i].expression + '</td>');
                            tr.appendTo(triggersTbody);
                        }

                        var paramsTbody = $('#i18n-1533');

                        var params = data.params;

                        for (var i = 0; i < params.length; i++) {

                            var tr = $('<tr><td>' + params[i].key + '</td><td>:</td>' + '<td>' + params[i].value + '</td>');
                            tr.appendTo(paramsTbody);
                        }

                        $('#i18n-1534').html(data.jobPlugin);

                        var dependencies = data.dependencies;

                        var temp = "";

                        for(var i=0; i<dependencies.length; i++){
                            if(i<dependencies.length-1){
                                temp+=dependencies[i]+" ; " ;
                            }else{
                                temp+=dependencies[i];
                            }
                        }
                        $('#i18n-1535').html(temp);
                        //alert(data.params[0].key);
                    }
                });
            }else{

                $('#summary-info').html('');

            }


            $.ajax({
                type: "GET",
                url: "/iquartz/jobController/getLogs.do?jobName=" + jobName,
                async: false,
                success: function (data) {

                    var ul_ = $('#summary-alerts-list');

                    for(var i=0; i<data.length; i++){
                        var li_ = $('<li>');
                        li_.addClass('ember-view status-0');

                        var div1 = $('<div>');
                        div1.addClass('container-fluid');
                        var div2 = $('<div>');
                        div2.addClass('row-fluid');
                        var div3 = $('<div>');
                        div3.addClass('span1 status-icon');
                        var i1 = $('<i>');

                        i1.appendTo(div3);

                        var div4 = $('<div>');
                        div4.addClass('span11');

                        var div5 = $('<div>');
                        div5.addClass('row-fluid');


                        var infoDiv = $('<div>');
                        infoDiv.addClass('span7 title');




                        var aDiv = $('<div>');
                        aDiv.addClass('span5 date-time');
                        aDiv.attr('rel', 'tooltip');
                        aDiv.attr('data-placement', 'right');



                        if(data[i].result==1){

                            infoDiv.html('任务运行正常');
                            i1.addClass('icon-ok icon-large');

                        } else{
                            infoDiv.html('任务运行出现异常');
                            i1.addClass('icon-warning-sign icon-large');
                            var a = $('<a>');
                            a.attr('href', '#');
                            a.attr('onclick', 'f("'+ data[i].logId +'")');

                            a.html('打印堆栈信息');
                            a.appendTo(aDiv);
                        }



                        var startDateDiv = $('<div>');
                        startDateDiv.addClass('row-fluid message');
                        startDateDiv.html('开始时间：'+data[i].startDate);
                        var endDateDiv = $('<div>');
                        endDateDiv.addClass('row-fluid message');
                        endDateDiv.html('结束时间：'+data[i].endDate);

                        infoDiv.appendTo(div5);
                        aDiv.appendTo(div5);

                        div5.appendTo(div4);
                        startDateDiv.appendTo(div4);
                        endDateDiv.appendTo(div4);


                        div3.appendTo(div2);


                        div4.appendTo(div2);
                        div2.appendTo(div1);
                        div1.appendTo(li_);
                        li_.appendTo(ul_);

                   }



                    /*var li_ = $('<li>');
                    li_.addClass('ember-view status-0');

                    var div1 = $('<div>');
                    div1.addClass('container-fluid');
                    var div2 = $('<div>');
                    div2.addClass('row-fluid');
                    var div3 = $('<div>');
                    div3.addClass('span1 status-icon');
                    var li1 = $('<li>');
                    li1.addClass('icon-warning-sign icon-large');
                    li1.appendTo(div3);

                    var div4 = $('<div>');
                    div4.addClass('span11');

                    var div5 = $('<div>');
                    div5.addClass('row-fluid');


                    var infoDiv = $('<div>');
                     infoDiv.addClass('span7 title');
                    infoDiv.html('任务运行出现异常');
                    var aDiv = $('<div>');
                    aDiv.addClass('span5 date-time');
                    aDiv.attr('rel', 'tooltip');
                    aDiv.attr('data-placement', 'right');

                    var a = $('<a>');
                    a.attr('href', '#')

                    a.html('打印堆栈信息');

                    a.appendTo(aDiv);


                    var startDateDiv = $('<div>');
                    startDateDiv.addClass('row-fluid message');
                    startDateDiv.html('开始时间：2014-6-10 12：00：00');
                    var endDateDiv = $('<div>');
                    endDateDiv.addClass('row-fluid message');
                    endDateDiv.html('开始时间：2014-6-10 12：00：00');

                    infoDiv.appendTo(div5);
                    aDiv.appendTo(div5);

                    div5.appendTo(div4);
                    startDateDiv.appendTo(div4);
                    endDateDiv.appendTo(div4);


                    div3.appendTo(div2);


                    div4.appendTo(div2);
                    div2.appendTo(div1);
                    div1.appendTo(li_);
                    li_.appendTo(ul_);*/

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

                            <script id="metamorph-3-start" type="text/x-placeholder"></script>
                            <div id="main-nav">
                                <div class="navbar">
                                    <div class="navbar-inner">
                                        <ul id="ember2708" class="ember-view nav">
                                            <li id="ember2711" class="ember-view span2 ">

                                                <a href="triggers.jsp">
                                                    定时器
                                                </a>
                                            </li>
                                            <li id="ember2712" class="ember-view span2 active">

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
                                            <div class="start-stop-all-service-button">
                                                <a href="#" class="btn btn-danger" data-bindattr-218="218" data-toggle="modal" data-ember-action="219" onclick="deleteJob()">
                                                    <i class="icon-stop icon-white"></i>
                                                    <span id="i18n-219">删除</span>
                                                </a>
                                            </div>
                                        </div>

                                        <div class="span10" id="detail">
                                            <div class="ember-view accordion-group common-config-category">
                                                <div class="accordion-heading">
                                                    <a class="accordion-toggle">任务摘要</a>
                                                </div>

                                                <table id="summary-info" class="table no-borders table-condensed">
                                                    <tbody>
                                                    <tr>
                                                        <td><span id="i18n-1540">任务名称</span></td>
                                                        <td>
                                                            <span id="i18n-1541"></span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1543">任务描述</span></td>
                                                        <td><span id="i18n-1530"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1544">是否有状态</span></td>
                                                        <td><span id="i18n-1531"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1545">定时器</span></td>
                                                        <td>
                                                            <table class="no-borders">
                                                                <tbody id="i18n-1532">

                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1549">执行所需参数</span></td>
                                                        <td>
                                                            <table class="no-borders">
                                                                <tbody id="i18n-1533">
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1550">插件</span></td>
                                                        <td><span id="i18n-1534"></span></td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="i18n-1551">依赖库</span></td>
                                                        <td>
                                                            <span id="i18n-1535"></span>
                                                        </td>
                                                    </tr>

                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="ember-view accordion-group common-config-category">
                                                <div class="accordion-heading">
                                                    <a class="accordion-toggle">运行详情</a>
                                                </div>
                                                <ul id="summary-alerts-list" class="alerts" style="height:336px;" >
                                                    <%--<li class="ember-view status-0">

                                                        <div class="container-fluid">
                                                            <div class="row-fluid">
                                                                <div class="span1 status-icon">
                                                                    <i class="icon-warning-sign icon-large"></i>
                                                                </div>
                                                                <div class="span11">
                                                                    <div class="row-fluid">
                                                                        <div class="span7 title">任务运行出现异常
                                                                        </div>
                                                                        <div rel="tooltip"
                                                                             data-placement="right"
                                                                             class="span5 date-time"><a
                                                                                href="">打印堆栈信息</a></div>
                                                                    </div>
                                                                    <div class="row-fluid message">开始时间：2014-6-10 12：00：00
                                                                    </div>
                                                                    <div class="row-fluid message">结束时间：2014-6-10 12：00：00
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li  class="ember-view status-0">

                                                        <div class="container-fluid">
                                                            <div class="row-fluid">
                                                                <div class="span1 status-icon">
                                                                    <i class="icon-ok icon-large"></i>
                                                                </div>
                                                                <div class="span11">
                                                                    <div class="row-fluid">
                                                                        <div class="span7 title">任务运行正常
                                                                        </div>
                                                                    </div>
                                                                    <div class="row-fluid message">开始时间：2014-6-10 12：00：00
                                                                    </div>
                                                                    <div class="row-fluid message">结束时间：2014-6-10 12：00：00
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>--%>

                                                </ul>
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