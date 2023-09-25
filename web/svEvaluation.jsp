<%-- 
    Document   : svEvaluation
    Created on : Jun 23, 2023, 3:43:07 PM
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
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<assessment> assessCompI = assessmentDao.getAssessCompByCourseName("FYP I");
        List<assessment> assessCompII = assessmentDao.getAssessCompByCourseName("FYP II");

        List<user> stuList = userDao.getStudentByGroup(e.getGroupNo());

        String[] grade = {"A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"};
        int[] stuNum = new int[grade.length];
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between">
                <div class="section-title">
                    <h2 class="text-start">List of Student's Evaluation</h2>
                </div>       
            </div>

            <div class="p-2">
                <h4 class="fw-bold">FYP I</h4>
                <div class="row border border-black lightYellow">
                    <table class="table table-hover table-striped">
                        <thead>
                            <tr>
                                <th>Matric No.</th>
                                    <%for (assessment comp : assessCompI) {%>
                                <th  class="text-center"><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</th>
                                    <%}%>
                                <th class="text-center">Total Score</th>
                                <th class="text-center">Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%for (user stu : stuList) {
                                    if (stu.getCrsName().equals("FYP I")) {
                                        evaluation evaluate = assessmentDao.getEvaluationByMatricNo(stu.getMatricNo());

                                        for (int j = 0; j < grade.length; j++) {
                                            if (evaluate.getGrade().equals(grade[j])) {
                                                stuNum[j] += 1;
                                            }
                                        }
                            %>
                            <tr>
                                <td><%=stu.getMatricNo()%></td>
                                <%for (assessment comp : assessCompI) {
                                        evaluation stuAssess = null;

                                        if (comp.getAssessComponent().equals("Presentation")) {
                                            stuAssess = assessmentDao.getStuPresentAssessAVGByMatricNoID(stu.getMatricNo());
                                        } else {
                                            stuAssess = assessmentDao.getStuAssessmentByMatricNoID(stu.getMatricNo(), comp.getAssessID());
                                        }

                                %>
                                <%if (stuAssess.getStuAssessID() == 0) {%>
                                <td></td>
                                <%} else {%>
                                <td class="text-center"><%=stuAssess.getStuAssessCompMark()%>%</td>
                                <%}
                                    }%>

                                <td class="text-center"><%=evaluate.getTotalMark()%>%</td>
                                <td class="text-center"><%=evaluate.getGrade()%></td>
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
                            <tr>
                                <th>Matric No.</th>
                                    <%for (assessment comp : assessCompII) {%>
                                <th  class="text-center"><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</th>
                                    <%}%>
                                <th class="text-center">Total Score</th>
                                <th class="text-center">Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%for (user stu : stuList) {
                                    if (stu.getCrsName().equals("FYP II")) {
                                        evaluation evaluate = assessmentDao.getEvaluationByMatricNo(stu.getMatricNo());

                                        for (int j = 0; j < grade.length; j++) {
                                            if (evaluate.getGrade().equals(grade[j])) {
                                                stuNum[j] += 1;
                                            }
                                        }
                            %>
                            <tr>
                                <td><%=stu.getMatricNo()%></td>
                                <%for (assessment comp : assessCompII) {
                                        evaluation stuAssess = null;

                                        if (comp.getAssessComponent().equals("Presentation")) {
                                            stuAssess = assessmentDao.getStuPresentAssessAVGByMatricNoID(stu.getMatricNo());
                                        } else {
                                            stuAssess = assessmentDao.getStuAssessmentByMatricNoID(stu.getMatricNo(), comp.getAssessID());
                                        }

                                %>
                                <%if (stuAssess.getStuAssessID() == 0) {%>
                                <td></td>
                                <%} else {%>
                                <td class="text-center"><%=stuAssess.getStuAssessCompMark()%>%</td>
                                <%}
                                    }%>

                                <td class="text-center"><%=evaluate.getTotalMark()%>%</td>
                                <td class="text-center"><%=evaluate.getGrade()%></td>
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

                for (int j = 0; j < grade.length; j++) {
                    xVal = grade[j];
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
                            text: "Number of Students By Grade"
                        },
                        axisY: {
                            title: "Number of Student",
                            minimum: 0,
                            maximum: <%=stuList.size()%>,
                            valueFormatString: "#",
                            interval: 1
                        },
                        axisX: {
                            title: "Grade"
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
            <div class="text-center" id="chartContainer" style=" width: 100%; height:420px; padding-top:10px;">
            </div>
        </div>
        <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    </body>
</html>

