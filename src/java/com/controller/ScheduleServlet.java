package com.controller;

import com.dao.*;
import com.model.*;
import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

/**
 *
 * @author TEOH YI YIN
 */
@MultipartConfig
public class ScheduleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");

        SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");

        RequestDispatcher rd;
        int status = 0;

        String action = request.getParameter("action");

        switch (action) {
            case "updateCourse": {
                rd = request.getRequestDispatcher("coFYPCourseUpdate.jsp");

                int i = Integer.parseInt(request.getParameter("i"));
                int ii = Integer.parseInt(request.getParameter("ii"));

                for (int I = 0; I <= i; I++) {
                    schedule s = new schedule();
                    s.setCourseCode(request.getParameter("fypI" + I));
                    s.setOldCode(request.getParameter("oldcodeI" + I));

                    scheduleDao.updateCourseCode(s);
                }
                for (int II = 0; II <= ii; II++) {
                    schedule s = new schedule();
                    s.setCourseCode(request.getParameter("fypII" + II));
                    s.setOldCode(request.getParameter("oldcodeII" + II));

                    scheduleDao.updateCourseCode(s);
                }

                rd.forward(request, response);
                break;
            }
            case "ADDDETAIL": {
                rd = request.getRequestDispatcher("coScheduleTimetable.jsp");

                int week = Integer.parseInt(request.getParameter("week"));
                String activity = request.getParameter("activity");
                String scheduleAction = request.getParameter("scheduleAction");

                schedule schedule = new schedule();
                schedule.setWeek(week);
                schedule.setActivity(activity);
                schedule.setAction(scheduleAction);

                String date = request.getParameter("date");
                if (!date.isEmpty()) {
                    long sdate = d.parse(date).getTime();
                    Date scheduleDate = new Date(sdate);
                    schedule.setDate(scheduleDate);
                }

                status = scheduleDao.addScheduleDetails(schedule);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add new timetable");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATEDETAIL": {
                rd = request.getRequestDispatcher("coScheduleTimetable.jsp");

                int week = Integer.parseInt(request.getParameter("week"));
                String activity = request.getParameter("activity");
                String scheduleAction = request.getParameter("scheduleAction");
                int detailID = Integer.parseInt(request.getParameter("detailID"));

                schedule schedule = new schedule();
                schedule.setWeek(week);
                schedule.setActivity(activity);
                schedule.setAction(scheduleAction);
                schedule.setDetailID(detailID);

                String date = request.getParameter("date");
                if (!date.isEmpty()) {
                    long sdate = d.parse(date).getTime();
                    Date scheduleDate = new Date(sdate);
                    schedule.setDate(scheduleDate);
                }

                status = scheduleDao.updateScheduleDetails(schedule);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update timetable");
                    request.getRequestDispatcher("coScheduleManage.jsp?action=Update").forward(request, response);
                }
                break;
            }
            case "DELETEDETAIL": {
                rd = request.getRequestDispatcher("coScheduleTimetable.jsp");

                int detailID = Integer.parseInt(request.getParameter("detailID"));

                status = scheduleDao.deleteScheduleDetails(detailID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete timetable");
                    rd.forward(request, response);
                }
                break;
            }
            case "ADDMATERIAL": {
                rd = request.getRequestDispatcher("coScheduleMaterial.jsp");

                schedule schedule = new schedule();

                if (!request.getParameter("materialID").isEmpty() && request.getParameter("detailID") != null) {
                    rd = request.getRequestDispatcher("coScheduleTimetable.jsp");

                    int detailID = Integer.parseInt(request.getParameter("detailID"));
                    int materialID = Integer.parseInt(request.getParameter("materialID"));

                    schedule.setDetailID(detailID);
                    schedule.setMaterialID(materialID);

                    status = scheduleDao.updateSchedule(schedule);
                } else if (request.getParameter("materialID").isEmpty()) {

                    if (request.getParameter("detailID") != null) {
                        rd = request.getRequestDispatcher("coScheduleTimetable.jsp");
                        int detailID = Integer.parseInt(request.getParameter("detailID"));
                        schedule.setDetailID(detailID);
                    }

                    String materialName = request.getParameter("materialName");
                    String materialType = request.getParameter("materialType");

                    if (!request.getParameter("materialLink").isEmpty() && schedule.isValidLink(request.getParameter("materialLink")) == true) {
                        String materialLink = request.getParameter("materialLink");
                        schedule.setMaterialLink(materialLink);
                    } else if (!request.getParameter("materialLink").isEmpty() && schedule.isValidLink(request.getParameter("materialLink")) == false) {
                        request.setAttribute("linkError", "Insert complete link start with http:// or https://..!");
                        request.getRequestDispatcher("coScheduleMaterialManage.jsp?action=Add").forward(request, response);
                    }

                    schedule.setMaterialName(materialName);
                    schedule.setMaterialType(materialType);

                    Part part = request.getPart("materialDoc");

                    if (part.getSize() != 0) {
                        InputStream filecontent = part.getInputStream();

                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        byte[] buffer = new byte[1024];
                        int len;
                        while ((len = filecontent.read(buffer)) != -1) {
                            baos.write(buffer, 0, len);
                        }
                        byte[] filedata = baos.toByteArray();

                        schedule.setMaterialDoc(filedata);
                    }

                    status = scheduleDao.addMaterial(schedule);
                }

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add material");
                    rd.forward(request, response);
                }
                break;
            }

            case "UPDATEMATERIAL": {
                rd = request.getRequestDispatcher("coScheduleMaterialManage.jsp?action=Update");

                String materialName = request.getParameter("materialName");
                String materialLink = null;

                if (!request.getParameter("materialLink").isEmpty() && schedule.isValidLink(request.getParameter("materialLink")) == true) {
                    materialLink = request.getParameter("materialLink");
                } else if (!request.getParameter("materialLink").isEmpty() && schedule.isValidLink(request.getParameter("materialLink")) == false) {
                    request.setAttribute("linkError", "Insert complete link start with http:// or https://..!");
                    request.getRequestDispatcher("coScheduleMaterialManage.jsp?action=Update").forward(request, response);
                }

                String materialType = request.getParameter("materialType");
                int materialID = Integer.parseInt(request.getParameter("materialID"));

                schedule schedule = new schedule();
                schedule.setMaterialName(materialName);
                schedule.setMaterialLink(materialLink);
                schedule.setMaterialType(materialType);
                schedule.setMaterialID(materialID);

                Part part = request.getPart("materialDoc");

                if (part.getSize() != 0) {
                    InputStream filecontent = part.getInputStream();

                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = filecontent.read(buffer)) != -1) {
                        baos.write(buffer, 0, len);
                    }
                    byte[] filedata = baos.toByteArray();

                    schedule.setMaterialDoc(filedata);
                }else{
                    schedule.setMaterialDoc(request.getParameter("oldDoc").getBytes());
                }

                status = scheduleDao.updateMaterial(schedule);

                if (status > 0) {
                    request.setAttribute("updateSuccess", "Success to update material");
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update material");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETEMATERIAL": {
                rd = request.getRequestDispatcher("coScheduleMaterial.jsp");

                int materialID = Integer.parseInt(request.getParameter("materialID"));

                status = scheduleDao.deleteMaterial(materialID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete material");
                    rd.forward(request, response);
                }
                break;
            }
            case "VIEWMATERIAL": {
                int materialID = Integer.parseInt(request.getParameter("materialID"));

                schedule material = scheduleDao.getMaterialByID(materialID);

                byte[] pdfBytes = material.getMaterialDoc();

                response.setContentType("application/pdf");
                response.setHeader("Content-disposition", "inline; filename=" + material.getMaterialName() + ".pdf");

                ServletOutputStream sos;
                sos = response.getOutputStream();
                sos.write(pdfBytes);
                sos.close();
                break;
            }
            case "DOWNLOAD": {
                int materialID = Integer.parseInt(request.getParameter("materialID"));

                schedule material = scheduleDao.getMaterialByID(materialID);

                byte[] pdfBytes = material.getMaterialDoc();

                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=" + material.getMaterialName() + ".pdf");
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(ScheduleServlet.class
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(ScheduleServlet.class
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
