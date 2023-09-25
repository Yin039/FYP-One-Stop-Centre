<%-- 
    Document   : stuMeet
    Created on : Apr 3, 2023, 2:41:57 AM
    Author     : user
--%>

<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Student</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<appointment> approved = appointmentDao.getApprovedAppointByMatricNo(e.getMatricNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">List of LogBook</h2>
                <a href="meetAdd.jsp?userType=Student"><button class="btn btn-primary addBtn">Add Meeting</button></a>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Date</th>
                        <th>Timestamp</th>
                        <th>LogBook Validation</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int i = 1;
                        for (appointment a : approved) {
                            meeting m = meetingDao.getMeetByID(a.getMeetID());
                            logbook lb = logbookDao.getLBByMatricNoMeetID(e.getMatricNo(), a.getMeetID());

                            String logValidate = lb.getLogValidate();
                    %>
                    <tr>
                        <td><%=i++%></td>
                        <td><%=m.getMeetDate()%></td>

                        <%if (lb.getLogID() == 0) {%>
                        <td class="text-danger" colspan="2">LogBook haven't fill in..!</td>
                        <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Add"><i class="bi bi-file-text-fill icon-color"></i></a></td>
                                <%} else {%>
                        <td><%=lb.getTimestamp()%></td>

                        <%if (lb.getLogValidate().equals("Valid")) {%>
                        <td><%=lb.getLogValidate()%></td>
                        <%} else {%>
                        <td class="text-danger"><%=lb.getLogValidate()%></td>
                        <%}%>

                        <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Update&logID=<%=lb.getLogID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
