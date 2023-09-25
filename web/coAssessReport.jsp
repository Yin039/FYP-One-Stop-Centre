<%-- 
    Document   : coAssessReport
    Created on : Jun 21, 2023, 7:37:27 PM
    Author     : user
--%>

<%@page import="java.util.*"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
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
        String courseName = null;
    %>
    <script>
        window.onload = function () {
        <%
            if (request.getParameter("courseName") != null) {
                courseName = request.getParameter("courseName");
            } else {
                courseName = "FYP I";
            }
        %>
        }
    </script>
    <%
        List<user> student = userDao.getStudentByCrsName(courseName);
        List<assessment> plo = assessmentDao.getSelectedPlo();

        int i = 0, k = 0, totalStu = 0;
        double[] totalPloMark = new double[plo.size()];
        int[] stuNum = new int[plo.size()];
        String[] ploName = new String[plo.size()];
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div class="section-title">
                    <h2 class="text-start">PLO Report (<%=courseName%>)</h2>

                    <div class="ms-2 col-4">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coAssessReport.jsp?courseName=' + this.value">
                            <option value="<%=courseName%>" selected style="display:none;"><%=courseName%></option>
                            <option value="FYP I">FYP I</option>
                            <option value="FYP II">FYP II</option>
                        </select>
                    </div>
                </div>     
            </div>

            <form action="AssessmentServlet?action=EXPORTPLO" method="post">
                <table class="table table-hover table-striped">
                    <thead>
                    <th>Matric No.</th>
                        <%for (assessment p : plo) {
                                totalPloMark[i] = assessmentDao.getTotalPloMarkByPlo(courseName, p.getPloID());
                                ploName[i] = p.getPlo();
                        %>
                    <th class="text-center"><%=p.getPlo()%> (<%=totalPloMark[i]%>%)</th>
                    <input type="hidden" name="ploID<%=i%>" value="<%=p.getPloID()%>">
                    <%
                            i++;
                        }%>
                    </thead>
                    <tbody>
                        <%for (user stu : student) {
                                k++;
                                totalStu += 1;
                                int y = 0;

                                List<evaluation> stuPloMark = assessmentDao.getStuPLOMarkByMatricNo(stu.getMatricNo());
                        %>
                        <tr>
                            <td><%=stu.getMatricNo()%></td>
                    <input type="hidden" name="matricNo<%=k%>" value="<%=stu.getMatricNo()%>">
                    <%
                        int x = 0;
                        for (evaluation ploMark : stuPloMark) {
                            x++;
                            List<evaluation> stuPresentPloMark = assessmentDao.getStuPresentPLOMarkByMatricNo(stu.getMatricNo());

                            for (evaluation presentPlo : stuPresentPloMark) {
                                if (presentPlo.getPloID() == ploMark.getPloID()) {
                                    Double newPloMark = ploMark.getStuPLOMark() + presentPlo.getStuPLOMark();
                                    ploMark.setStuPLOMark(newPloMark);
                                }
                            }

                            if (((ploMark.getStuPLOMark() / totalPloMark[y]) * 100) >= 50) {
                                stuNum[y] += 1;
                            }

                    %>
                    <td class="text-center"><%=String.format("%.2f", ploMark.getStuPLOMark())%></td>
                    <input type="hidden" name="stuPLOMark<%=x%><%=k%>" value="<%=ploMark.getStuPLOMark()%>">                    
                    <%
                            y++;
                        }%>
                    </tr>
                    <%}%>
                    </tbody>
                </table>

                <input type="hidden" name="count" value="<%=i%>">
                <input type="hidden" name="stuCount" value="<%=k%>">
                <input type="hidden" name="courseName" value="<%=courseName%>">

                <div class="enroll-con d-flex justify-content-end align-items-center">
                    <button type="submit" value="Submit" class="btn btn-primary">Export Excel</button>
                </div>
            </form>       

            <%
                Gson gsonObj = new Gson();
                Map<Object, Object> map = null;
                List<Map<Object, Object>> list = new ArrayList<>();
                String dataPoints = null;

                String xVal;
                double yVal;
                for (int j = 0; j < totalPloMark.length; j++) {
                    xVal = ploName[j];
                    yVal = stuNum[j];

                    map = new HashMap<>();
                    map.put("label", xVal);
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
                            text: "Number of Students Score >= 50% By PLO （<%out.print(courseName);%>）"
                        },
                        axisY: {
                            title: "Number of Student",
                            minimum: 0,
                            maximum: <%=totalStu%>,
                            valueFormatString: "#",
                            interval: 1
                        },
                        axisX: {
                            title: "PLO"
                        },
                        data: [{
                                type: "column",
                                dataPoints: <%out.print(dataPoints);%>
                            }]
                    });
                    chart.render();
                <%}%>
                }
            </script>
            <div id="chartContainer" style=" width: 100%; height:420px; padding-top:10px;">
            </div>
        </div>
        <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    </body>
</html>
