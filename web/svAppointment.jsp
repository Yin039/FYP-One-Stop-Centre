<%-- 
    Document   : svAppointment
    Created on : Apr 5, 2023, 7:57:08 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        List<appointment> appoint = null;
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <div class="section-title">
                <h6 class="text-danger text-center">${updateAppointError}</h6>
            </div>

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">List of Appointments</h2>

                <form method="post">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search by Matric No."/>
                        <input type="submit" value="Search" class="btn btn-primary"/>
                    </div>
                </form>
            </div>

            <table class="table table-hover" id="myTable">
                <thead>
                    <tr>
                        <th>Matric No</th>
                        <th>Student Name</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th>Appointment Status</th>
                        <th class="text-center"colspan='3'>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String search = request.getParameter("search");

                        if (search == null) {
                            appoint = appointmentDao.getAppointBySvID(e.getSvID());
                        } else {
                            appoint = appointmentDao.searchAppointByMatricNo(e.getSvID(), search);
                        }

                        for (appointment a : appoint) {
                            Date date = new Date();

                            user student = userDao.getStudentDetail(a.getMatricNo());
                            meeting m = meetingDao.getMeetByID(a.getMeetID());

                            String logValidate = a.getAppointVerify();
                    %>
                    <%if (m.getMeetDate().after(date)) {%>
                    <tr>
                        <%} else {%>
                    <tr class="text-secondary">
                        <%}%>
                        <td><%=a.getMatricNo()%></td>
                        <td><%=student.getName()%></td>
                        <td><%=m.getMeetDate()%></td>
                        <td><%=m.getMeetTime()%></td>
                        <td><%=m.getMeetMode()%></td>
                        <td><%=m.getMeetLocate()%></td>
                        <%if (logValidate.equals("Approved")) {%>
                        <td class="text-warning"><%=logValidate%></td>
                        <%} else if (logValidate.equals("Rejected")) {%>
                        <td class="text-danger"><%=logValidate%></td>
                        <%} else {%>
                        <td><%=logValidate%></td>
                        <%}%>
                        
                        <%if (m.getMeetDate().after(date)) {%>
                    <td class="text-center"><a href="MeetingServlet?action=APPOINTSTATE&appointVerify=Approved&appointID=<%=a.getAppointID()%>&meetID=0"><i class="bi bi-check-circle-fill text-warning"></i></a></td>
                        <td class="text-center"><a href="MeetingServlet?action=APPOINTSTATE&appointVerify=Rejected&appointID=<%=a.getAppointID()%>&meetID=0"><i class="bi bi-x-circle-fill text-danger"></i></a></td>
                        <%} else {%>
                    <td class="text-center"><i class="bi bi-check-circle-fill text-warning" style="color: #bdbebf"></i></a></td>
                        <td class="text-center"><i class="bi bi-x-circle-fill text-danger" style="color: #bdbebf"></i></a></td>
                        <%}%>
                        
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>


    </body>
    <script>
        function myFunction() {
            // Declare variables
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("myInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("myTable");
            tr = table.getElementsByTagName("tr");

            // Loop through all table rows, and hide those who don't match the search query
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0];
                if (td) {
                    txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }

            table.reload();
        }
    </script>
</html>
