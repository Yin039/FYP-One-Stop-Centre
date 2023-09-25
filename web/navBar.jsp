<%-- 
   Document   : navBar
   Created on : Jan 11, 2023, 8:30:10 AM
   Author     : YIYIN
--%>

<%@page import="com.dao.userDao"%>
<%@page import="com.model.user"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <jsp:include page="head.html"/>
    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        String type = request.getParameter("type");
    %>
    <body>
        <header id="header" class="d-flex align-items-center">
            <%if (user.getUserType().equals("Coordinator")) {%>
            <div class="container d-flex align-items-center justify-content-between">

                <h1 class="logo">
                    <a href="coMainPage.jsp"><img src="img/FYPLogo.PNG" class="FYPLogo rounded"></a>
                    <a href="userPersonalInfo.jsp" class="userName">Coordinator</a>
                </h1>

                <nav id="navbar" class="navbar">
                    <ul>
                        <li><a class="nav-link" href="coMainPage.jsp">Home</a></li>
                        <li class="dropdown"><a class="nav-link"><span>User Manage</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="coUserManage.jsp?type=Student" class="nav-link">Student</a></li>
                                <li><a href="coUserManage.jsp?type=Supervisor" class="nav-link">Supervisor</a></li>
                                <li><a href="coUserManage.jsp?type=Officer" class="nav-link">Vocational Officer</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Schedule</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="coScheduleTimetable.jsp" class="nav-link">Timetable</a></li>
                                <li><a href="coScheduleMaterial.jsp" class="nav-link">Material</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Project Monitoring</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="projCoApprovalUpdate.jsp?status=All" class="nav-link">Project Registration</a></li>
                                <li><a href="coProjTask.jsp" class="nav-link">Project's Task</a></li>
                                <li><a href="coProjSubmission.jsp" class="nav-link">Project Submission</a></li>
                                <li><a href="coProjReport.jsp" class="nav-link">Project Progress Report</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Presentation</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="coPresentation.jsp" class="nav-link">Group Manage</a></li>
                                <li><a href="coPresentationAttend.jsp" class="nav-link">Attendance</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Assessment</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="coLo.jsp" class="nav-link">Learning Outcomes</a></li>
                                <li><a href="coAssessRubric.jsp" class="nav-link">Assessment Rubric</a></li>
                                <li><a href="coAssessValidI.jsp" class="nav-link">Validation (FYP I)</a></li>
                                <li><a href="coAssessValidII.jsp" class="nav-link">Validation (FYP II)</a></li>
                                <li><a href="coEvaluation.jsp" class="nav-link">Evaluation Report</a></li>
                                <li><a href="coAssessReport.jsp" class="nav-link">PLO Report</a></li>
                            </ul>
                        </li>
                        <li><a class="nav-link" href="logout.jsp">LogOut</a></li>
                    </ul>
                </nav>
            </div>
            <%} else if (user.getUserType().equals("Supervisor")) {%>
            <div class="container d-flex align-items-center justify-content-between">

                <h1 class="logo">
                    <a href="svMainPage.jsp"><img src="img/FYPLogo.PNG" class="FYPLogo rounded"></a>
                    <a href="userPersonalInfo.jsp" class="userName"><%=e.getSvName()%></a>
                </h1>

                <nav id="navbar" class="navbar">
                    <ul>
                        <li><a class="nav-link" href="svMainPage.jsp">Home</a></li>
                        <li class="dropdown"><a class="nav-link"><span>Project Monitoring</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="projSvApprovalUpdate.jsp" class="nav-link">Project Registration</a></li>    
                                <li><a href="svStuSubmission.jsp" class="nav-link">Project Submission</a></li>      
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Meeting</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="svMeet.jsp" class="nav-link">Manage</a></li>
                                <li><a href="svAppointment.jsp" class="nav-link">Appointment</a></li>
                                <li><a href="svLogBook.jsp" class="nav-link">LogBook</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Presentation</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="svPresentation.jsp" class="nav-link">Details</a></li>    
                                <li><a href="svPresentAssess.jsp" class="nav-link">Assessment</a></li>      
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Assessment</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="svStuAssess.jsp" class="nav-link">Student's Assessment</a></li>
                                <li><a href="svRubric.jsp" class="nav-link">Assessment Rubric</a></li>
                                <li><a href="svEvaluation.jsp" class="nav-link">Evaluation Report</a></li>
                                <li><a href="svAssessReport.jsp" class="nav-link">PLO Report</a></li>
                            </ul>
                        </li> 
                        <li><a class="nav-link" href="logout.jsp">LogOut</a></li>
                    </ul>
                </nav>
            </div>
            <%} else if (user.getUserType().equals("Student")) {%>
            <div class="container d-flex align-items-center justify-content-between">

                <h1 class="logo">
                    <a href="stuMainPage.jsp"><img src="img/FYPLogo.PNG" class="FYPLogo rounded"></a>
                    <a href="userPersonalInfo.jsp" class="userName"><%=e.getName()%>(<%=e.getMatricNo()%>)</a>
                </h1>

                <nav id="navbar" class="navbar">
                    <ul>
                        <li><a class="nav-link" href="stuMainPage.jsp">Home</a></li>
                        <li class="dropdown"><a class="nav-link"><span>Meeting</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="stuAppoint.jsp?status=All" class="nav-link">Appointment</a></li>
                                <li><a href="stuLogBook.jsp" class="nav-link">LogBook</a></li>
                            </ul>
                        </li>
                        <li class="dropdown"><a class="nav-link"><span>Assessment</span> <i class="bi bi-chevron-down"></i></a>
                            <ul>
                                <li><a href="stuAssess.jsp" class="nav-link">Evaluation</a></li>
                                <li><a href="stuRubric.jsp" class="nav-link">Assessment Rubric</a></li>
                            </ul>
                        </li> 
                        <li><a class="nav-link " href="stuPresentation.jsp">Presentation</a></li>
                        <li><a class="nav-link " href="logout.jsp">LogOut</a></li>
                    </ul>
                </nav>
            </div>
            <%} else if (user.getUserType().equals("Officer")) {%>
            <div class="container d-flex align-items-center justify-content-between">

                <h1 class="logo">
                    <a href="offMainPage.jsp"><img src="img/FYPLogo.PNG" class="FYPLogo rounded"></a>
                    <a href="userPersonalInfo.jsp" class="userName"><%=e.getName()%></a>
                </h1>

                <nav id="navbar" class="navbar">
                    <ul>
                        <li><a class="nav-link" href="offMainPage.jsp">Home</a></li>
                        <li><a class="nav-link " href="logout.jsp">LogOut</a></li>
                    </ul>
                </nav>
            </div>
            <%}%>
        </header>
    </body>
</html>
