<%-- 
    Document   : svProjTaskManage
    Created on : Jun 14, 2023, 6:47:52 PM
    Author     : TEOH YI YIN
--%>

<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>

    <%
        String stuUserID = request.getParameter("stuUserID");
        int projectID = Integer.parseInt(request.getParameter("projectID"));

        int i = 0;
        int k = 0;

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        }
        
        List<projectProgress> module = projectProgressDao.getModuleTrackingByProjectID(projectID);
        project project = projectDao.getProjectByID(projectID);
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">UPDATE PROJECT'S MODULE</h2>
                <h6 class="text-danger text-center">${deleteError}</h6>
            </div>

            <div class="form">
                <form action="ProjectProgressServlet?action=UPDATEMODULE" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Title</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input hidden="type" name="stuUserID" value="<%=stuUserID%>">
                                <input hidden="type" name="projectID" value="<%=projectID%>">
                                <input type="text" class="form-control" name="projectTitle" value='<%=project.getProjectTitle()%>'/>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>System's Module</label>

                            <%for (projectProgress m : module) {
                                    k++;
                            %>
                            <div id="row">
                                <div class="input-group m-3">
                                    <div class="input-group-prepend">
                                        <a href='ProjectProgressServlet?action=DELETEMODULE&moduleTrackID=<%=m.getModuleTrackID()%>&projectID=<%=project.getProjectID()%>&stuUserID=<%=stuUserID%>'><button class="btn btn-danger" type="button" ><i class="bi bi-trash"></i>Delete</button></a>
                                    </div>
                                    <input type='hidden' name="moduleTrackID<%=k%>" value="<%=m.getModuleTrackID()%>">
                                    <input type='hidden' name="trackStatus<%=k%>" value="<%=m.getTrackStatus()%>">
                                    <input type="text" class="form-control m-input" name='oldModule<%=k%>' value="<%=m.getModule()%>">
                                </div>
                            </div>
                            <%}%>
                            <%if (request.getParameter("count") != null) {
                                    i = Integer.parseInt(request.getParameter("count"));
                                    for (int j = 0; j < i; j++) {%>
                            <div id="row">
                                <div class="input-group m-3">
                                    <div class="input-group-prepend">
                                        <a href='svProjTaskManage.jsp?projectID=<%=project.getProjectID()%>&stuUserID=<%=stuUserID%>&count=<%=i - 1%>'><button class="btn btn-danger" type="button" ><i class="bi bi-trash"></i>Delete</button></a>
                                    </div>
                                    <input type="text" class="form-control m-input" name='module<%=j%>'>
                                </div>
                            </div>
                            <%}
                                }%>

                            <a href='svProjTaskManage.jsp?projectID=<%=project.getProjectID()%>&stuUserID=<%=stuUserID%>&count=<%=i + 1%>'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span>ADD</button></a>
                        </div>
                    </div>

                    <input type="hidden" name="oldSubTaskCount" value="<%=k%>">
                    <input type="hidden" name="count" value="<%=i%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="svStuDetail.jsp?stuUserID=<%=stuUserID%>" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>


</html>


