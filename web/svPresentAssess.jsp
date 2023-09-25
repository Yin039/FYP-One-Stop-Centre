<%-- 
    Document   : svPresentAssess
    Created on : Jun 23, 2023, 8:29:55 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
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

        presentation panel = presentationDao.getPanelGroupBySvID(e.getSvID());
        List<user> student = userDao.getPresentStuByGpNo(panel.getPanelGpNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="row">
                <div class="section-title">
                    <h2>Presentation Assessment</h2>
                    <h6 class="text-danger text-center">${addError}${updateError}</h6>
                </div>

                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Matric No.</th>
                            <th>Student Name</th>
                            <th>Presentation</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for (user stu : student) {
                                assessment assess = assessmentDao.getPresentCompByCourseName(stu.getCrsName());
                                evaluation stuPresentAssess = assessmentDao.getStuPresentAssessByMatricNoID(stu.getMatricNo(), e.getSvID());

                                Date d = new Date();
                                boolean access = false;
                                if (assess.getAssessStartDate() != null) {
                                    if (!d.before(assess.getAssessStartDate()) && !d.after(assess.getAssessEndDate())) {
                                        access = true;
                                    }
                                }
                        %>
                        <tr>
                            <td><%=stu.getMatricNo()%></td>
                            <td><%=stu.getName()%></td>

                            <%if (stuPresentAssess.getStuAssessID() != 0) {%>
                            <td>
                                <%=stuPresentAssess.getStuAssessCompMark()%>/<%=assess.getCompPercentage()%>%

                                <%if (access) {%>
                                <a href="svPresentAssessManage.jsp?stuPresentAssessID=<%=stuPresentAssess.getStuAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Update"><i class="bi bi-pencil-square icon-color"></i></a>
                                    <%} else {%>
                                <i class="bi bi-pencil-square text-secondary"></i>
                                <%}%>
                            </td>
                            <%} else {%>
                            <td>
                                <%if (access) {%>
                                <a href="svPresentAssessManage.jsp?assessID=<%=assess.getAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Add"><i class="bi bi-pencil-square icon-color"></i></a>
                                    <%} else {%>
                                <i class="bi bi-pencil-square text-secondary"></i>
                                <%}%>
                            </td>
                            <%}
                                }%>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
