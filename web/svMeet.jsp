<%-- 
    Document   : svMeeting
    Created on : Apr 3, 2023, 1:13:59 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.model.appointment"%>
<%@page import="com.dao.appointmentDao"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page import="com.dao.meetingDao"%>
<%@page import="com.model.meeting"%>
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

        List<meeting> meet = meetingDao.getMeetBySvID(e.getSvID());

        List<appointment> appoint = appointmentDao.getAppointBySvID(e.getSvID());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${updateError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">List of Meetings</h2>
                <a href="meetAdd.jsp?userType=Supervisor"><button class="btn btn-primary addBtn">Add Meeting</button></a>
            </div>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th class="text-center"colspan='3'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (meeting m : meet) {
                            Date date = new Date();
                    %>
                    <%if (m.getMeetDate().after(date)) {%>
                    <tr>
                        <%} else {%>
                    <tr class="text-secondary">
                        <%}%>
                        <td><%=m.getMeetDate()%></td>

                        <td><%=m.getMeetTime()%></td>
                        <td><%=m.getMeetMode()%></td>
                        <td><%=m.getMeetLocate()%></td>
                        <td class="text-center"><a href="svMeetDetail.jsp?meetID=<%=m.getMeetID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                               
                        <%if (m.getMeetDate().before(date)) {%>
                        <td class="text-center"><i class="bi bi-wrench-adjustable-circle" style="color: #bdbebf"></i></td>
                                <%} else {%>
                        <td class="text-center"><a href="meetUpdate.jsp?meetID=<%=m.getMeetID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                <%}%>

                        <td class="text-center">
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'MeetingServlet?action=DELETEMEET&meetID=<%=m.getMeetID()%>';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
