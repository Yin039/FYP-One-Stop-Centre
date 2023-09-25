<%-- 
    Document   : svAssessReport
    Created on : Jun 23, 2023, 3:43:18 PM
    Author     : TEOH YI YIN
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
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<user> student = userDao.getStudentByGroup(e.getGroupNo());
        List<assessment> plo = assessmentDao.getSelectedPlo();

        int i = 0, totalStu = 0;
        double[] totalPloMark = new double[plo.size()];
        int[] stuNum = new int[plo.size()];
        String[] ploName = new String[plo.size()];
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div class="section-title">
                    <h2 class="text-start">PLO Report</h2>
                </div>     
            </div>

            <div class="p-2">
                <h4 class="fw-bold">FYP I</h4>
                <div class="row border border-black lightYellow">
                    <table class="table table-hover table-striped">
                        <thead>
                        <th>Matric No.</th>
                            <%for (assessment p : plo) {
                                    totalPloMark[i] = assessmentDao.getTotalPloMarkByPlo("FYP I", p.getPloID());
                                    ploName[i] = p.getPlo();
                            %>
                        <th class="text-center"><%=p.getPlo()%> (<%=totalPloMark[i]%>%)</th>
                            <%
                                    i++;
                                }%>
                        </thead>
                        <tbody>
                            <%for (user stu : student) {
                                    if (stu.getCrsName().equals("FYP I")) {
                                        totalStu += 1;
                                        int y = 0;

                                        List<evaluation> stuPloMark = assessmentDao.getStuPLOMarkByMatricNo(stu.getMatricNo());
                            %>
                            <tr>
                                <td><%=stu.getMatricNo()%></td>
                                <%
                                    for (evaluation ploMark : stuPloMark) {
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
                                <%y++;
                                    }%>
                            </tr>
                            <%}
                                }%>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="p-2">
                <h4 class="fw-bold">FYP II</h4>
                <div class="row border border-black lightBlue">
                    <table class="table table-hover table-striped">
                        <thead>
                        <th>Matric No.</th>
                            <%
                                i = 0;
                                for (assessment p : plo) {
                                    totalPloMark[i] = assessmentDao.getTotalPloMarkByPlo("FYP II", p.getPloID());
                                    ploName[i] = p.getPlo();
                            %>
                        <th class="text-center"><%=p.getPlo()%> (<%=totalPloMark[i]%>%)</th>
                            <%
                                    i++;
                                }%>
                        </thead>
                        <tbody>
                            <%for (user stu : student) {
                                    if (stu.getCrsName().equals("FYP II")) {
                                        totalStu += 1;
                                        int y = 0;

                                        List<evaluation> stuPloMark = assessmentDao.getStuPLOMarkByMatricNo(stu.getMatricNo());
                            %>
                            <tr>
                                <td><%=stu.getMatricNo()%></td>
                                <%
                                    for (evaluation ploMark : stuPloMark) {
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
                                <%y++;
                                    }%>
                            </tr>
                            <%}
                                }%>
                        </tbody>
                    </table>
                </div>
            </div>

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
                            text: "Number of Students Score >= 50% By PLO"
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

