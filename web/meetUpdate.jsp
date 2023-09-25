<%-- 
    Document   : meetUpdate
    Created on : Apr 3, 2023, 11:10:33 PM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>FYP One Stop Centre</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        int meetID = Integer.parseInt(request.getParameter("meetID"));
        meeting meet = meetingDao.getMeetByID(meetID);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">UPDATE MEETING DETAILS</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="MeetingServlet?action=UPDATEMEET" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="meetDate"  min="<%=java.time.LocalDate.now()%>" value="<%=meet.getMeetDate()%>"/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Time</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="meetTime" min="08:00" max="17:00" value="08:00" value="<%=meet.getMeetTime()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Mode</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="meetMode" required>
                                    <option value="<%=meet.getMeetMode()%>" style="display:none;"><%=meet.getMeetMode()%></option>
                                    <option value="Physical">Physical</option>
                                    <option value="Online">Online</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Location</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-geo-alt-fill"></i></div>
                                <input type="text" class="form-control" id="meetLocate" name="meetLocate" value="<%=meet.getMeetLocate()%>" required/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="meetID" value="<%=meetID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="svMeet.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
    </body>
