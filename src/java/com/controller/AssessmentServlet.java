package com.controller;

import com.dao.*;
import com.model.*;
import java.io.File;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.*;
import java.util.zip.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

/**
 *
 * @author TEOH YI YIN
 */
public class AssessmentServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");

        SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");

        RequestDispatcher rd = null;
        int status = 0;

        String action = request.getParameter("action");

        switch (action) {
            case "ADDCLOPLO": {
                rd = request.getRequestDispatcher("coLo.jsp");

                String clo = request.getParameter("clo");
                int ploID = Integer.parseInt(request.getParameter("ploID"));
                String loDesc = request.getParameter("loDesc");
                String courseName = request.getParameter("courseName");

                assessment a = new assessment();
                a.setClo(clo);
                a.setPloID(ploID);
                a.setLoDesc(loDesc);
                a.setCourseName(courseName);

                status = assessmentDao.addCloPlo(a);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("AddError", "Failed to add PLO");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATEPLO": {
                rd = request.getRequestDispatcher("coLo.jsp");

                int count = Integer.parseInt(request.getParameter("count"));

                for (int i = 0; i <= count; i++) {
                    String ploID = request.getParameter("ploID" + i);

                    if (ploID != null) {
                        int pid = Integer.parseInt(ploID);

                        String ploSelection = request.getParameter("ploSelection" + i);

                        assessment a = new assessment();
                        a.setPloID(pid);
                        a.setPloSelection(ploSelection);

                        status = assessmentDao.updatePlo(a);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update PLO");
                            rd.forward(request, response);
                        }
                    }
                }

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("UpdateError", "Failed to update PLO");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATELO": {
                rd = request.getRequestDispatcher("coLo.jsp");

                int cloploID = Integer.parseInt(request.getParameter("cloploID"));
                String clo = request.getParameter("clo");
                int ploID = Integer.parseInt(request.getParameter("ploID"));
                String loDesc = request.getParameter("loDesc");
                String courseName = request.getParameter("courseName");

                assessment a = new assessment();
                a.setCloploID(cloploID);
                a.setClo(clo);
                a.setPloID(ploID);
                a.setLoDesc(loDesc);
                a.setCourseName(courseName);

                status = assessmentDao.updateCloPlo(a);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("UpdateError", "Failed to update CLO/PLO");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETECLOPLO": {
                rd = request.getRequestDispatcher("coLo.jsp");

                int cloploID = Integer.parseInt(request.getParameter("CloploID"));

                status = assessmentDao.deleteCloPlo(cloploID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("DeleteError", "Failed to delete CLO/PLO");
                    rd.forward(request, response);
                }
                break;
            }
            case "ADDASSESSCOMP": {
                String assessComp = request.getParameter("assessComp");
                double assessPercentage = Double.parseDouble(request.getParameter("assessPercentage"));
                String courseName = request.getParameter("courseName");
                int criteriaCount = Integer.parseInt(request.getParameter("count"));

                rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName + "&component=" + assessComp);

                assessment a = new assessment();
                a.setAssessComponent(assessComp);
                a.setCompPercentage(assessPercentage);
                a.setCourseName(courseName);

                if (request.getParameter("assessStartDate") == null && request.getParameter("assessEndDate") == null) {
                    long start = d.parse(request.getParameter("assessStartDate")).getTime();
                    Date s = new Date(start);

                    long end = d.parse(request.getParameter("assessEndDate")).getTime();
                    Date e = new Date(end);

                    a.setAssessStartDate(s);
                    a.setAssessEndDate(e);
                }

                status = assessmentDao.addAssessComp(a);

                if (status > 0) {
                    for (int i = 0; i < criteriaCount; i++) {
                        String assessCriteria = request.getParameter("assessCriteria" + i);

                        if (!assessCriteria.isEmpty()) {
                            double criteriaPercentage = Double.parseDouble(request.getParameter("criteriaPercentage" + i));
                            int cloploID = Integer.parseInt(request.getParameter("cloploID" + i));

                            a.setAssessCriteria(assessCriteria);
                            a.setCriteriaPercentage(criteriaPercentage);
                            a.setCloploID(cloploID);

                            status = assessmentDao.addAssessCriteria(a);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to add assessment criteria");
                                rd.forward(request, response);
                            }
                        }
                    }

                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATEASSESSCOMP": {
                int assessID = Integer.parseInt(request.getParameter("assessID"));
                String assessComp = request.getParameter("assessComp");
                double assessPercentage = Double.parseDouble(request.getParameter("assessPercentage"));
                String courseName = request.getParameter("courseName");

                rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName + "&component=" + assessComp);

                int oldCriteriaCount = Integer.parseInt(request.getParameter("oldCriteriaCount"));
                int criteriaCount = Integer.parseInt(request.getParameter("count"));

                assessment a = new assessment();
                a.setAssessID(assessID);
                a.setAssessComponent(assessComp);
                a.setCompPercentage(assessPercentage);
                a.setCourseName(courseName);

                if (!request.getParameter("assessStartDate").isEmpty() && !request.getParameter("assessEndDate").isEmpty()) {
                    long start = d.parse(request.getParameter("assessStartDate")).getTime();
                    Date s = new Date(start);

                    long end = d.parse(request.getParameter("assessEndDate")).getTime();
                    Date e = new Date(end);

                    a.setAssessStartDate(s);
                    a.setAssessEndDate(e);
                }

                status = assessmentDao.updateAssessComp(a);

                if (status > 0) {
                    for (int i = 1; i <= oldCriteriaCount; i++) {
                        int criteriaID = Integer.parseInt(request.getParameter("criteriaID" + i));
                        String oldCriteria = request.getParameter("oldCriteria" + i);
                        double oldPercentage = Double.parseDouble(request.getParameter("oldPercentage" + i));
                        int oldCloPloID = Integer.parseInt(request.getParameter("oldCloPloID" + i));

                        a.setCriteriaID(criteriaID);
                        a.setAssessCriteria(oldCriteria);
                        a.setCriteriaPercentage(oldPercentage);
                        a.setCloploID(oldCloPloID);

                        status = assessmentDao.updateAssessCriteria(a);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update assessment criteria");
                            rd.forward(request, response);
                        }
                    }

                    for (int i = 0; i < criteriaCount; i++) {
                        String assessCriteria = request.getParameter("assessCriteria" + i);

                        if (!assessCriteria.isEmpty()) {
                            double criteriaPercentage = Double.parseDouble(request.getParameter("criteriaPercentage" + i));
                            int cloploID = Integer.parseInt(request.getParameter("cloploID" + i));

                            a.setAssessCriteria(assessCriteria);
                            a.setCriteriaPercentage(criteriaPercentage);
                            a.setCloploID(cloploID);

                            status = assessmentDao.addAssessCriteria(a);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to add assessment criteria");
                                rd.forward(request, response);
                            }
                        }
                    }

                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update main task");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATESUBCRI": {
                int criteriaID = Integer.parseInt(request.getParameter("criteriaID"));
                String courseName = request.getParameter("courseName");
                String assessComp = request.getParameter("assessComp");
                rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName + "&component=" + assessComp);

                int oldSubCriCount = Integer.parseInt(request.getParameter("oldSubCriCount"));
                int count = Integer.parseInt(request.getParameter("count"));

                assessment a = new assessment();
                a.setCriteriaID(criteriaID);

                for (int i = 1; i <= oldSubCriCount; i++) {
                    int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID" + i));
                    String oldSubCriteria = request.getParameter("oldSubCriteria" + i);

                    a.setSubCriteriaID(subCriteriaID);
                    a.setSubCriteria(oldSubCriteria);

                    status = assessmentDao.updateSubCriteria(a);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update assessment sub-criteria");
                        rd.forward(request, response);
                    }
                }

                for (int i = 0; i < count; i++) {
                    String subCriteria = request.getParameter("subCriteria" + i);

                    if (!subCriteria.isEmpty()) {
                        a.setSubCriteria(subCriteria);

                        status = assessmentDao.addSubCriteria(a);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to add assessment sub-criteria");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);

                break;
            }
            case "UPDATEGRADESCALE": {
                int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID"));
                String courseName = request.getParameter("courseName");
                String assessComp = request.getParameter("assessComp");
                rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName + "&component=" + assessComp);

                int oldScaleCount = Integer.parseInt(request.getParameter("oldScaleCount"));
                int count = Integer.parseInt(request.getParameter("count"));

                assessment a = new assessment();
                a.setSubCriteriaID(subCriteriaID);

                for (int i = 1; i <= oldScaleCount; i++) {
                    int scaleID = Integer.parseInt(request.getParameter("scaleID" + i));
                    int oldGrading = Integer.parseInt(request.getParameter("oldGrading" + i));
                    String oldDesc = request.getParameter("oldDesc" + i);

                    a.setScaleID(scaleID);
                    a.setGradingScale(oldGrading);
                    a.setScaleDesc(oldDesc);

                    status = assessmentDao.updateGradingScale(a);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update grading scale");
                        rd.forward(request, response);
                    }
                }

                for (int i = 0; i < count; i++) {
                    String scaleDesc = request.getParameter("scaleDesc" + i);

                    if (!scaleDesc.isEmpty()) {
                        int scaleGrading = Integer.parseInt(request.getParameter("scaleGrading" + i));

                        a.setGradingScale(scaleGrading);
                        a.setScaleDesc(scaleDesc);

                        status = assessmentDao.addGradingScale(a);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to add grading scale");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);
                break;
            }
            case "ADDSTUASSESS": {
                ArrayList<Double> StuCriMark = new ArrayList<>();
                double totalStuCriMark = 0;

                int assessID = Integer.parseInt(request.getParameter("assessID"));
                String matricNo = request.getParameter("matricNo");
                int criCount = Integer.parseInt(request.getParameter("criCount"));

                rd = request.getRequestDispatcher("svStuAssess.jsp");

                evaluation e = new evaluation();
                e.setAssessID(assessID);
                e.setMatricNo(matricNo);

                status = assessmentDao.addStudentAssessment(e);

                if (status > 0) {
                    for (int i = 1; i <= criCount; i++) {
                        int criteriaID = Integer.parseInt(request.getParameter("criteriaID" + i));
                        int subCriCount = Integer.parseInt(request.getParameter("subCriCount" + i));

                        ArrayList<Integer> StuSubCriMark = new ArrayList<>();
                        ArrayList<Integer> SubCriMark = new ArrayList<>();
                        double totalStuSubCriMark = 0, totalSubCriMark = 0;

                        e.setCriteriaID(criteriaID);
                        status = assessmentDao.addStudentCriteriaMark(e);

                        if (status > 0) {
                            for (int j = 1; j <= subCriCount; j++) {
                                int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID" + criteriaID + j));
                                int stuSubCriteriaMark = Integer.parseInt(request.getParameter("stuSubCriteriaMark" + subCriteriaID + j));

                                StuSubCriMark.add(stuSubCriteriaMark);
                                SubCriMark.add(Integer.parseInt(request.getParameter("highestCriteriaMark" + subCriteriaID + j)));

                                e.setSubCriteriaID(subCriteriaID);
                                e.setStuSubCriteriaMark(stuSubCriteriaMark);
                                status = assessmentDao.addStudentSubCriteriaMark(e);

                                if (status < 0) {
                                    request.setAttribute("addError", "Failed to add student's sub-criteria mark");
                                    rd.forward(request, response);
                                }
                            }

                            for (int k = 0; k < SubCriMark.size(); k++) {
                                totalSubCriMark += SubCriMark.get(k);
                                totalStuSubCriMark += StuSubCriMark.get(k);
                            }

                            assessment criteria = assessmentDao.getAssessCriteriaByID(criteriaID);
                            double criteriaPercentage = criteria.getCriteriaPercentage();
                            e.setPloID(criteria.getPloID());

                            double stuCriteriaMark = (totalStuSubCriMark / totalSubCriMark) * criteriaPercentage;
                            StuCriMark.add(stuCriteriaMark);

                            e.setStuCriteriaMark(stuCriteriaMark);
                            e.setStuPLOMark(stuCriteriaMark);
                            status = assessmentDao.updateStudentCriteriaMark(e);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to update student's criteria mark");
                                rd.forward(request, response);
                            } else {
                                status = assessmentDao.addStudentPLOMark(e);

                                if (status < 0) {
                                    request.setAttribute("addError", "Failed to add student's PLO mark");
                                    rd.forward(request, response);
                                }
                            }
                        } else {
                            request.setAttribute("addError", "Failed to add student's criteria mark");
                            rd.forward(request, response);
                        }
                    }

                    for (int k = 0; k < StuCriMark.size(); k++) {
                        totalStuCriMark += StuCriMark.get(k);
                    }

                    assessment assess = assessmentDao.getAssessCompByID(assessID);

                    e.setStuAssessCompMark(totalStuCriMark);
                    e.setStuAssessValid(e.checkAssessValidation(totalStuCriMark, assess.getCompPercentage()));
                    status = assessmentDao.updateStudentAssessment(e);

                    if (status < 0) {
                        request.setAttribute("addError", "Failed to update student's component mark");
                        rd.forward(request, response);
                    } else {
                        rd.forward(request, response);
                    }
                } else {
                    request.setAttribute("addError", "Failed to add student's component mark");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATESTUASSESS": {
                ArrayList<Double> StuCriMark = new ArrayList<>();
                double totalStuCriMark = 0;

                int stuAssessID = Integer.parseInt(request.getParameter("stuAssessID"));
                String matricNo = request.getParameter("matricNo");
                int criCount = Integer.parseInt(request.getParameter("criCount"));

                rd = request.getRequestDispatcher("svStuAssessManage.jsp?assessID=" + stuAssessID + "&matricNo=" + matricNo + "&action=Update");

                evaluation e = new evaluation();
                e.setStuAssessID(stuAssessID);
                e.setMatricNo(matricNo);

                for (int i = 1; i <= criCount; i++) {
                    ArrayList<Integer> StuSubCriMark = new ArrayList<>();
                    ArrayList<Integer> SubCriMark = new ArrayList<>();
                    double totalStuSubCriMark = 0, totalSubCriMark = 0;

                    int stuCriteriaID = Integer.parseInt(request.getParameter("stuCriteriaID" + i));
                    int criteriaID = Integer.parseInt(request.getParameter("criteriaID" + i));
                    int subCriCount = Integer.parseInt(request.getParameter("subCriCount" + i));

                    e.setStuCriteriaID(stuCriteriaID);

                    for (int j = 1; j <= subCriCount; j++) {
                        int stuSubCriteriaID = Integer.parseInt(request.getParameter("stuSubCriteriaID" + criteriaID + j));
                        int stuSubCriteriaMark = Integer.parseInt(request.getParameter("stuSubCriteriaMark" + stuSubCriteriaID + j));

                        StuSubCriMark.add(stuSubCriteriaMark);
                        SubCriMark.add(Integer.parseInt(request.getParameter("highestCriteriaMark" + stuSubCriteriaID + j)));

                        e.setStuSubCriteriaID(stuSubCriteriaID);
                        e.setStuSubCriteriaMark(stuSubCriteriaMark);
                        status = assessmentDao.updateStudentSubCriteriaMark(e);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to add student's sub-criteria mark");
                            rd.forward(request, response);
                        }
                    }

                    for (int k = 0; k < SubCriMark.size(); k++) {
                        totalSubCriMark += SubCriMark.get(k);
                        totalStuSubCriMark += StuSubCriMark.get(k);
                    }

                    assessment criteria = assessmentDao.getAssessCriteriaByID(criteriaID);
                    double criteriaPercentage = criteria.getCriteriaPercentage();
                    e.setPloID(criteria.getPloID());

                    double stuCriteriaMark = (totalStuSubCriMark / totalSubCriMark) * criteriaPercentage;
                    StuCriMark.add(stuCriteriaMark);
                    e.setStuPLOMark(stuCriteriaMark);

                    e.setStuCriteriaMark(stuCriteriaMark);
                    status = assessmentDao.updateStudentCriteriaMark(e);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update student's criteria mark");
                        rd.forward(request, response);
                    } else {
                        status = assessmentDao.updateStuPLOMarkByIDs(e);
                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update student's PLO mark");
                            rd.forward(request, response);
                        }
                    }
                }

                for (int k = 0; k < StuCriMark.size(); k++) {
                    totalStuCriMark += StuCriMark.get(k);
                }

                int assessID = Integer.parseInt(request.getParameter("assessID"));
                assessment assess = assessmentDao.getAssessCompByID(assessID);

                e.setStuAssessCompMark(totalStuCriMark);
                e.setStuAssessValid(e.checkAssessValidation(totalStuCriMark, assess.getCompPercentage()));
                status = assessmentDao.updateStudentAssessment(e);

                if (status < 0) {
                    request.setAttribute("updateError", "Failed to update student's component mark");
                    rd.forward(request, response);
                } else {
                    rd.forward(request, response);
                }
                break;
            }
            case "ASSESSVALID": {
                int stuAssessID = Integer.parseInt(request.getParameter("stuAssessID"));
                String assessValid = request.getParameter("assessValid");
                String courseName = request.getParameter("courseName");
                String comp = request.getParameter("comp");
                String valid = request.getParameter("valid");

                if (courseName.equals("FYP I")) {
                    rd = request.getRequestDispatcher("coAssessValidI.jsp?comp=" + comp + "&valid" + valid);
                } else {
                    rd = request.getRequestDispatcher("coAssessValidII.jsp?comp=" + comp + "&valid" + valid);
                }

                evaluation e = new evaluation();
                e.setStuAssessID(stuAssessID);
                e.setStuAssessValid(assessValid);

                if (comp.equals("Presentation")) {
                    status = assessmentDao.updateStuPresentAssessValid(e);
                } else {
                    status = assessmentDao.updateStuAssessValid(e);
                }

                if (status < 0) {
                    request.setAttribute("validateError", "Failed to update student's assessment validation");
                    rd.forward(request, response);
                } else {
                    rd.forward(request, response);
                }
                break;
            }
            case "ASSESSVALIDALL": {
                String courseName = request.getParameter("courseName");
                String comp = request.getParameter("comp");
                String valid = request.getParameter("valid");

                if (courseName.equals("FYP I")) {
                    rd = request.getRequestDispatcher("coAssessValidI.jsp?comp=" + comp + "&valid" + valid);
                } else {
                    rd = request.getRequestDispatcher("coAssessValidII.jsp?comp=" + comp + "&valid" + valid);
                }

                List<evaluation> stuAssess = null;
                if (comp.equals("Presentation")) {
                    stuAssess = assessmentDao.getStuPresentAssessByComp(comp, courseName);
                    for (evaluation a : stuAssess) {
                        a.setStuAssessValid("Valid");

                        status = assessmentDao.updateStuPresentAssessValid(a);
                    }
                } else {
                    stuAssess = assessmentDao.getStuAssessByComp(comp, courseName);

                    for (evaluation a : stuAssess) {
                        a.setStuAssessValid("Valid");

                        status = assessmentDao.updateStuAssessValid(a);
                    }
                }

                if (status < 0) {
                    request.setAttribute("validateError", "Failed to update student's assessment validation");
                    rd.forward(request, response);
                } else {
                    rd.forward(request, response);
                }
                break;
            }
            case "ADDSTUPRESENTASSESS": {
                ArrayList<Double> StuCriMark = new ArrayList<>();
                double totalStuCriMark = 0;

                int assessID = Integer.parseInt(request.getParameter("assessID"));
                String matricNo = request.getParameter("matricNo");
                int svID = Integer.parseInt(request.getParameter("svID"));
                int criCount = Integer.parseInt(request.getParameter("criCount"));

                rd = request.getRequestDispatcher("svPresentAssess.jsp");

                evaluation e = new evaluation();
                e.setAssessID(assessID);
                e.setMatricNo(matricNo);
                e.setSvID(svID);

                status = assessmentDao.addStudentPresentAssess(e);

                if (status > 0) {
                    for (int i = 1; i <= criCount; i++) {
                        int criteriaID = Integer.parseInt(request.getParameter("criteriaID" + i));
                        int subCriCount = Integer.parseInt(request.getParameter("subCriCount" + i));

                        ArrayList<Integer> StuSubCriMark = new ArrayList<>();
                        ArrayList<Integer> SubCriMark = new ArrayList<>();
                        double totalStuSubCriMark = 0, totalSubCriMark = 0;

                        e.setCriteriaID(criteriaID);
                        status = assessmentDao.addStudentPresentCriteriaMark(e);

                        if (status > 0) {
                            for (int j = 1; j <= subCriCount; j++) {
                                int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID" + criteriaID + j));
                                int stuSubCriteriaMark = Integer.parseInt(request.getParameter("stuSubCriteriaMark" + subCriteriaID + j));

                                StuSubCriMark.add(stuSubCriteriaMark);
                                SubCriMark.add(Integer.parseInt(request.getParameter("highestCriteriaMark" + subCriteriaID + j)));

                                e.setSubCriteriaID(subCriteriaID);
                                e.setStuSubCriteriaMark(stuSubCriteriaMark);
                                status = assessmentDao.addStudentPresentSubCriteriaMark(e);

                                if (status < 0) {
                                    request.setAttribute("addError", "Failed to add student's sub-criteria mark");
                                    rd.forward(request, response);
                                }
                            }

                            for (int k = 0; k < SubCriMark.size(); k++) {
                                totalSubCriMark += SubCriMark.get(k);
                                totalStuSubCriMark += StuSubCriMark.get(k);
                            }

                            assessment criteria = assessmentDao.getAssessCriteriaByID(criteriaID);
                            double criteriaPercentage = criteria.getCriteriaPercentage();
                            e.setPloID(criteria.getPloID());

                            double stuCriteriaMark = (totalStuSubCriMark / totalSubCriMark) * criteriaPercentage;
                            StuCriMark.add(stuCriteriaMark);
                            e.setStuPLOMark(stuCriteriaMark);

                            e.setStuCriteriaMark(stuCriteriaMark);
                            status = assessmentDao.updateStudentPresentCriteriaMark(e);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to update student's criteria mark");
                                rd.forward(request, response);
                            } else {
                                status = assessmentDao.addStuPresentPLOMark(e);

                                if (status < 0) {
                                    request.setAttribute("addError", "Failed to update student's PLO mark");
                                    rd.forward(request, response);
                                }
                            }
                        } else {
                            request.setAttribute("addError", "Failed to add student's criteria mark");
                            rd.forward(request, response);
                        }
                    }

                    for (int k = 0; k < StuCriMark.size(); k++) {
                        totalStuCriMark += StuCriMark.get(k);
                    }

                    assessment assess = assessmentDao.getAssessCompByID(assessID);
                    e.setStuAssessCompMark(totalStuCriMark);

                    e.setStuAssessValid(e.checkAssessValidation(totalStuCriMark, assess.getCompPercentage()));
                    status = assessmentDao.updateStudentPresentAssess(e);

                    if (status < 0) {
                        request.setAttribute("addError", "Failed to update student's component mark");
                        rd.forward(request, response);
                    } else {
                        rd.forward(request, response);
                    }
                } else {
                    request.setAttribute("addError", "Failed to add student's component mark");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATESTUPRESENTASSESS": {
                ArrayList<Double> StuCriMark = new ArrayList<>();
                double totalStuCriMark = 0;

                int stuPresentAssessID = Integer.parseInt(request.getParameter("stuPresentAssessID"));
                String matricNo = request.getParameter("matricNo");
                int criCount = Integer.parseInt(request.getParameter("criCount"));

                rd = request.getRequestDispatcher("svPresentAssess.jsp");

                evaluation e = new evaluation();
                e.setStuAssessID(stuPresentAssessID);
                e.setMatricNo(matricNo);

                for (int i = 1; i <= criCount; i++) {
                    ArrayList<Integer> StuSubCriMark = new ArrayList<>();
                    ArrayList<Integer> SubCriMark = new ArrayList<>();
                    double totalStuSubCriMark = 0, totalSubCriMark = 0;

                    int stuCriteriaID = Integer.parseInt(request.getParameter("stuCriteriaID" + i));
                    int criteriaID = Integer.parseInt(request.getParameter("criteriaID" + i));
                    int subCriCount = Integer.parseInt(request.getParameter("subCriCount" + i));

                    e.setStuCriteriaID(stuCriteriaID);

                    for (int j = 1; j <= subCriCount; j++) {
                        int stuSubCriteriaID = Integer.parseInt(request.getParameter("stuSubCriteriaID" + criteriaID + j));
                        int stuSubCriteriaMark = Integer.parseInt(request.getParameter("stuSubCriteriaMark" + stuSubCriteriaID + j));

                        StuSubCriMark.add(stuSubCriteriaMark);
                        SubCriMark.add(Integer.parseInt(request.getParameter("highestCriteriaMark" + stuSubCriteriaID + j)));

                        e.setStuSubCriteriaID(stuSubCriteriaID);
                        e.setStuSubCriteriaMark(stuSubCriteriaMark);
                        status = assessmentDao.updateStudentPresentSubCriteriaMark(e);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to add student's sub-criteria mark");
                            rd.forward(request, response);
                        }
                    }

                    for (int k = 0; k < SubCriMark.size(); k++) {
                        totalSubCriMark += SubCriMark.get(k);
                        totalStuSubCriMark += StuSubCriMark.get(k);
                    }

                    assessment criteria = assessmentDao.getAssessCriteriaByID(criteriaID);
                    double criteriaPercentage = criteria.getCriteriaPercentage();
                    e.setPloID(criteria.getPloID());

                    double stuCriteriaMark = (totalStuSubCriMark / totalSubCriMark) * criteriaPercentage;
                    StuCriMark.add(stuCriteriaMark);
                    e.setStuPLOMark(stuCriteriaMark);

                    e.setStuCriteriaMark(stuCriteriaMark);
                    status = assessmentDao.updateStudentPresentCriteriaMark(e);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update student's criteria mark");
                        rd.forward(request, response);
                    } else {
                        status = assessmentDao.updateStuPresentPLOMarkByIDs(e);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update student's PLO mark");
                            rd.forward(request, response);
                        }
                    }
                }

                for (int k = 0; k < StuCriMark.size(); k++) {
                    totalStuCriMark += StuCriMark.get(k);
                }

                int assessID = Integer.parseInt(request.getParameter("assessID"));
                assessment assess = assessmentDao.getAssessCompByID(assessID);

                e.setStuAssessCompMark(totalStuCriMark);
                e.setStuAssessValid(e.checkAssessValidation(totalStuCriMark, assess.getCompPercentage()));
                status = assessmentDao.updateStudentPresentAssess(e);

                if (status < 0) {
                    request.setAttribute("updateError", "Failed to update student's component mark");
                    rd.forward(request, response);
                } else {
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETECOMP": {
                String courseName = request.getParameter("courseName");
                rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName);

                int assessID = Integer.parseInt(request.getParameter("assessID"));

                status = assessmentDao.deleteAssessComp(assessID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete assessment component");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETECRI": {
                String courseName = request.getParameter("courseName");
                if (request.getParameter("assessID") == null) {
                    rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName);
                } else {
                    int assessID = Integer.parseInt(request.getParameter("assessID"));
                    rd = request.getRequestDispatcher("coAssessCompManage.jsp?action=Update&assessID=" + assessID + "&courseName=" + courseName);
                }

                int criteriaID = Integer.parseInt(request.getParameter("criteriaID"));

                status = assessmentDao.deleteAssessCriteria(criteriaID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete assessment criteria");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETESUBCRI": {
                String courseName = request.getParameter("courseName");
                if (request.getParameter("criteriaID") == null) {
                    rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName);
                } else {
                    int criteriaID = Integer.parseInt(request.getParameter("criteriaID"));
                    rd = request.getRequestDispatcher("coAssessCriteriaManage.jsp?criteriaID=" + criteriaID);
                }

                int subCriteriaID = Integer.parseInt(request.getParameter("subCriteriaID"));

                status = assessmentDao.deleteSubCriteria(subCriteriaID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete assessment sub-criteria");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETESCALE": {
                String courseName = request.getParameter("courseName");

                if (request.getParameter("subCriteriaID") == null) {
                    rd = request.getRequestDispatcher("coAssessRubric.jsp?status=" + courseName);
                } else {
                    int criteriaID = Integer.parseInt(request.getParameter("subCriteriaID"));
                    rd = request.getRequestDispatcher("coAssessGradingManage.jsp?subCriteriaID=" + criteriaID);
                }

                int scaleID = Integer.parseInt(request.getParameter("scaleID"));

                status = assessmentDao.deleteGradingScale(scaleID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete grading scale");
                    rd.forward(request, response);
                }
                break;
            }
            case "EVALUATE": {
                String courseName = request.getParameter("courseName");

                rd = request.getRequestDispatcher("coEvaluation.jsp?courseName=" + courseName);

                List<evaluation> evaluateList = assessmentDao.getEvaluationListByCrsName(courseName);

                for (evaluation l : evaluateList) {
                    evaluation presentMark = assessmentDao.getStuPresentAssessAVGByMatricNoID(l.getMatricNo());
                    double assessMark = assessmentDao.getStuAssessMark(l.getMatricNo());

                    double totalMark = presentMark.getStuAssessCompMark() + assessMark;
                    String grade = evaluation.grading(totalMark);

                    l.setTotalMark(totalMark);
                    l.setGrade(grade);
                    status = assessmentDao.updateEvaluation(l);

                    if (status < 0) {
                        request.setAttribute("addError", "Failed to evaluate");
                        rd.forward(request, response);
                    }
                }

                rd.forward(request, response);

                break;
            }
            case "EXPORTPLO": {
                int count = Integer.parseInt(request.getParameter("count"));
                int stuCount = Integer.parseInt(request.getParameter("stuCount"));
                String courseName = request.getParameter("courseName");

                try (ZipOutputStream zipOutStream = new ZipOutputStream(response.getOutputStream())) {
                    response.setContentType("application/zip");
                    response.setHeader("Content-Disposition", "attachment; filename=" + courseName + " - plo.zip");

                    //loop to create multiple Excel file
                    for (int i = 0; i < count; i++) {

                        int ploID = Integer.parseInt(request.getParameter("ploID" + i));

                        assessment ploDetails = assessmentDao.getPloByIDCrsName(ploID, courseName);
                        String plo = ploDetails.getPlo() + " " + ploDetails.getClo();
                        String ploDesc = ploDetails.getPloDesc();

                        double ploMark = assessmentDao.getTotalPloMarkByPlo(courseName, ploID);

                        String excelFilePath = "/home/s58798/" + ploDetails.getPlo() + ".xlsx";
                        String csvFilePath = "/home/s58798/" + ploDetails.getPlo() + ".csv";

                        //create new workbook and sheet
                        XSSFWorkbook workbook = new XSSFWorkbook();
                        XSSFSheet sheet = workbook.createSheet(ploDetails.getPlo());

                        //write data to sheet
                        int rowCount = 4;
                        assessment.writeHeader(sheet, i + 1, plo, ploDesc, ploMark);

                        for (int j = 1; j <= stuCount; j++) {
                            String matricNo = request.getParameter("matricNo" + j);
                            user stu = userDao.getStudentDetail(matricNo);
                            double stuPLOMark=0;
                            if(request.getParameter("stuPLOMark" + (i + 1) + j) != null){
                            stuPLOMark = Double.parseDouble(request.getParameter("stuPLOMark" + (i + 1) + j));
                            }                            
                            
                            assessment.writeDataLines(rowCount, j, matricNo, stu.getName(), stuPLOMark, sheet);
                            rowCount++;
                        }

                        FileOutputStream fileOut = new FileOutputStream(excelFilePath);
                        workbook.write(fileOut);
                        fileOut.close();
                        workbook.close();

                        try {
                            Workbook wb = WorkbookFactory.create(new FileInputStream(excelFilePath));

                            // Get the first sheet
                            Sheet newSheet = wb.getSheetAt(0);

                            // Create a CSV writer
                            FileWriter csvWriter = new FileWriter(csvFilePath);

                            // Create a data formatter to format cell values as strings
                            DataFormatter dataFormatter = new DataFormatter();

                            // Iterate over rows and columns and write cell values to CSV
                            for (Row row : newSheet) {
                                for (Cell cell : row) {
                                    String cellValue = dataFormatter.formatCellValue(cell);
                                    csvWriter.append(cellValue);
                                    csvWriter.append(",");
                                }
                                csvWriter.append("\n");
                            }

                            // Close the CSV writer and workbook
                            csvWriter.flush();
                            csvWriter.close();
                            wb.close();
                            try (FileInputStream fis = new FileInputStream(csvFilePath)) {
                                ZipEntry zipEntry = new ZipEntry(csvFilePath);
                                zipOutStream.putNextEntry(zipEntry);

                                byte[] bytes = new byte[1024];
                                int length;
                                while ((length = fis.read(bytes)) >= 0) {
                                    zipOutStream.write(bytes, 0, length);
                                }
                                fis.close();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }

                            File tempFile = new File(excelFilePath);
                            tempFile.delete();

                            File csvFile = new File(csvFilePath);
                            csvFile.delete();

                        } catch (Exception e) {
                        }
                    }
                    break;
                }
            }
            default:
                break;
        }
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response
    )
            throws ServletException,
             IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(AssessmentServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response
    )
            throws ServletException,
             IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(AssessmentServlet.class
                    .getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
