<%-- 
    Document   : projUpdate
    Created on : Mar 29, 2023, 12:57:03 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.project"%>
<%@page import="com.dao.projectDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        int projectID = Integer.parseInt(request.getParameter("projectID"));

        project project = (project) projectDao.getProjectByID(projectID);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">UPDATE PROJECT DETAILS</h2>
                <h6 class="text-success text-center">${updateSuccess}</h6>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="ProjectServlet?action=PROJUPDATE" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Title</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-fill"></i></div>
                                    <%if (project.getProjectApproval().equals("Rejected")) {%>
                                <input type="text" class="form-control" id="projTitle" name="projTitle" value="<%=project.getProjectTitle()%>"/>
                                <%} else {%>
                                <input type="text" class="form-control" id="projTitle" name="projTitle" value="<%=project.getProjectTitle()%>" readonly/>
                                <%}%>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Description</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projDesc" value="<%=project.getProjectDesc()%>"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Project Type</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file"></i></div>
                                <select class="form-select" name="projType">
                                    <option value="<%=project.getProjectType()%>" style="display:none;"><%=project.getProjectType()%></option>
                                    <option value="RESEARCH">RESEARCH</option>
                                    <option value="SYSTEM">SYSTEM</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <h4 class="text-center">Details of Co-Supervisor</h4>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="coSvName" name="coSvName" value="<%=project.getCoSvName()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="coSvHp" name="coSvHp" value="<%=project.getCoSvHp()%>"/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="projectID" value="<%=projectID%>">
                    <input type="hidden" name="matricNo" value="<%=project.getMatricNo()%>">
                    <input type="hidden" name="projApproval" value="<%=project.getProjectApproval()%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="stuMainPage.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
