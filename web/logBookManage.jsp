<%-- 
    Document   : logBookAdd
    Created on : Apr 4, 2023, 12:19:21 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - LogBook</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        int meetID = Integer.parseInt(request.getParameter("meetID"));
        String action = request.getParameter("action");

        meeting m = meetingDao.getMeetByID(meetID);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <%if (action.equals("Add")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD LOGBOOK</h2>
                <h6 class="text-danger text-center">${addError}</h6>
            </div>

            <div class="form">
                <form action="MeetingServlet?action=ADDLB" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Activity</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projectAct"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Problem/Issue</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projectProb"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Problem Solving Suggestion</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="probSolveSuggest"></textarea>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="meetID" value="<%=meetID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="stuAppoint.jsp?status=Approved" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int logID = Integer.parseInt(request.getParameter("logID"));
                logbook lb = logbookDao.getLBByID(logID);
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE LOGBOOK (<%=m.getMeetDate()%>)</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="MeetingServlet?action=UPDATELB" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-start">
                        <div class="col-2"></div>
                        <div class="col-2">
                            <label>TimeStamp</label>
                            <div class='input-group'>
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input class="form-control" type='text' name='timestamp' value="<%=lb.getTimestamp()%>" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Project Activity</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projectAct"><%=lb.getProjectAct()%></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Problem/Issue</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projectProb"><%=lb.getProjectProb()%></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Problem Solving Suggestion</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="probSolveSuggest"><%=lb.getProjectSolveSuggest()%></textarea>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="meetID" value="<%=meetID%>">
                    <input type="hidden" name='logValidate' value='<%=lb.getLogValidate()%>'>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="stuLogBook.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("View")) {
                int logID = Integer.parseInt(request.getParameter("logID"));
                logbook lb = logbookDao.getLBByID(logID);
            %>
            <div class="section-title">
                <h2 class="text-center"><%=lb.getMatricNo()%> LOGBOOK (<%=m.getMeetDate()%>)</h2>
            </div>

            <div class="d-flex justify-content-center">
                <div class="col-10">
                    <table class="table table-borderless">
                        <tr class="pt-2">
                            <th class="col-1">Matric No: </th>
                            <td><%=lb.getMatricNo()%></td>
                        </tr>
                        <tr>
                            <th>Timestamp: </th>
                            <td><%=lb.getTimestamp()%></td>
                        </tr>
                        <tr><td></td></tr>
                        <tr class="bgColor text-white">
                            <th colspan="2">Project Activity: </th>
                        </tr>
                        <tr>
                            <td colspan="2" class="col-10"><%=lb.getProjectAct()%></td>
                        </tr>
                        <tr class="bgColor text-white">
                            <th colspan="2">Problem/Issue: </th>
                        </tr>
                        <tr>
                            <td colspan="2" class="col-10"><%=lb.getProjectProb()%></td>
                        </tr>
                        <tr class="bgColor text-white">
                            <th colspan="2">Problem Solving Suggestion: </th>
                        </tr>
                        <tr>
                            <td colspan="2" class="col-10"><%=lb.getProjectSolveSuggest()%></td>
                        </tr>                        
                    </table>
                    <%
                        if (request.getParameter("user") == null){
                    %>
                    <div class="text-center">
                        <a href="MeetingServlet?action=VALIDATELB&meetID=<%=meetID%>&logID=<%=lb.getLogID()%>&logValidate=<%=lb.getLogValidate()%>" class="btn btn-primary"><%=lb.getLogValidate()%></a>
                    </div>
                    <%}%>
                </div>
            </div>
            <%}%>
        </div>
    </body>
</html>
