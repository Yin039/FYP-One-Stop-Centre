<%-- 
    Document   : coAssessComp
    Created on : May 8, 2023, 11:18:29 PM
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
        List<assessment> plo = assessmentDao.getAllPlo();
        List<assessment> cloploI = assessmentDao.getCloPloByCourseName("FYP I");
        List<assessment> cloploII = assessmentDao.getCloPloByCourseName("FYP II");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h6 class="text-danger text-center">${addError}${updateError}${DeleteError}</h6>
            </div>


            <div class="enroll-con d-flex justify-content-between">
                <h2 class="text-center">Program Learning Outcomes (PLO)</h2>
                <a href="coLoManage.jsp?action=UpdatePlo"><button class="btn btn-primary addBtn">Update PLO</button></a>
            </div>

            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>PLO</th>
                        <th>Description</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <%for (assessment PLO : plo) {%>
                    <tr>
                        <td><%=PLO.getPlo()%></td>
                        <td><%=PLO.getPloDesc()%></td>
                        <td>
                            <%if (PLO.getPloSelection().equals("Selected")) {%>
                            <input class="form-check-input" type="checkbox" Checked disabled>
                            <%} else {%>
                            <input class="form-check-input" type="checkbox"disabled>
                            <%}%>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>

            <div class="row mt-5">
                <div class="enroll-con d-flex justify-content-between">
                    <h2 class="text-center">Course Learning Outcomes (CLO)</h2>
                    <a href="coLoManage.jsp?action=AddCloPlo"><button class="btn btn-primary addBtn">Add CLO/PLO</button></a>
                </div>

                <div class="col my-2">
                    <h5>FYP I</h5>
                    <div class="p-2" style="background-color:#fcf6de">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>CLO/PLO</th>
                                    <th>Description</th>
                                    <th colspan="2">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (assessment CLOPLO : cloploI) {
                                        assessment PLO = assessmentDao.getPloByID(CLOPLO.getPloID());
                                %>
                                <tr>
                                    <td><%=CLOPLO.getClo()%>-<%=PLO.getPlo()%></td>
                                    <td><%=CLOPLO.getLoDesc()%></td>
                                    <td><a href="coLoManage.jsp?action=UpdateCloPlo&CloPloID=<%=CLOPLO.getCloploID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                    <td>
                                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                                    href = 'AssessmentServlet?action=DELETECLOPLO&CloploID=<%=CLOPLO.getCloploID()%>';
                                                else
                                                    return false;">
                                            <i class="bi bi-trash-fill text-danger"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col my-2">
                    <h5 class="fw-bold">FYP II</h5>
                    <div class="lightBlue p-2">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>CLO/PLO</th>
                                    <th>Description</th>
                                    <th colspan="2">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%for (assessment CLOPLO : cloploII) {
                                        assessment PLO = assessmentDao.getPloByID(CLOPLO.getPloID());
                                %>
                                <tr>
                                    <td><%=CLOPLO.getClo()%>-<%=PLO.getPlo()%></td>
                                    <td><%=CLOPLO.getLoDesc()%></td>
                                    <td><a href="coLoManage.jsp?action=UpdateCloPlo&CloploID=<%=CLOPLO.getCloploID()%>"><i class="bi bi-wrench-adjustable-circle icon-color"></i></a></td>
                                    <td>
                                        <a onclick="if (confirm('Are you sure you want to delete?'))
                                                    href = 'AssessmentServlet?action=DELETECLOPLO&CloploID=<%=CLOPLO.getCloploID()%>';
                                                else
                                                    return false;">
                                            <i class="bi bi-trash-fill text-danger"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

