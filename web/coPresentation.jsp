<%-- 
    Document   : coPresentation
    Created on : May 21, 2023, 12:21:58 PM
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
        List<presentation> panelGroup = presentationDao.getPanelGroupList();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${updateError}${DeleteError}</h6>
            </div>

            <h2 class="text-start">Presentation Group</h2>
            <p><i class="mx-2 bi bi-star-fill icon-color"></i>-- Panel Leader</p>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>SV Group</th>
                        <th>Supervisor</th>
                        <th class="text-center">No. of Students</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] color = new String[]{"lightBlue", "lightYellow"};
                        int i = 0, j = 0, oldPanelGp = 0;
                        for (presentation p : panelGroup) {
                            user group = userDao.getSVGroupBySVID(p.getSvID());
                            if (p.getPanelGpNo() == oldPanelGp) {
                    %>
                    <tr>
                        <td><%=group.getGroupNo()%></td>
                        <td><%=group.getSvName()%></td>
                        <td class="text-center" colspan="2"><%=group.getNumber()%></td>

                        <%if (p.getPanelLeader().equals("No")) {%>
                        <td class="text-center"><a href="PresentationServlet?action=ASSIGNLEADER&panelID=<%=p.getPanelID()%>&panelGpNo=<%=p.getPanelGpNo()%>"><i class="bi bi-star icon-color"></i></a></td>
                                <%} else {%>
                        <td class="text-center"><a href="PresentationServlet?action=ASSIGNLEADER&panelID=<%=p.getPanelID()%>"><i class="bi bi-star-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%} else {
                        i++;
                        j = 0;
                        oldPanelGp = p.getPanelGpNo();
                    %>
                    <%if (i % 2 == 0) {%>
                    <tr class="<%=color[0]%>">
                        <%} else {%>
                    <tr class="<%=color[1]%>">
                        <%}%>

                        <th colspan="3"><%="Group " + p.getPanelGpNo()%></th>

                        <td class="text-center"><a href="coPresentationGroupManage.jsp?action=Update&panelGpNo=<%=p.getPanelGpNo()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>

                        <td class="text-start">
                            <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'PresentationServlet?action=DELETEGROUP&panelGpNo=<%=p.getPanelGpNo()%>';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                            </a>
                        </td>

                    </tr>

                    <tr>
                        <td><%=group.getGroupNo()%></td>
                        <td><%=group.getSvName()%></td>
                        <td class="text-center" colspan="2"><%=group.getNumber()%></td>

                        <%if (p.getPanelLeader().equals("No")) {%>
                        <td class="text-center"><a href="PresentationServlet?action=ASSIGNLEADER&panelID=<%=p.getPanelID()%>&panelGpNo=<%=p.getPanelGpNo()%>"><i class="bi bi-star icon-color"></i></a></td>
                                <%} else {%>
                        <td class="text-center"><a href="PresentationServlet?action=ASSIGNLEADER&panelID=<%=p.getPanelID()%>"><i class="bi bi-star-fill icon-color"></i></a></td>
                                <%}%>
                    </tr>
                    <%
                            }
                        }%>
                </tbody>
            </table>

            <div class="enroll-con d-flex justify-content-end">
                <a href="coPresentationGroupManage.jsp?action=Add"><button class="btn btn-primary addBtn">Generate Group</button></a>
            </div>
        </div>
    </body>
</html>


