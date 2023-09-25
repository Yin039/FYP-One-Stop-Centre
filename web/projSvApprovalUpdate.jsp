<%-- 
    Document   : projApprovalUpdate
    Created on : Mar 29, 2023, 1:22:11 AM
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
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<project> project = projectDao.getProjectByGroup(e.getGroupNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${updateError}</h6>
                <h2 class="text-start">List of Project Registration</h2>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Project Title</th>
                        <th>Project Type</th>
                        <th>Project Status</th>
                        <th  class="text-center"colspan=2'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (project proj : project) {%>
                    <tr>
                        <td><%=proj.getMatricNo()%></td>
                        <td><%=proj.getProjectTitle()%></td>
                        <td><%=proj.getProjectType()%></td>
                        <td>
                            <%
                                if (proj.getProjectApproval() != null) {
                                    String approval = proj.getProjectApproval();
                                    if (approval.equals("Applying") || approval.equals("SV Approved")) {
                            %>
                            <p class="text-warning"><%=approval%></p>
                            <%} else if (approval.equals("Approved")) {%>
                            <%=approval%>
                            <%} else if (approval.equals("Rejected")) {%>
                            <p class="text-danger"><%=approval%></p>
                            <%}
                            } else {
                            %>
                            <p class="text-danger">Project Haven't Register</p>
                            <%}%>
                        </td>
                       
                        <%if(proj.getProjectApproval() != null && proj.getProjectApproval().equals("Approved")){%>
                         <td class="text-center"><i class="bi bi-check-circle-fill" style="color: #bdbebf"></i></td>
                        <td class="text-center"><i class="bi bi-x-circle-fill" style="color: #bdbebf"></i></td>
                        <%}else{%>
                         <td class="text-center"><a href="ProjectServlet?action=SVUPDATE&projApproval=SV Approved&projectID=<%=proj.getProjectID()%>"><i class="bi bi-check-circle-fill text-warning"></i></a></td>
                        <td class="text-center"><a href="ProjectServlet?action=SVUPDATE&projApproval=Rejected&projectID=<%=proj.getProjectID()%>"><i class="bi bi-x-circle-fill text-danger"></i></a></td>
                        <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
