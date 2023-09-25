<%-- 
    Document   : svRubric.jsp
    Created on : May 10, 2023, 4:19:05 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String status = null;
        String component = null;
    %>
    <script>
        window.onload = function () {
        <%
            if (request.getParameter("status") != null) {
                status = request.getParameter("status");
            } else {
                status = "FYP I";
            }

            if (request.getParameter("component") != null) {
                component = request.getParameter("component");
            } else {
                component = "All";
            }
        %>
        }
    </script>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="text-center">Assessment Rubric (<%=status%>)</h2>

                    <div class="col-3 mt-2">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'svRubric.jsp?component=<%=component%>&status=' + this.value">
                            <option value="<%=status%>" selected style="display:none;"><%=status%></option>
                            <option value="FYP I">FYP I</option>
                            <option value="FYP II">FYP II</option>
                        </select>
                    </div>
                </div>
                <div class="text-end">
                    <div class="mt-2">
                        <select class="form-select lightBlue border-dark" name="component" onchange="window.location = 'svRubric.jsp?status=<%=status%>&component=' + this.value">
                            <option value="<%=component%>" selected style="display:none;"><%=component%></option>
                            <option value="All">All</option>
                            <%
                                List<assessment> assessComp = assessmentDao.getAssessCompByCourseName(status);
                                for (assessment comp : assessComp) {
                            %>
                            <option value="<%=comp.getAssessComponent()%>"><%=comp.getAssessComponent()%></option>
                            <%}%>
                        </select>
                    </div>
                </div>
            </div>


            <%if (component.equals("All")) {
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
            <%}
            } else {
                assessment comp = assessmentDao.getAssessCompByCourseComp(status, component);
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