<%-- 
    Document   : coFYPCourseUpdate
    Created on : Mar 29, 2023, 7:48:48 AM
    Author     : user
--%>

<%@page import="com.dao.scheduleDao"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
        <jsp:include page="head.html"/>
    </head>
    <%
        int i = 0;
        int j = 0;
        List<String> FYPI = scheduleDao.getCourseCodeByName("FYP I");
        List<String> FYPII = scheduleDao.getCourseCodeByName("FYP II");
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class='container'>

            <div class="section-title">
                <h2 class="text-center">UPDATE COURSE CODE</h2>
            </div>

            <div class="form">
                <form action="ScheduleServlet?action=updateCourse" class="row" method="post">
                    <div class="row">
                        <div class="col-3"></div>

                        <div class="col-6">
                            <div class="enroll-con d-flex justify-content-center">
                                <div class="col">
                                    <h5 class="text-center yellow p-2 m-0">FYP I</h5>
                                    <%for (String fypI : FYPI) {
                                            i++;
                                    %>
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="fypI<%=i%>" value="<%=fypI%>"/>
                                        <input type="hidden" name="oldcodeI<%=i%>" value="<%=fypI%>"/>
                                    </div>
                                    <%}%>
                                </div>

                                <div class="col">
                                    <h5 class="text-center blue p-2 m-0">FYP II</h5>
                                    <%for (String fypII : FYPII) {
                                            j++;
                                    %>
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="fypII<%=j%>" value="<%=fypII%>"/>
                                        <input type="hidden" name="oldcodeII<%=j%>" value="<%=fypII%>"/>
                                    </div>
                                    <%}%>
                                </div>
                            </div>
                            <div class="col-3"></div>
                        </div>

                        <input type="hidden" name="i" value="<%=i%>">
                        <input type="hidden" name="ii" value="<%=j%>">

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Update</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="coScheduleTimetable.jsp" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>
                </form>
            </div>
        </div>
    </body>
</html>
