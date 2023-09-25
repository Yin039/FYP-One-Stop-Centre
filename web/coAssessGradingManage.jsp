<%-- 
    Document   : coAssessGradingManage
    Created on : May 10, 2023, 12:25:55 AM
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

        int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID"));
        assessment subCriteria = assessmentDao.getSubCriteriaByID(subCriteriaID);
        assessment criteria = assessmentDao.getAssessCriteriaByID(subCriteria.getCriteriaID());
        assessment assess = assessmentDao.getAssessCompByID(criteria.getAssessID());
        assessment clo = assessmentDao.getCloPloByID(criteria.getCloploID());
        assessment plo = assessmentDao.getPloByID(clo.getPloID());

        List<assessment> gradingScale = assessmentDao.getGradingScaleBySubCriID(subCriteriaID);

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        } else if (request.getParameter("count") == null && gradingScale.size() == 0) {
            i = 5;
        }
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">ADD Grading Scale</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATEGRADESCALE" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Component(<%=assess.getCourseName()%>)</label>
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
                    </div>

                    <input type="hidden" name="subCriteriaID" value="<%=subCriteriaID%>">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Sub-Criteria</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="subCriteria" value="<%=subCriteria.getSubCriteria()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>

                        <input type="hidden" name="subCriteriaID" value="<%=subCriteriaID%>">
                    </div>

                    <div class="row mb-3">
                        <h4 class="text-center">Grading Scale</h4>
                        <div class="row justify-content-center">
                            <%for (assessment scale : gradingScale) {
                                    k++;
                            %>
                            <div class="row align-items-center justify-content-center">
                                <div class="col-3">
                                    <label>Scale Grading</label>
                                    <div class="input-group">
                                        <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                        <input type="number" class="form-control" name="oldGrading<%=k%>" value="<%=scale.getGradingScale()%>" required/>
                                    </div>
                                </div>
                                <div class="col-2"></div>
                                <div class="col-1 text-end">
                                    <a href='AssessmentServlet?action=DELETESCALE&scaleID=<%=scale.getScaleID()%>&subCriteriaID=<%=subCriteriaID%>&courseName=<%=assess.getCourseName()%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>
                            <div class="row align-items-center justify-content-center">
                                <div class="col-6">
                                    <label>Description</label>
                                    <div class="input-group">
                                        <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                        <textarea class="form-control" rows="3" name="oldDesc<%=k%>"><%=scale.getScaleDesc()%></textarea>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="scaleID<%=k%>" value="<%=scale.getScaleID()%>">
                            <%}for (int j = 0; j < i; j++) {%>

                            <div class="row align-items-center justify-content-center">
                                <div class="col-3">
                                    <label>Scale Grading</label>
                                    <div class="input-group">
                                        <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                        <input type="number" class="form-control" name="scaleGrading<%=j%>"  min="0" max="100" value="<%=k + j%>"/>
                                    </div>
                                </div>
                                <div class="col-2"></div>
                                <div class="col-1 text-end">
                                    <a href='coAssessGradingManage.jsp?count=<%=i - 1%>&subCriteriaID=<%=subCriteriaID%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>
                            <div class="row align-items-center justify-content-center">
                                <div class="col-6">
                                    <label>Description</label>
                                    <div class="input-group">
                                        <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                        <textarea class="form-control" rows="3" name="scaleDesc<%=j%>" placeholder="Example: 0 MF"></textarea>
                                    </div>
                                </div>
                            </div>
                            <%}%>

                            <div class="row justify-content-center">
                                <div class="col-4"></div>
                                <div class="col-2 text-end">
                                    <a href='coAssessGradingManage.jsp?count=<%=i + 1%>&subCriteriaID=<%=subCriteriaID%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="courseName" value="<%=assess.getCourseName()%>">
                    <input type="hidden" name="oldScaleCount" value="<%=k%>">
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
