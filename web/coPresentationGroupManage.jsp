<%-- 
    Document   : coPresentationGroupManage
    Created on : May 30, 2023, 10:09:15 PM
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
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String action = request.getParameter("action");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Add")) {
                    int totalGroup = userDao.getTotalSvGroupNumber();
            %>
            <div class="section-title">
                <h2 class="text-center">GENERATE PRESENTATION GROUP</h2>
            </div>

            <div>
                <h5>Total Number of Unassigned SV Group: <%=totalGroup%></h5>
            </div>
            <div class="form">
                <form action="PresentationServlet?action=GENERATEGROUP" class="row g-4 mt-3" method="post">
                    <div class="row mb-3">
                        <div class="row justify-content-center">
                            <div class="col-4">
                                <label>Number Presentation Group</label>
                                <div class="input-group">
                                    <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                    <input type="int" class="form-control" name="numGroups" required/>
                                </div>
                            </div>
                        </div>

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Generate</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="coPresentation.jsp" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int i = 0, presentID = 0;

                if (request.getParameter("count") != null) {
                    i = Integer.parseInt(request.getParameter("count"));
                }

                int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));
                List<presentation> panelGp = presentationDao.getPanelGroupByPanelGpNo(panelGpNo);
                List<user> unassignedSvGroup = userDao.getUnassignedSVGroup();
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE PRESENTATION GROUP (G<%=panelGpNo%>)</h2>
            </div>

            <div class="form">
                <form action="PresentationServlet?action=UPDATEGROUP" class="row g-4 mt-3" method="post">
                    <div class="row mb-3">
                        <%
                            for (presentation p : panelGp) {
                                user group = userDao.getSVGroupBySVID(p.getSvID());
                                presentID = p.getPresentID();
                        %>
                        <div class="row justify-content-center align-items-center m-1">
                            <div class="col-5">
                                <input type="text" class="form-control" value="<%="Group " + group.getGroupNo() + " - " + group.getSvName() + " (" + group.getNumber() + ")"%>" readonly/>

                            </div>
                            <div class="col-1">
                                <a href='PresentationServlet?action=DELETESV&panelID=<%=p.getPanelID()%>&panelGpNo=<%=panelGpNo%>'><i class="bi bi-trash-fill text-danger"></i></a>
                            </div>
                        </div>
                        <%}
                            if (request.getParameter("count") != null) {
                                i = Integer.parseInt(request.getParameter("count"));
                                for (int j = 0; j < i; j++) {
                        %>
                        <div class="row justify-content-center align-items-center m-1">
                            <div class="col-5">
                                <select class="form-select" name="svID<%=j%>">
                                    <%
                                        for (user group : unassignedSvGroup) {
                                            if (group.getSvName() == null) {
                                    %>
                                    <option>All Groups Are Assigned</option>
                                    <%} else {%>
                                    <option value="<%=group.getSvID()%>"><%="Group " + group.getGroupNo() + " - " + group.getSvName() + " (" + group.getNumber() + ")"%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>

                            <div class="col-1">
                                <a href='coPresentationGroupManage.jsp?action=Update&count=<%=i - 1%>&panelGpNo=<%=panelGpNo%>'><i class="bi bi-trash-fill text-danger"></i></a>
                            </div>
                        </div>
                        <%}
                            }%>

                        <div class="row justify-content-center">
                            <div class="col-4"></div>
                            <div class="col-2 text-end">
                                <a href='coPresentationGroupManage.jsp?count=<%=i + 1%>&panelGpNo=<%=panelGpNo%>&action=Update'><button type="button" class="btn btn-dark"><span class="bi bi-plus-square-dotted"></span> ADD</button></a>
                            </div>
                        </div>

                        <input type="hidden" name="count" value="<%=i%>">
                        <input type="hidden" name="panelGpNo" value="<%=panelGpNo%>">

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="coPresentation.jsp" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>

                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
