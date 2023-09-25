<%-- 
    Document   : logout
    Created on : Nov 10, 2022, 6:18:53 AM
    Author     : TEOH YI YIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <%session.invalidate();%>

        <jsp:forward page="mainPage.jsp"/>
    </body>
</html>
