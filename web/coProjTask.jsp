<%-- 
    Document   : coProjTask
    Created on : Apr 16, 2023, 3:18:39 AM
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
        List<projectProgress> mainTaskI = projectProgressDao.getMainTaskByCourseName("FYP I");
        List<projectProgress> mainTaskII = projectProgressDao.getMainTaskByCourseName("FYP II");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-start">Project's Task</h2>
                <h6 class="text-danger text-center">${addError}${updateError}${deleteError}</h6>
            </div>

            <div class="p-2">
                <div class="enroll-con d-flex justify-content-between align-items-center">
                    <h4 class="fw-bold">FYP I</h4>
                    <a href="coProjTaskManage.jsp?action=Add&courseName=FYPI"><button class="btn btn-primary addBtn">Add Main Task</button></a>
                </div>

                <div class="row border border-dark lightYellow">
                    <%for (projectProgress main : mainTaskI) {
                            List<projectProgress> subTask = projectProgressDao.getSubTaskByMainTaskID(main.getMainTaskID());
                    %>
                    <div class="col">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th><%=main.getMainTask()%></th>
                                    <td><a href="coProjTaskManage.jsp?action=Update&courseName=FYP I&mainTaskID=<%=main.getMainTaskID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                    <td>
                                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                                    href = 'ProjectProgressServlet?action=DELETEMAIN&mainTaskID=<%=main.getMainTaskID()%>';
                                                else
                                                    return false;">
                                            <i class="bi bi-trash-fill text-danger"></i>
                                        </a>
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (projectProgress sub : subTask) {%>
                                <tr><td colspan="3"><%=sub.getSubTask()%></td></tr>
                                    <%}%>
                            </tbody>
                        </table>
                    </div>
                    <%}%>
                </div>
            </div>

            <div class="mt-1 p-2">
                <div class="enroll-con d-flex justify-content-between align-items-center">
                    <h4 class="fw-bold">FYP II</h4>
                    <a href="coProjTaskManage.jsp?action=Add&courseName=FYPII"><button class="btn btn-primary addBtn">Add Main Task</button></a>
                </div>

                <div class="row border border-dark lightBlue">
                    <%for (projectProgress main : mainTaskII) {
                            List<projectProgress> subTask = projectProgressDao.getSubTaskByMainTaskID(main.getMainTaskID());
                    %>
                    <div class="col">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th><%=main.getMainTask()%></th>
                                    <td><a href="coProjTaskManage.jsp?action=Update&courseName=FYP II&mainTaskID=<%=main.getMainTaskID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                    <td>
                                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                                    href = 'ProjectProgressServlet?action=DELETEMAIN&mainTaskID=<%=main.getMainTaskID()%>';
                                                else
                                                    return false;">
                                            <i class="bi bi-trash-fill text-danger"></i>
                                        </a>
                                    </td>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (projectProgress sub : subTask) {%>
                                <tr>
                                    <td colspan="3"><%=sub.getSubTask()%></td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                    <%}%>
                </div>
            </div>
        </div>
    </body>
</html>
