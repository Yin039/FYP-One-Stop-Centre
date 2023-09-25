<%-- 
    Document   : stuAppoint
    Created on : Apr 3, 2023, 2:33:00 AM
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
        <title>FYP One Stop Centre - Student</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());
        Date date = new Date();

        List<meeting> allMeeting = meetingDao.getMeetBySvID(e.getSvID());
        List<meeting> toAppoint = meetingDao.getMeetToAppointBySvID(e.getMatricNo(), date);

        List<appointment> appointed = appointmentDao.getAppointByMatricNo(e.getMatricNo());
        List<appointment> approved = appointmentDao.getApprovedAppointByMatricNo(e.getMatricNo());
    %>
    <script>
        window.onload = function () {
        <%
            String status = request.getParameter("status");
        %>
        }
    </script>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}</h6>
                <h6 class="text-danger text-center">${updateAppointError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-start">List of Appointment For Meeting</h2>

                <div class="d-flex justify-content-end">
                    <div class="col-7">
                        <a href="appointAdd.jsp"><button class="btn btn-primary addBtn">Add Appointment</button></a>
                    </div>


                    <div class="col-6 mt-2">
                        <select class="form-select" name="status" onchange="window.location = 'stuAppoint.jsp?status=' + this.value">
                            <option value="<%=status%>" selected style="display:none;"><%=status%></option>
                            <option value="All">All</option>
                            <option value="To Appoint">To Appoint</option>
                            <option value="Appointed">Appointed</option>
                            <option value="Approved">Approved</option>
                        </select>
                    </div>
                </div>
            </div>
            <%if (status.equals("All")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>

                    <%
                        for (meeting m : allMeeting) {
                            appointment appoint = appointmentDao.getAppointByMatricNoMeetID(m.getMeetID(), e.getMatricNo());
                    %>
                <td><%=m.getMeetDate()%></td>
                <td><%=m.getMeetTime()%></td>
                <td><%=m.getMeetMode()%></td>
                <td><%=m.getMeetLocate()%></td>
                <%if (appoint.getAppointID() == 0 && m.getMeetDate().after(date)) {%>
                <td colspan="4"><a href="MeetingServlet?action=APPOINT&meetID=<%=m.getMeetID()%>" class="a-link">Make Appointment</a></td>
                <%} else if (appoint.getAppointID() == 0 && m.getMeetDate().before(date)) {%>
                <td colspan="4" class="text-secondary">Make Appointment</td>
                <%} else {%>
                <td><%=appoint.getAppointVerify()%></td>
                <%
                    if (appoint.getAppointVerify().equals("Approved")) {
                        logbook lb = logbookDao.getLBByMatricNoMeetID(e.getMatricNo(), m.getMeetID());
                        if (lb.getLogID() == 0) {
                %>
                <td class="text-danger" colspan="2">LogBook haven't fill in..!</td>
                <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Add"><i class="bi bi-file-text-fill icon-color"></i></a></td>
                        <%} else {%>
                <td><%=lb.getTimestamp()%></td>
                <td><%=lb.getLogValidate()%></td>
                <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Update&logID=<%=lb.getLogID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                        <%}%>
                        <%} else {%>
                <td class="text-left" colspan="3">
                    <a onclick="if (confirm('Are you sure you want to cancel appointment?'))
                                href = 'MeetingServlet?action=DELETEAPPOINT&appointID=<%=appoint.getAppointID()%>';
                            else
                                return false;">
                        <i class="bi bi-trash-fill text-danger"></i>
                    </a>
                </td>
                <%}%>
                <%}%>
                </tr>
                <%}%>
                </tbody>
            </table>
            <%} else if (status.equals("To Appoint")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>

                    <%for (meeting m : toAppoint) {%>
                    <tr>
                        <td><%=m.getMeetDate()%></td>
                        <td><%=m.getMeetTime()%></td>
                        <td><%=m.getMeetMode()%></td>
                        <td><%=m.getMeetLocate()%></td>
                        <td><a href="MeetingServlet?action=APPOINT&meetID=<%=m.getMeetID()%>" class="a-link">Make Appointment</a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (status.equals("Appointed")) {%>
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (appointment a : appointed) {
                            meeting m = meetingDao.getMeetByID(a.getMeetID());
                    %>
                    <tr>
                        <td><%=m.getMeetDate()%></td>
                        <td><%=m.getMeetTime()%></td>
                        <td><%=m.getMeetMode()%></td>
                        <td><%=m.getMeetLocate()%></td>
                        <td><%=a.getAppointVerify()%></td>
                        <td class="text-center">
                            <a onclick="if (confirm('Are you sure you want to cancel appointment?'))
                                        href = 'MeetingServlet?action=DELETEAPPOINT&appointID=<%=a.getAppointID()%>';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                    <%}%>
                    <%} else if (status.equals("Approved")) {%>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Mode</th>
                            <th>Location</th>
                            <th colspan="2">LogBook Validation</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (appointment a : approved) {
                                meeting m = meetingDao.getMeetByID(a.getMeetID());
                                logbook lb = logbookDao.getLBByMatricNoMeetID(e.getMatricNo(), a.getMeetID());
                        %>
                        <tr>
                            <td><%=m.getMeetDate()%></td>
                            <td><%=m.getMeetTime()%></td>
                            <td><%=m.getMeetMode()%></td>
                            <td><%=m.getMeetLocate()%></td>
                            <%if (lb.getLogID() == 0) {%>
                            <td class="text-danger" colspan="2">LogBook haven't fill in..!</td>
                            <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Add"><i class="bi bi-file-text-fill icon-color"></i></a></td>
                                    <%} else {%>
                            <td><%=lb.getTimestamp()%></td>
                            <td><%=lb.getLogValidate()%></td>
                            <td class="text-center"><a href="logBookManage.jsp?meetID=<%=m.getMeetID()%>&action=Update&logID=<%=lb.getLogID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                    <%}%>
                                    <%}%>
                                    <%}%>
                    </tbody>
                </table>
        </div>
    </body>
</html>

