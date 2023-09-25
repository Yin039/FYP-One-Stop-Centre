<%-- 
    Document   : coPresentationAttendDetail
    Created on : Jun 15, 2023, 2:37:51 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        int[] letter = new int[2], absent = new int[2];

        int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

        List<presentation> panelGroup = presentationDao.getPanelGroupByPanelGpNo(panelGpNo);
        List<presentation> presentation = presentationDao.getPresentationListByGpNo(panelGpNo);
        List<presentation> stuPresentList = presentationDao.getStuPresentationListByGpNo(panelGpNo);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <h2 class="text-start mx-2">Presentation Attendance (Group <%=panelGpNo%>)</h2>

            <div class="row col-5 mx-2">
                <table class="table">
                    <tr>
                        <th>PANELS: </th>
                    </tr>
                    <%
                        for (presentation group : panelGroup) {
                            user g = userDao.getSVGroupBySVID(group.getSvID());
                    %>
                    <tr>
                        <td>
                            <%=g.getSvName()%>
                            <%if (group.getPanelLeader().equals("Yes")) {%>
                            <i class="mx-2 bi bi-star-fill icon-color"></i>
                            <%}%>
                        </td>
                    </tr>
                    <%}%>
                </table>
                <p><i class="mx-2 bi bi-star-fill icon-color"></i>-- Panel Leader</p>
            </div>

            <div class="row">
                <div class="col">
                    <table class="table table-striped table-hover table-bordered border-dark mx-2">
                        <thead>
                            <tr>
                                <th>Student Name (Matric No)</th>
                                    <%
                                        for (presentation p : presentation) {
                                            int attendStu = presentationDao.getPresentStuNum(p.getPresentID());
                                    %>
                                <td><span class="fw-bold">DATE: </span><%=p.getPresentDate()%></td>
                                <th class="text-end"><%=attendStu%>/<%=p.getStuNum()%></th>
                                    <%}%>
                            </tr>
                        </thead>
                        <tbody>
                            <%for (presentation student : stuPresentList) {
                                    int i = 0;
                                    user stu = userDao.getStudentDetail(student.getMatricNo());
                                    List<presentation> attandanceList = presentationDao.getPresentationAttendanceListByMatricNo(student.getMatricNo());
                            %>
                            <tr>
                                <td><%=stu.getName()%> (<%=student.getMatricNo()%>)</td>

                                <%for (presentation attend : attandanceList) {

                                %>
                                <td colspan="2" class="text-center">
                                    <%if (attend.getAttendStatus().equals("Absent")) {
                                            absent[i] += 1;
                                    %>
                                    <span class="text-danger"><%=attend.getAttendStatus()%></span>
                                    <%} else {
                                        if (attend.getAttendStatus().equals("Letter")) {
                                            letter[i] += 1;
                                        }
                                    %>
                                    <%=attend.getAttendStatus()%>
                                    <%}%>
                                </td>
                                <%
                                        ++i;
                                    }%>
                            </tr>
                            <%}%>
                            <tr>
                                <th class="text-end">
                                    Number of Student Absent:
                                    <br>
                                    Number of Student Absent with Letter:
                                </th>

                                <%for (int i = 0; i < absent.length; ++i) {%>
                                <th class="text-end" colspan="2">
                                    <%=absent[i]%>
                                    <br>
                                    <%=letter[i]%>
                                </th>
                                <%}%>
                            <tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="row">

            </div>
        </div>
    </body>
</html>
