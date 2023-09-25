<%-- 
    Document   : svStuAssess
    Created on : May 16, 2023, 1:18:27 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.Date"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
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
        List<user> Student = userDao.getStudentByGroup(e.getGroupNo());

        List<assessment> FYPI = assessmentDao.getAssessCompByCourseName("FYP I");
        List<assessment> FYPII = assessmentDao.getAssessCompByCourseName("FYP II");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}</h6>
                <h2 class="text-start">Student's Assessment</h2>
            </div>

            <h4>FYP I</h4>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                            <%for (assessment comp : FYPI) {
                                    if (!comp.getAssessComponent().equals("Presentation")) {
                            %>
                        <th><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</th>
                            <%}
                                }%>
                    </tr>
                </thead>
                <tbody>
                    <%for (user stu : Student) {
                            if (stu.getCrsName().equals("FYP I")) {
                    %>
                    <tr>
                        <td><%=stu.getMatricNo()%></td>
                        <%for (assessment comp : FYPI) {
                                Date d = new Date();
                                boolean access = false;
                                if (comp.getAssessStartDate() != null) {
                                    if (!d.before(comp.getAssessStartDate()) && !d.after(comp.getAssessEndDate())) {
                                        access = true;
                                    }
                                }

                                if (!comp.getAssessComponent().equals("Presentation")) {
                                    evaluation stuAssess = assessmentDao.getStuAssessmentByMatricNoID(stu.getMatricNo(), comp.getAssessID());
                        %>
                        <%if (stuAssess.getStuAssessID() != 0) {%>
                        <td>
                            <%=stuAssess.getStuAssessCompMark()%>%

                            <%if (access) {%>
                            <a href="svStuAssessManage.jsp?stuAssessID=<%=stuAssess.getStuAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Update"><i class="bi bi-pencil-square icon-color"></i></a>
                                <%} else {%>
                            <i class="bi bi-pencil-square text-secondary"></i>
                            <%}%>
                        </td>
                        <%} else {%>
                        <td>
                            <%if (access) {%>
                            <a href="svStuAssessManage.jsp?assessID=<%=comp.getAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Add"><i class="bi bi-pencil-square icon-color"></i></a>
                                <%} else {%>
                            <i class="bi bi-pencil-square text-secondary"></i>
                            <%}%>
                        </td>
                        <%}
                                }
                            }%>
                    </tr>
                    <%}
                        }%>
                </tbody>
            </table>

            <h4>FYP II</h4>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                            <%for (assessment comp : FYPII) {
                                    if (!comp.getAssessComponent().equals("Presentation")) {
                            %>
                        <th><%=comp.getAssessComponent()%> (<%=comp.getCompPercentage()%>%)</th>
                            <%}
                                }%>
                    </tr>
                </thead>
                <tbody>
                    <%for (user stu : Student) {
                            if (stu.getCrsName().equals("FYP II")) {
                    %>
                    <tr>
                        <td><%=stu.getMatricNo()%></td>
                        <%for (assessment comp : FYPII) {
                                Date d = new Date();
                                boolean access = false;
                                if (comp.getAssessStartDate() != null) {
                                    if (!(d.after(comp.getAssessEndDate()) || d.before(comp.getAssessStartDate()))) {
                                        access = true;
                                    }
                                }

                                if (!comp.getAssessComponent().equals("Presentation")) {
                                    evaluation stuAssess = assessmentDao.getStuAssessmentByMatricNoID(stu.getMatricNo(), comp.getAssessID());
                        %>
                        <%if (stuAssess.getStuAssessID() != 0) {%>
                        <td>
                            <%=stuAssess.getStuAssessCompMark()%>%

                            <%if (access) {%>
                            <a href="svStuAssessManage.jsp?stuAssessID=<%=stuAssess.getStuAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Update"><i class="bi bi-pencil-square icon-color"></i></a>
                                <%} else {%>
                            <i class="bi bi-pencil-square text-secondary"></i>
                            <%}%>
                        </td>
                        <%} else {%>
                        <td>
                            <%if (access) {%>
                            <a href="svStuAssessManage.jsp?assessID=<%=comp.getAssessID()%>&matricNo=<%=stu.getMatricNo()%>&action=Add"><i class="bi bi-pencil-square icon-color"></i></a>
                                <%} else {%>
                            <i class="bi bi-pencil-square text-secondary"></i>
                            <%}%>
                        </td>
                        <%}
                                }
                            }%>
                    </tr>
                    <%}
                        }%>
                </tbody>
            </table>
        </div>
    </body>
</html>
