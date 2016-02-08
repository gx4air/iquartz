//brancheB_test_1
<%@ page import="java.util.Map" %>
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
    <script type="text/javascript">
        <%
            String jobName = request.getParameter("jobName");
            Map<String, String> map = (Map<String, String>)session.getAttribute("info");

            String result = "WARNING";
            String info = "该页面只供跳转，请不要直接访问该页面";
            String ext = "";

            if(map!=null){
                result = map.get("result");
                info = map.get("info");
                if(map.get("ext")!=null){
                    ext = map.get("info");
                }

            }

            session.removeAttribute("info");

        %>
        var jobName = '<%=jobName%>';
        var info = '<%=info%>';
        var result = '<%=result%>'
        var ext = '<%=ext%>'
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

            var infoDiv = $('#infoDiv');
            if(result=='OK'){
                infoDiv.addClass('alert alert-success');
            }
            if(result=='ERROR'){
                infoDiv.addClass('alert alert-error');
            }
            if(result=='WARNING'){
                infoDiv.addClass('alert alert-alert-block');
            }
            infoDiv.html('<strong>'+result+'</strong>&nbsp;'+info+'<b>'+ext);

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
                                            <div id="infoDiv">
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