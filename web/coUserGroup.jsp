<%-- 
    Document   : coUserGroup
    Created on : Jun 25, 2023, 5:36:07 AM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.ArrayList"%>
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
        int i = 0;

        String svUserID = request.getParameter("svUserID");
        user sv = (user) userDao.getUserByID(Integer.parseInt(svUserID));
        List<user> groupList = userDao.getStudentByGroup(sv.getGroupNo());
        List<user> Student = userDao.getStudentWithoutGroup();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">GROUPING</h2>
                <h6 class="text-danger text-center">${addError}</h6>
            </div>

            <table class="table table-borderless">
                <tr>
                    <th class="col-1">SUPERVISOR: </th>
                    <td><%=sv.getSvName()%></td>
                </tr>
                <tr>
                    <th class="col-1">GROUP NO: </th>
                    <td><%=sv.getGroupNo()%></td>
                </tr>                     
            </table>

            <div class="form">
                <form action="UserServlet?action=ADDGROUP" class="row" method="post">
                    <div class="row mb-3">
                        <%for (user stu : groupList) {%>
                        <div class="row justify-content-center align-items-center m-1">
                            <div class="col-5">
                                <span class="form-control"><%=stu.getName() + " (" + stu.getMatricNo() + ")"%></span>
                            </div>
                            <div class="col-1">
                                <a onclick="if (confirm('Are you sure you want to delete?'))
                                        href = 'UserServlet?action=DELETEGROUP&pairID=<%=stu.getPairID()%>&svUserID=<%=svUserID%>';
                                    else
                                        return false;">
                                <i class="bi bi-trash-fill text-danger"></i>
                                </a>
                            </div>
                        </div>
                        <%}
                            if (request.getParameter("count") != null) {
                                i = Integer.parseInt(request.getParameter("count"));
                                for (int j = 0; j < i; j++) {
                        %>
                        <div class="row justify-content-center align-items-center m-1">
                            <div class="col-5">
                                <select class="form-select" name="matricNo<%=j%>">
                                    <%
                                        for (user stu : Student) {
                                            if (stu.getUserID() == 0) {
                                    %>
                                    <option>All Students Are Assigned</option>
                                    <%} else {%>
                                    <option value="<%=stu.getMatricNo()%>"><%=stu.getName() + " (" + stu.getMatricNo() + ")"%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>

                            <div class="col-1">
                                <a href='coUserGroup.jsp?count=<%=i - 1%>&svUserID=<%=svUserID%>'><i class="bi bi-trash-fill text-danger"></i></a>
                            </div>
                        </div>
                        <%}
                            }%>

                        <div class="row justify-content-center">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='coUserGroup.jsp?count=<%=i + 1%>&svUserID=<%=svUserID%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>

                        <input type="hidden" name="count" value="<%=i%>">
                        <input type="hidden" name="svUserID" value="<%=svUserID%>">
                        <input type="hidden" name="svID" value="<%=sv.getSvID()%>">
                        <input type="hidden" name="groupNo" value="<%=sv.getGroupNo()%>">

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="coUserManage.jsp?type=Supervisor" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
