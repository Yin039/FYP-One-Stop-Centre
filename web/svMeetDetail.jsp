<%-- 
    Document   : svMeetDetail
    Created on : Apr 3, 2023, 11:25:41 PM
    Author     : TEOH YI YIN
--%>

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
        int meetID = Integer.parseInt(request.getParameter("meetID"));
        meeting meet = meetingDao.getMeetByID(meetID);

        List<appointment> alist = appointmentDao.getListAppointByMeetID(meetID);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">Meeting Details</h2>
            </div>
            <div class="d-flex justify-content-between">
                <div class="col-2">
                    <table class="table">
                        <tr>
                            <th class="text-center">DATE: </th>
                            <td><%=meet.getMeetDate()%></td>
                        </tr>
                        <tr>
                            <th class="text-center">TIME: </th>
                            <td><%=meet.getMeetTime()%></td>
                        </tr>
                        <tr>
                            <th class="text-center">MODE: </th>
                            <td><%=meet.getMeetMode()%></td>
                        </tr>
                        <tr>
                            <th class="text-center">LOCATION: </th>
                            <td><%=meet.getMeetLocate()%></td>
                        </tr>
                    </table>
                </div>
                <div class="col-10 text-end">
                    <a href="meetUpdate.jsp?meetID=<%=meet.getMeetID()%>"><button class="btn btn-primary addBtn">Edit Meeting</button></a>
                </div>
            </div>
            <table class="table table-hover mt-3">
                <thead>
                    <tr>
                        <th class="col-1">Student Name</th>
                        <th class="col-1">Appointment Status</th>
                        <th colspan='2' class="col-1 text-center">Action</th>
                        <th colspan="2" class="col-2">LogBook</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (appointment a : alist) {
                            user student = userDao.getStudentDetail(a.getMatricNo());
                            logbook lb = logbookDao.getLBByMatricNoMeetID(a.getMatricNo(), a.getMeetID());
                    %>
                    <tr>
                        <td><%=student.getName()%></td>
                        <td><%=a.getAppointVerify()%></td>
                        <td class="text-end"><a href="MeetingServlet?action=APPOINTSTATE&appointVerify=Approved&appointID=<%=a.getAppointID()%>&meetID=<%=meet.getMeetID()%>"><i class="bi bi-check-circle-fill text-warning"></i></a></td>
                        <td class="text-start"><a href="MeetingServlet?action=APPOINTSTATE&appointVerify=Rejected&appointID=<%=a.getAppointID()%>&meetID=<%=meet.getMeetID()%>"><i class="bi bi-x-circle-fill text-danger"></i></a></td>
                        <%if (!a.getAppointVerify().equals("Approved") && lb.getLogID() == 0) {%>
                        <td class="text-danger" colspan="2"></td>
                        <%}else if (a.getAppointVerify().equals("Approved") && lb.getLogID() == 0) {%>
                        <td class="text-danger" colspan="2">LogBook haven't fill in..!</td>
                        <%} else {
                            if (!lb.getLogValidate().equals("Valid")) {%>
                        <td class="text-danger"><%=lb.getLogValidate()%></td>
                        <%} else {%>
                        <td><%=lb.getLogValidate()%></td>
                        <%}%>
                        <td><a href="logBookManage.jsp?meetID=<%=a.getMeetID()%>&action=View&logID=<%=lb.getLogID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
