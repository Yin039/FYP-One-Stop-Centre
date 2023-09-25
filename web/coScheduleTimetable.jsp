<%-- 
    Document   : coScheduleTimtable
    Created on : Mar 29, 2023, 7:06:47 AM
    Author     : TEOH YI YIN
--%>

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
        List<String> FYPI = scheduleDao.getCourseCodeByName("FYP I");
        List<String> FYPII = scheduleDao.getCourseCodeByName("FYP II");

        List<schedule> schedule = scheduleDao.getSchedule();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-center">SEM 1 2022/23</h2>
                <a href="coFYPCourseUpdate.jsp"><button class="btn btn-primary addBtn">Update Course Code</button></a>
            </div>

            <div class="row">
                <div class="col-3"></div>

                <div class="col-6">
                    <h5 class="text-center bg-light p-2 m-0 border border-black ">COURSE CODE</h5>
                    <div class="enroll-con d-flex justify-content-center">

                        <div class="col">
                            <h5 class="text-center yellow p-2 m-0">FYP I</h5>
                            <%for (String fypI : FYPI) {%>
                            <p class="text-center border border-black p-2 m-0"><%=fypI%></p>
                            <%}%>
                        </div>

                        <div class="col">
                            <h5 class="text-center blue p-2 m-0">FYP II</h5>
                            <%for (String fypII : FYPII) {%>
                            <p class="text-center border border-black p-2 m-0"><%=fypII%></p>
                            <%}%>
                        </div>
                    </div>
                </div>

                <div class="col-3"></div>
            </div>

            <div class="section-title">

                <h6 class="text-danger text-center">${addError}${deleteError}</h6>
            </div>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2>Schedule</h2>
                <a href="coScheduleManage.jsp?action=Add"><button class="btn btn-primary addBtn">Add Schedule</button></a>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Week</th>
                        <th>Date</th>
                        <th>Activity</th>
                        <th>Action</th>
                        <th colspan="3"></th>
                    </tr>
                </thead>
                <tbody>
                    <%for (schedule s : schedule) {%>
                    <tr>
                        <td><%=s.getWeek()%></td>

                        <%if (s.getDate() == null) {%>
                        <td></td>
                        <%} else {%>
                        <td><%=s.getDate()%></td>
                        <%}%>

                        <%
                            if (s.getMaterialID() != 0) {
                                if (s.getMaterialLink() == null) {
                        %>
                        <td><%=s.getActivity()%></td>
                            <%} else {%>
                        <td><a href="<%=s.getMaterialLink()%>" class="a-link"><%=s.getActivity()%></a></td>
                            <%}%>

                        <td><%=s.getAction()%></td>

                        <%if (s.getMaterialDoc() != null && s.getMaterialDoc().length > 0) {%>
                        <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=s.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                <%} else {%>
                        <td></td>
                        <%}%>

                        <td class="text-center"><a href="coScheduleMaterialManage.jsp?action=Update&materialID=<%=s.getMaterialID()%>"><i class="bi bi-file-earmark-arrow-up-fill icon-color"></i></a></td>
                                <%} else {%>
                        <td><%=s.getActivity()%></td>
                        <td><%=s.getAction()%></td>
                        <td></td>
                        <td class="text-center"><a href="coScheduleMaterialManage.jsp?action=Add&detailID=<%=s.getDetailID()%>"><i class="bi bi-file-earmark-plus-fill icon-color"></i></a></td>
                                <%}%>
                        <td class="text-center"><a href="coScheduleManage.jsp?detailID=<%=s.getDetailID()%>&action=Update"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                        <td class="text-center">
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'ScheduleServlet?action=DELETEDETAIL&detailID=<%=s.getDetailID()%>';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
