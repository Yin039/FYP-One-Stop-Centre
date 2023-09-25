<%-- 
    Document   : svPresentation
    Created on : Jun 3, 2023, 10:43:26 PM
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
        int i = 0, j = 0, k = 0;

        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        presentation panel = presentationDao.getPanelGroupBySvID(e.getSvID());
        List<presentation> panelGroup = presentationDao.getPanelGroupByPanelGpNoSvID(panel.getPanelGpNo(), e.getSvID());

        List<presentation> presentation = presentationDao.getPresentationListByGpNo(panel.getPanelGpNo());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${updateError}</h6>
            </div>

            <h2>Presentation Details</h2>
            <p><i class="mx-2 bi bi-star-fill icon-color"></i>-- Panel Leader</p>

            <div class="row">
                <div class="d-flex justify-content-between">
                    <div class="col-8">
                        <table class="table">
                            <tr>
                                <th class="text-end">PANEL GROUP NO: </th>
                                <td colspan="3">
                                    <%if (panel.getPanelID() == 0) {%>
                                    <span class="text-danger">No Assigned Yet..!</span>
                                    <%} else {%>
                                    <%=panel.getPanelGpNo()%>

                                    <%if (panel.getPanelLeader().equals("Yes")) {%>
                                    <i class="mx-2 bi bi-star-fill icon-color"></i>
                                    <%}}%>

                                </td>
                            </tr>
                            <tr>
                                <th class="text-end">OTHER PANELS: </th>
                                <td colspan="2">
                                    <%
                                        if(panelGroup.size()>0){
                                        for (presentation p : panelGroup) {
                                            j++;
                                            user group = userDao.getSVGroupBySVID(p.getSvID());
                                    %>
                                    <span class="fw-bold"><%=j%>.</span> <%=group.getSvName()%>
                                    <%if (p.getPanelLeader().equals("Yes")) {%>
                                    <i class="mx-2 bi bi-star-fill icon-color"></i>
                                    <%}
                                        }}%>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div class="pe-2">
                        <%if(panelGroup.size() > 0){
                            if (panel.getPanelLeader().equals("Yes") && presentation.size() < 2) {%>
                        <a href="svPresentationManage.jsp?action=Add&panelGpNo=<%=panel.getPanelGpNo()%>"><button class="btn btn-primary addBtn">Add Presentation</button></a>
                        <%}}%>
                    </div>
                </div>

                <div class="row">
                    <form action="PresentationServlet?action=UPDATEATTEND" method="post">
                        <table class="table">
                            <%if(presentation.size() > 0){
                                for (presentation p : presentation) {
                                    i++;
                                    List<presentation> attandanceList = presentationDao.getPresentationAttendanceListByPresentID(p.getPresentID());
                            %>
                            <thead>
                                <tr>
                                    <th colspan="4" class="lightBlue">
                                        PRESENTATION <%=i%>  
                                        <%if (panel.getPanelLeader().equals("Yes")) {%>
                                        <a href="svPresentationManage.jsp?action=Update&presentID=<%=p.getPresentID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a>
                                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                                    href = 'PresentationServlet?action=DELETEPRESENT&presentID=<%=p.getPresentID()%>';
                                                else
                                                    return false;">
                                            <i class="bi bi-trash-fill text-danger"></i>
                                        </a>
                                        <%}%>
                                    </th>
                                </tr>
                            </thead>

                            <tr>
                                <td><span class="fw-bold pe-2">DATE: </span><%=p.getPresentDate()%></td>
                                <td><span class="fw-bold pe-2">TIME: </span><%=p.getPresentStartTime()%> - <%=p.getPresentEndTime()%></td>
                                <td><span class="fw-bold pe-2">LOCATION: </span><%=p.getPresentLocate()%></td>
                                <td><span class="fw-bold pe-2">TOTAL STUDENTS: </span><%=p.getStuNum()%></td>
                            </tr>

                            <tr>
                                <td>
                                    <span class="fw-bold pe-2">VALIDATION: </span>
                                    <%if (p.getPresentLocateValid().equals("Invalid")) {%>
                                    <span class="text-danger"><%=p.getPresentLocateValid()%></span>
                                    <%} else {%>
                                    <%=p.getPresentLocateValid()%>
                                    <%}%>

                                </td>
                                <td>
                                    <span class="fw-bold pe-2">PREPARING STATUS: </span>
                                    <%if (p.getPresentSetUp().equals("Done")) {%>
                                    <%=p.getPresentSetUp()%>
                                    <%} else {%>
                                    <span class="text-danger"><%=p.getPresentSetUp()%></span>
                                    <%}%>
                                </td>
                                <td><span class="fw-bold pe-2" colspan="2">REMARK: </span><%=p.getPresentRemark()%></td>
                            </tr>

                            <thead class="text-center bg-light">
                                <tr>
                                    <td colspan="2"></td>
                                    <th>Present</th>
                                    <th>Letter</th>
                                </tr>
                            </thead>


                            <%
                                k = 0;
                                for (presentation attend : attandanceList) {
                                    k++;
                                    user stu = userDao.getStudentDetail(attend.getMatricNo());
                            %>
                            <tr>
                                <%if (attend.getAttendStatus().equals("Absent")) {%>
                                <td class="text-danger" colspan="2"><%=stu.getName()%> (<%=attend.getMatricNo()%>)</td>
                                <%} else {%>
                                <td colspan="2"><%=stu.getName()%> (<%=attend.getMatricNo()%>)</td>
                                <%}%>

                                <td class="text-center">
                                    <%if (panel.getPanelLeader().equals("Yes")) {%>
                                    <%if (attend.getAttendStatus().equals("Present")) {%>
                                    <input class="form-check-input" type="checkbox" name="present<%=i%><%=k%>" value="Present" Checked>
                                    <input type="hidden" name="present<%=i%><%=k%>" value="Absent">
                                    <%} else {%>
                                    <input class="form-check-input" type="checkbox" name="present<%=i%><%=k%>" value="Present">
                                    <input type="hidden" name="present<%=i%><%=k%>" value="Absent">
                                    <%}
                                        }%>
                                </td>

                                <td class="text-center">
                                    <%if (panel.getPanelLeader().equals("Yes")) {%>
                                    <%if (attend.getAttendStatus().equals("Letter")) {%>
                                    <input class="form-check-input" type="checkbox"  name="letter<%=i%><%=k%>" value="Letter" Checked>
                                    <input type="hidden" name="letter<%=i%><%=k%>" value="Absent">
                                    <%} else {%>
                                    <input class="form-check-input" type="checkbox" name="letter<%=i%><%=k%>" value="Letter">
                                    <input type="hidden" name="letter<%=i%><%=k%>" value="Absent">
                                    <%}
                                        }%>
                                </td>

                            <input type="hidden" name="presentAttendID<%=i%><%=k%>" value="<%=attend.getPresentAttendID()%>">
                            </tr>
                            <%}%>
                            <tr>
                                <td class="text-end" colspan="4"><button type="submit" value="Submit" class="btn btn-primary">Save</button></td>
                            <input type="hidden" name="totalStuCount<%=i%>" value="<%=k%>">
                            </tr>
                            <%}}%>
                            <input type="hidden" name="totalDay" value="<%=i%>">
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>



