<%-- 
    Document   : svMainPage
    Created on : Nov 10, 2022, 6:10:12 AM
    Author     : YI YIN
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dao.*"%>
<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <body>
        <%
            user user = (user) session.getAttribute("login");
            user e = (user) userDao.getUserByID(user.getUserID());
            List<user> Student = userDao.getStudentByGroup(e.getGroupNo());

            List<meeting> upcomingMeet = meetingDao.getUpcomingMeetBySvID(e.getSvID());

            SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");
            Date date = d.parse(d.format(new Date()));
        %>
        <jsp:include page="navBar.jsp"/>

        <div class="container">            

            <div class="row">
                <div class="col-2">
                    <p class="userName">GROUP NO:</p>
                </div>
                <div class="col-1">
                    <p class="userName"><%=e.getGroupNo()%></p>
                </div>
            </div>
            <div class="row">
                <div class="col-2">
                    <p class="userName">GROUP LINK:</p>
                </div>
                <div class="col">
                    <%if (e.getGroupLink() == null || e.getGroupLink().isEmpty()) {%>
                    <p class="text-danger">Link of Group Chat Haven't Added.</p>
                    <%} else {%>
                    <a class="userName a-link" href="<%=e.getGroupLink()%>"><%=e.getGroupLink()%></a>
                    <%}%>
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
                            <%
                                List<meeting> dayDetails = meetingDao.getUpcomingMeetByDateSvID(m.getMeetDate(), e.getSvID());
                                for (meeting days : dayDetails) {
                            %>
                            <p class="pt-2 pb-0 border-bottom small-shadow"><%=days.getMeetTime()%> - <%=days.getMeetLocate()%></p>

                            <%
                                List<appointment> meetDetails = appointmentDao.getListAppointByMeetID(days.getMeetID());
                                for (appointment details : meetDetails) {
                                    user stu = userDao.getStudentDetail(details.getMatricNo());
                            %>
                            <p><%=stu.getName()%></p>
                            <%}
                                }%>
                        </div>
                    </div>
                    <%}
                        }%>
                </div>

                <div class="col">
                    <div class="section-title">
                        <h2 class="text-center">List of Students</h2>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th rowspan="2">Matric No.</th>
                                <th rowspan="2">Course Name</th>
                                <th rowspan="2">Program</th>
                                <th rowspan="2">Sem</th>
                                <th rowspan="2">Student Name</th>
                                <th rowspan="2">Meeting Frequencies</th>
                                <th rowspan="2">Progress (%)</th>
                                <th colspan="2" class="text-center">Eligibility</th>
                                <th rowspan="2">Action</th>
                            </tr>
                            <tr>
                                <th>Presentation</th>
                                <th>Report</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (user stu : Student) {
                                    int mFrequency = logbookDao.getMeetingFrequency(stu.getMatricNo());

                                    double totalOM = assessmentDao.getAssessCompTotalMark("Observation", stu.getCrsName());
                                    double stuOM = assessmentDao.getStuAssessCompMark("Observation", stu.getMatricNo());

                                    double totalPM = assessmentDao.getAssessCompTotalMark("Presentation", stu.getCrsName());
                                    evaluation stuPM = assessmentDao.getStuPresentAssessAVGByMatricNoID(stu.getMatricNo());

                                    double OM = (stuOM / totalOM) * 100;
                                    double CM = ((stuOM + stuPM.getStuAssessCompMark()) / (totalOM + totalPM)) * 100;

                                    String presentEligibility = "InEligible", reportEligibility = "InEligible";
                                    if (OM >= 50 && mFrequency >= 5) {
                                        presentEligibility = "Eligible";
                                    }
                                    if (CM >= 45 && mFrequency >= 5) {
                                        reportEligibility = "Eligible";
                                    }

                                    project project = projectDao.getProjectByMatricNo(stu.getMatricNo());
                            %>
                            <tr>
                                <td><%=stu.getMatricNo()%></td>
                                <td><%=stu.getCrsName()%></td>
                                <td><%=stu.getPgm()%></td>
                                <td><%=stu.getSem()%></td>
                                <td><%=stu.getName()%></td>
                                <td class="text-center"><%=mFrequency%></td>

                                <%if (project.getProjectID() == 0) {%>
                                <td>0</td>
                                <%} else {%>
                                <td><%=project.getProjectProgress()%></td>
                                <%}%>


                                <%if (presentEligibility.equals("Eligible")) {%>
                                <td><%=presentEligibility%></td>
                                <%} else {%>
                                <td class="text-danger"><%=presentEligibility%></td>
                                <%}%>

                                <%if (reportEligibility.equals("Eligible")) {%>
                                <td> <%=reportEligibility%></td>
                                <%} else {%>
                                <td class="text-danger"> <%=reportEligibility%></td>
                                <%}%>


                                <td class="text-center"><a href="svStuDetail.jsp?stuUserID=<%=stu.getUserID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>
