<%-- 
    Document   : svStuDetail
    Created on : Apr 5, 2023, 8:08:13 PM
    Author     : user
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String stuUserID = request.getParameter("stuUserID");

        user stu = (user) userDao.getUserByID(Integer.parseInt(stuUserID));
        project project = (project) projectDao.getProjectByMatricNo(stu.getMatricNo());
        List<appointment> approved = appointmentDao.getApprovedAppointByMatricNo(stu.getMatricNo());

        List<projectProgress> mainTask = projectProgressDao.getMainTaskByCourseName(stu.getCrsName());
        List<projectProgress> projectTrack = projectProgressDao.getTrackingByProjectID(project.getProjectID());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <h2 class="text-center"><%=stu.getName()%> (<%=stu.getMatricNo()%>)</h2>
            <table class="table mt-3">
                <tr>
                    <th colspan="1" class="text-end">EMAIL: </th>
                    <td colspan="6"><%=stu.getEmail()%></td>
                    <th colspan="1" class="text-end">PHONE NO: </th>
                    <td colspan="4"><%=stu.getHP()%></td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">GROUP NO: </th>
                    <td colspan="2"><%=stu.getGroupNo()%></td>
                    <th colspan="1" class="text-end">SUPERVISOR: </th>
                    <td colspan="8"><%=stu.getSvName()%></td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">PROGRAMME: </th>
                    <td colspan="11"><%=stu.getPgm()%></td>
                </tr>
                <tr>
                    <th colspan="1" class="text-end">SEMESTER: </th>
                    <td colspan="2"><%=stu.getSem()%></td>
                    <th colspan="2" class="text-end">COURSE CODE: </th>
                    <td colspan="3"><%=stu.getCrsCode()%></td>
                    <th colspan="2" class="text-end">COURSE NAME: </th>
                    <td colspan="2"><%=stu.getCrsName()%></td>
                </tr>
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
                        <p class="text-danger">Project Haven't Register</p>
                        <%} else {%>
                        <%=project.getProjectTitle()%>
                        <%}%>
                    </td>
                </tr>
            </table>

            <div class="border px-2 mb-2 lightBlue">
                <div class="section-title">
                    <h2 class="text-start">Project Tracker</h2>
                    <h6 class="text-danger text-center">${updateError}</h6>
                </div>

                <form action="ProjectProgressServlet?action=UPDATETRACK" method="post">
                    <div class="row">
                        <%
                            double i = 0;
                            for (projectProgress main : mainTask) {
                                projectProgress submission = projectProgressDao.getSubmitByIDs(main.getMainTaskID(), stu.getMatricNo());
                                i++;
                                int j = 0;
                                double taskChecked = 0;
                        %>
                        <div class="col">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th><%=main.getMainTask()%></th>
                                        <td class="text-end  col-6">
                                            <%if (submission.getSubmitID() != 0) {%>
                                            <a class="me-1" href="ProjectProgressServlet?action=VIEWSUBMIT&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-eye-fill icon-color"></i></a>
                                            <a class="me-1" href="ProjectProgressServlet?action=DOWNLOAD&submitID=<%=submission.getSubmitID()%>"><i class="bi bi-download icon-color"></i></a>
                                                <%}%>
                                                <%if (main.getMainTask().equals("Project")) {%>
                                            <a href="svProjTaskManage.jsp?stuUserID=<%=stuUserID%>&projectID=<%=project.getProjectID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a>
                                                <%}%>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%for (projectProgress tracking : projectTrack) {
                                            if (tracking.getMainTaskID() == main.getMainTaskID()) {
                                                j++;
                                    %>
                                    <tr>
                                        <td class="col-9"><%=tracking.getSubTask()%></td>
                                        <td class="text-center">
                                            <input type="hidden" name="trackID<%=main.getMainTask()%><%=(int) j%>" value="<%=tracking.getTrackID()%>">

                                            <%if (tracking.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" name="trackStatus<%=main.getMainTask()%><%=(int) j%>" value="Complete" Checked>
                                            <input type="hidden" name="trackStatus<%=main.getMainTask()%><%=(int) j%>" value="Incomplete">
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" name="trackStatus<%=main.getMainTask()%><%=(int) j%>" value="Complete">
                                            <input type="hidden" name="trackStatus<%=main.getMainTask()%><%=(int) j%>" value="Incomplete">
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%}
                                        }
                                        if (main.getMainTask().equals("Project")) {
                                            List<projectProgress> module = projectProgressDao.getModuleTrackingByProjectID(project.getProjectID());
                                            for (projectProgress m : module) {
                                                j++;
                                    %>
                                    <tr>
                                        <td class="col-9"><%=m.getModule()%></td>
                                        <td class="text-center">
                                            <input type="hidden" name="moduleTrackID<%=(int) j%>" value="<%=m.getModuleTrackID()%>">
                                            <input type="hidden" name="module<%=(int) j%>" value="<%=m.getModule()%>">

                                            <%if (m.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" name="moduleStatus<%=(int) j%>" value="Complete" Checked>
                                            <input type="hidden" name="moduleStatus<%=(int) j%>" value="Incomplete">
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" name="moduleStatus<%=(int) j%>" value="Complete">
                                            <input type="hidden" name="moduleStatus<%=(int) j%>" value="Incomplete">
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%}
                                        }
                                        double percentage = (taskChecked / j) * 100;
                                        Double p = new Double(percentage);
                                        if (!p.isNaN()) {
                                    %>
                                <thead>
                                <td style="border-bottom-style: none"></td>
                                <th style="border-bottom-style: none"><%=String.format("%.2f", percentage)%>%</th>
                                </thead>

                                <input type="hidden" name="subTaskCount<%=(int) i%>" value="<%=j%>">
                                <input type="hidden" name="mainTask<%=(int) i%>" value="<%=main.getMainTask()%>">
                                <%}%>
                                </tbody>
                            </table>
                        </div>
                        <%}%>
                    </div>

                    <input type="hidden" name="count" value="<%=(int) i%>">
                    <input type="hidden" name="stuUserID" value="<%=stuUserID%>">

                    <div class="enroll-con d-flex justify-content-between">
                        <div class="col-3 bgColor p-2 m-2 rounded text-white text-center">
                            <span class="h5">Overall Percentage: </span>
                            <span class="h5"><%=String.format("%.2f", project.getProjectProgress())%>%</span>
                            <input type="hidden" name="projectID" value="<%=project.getProjectID()%>">
                        </div>
                        <button type="submit" value="Submit" class="btn btn-primary addBtn">Update Tracker</button>
                    </div>
                </form>
            </div>

            <div class="border px-2 mb-5" style="background-color:#fbeee1">
                <div class="section-title">
                    <h2 class="text-start">List of LogBook</h2>
                </div>
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>Matric No.</th>
                            <th>Date</th>
                            <th>Timestamp</th>
                            <th class="text-center">LogBook Validation</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int mFrequency = 0;
                            for (appointment a : approved) {
                                meeting m = meetingDao.getMeetByID(a.getMeetID());
                                logbook lb = logbookDao.getLBByMatricNoMeetID(a.getMatricNo(), a.getMeetID());

                                if (lb.getLogID() != 0 && lb.getLogValidate().equals("Valid")) {
                                    mFrequency++;
                                }
                        %>
                        <tr>
                            <td><%=a.getMatricNo()%></td>
                            <td><%=m.getMeetDate()%></td>
                            <%if (lb.getLogID() == 0) {%>
                            <td class="text-danger" colspan="3">LogBook haven't fill in..!</td>
                            <%} else {%>
                            <td><%=lb.getTimestamp()%></td>
                            <%if (lb.getLogValidate().equals("Valid")) {%>
                            <td class="text-center"><%=lb.getLogValidate()%></td>
                            <%} else {%>
                            <td class="text-danger text-center"><%=lb.getLogValidate()%></td>
                            <%}%>
                            <td class="text-center"><a href="logBookManage.jsp?meetID=<%=a.getMeetID()%>&action=View&logID=<%=lb.getLogID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%}%>
                        </tr>
                        <%}%>
                    </tbody>
                    <thead>
                    <th colspan="5">Meeting Frequency: <%=mFrequency%></th>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
