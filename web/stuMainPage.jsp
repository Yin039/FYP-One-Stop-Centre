<%-- 
    Document   : stuMainPage
    Created on : Nov 10, 2022, 6:10:12 AM
    Author     : YI YIN
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>FYP One Stop Centre - Student</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user e = (user) session.getAttribute("login");
        user user = (user) userDao.getUserByID(e.getUserID());
        project project = (project) projectDao.getProjectByMatricNo(user.getMatricNo());

        List<meeting> upcomingMeet = meetingDao.getUpcomingMeetByMatricNo(user.getMatricNo());

        List<projectProgress> mainTask = projectProgressDao.getMainTaskByCourseName(user.getCrsName());
        List<projectProgress> projectTrack = projectProgressDao.getTrackingByProjectID(project.getProjectID());

        SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");
        Date date = d.parse(d.format(new Date()));
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <table class="table">
                <tr>
                    <th colspan="1" class="text-end">APPROVAL STATUS: </th>
                    <td colspan="3">
                        <%
                            if (project.getProjectApproval() != null) {
                                String approval = project.getProjectApproval();
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
                    <th colspan="1" class="text-end">PROJECT TITLE: </th>
                    <td colspan="7">
                        <%if (project.getProjectTitle() == null) {%>
                        <a class="userName a-link"  href="projRegister.jsp?matricNo=<%=user.getMatricNo()%>">Register Project Title</a>
                        <%} else {%>
                        <a class="userName a-link"  href="projUpdate.jsp?projectID=<%=project.getProjectID()%>"><%=project.getProjectTitle()%></a>
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">SUPERVISOR: </th>
                    <td colspan="11"><%=user.getSvName()%></td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">GROUP NO: </th>
                    <td colspan="2"><%=user.getGroupNo()%></td>
                    <th colspan="1" class="text-end">GROUP LINK: </th>
                    <td colspan="8"><%if (user.getGroupLink() == null) {%>
                        <p class="text-danger">Link of Group Chat Haven't Added.</p>
                        <%} else {%>
                        <a class="userName a-link" href="<%=user.getGroupLink()%>"><%=user.getGroupLink()%></a>
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">SEMESTER: </th>
                    <td colspan="2"><%=user.getSem()%></td>
                    <th colspan="1" class="text-end">COURSE CODE: </th>
                    <td colspan="1"><%=user.getCrsCode()%></td>
                    <th colspan="1" class="text-end">COURSE NAME: </th>
                    <td colspan="1"><%=user.getCrsName()%></td>
                </tr>
            </table>

            <form method="post" action="ProjectProgressServlet?action=SUBMIT" enctype="multipart/form-data">
                <div class="row enroll-con justify-content-end align-items-center ms-5">
                    <div class="col-5">
                        <div class="input-group">
                            <select class="form-select" name="mainTaskID">
                                <%
                                    for (projectProgress main : mainTask) {
                                        if (!main.getMainTask().equals("Project")) {
                                %>
                                <option value="<%=main.getMainTaskID()%>"><%=main.getMainTask()%></option>
                                <%}}%>
                            </select>
                            <div class="custom-file">
                                <input name="file" type="file" accept="application/pdf" class="custom-file-input" placeholder="Choose File">
                                <input type="hidden" name="matricNo" value="<%=user.getMatricNo()%>">
                            </div>
                        </div>
                    </div>
                    <div class="col-1">
                        <button type="submit" value="Submit" class="btn btn-primary">Submit</button>
                    </div>
                </div>
            </form>
            <div class="row">
                <div class="col-6"></div> 
                <div class="col-6">
                    <h6 class="text-danger text-end">${uploadError}</h6>
                    <h6 class="text-success text-end">${uploadSuccess}</h6>
                </div> 
            </div>

            <div class="row"> 
                <div class="col-2 border px-3 py-1">
                    <div class="mt-2 text-decoration-underline">
                        <h5>Upcoming Meetings</h5>
                    </div>

                    <%if (upcomingMeet.isEmpty()) {%>
                    <p>No Upcoming Meetings Within 7 Days</p>
                    <%} else {
                        for (meeting m : upcomingMeet) {
                    %>
                    <div class="row shadow rounded mt-2">
                        <%if (m.getMeetDate().equals(date)) {%>
                        <div class="bgColor rounded-top">
                            <p class="text-white pt-2 pb-0 fw-bold"><%=m.getMeetDate()%></p>
                        </div>
                        <%} else {%>
                        <div class="lightBlue rounded-top">
                            <p class="pt-2 pb-0 fw-bold"><%=m.getMeetDate()%></p>
                        </div>
                        <%}%>

                        <div>
                            <p class="pt-2 pb-0 border-bottom small-shadow"><%=m.getMeetTime()%> - <%=m.getMeetLocate()%></p>
                        </div>
                    </div>
                    <%}
                        }%>
                </div>

                <div class="col">
                    <div class="row lightBlue">
                        <%
                            double i = 0;

                            for (projectProgress main : mainTask) {
                                projectProgress submission = projectProgressDao.getSubmitByIDs(main.getMainTaskID(), user.getMatricNo());
                                double taskChecked = 0;
                        %>
                        <div class="col">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><%=main.getMainTask()%></th>

                                        <td class="text-end  col-6">
                                            <%if (submission.getSubmitID() != 0) {%>
                                            <a class="me-1" href="ProjectProgressServlet?action=VIEWSUBMIT&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-eye-fill icon-color"></i></a>
                                            <a class="me-1" href="ProjectProgressServlet?action=DOWNLOAD&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-download icon-color"></i></a>
                                                <%}%>
                                                <%if (main.getMainTask().equals("Project")) {%>
                                            <a href="stuProjTaskManage.jsp"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a>
                                                <%}%>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%for (projectProgress tracking : projectTrack) {
                                            if (tracking.getMainTaskID() == main.getMainTaskID()) {
                                                i++;
                                    %>
                                    <tr>
                                        <td class="col-9"><%=tracking.getSubTask()%></td>
                                        <td class="text-center">
                                            <%if (tracking.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" value="Complete" Checked disabled>
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" value="Complete" disabled>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%}
                                        }
                                        if (main.getMainTask().equals("Project")) {
                                            List<projectProgress> module = projectProgressDao.getModuleTrackingByProjectID(project.getProjectID());
                                            for (projectProgress m : module) {
                                    %>
                                    <tr>
                                        <td class="col-9"><%=m.getModule()%></td>
                                        <td class="text-center">
                                            <%if (m.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" value="Complete" Checked disabled>
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" value="Complete" disabled>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%}
                                        }
                                        double percentage = (taskChecked / i) * 100;
                                        Double p = new Double(percentage);
                                        if (!p.isNaN()) {
                                    %>
                                </tbody>
                                <tr>
                                    <td style="border-bottom-style: none"></td>
                                    <th style="border-bottom-style: none"><%=String.format("%.2f", percentage)%>%</th>
                                </tr>
                                <%}%>
                            </table>                            
                        </div>
                        <%}%>

                        <div class="enroll-con d-flex justify-content-between">
                            <div class="col-3 bgColor p-2 m-2 rounded text-white text-center">
                                <span class="h5">Overall Percentage: </span>
                                <span class="h5"><%=project.getProjectProgress()%>%</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <object data="${pdfContainer}" type="application/pdf" width="100%" height="600px">
                <p>Unable to display PDF</p>
            </object>
        </div>
    </body>
</html>
