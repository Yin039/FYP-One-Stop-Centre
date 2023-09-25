<%-- 
    Document   : stuRubric
    Created on : May 20, 2023, 4:51:37 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Student</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String component = null;
    %>
    <script>
        window.onload = function () {
        <%
            if (request.getParameter("component") != null) {
                component = request.getParameter("component");
            } else {
                component = "All";
            }
        %>
        }
    </script>
    <%
        user e = (user) session.getAttribute("login");
        user user = (user) userDao.getUserByID(e.getUserID());

        List<assessment> assessComp = assessmentDao.getAssessCompByCourseName(user.getCrsName());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div>
                    <h2>Assessment Rubric (<%=user.getCrsName()%>)</h2>
                </div>
                <div class="text-end">
                    <div class="mt-2">
                        <select class="form-select lightBlue border-dark" name="component" onchange="window.location = 'stuRubric.jsp?component=' + this.value">
                            <option value="<%=component%>" selected style="display:none;"><%=component%></option>
                            <option value="All">All</option>
                            <%for (assessment comp : assessComp) {%>
                            <option value="<%=comp.getAssessComponent()%>"><%=comp.getAssessComponent()%></option>
                            <%}%>
                        </select>
                    </div>
                </div>
            </div>

            <%
                if (component.equals("All")) {
                    for (assessment comp : assessComp) {
                        List<assessment> criteria = assessmentDao.getCriteriaByAssessID(comp.getAssessID());
            %>
            <div class="border p-2 my-1">
                <div class="row">
                    <div class="col">
                        <h4><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</h4>
                    </div>
                    <%if (comp.getAssessStartDate() != null) {%>
                    <div class="col text-end">
                        <h5><%=comp.getAssessStartDate() + " to " + comp.getAssessEndDate()%></h5>
                    </div>
                    <%}%>
                </div>

                <table class="table table-hover">
                    <%for (assessment cri : criteria) {
                            List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                    %>
                    <thead>
                        <tr style="background-color: <%=assessment.colorCode(cri.getPlo())%>">
                            <th><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</th>
                            <th><%=cri.getCriteriaPercentage()%>%</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for (assessment sub : subCriteria) {
                                List<assessment> gradingScale = assessmentDao.getGradingScaleBySubCriID(sub.getSubCriteriaID());
                        %>
                        <tr>
                            <td><span><%=sub.getSubCriteria()%></span>
                                <%for (assessment scale : gradingScale) {%>
                                <h6 class="mx-3 mt-1"><%=scale.getGradingScale()%> - <%=scale.getScaleDesc()%></h6>
                                <%}%>
                            </td>
                            <td></td>
                        </tr>
                        <%}
                            }%>
                    </tbody>
                </table>
            </div>
            <%
                }
            } else {
                assessment comp = assessmentDao.getAssessCompByCourseComp(user.getCrsName(), component);
                List<assessment> criteria = assessmentDao.getCriteriaByAssessID(comp.getAssessID());
            %>
            <div class="border p-2 my-1">
                <div class="row">
                    <div class="col">
                        <h4><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</h4>
                    </div>
                    <%if (comp.getAssessStartDate() != null) {%>
                    <div class="col text-end">
                        <h5><%=comp.getAssessStartDate() + " to " + comp.getAssessEndDate()%></h5>
                    </div>
                    <%}%>
                </div>

                <table class="table table-hover">
                    <%for (assessment cri : criteria) {
                            List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                    %>
                    <thead>
                        <tr style="background-color: <%=assessment.colorCode(cri.getPlo())%>">
                            <th><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</th>
                            <th><%=cri.getCriteriaPercentage()%>%</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for (assessment sub : subCriteria) {
                                List<assessment> gradingScale = assessmentDao.getGradingScaleBySubCriID(sub.getSubCriteriaID());
                        %>
                        <tr>
                            <td><span><%=sub.getSubCriteria()%></span>
                                <%for (assessment scale : gradingScale) {%>
                                <h6 class="mx-3 mt-1"><%=scale.getGradingScale()%> - <%=scale.getScaleDesc()%></h6>
                                <%}%>
                            </td>
                            <td></td>
                        </tr>
                        <%}
                            }%>
                    </tbody>
                </table>
            </div>
            <%
                }%>
        </div>
    </body>
</html>