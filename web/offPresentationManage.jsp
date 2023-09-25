<%-- 
    Document   : offPresentationManage
    Created on : Jun 3, 2023, 7:01:33 PM
    Author     : TEOH YI YIN
--%>

<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.presentationDao"%>
<%@page import="com.dao.userDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Vocational Officer</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String action = request.getParameter("action");

        int i = 0, k = 0;

        if (request.getParameter("count") != null) {
            i = Integer.parseInt(request.getParameter("count"));
        }
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Manage")) {
                    List<presentation> location = presentationDao.getLocationList();
            %>
            <div class="section-title">
                <h2 class="text-center">ADD LOCATION</h2>
            </div>

            <div class="form">
                <form action="PresentationServlet?action=MANAGELOCATE" class="row g-4 mt-3" method="post">
                    <div class="row mb-3">
                        <%for (presentation l : location) {
                                k++;
                        %>
                        <div class="mt-3">
                            <div class="row justify-content-center align-items-center">
                                <div class="col-3">
                                    <input type="text" class="form-control" name="presentLocate<%=k%>" value="<%=l.getPresentLocate()%>"/>
                                </div>

                                <div class="col-2">
                                    <select class="form-select" name="presentLocateValid<%=k%>">
                                        <option value="<%=l.getPresentLocateValid()%>" selected style="display:none;"><%=l.getPresentLocateValid()%></option>
                                        <option value="Valid">Valid</option>
                                        <option value="Invalid">Invalid</option>
                                    </select>
                                </div>

                                <div class="col-1">
                                    <a href='PresentationServlet?action=DELETELOCATE&locateID=<%=l.getLocateID()%>'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>

                                <input type="hidden" name="locateID<%=k%>" value="<%=l.getLocateID()%>">
                            </div>
                        </div>
                        <%}
                            if (request.getParameter("count") != null) {
                                i = Integer.parseInt(request.getParameter("count"));
                                for (int j = 0; j < i; j++) {
                        %>
                        <div class="mt-3">
                            <div class="row justify-content-center align-items-center">
                                <div class="col-3">
                                    <input type="text" class="form-control" name="newPresentLocate<%=j%>"/>
                                </div>
                                <div class="col-2">
                                    <select class="form-select" name="newPresentLocateValid<%=j%>">
                                        <option value="Valid">Valid</option>
                                        <option value="Invalid">Invalid</option>
                                    </select>
                                </div>

                                <div class="col-1">
                                    <a href='offPresentationManage.jsp?count=<%=i - 1%>&action=Manage'><i class="bi bi-trash-fill text-danger"></i></a>
                                </div>
                            </div>
                        </div>
                        <%}
                            }%>

                        <div class="row justify-content-center mt-2">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='offPresentationManage.jsp?count=<%=i + 1%>&action=Manage'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="existLocateCount" value="<%=k%>">
                    <input type="hidden" name="count" value="<%=i%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="offMainPage.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {

                int presentID = Integer.parseInt(request.getParameter("presentID"));
                presentation p = presentationDao.getPresentationByID(presentID);
            %>

            <div class="section-title">
                <h2 class="text-center">UPDATE LOCATION</h2>
            </div>

            <div class="form">
                <form action="PresentationServlet?action=UPDATEPRESENTSTATE" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Location</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-geo-alt-fill"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="presentLocate" value="<%=p.getPresentLocate()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3"></div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Date</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-fill"></i></div>
                                <input type="date" class="form-control" id="meetDate" name="presentDate" value="<%=p.getPresentDate()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Start Time</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentStartTime" min="08:00" max="17:00" value="<%=p.getPresentStartTime()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>End Time</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clock-fill"></i></div>
                                <input type="time" class="form-control" id="meetTime" name="presentEndTime" min="08:00" max="17:00" value="<%=p.getPresentStartTime()%>" readonly/>
                            </div>
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
                                <select class="form-select" name="presentLocateValid" required>
                                    <option value="<%=p.getPresentLocateValid()%>" selected style="display:none;"><%=p.getPresentLocateValid()%></option>
                                    <option value="Valid">Valid</option>
                                    <option value="Invalid">Invalid</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Preparing Status</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-clipboard-check-fill"></i></div>
                                <select class="form-select" name="presentSetUp" required>
                                    <option value="<%=p.getPresentSetUp()%>" selected style="display:none;"><%=p.getPresentSetUp()%></option>
                                    <option value="Missing Instruments">Missing Instruments</option>
                                    <option value="Setting Up">Setting Up</option>
                                    <option value="Done">Done</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="presentID" value="<%=presentID%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="offMainPage.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>

            <%}%>
        </div>
    </body>
</html>

