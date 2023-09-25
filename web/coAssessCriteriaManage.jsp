<%-- 
    Document   : coAssessCriteriaManage
    Created on : May 10, 2023, 12:58:07 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>

    <%
        int i = 0;
        int k = 0;

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        }

        int criteriaID = Integer.parseInt(request.getParameter("criteriaID"));
        assessment criteria = assessmentDao.getAssessCriteriaByID(criteriaID);
        assessment assess = assessmentDao.getAssessCompByID(criteria.getAssessID());
        assessment clo = assessmentDao.getCloPloByID(criteria.getCloploID());
        assessment plo = assessmentDao.getPloByID(clo.getPloID());

        List<assessment> subCri = assessmentDao.getSubCriteriaByCriteriaID(criteriaID);
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">UPDATE ASSESSMENT CRITERIA</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATESUBCRI" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Component (<%=assess.getCourseName()%>)</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="assessComp" value="<%=assess.getAssessComponent()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Percentage</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="number" class="form-control" name="assessPercentage" value="<%=assess.getCompPercentage()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>CLO/PLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="cloplo" value="<%=clo.getClo()%>-<%=plo.getPlo()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3"></div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Criteria</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="assessCriteria"  value="<%=criteria.getAssessCriteria()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Percentage</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="number" class="form-control" name="criteriaPercentage"  value="<%=criteria.getCriteriaPercentage()%>" readonly/>
                            </div>
                        </div>
                        <input type="hidden" name="criteriaID" value="<%=criteriaID%>">
                    </div>

                    <div class="row mb-3">
                        <h4 class="text-center mt-5">Assessment Sub-Criteria</h4>
                        <%for (assessment subCriteria : subCri) {
                                k++;
                        %>
                        <div class="row justify-content-center align-items-center">
                            <div class="col-5">
                                <input type="text" class="form-control" name="oldSubCriteria<%=k%>" value="<%=subCriteria.getSubCriteria()%>" required/>

                            </div>
                            <div class="col-1">
                                <a href='AssessmentServlet?action=DELETESUBCRI&subCriteriaID=<%=subCriteria.getSubCriteriaID()%>&criteriaID=<%=criteriaID%>&courseName=<%=assess.getCourseName()%>'><i class="bi bi-trash-fill text-danger"></i></a>
                            </div>

                            <input type="hidden" name="subCriteriaID<%=k%>" value="<%=subCriteria.getSubCriteriaID()%>">
                        </div>
                        <%}
                            if (request.getParameter("count") != null) {
                                i = Integer.parseInt(request.getParameter("count"));
                                for (int j = 0; j < i; j++) {
                        %>
                        <div class="row justify-content-center align-items-center">
                            <div class="col-5">
                                <input type="text" class="form-control" name="subCriteria<%=j%>" placeholder="Example: Presentation Skill"/>

                            </div>
                            <div class="col-1">
                                <a href='coAssessCriteriaManage.jsp?count=<%=i - 1%>&criteriaID=<%=criteriaID%>'><i class="bi bi-trash-fill text-danger"></i></a>
                            </div>
                        </div>
                        <%}
                            }%>

                        <div class="row justify-content-center">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='coAssessCriteriaManage.jsp?count=<%=i + 1%>&criteriaID=<%=criteriaID%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="courseName" value="<%=assess.getCourseName()%>">
                    <input type="hidden" name="oldSubCriCount" value="<%=k%>">
                    <input type="hidden" name="count" value="<%=i%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coAssessRubric.jsp?status=<%=assess.getCourseName()%>" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

