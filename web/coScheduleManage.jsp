<%-- 
    Document   : coScheduleManage
    Created on : Apr 16, 2023, 12:30:58 AM
    Author     : user
--%>

<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String action = request.getParameter("action");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <%if (action.equals("Add")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD TIMETABLE</h2>
            </div>

            <div class="form">
                <form action="ScheduleServlet?action=ADDDETAIL" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Week</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="int" class="form-control" name="week" required/>
                            </div>
                        </div>

                        <div class="col-3">
                            <label>Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" name="date"  min="<%=java.time.LocalDate.now()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Activity</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" name="activity"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Action</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" name="scheduleAction"></textarea>
                            </div>
                        </div>
                    </div>
                            
                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coScheduleTimetable.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int detailID = Integer.parseInt(request.getParameter("detailID"));
                schedule s = scheduleDao.getScheduleDetailsByID(detailID);
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE TIMETABLE</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="ScheduleServlet?action=UPDATEDETAIL" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Week</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="int" class="form-control" name="week" value="<%=s.getWeek()%>"/>
                            </div>
                        </div>

                        <div class="col-3">
                            <label>Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" name="date"  min="<%=java.time.LocalDate.now()%>" value="<%=s.getDate()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Activity</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" name="activity"><%=s.getActivity()%></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Action</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" name="scheduleAction"><%=s.getAction()%></textarea>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="detailID" value="<%=detailID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coScheduleTimetable.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
