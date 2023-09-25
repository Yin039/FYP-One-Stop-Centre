<%-- 
    Document   : coUserUpdate
    Created on : Dec 20, 2022, 11:34:19 PM
    Author     : YI YIN
--%>

<%@page import="com.dao.scheduleDao"%>
<%@page import="java.util.List"%>
<%@page import="com.model.user"%>
<%@page import="com.dao.userDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        String type = request.getParameter("type");
        int id = Integer.parseInt(request.getParameter("userID"));

        user user = userDao.getUserByID(id);

        List<String> courseCode = scheduleDao.getFYPCourse();
        List<Integer> SVGroup = userDao.getSVGroup();
        String[] program = {"SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN", "SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)"};
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">

            <%if (type.equals("Supervisor")) {%>
            <div class="section-title">
                <h2 class="text-center">UPDATE SUPERVISOR</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="UserServlet?action=UPDATE&userType=Supervisor" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" value="<%=user.getSvName()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=user.getEmail()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" value="<%=user.getHP()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <input type="number" class="form-control" id="groupNo" name="groupNo"  value="<%=user.getGroupNo()%>"/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="password" value="<%=user.getPassword()%>">
                    <input type="hidden" name="userID" value="<%=user.getUserID()%>">
                    <input type="hidden" name="svID" value="<%=user.getSvID()%>">
                    <input type="hidden" name="groupLink" value="<%=user.getGroupLink()%>">

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save</button>
                        </div>
                        <div class="col-1 mt-2 mb-5">
                            <a href="coUserManage.jsp?type=Supervisor" class="btn btn-primary float-end">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (type.equals("Student")) {%>
            <div class="section-title">
                <h2 class="text-center">UPDATE STUDENT</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
            </div>

            <div class="form">
                <form action="UserServlet?action=UPDATE&userType=Student" class="row g-4 mt-3" method="post">
                    <div class="row justify-content-center">
                        <div class="col-4">
                            <label>Matric No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-stripe"></i></div>
                                <input type="text" class="form-control" id="matricNo" name="matricNo" value="<%=user.getMatricNo()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-4">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <select class="form-select" name="groupNo">
                                    <option value="<%=user.getGroupNo()%>"><%=user.getGroupNo()%></option>
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
                                <input type="text" class="form-control" id="name" name="name" value="<%=user.getName()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>IC No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-vcard"></i></div>
                                <input type="text" class="form-control" id="IC" name="IC" value="<%=user.getIC()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=user.getEmail()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" value="<%=user.getHP()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Program</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-code-square"></i></div>
                                <select class="form-select" name="program">
                                    <option value="<%=user.getPgm()%>" selected style="display:none;"><%=user.getPgm()%></option>
                                    <option value="SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN">SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN</option>
                                    <option value="SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)">SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-2">
                            <label>Semester</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-week-fill"></i></div>
                                <input type="text" class="form-control" id="sem" name="sem" value="<%=user.getSem()%>"/>
                            </div>
                        </div>
                        <div class="col-6">
                            <label>Course Code</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-journal"></i></div>
                                <select class="form-select" name="crsCode">
                                    <option value="<%=user.getCrsCode()%>" selected><%=user.getCrsCode()%></option>
                                    <%for (String code : courseCode) {%>
                                    <option value="<%=code%>"><%=code%></option>
                                    <%}%>
                                </select>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="password" value="<%=user.getPassword()%>"/>
                    <input type="hidden" name="userID" value="<%=user.getUserID()%>"/>

                    <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save</button>
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

