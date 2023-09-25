<%-- 
    Document   : registerProject
    Created on : Mar 28, 2023, 11:22:04 PM
    Author     : TEOH YI YIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String matricNo = request.getParameter("matricNo");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">REGISTER PROJECT</h2>
                <h6 class="text-danger text-center">${registerError}</h6>
            </div>

            <div class="form">
                <form action="ProjectServlet?action=REGISTER" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Title</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-fill"></i></div>
                                <input type="text" class="form-control" id="projTitle" name="projTitle" placeholder="Title of project to propose" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Project Description</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="projDesc" placeholder="Breifly describe project to  propose"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Project Type</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file"></i></div>
                                <select class="form-select" name="projType" required>
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
                                <input type="text" class="form-control" id="coSvName" name="coSvName" placeholder="Example: ABC (IN CAPITAL LETTER)"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="coSvHp" name="coSvHp" placeholder="Example: 01212345678"/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="matricNo" value="<%=matricNo%>">
                    <input type="hidden" name="projApproval" value="Applying">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Register</button>
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
