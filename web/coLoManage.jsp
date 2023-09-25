<%-- 
    Document   : coAssessCompManage
    Created on : May 8, 2023, 11:53:16 PM
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

        List<assessment> ploSelected = assessmentDao.getSelectedPlo();
    %>

    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">

            <%if (action.equals("AddCloPlo")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD CLO/PLO</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=ADDCLOPLO" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Course Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="courseName" required>
                                    <option value="FYP I">FYP I</option>
                                    <option value="FYP II">FYP II</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>CLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="clo" placeholder="Example: CLO1" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>PLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="ploID" required>
                                    <%for (assessment PLO : ploSelected) {%>
                                    <option value="<%=PLO.getPloID()%>"><%=PLO.getPlo()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Description</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="2" name="loDesc" placeholder="Enter Description of CLO/PLO" required></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coLo.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("UpdatePlo")) {
                List<assessment> plo = assessmentDao.getAllPlo();
                int i = 0;
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE PLO</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATEPLO" class="row g-4 mt-3" method="post">
                    <%for (assessment PLO : plo) {
                            i++;
                    %>
                    <div class="row justify-content-center align-items-center">
                        <div class="col-2">
                            <label>PLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="plo<%=i%>" value="<%=PLO.getPlo()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>Description</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="ploDesc<%=i%>" value="<%=PLO.getPloDesc()%>" required/>
                            </div>
                        </div>
                        <div class='col-1'>
                            <div class="form-check">
                                <%if (PLO.getPloSelection().equals("Selected")) {%>
                                <input class="form-check-input" type="checkbox" name="ploSelection<%=i%>" value="Selected" Checked>
                                <input type="hidden" name="ploSelection<%=i%>" value="Unselected">
                                <%} else {%>
                                <input class="form-check-input" type="checkbox" name="ploSelection<%=i%>" value="Selected">
                                <input type="hidden" name="ploSelection<%=i%>" value="Unselected">
                                <%}%>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="ploID<%=i%>" value="<%=PLO.getPloID()%>">
                    <%}%>
                    
                    <input type="hidden" name="count" value="<%=i%>">
                    
                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coLo.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>

            <%} else if (action.equals("UpdateCloPlo")) {
                int cloploID = Integer.parseInt(request.getParameter("CloPloID"));
                assessment LO = assessmentDao.getCloPloByID(cloploID);
                assessment PLO = assessmentDao.getPloByID(LO.getPloID());
            %>
            <div class="section-title">
                <h2 class="text-center">UPDATE CLO/PLO</h2>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATELO" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>Course Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="courseName" required>
                                    <option value="<%=LO.getCourseName()%>" selected style="display:none;"><%=LO.getCourseName()%></option>
                                    <option value="FYP I">FYP I</option>
                                    <option value="FYP II">FYP II</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-3">
                            <label>CLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <input type="text" class="form-control" name="clo" value="<%=LO.getClo()%>" required/>
                            </div>
                        </div>
                        <div class="col-3">
                            <label>PLO</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-chat-right-fill"></i></div>
                                <select class="form-select" name="ploID" required>
                                    <option value="<%=LO.getPloID()%>" selected style="display:none;"><%=PLO.getPlo()%></option>
                                    <%for (assessment ploList : ploSelected) {%>
                                    <option value="<%=ploList.getPloID()%>"><%=ploList.getPlo()%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>


                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Description</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-file-earmark-text-fill"></i></div>
                                <textarea class="form-control" rows="2" name="loDesc"><%=LO.getLoDesc()%></textarea>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="cloploID" value="<%=LO.getCloploID()%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coLo.jsp" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>


</html>

