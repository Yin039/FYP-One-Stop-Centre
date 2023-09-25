<%-- 
    Document   : coScheduleMaterialManage
    Created on : Apr 16, 2023, 1:31:19 AM
    Author     : user
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
        String action = request.getParameter("action");
        List<schedule> materialList = scheduleDao.getMaterialList();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>
            <%if (action.equals("Add")) {
                    String detailID = request.getParameter("detailID");
            %>
            <div class="section-title">
                <h2 class="text-center">ADD MATERIAL</h2>
            </div>

            <div class="form">
                <form action="ScheduleServlet?action=ADDMATERIAL" class="row g-4 mt-3" method="post" enctype="multipart/form-data">
                    <%if (detailID != null) {%>
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Uploaded Material</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="materialID">
                                    <option></option>
                                    <%for (schedule material : materialList) {%>
                                    <option value='<%=material.getMaterialID()%>'><%=material.getMaterialName()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>
                    <%}%>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="materialName" required/>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Link</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="materialLink"/>
                            </div>
                            <span class="text-danger">${linkError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Type</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="materialType" required>
                                    <option value="Manuals & Handbook">Manuals & Handbook</option>
                                    <option value="Briefing Materials">Briefing Materials</option>
                                    <option value="Sample Dissertations">Sample Dissertations</option>
                                    <option value="Templates">Templates</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <div class="input-group">
                                <div class="custom-file">
                                    <input name="materialDoc" type="file"  accept="application/pdf" class="custom-file-input" placeholder="Choose File">
                                </div>
                            </div>
                        </div>
                    </div>

                    <%if (detailID != null) {%>
                    <input type="hidden" name="detailID" value="<%=detailID%>"/>
                    <%}%>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coScheduleMaterial.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int materialID = Integer.parseInt(request.getParameter("materialID"));
                schedule m = scheduleDao.getMaterialByID(materialID);
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE MATERIAL</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
                <h6 class="text-success text-center">${updateSuccess}</h6>
            </div>

            <div class="form">
                <form action="ScheduleServlet?action=UPDATEMATERIAL" class="row g-4 mt-3" method="post"  enctype="multipart/form-data">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="materialName" value="<%=m.getMaterialName()%>"/>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Link</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="materialLink" value="<%=m.getMaterialLink()%>"/>
                            </div>
                            <span class="text-danger">${linkError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Material Type</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="materialType" required>
                                    <option value="<%=m.getMaterialType()%>" selected style="display:none;" ><%=m.getMaterialType()%></option>
                                    <option value="Manuals & Handbook">Manuals & Handbook</option>
                                    <option value="Briefing Materials">Briefing Materials</option>
                                    <option value="Sample Dissertations">Sample Dissertations</option>
                                    <option value="Templates">Templates</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <div class="input-group">
                                <div class="custom-file">
                                    <input name="materialDoc" type="file"  accept="application/pdf" class="custom-file-input">
                                </div>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="olDoc" value="<%=m.getMaterialDoc()%>">
                    <input type="hidden" name="materialID" value="<%=materialID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coScheduleTimetable.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
