<%-- 
    Document   : coEvaluation.jsp
    Created on : Jun 21, 2023, 2:30:08 AM
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
        List<assessment> assessComp = assessmentDao.getAssessCompByCourseName(courseName);

        List<evaluation> stuList = null;
        String search = request.getParameter("search");

        if (search == null) {
            stuList = assessmentDao.getEvaluationListByCrsName(courseName);
        } else {
            stuList = assessmentDao.searchEvaluateListByGrade(search, courseName);
        }

        String[] grade = {"A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"};
        int[] stuNum = new int[grade.length];
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between">
                <div class="section-title">
                    <h2 class="text-start">Student's Evaluation (<%=courseName%>)</h2>
                    <div class="ms-2 col-3">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coEvaluation.jsp?courseName=' + this.value">
                            <option value="<%=courseName%>" selected style="display:none;"><%=courseName%></option>
                            <option value="FYP I">FYP I</option>
                            <option value="FYP II">FYP II</option>
                        </select>
                    </div>
                </div>
                <div class="enroll-con d-flex justify-content-between align-items-center">
                    <form method="post">
                        <div class="input-group">
                            <input type="text" name="search" class="form-control" placeholder="Search By Grade"/>
                            <input type="submit" value="Search" class="btn btn-primary"/>
                        </div>
                    </form>
                    <div class="ms-2">
                        <a href="AssessmentServlet?action=EVALUATE&courseName=<%=courseName%>"><button class="btn btn-primary addBtn">Evaluate</button></a>
                    </div>
                </div>            
            </div>

            <table class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                            <%for (assessment comp : assessComp) {%>
                        <th  class="text-center"><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</th>
                            <%}%>
                        <th class="text-center">Total Score</th>
                        <th class="text-center">Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (evaluation stu : stuList) {
                            for (int j = 0; j < grade.length; j++) {
                                if (stu.getGrade().equals(grade[j])) {
                                    stuNum[j] += 1;
                                }
                            }
                    %>
                    <tr>
                        <td><%=stu.getMatricNo()%></td>
                        <%for (assessment comp : assessComp) {
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

                        <td class="text-center"><%=stu.getTotalMark()%>%</td>
                        <td class="text-center"><%=stu.getGrade()%></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>

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
                            text: "Number of Students By Grade (<%out.print(courseName);%>)"
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
