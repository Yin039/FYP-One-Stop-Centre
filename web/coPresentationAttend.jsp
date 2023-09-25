<%-- 
    Document   : coPresentationAttend.jsp
    Created on : Jun 15, 2023, 2:18:45 AM
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
        int[] present = new int[2], absent = new int[2];

        List<presentation> presentation = presentationDao.getPresentationList();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <h2>Presentation Attendance List</h2>

            <table class="table table-hover table-striped">
                <thead>
                    <tr>
                        <th>Panel Group No.</th>
                        <th>Presentation I</th>
                        <th>Presentation II</th>
                    </tr>
                </thead>
                <tbody>
                    <%for (presentation p : presentation) {
                            int i = 0;
                            List<presentation> presentDetails = presentationDao.getPresentationListByGpNo(p.getPanelGpNo());
                    %>
                    <tr>
                        <td>Group <%=p.getPanelGpNo()%></td>
                        <%
                            for (presentation details : presentDetails) {
                                
                                int presentStu = presentationDao.getPresentStuNum(details.getPresentID());
                                present[i] += presentStu;

                                int ab = (details.getStuNum() - presentStu);
                                absent[i] += ab;
                        %>
                        <td><%=presentStu%>/<%=details.getStuNum()%></td>          
                        <%i++;}%>
                        <td><a href="coPresentationAttendDetail.jsp?panelGpNo=<%=p.getPanelGpNo()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%
                            i++;
                        }%>

                    <thead>
                        <th class="text-end">
                            Number of Student Present:
                            <br>
                            Number of Student Absent:
                        </th>

                        <%for (int j = 0; j < present.length; ++j) {%>

                        <th>
                            <%=present[j]%>
                            <br>
                            <%=absent[j]%>
                        </th>
                        <%}%>

                        <td></td>
                    </thead>
                </tbody>
            </table>
        </div>
    </body>
</html>
