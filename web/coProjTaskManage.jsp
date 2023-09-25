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
        String action = request.getParameter("action");
        String courseName = request.getParameter("courseName");

        int i = 1;
        int k = 0;

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        }
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Add")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD PROJECT'S TASK</h2>
            </div>

            <div class="form">
                <form action="ProjectProgressServlet?action=ADDTASK" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Main Task</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="mainTask" required/>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Sub Task</label>
                            <%for (int j = 1; j <= i; j++) {%>
                            <div id="row">
                                <div class="input-group m-3">
                                    <div class="input-group-prepend">
                                        <a href='coProjTaskManage.jsp?action=Add&count=<%=i - 1%>&courseName=<%=courseName%>'><button class="btn btn-danger" type="button" ><i class="bi bi-trash"></i>Delete</button></a>
                                    </div>
                                    <input type="text" class="form-control m-input" name='subTask<%=j%>'>
                                </div>
                            </div>
                            <%}%>

                            <a href='coProjTaskManage.jsp?action=Add&count=<%=i + 1%>&courseName=<%=courseName%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                        </div>
                    </div>

                    <input type="hidden" name="count" value="<%=i%>">
                    
                    <%if (courseName.equals("FYPI")) {%>
                    <input type="hidden" name="courseName" value="FYP I">
                    <%} else if (courseName.equals("FYPII")) {%>
                    <input type="hidden" name="courseName" value="FYP II">
                    <%}%>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coProjTask.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                i = 0;

                int mainTaskID = Integer.parseInt(request.getParameter("mainTaskID"));
                String mainTask = projectProgressDao.getMainTaskByID(mainTaskID);

                List<projectProgress> subTask = projectProgressDao.getSubTaskByMainTaskID(mainTaskID);
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE PROJECT'S TASK</h2>
                <h6 class="text-danger text-center">${deleteError}</h6>
            </div>

            <div class="form">
                <form action="ProjectProgressServlet?action=UPDATETASK" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Main Task</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input hidden="type" name="mainTaskID" value="<%=mainTaskID%>">
                                <input type="text" class="form-control" name="mainTask" value='<%=mainTask%>'/>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Sub Task</label>

                            <%for (projectProgress task : subTask) {
                                    k++;
                            %>
                            <div id="row">
                                <div class="input-group m-3">
                                    <div class="input-group-prepend">
                                        <a href='ProjectProgressServlet?action=DELETESUBTASK&subTaskID=<%=task.getSubTaskID()%>&mainTaskID=<%=mainTaskID%>'><button class="btn btn-danger" type="button" ><i class="bi bi-trash"></i>Delete</button></a>
                                    </div>
                                    <input hidden="type" name="subTaskID<%=k%>" value="<%=task.getSubTaskID()%>">
                                    <input type="text" class="form-control m-input" name='oldTask<%=k%>' value="<%=task.getSubTask()%>">
                                </div>
                            </div>
                            <%}%>
                            <%if (request.getParameter("count") != null) {
                                    i = Integer.parseInt(request.getParameter("count"));
                                    for (int j = 0; j < i; j++) {%>
                            <div id="row">
                                <div class="input-group m-3">
                                    <div class="input-group-prepend">
                                        <a href='coProjTaskManage.jsp?action=Update&count=<%=i - 1%>&mainTaskID=<%=mainTaskID%>'><button class="btn btn-danger" type="button" ><i class="bi bi-trash"></i>Delete</button></a>
                                    </div>
                                    <input type="text" class="form-control m-input" name='subTask<%=j%>'>
                                </div>
                            </div>
                            <%}
                                }%>

                            <a href='coProjTaskManage.jsp?action=Update&count=<%=i + 1%>&mainTaskID=<%=mainTaskID%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                        </div>
                    </div>

                    <input type="hidden" name="oldSubTaskCount" value="<%=k%>">
                    <input type="hidden" name="count" value="<%=i%>">
                    <input type="hidden" name="courseName" value="<%=courseName%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coProjTask.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
