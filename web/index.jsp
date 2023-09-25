<%-- 
    Document   : mainPage
    Created on : Dec 3, 2022, 9:47:09 PM
    Author     : user
--%>


<%@page import="java.util.List"%>
<%@page import="com.model.*"%>
<%@page import="com.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre</title>        
        <jsp:include page="head.html"/>
    </head>
    <%
        List<schedule> schedule = scheduleDao.getSchedule();

        List<schedule> manuals = scheduleDao.getMaterialByType("Manuals & Handbook");
        List<schedule> brief = scheduleDao.getMaterialByType("Briefing Materials");
        List<schedule> dissertation = scheduleDao.getMaterialByType("Sample Dissertations");
        List<schedule> templates = scheduleDao.getMaterialByType("Templates");

        List<presentation> presentation = presentationDao.getPresentationList();
    %>
    <body>
        <header id="header" class="d-flex align-items-center">
            <div class="container d-flex align-items-center justify-content-between">

                <h1 class="logo"><a href="mainPage.jsp"><img src="img/FYPLogo.PNG" class="FYPLogo rounded"></a></h1>

                <nav id="navbar" class="navbar">
                    <ul>
                        <li><a class="nav-link scrollto active" href="#home">Home</a></li>
                        <li><a class="nav-link scrollto" href="#schedule">Schedule</a></li>
                        <li><a class="nav-link scrollto" href="#Materials">Materials</a></li>
                        <li><a class="nav-link scrollto" href="#Presentation">Presentation</a></li>
                        <li><a class="nav-link scrollto " href="login.jsp">Login</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <section id="home" class="d-flex justify-content-center">
            <img src="img/FYPBand.PNG" class="FYPBand">
        </section>

        <main id="main">
            <section id="schedule" class="schedule">
                <div class="container" data-aos="fade-up">

                    <div class="section-title">
                        <h2>Schedule</h2>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th>Week</th>
                                <th>Date</th>
                                <th>Activity</th>
                                <th>Action</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%for (schedule s : schedule) {%>
                            <tr>
                                <td><%=s.getWeek()%></td>

                                <%if (s.getDate() == null) {%>
                                <td></td>
                                <%} else {%>
                                <td><%=s.getDate()%></td>
                                <%}%>

                                <%
                                    if (s.getMaterialID() != 0) {
                                        if (s.getMaterialLink() == null) {
                                %>
                                <td><%=s.getActivity()%></td>
                                <%} else {%>
                                <td><a href="<%=s.getMaterialLink()%>" class="a-link"><%=s.getActivity()%></a></td>
                                    <%}%>
                                    <%} else {%>
                                <td><%=s.getActivity()%></td>
                                <%}%>

                                <td><%=s.getAction()%></td>

                                <%if (s.getMaterialDoc() != null && s.getMaterialDoc().length > 0) {%>
                                <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=s.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                        <%} else {%>
                                <td></td>
                                <%}%>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
            </section>

            <section id="Materials" class="Materials">
                <div class="container" data-aos="fade-up">

                    <div class="section-title">
                        <h2>Materials</h2>
                    </div>

                    <table class="table table-hover">
                        <tr>
                            <th colspan="3" class="lightBlue">Manuals & Handbook</th>
                        </tr>
                        <%for (schedule m : manuals) {%>
                        <tr>
                            <td>
                                <%if (m.getMaterialLink() == null) {%>
                                <%=m.getMaterialName()%>
                                <%} else {%>
                                <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                                <%}%>
                            </td>
                            <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                            <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%} else {%>
                            <td></td>
                            <%}%>
                        </tr>
                        <%}%>
                        <tr>
                            <th colspan="3" class="lightBlue">Briefing Materials</th>
                        </tr>
                        <%for (schedule m : brief) {%>
                        <tr>
                            <td>
                                <%if (m.getMaterialLink() == null) {%>
                                <%=m.getMaterialName()%>
                                <%} else {%>
                                <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                                <%}%>
                            </td>
                            <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                            <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%} else {%>
                            <td></td>
                            <%}%>
                        </tr>
                        <%}%>
                        <tr>
                            <th colspan="3" class="lightBlue">Sample Dissertations</th>
                        </tr>
                        <%for (schedule m : dissertation) {%>
                        <tr>
                            <td>
                                <%if (m.getMaterialLink()== null) {%>
                                <%=m.getMaterialName()%>
                                <%} else {%>
                                <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                                <%}%>
                            </td>
                            <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                            <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%} else {%>
                            <td></td>
                            <%}%>
                        </tr>
                        <%}%>
                        <tr>
                            <th colspan="3" class="lightBlue">Templates</th>
                        </tr>
                        <%for (schedule m : templates) {%>
                        <tr>
                            <td>
                                <%if (m.getMaterialLink()== null) {%>
                                <%=m.getMaterialName()%>
                                <%} else {%>
                                <a href="<%=m.getMaterialLink()%>" class="a-link"><%=m.getMaterialName()%></a>
                                <%}%>
                            </td>
                            <%if (m.getMaterialDoc() != null && m.getMaterialDoc().length > 0) {%>
                            <td><a href="ScheduleServlet?action=VIEWMATERIAL&materialID=<%=m.getMaterialID()%>"><i class="bi bi-eye-fill icon-color"></i></a></td>
                                    <%} else {%>
                            <td></td>
                            <%}%>
                        </tr>
                        <%}%>
                    </table>
                </div>
            </section>

            <section id="Presentation" class="Presentation">
                <div class="container" data-aos="fade-up">

                    <div class="section-title">
                        <h2>Presentation Details</h2>
                    </div>

                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th class="text-center">Total Students</th>
                                <th class="text-center">Location Validation</th>
                                <th class="text-center">Preparing Status</th>
                                <th>Remark</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String[] color = new String[]{"lightBlue", "lightYellow"};
                                int i = 0;
                                for (presentation p : presentation) {
                                    i++;
                                    List<presentation> presentDetails = presentationDao.getPresentationListByGpNo(p.getPanelGpNo());
                            %>
                            <%if (i % 2 == 0) {%>
                            <tr class="<%=color[1]%>">
                                <%} else {%>
                            <tr class="<%=color[0]%>">
                                <%}%>

                                <th>Group <%=p.getPanelGpNo()%> - <%=p.getPresentLocate()%></th>
                                <%if(p.getPresentLink() == null){%>
                                <th colspan="7"></th>
                                <%}else{%>
                                <th colspan="7"><a href="<%=p.getPresentLink()%>"><i class="bi bi-link icon-color"></i></a></th>
                                <%}%>
                                
                            </tr>

                            <%for (presentation details : presentDetails) {%>
                            <tr>
                                <td><%=details.getPresentDate()%></td>
                                <td><%=details.getPresentStartTime()%> - <%=details.getPresentEndTime()%></td>
                                <td class="text-center"><%=details.getStuNum()%></td>
                                
                                <%if (details.getPresentLocateValid().equals("Invalid")) {%>
                                <td class="text-danger text-center"><%=details.getPresentLocateValid()%></td>
                                <%} else {%>
                                <td class="text-center"><%=details.getPresentLocateValid()%></td>
                                <%}%>

                                <%if (details.getPresentSetUp().equals("Done")) {%>
                                <td class="text-center"><%=details.getPresentSetUp()%></td>
                                <%} else {%>
                                <td class="text-danger text-center"><%=details.getPresentSetUp()%></td>
                                <%}%>
                                
                                <td><%=details.getPresentRemark()%></td>
                            </tr>
                            <%}
                                }%>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </body>

    <script>
        /* Navbar links active state on scroll*/
        let navbarlinks = select('#navbar .scrollto', true);
        const navbarlinksActive = () => {
            let position = window.scrollY + 200;
            navbarlinks.forEach(navbarlink => {
                if (!navbarlink.hash)
                    return;
                let section = select(navbarlink.hash);
                if (!section)
                    return;
                if (position >= section.offsetTop && position <= (section.offsetTop + section.offsetHeight)) {
                    navbarlink.classList.add('active');
                } else {
                    navbarlink.classList.remove('active');
                }
            })
        }
        window.addEventListener('load', navbarlinksActive);
        onscroll(document, navbarlinksActive);

        /* Scrolls to an element with header offset*/
        const scrollto = (el) => {
            let header = select('#header');
            let offset = header.offsetHeight;

            if (!header.classList.contains('header-scrolled')) {
                offset -= 16;
            }

            let elementPos = select(el).offsetTop;
            window.scrollTo({
                top: elementPos - offset,
                behavior: 'smooth'
            });
        };

        /*Header fixed top on scroll*/
        let selectHeader = select('#header');
        if (selectHeader) {
            let headerOffset = selectHeader.offsetTop;
            let nextElement = selectHeader.nextElementSibling;
            const headerFixed = () => {
                if ((headerOffset - window.scrollY) <= 0) {
                    selectHeader.classList.add('fixed-top');
                    nextElement.classList.add('scrolled-offset');
                } else {
                    selectHeader.classList.remove('fixed-top');
                    nextElement.classList.remove('scrolled-offset');
                }
            };
            window.addEventListener('load', headerFixed);
            onscroll(document, headerFixed);
        }
    </script>
</html>
