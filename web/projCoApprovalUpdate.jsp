<%-- 
    Document   : projCoApprovalUpdate
    Created on : Mar 29, 2023, 2:13:11 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.project"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page import="com.dao.projectDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <script>
        window.onload = function () {
        <%
            String status = request.getParameter("status");
            List<project> project = null;

            if (status.equals("All")) {
                project = projectDao.getProjectList();
            } else if (status.equals("Not Registered")) {
                project = projectDao.getStuNotRegisteredProject();
            } else {
                project = projectDao.getProjectByApprovalStatus(status);
            }
        %>
        }
    </script>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">List of Project Approval Status</h2>
                <div class="col-2">
                    <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'projCoApprovalUpdate.jsp?status=' + this.value">
                        <option value="<%=status%>" selected style="display:none;"><%=status%></option>
                        <option value="All">All</option>
                        <option value="Applying">Applying</option>
                        <option value="SV Approved">SV Approved</option>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                        <option value="Not Registered">Not Registered</option>
                    </select>
                </div>
            </div>
            <%if (status.equals("Approved")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th  class="text-center"colspan='2'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {
                        user stu = userDao.getStudentDetail(proj.getMatricNo());
                    %>
                    <tr>
                        <td><%=proj.getMatricNo()%></td>
                        <%if (proj.getProjectID() == 0) {%>
                        <td colspan="5" class="text-danger">Not Yet Registered..!</td>
                        <%} else {%>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>
                        <td><%=proj.getProjectApproval()%></td>
                        <td class="text-center"><a href="ProjectServlet?action=COUPDATE&projApproval=Rejected&projectID=<%=proj.getProjectID()%>&oriState=<%=proj.getProjectApproval()%>"><i class="bi bi-x-circle-fill text-danger"></i></a></td>
                        <td class="text-center"><a href="coUserManage.jsp?stuUserID=<%=stu.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (status.equals("Applying")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {
                    user stu = userDao.getStudentDetail(proj.getMatricNo());
                    %>
                    <tr>
                        <td><%=proj.getMatricNo()%></td>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>
                        <td class="text-warning"><%=proj.getProjectApproval()%></td>
                        <td class="text-center"><a href="coUserManage.jsp?stuUserID=<%=stu.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (status.equals("SV Approved")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th  class="text-center"colspan='3'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {
                    user stu = userDao.getStudentDetail(proj.getMatricNo());
                    %>
                    <tr>
                        <td><%=proj.getMatricNo()%></td>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>
                        <td class="text-warning"><%=proj.getProjectApproval()%></td>
                        <td class="text-center"><a href="ProjectServlet?action=COUPDATE&projApproval=Approved&projectID=<%=proj.getProjectID()%>&oriState=<%=proj.getProjectApproval()%>"><i class="bi bi-check-circle-fill text-warning"></i></a></td>
                        <td class="text-center"><a href="ProjectServlet?action=COUPDATE&projApproval=Rejected&projectID=<%=proj.getProjectID()%>&oriState=<%=proj.getProjectApproval()%>"><i class="bi bi-x-circle-fill text-danger"></i></a></td>
                        <td class="text-center"><a href="coUserManage.jsp?stuUserID=<%=stu.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (status.equals("Rejected")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th  class="text-center"colspan='2'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {
                    user stu = userDao.getStudentDetail(proj.getMatricNo());
                    %>
                    <tr>
                        <td><%=proj.getMatricNo()%></td>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>
                        <td class="text-danger"><%=proj.getProjectApproval()%></td>
                        <td class="text-center"><a href="ProjectServlet?action=COUPDATE&projApproval=Approved&projectID=<%=proj.getProjectID()%>&oriState=<%=proj.getProjectApproval()%>"><i class="bi bi-check-circle-fill text-warning"></i></a></td>
                        <td class="text-center"><a href="coUserManage.jsp?stuUserID=<%=stu.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th  class="text-center"colspan='2'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {
                    user stu = userDao.getStudentDetail(proj.getMatricNo());
                    %>
                    <tr>
                        <%if (proj.getProjectID() == 0) {%>
                        <td class="text-danger"><%=proj.getMatricNo()%></td>
                        <td colspan="4" class="text-danger">Not Yet Registered..!</td>
                        <%} else {%>
                        <td><%=proj.getMatricNo()%></td>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>

                        <%if (proj.getProjectApproval().equals("Approved")) {%>
                        <td><%=proj.getProjectApproval()%></td>
                        <%} else if (proj.getProjectApproval().equals("Rejected")) {%>
                        <td class="text-danger"><%=proj.getProjectApproval()%></td>
                        <%} else {%>
                        <td class="text-warning"><%=proj.getProjectApproval()%></td>
                        <%}%>
                        <td class="text-center"><a href="coUserManage.jsp?stuUserID=<%=stu.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%}%>
        </div>
    </body>
</html>

