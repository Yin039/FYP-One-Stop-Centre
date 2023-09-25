<%-- 
    Document   : coAssessCriteria
    Created on : May 9, 2023, 1:26:45 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String status = null;
        String component = null;
        int i = 0;
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
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${updateError}${deleteError}</h6>
            </div>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div>
                    <div class="section-title">
                        <h2 class="text-start">Assessment Rubric (<%=status%>)</h2>
                    </div>
                    <div class="col-3 mt-2">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coAssessRubric.jsp?component=<%=component%>&status=' + this.value">
                            <option value="<%=status%>" selected style="display:none;"><%=status%></option>
                            <option value="FYP I">FYP I</option>
                            <option value="FYP II">FYP II</option>
                        </select>
                    </div>
                </div>
                <div class="text-end">
                    <div class="mt-2">
                        <select class="form-select lightBlue border-dark" name="component" onchange="window.location = 'coAssessRubric.jsp?status=<%=status%>&component=' + this.value">
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
                    <a href="coAssessCompManage.jsp?action=Add&courseName=<%=status%>"><button class="btn btn-primary addBtn">Add Component</button></a>
                </div>
            </div>


            <%if (component.equals("All")) {
                    for (assessment comp : assessComp) {
                        List<assessment> criteria = assessmentDao.getCriteriaByAssessID(comp.getAssessID());
            %>
            <div class="border p-2 my-1">
                <div class="row">
                    <div class="col-1 text-center">
                        <a href="coAssessCompManage.jsp?action=Update&courseName=<%=status%>&assessID=<%=comp.getAssessID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a>
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'AssessmentServlet?action=DELETECOMP&assessID=<%=comp.getAssessID()%>&courseName=<%=comp.getCourseName()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </div>
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
                            i++;
                            List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                    %>
                    <thead>
                        <tr style="background-color: <%=assessment.colorCode(cri.getPlo())%>">
                            <th><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</th>
                            <th><%=cri.getCriteriaPercentage()%>%</th>
                            <td><a href="coAssessCriteriaManage.jsp?criteriaID=<%=cri.getCriteriaID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                            <td>
                                <a onclick="if (confirm('Are you sure you want to delete?'))
                                            href = 'AssessmentServlet?action=DELETECRI&criteriaID=<%=cri.getCriteriaID()%>&courseName=<%=comp.getCourseName()%>';
                                        else
                                            return false;">
                                    <i class="bi bi-trash-fill text-danger"></i>
                                </a>
                            </td>
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
                            <td><a href="coAssessGradingManage.jsp?subCriteriaID=<%=sub.getSubCriteriaID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                            <td>
                                <a onclick="if (confirm('Are you sure you want to delete?'))
                                            href = 'AssessmentServlet?action=DELETESUBCRI&subCriteriaID=<%=sub.getSubCriteriaID()%>&courseName=<%=comp.getCourseName()%>';
                                        else
                                            return false;">
                                    <i class="bi bi-trash-fill text-danger"></i>
                                </a>
                            </td>
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
                    <div class="col-1 text-center">
                        <a href="coAssessCompManage.jsp?action=Update&courseName=<%=status%>&assessID=<%=comp.getAssessID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a>
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'AssessmentServlet?action=DELETECOMP&assessID=<%=comp.getAssessID()%>&courseName=<%=comp.getCourseName()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </div>
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
                            i++;
                            List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                    %>
                    <thead>
                        <tr style="background-color: <%=assessment.colorCode(cri.getPlo())%>">
                            <th><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</th>
                            <th><%=cri.getCriteriaPercentage()%>%</th>
                            <td><a href="coAssessCriteriaManage.jsp?criteriaID=<%=cri.getCriteriaID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                            <td>
                                <a onclick="if (confirm('Are you sure you want to delete?'))
                                            href = 'AssessmentServlet?action=DELETECRI&criteriaID=<%=cri.getCriteriaID()%>&courseName=<%=comp.getCourseName()%>';
                                        else
                                            return false;">
                                    <i class="bi bi-trash-fill text-danger"></i>
                                </a>
                            </td>
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
                            <td><a href="coAssessGradingManage.jsp?subCriteriaID=<%=sub.getSubCriteriaID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                            <td>
                                <a onclick="if (confirm('Are you sure you want to delete?'))
                                            href = 'AssessmentServlet?action=DELETESUBCRI&subCriteriaID=<%=sub.getSubCriteriaID()%>&courseName=<%=comp.getCourseName()%>';
                                        else
                                            return false;">
                                    <i class="bi bi-trash-fill text-danger"></i>
                                </a>
                            </td>
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
