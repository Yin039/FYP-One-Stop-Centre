<%-- 
    Document   : coUserManage
    Created on : Nov 10, 2022, 5:53:14 AM
    Author     : YI YIN
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
        String type = request.getParameter("type");

        List<user> Supervisor = userDao.getAllUser("Supervisor");
        List<user> Student = userDao.getAllUser("Student");
        List<user> Officer = userDao.getAllUser("Officer");

        String svUserID = request.getParameter("svUserID");
        String stuUserID = request.getParameter("stuUserID");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">

            <%if (type.equals("Supervisor") && svUserID == null) {%>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-start">List of Supervisor</h2>

                <div class="d-flex justify-content-end">
                    <a href="coUserAdd.jsp?type=Supervisor"><button class="btn btn-primary addBtn">Add Supervisor</button></a>

                    <form method="post" action="UserServlet?action=ENROLL&userType=Supervisor"enctype="multipart/form-data">
                        <div class="input-group">
                            <div class="custom-file">
                                <input name="excel" type="file"  accept=".csv, application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" class="custom-file-input" placeholder="Choose File">
                            </div>
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="submit">Enroll</button>
                            </div>
                        </div>
                        <p class="text-warning ps-2">only accept Excel file type</p>
                    </form>
                </div>
            </div>

            <div class="section-title">
                <h6 class="text-danger text-start">${enrollError}${deleteError}</h6>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th class="text-center">Group</th>
                        <th>Supervisor</th>
                        <th class="text-center">FYP I</th>
                        <th class="text-center">FYP II</th>
                        <th class="text-center">Total</th>
                        <th class="text-center" colspan="3">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (user e : Supervisor) {
                            int fyp1 = userDao.getNumberStuFYP1BySV(e.getSvID());
                            int fyp2 = userDao.getNumberStuFYP2BySV(e.getSvID());
                    %>
                    <tr>
                        <td class="text-center"><%=e.getGroupNo()%></td>
                        <td><%=e.getSvName()%></td>
                        <td class="text-center"><%=fyp1%></td>
                        <td class="text-center"><%=fyp2%></td>
                        <td class="text-center"><%=fyp1 + fyp2%></td>
                        <td  class="text-center"><a href="coUserGroup.jsp?svUserID=<%=e.getUserID()%>"><i class="bi bi-people-fill icon-color"></i></a></td>
                        <td  class="text-center"><a href="coUserManage.jsp?svUserID=<%=e.getUserID()%>&type=Supervisor"><i class="bi bi-eye-fill icon-color"></i></a></td>
                        <td  class="text-center"><a href="coUserUpdate.jsp?userID=<%=e.getUserID()%>&type=Supervisor"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                        <td  class="text-center">
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'UserServlet?action=DELETE&id=<%=e.getUserID()%>&userType=Supervisor';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                <div class="form-popup">
                    <form action="UserServlet?action=EDIT" method="post">

                    </form>
                </div>
                <%}%>
                </tbody>
            </table>
            <%} else if (type.equals("Supervisor") && svUserID != null) {
                user sv = (user) userDao.getUserByID(Integer.parseInt(svUserID));
                List<user> groupList = userDao.getStudentByGroup(sv.getGroupNo());
            %>
            <div class="section-title">
                <h2 class="text-center">Group List</h2>
            </div>
            <table class="table table-borderless">
                <tr>
                    <th class="col-1">SUPERVISOR: </th>
                    <td><%=sv.getSvName()%></td>
                </tr>
                <tr>
                    <th class="col-1">GROUP NO: </th>
                    <td><%=sv.getGroupNo()%></td>
                </tr>
                <tr>
                    <th>EMAIL:</th>
                    <td><%=sv.getEmail()%></td>
                </tr>
                <tr>
                    <th>PHONE NO:</th>
                    <td><%=sv.getHP()%></td>
                </tr>                        
            </table>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Matric No.</th>
                        <th>Student Name</th>
                        <th>IC No.</th>
                        <th>HP No.</th>
                        <th>Program</th>
                        <th>Semester</th>
                        <th>Course Name</th>
                        <th class="text-center" colspan="2">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (user e : groupList) {%>
                    <tr>
                        <td><%=e.getMatricNo()%></td>
                        <td><%=e.getName()%></td>
                        <td><%=e.getIC()%></td>
                        <td><%=e.getHP()%></td>
                        <td><%=e.getPgm()%></td>
                        <td><%=e.getSem()%></td>
                        <td><%=e.getCrsName()%></td>
                        <td><a href="coUserManage.jsp?stuUserID=<%=e.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                        <td><a href="coUserUpdate.jsp?userID=<%=e.getUserID()%>&type=Student" class="nav-icon"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (type.equals("Student") && stuUserID == null) {
                String group = "Student Assigned";

                if (request.getParameter("group") != null) {
                    group = request.getParameter("group");
                }

                if (group.equals("Student Without Group")) {
                    Student = userDao.getStudentWithoutGroup();
                }

            %>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="text-start">List of Students</h2>
                    <div>
                        <select class="form-select lightBlue border-dark" name="status" onchange="window.location = 'coUserManage.jsp?type=Student&group=' + this.value">
                            <option value="<%=group%>" selected style="display:none;"><%=group%></option>
                            <option value="Student Assigned">Student Assigned</option>
                            <option value="Student Without Group">Student Without Group</option>
                        </select>
                    </div>
                </div>
                <div class="d-flex justify-content-end">
                    <a href="coUserAdd.jsp?type=Student"><button class="btn btn-primary addBtn">Add Student</button></a>

                    <form method="post" action="UserServlet?action=ENROLL&userType=Student"enctype="multipart/form-data">
                        <div class="input-group">
                            <div class="custom-file">
                                <input name="excel" type="file"  accept=".csv, application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" class="custom-file-input" placeholder="Choose File">
                            </div>
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="submit">Enroll</button>
                            </div>
                        </div>
                        <p class="text-warning ps-2">only accept Excel file type</p>
                    </form>
                </div>
            </div>

            <div class="section-title">
                <h6 class="text-danger text-center">${enrollError}${deleteError}</h6>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th class="text-center">Group</th>
                        <th>Matric No.</th>
                        <th>Student Name</th>
                        <th>Program</th>
                        <th class="text-center">Sem</th>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th  class="text-center" colspan="3">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (user e : Student) {%>
                    <tr>
                        <td class="text-center"><%=e.getGroupNo()%></td>
                        <td><%=e.getMatricNo()%></td>
                        <td><%=e.getName()%></td>
                        <td><%=e.getPgm()%></td>
                        <td class="text-center"><%=e.getSem()%></td>
                        <td><%=e.getCrsCode()%></td>
                        <td><%=e.getCrsName()%></td>
                        <td><a href="coUserManage.jsp?stuUserID=<%=e.getUserID()%>&type=Student"><i class="bi bi-eye-fill icon-color"></i></a></td>
                        <td><a href="coUserUpdate.jsp?userID=<%=e.getUserID()%>&type=Student" class="nav-icon"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                        <td>
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'UserServlet?action=DELETE&id=<%=e.getUserID()%>&userType=Student';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%} else if (type.equals("Student") && stuUserID != null) {
                user stu = (user) userDao.getUserByID(Integer.parseInt(stuUserID));
                project project = (project) projectDao.getProjectByMatricNo(stu.getMatricNo());
                List<appointment> approved = appointmentDao.getApprovedAppointByMatricNo(stu.getMatricNo());

                List<projectProgress> mainTask = projectProgressDao.getMainTaskByCourseName(stu.getCrsName());
                List<projectProgress> projectTrack = projectProgressDao.getTrackingByProjectID(project.getProjectID());
            %>
            <h2 class="text-center">Personal Information - <%=stu.getName()%> (<%=stu.getMatricNo()%>)</h2>
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

                <div class="row">
                    <%
                        double i = 0;

                        for (projectProgress main : mainTask) {
                            double taskChecked = 0;
                    %>
                    <div class="col">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th><%=main.getMainTask()%></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (projectProgress tracking : projectTrack) {
                                        if (tracking.getMainTaskID() == main.getMainTaskID()) {
                                            i++;
                                %>
                                <tr>
                                    <td><%=tracking.getSubTask()%></td>
                                    <td>
                                        <div class="form-check">
                                            <%if (tracking.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" value="Complete" Checked disabled>
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" value="Complete" disabled>
                                            <%}%>
                                        </div>
                                    </td>
                                </tr>
                                <%}
                                    }
                                    if (main.getMainTask().equals("Project")) {
                                        List<projectProgress> module = projectProgressDao.getModuleTrackingByProjectID(project.getProjectID());
                                        for (projectProgress m : module) {
                                %>
                                <tr>
                                    <td><%=m.getModule()%></td>
                                    <td>
                                        <div class="form-check">
                                            <%if (m.getTrackStatus().equals("Complete")) {
                                                    taskChecked++;
                                            %>
                                            <input class="form-check-input" type="checkbox" value="Complete" Checked disabled>
                                            <%} else {%>
                                            <input class="form-check-input" type="checkbox" value="Complete" disabled>
                                            <%}%>

                                        </div>
                                    </td>
                                </tr>
                                <%}
                                    }
                                    double percentage = (taskChecked / i) * 100;
                                    Double p = new Double(percentage);
                                    if (!p.isNaN()) {
                                %>
                            <thead>
                            <td style="border-bottom-style: none"></td>
                            <th style="border-bottom-style: none"><%=String.format("%.2f", percentage)%>%</th>
                            </thead>

                            <%}%>
                            </tbody>
                        </table>
                    </div>
                    <%}%>
                </div>

                <div class="enroll-con d-flex justify-content-between">
                    <div class="col-3 bgColor p-2 m-2 rounded text-white text-center">
                        <span class="h5">Overall Percentage: </span>

                        <%if (project.getProjectID() != 0) {%>
                        <span class="h5"><%=project.getProjectProgress()%>%</span>
                        <%} else {%>
                        <span class="h5">0%</span>
                        <%}%>
                    </div>
                </div>
            </div>

            <div class="border px-2 mb-5" style="background-color:#e6fcf5">
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

                                if (lb.getLogValidate().equals("Valid")) {
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
                            <td class="text-center"><a href="logBookManage.jsp?meetID=<%=a.getMeetID()%>&action=View&logID=<%=lb.getLogID()%>&user=Coordinator"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%}%>
                        </tr>
                        <%}%>
                    </tbody>
                    <thead>
                    <th colspan="5">Meeting Frequency: <%=mFrequency%></th>
                    </thead>
                </table>
            </div>
            <%} else if (type.equals("Officer")) {%>
            <div class="section-title">
                <h2 class="text-start">List of Vocational Officers</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>HP No.</th>
                        <th>Email</th>
                        <th class="text-center">Login Validation Status</th>
                        <th class="text-center">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (user e : Officer) {%>
                    <tr>
                        <td><%=e.getName()%></td>
                        <td><%=e.getHP()%></td>
                        <td><%=e.getEmail()%></td>
                        <td class="text-center">
                            <a href="UserServlet?action=UPDATE&userType=Officer&userID=<%=e.getUserID()%>" class="a-link"><%=e.getOffLoginValid()%></a>
                        </td>
                        <td class="text-center">
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'UserServlet?action=DELETE&id=<%=e.getUserID()%>&userType=Officer';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
            <%}%>
        </div>
    </body>
</html>
