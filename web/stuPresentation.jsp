<%-- 
    Document   : stuPresentation
    Created on : Jun 3, 2023, 10:46:29 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>FYP One Stop Centre - Student</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        int i = 0, j = 1;

        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        presentation panel = presentationDao.getPanelGroupBySvID(e.getSvID());

        List<presentation> panelGroup = presentationDao.getPanelGroupByPanelGpNoSvID(panel.getPanelGpNo(), e.getSvID());
        List<presentation> presentation = presentationDao.getPresentationListByGpNo(panel.getPanelGpNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">

            <h2>Presentation Details</h2>
            <p><i class="mx-2 bi bi-star-fill icon-color"></i>-- Panel Leader</p>

            <div>
                <table class="table">
                    <thead>
                        <%if (panel.getPanelID() == 0) {%>
                    <td colspan="3" class="text-danger">No Assigned Yet..!</td>
                    <%} else {%>
                    <tr>
                        <th class="text-end">PANEL GROUP NO: </th>
                        <td colspan="7"><%=panel.getPanelGpNo()%></td>
                    </tr>                    
                    <tr>
                        <th class="text-end">PANELS: </th>
                        <td colspan="7">
                            <span class="fw-bold">1.</span> <%=e.getSvName()%>
                            <%
                                presentation sv = presentationDao.getPanelGroupBySvID(e.getSvID());
                                if (sv.getPanelLeader().equals("Yes")) {%>
                            <i class="mx-2 bi bi-star-fill icon-color"></i>
                        </td>
                        <%}%>
                    </tr>
                    <%}%>

                    <%if (panelGroup.size() > 0) {
                            for (presentation p : panelGroup) {
                                j++;
                                user group = userDao.getSVGroupBySVID(p.getSvID());
                    %>
                    <tr>
                        <td></td>
                        <td colspan="7">     
                            <span class="fw-bold"><%=j%>.</span> <%=group.getSvName()%>
                            <%if (p.getPanelLeader().equals("Yes")) {%>
                            <i class="mx-2 bi bi-star-fill icon-color"></i>
                            <%}%>
                        </td>
                    </tr>
                    <%}
                        }%>
                    </thead>
                    <%if(presentation.size() > 0){
                        for (presentation p : presentation) {
                            i++;
                    %>
                    <thead>
                        <tr>
                            <th colspan="7" class="lightBlue">PRESENTATION <%=i%></th>
                        </tr>
                    </thead>
                    <tr>
                        <th class="text-end">DATE: </th>
                        <td><%=p.getPresentDate()%></td>
                        <th class="text-end">TIME: </th>
                        <td><%=p.getPresentStartTime()%> - <%=p.getPresentEndTime()%></td>
                    </tr>
                    <tr>
                        <th class="text-end">LOCATION: </th>
                        <td><%=p.getPresentLocate()%></td>
                        <th class="text-end">TOTAL STUDENTS: </th>
                        <td><%=p.getStuNum()%></td>
                    </tr>
                    <%}}%>
                </table>
            </div>
        </div>
    </body>
</html>




