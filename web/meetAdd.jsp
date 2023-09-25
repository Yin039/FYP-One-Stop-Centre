<%-- 
    Document   : meetAdd
    Created on : Apr 3, 2023, 1:36:44 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String userType = request.getParameter("userType");

        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">ADD MEETING</h2>
                <h6 class="text-danger text-center">${addError}</h6>
            </div>

            <div class="form">
                <form action="MeetingServlet?action=ADDMEET" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="meetDate"  min="<%=java.time.LocalDate.now()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Time</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="meetTime" min="08:00" max="17:00" value="08:00" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Mode</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="meetMode" required>
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
                                <input type="text" class="form-control" id="meetLocate" name="meetLocate" placeholder="Exp: Webex/FTKKI C34" required/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="svID" value="<%=e.getSvID()%>">
                    <input type="hidden" name="userType" value="<%=userType%>">

                    <%if (e.getUserType().equals("Student")) {%>
                    <input type="hidden" name="appointVerify" value="Approve">
                    <input type="hidden" name="matricNo" value="<%=e.getMatricNo()%>">
                    <%}%>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <%if (e.getUserType().equals("Supervisor")) {%>
                            <a href="svMeet.jsp" class="btn btn-primary float-end">Cancel</a>
                            <%} else if (e.getUserType().equals("Student")) {%>
                            <a href="stuLogBook.jsp" class="btn btn-primary float-end">Cancel</a>
                            <%}%>

                        </div>
                    </div>
                </form>
            </div>
    </body>
</html>
