<%-- 
    Document   : coProjReport
    Created on : Jun 22, 2023, 3:51:58 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.*"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.JsonObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        List<project> projectProgress = projectDao.getProjectList();

        int[] percentage = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
        int[] stuNum = new int[percentage.length];

        Gson gsonObj = new Gson();
        Map<Object, Object> map = null;
        List<Map<Object, Object>> list = new ArrayList<>();
        String dataPoints = null;

        double xVal;
        double yVal;

        for (project progress : projectProgress) {
            double stuProgress = progress.getProjectProgress();

            for (int j = 0; j < percentage.length-1; j++) {
                if (stuProgress >= percentage[j] && stuProgress < percentage[j + 1]) {
                    stuNum[j] += 1;
                }
            }
            
            if(stuProgress == 100){
                stuNum[10] += 1;
            }
        }

        for (int j = 0; j < percentage.length; j++) {
            xVal = percentage[j];
            yVal = stuNum[j];

            map = new HashMap<>();
            map.put("x", xVal);
            map.put("y", yVal);
            list.add(map);
            dataPoints = gsonObj.toJson(list);
        }
    %>
    <script type="text/javascript">
        window.onload = function () {
        <% if (dataPoints != null) {%>
            var chart = new CanvasJS.Chart("chartContainer", {
                animationEnabled: true,
                exportEnabled: true,
                title: {
                    fontFamily: "Arial",
                    text: "Student's Project Progress"
                },
                axisY: {
                    title: "Number of Student",
                    minimum: 0,
                    maximum: <%=projectProgress.size() + 1%>
                },
                axisX: {
                    title: "Project Progress (%)",
                    minimum: 0,
                    maximum: 100
                },
                data: [{
                        type: "line",
                        dataPoints: <%out.print(dataPoints);%>
                    }]
            });
            chart.render();
        <%}%>
        }
    </script>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="text-center" id="chartContainer" style=" width: 100%; height:420px; padding-top:10px;">
                <div class="position1">
                    <h1>No Record Project Progress</h1>
                </div>
            </div>
            <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    </body>
</body>
</html>
