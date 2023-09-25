<%-- 
    Document   : svPresentationManage.jsp
    Created on : Jun 3, 2023, 6:19:03 PM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String action = request.getParameter("action");
        List<presentation> validLocate = presentationDao.getValidLocationList();

        assessment assess = assessmentDao.getPresentCompByCourseName("FYP I");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Add")) {
                    int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

                    presentation locateSelected = presentationDao.getPresentLocate(panelGpNo);
            %>
            <div class="section-title">
                <h2 class="text-center">ADD PRESENTATION DETAIL</h2>
            </div>

            <div class="form">
                <form action="PresentationServlet?action=ADDPRESENT" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Location <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-geo-alt-fill"></i></div>
                                <select class="form-select" name="locateID" required>
                                    <%if (locateSelected.getLocateID() == 0) {%>
                                    <%for (presentation l : validLocate) {%>
                                    <option value="<%=l.getLocateID()%>"><%=l.getPresentLocate()%></option>
                                    <%}
                                    } else {%>
                                    <option value="<%=locateSelected.getLocateID()%>"><%=locateSelected.getPresentLocate()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                        <div class="col-3"></div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Date <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="presentDate" min="<%=assess.getAssessStartDate()%>" max="<%=assess.getAssessEndDate()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Start Time <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentStartTime" min="08:00" max="17:00" value="08:00" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>End Time <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentEndTime" min="08:00" max="17:00" value="08:00" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Presentation Link</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-link"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="presentLink"/>
                            </div>
                            <span class="text-danger">${linkError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Remarks</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="presentRemark"></textarea>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="presentLocateValid" value="Valid">
                    <input type="hidden" name="presentSetUp" value="Setting Up">
                    <input type="hidden" name="panelGpNo" value="<%=panelGpNo%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="svPresentation.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int presentID = Integer.parseInt(request.getParameter("presentID"));
                presentation p = presentationDao.getPresentationByID(presentID);
            %>

            <div class="section-title">
                <h2 class="text-center">UPDATE PRESENTATION DETAIL</h2>
            </div>

            <div class="form">
                <form action="PresentationServlet?action=UPDATEPRESENT" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Location<span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-geo-alt-fill"></i></div>
                                <select class="form-select" name="locateID" required>
                                    <option value="<%=p.getLocateID()%>" selected style="display:none;"><%=p.getPresentLocate()%></option>
                                    <%for (presentation l : validLocate) {%>
                                    <option value="<%=l.getLocateID()%>"><%=l.getPresentLocate()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                        <div class="col-3"></div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Date<span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="presentDate" value="<%=p.getPresentDate()%>" min="<%=assess.getAssessStartDate()%>" max="<%=assess.getAssessEndDate()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Start Time<span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentStartTime" min="08:00" max="17:00" value="<%=p.getPresentStartTime()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>End Time<span class="text-danger">*</span></label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentEndTime" min="08:00" max="17:00" value="<%=p.getPresentStartTime()%>" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Presentation Link</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-link"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="presentLink" value="<%=p.getPresentLink()%>"/>
                            </div>
                            <span class="text-danger">${linkError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Remarks</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="3" id="projDesc" name="presentRemark"><%=p.getPresentRemark()%></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Location Validation</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-check2-square"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="presentLocateValid" value="<%=p.getPresentLocateValid()%>" readonly=""/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Preparing Status</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clipboard-check-fill"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="presentSetUp" value="<%=p.getPresentSetUp()%>" readonly=""/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="presentID" value="<%=presentID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="svPresentation.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>

