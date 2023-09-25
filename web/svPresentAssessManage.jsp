<%-- 
    Document   : svPresentAssessManage
    Created on : Jun 4, 2023, 12:55:17 AM
    Author     : TEOH YI YIN
--%>

<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Supervisor</title>
        <jsp:include page="head.html"/>
    </head>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.0/js/select2.full.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.0/css/select2.css" rel="stylesheet" />

    <style>
        .select2{
            width: 95%;
        }    
        .input-group-text{
            height: 28px;
        }
    </style>

    <script>
        $(function () {
            var $select2 = $('.select2').select2({
                containerCssClass: "wrap"
            })
        })
    </script>

    <%
        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        String action = request.getParameter("action");
        String matricNo = request.getParameter("matricNo");

        int i = 0;
        int k = 0;

        user student = (user) userDao.getStudentDetail(matricNo);
    %>
    <body>
        <jsp:include page="navBar.jsp"/>
        <div class="container">
            <%if (action.equals("Add")) {
                    int assessID = Integer.parseInt(request.getParameter("assessID"));

                    assessment assess = assessmentDao.getAssessCompByID(assessID);
                    List<assessment> criteria = assessmentDao.getCriteriaByAssessID(assessID);
            %>
            <div class="section-title">
                <h2 class="text-center"><%=assess.getAssessComponent()%> (<%=assess.getCompPercentage()%>%)</h2>
            </div>

            <div>
                <h5>Name: <%=student.getName()%></h5>
                <h5>Matric No: <%=matricNo%></h5>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=ADDSTUPRESENTASSESS" class="row g-4 mt-3" method="post">

                    <input type="hidden" name="assessID" value="<%=assessID%>">
                    <input type="hidden" name="matricNo" value="<%=matricNo%>">
                    <input type="hidden" name="svID" value="<%=e.getSvID()%>">

                    <div class="row mb-3">
                        <%for (assessment cri : criteria) {
                                k = 0;
                                i++;
                                List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                        %>
                        <div class="my-1 border p-3"style="background-color:<%=assessment.colorCode(cri.getPlo())%>">
                            <div class="row justify-content-center">
                                <div class="col-10">
                                    <h4><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</h4>
                                </div>
                                <div class="col-2 text-end">
                                    <h4><%=cri.getCriteriaPercentage()%>%</h4>
                                </div>
                            </div>
                            <input type="hidden" name="criteriaID<%=i%>" value="<%=cri.getCriteriaID()%>">

                            <%for (assessment subCri : subCriteria) {
                                    k++;
                                    int highest = 0;
                                    List<assessment> gradingScale = assessmentDao.getGradingScaleBySubCriID(subCri.getSubCriteriaID());

                                    assessment meetScale = null;
                                    int grade = 0;
                                    String gradeDesc = null;
                            %>
                            <div class="row justify-content-center">
                                <div class="col-12">
                                    <div class="input-group">
                                        <div class="input-group-text"><label><%=subCri.getSubCriteria()%></label></div>
                                        <select class="select2" name="stuSubCriteriaMark<%=subCri.getSubCriteriaID()%><%=k%>" required>
                                            <%if (gradeDesc != null) {%>
                                            <option value="<%=grade%>" selected style="display:none;"><%=grade + " - " + gradeDesc%></option>
                                            <%}
                                                for (assessment scale : gradingScale) {
                                                    if (highest < scale.getGradingScale()) {
                                                        highest = scale.getGradingScale();
                                                    }
                                            %>
                                            <option value="<%=scale.getGradingScale()%>"><%=scale.getGradingScale()%> - <%=scale.getScaleDesc()%></option>
                                            <%}%>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="highestCriteriaMark<%=subCri.getSubCriteriaID()%><%=k%>" value="<%=highest%>">
                            <input type="hidden" name="subCriteriaID<%=cri.getCriteriaID()%><%=k%>" value="<%=subCri.getSubCriteriaID()%>">
                            <%}%>

                        </div>
                        <input type='hidden' name='subCriCount<%=i%>' value="<%=k%>">
                        <%}%>

                        <input type='hidden' name='criCount' value="<%=i%>">

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Grade</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="svPresentAssess.jsp" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <%} else if (action.equals("Update")) {
                int stuPresentAssessID = Integer.parseInt(request.getParameter("stuPresentAssessID"));

                evaluation stuAssess = assessmentDao.getStuPresentAssessByID(stuPresentAssessID);
                assessment assess = assessmentDao.getAssessCompByID(stuAssess.getAssessID());
                List<assessment> criteria = assessmentDao.getCriteriaByAssessID(stuAssess.getAssessID());
            %>
            <div class="section-title">
                <h2 class="text-center"><%=assess.getAssessComponent()%> (<%=stuAssess.getStuAssessCompMark()%>%/<%=assess.getCompPercentage()%>%)</h2>
            </div>

            <div>
                <h5>Name: <%=student.getName()%></h5>
                <h5>Matric No: <%=matricNo%></h5>
            </div>

            <div class="form">
                <form action="AssessmentServlet?action=UPDATESTUPRESENTASSESS" class="row g-4 mt-3" method="post">

                    <input type="hidden" name="assessID" value="<%=stuAssess.getAssessID()%>">
                    <input type="hidden" name="stuPresentAssessID" value="<%=stuPresentAssessID%>">
                    <input type="hidden" name="matricNo" value="<%=matricNo%>">

                    <div class="row mb-3">
                        <%for (assessment cri : criteria) {
                                k = 0;
                                i++;
                                evaluation stuCriteriaMark = assessmentDao.getStuPresentCriteriaMarkByIDs(stuPresentAssessID, cri.getCriteriaID());
                                List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());
                        %>
                        <div class="my-1 border p-3" style="background-color:<%=assessment.colorCode(cri.getPlo())%>">
                            <div class="row justify-content-center">
                                <div class="col-10">
                                    <h4><%=cri.getAssessCriteria()%> (<%=cri.getPlo()%>)</h4>
                                </div>
                                <div class="col-2 text-end">
                                    <h4><%=stuCriteriaMark.getStuCriteriaMark()%>/<%=cri.getCriteriaPercentage()%>%</h4>
                                </div>
                            </div>
                            <input type="hidden" name="stuCriteriaID<%=i%>" value="<%=stuCriteriaMark.getStuCriteriaID()%>">
                            <input type="hidden" name="criteriaID<%=i%>" value="<%=cri.getCriteriaID()%>">


                            <%for (assessment subCri : subCriteria) {
                                    k++;
                                    int highest = 0;
                                    assessment stuSubCriteriaMark = assessmentDao.getStuPresentSubCriteriaMarkByIDs(stuCriteriaMark.getStuCriteriaID(), subCri.getSubCriteriaID());
                                    List<assessment> gradingScale = assessmentDao.getGradingScaleBySubCriID(subCri.getSubCriteriaID());
                            %>
                            <div class="row justify-content-center">
                                <div class="col-12">
                                    <div class="input-group">
                                        <div class="input-group-text"><label><%=subCri.getSubCriteria()%></label></div>
                                        <select class="select2" name="stuSubCriteriaMark<%=stuSubCriteriaMark.getScaleID()%><%=k%>" required>
                                            <option value="<%=stuSubCriteriaMark.getGradingScale()%>" selected style="display:none;"><%=stuSubCriteriaMark.getGradingScale() + " - " + stuSubCriteriaMark.getScaleDesc()%></option>
                                            <%for (assessment scale : gradingScale) {
                                                    if (highest < scale.getGradingScale()) {
                                                        highest = scale.getGradingScale();
                                                    }
                                            %>
                                            <option value="<%=scale.getGradingScale()%>"><%=scale.getGradingScale()%> - <%=scale.getScaleDesc()%></option>
                                            <%}%>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="highestCriteriaMark<%=stuSubCriteriaMark.getScaleID()%><%=k%>" value="<%=highest%>">
                            <input type="hidden" name="stuSubCriteriaID<%=cri.getCriteriaID()%><%=k%>" value="<%=stuSubCriteriaMark.getScaleID()%>">
                            <%}%>

                        </div>
                        <input type='hidden' name='subCriCount<%=i%>' value="<%=k%>">

                        <%}%>

                        <input type='hidden' name='criCount' value="<%=i%>">

                        <div class="row justify-content-center pt-2">
                            <div class="col-1 mt-2 mb-5">
                                <button type="submit" value="Submit" class="btn btn-primary">Grade</button>
                            </div>
                            <div class="col-1 mt-2 mb-5">
                                <a href="svPresentAssess.jsp" class="btn btn-primary float-end">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <%}%>
        </div>
    </body>
</html>

