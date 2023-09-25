package com.controller;

import com.dao.projectDao;
import com.dao.projectProgressDao;
import com.model.project;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author TEOH YI YIN
 */
public class ProjectServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        RequestDispatcher rd;
        int status;

        String action = request.getParameter("action");

        switch (action) {
            case "REGISTER": {
                rd = request.getRequestDispatcher("stuMainPage.jsp");

                String matricNo = request.getParameter("matricNo");
                String projTitle = request.getParameter("projTitle");
                String projDesc = request.getParameter("projDesc");
                String projType = request.getParameter("projType");
                String projApproval = request.getParameter("projApproval");
                String coSvName = null;
                String coSvHp = null;

                if (!request.getParameter("coSvName").isEmpty()) {
                    coSvName = request.getParameter("coSvName");
                    coSvHp = request.getParameter("coSvHp");
                }

                project proj = new project();
                proj.setMatricNo(matricNo);
                proj.setProjectTitle(projTitle);
                proj.setProjectDesc(projDesc);
                proj.setProjectType(projType);
                proj.setProjectApproval(projApproval);
                proj.setCoSvName(coSvName);
                proj.setCoSvHp(coSvHp);

                status = projectDao.registerProject(proj, matricNo);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("registerError", "Failed to register project");
                    request.getRequestDispatcher("projRegister.jsp").forward(request, response);
                }
                break;
            }
            case "PROJUPDATE": {
                rd = request.getRequestDispatcher("projUpdate.jsp");

                project proj = new project();
                proj.setProjectID(Integer.parseInt(request.getParameter("projectID")));
                proj.setProjectTitle(request.getParameter("projTitle"));
                proj.setProjectDesc(request.getParameter("projDesc"));
                proj.setProjectType(request.getParameter("projType"));
                proj.setProjectApproval(request.getParameter("projApproval"));
                proj.setMatricNo(request.getParameter("matricNo"));
                proj.setCoSvName(request.getParameter("coSvName"));
                proj.setCoSvHp(request.getParameter("coSvHp"));

                status = projectDao.updateProject(proj);

                if (status > 0) {
                    request.setAttribute("updateSuccess", "Update Successfully");
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Update Failed");
                    rd.forward(request, response);
                }
                break;
            }
            case "SVUPDATE": {
                rd = request.getRequestDispatcher("projSvApprovalUpdate.jsp");
                
                int projectID = Integer.parseInt(request.getParameter("projectID"));
                String projApproval = request.getParameter("projApproval");
                
                status = projectDao.updateApprovalStatus(projectID, projApproval);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Update Failed");
                    rd.forward(request, response);
                }
                break;
            }
            case "COUPDATE": {
                int projectID = Integer.parseInt(request.getParameter("projectID"));
                String projApproval = request.getParameter("projApproval");
                String oriState = request.getParameter("oriState");
                
                rd = request.getRequestDispatcher("projCoApprovalUpdate.jsp?status=" + oriState);
                
                status = projectDao.updateApprovalStatus(projectID, projApproval);
                
                if(projApproval.equals("Rejected") && oriState.equals("Approved")){
                    projectProgressDao.deleteTrackingByProjectID(projectID);
                }

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Update Failed");
                    rd.forward(request, response);
                }
                break;
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
