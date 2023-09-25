package com.controller;

import com.dao.*;
import com.model.*;
import java.io.*;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author TEOH YI YIN
 */
public class MeetingServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");

        SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat t = new SimpleDateFormat("HH:mm");

        RequestDispatcher rd = null;
        int status = 0;
        HttpSession session = request.getSession();

        user user = (user) session.getAttribute("login");
        user e = (user) userDao.getUserByID(user.getUserID());

        String action = request.getParameter("action");

        switch (action) {
            case "ADDMEET": {
                String userType = request.getParameter("userType");

                String meetDate = request.getParameter("meetDate");
                long date = d.parse(meetDate).getTime();
                Date meetdate = new Date(date);

                String meetTime = request.getParameter("meetTime");
                long time = t.parse(meetTime).getTime();
                Time meettime = new Time(time);

                String meetMode = request.getParameter("meetMode");
                String meetLocate = request.getParameter("meetLocate");
                int svID = Integer.parseInt(request.getParameter("svID"));

                meeting meet = new meeting();
                meet.setMeetDate(meetdate);
                meet.setMeetTime(meettime);
                meet.setMeetMode(meetMode);
                meet.setMeetLocate(meetLocate);
                meet.setSvID(svID);

                if (userType.equals("Supervisor")) {
                    status = meetingDao.addMeet(meet);
                } else if (userType.equals("Student")) {
                    String matricNo = e.getMatricNo();
                    String appointVerify = "Approved";

                    appointment appoint = new appointment();
                    appoint.setMatricNo(matricNo);
                    appoint.setAppointVerify(appointVerify);
                    status = appointmentDao.addAppoint(meet, appoint);
                }

                if (status > 0) {
                    if (userType.equals("Supervisor")) {
                        request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                    } else if (userType.equals("Student")) {
                        request.getRequestDispatcher("stuLogBook.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("addError", "Failed to add meeting");
                    if (userType.equals("Supervisor")) {
                        request.getRequestDispatcher("meetAdd.jsp?userType=Supervisor").forward(request, response);
                    } else if (userType.equals("Student")) {
                        request.getRequestDispatcher("meetAdd.jsp?userType=Student").forward(request, response);
                    }
                }
                break;
            }
            case "UPDATEMEET": {
                String meetDate = request.getParameter("meetDate");
                long date = d.parse(meetDate).getTime();
                Date meetdate = new Date(date);

                String meetTime = request.getParameter("meetTime");
                long time = t.parse(meetTime).getTime();
                Time meettime = new Time(time);

                int meetID = Integer.parseInt(request.getParameter("meetID"));
                String meetMode = request.getParameter("meetMode");
                String meetLocate = request.getParameter("meetLocate");

                meeting meet = new meeting();
                meet.setMeetID(meetID);
                meet.setMeetDate(meetdate);
                meet.setMeetTime(meettime);
                meet.setMeetMode(meetMode);
                meet.setMeetLocate(meetLocate);

                status = meetingDao.updateMeet(meet);

                if (status > 0) {
                    request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                } else {
                    request.setAttribute("updateError", "Update Failed");
                    request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                }
                break;
            }
            case "DELETEMEET": {
                int meetID = Integer.parseInt(request.getParameter("meetID"));

                status = meetingDao.deleteMeet(meetID);

                if (status > 0) {
                    request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to delete meeting");
                    request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                }
                break;
            }
            case "ADDAPPOINT": {
                String meetDate = request.getParameter("meetDate");
                long date = d.parse(meetDate).getTime();
                Date meetdate = new Date(date);

                String meetTime = request.getParameter("meetTime");
                long time = t.parse(meetTime).getTime();
                Time meettime = new Time(time);

                String meetMode = request.getParameter("meetMode");
                String meetLocate = request.getParameter("meetLocate");
                int svID = Integer.parseInt(request.getParameter("svID"));

                meeting meet = new meeting();
                meet.setMeetDate(meetdate);
                meet.setMeetTime(meettime);
                meet.setMeetMode(meetMode);
                meet.setMeetLocate(meetLocate);
                meet.setSvID(svID);

                String matricNo = e.getMatricNo();
                String appointVerify = "Waiting Approval";

                appointment appoint = new appointment();
                appoint.setMatricNo(matricNo);
                appoint.setAppointVerify(appointVerify);

                status = appointmentDao.addAppoint(meet, appoint);

                if (status > 0) {
                    request.getRequestDispatcher("stuAppoint.jsp?status=Appointed").forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add appointment");
                    request.getRequestDispatcher("stuAppoint.jsp?status=To Appoint").forward(request, response);
                }
                break;
            }
            case "APPOINT": {
                int meetID = Integer.parseInt(request.getParameter("meetID"));
                String matricNo = e.getMatricNo();
                String appointVerify = "Waiting Approval";

                appointment appoint = new appointment();
                appoint.setMeetID(meetID);
                appoint.setMatricNo(matricNo);
                appoint.setAppointVerify(appointVerify);

                status = appointmentDao.appoint(appoint);

                if (status > 0) {
                    request.getRequestDispatcher("stuAppoint.jsp?status=Appointed").forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to make appointment");
                    request.getRequestDispatcher("stuAppoint.jsp?status=To Appoint").forward(request, response);
                }
                break;
            }
            case "APPOINTSTATE": {
                rd = request.getRequestDispatcher("svAppointment.jsp");

                int appointID = Integer.parseInt(request.getParameter("appointID"));
                String appointVerify = request.getParameter("appointVerify");

                status = appointmentDao.updateAppointStatus(appointID, appointVerify);

                int meetID = Integer.parseInt(request.getParameter("meetID"));
                if (meetID != 0) {
                    rd = request.getRequestDispatcher("svMeetDetail.jsp?meetID=" + meetID);
                }

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to update apppointment's status");
                    rd.forward(request, response);
                }
                break;
            }
            case "DELETEAPPOINT": {
                int appointID = Integer.parseInt(request.getParameter("appointID"));

                status = appointmentDao.deleteAppointment(appointID);

                if (status > 0) {
                    request.getRequestDispatcher("stuAppoint.jsp?status=Appointed").forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to delete appointment");
                    request.getRequestDispatcher("svMeet.jsp").forward(request, response);
                }
                break;
            }
            case "ADDLB": {
                Date parsets = new Date();
                Timestamp lbts = new Timestamp(parsets.getTime());

                int meetID = Integer.parseInt(request.getParameter("meetID"));
                String matricNo = e.getMatricNo();
                String projectAct = request.getParameter("projectAct");
                String projectProb = request.getParameter("projectProb");
                String probSolveSuggest = request.getParameter("probSolveSuggest");

                logbook lb = new logbook();
                lb.setMeetID(meetID);
                lb.setMatricNo(matricNo);
                lb.setTimestamp(lbts);
                lb.setProjectAct(projectAct);
                lb.setProjectProb(projectProb);
                lb.setProjectSolveSuggest(probSolveSuggest);
                lb.setLogValidate("To Validate");

                status = logbookDao.addLogBook(lb);

                if (status > 0) {
                    request.getRequestDispatcher("stuLogBook.jsp").forward(request, response);
                } else {
                    request.setAttribute("addError", "Failed to add logbook");
                    request.getRequestDispatcher("stuLogBook.jsp").forward(request, response);
                }
                break;
            }
            case "UPDATELB": {
                Date parsets = new Date();
                Timestamp lbts = new Timestamp(parsets.getTime());

                int meetID = Integer.parseInt(request.getParameter("meetID"));
                String matricNo = e.getMatricNo();
                String projectAct = request.getParameter("projectAct");
                String projectProb = request.getParameter("projectProb");
                String probSolveSuggest = request.getParameter("probSolveSuggest");
                String logValidate = request.getParameter("logValidate");

                logbook lb = new logbook();
                lb.setMeetID(meetID);
                lb.setMatricNo(matricNo);
                lb.setTimestamp(lbts);
                lb.setProjectAct(projectAct);
                lb.setProjectProb(projectProb);
                lb.setProjectSolveSuggest(probSolveSuggest);
                lb.setLogValidate(logValidate);

                status = logbookDao.updateLB(lb);

                if (status > 0) {
                    request.getRequestDispatcher("stuLogBook.jsp").forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to add logbook");
                    request.getRequestDispatcher("stuLogBook.jsp").forward(request, response);
                }
                break;
            }
            case "VALIDATELB": {
                int logID = Integer.parseInt(request.getParameter("logID"));
                int meetID = Integer.parseInt(request.getParameter("meetID"));
                logbook lb = logbookDao.getLBByID(logID);

                String logValidate = request.getParameter("logValidate");

                if (logValidate.equals("Valid")) {
                    lb.setLogValidate("Invalid");
                } else {
                    lb.setLogValidate("Valid");
                }

                status = logbookDao.updateLB(lb);

                if (status > 0) {
                    request.getRequestDispatcher("logBookManage.jsp?action=View&meetID="+meetID+"&logID="+logID).forward(request, response);
                } else {
                    request.setAttribute("updateError", "Failed to add logbook");
                    request.getRequestDispatcher("logBookManage.jsp?action=View&meetID="+meetID+"&logID="+logID).forward(request, response);
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
            Logger.getLogger(MeetingServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(MeetingServlet.class.getName()).log(Level.SEVERE, null, ex);
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
