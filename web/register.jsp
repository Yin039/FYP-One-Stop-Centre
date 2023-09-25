<%-- 
    Document   : login
    Created on : Nov 10, 2022, 6:14:37 AM
    Author     : YI YIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Registration</title>
        <jsp:include page="head.html"/>
    </head>
    <body>
        
        <div class="login-page bg-light">
            <div class="container">
                <h6 class="text-danger text-center mt-5">${registerError}</h6>
                <div class="row">
                    <div class="col-lg-10 offset-lg-1">
                        <div class="bg-white shadow rounded">
                            <div class="row">
                                <div class="col-md-7 pe-0">
                                    <div class="form-left h-100 py-5 px-5">
                                        <form action="UserServlet?action=REGISTER" class="row g-4" method="POST">
                                            <div class="col-12">
                                                <label>Email<span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <div class="input-group-text"><i class="bi bi-envelope-fill"></i></div>
                                                    <input type="text" class="form-control" id="email" placeholder="Enter Email" name="email" required/>
                                                </div>
                                                <span class="text-danger">${emailError}</span>
                                            </div>

                                            <div class="col-12">
                                                <label>Password<span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <div class="input-group-text"><i class="bi bi-lock-fill"></i></div>
                                                    <input type="text" class="form-control" id="password" placeholder="Enter Password" name="password" required/>
                                                </div>
                                                <span class="text-danger">${passwordError}</span>
                                            </div>

                                            <div class="col-12">
                                                <label>Name<span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <div class="input-group-text"><i class="bi bi-person-fill"></i></div>
                                                    <input type="text" class="form-control" id="password" placeholder="Enter Name" name="name" required/>
                                                </div>
                                            </div>

                                            <div class="col-12">
                                                <label>HP No.<span class="text-danger">*</span></label>
                                                <div class="input-group">
                                                    <div class="input-group-text"><i class="bi bi-telephone-fill"></i></div>
                                                    <input type="text" class="form-control" id="password" placeholder="Enter Phone Number" name="hpNo" required/>
                                                </div>
                                                <span class="text-danger">${hpError}</span>
                                            </div>
                                            
                                            <input type="hidden" name="offLoginValid" value="To Valid"/>

                                            <div class="col-sm-6">
                                                <a href="login.jsp" class="a-link float-start">Back to Login Page</a>
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" value="Submit" class="btn btn-primary float-end">Register</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="col-md-5 ps-0 d-none d-md-block">
                                    <div class="form-right h-100 bgColor text-white text-center pt-5">
                                        <div class="mt-5">
                                            <a class="mx-auto" href="mainPage.jsp">
                                                <img class='img-fluid mx-auto d-block w-50 pt-5' src='img/UMTLogo.png'/>
                                            </a>
                                            <h1 class="h1">
                                                Final Year Project 
                                                <br> 
                                                One Stop Centre
                                            </h1>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

