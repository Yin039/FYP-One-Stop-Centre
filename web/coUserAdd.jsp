<%-- 
    Document   : coUserAdd
    Created on : Jan 10, 2023, 11:11:54 PM
    Author     : user
--%>

<%@page import="com.dao.scheduleDao"%>
<%@page import="java.util.List"%>
<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String type = request.getParameter("type");

        List<String> courseCode = scheduleDao.getFYPCourse();
        List<Integer> SVGroup = userDao.getSVGroup();
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">

            <%if (type.equals("Supervisor")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD SUPERVISOR</h2>
                <h6 class="text-danger text-center">${insertError}</h6>
            </div>

            <div class="form">
                <form action="UserServlet?action=ADD1&userType=Supervisor" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" placeholder="Example: ABC (IN CAPITAL LETTER)" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" placeholder="Example: abc@ocean.umt.edu.my" required/>
                            </div>
                            <span class="text-danger">${emailError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" placeholder="Example: 01212345678"/>
                            </div>
                            <span class="text-danger">${hpError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <input type="number" class="form-control" id="groupNo" name="groupNo" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coUserManage.jsp?type=Supervisor" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (type.equals("Student")) {%>
            <div class="section-title">
                <h2 class="text-center">ADD STUDENT</h2>
                <h6 class="text-danger text-center">${insertError}</h6>
            </div>

            <div class="form">
                <form action="UserServlet?action=ADD1&userType=Student" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-4">
                            <label>Matric No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-stripe"></i></div>
                                <input type="text" class="form-control" id="matricNo" name="matricNo" placeholder="Example: S12345" required/>
                            </div>
                        </div>
                        <div class="col-4">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <select class="form-select" name="groupNo" required>
                                    <%for (int groupNo : SVGroup) {%>
                                    <option value="<%=groupNo%>"><%=groupNo%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" placeholder="Example: ABC (IN CAPITAL LETTER)" required/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Program</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-code-square"></i></div>
                                <select class="form-select" name="program">
                                    <option value="SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN">SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN</option>
                                    <option value="SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)">SARJASARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-2">
                            <label>Semester</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-week-fill"></i></div>
                                <input type="number" class="form-control" id="sem" name="sem" placeholder="Example: 5"/>
                            </div>
                            </div>
                        <div class="col-3">
                            <label>Session</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-week-fill"></i></div>
                                <input type="text" class="form-control" id="sem" name="stuSession" placeholder="Example: SEM 1 2022/23"/>
                            </div>
                        </div>

                        <div class="col-3">
                            <label>Course Code</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-journal"></i></div>
                                <select class="form-select" name="courseCode">
                                    <%for (String code : courseCode) {%>
                                    <option value="<%=code%>"><%=code%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Add</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coUserManage.jsp?type=Student" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>
