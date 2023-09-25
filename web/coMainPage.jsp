<%-- 
    Document   : coMainPage
    Created on : Nov 10, 2022, 6:10:12 AM
    Author     : YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.model.user"%>
<%@page import="com.dao.userDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        List<user> SV = userDao.getAllUser("Supervisor");

        List<user> stuNumCrsCode = userDao.getNumberStuBasedFYP();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-start">SEM 1 2022/23</h2>
            </div>

            <table class="table table-bordered mb-5 mt-2">
                <tbody>
                    <tr>
                        <th colspan="6" class="text-center bg-light">NUMBER OF STUDENTS</th>
                    </tr>
                    <tr>
                        <th colspan="3" class="text-center yellow">FYP I</th>
                        <th colspan="3" class="text-center blue">FYP II</th>
                    </tr>
                    <tr class="text-center">
                        <%for (user stuNum : stuNumCrsCode) {
                                if (stuNum.getCrsName().equals("FYP I")) {%>
                        <th><%=stuNum.getCrsCode()%></th>
                            <%}
                                }%>
                            <%for (user stuNum : stuNumCrsCode) {
                                    if (stuNum.getCrsName().equals("FYP II")) {%>
                        <th><%=stuNum.getCrsCode()%></th>
                            <%}
                                }%>
                    </tr>
                    <tr class="text-center">
                        <%for (user stuNum : stuNumCrsCode) {
                                if (stuNum.getCrsName().equals("FYP I")) {%>
                        <td class="lightYellow"><%=stuNum.getNumber()%></td>
                        <%}
                            }%>
                        <%for (user stuNum : stuNumCrsCode) {
                                if (stuNum.getCrsName().equals("FYP II")) {%>
                        <td class="lightBlue"><%=stuNum.getNumber()%></td>
                        <%}
                            }%>
                    </tr>
                </tbody>
            </table>

            <div class="section-title">
                <h2 class="text-start">SUPERVISION</h2>
            </div>

            <table class="table table-hover text-center">
                <thead>
                    <tr>
                        <th>Group</th>
                        <th class="text-start">Supervisor</th>
                        <th>FYP I</th>
                        <th>FYP II</th>
                        <th>Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (user e : SV) {
                            int fyp1 = userDao.getNumberStuFYP1BySV(e.getSvID());
                            int fyp2 = userDao.getNumberStuFYP2BySV(e.getSvID());
                    %>
                    <tr>
                        <td><%=e.getGroupNo()%></td>
                        <td class="text-start"><%=e.getSvName()%></td>
                        <td><%=fyp1%></td>
                        <td><%=fyp2%></td>
                        <td><%=fyp1 + fyp2%></td>
                        <td><a href="coUserManage.jsp?svUserID=<%=e.getUserID()%>&type=Supervisor"><i class="bi bi-eye-fill icon-color"></i></a></td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
