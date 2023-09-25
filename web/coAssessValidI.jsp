<%-- 
    Document   : coAssessValidation
    Created on : Jun 15, 2023, 3:23:00 AM
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
        String comp = null;
        String valid = null;
    %>
    <script>
        window.onload = function () {
        <%
            if (request.getParameter("comp") != null) {
                comp = request.getParameter("comp");
            } else {
                comp = "Presentation";
            }

            if (request.getParameter("valid") != null) {
                valid = request.getParameter("valid");
            } else {
                valid = "All";
            }
        %>
        }
    </script>
    <%
        List<assessment> assessComp = assessmentDao.getAssessCompByCourseName("FYP I");
        assessment assess = assessmentDao.getAssessCompByCourseComp("FYP I", comp);
        List<assessment> criteria = assessmentDao.getCriteriaByAssessID(assess.getAssessID());

        List<evaluation> stuCri = null;
        String search = request.getParameter("search");

        if (comp.equals("Presentation")) {
            if (valid.equals("All")) {
                stuCri = assessmentDao.getStuPresentAssessByAssessID(assess.getAssessID());
            } else {
                stuCri = assessmentDao.getStuPresentAssessByValidStatus(assess.getAssessID(), valid);
            }

            if (search != null) {
                stuCri = assessmentDao.searchStuPresentSubCriMark(assess.getAssessID(), search);
            }
        } else {
            if (valid.equals("All")) {
                stuCri = assessmentDao.getStuAssessByAssessID(assess.getAssessID());
            } else {
                stuCri = assessmentDao.getStuAssessByValidStatus(assess.getAssessID(), valid);
            }

            if (search != null) {
                stuCri = assessmentDao.searchStuSubCriMark(assess.getAssessID(), search);
            }
        }
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${validateError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between">
                <div class="section-title">
                    <h2 class="text-start">Assessment Validation - <%=comp%> (FYP I)</h2>
                    <div class="ms-2 col-4">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coAssessValidI.jsp?valid=<%=valid%>&comp=' + this.value">
                            <option value="<%=comp%>" selected style="display:none;"><%=comp%></option>
                            <%for (assessment c : assessComp) {%>
                            <option value="<%=c.getAssessComponent()%>"><%=c.getAssessComponent()%></option>
                            <%}%>
                        </select>
                    </div>
                </div>
                <div class="justify-content-end">
                    <div class="enroll-con d-flex justify-content-end align-items-center me-4">
                        <div>
                            <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coAssessValidI.jsp?comp=<%=comp%>&valid=' + this.value">
                                <option value="<%=valid%>" selected style="display:none;"><%=valid%></option>
                                <option value="All">All</option>
                                <option value="Invalid">Invalid</option>
                                <option value="Valid">Valid</option>
                            </select>
                        </div>
                        <div>
                            <form method="post">
                                <div class="input-group">
                                    <input type="number" name="search" min="0" class="form-control" placeholder="Sub-criteria Score"/>
                                    <input type="submit" value="Search" class="btn btn-primary"/>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="enroll-con d-flex justify-content-end align-items-center">
                        <a href="AssessmentServlet?action=ASSESSVALIDALL&comp=<%=comp%>&courseName=FYP I&assessValid=Valid&valid=<%=valid%>"><button class="btn btn-primary addBtn">Valid All</button></a>
                    </div>
                </div>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                            <%if (comp.equals("Presentation")) {%>
                        <th>Supervisor</th>
                            <%}%>
                            <%for (assessment cri : criteria) {%>
                        <th class="text-center"><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</th>
                            <%}%>
                        <th class="text-center">Total Mark</th>
                        <th colspan="2"></th>
                    </tr>
                </thead>

                <tbody>

                    <%
                        for (evaluation stu : stuCri) {  
                            user sv = null;
                            List<evaluation> stuMark = null;

                            if (comp.equals("Presentation")) {
                                sv = userDao.getSVGroupBySVID(stu.getSvID());
                                stuMark = assessmentDao.getStuPresentCriMarkByMatricNo(stu.getMatricNo(), assess.getAssessID(), stu.getSvID());
                            } else {
                                stuMark = assessmentDao.getStuCriteriaMarkByMatricNo(stu.getMatricNo(), assess.getAssessID());
                            }
                    %>
                    <tr>
                        <td><%=stu.getMatricNo()%></td>

                        <%if (comp.equals("Presentation")) {%>
                        <td><%=sv.getSvName()%></td>
                        <%}%>

                        <%for (evaluation stuCriMark : stuMark) {%>
                        <td class="text-center"><%=stuCriMark.getStuCriteriaMark()%></td>
                        <%}%>

                        <%if (stu.getStuAssessValid().equals("Valid")) {%>
                        <td class="text-center"><%=stu.getStuAssessCompMark()%></td>
                        <%} else {%>
                        <td class="text-center text-danger"><%=stu.getStuAssessCompMark()%></td>
                        <%}%>

                        <td>
                            <div class="form-check">
                                <%if (stu.getStuAssessValid().equals("Valid")) {%>
                                <input class="form-check-input" onchange="window.location = 'AssessmentServlet?action=ASSESSVALID&stuAssessID=<%=stu.getStuAssessID()%>&comp=<%=comp%>&courseName=FYP I&assessValid=Invalid&valid=<%=valid%>'" type="checkbox" Checked>
                                <%} else {%>
                                <input class="form-check-input" onchange="window.location = 'AssessmentServlet?action=ASSESSVALID&stuAssessID=<%=stu.getStuAssessID()%>&comp=<%=comp%>&courseName=FYP I&assessValid=Valid&valid=<%=valid%>'" type="checkbox">
                                <%}%>
                            </div>
                        </td>

                        <td><a href="coAssessDetailPerStu.jsp?stuAssessID=<%=stu.getStuAssessID()%>&matricNo=<%=stu.getMatricNo()%>&comp=<%=comp%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%}%>

                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

