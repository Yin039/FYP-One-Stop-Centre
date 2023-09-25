<%-- 
    Document   : svStuSubmission
    Created on : Jun 25, 2023, 5:47:19 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.Date"%>
<%@page import="com.dao.*"%>
<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String courseName = null;
        String component = null;
        int i = 0;
    %>
    <script>
        window.onload = function () {
        <%
            if (request.getParameter("courseName") != null) {
                courseName = request.getParameter("courseName");
            } else {
                courseName = "FYP I";
            }

            if (request.getParameter("component") != null) {
                component = request.getParameter("component");
            } else {
                component = "All";
            }
        %>
        }
    </script>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<user> Student = userDao.getStudentByGroup(e.getGroupNo());
        List<projectProgress> mainTask = projectProgressDao.getMainTaskByCourseName(courseName);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div class='row'>
                    <div class="section-title">
                        <h2 class="text-start">List of Submission (<%=courseName%>)</h2>
                    </div>
                    <div class="col-3 mt-2">
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'svStuSubmission.jsp?courseName=' + this.value">
                            <option value="<%=courseName%>" selected style="display:none;"><%=courseName%></option>
                            <option value="FYP I">FYP I</option>
                            <option value="FYP II">FYP II</option>
                        </select>
                    </div>
                </div>
            </div>

            <table class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Student Name</th>
                            <%for (projectProgress main : mainTask) {
                                    if (!main.getMainTask().equals("Project")) {
                            %>
                        <th colspan="3"><%=main.getMainTask()%></th>
                            <%}
                                }%>
                    </tr>
                </thead>
                <tbody>
                    <%for (user stu : Student) {
                            if (stu.getCrsName().equals(courseName)) {
                    %>
                    <tr>
                        <td><%=stu.getMatricNo()%></td>
                        <td><%=stu.getName()%></td>
                        <%
                            for (projectProgress main : mainTask) {
                                if (!main.getMainTask().equals("Project")) {
                                    projectProgress submission = projectProgressDao.getSubmitByIDs(main.getMainTaskID(), stu.getMatricNo());

                                    if (submission.getSubmitID() != 0) {
                        %>
                        <td><%=submission.getDocumentName()%></td>
                        <td><a class="me-1" href="ProjectProgressServlet?action=VIEWSUBMIT&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                        <td><a class="me-1" href="ProjectProgressServlet?action=DOWNLOAD&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-download icon-color"></i></a></td>
                                <%} else {%>
                        <td colspan='3' class="text-danger">No Submission</td>
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
