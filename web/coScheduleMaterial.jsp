<%-- 
    Document   : coMaterial
    Created on : Apr 16, 2023, 1:26:43 AM
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
        List<schedule> manuals = scheduleDao.getMaterialByType("Manuals & Handbook");
        List<schedule> brief = scheduleDao.getMaterialByType("Briefing Materials");
        List<schedule> dissertation = scheduleDao.getMaterialByType("Sample Dissertations");
        List<schedule> templates = scheduleDao.getMaterialByType("Templates");
    %>
    <body>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>

            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${deleteError}</h6>
            </div>
            <div class="enroll-con d-flex justify-content-between align-items-center">
                <h2 class="text-start">Materials</h2>
                <a href="coScheduleMaterialManage.jsp?action=Add"><button class="btn btn-primary addBtn">Add Material</button></a>
            </div>

            <table class="table">
                <tr>
                    <th colspan="5" class="lightBlue">Manuals & Handbook</th>
                </tr>
                <%for (schedule m : manuals) {%>
                <tr>
                    <td>
                        <%if (m.getMaterialLink() == null) {%>
                        <%=m.getMaterialName()%>
                        <%} else {%>
                        <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                        <%}%>
                    </td>
                    <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                    <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                            <%} else {%>
                    <td></td>
                    <%}%>
                    <td class="text-center"><a href="coScheduleMaterialManage.jsp?materialID=<%=m.getMaterialID()%>&action=Update"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    <td class="text-center">
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'ScheduleServlet?action=DELETEMATERIAL&materialID=<%=m.getMaterialID()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </td>
                </tr>
                <%}%>
                <tr>
                    <th colspan="5" class="lightBlue">Briefing Materials</th>
                </tr>
                <%for (schedule m : brief) {%>
                <tr>
                    <td>
                        <%if (m.getMaterialLink() == null) {%>
                        <%=m.getMaterialName()%>
                        <%} else {%>
                        <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                        <%}%>
                    </td>
                        <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                    <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                            <%} else {%>
                    <td></td>
                    <%}%>
                    <td class="text-center"><a href="coScheduleMaterialManage.jsp?materialID=<%=m.getMaterialID()%>&action=Update"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    <td class="text-center">
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'ScheduleServlet?action=DELETEMATERIAL&materialID=<%=m.getMaterialID()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </td>
                </tr>
                <%}%>
                <tr>
                    <th colspan="5" class="lightBlue">Sample Dissertations</th>
                </tr>
                <%for (schedule m : dissertation) {%>
                <tr>
                    <td>
                        <%if (m.getMaterialLink() == null) {%>
                        <%=m.getMaterialName()%>
                        <%} else {%>
                        <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                        <%}%>
                    </td>
                        <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                    <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                            <%} else {%>
                    <td></td>
                    <%}%>
                    <td class="text-center"><a href="coScheduleMaterialManage.jsp?materialID=<%=m.getMaterialID()%>&action=Update"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    <td class="text-center">
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'ScheduleServlet?action=DELETEMATERIAL&materialID=<%=m.getMaterialID()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </td>
                </tr>
                <%}%>
                <tr>
                    <th colspan="5" class="lightBlue">Templates</th>
                </tr>
                <%for (schedule m : templates) {%>
                <tr>
                    <td>
                        <%if (m.getMaterialLink() == null) {%>
                        <%=m.getMaterialName()%>
                        <%} else {%>
                        <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                        <%}%>
                    </td>
                        <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                    <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                            <%} else {%>
                    <td></td>
                    <%}%>
                    <td class="text-center"><a href="coScheduleMaterialManage.jsp?materialID=<%=m.getMaterialID()%>&action=Update"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                    <td class="text-center">
                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                    href = 'ScheduleServlet?action=DELETEMATERIAL&materialID=<%=m.getMaterialID()%>';
                                else
                                    return false;">
                            <i class="bi bi-trash-fill text-danger"></i>
                        </a>
                    </td>
                </tr>
                <%}%>
            </table>
        </div>
    </body>
</html>
