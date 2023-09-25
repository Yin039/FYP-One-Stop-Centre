package com.controller;

import com.dao.*;
import com.model.*;
import java.io.IOException;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author TEOH YI YIN
 */
public class PresentationServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");

        SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat t = new SimpleDateFormat("HH:mm");

        RequestDispatcher rd = null;
        int status = 0;

        String action = request.getParameter("action");

        switch (action) {
            case "GENERATEGROUP": {
                rd = request.getRequestDispatcher("coPresentation.jsp");

                int numGroups = Integer.parseInt(request.getParameter("numGroups"));
                List<presentation> svGroup = presentationDao.getSVWithoutPanelGroup();
                if (svGroup.isEmpty()) {
                    request.setAttribute("addError", "All Supervisor is Assigned");
                    rd.forward(request, response);
                } else {
                    int panelGroupNo = 0;
                    if (presentationDao.getLastPanelGroupNo() != 0) {
                        panelGroupNo = presentationDao.getLastPanelGroupNo();
                    }

                    List<List<presentation>> groups = presentation.assignTeams(svGroup, numGroups);

                    for (int i = 0; i < groups.size(); i++) {
                        List<presentation> groupDetails = groups.get(i);
                        panelGroupNo += 1;

                        for (int j = 0; j < groupDetails.size(); j++) {
                            presentation g = groupDetails.get(j);

                            presentation presentGroup = new presentation();
                            presentGroup.setPanelGpNo(panelGroupNo);
                            presentGroup.setSvID(g.getSvID());
                            presentGroup.setPanelLeader("No");

                            status = presentationDao.addPanelGroup(presentGroup);

                            if (status < 0) {
                                request.setAttribute("addError", "Failed to generate presentation group");
                                rd.forward(request, response);
                            }
                        }
                    }

                    if (status > 0) {
                        rd.forward(request, response);
                    }
                }

                break;
            }
            case "UPDATEGROUP": {
                rd = request.getRequestDispatcher("coPresentation.jsp");

                int count = Integer.parseInt(request.getParameter("count"));
                int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

                presentation p = new presentation();
                p.setPanelGpNo(panelGpNo);

                for (int i = 0; i < count; i++) {
                    if (!request.getParameter("svID" + i).isEmpty()) {
                        p.setSvID(Integer.parseInt(request.getParameter("svID" + i)));

                        status = presentationDao.addPanelGroup(p);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to update presentation group");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);
                break;
            }
            case "ASSIGNLEADER": {
                rd = request.getRequestDispatcher("coPresentation.jsp");

                int panelID = Integer.parseInt(request.getParameter("panelID"));
                presentation p = new presentation();
                p.setPanelID(panelID);

                if (request.getParameter("panelGpNo") != null) {
                    int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

                    List<presentation> panelGp = presentationDao.getPanelGroupByPanelGpNo(panelGpNo);

                    for (presentation g : panelGp) {
                        g.setPanelLeader("No");

                        status = presentationDao.updatePanelGroup(g);
                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to assigned group leader");
                        }
                    }

                    p.setPanelLeader("Yes");
                    status = presentationDao.updatePanelGroup(p);
                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to assigned group leader");
                    }

                } else {
                    p.setPanelLeader("No");
                    status = presentationDao.updatePanelGroup(p);
                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to unassigned group leader");
                    }
                }

                rd.forward(request, response);
                break;
            }
            case "DELETEGROUP": {
                rd = request.getRequestDispatcher("coPresentation.jsp");
                int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

                status = presentationDao.deletePanelGroupByGpNo(panelGpNo);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete presentation group");
                    rd.forward(request, response);
                }

                break;
            }
            case "MANAGELOCATE": {
                rd = request.getRequestDispatcher("offMainPage.jsp");

                int existLocateCount = Integer.parseInt(request.getParameter("existLocateCount"));
                int count = Integer.parseInt(request.getParameter("count"));

                presentation p = new presentation();

                for (int i = 1; i <= existLocateCount; i++) {
                    int locateID = Integer.parseInt(request.getParameter("locateID" + i));
                    String presentLocate = request.getParameter("presentLocate" + i);
                    String presentLocateValid = request.getParameter("presentLocateValid" + i);

                    p.setLocateID(locateID);
                    p.setPresentLocate(presentLocate);
                    p.setPresentLocateValid(presentLocateValid);

                    status = presentationDao.updatePresentLocate(p);

                    if (status < 0) {
                        request.setAttribute("updateError", "Failed to update location");
                        rd.forward(request, response);
                    }
                }

                for (int i = 0; i < count; i++) {
                    if (!request.getParameter("newPresentLocate" + i).isEmpty()) {
                        p.setPresentLocate(request.getParameter("newPresentLocate" + i));
                        p.setPresentLocateValid(request.getParameter("newPresentLocateValid" + i));

                        status = presentationDao.addPresentLocate(p);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to add location");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);
                break;
            }
            case "DELETELOCATE": {
                rd = request.getRequestDispatcher("offPresentationManage.jsp?action=Manage");
                int locateID = Integer.parseInt(request.getParameter("locateID"));

                status = presentationDao.deletePresentLocate(locateID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete location");
                    rd.forward(request, response);
                }

                break;
            }
            case "ADDPRESENT": {
                rd = request.getRequestDispatcher("svPresentation.jsp");

                String presentDate = request.getParameter("presentDate");
                long date = d.parse(presentDate).getTime();
                Date pDate = new Date(date);

                String presentStartTime = request.getParameter("presentStartTime");
                long startTime = t.parse(presentStartTime).getTime();
                Time start = new Time(startTime);

                String presentEndTime = request.getParameter("presentEndTime");
                long endTime = t.parse(presentEndTime).getTime();
                Time end = new Time(endTime);

                int locateID = Integer.parseInt(request.getParameter("locateID"));
                String presentRemark = request.getParameter("presentRemark");
                String presentLocateValid = request.getParameter("presentLocateValid");
                String presentSetUp = request.getParameter("presentSetUp");
                int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));

                presentation p = new presentation();
                p.setLocateID(locateID);

                p.setPresentDate(pDate);
                p.setPresentStartTime(start);
                p.setPresentEndTime(end);
                p.setPresentRemark(presentRemark);
                p.setPresentLocateValid(presentLocateValid);
                p.setPresentSetUp(presentSetUp);
                p.setPanelGpNo(panelGpNo);

                if (request.getParameter("presentLink") != null && schedule.isValidLink(request.getParameter("presentLink")) == true) {
                    p.setPresentLink(request.getParameter("presentLink"));
                } else if (request.getParameter("presentLink") != null && schedule.isValidLink(request.getParameter("presentLink")) == false) {
                    request.setAttribute("linkError", "Insert complete link start with http:// or https://..!");
                    request.getRequestDispatcher("svPresentationManage.jsp?action=Add").forward(request, response);
                }

                status = presentationDao.addPresentation(p);

                if (status > 0) {
                    List<user> student = userDao.getPresentStuByGpNo(panelGpNo);

                    for (user stu : student) {
                        p.setAttendStatus("To Fill");
                        p.setMatricNo(stu.getMatricNo());

                        status = presentationDao.addPresentAttend(p);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to add presentation's attendance list");
                            rd.forward(request, response);
                        }
                    }

                    rd.forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add presentation Details");
                    rd.forward(request, response);
                }
                break;
            }
            case "UPDATEPRESENT": {
                rd = request.getRequestDispatcher("svPresentation.jsp?");

                String presentDate = request.getParameter("presentDate");
                long date = d.parse(presentDate).getTime();
                Date pDate = new Date(date);

                String presentStartTime = request.getParameter("presentStartTime");
                long startTime = t.parse(presentStartTime).getTime();
                Time start = new Time(startTime);

                String presentEndTime = request.getParameter("presentEndTime");
                long endTime = t.parse(presentEndTime).getTime();
                Time end = new Time(endTime);

                int presentID = Integer.parseInt(request.getParameter("presentID"));
                int locateID = Integer.parseInt(request.getParameter("locateID"));
                String presentRemark = request.getParameter("presentRemark");

                presentation p = new presentation();
                p.setPresentID(presentID);
                p.setLocateID(locateID);
                p.setPresentDate(pDate);
                p.setPresentStartTime(start);
                p.setPresentEndTime(end);
                p.setPresentRemark(presentRemark);

                if (request.getParameter("presentLink") != null && schedule.isValidLink(request.getParameter("presentLink")) == true) {
                    p.setPresentLink(request.getParameter("presentLink"));
                } else if (request.getParameter("presentLink").isEmpty() && schedule.isValidLink(request.getParameter("presentLink")) == false) {
                    request.setAttribute("linkError", "Insert complete link start with http:// or https://..!");
                    request.getRequestDispatcher("svPresentationManage.jsp?action=Update").forward(request, response);
                }

                status = presentationDao.updatePresentation(p);

                if (status > 0) {
                    rd.include(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update presentation Details");
                    rd.include(request, response);
                }
                break;
            }
            case "UPDATEPRESENTSTATE": {
                rd = request.getRequestDispatcher("offMainPage.jsp?");

                int presentID = Integer.parseInt(request.getParameter("presentID"));
                String presentRemark = request.getParameter("presentRemark");
                String presentLocateValid = request.getParameter("presentLocateValid");
                String presentSetUp = request.getParameter("presentSetUp");

                presentation p = new presentation();
                p.setPresentID(presentID);
                p.setPresentRemark(presentRemark);
                p.setPresentLocateValid(presentLocateValid);
                p.setPresentSetUp(presentSetUp);

                status = presentationDao.updatePresentationState(p);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update presentation's status");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETEPRESENT": {
                rd = request.getRequestDispatcher("svPresentation.jsp");
                int presentID = Integer.parseInt(request.getParameter("presentID"));

                status = presentationDao.deletePresentation(presentID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete presentation's details");
                    rd.forward(request, response);
                }

                break;
            }
            case "UPDATEATTEND": {
                rd = request.getRequestDispatcher("svPresentation.jsp");

                int totalDay = Integer.parseInt(request.getParameter("totalDay"));
                for (int i = 1; i <= totalDay; i++) {
                    int totalStuCount = Integer.parseInt(request.getParameter("totalStuCount" + i));

                    for (int j = 1; j <= totalStuCount; j++) {
                        int presentAttendID = Integer.parseInt(request.getParameter("presentAttendID" + i + j));
                        String present = request.getParameter("present" + i + j);
                        String letter = request.getParameter("letter" + i + j);

                        presentation attendance = new presentation();
                        attendance.setPresentAttendID(presentAttendID);

                        if (present == null && letter == null) {
                            attendance.setAttendStatus("Absent");
                        } else if (letter != null && letter.equals("Letter")) {
                            attendance.setAttendStatus("Letter");
                        } else if (present.equals("Absent") && letter.equals("Absent")) {
                            attendance.setAttendStatus("Absent");
                        } else if (present != null && present.equals("Present")) {
                            attendance.setAttendStatus("Present");
                        }

                        status = presentationDao.updatePresentAttend(attendance);

                        if (status < 0) {
                            request.setAttribute("updateError", "Failed to update student's attendance");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);
                break;
            }
            case "DELETESV": {
                int panelGpNo = Integer.parseInt(request.getParameter("panelGpNo"));
                int panelID = Integer.parseInt(request.getParameter("panelID"));

                rd = request.getRequestDispatcher("coPresentationGroupManage.jsp?action=Update&panelGpNo=" + panelGpNo);

                status = presentationDao.deletePanel(panelID);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("deleteError", "Failed to delete presentation's details");
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(PresentationServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(PresentationServlet.class.getName()).log(Level.SEVERE, null, ex);
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
