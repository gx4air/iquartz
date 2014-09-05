<%--
  Created by IntelliJ IDEA.
  User: air
  Date: 14-8-17
  Time: 下午1:40
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
            String info = (String)request.getAttribute("inf");
        %>
        var jobName = '<%=jobName%>';
        var info = '<%=info%>';



        //TODO 首先要做些验证工作
        function submitForm(){

            //执行时间必须有，而且符合规则
            var v = $('input[id^="triggers"]').val();
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

            //插件上传文件必须有
            var plugin = $('#file0');
            if(plugin.val()==''){
                var pluginDiv = $('#pluginDiv');

                pluginDiv.addClass('error');
                var pluginSpan = $('#pluginSpan');

                pluginSpan.attr("class", "help-inline")
                pluginSpan.html('插件不能为空，请上传文件');
                return;
            }else if(!strEndWith(plugin.val(),'Plugin.jar')){
                var pluginDiv = $('#pluginDiv');

                pluginDiv.addClass('error');
                var pluginSpan = $('#pluginSpan');

                pluginSpan.attr("class", "help-inline")
                pluginSpan.html('上传插件名称格式必须为xxxPlugin.jar，请重新上传文件');
                return;
            } else if(!pluginValidate(plugin.val(), $('span[name^="jobNames"]'))){
                var pluginDiv = $('#pluginDiv');

                pluginDiv.addClass('error');
                var pluginSpan = $('#pluginSpan');

                pluginSpan.attr("class", "help-inline")
                pluginSpan.html('已有该名称的插件，请重新上传文件');
                return ;
            } else{

                var pluginDiv = $('#pluginDiv');
                pluginDiv.attr("class", "control-group");
                var pluginSpan = $('#pluginSpan');
                pluginSpan.html('');

                $('#jobName').val(generateJobName(plugin.val()));

            }


            //插件类路径必须有
            var pluginPath = $('#pluginPath');
            if(pluginPath.val()==''){
                var pluginPathDiv = $('#pluginPathDiv');

                pluginPathDiv.addClass('error');
                var pluginPathSpan = $('#pluginPathSpan');

                pluginPathSpan.attr("class", "help-inline")
                pluginPathSpan.html('插件类路径不能为空，请输入');
                return;
            }else {

                var pluginPathDiv = $('#pluginPathDiv');
                pluginPathDiv.attr("class", "control-group");
                var pluginPathSpan = $('#pluginPathSpan');
                pluginPathSpan.html('');
            }

            var form = $('#addJobForm');
            form.submit();

        }



        var paramIndex = 1;
        var fileIndex = 2;

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
                            li.addClass('ember-view');
                        } else {
                            li.addClass('ember-view');
                        }

                        var a = $('<a>');
                        var span = $('<span class="ember-view service-health health-status-LIVE" rel="HealthTooltip"></span>&nbsp;<span name="jobNames">' + data[i] + '</span>');
                        span.appendTo(a);

                        a.appendTo(li);

                        li.appendTo(ul);
                    }

                }
            });

            var paramBtn = $("#addParam");
            paramBtn.click(function () {

                var paramDiv = $('<div class="controls"><input class="ember-view ember-text-field" type="text" id="params[' + paramIndex + '].key" name="params[' + paramIndex + '].key"/>&nbsp;:&nbsp;<input class="ember-view ember-text-field" type="text" id="params[' + paramIndex + '].value" name="params[' + paramIndex + '].value"/>' + '</div>');
                var paramsDiv = $('#paramsDiv');
                paramDiv.appendTo(paramsDiv);

                paramIndex++;

            });

            var fileBtn = $('#addFile');
            fileBtn.click(function () {

                var fileDiv = $('<div></div>');
                fileDiv.addClass('controls');

                var fileInput = $('<input>');
                fileInput.attr('id', 'file' + fileIndex);
                fileInput.attr('name', 'file');
                fileInput.attr('type', 'file');

                fileInput.appendTo(fileDiv);

                var filesDiv = $('#filesDiv');

                fileDiv.appendTo(filesDiv);

                fileIndex++;

            });

        });

    </script>
</head>

<body>


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
                    <div class="ember-view">
                        <div class="ember-view">
                            <div id="main-nav">
                                <div class="navbar">
                                    <div class="navbar-inner">
                                        <ul class="ember-view nav">
                                            <li class="ember-view span2">

                                                <a href="triggers.jsp">
                                                    定时器
                                                </a>
                                            </li>
                                            <li class="ember-view span2">

                                                <a href="jobs.jsp">
                                                    任务
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="ember-view">
                                <div class="ember-view">
                                    <div class="row-fluid">
                                        <div class="services-menu well span2" style="padding: 8px 0">
                                            <ul class="ember-view nav nav-list nav-services" id="jobListUl">
                                            </ul>
                                        </div>

                                        <div class="span10" id="detail">
                                            <div class="ember-view accordion-group common-config-category">
                                                <div class="accordion-heading">
                                                    <a class="accordion-toggle">添加任务</a>
                                                </div>

                                                <form class="form-horizontal" autocomplete="off"
                                                      modelAttribute="jobItem" id="addJobForm"
                                                      action="/iquartz/jobController/addJob.do" method="post"
                                                      enctype="multipart/form-data">
                                                    <input type="hidden" id="jobName" name="jobName" />
                                                    <div class="control-group">
                                                        <label class="control-label">任务描述</label>

                                                        <div class="controls">
                                                            <input id="description" name="description"
                                                                   class="ember-view ember-text-field"
                                                                   type="text" value="">
                                                            <span class="help-inline"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group" id="cronDiv">
                                                        <label class="control-label">执行时间</label>

                                                        <div class="controls">
                                                            <input id="triggers[0].expression"
                                                                   name="triggers[0].expression"
                                                                   class="ember-view ember-text-field"
                                                                   type="text" value="">
                                                            <span class="help-inline">0 0/5 * * * ?</span>
                                                            <span class="help-inline hidden" id="cronSpan"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group" id="paramsDiv">
                                                        <label class="control-label">参数键值对</label>

                                                        <div class="controls">
                                                            <input id="params[0].key" name="params[0].key"
                                                                   class="ember-view ember-text-field"
                                                                   type="text" value="">&nbsp;:&nbsp;<input
                                                                id="params[0].value" name="params[0].value"
                                                                class="ember-view ember-text-field"
                                                                type="text" value="">
                                                            <input type="button" class="btn single-btn-group add-button"
                                                                   id="addParam" value="+">

                                                            </input>
                                                        </div>
                                                    </div>
                                                    <div class="control-group" id="pluginDiv">
                                                        <label class="control-label">插件上传</label>

                                                        <div class="controls">
                                                            <input id="file0" name="file" type="file"
                                                                   class="ember-view">
                                                            <span class="help-inline" id="pluginSpan"></span>
                                                        </div>
                                                    </div>

                                                    <div class="control-group" id="pluginPathDiv">
                                                        <label class="control-label">插件类路径</label>

                                                        <div class="controls">
                                                            <input id="pluginPath" name="pluginPath"
                                                                   class="ember-view ember-text-field"
                                                                   type="text" value="">
                                                            <span class="help-inline" id="pluginPathSpan"></span>
                                                        </div>
                                                    </div>

                                                    <div class="control-group" id="filesDiv">
                                                        <label class="control-label">依赖库上传</label>

                                                        <div class="controls">
                                                            <input id="file1" name="file" type="file"
                                                                   class="default">
                                                            <input type="button" class="btn single-btn-group add-button"
                                                                   id="addFile" value="+">
                                                        </div>
                                                    </div>
                                                    <div class="control-group">
                                                        <label class="control-label">有状态</label>

                                                        <div class="controls">
                                                            <input id="statefull"  name="statefull"
                                                                   class="ember-view ember-checkbox"
                                                                   type="checkbox">
                                                            <span class="help-inline"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group">
                                                        <label class="control-label">立即执行</label>

                                                        <div class="controls">
                                                            <input id="triggers[0].instant" name="triggers[0].instant"
                                                                   class="ember-view ember-checkbox"
                                                                   type="checkbox">
                                                            <span class="help-inline"></span>
                                                        </div>
                                                    </div>
                                                    <div class="control-group">
                                                        <div class="controls">
                                                            <button type="reset" class="btn"
                                                                    data-ember-action="3105"><span
                                                                    id="3105">取消</span></button>
                                                            <button type="button" class="btn btn-primary"
                                                                    data-ember-action="3107"  onclick="submitForm()"
                                                                    ><span
                                                                    >保存</span></button>
                                                        </div>
                                                    </div>
                                                </form>
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