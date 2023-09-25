/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.controller;

import com.dao.*;
import com.model.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author TEOH YI YIN
 */
@MultipartConfig
public class ProjectProgressServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        RequestDispatcher rd;
        int status = 0;

        String action = request.getParameter("action");

        switch (action) {
            case "ADDTASK": {
                rd = request.getRequestDispatcher("coProjTask.jsp");

                String mainTask = request.getParameter("mainTask");
                String courseName = request.getParameter("courseName");
                int subTaskCount = Integer.parseInt(request.getParameter("count"));

                projectProgress progress = new projectProgress();
                progress.setMainTask(mainTask);
                progress.setCourseName(courseName);

                status = projectProgressDao.addMainTask(progress);

                if (status > 0) {
                    for (int i = 1; i <= subTaskCount; i++) {
                        String subTask = request.getParameter("subTask" + i);

                        if (!subTask.isEmpty()) {
                            progress.setSubTask(subTask);

                            status = projectProgressDao.addSubTask(progress);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to add sub-task");
                                rd.forward(request, response);
                            }

                            List<project> projectApproved = projectDao.getProjectByApprovalStatus("Approved");
                            for (project p : projectApproved) {
                                projectProgress newTrack = new projectProgress();
                                newTrack.setProjectID(p.getProjectID());
                                newTrack.setSubTaskID(progress.getSubTaskID());

                                projectProgressDao.addTracking(newTrack);
                            }
                        }
                    }

                    rd.forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add main task");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETEMAIN": {
                rd = request.getRequestDispatcher("coProjTask.jsp");
                int mainTaskID = Integer.parseInt(request.getParameter("mainTaskID"));

                status = projectProgressDao.deleteMainTask(mainTaskID);
                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete main task");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATETASK": {
                rd = request.getRequestDispatcher("coProjTask.jsp");

                int mainTaskID = Integer.parseInt(request.getParameter("mainTaskID"));
                String mainTask = request.getParameter("mainTask");

                int oldSubTaskCount = Integer.parseInt(request.getParameter("oldSubTaskCount"));
                int subTaskCount = Integer.parseInt(request.getParameter("count"));

                projectProgress progress = new projectProgress();
                progress.setMainTaskID(mainTaskID);
                progress.setMainTask(mainTask);

                status = projectProgressDao.updateMainTask(progress);

                if (status > 0) {
                    for (int i = 1; i <= oldSubTaskCount; i++) {
                        int subTaskID = Integer.parseInt(request.getParameter("subTaskID" + i));
                        String subTask = request.getParameter("oldTask" + i);

                        progress.setSubTaskID(subTaskID);
                        progress.setSubTask(subTask);

                        status = projectProgressDao.updateSubTask(progress);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update sub-task");
                            rd.forward(request, response);
                        }
                    }

                    for (int i = 0; i < subTaskCount; i++) {
                        String subTask = request.getParameter("subTask" + i);

                        if (!subTask.isEmpty()) {
                            progress.setSubTask(subTask);

                            status = projectProgressDao.addSubTask(progress);

                            if (status < 0) {
                                request.setAttribute("updateError", "Failed to update sub-task");
                                rd.forward(request, response);
                            }

                            List<project> projectApproved = projectDao.getProjectByApprovalStatus("Approved");
                            for (project p : projectApproved) {
                                projectProgress newTrack = new projectProgress();
                                newTrack.setProjectID(p.getProjectID());
                                newTrack.setSubTaskID(progress.getSubTaskID());

                                projectProgressDao.addTracking(newTrack);
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
            case "DELETESUBTASK": {
                int mainTaskID = Integer.parseInt(request.getParameter("mainTaskID"));
                int subTaskID = Integer.parseInt(request.getParameter("subTaskID"));

                status = projectProgressDao.deleteSubTask(subTaskID);

                if (status > 0) {
                    request.getRequestDispatcher("coProjTaskManage.jsp?action=Update&mainTaskID=" + mainTaskID).forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete sub task");
                    request.getRequestDispatcher("coProjTaskManage.jsp?action=Update&mainTaskID=" + mainTaskID).forward(request, response);
                }
                break;
            }
            case "UPDATETRACK": {
                String stuUserID = request.getParameter("stuUserID");
                rd = request.getRequestDispatcher("svStuDetail.jsp?stuUserID=" + stuUserID);

                int count = Integer.parseInt(request.getParameter("count"));
                double overallPercentage = 0, taskChecked = 0, totalSubTask = 0;

                for (int i = 1; i <= count; i++) {
                    if (request.getParameter("subTaskCount" + i) != null) {
                        int subTaskCount = Integer.parseInt(request.getParameter("subTaskCount" + i));
                        totalSubTask += subTaskCount;
                        String mainTask = request.getParameter("mainTask" + i);

                        if (mainTask.equals("Project")) {
                            for (int j = 1; j <= subTaskCount; j++) {

                                String moduleTrackID = request.getParameter("moduleTrackID" + j);

                                if (moduleTrackID != null) {
                                    int tid = Integer.parseInt(moduleTrackID);
                                    String module = request.getParameter("module" + j);

                                    String moduleStatus = request.getParameter("moduleStatus" + j);
                                    if (moduleStatus.equals("Complete")) {
                                        taskChecked++;
                                    }

                                    projectProgress progress = new projectProgress();
                                    progress.setModuleTrackID(tid);
                                    progress.setModule(module);
                                    progress.setTrackStatus(moduleStatus);

                                    status = projectProgressDao.updateModuleTrack(progress);

                                    if (status < 0) {
                                        request.setAttribute("updateError", "Failed to update tracker");
                                        rd.forward(request, response);
                                    }
                                }
                            }
                        } else {
                            for (int j = 1; j <= subTaskCount; j++) {
                                String trackID = request.getParameter("trackID" + mainTask + j);

                                if (trackID != null) {
                                    int tid = Integer.parseInt(trackID);

                                    String trackStatus = request.getParameter("trackStatus" + mainTask + j);
                                    if (trackStatus.equals("Complete")) {
                                        taskChecked++;
                                    }

                                    projectProgress progress = new projectProgress();
                                    progress.setTrackID(tid);
                                    progress.setTrackStatus(trackStatus);

                                    status = projectProgressDao.updateTracking(progress);

                                    if (status < 0) {
                                        request.setAttribute("updateError", "Failed to update tracker");
                                        rd.forward(request, response);
                                    }
                                }
                            }
                        }
                    }
                }

                overallPercentage = (taskChecked / totalSubTask) * 100;

                double projectProgress = Double.parseDouble(String.format("%.2f", overallPercentage));
                int projectID = Integer.parseInt(request.getParameter("projectID"));

                status = projectProgressDao.updateProjectProgress(projectProgress, projectID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update tracker");
                    rd.forward(request, response);
                }
                break;
            }

            case "DELETEMODULE": {
                String stuUserID = request.getParameter("stuUserID");
                if (stuUserID != null) {
                    int projectID = Integer.parseInt(request.getParameter("projectID"));

                    rd = request.getRequestDispatcher("stuProjTaskManage.jsp?stuUserID=" + stuUserID + "&projectID=" + projectID);
                } else {
                    rd = request.getRequestDispatcher("stuProjTaskManage.jsp");
                }

                int moduleTrackID = Integer.parseInt(request.getParameter("moduleTrackID"));

                status = projectProgressDao.deleteModuleTracking(moduleTrackID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete module");
                    rd.forward(request, response);
                }

                break;
            }
            case "UPDATEMODULE": {
                user user = (user) session.getAttribute("login");
                user e = (user) userDao.getUserByID(user.getUserID());

                if (e.getUserType().equals("Student")) {
                    rd = request.getRequestDispatcher("stuMainPage.jsp");
                } else {
                    int stuUserID = Integer.parseInt(request.getParameter("stuUserID"));
                    rd = request.getRequestDispatcher("svStuDetail.jsp?stuUserID=" + stuUserID);
                }

                int projectID = Integer.parseInt(request.getParameter("projectID"));

                int oldSubTaskCount = Integer.parseInt(request.getParameter("oldSubTaskCount"));
                int subTaskCount = Integer.parseInt(request.getParameter("count"));

                projectProgress progress = new projectProgress();
                progress.setProjectID(projectID);

                for (int i = 1; i <= oldSubTaskCount; i++) {
                    int moduleTrackID = Integer.parseInt(request.getParameter("moduleTrackID" + i));
                    String oldModule = request.getParameter("oldModule" + i);
                    String trackStatus = request.getParameter("trackStatus" + i);

                    progress.setModuleTrackID(moduleTrackID);
                    progress.setModule(oldModule);
                    progress.setTrackStatus(trackStatus);

                    status = projectProgressDao.updateModuleTrack(progress);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update system's module");
                        rd.forward(request, response);
                    }
                }

                for (int i = 0; i < subTaskCount; i++) {
                    String module = request.getParameter("module" + i);

                    if (!module.isEmpty()) {
                        progress.setModule(module);

                        status = projectProgressDao.addModuleTracking(progress);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update system's module");
                            rd.forward(request, response);
                        }
                    }
                }

                rd.forward(request, response);

                break;
            }
            case "SUBMIT": {
                rd = request.getRequestDispatcher("stuMainPage.jsp");

                Date parsets = new Date();
                Timestamp lbts = new Timestamp(parsets.getTime());

                int mainTaskID = Integer.parseInt(request.getParameter("mainTaskID"));
                String matricNo = request.getParameter("matricNo");
                Part part = request.getPart("file");

                if (part.getSize() != 0) {

                    String documentName = part.getSubmittedFileName();
                    InputStream filecontent = part.getInputStream();

                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = filecontent.read(buffer)) != -1) {
                        baos.write(buffer, 0, len);
                    }
                    byte[] filedata = baos.toByteArray();

                    projectProgress submitted = projectProgressDao.getSubmitByIDs(mainTaskID, matricNo);

                    if (submitted.getSubmitID() != 0) {
                        submitted.setDocumentName(documentName);
                        submitted.setDocument(filedata);
                        submitted.setSubmitDate(lbts);

                        status = projectProgressDao.updateSubmission(submitted);

                        if (status < 0) {
                            request.setAttribute("uploadError", "Failed to update submission");
                            rd.forward(request, response);
                        }
                    } else {
                        projectProgress submission = new projectProgress();
                        submission.setMainTaskID(mainTaskID);
                        submission.setMatricNo(matricNo);
                        submission.setDocumentName(documentName);
                        submission.setDocument(filedata);
                        submission.setSubmitDate(lbts);

                        status = projectProgressDao.addSubmission(submission);

                        if (status < 0) {
                            request.setAttribute("uploadError", "Failed to make submission");
                            rd.forward(request, response);
                        }
                    }

                    request.setAttribute("uploadSuccess", "Submit Successfully..!");
                    rd.forward(request, response);
                } else {
                    request.setAttribute("uploadError", "Please Choose a PDF file");
                    rd.forward(request, response);
                }
                break;
            }
            case "VIEWSUBMIT": {
                int submitID = Integer.parseInt(request.getParameter("submitID"));

                projectProgress submission = projectProgressDao.getSubmitByIDs(submitID);

                byte[] pdfBytes = submission.getDocument();

                response.setContentType("application/pdf");
                response.setHeader("Content-disposition", "inline; filename=" + submission.getDocumentName());

                ServletOutputStream sos;
                sos = response.getOutputStream();
                sos.write(pdfBytes);
                sos.close();
            }
            case "DOWNLOAD": {
                int submitID = Integer.parseInt(request.getParameter("submitID"));

                projectProgress submission = projectProgressDao.getSubmitByIDs(submitID);

                byte[] pdfBytes = submission.getDocument();

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=" + submission.getDocumentName());
                response.setContentLength(pdfBytes.length);
                System.out.println(pdfBytes.length);
                response.getOutputStream().write(pdfBytes);
                response.getOutputStream().flush();
                response.getOutputStream().close();
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
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
