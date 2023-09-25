<%-- 
    Document   : coAssessDetailPerStu
    Created on : Jun 20, 2023, 11:31:52 PM
    Author     : TEOH YI YIN
--%>

<%@page import="com.dao.*"%>
<%@page import="com.model.*"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>FYP One Stop Centre - Coordinator</title>
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
        String matricNo = request.getParameter("matricNo");
        user student = (user) userDao.getStudentDetail(matricNo);

        int mFrequency = logbookDao.getMeetingFrequency(matricNo);

        String comp = request.getParameter("comp");
        int stuAssessID = Integer.parseInt(request.getParameter("stuAssessID"));

        evaluation stuAssess = null;
        if (comp.equals("Presentation")) {
            stuAssess = assessmentDao.getStuPresentAssessByID(stuAssessID);
        } else {
            stuAssess = assessmentDao.getStuAssessmentByID(stuAssessID);
        }

        assessment assess = assessmentDao.getAssessCompByID(stuAssess.getAssessID());
        List<assessment> criteria = assessmentDao.getCriteriaByAssessID(stuAssess.getAssessID());
    %>
    <body>
        <div class="container">
            <div class="section-title">
                <h2 class="text-center"><%=assess.getAssessComponent()%> (<%=stuAssess.getStuAssessCompMark()%>/<%=assess.getCompPercentage()%>%)</h2>
            </div>

            <div class="enroll-con d-flex justify-content-between">
                <div>
                    <h5>Name: <%=student.getName()%></h5>
                    <h5>Matric No: <%=matricNo%></h5>
                </div>

                <div>
                    <select class="form-select" onchange="window.location = 'AssessmentServlet?action=ASSESSVALID&stuAssessID=<%=stuAssess.getStuAssessID()%>&comp=<%=assess.getAssessComponent()%>&courseName=<%=assess.getCourseName()%>&assessValid=' + this.value">
                        <option value="<%=stuAssess.getStuAssessValid()%>" selected style="display:none;"><%=stuAssess.getStuAssessValid()%></option>                                
                        <option value="Valid">Valid</option>
                        <option style="color:red" value="Invalid">Invalid</option>
                    </select>
                </div>
            </div>

            <div class="form">
                <div class="row mb-3">
                    <%for (assessment cri : criteria) {
                            evaluation stuCriteriaMark = null;
                            List<assessment> subCriteria = assessmentDao.getSubCriteriaByCriteriaID(cri.getCriteriaID());

                            if (comp.equals("Presentation")) {
                                stuCriteriaMark = assessmentDao.getStuPresentCriteriaMarkByIDs(stuAssessID, cri.getCriteriaID());
                            } else {
                                stuCriteriaMark = assessmentDao.getStuCriteriaMarkByIDs(stuAssessID, cri.getCriteriaID());
                            }
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

                        <%if (cri.getAssessCriteria().equals("Discipline")) {%>
                        <div class="row justify-content-center">
                            <p>Meeting Frequency = <%=mFrequency%></p>
                        </div>
                        <%}%>

                        <%for (assessment subCri : subCriteria) {
                                assessment stuSubCriteriaMark = null;

                                if (comp.equals("Presentation")) {
                                    stuSubCriteriaMark = assessmentDao.getStuPresentSubCriteriaMarkByIDs(stuCriteriaMark.getStuCriteriaID(), subCri.getSubCriteriaID());
                                } else {
                                    stuSubCriteriaMark = assessmentDao.getStuSubCriteriaMarkByIDs(stuCriteriaMark.getStuCriteriaID(), subCri.getSubCriteriaID());
                                }
                        %>
                        <div class="row justify-content-center">
                            <div class="col-12">
                                <label><%=subCri.getSubCriteria()%></label>
                                <div class="input-group">
                                    <%if(stuSubCriteriaMark.getGradingScale() == 0){%>
                                    <p  class="form-control text-danger"><%=stuSubCriteriaMark.getGradingScale() + " - " + stuSubCriteriaMark.getScaleDesc()%></p>
                                    <%}else{%>
                                    <p  class="form-control"><%=stuSubCriteriaMark.getGradingScale() + " - " + stuSubCriteriaMark.getScaleDesc()%></p>
                                    <%}%>
                                    
                                </div>
                            </div>
                        </div>
                        <%}%>
                    </div>
                    <%}%>
                </div>
            </div>
                <div class="row justify-content-center pt-2">
                        <div class="col-1 mt-2 mb-5">
                            <%if(assess.getCourseName().equals("FYP I")){%>
                            <a href="coAssessValidI.jsp?comp=<%=comp%>" class="btn btn-primary float-end">Back</a>
                            <%}else{%>
                            <a href="coAssessValidII.jsp?comp=<%=comp%>" class="btn btn-primary float-end">Back</a>
                            <%}%>
                            
                        </div>
                    </div>
        </div>
    </body>
</html>
