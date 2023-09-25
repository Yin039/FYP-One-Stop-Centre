<%-- 
    Document   : coAssessCompManage
    Created on : May 9, 2023, 1:26:57 AM
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
        String action = request.getParameter("action");
        String courseName = request.getParameter("courseName");

        int i = 1;
        int k = 0;

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        }

        List<assessment> cloplo = assessmentDao.getCloPloByCourseName(courseName);
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Add")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD ASSESSMENT COMPONENT</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=ADDASSESSCOMP" class="row g-4 mt-3" method="post">

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Component</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="assessComp" placeholder="Example: Presentation" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Percentage</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="number" class="form-control" name="assessPercentage" step=".01" min="0" max="100" placeholder="Example: 15.0" required/>
                            </div>
                        </div>

                        <input type="hidden" name="courseName" value="<%=courseName%>">
                    </div>
                    
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Start Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="assessStartDate"/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Assessment End Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="date" class="form-control" id="meetTime" name="assessEndDate"/>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <h4 class="text-center mt-3">Assessment Criteria</h4>
                        <%for (int j = 0; j < i; j++) {%>
                        <div class="mt-3">
                            <div class="row justify-content-center">
                                <div class="col-3">
                                    <select class="form-select" name="cloploID<%=j%>" required>
                                        <%for (assessment LO : cloplo) {
                                                assessment plo = assessmentDao.getPloByID(LO.getPloID());
                                        %>
                                        <option value="<%=LO.getCloploID()%>"><%=LO.getClo()%>-<%=plo.getPlo()%></option>
                                        <%}%>
                                    </select>
                                </div>
                                <div class="col-3"></div>
                            </div>

                            <div class="row justify-content-center  align-items-center">
                                <div class="col-3">
                                    <input type="text" class="form-control" name="assessCriteria<%=j%>" placeholder="Example: Presentation Skill" required/>
                                </div>
                                <div class="col-2">
                                    <input type="number" class="form-control" name="criteriaPercentage<%=j%>" step=".01" min="0" max="100" placeholder="Percentage" required/>
                                </div>
                                <div class="col-1">
                                    <a href='coAssessCompManage.jsp?action=Add&courseName=<%=courseName%>&count=<%=i - 1%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>
                        </div>
                        <%}%>

                        <div class="row justify-content-center">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='coAssessCompManage.jsp?action=Add&courseName=<%=courseName%>&count=<%=i + 1%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="count" value="<%=i%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coAssessRubric.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>

            <%} else if (action.equals("Update")) {
                i = 0;

                int assessID = Integer.parseInt(request.getParameter("assessID"));
                assessment assess = assessmentDao.getAssessCompByID(assessID);

                List<assessment> criteria = assessmentDao.getCriteriaByAssessID(assessID);
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE ASSESSMENT COMPONENT</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATEASSESSCOMP" class="row g-4 mt-3" method="post">

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Component</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="assessComp" value="<%=assess.getAssessComponent()%>"/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Percentage</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="number" class="form-control" name="assessPercentage" step=".01" min="0" max="100" value="<%=assess.getCompPercentage()%>"/>
                            </div>
                        </div>

                        <input type="hidden" name="courseName" value="<%=assess.getCourseName()%>">
                        <input type="hidden" name="assessID" value="<%=assessID%>">
                    </div>
                    
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Assessment Start Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="assessStartDate" value="<%=assess.getAssessStartDate()%>"/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Assessment End Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="date" class="form-control" id="meetTime" name="assessEndDate" value="<%=assess.getAssessEndDate()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <h4 class="text-center mt-3">Assessment Criteria</h4>
                        <%for (assessment cri : criteria) {
                                k++;
                                assessment clo = assessmentDao.getCloPloByID(cri.getCloploID());
                                assessment plo = assessmentDao.getPloByID(clo.getPloID());
                        %>
                        <div class="mt-3">
                            <div class="row justify-content-center">
                                <div class="col-3">
                                    <select class="form-select" name="oldCloPloID<%=k%>" required>
                                        <option value="<%=cri.getCloploID()%>" selected style="display:none;"><%=clo.getClo()%>-<%=plo.getPlo()%></option>
                                        <%for (assessment LO : cloplo) {
                                                plo = assessmentDao.getPloByID(LO.getPloID());
                                        %>
                                        <option value="<%=LO.getCloploID()%>"><%=LO.getClo()%>-<%=plo.getPlo()%></option>
                                        <%}%>
                                    </select>
                                </div>
                                <div class="col-3"></div>
                            </div>

                            <div class="row justify-content-center  align-items-center">
                                <div class="col-3">
                                    <input type="text" class="form-control" name="oldCriteria<%=k%>" value="<%=cri.getAssessCriteria()%>" required/>
                                </div>
                                <div class="col-2">
                                    <input type="number" class="form-control" name="oldPercentage<%=k%>" step=".01" min="0" max="100" value="<%=cri.getCriteriaPercentage()%>" required/>
                                </div>
                                <div class="col-1">
                                    <a href='AssessmentServlet?action=DELETECRI&criteriaID=<%=cri.getCriteriaID()%>&assessID=<%=assessID%>&courseName=<%=courseName%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>

                            <input type="hidden" name="criteriaID<%=k%>" value="<%=cri.getCriteriaID()%>">
                        </div>
                        <%}%>
                        <%if (request.getParameter("count") != null) {
                                i = Integer.parseInt(request.getParameter("count"));
                                for (int j = 0; j < i; j++) {%>
                        <div class="mt-3">
                            <div class="row justify-content-center">
                                <div class="col-3">
                                    <select class="form-select" name="cloploID<%=j%>" required>
                                        <%for (assessment LO : cloplo) {
                                                assessment plo = assessmentDao.getPloByID(LO.getPloID());
                                        %>
                                        <option value="<%=LO.getCloploID()%>"><%=LO.getClo()%>-<%=plo.getPlo()%></option>
                                        <%}%>
                                    </select>
                                </div>
                                <div class="col-3"></div>
                            </div>

                            <div class="row justify-content-center  align-items-center">
                                <div class="col-3">
                                    <input type="text" class="form-control" name="assessCriteria<%=j%>" placeholder="Example: Presentation Skill"/>
                                </div>
                                <div class="col-2">
                                    <input type="number" class="form-control" name="criteriaPercentage<%=j%>" step=".01" min="0" max="100" placeholder="Percentage"/>
                                </div>
                                <div class="col-1">
                                    <a href='coAssessCompManage.jsp?action=Update&courseName=<%=courseName%>&count=<%=i - 1%>&assessID=<%=assessID%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>
                        </div>
                        <%}}%>

                        <div class="row justify-content-center mt-2">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='coAssessCompManage.jsp?action=Update&courseName=<%=courseName%>&count=<%=i + 1%>&assessID=<%=assessID%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="oldCriteriaCount" value="<%=k%>">
                    <input type="hidden" name="count" value="<%=i%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coAssessRubric.jsp?status=<%=courseName%>" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
