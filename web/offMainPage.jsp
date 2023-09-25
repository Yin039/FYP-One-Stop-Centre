<%-- 
    Document   : offMainPage
    Created on : Nov 10, 2022, 6:10:12 AM
    Author     : YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.presentationDao"%>
<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Vocational Officer</title>
        <jsp:include page="head.html"/>
    </head>
    <body>
        <%
            user user = (user) session.getAttribute("login");
            user e = (user) userDao.getUserByID(user.getUserID());

            List<presentation> location = presentationDao.getLocationList();
            List<presentation> presentation = presentationDao.getPresentationList();
        %>
        <jsp:include page="navBar.jsp"/>
        <div class="container" data-aos="fade-up">

            <div class="enroll-con d-flex justify-content-between align-items-center">
                <div class="section-title">
                    <h2 class="text-start">List of Locations</h2>
                    <h6 class="text-danger text-center">${addError}</h6>
                </div>

                <div class="text-end">
                    <a href="offPresentationManage.jsp?action=Manage"><button class="btn btn-primary addBtn">Manage Location</button></a>
                </div>
            </div>



            <table class="table">
                <thead>
                    <tr>
                        <th>Location</th>
                        <th>Validation</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (presentation l : location) {%>
                    <tr>
                        <td><%=l.getPresentLocate()%></td>

                        <%if (l.getPresentLocateValid().equals("Invalid")) {%>
                        <td class="text-danger"><%=l.getPresentLocateValid()%></td>
                        <%} else {%>
                        <td><%=l.getPresentLocateValid()%></td>
                        <%}%>

                    </tr>
                    <%}%>
                </tbody>
            </table>

            <div class="section-title">
                <h2 class="text-start">Presentation Schedule</h2>
                <h6 class="text-danger">${updateError}</h6>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Remark</th>
                        <th class="text-center">Location Validation</th>
                        <th class="text-center">Preparing Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] color = new String[]{"lightBlue", "lightYellow"};
                        int i = 0;
                        for (presentation p : presentation) {
                            i++;
                            List<presentation> presentDetails = presentationDao.getPresentationListByGpNo(p.getPanelGpNo());
                    %>
                    <%if (i % 2 == 0) {%>
                    <tr class="<%=color[1]%>">
                        <%} else {%>
                    <tr class="<%=color[0]%>">
                        <%}%>

                        <th colspan="6">Group <%=p.getPanelGpNo()%> - <%=p.getPresentLocate()%></th>
                    </tr>

                    <%for (presentation details : presentDetails) {%>
                    <tr>
                        <td><%=details.getPresentDate()%></td>
                        <td><%=details.getPresentStartTime()%> - <%=details.getPresentEndTime()%></td>
                        <td><%=details.getPresentRemark()%></td>

                        <%if (details.getPresentLocateValid().equals("Invalid")) {%>
                        <td class="text-danger text-center"><%=details.getPresentLocateValid()%></td>
                        <%} else {%>
                        <td class="text-center"><%=details.getPresentLocateValid()%></td>
                        <%}%>

                        <%if (details.getPresentSetUp().equals("Done")) {%>
                        <td class="text-center"><%=details.getPresentSetUp()%></td>
                        <%} else {%>
                        <td class="text-danger text-center"><%=details.getPresentSetUp()%></td>
                        <%}%>

                        <td class="text-center"><a href="offPresentationManage.jsp?action=Update&presentID=<%=details.getPresentID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    </tr>
                    <%}
                        }%>
                </tbody>
            </table>

        </div>
    </body>
</html>
