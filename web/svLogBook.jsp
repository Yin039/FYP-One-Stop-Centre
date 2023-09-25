<%-- 
    Document   : svLogBook
    Created on : Apr 5, 2023, 6:46:58 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
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

        List<appointment> approved = null;
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">List of LogBooks</h2>
                
                <form method="post">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search by Matric No."/>
                        <input type="submit" value="Search" class="btn btn-primary"/>
                    </div>
                </form>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Date</th>
                        <th>Timestamp</th>
                        <th>LogBook Validation</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String search = request.getParameter("search");

                        if (search == null) {
                            approved = appointmentDao.getApprovedAppointBySvID(e.getSvID());
                        } else {
                            approved = appointmentDao.searchAppointApprovedByMatricNo(e.getSvID(), search);
                        }

                        for (appointment a : approved) {
                            meeting m = meetingDao.getMeetByID(a.getMeetID());
                            logbook lb = logbookDao.getLBByMatricNoMeetID(a.getMatricNo(), a.getMeetID());
                    %>
                    <tr>
                        <td><%=a.getMatricNo()%></td>
                        <td><%=m.getMeetDate()%></td>
                        <%if (lb.getLogID() == 0) {%>
                        <td class="text-danger" colspan="3">LogBook haven't fill in..!</td>
                        <%} else {%>
                        <td><%=lb.getTimestamp()%></td>
                        <%if (!lb.getLogValidate().equals("Valid")) {%>
                        <td class="text-danger"><%=lb.getLogValidate()%></td>
                        <%} else {%>
                        <td><%=lb.getLogValidate()%></td>
                        <%}%>
                        <td class="text-center"><a href="logBookManage.jsp?meetID=<%=a.getMeetID()%>&action=View&logID=<%=lb.getLogID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
