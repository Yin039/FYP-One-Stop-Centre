<%-- 
    Document   : stuAssess
    Created on : May 21, 2023, 11:58:38 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.Date"%>
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
        user e = (user) session.getAttribute("login");
        user user = (user) userDao.getUserByID(e.getUserID());

        Date d = new Date();

        List<assessment> assessComp = assessmentDao.getAssessCompByCourseName(user.getCrsName());
        evaluation evaluation = assessmentDao.getEvaluationByMatricNo(user.getMatricNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-start">Assessment (<%=user.getCrsName()%>)</h2>
            </div>

            <div class="row">
                <%
                    double carryMark = 0;
                    for (assessment assess : assessComp) {
                        if (!assess.getAssessComponent().equals("Report") && d.after(assess.getAssessEndDate())) {
                            evaluation stuAssess = assessmentDao.getStuAssessmentByMatricNoID(user.getMatricNo(), assess.getAssessID());
                            List<evaluation> stuCriteriaMark = assessmentDao.getStuCriteriaMarkByStuAssessID(stuAssess.getStuAssessID());
                            List<evaluation> stuPresentAssess = null;
                            String assessValid = "Invalid";

                            int i = 0;
                            double pAssessMark = 0.0;

                            if (assess.getAssessComponent().equals("Presentation")) {
                                stuPresentAssess = assessmentDao.getStuPresentAssessByMatricNoAssessID(user.getMatricNo(), assess.getAssessID());

                                for (evaluation present : stuPresentAssess) {
                                    i++;
                                    pAssessMark += present.getStuAssessCompMark();
                                    assessValid = present.getStuAssessValid();

                                }

                                if (assessValid.equals("Valid")) {
                                    carryMark += (pAssessMark / i);
                                }

                            }

                            if (stuAssess.getStuAssessID() != 0) {
                                if (stuAssess.getStuAssessValid().equals("Valid")) {
                                    carryMark += stuAssess.getStuAssessCompMark();
                                }
                            }

                %>
                <div class="col">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th><%=assess.getAssessComponent()%></th>

                                <%if (assess.getAssessComponent().equals("Presentation")) {%>

                                <%if (assessValid.equals("Valid")) {%>
                                <th><%=String.format("%.2f", pAssessMark / i)%>/<%=assess.getCompPercentage()%>%</th>
                                    <%} else {%>
                                <th>0/<%=assess.getCompPercentage()%>%</th>
                                    <%}%>
                                    <%} else {%>
                                    <%if (stuAssess.getAssessID() != 0) {
                                            if (stuAssess.getStuAssessValid().equals("Valid")) {%>
                                <th><%=String.format("%.2f", stuAssess.getStuAssessCompMark())%>/<%=assess.getCompPercentage()%>%</th>
                                    <%} else {%>
                                <th>0/<%=assess.getCompPercentage()%>%</th>
                                    <%}
                                            }
                                        }%>
                            </tr>
                        </thead>
                        <tbody>
                            <%for (evaluation cri : stuCriteriaMark) {
                                    assessment criteria = assessmentDao.getAssessCriteriaByID(cri.getCriteriaID());
                            %>
                            <tr>
                                <td><%=criteria.getAssessCriteria()%></td>
                                <%if (stuAssess.getStuAssessValid().equals("Valid")) {%>
                                <td><%=String.format("%.2f", cri.getStuCriteriaMark())%>%</td>
                                <%} else {%>
                                <td>0%</td>
                                <%}%>
                            </tr>
                            <%}%>

                            <%if (assess.getAssessComponent().equals("Presentation")) {
                                    List<assessment> criteria = assessmentDao.getCriteriaByAssessID(assess.getAssessID());
                                    stuPresentAssess = assessmentDao.getStuPresentAssessByMatricNoAssessID(user.getMatricNo(), assess.getAssessID());

                                    for (assessment pCri : criteria) {
                                        double mark = 0.0;

                                        for (evaluation present : stuPresentAssess) {
                                            evaluation stuPresentCriteriaMark = assessmentDao.getStuPresentCriteriaMarkByStuAssessID(pCri.getCriteriaID(), present.getStuAssessID());
                                            mark += stuPresentCriteriaMark.getStuCriteriaMark();
                                        }
                            %>
                            <tr>
                                <td><%=pCri.getAssessCriteria()%></td>
                                <%if (assessValid.equals("Valid")) {%>
                                <td><%=String.format("%.2f", mark / i)%>%</td>
                                <%} else {%>
                                <td>0%</td>
                                <%}%>
                            </tr>
                            <%}
                                }%>
                        </tbody>
                    </table>
                </div>
                <%}
                    }%>
            </div>
            <div class="col-2 bgColor p-2 m-2 rounded text-white text-start">
                <div class="row">
                    <span class="h5">Carry Mark: <%=String.format("%.2f", carryMark)%>%</span>
                </div>
            </div>
        </div>
    </body>
</html>
