<%-- 
    Document   : userPersonalInfo
    Created on : Dec 22, 2022, 12:33:01 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center">Personal Information</h2>
                <h6 class="text-danger text-center">${updateError}</h6>
                <h6 class="text-warning text-center">${changePass}</h6>
            </div>

            <div class="form mt-4">

                <%if (user.getUserType().equals("Coordinator")) {%>
                <form action="UserServlet?action=UPDATEPERSONAL&userType=Coordinator" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=e.getEmail()%>"/>
                            </div>
                            <span class="text-danger">${emailError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="password" name="password" value="<%=e.getPassword()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>New Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="newPass" name="newPass"/>
                            </div>
                            <span class="text-danger">${passwordError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Confirm Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="conPass" name="conPass"/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="userID" value="<%=user.getUserID()%>">

                    <div class="row justify-content-center">
                        <div class="col-2 text-center mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </div>
                </form>

                <%} else if (user.getUserType().equals("Supervisor")) {%>

                <form action="UserServlet?action=UPDATEPERSONAL&userType=Supervisor" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" value="<%=e.getSvName()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=e.getEmail()%>"/>
                            </div>
                            <span class="text-danger">${emailError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="password" name="password" value="<%=e.getPassword()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>New Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="newPass" name="newPass"/>
                            </div>
                            <span class="text-danger">${passwordError}</span>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Confirm Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="conPass" name="conPass"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" value="<%=e.getHP()%>"/>
                            </div>
                            <span class="text-danger">${hpError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <input type="text" class="form-control" id="groupNo" name="groupNo"  value="<%=e.getGroupNo()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Group Link</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-link"></i></div>
                                    <%if (e.getGroupLink() == null) {%>
                                <input type="text" class="form-control" id="groupNo" name="groupLink" placeholder="Link of Group Chat Haven't Added."/>
                                <%} else {%>
                                <input type="text" class="form-control" id="groupNo" name="groupLink"  value="<%=e.getGroupLink()%>"/>
                                <%}%>
                            </div>
                            <span class="text-danger">${linkError}</span>
                        </div>
                    </div>

                    <input type="hidden" name="userID" value="<%=e.getUserID()%>">
                    <input type="hidden" name="svID" value="<%=e.getSvID()%>">

                    <div class="row justify-content-center">
                        <div class="col-2 text-center mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </div>
                </form>

                <%} else if (user.getUserType().equals("Officer")) {%>

                <form action="UserServlet?action=UPDATEPERSONAL&userType=Officer" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" value="<%=e.getName()%>"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=e.getEmail()%>"/>
                            </div>
                            <span class="text-danger">${emailError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="password" name="password" value="<%=e.getPassword()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>New Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="newPass" name="newPass"/>
                            </div>
                            <span class="text-danger">${passwordError}</span>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>Confirm Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="conPass" name="conPass"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-6">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" value="<%=e.getHP()%>"/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="userID" value="<%=e.getUserID()%>">
                    <input type="hidden" name="offID" value="<%=e.getOffID()%>">
                    <input type="hidden" name="offLoginValid" value="<%=e.getOffLoginValid()%>">

                    <div class="row justify-content-center">
                        <div class="col-2 text-center mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </div>
                </form>

                <%} else if (user.getUserType().equals("Student")) {%>
                <form action="UserServlet?action=UPDATEPERSONAL&userType=Student" class="row g-4" method="post">
                    <div class="row justify-content-center">
                        <div class="col-4">
                            <label>Matric No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-stripe"></i></div>
                                <input type="text" class="form-control" id="matricNo" name="matricNo" value="<%=e.getMatricNo()%>" readonly/>
                            </div>
                        </div>
                        <div class="col-4">
                            <label>Group No</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-people-fill"></i></div>
                                <input type="number" class="form-control" id="groupNo" name="groupNo"  value="<%=e.getGroupNo()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Name</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                <input type="text" class="form-control" id="name" name="name" value="<%=e.getName()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>IC No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-person-vcard"></i></div>
                                <input type="text" class="form-control" id="IC" name="IC" value="<%=e.getIC()%>"/>
                            </div>
                            <span class="text-danger">${icError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Email</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                <input type="text" class="form-control" id="email" name="email" value="<%=e.getEmail()%>"/>
                            </div>
                            <span class="text-danger">${emailError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="password" name="password" value="<%=e.getPassword()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-4">
                            <label>New Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="newPass" name="newPass"/>
                            </div>
                            <span class="text-danger">${passwordError}</span>
                        </div>
                        <div class="col-4">
                            <label>Confirm Password</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                <input type="password" class="form-control" id="conPass" name="conPass"/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>HP No.</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                <input type="text" class="form-control" id="HP" name="HP" value="<%=e.getHP()%>"/>
                            </div>
                            <span class="text-danger">${hpError}</span>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-8">
                            <label>Program</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-code-square"></i></div>
                                <input type="text" class="form-control" id="program" name="program" value="<%=e.getPgm()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-2">
                            <label>Semester</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-calendar-week-fill"></i></div>
                                <input type="text" class="form-control" id="sem" name="sem" value="<%=e.getSem()%>"readonly/>
                            </div>
                        </div>

                        <div class="col-6">
                            <label>Course Code</label>
                            <div class="input-group">
                                <div class="input-group-text"><i class="bi bi-journal"></i></div>
                                <input type="text" class="form-control" id="crsCode" name="crsCode" value="<%=e.getCrsCode()%>"readonly/>
                                <input type="text" class="form-control" id="crsName" name="crsName" value="<%=e.getCrsName()%>" readonly/>
                            </div>
                        </div>
                    </div>

                    <input type="hidden" name="userID" value="<%=e.getUserID()%>"/>

                    <div class="row justify-content-center">
                        <div class="col-2  text-center mt-2 mb-5">
                            <button type="submit" value="Submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </div>
                </form>
                <%}%>
            </div>
        </div>
    </body>
</html>
