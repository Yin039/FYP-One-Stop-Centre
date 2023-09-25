package com.controller;

import com.dao.assessmentDao;
import com.dao.userDao;
import com.model.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

/**
 *
 * @author TEOH YI YIN
 */
@MultipartConfig
public class UserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ClassNotFoundException {
        response.setContentType("text/plain;charset=UTF-8");

        HttpSession session = request.getSession();
        RequestDispatcher rd;
        int status;

        String action = request.getParameter("action");
        String userType = request.getParameter("userType");

        switch (action) {
            //Controller for user login to corresponsing user page
            case "LOGIN": {
                rd = request.getRequestDispatcher("login.jsp");

                String email = request.getParameter("email");
                String password = request.getParameter("password");
                user user = userDao.login(email, password);

                if (user != null) {
                    session.setAttribute("login", user);

                    switch (user.getUserType()) {
                        case "Coordinator":
                            response.sendRedirect("coMainPage.jsp");
                            break;
                        case "Supervisor":
                            response.sendRedirect("svMainPage.jsp");
                            break;
                        case "Student":
                            response.sendRedirect("stuMainPage.jsp");
                            break;
                        case "Officer":
                            if (user.getOffLoginValid().equals("Valid")) {
                                response.sendRedirect("offMainPage.jsp");
                            } else {
                                request.setAttribute("loginError", "Invalid Login Status..!");
                                rd.forward(request, response);
                            }
                            break;
                        default:
                            break;
                    }
                } else {
                    request.setAttribute("loginError", "Invalid email or password..!");
                    rd.forward(request, response);
                }
                break;
            }
            //Controller for Vocational Officer to register an account
            case "REGISTER": {
                user e = new user();

                if (user.isValidEmail(request.getParameter("email")) == true) {
                    e.setEmail(request.getParameter("email"));
                } else {
                    request.setAttribute("emailError", "Please register using UMT email..!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }

                if (user.isValidPassword(request.getParameter("password")) == true) {
                    e.setPassword(request.getParameter("password"));
                } else {
                    request.setAttribute("passwordError", "Password must contains 8-20 charcters, a lowercase, an uppercase, a special symbol..!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }

                if (user.isValidPhnNo(request.getParameter("hpNo")) == true) {
                    e.setHP(request.getParameter("hpNo"));
                } else {
                    request.setAttribute("hpError", "Insert valid phone number without '-'..!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }

                e.setUserType("Officer");
                e.setName(request.getParameter("name").toUpperCase());
                e.setOffLoginValid(request.getParameter("offLoginValid"));

                status = userDao.registerUser(e);

                if (status > 0) {
                    request.setAttribute("success", "Registration Successfully..!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    request.setAttribute("registerError", "Failed to Register..!");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
                break;
            }
            //Make enrollment of student and supervisor using EXCEL file
            case "ENROLL": {
                if (userType.equals("Supervisor")) {
                    rd = request.getRequestDispatcher("coUserManage.jsp?type=Supervisor");

                    //build folder path to save file
                    String folderName = "resources";
                    String uploadPath = "/home/s58798/" + File.separator + folderName;
                    //String uploadPath = request.getServletContext().getRealPath("") + File.separator + folderName;
                    File dir = new File(uploadPath);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    //Textbox value of name file.
                    Part filePart = request.getPart("excel");
                    String fileName = filePart.getSubmittedFileName();

                    try (InputStream is = filePart.getInputStream()) {
                        Files.copy(is, Paths.get(uploadPath + File.separator + fileName), StandardCopyOption.REPLACE_EXISTING);
                        FileInputStream fis = new FileInputStream(uploadPath + File.separator + fileName);

                        //read Excel
                        try (Workbook workbook = new XSSFWorkbook(fis)) {
                            Sheet firstSheet = workbook.getSheetAt(0);
                            Iterator<Row> rowIterator = firstSheet.iterator();

                            rowIterator.next(); // skip the header row

                            while (rowIterator.hasNext()) {
                                user e = new user();
                                e.setUserType("Supervisor");

                                Row nextRow = rowIterator.next();
                                Iterator<Cell> cellIterator = nextRow.cellIterator();

                                while (cellIterator.hasNext()) {
                                    Cell nextCell = cellIterator.next();
                                    int columnIndex = nextCell.getColumnIndex();

                                    switch (columnIndex) {
                                        case 0:
                                            String name = nextCell.getStringCellValue();
                                            e.setName(name.toUpperCase());
                                            break;
                                        case 1:
                                            String email = nextCell.getStringCellValue();
                                            e.setPassword(email);
                                            e.setEmail(email);
                                            break;
                                        case 2:
                                            String hp = nextCell.getStringCellValue();
                                            e.setHP(hp);
                                            break;
                                        case 3:
                                            int groupNo = (int) nextCell.getNumericCellValue();
                                            e.setGroupNo(groupNo);
                                            break;
                                    }
                                }
                                status = userDao.enrollUser(e);

                                if (status < 0) {
                                    request.setAttribute("enrollError", "Enrollment Failed");
                                }
                            }
                            dir.delete();
                            rd.forward(request, response);
                        } catch (Exception e) {
                            request.setAttribute("enrollError", "Enrollment Failed");
                            rd.forward(request, response);

                        }
                    }
                } else if (userType.equals("Student")) {
                    rd = request.getRequestDispatcher("coUserManage.jsp?type=Student");

                    //build folder path to save file
                    String folderName = "resources";
                    String uploadPath = "/home/s58798/" + File.separator + folderName;
                    //String uploadPath = request.getServletContext().getRealPath("") + File.separator + folderName;
                    File dir = new File(uploadPath);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    //Textbox value of name file.
                    Part filePart = request.getPart("excel");
                    String fileName = filePart.getSubmittedFileName();

                    try (InputStream is = filePart.getInputStream()) {
                        Files.copy(is, Paths.get(uploadPath + File.separator + fileName), StandardCopyOption.REPLACE_EXISTING);
                        FileInputStream fis = new FileInputStream(uploadPath + File.separator + fileName);

                        //read Excel
                        try (Workbook workbook = new XSSFWorkbook(fis)) {
                            Sheet firstSheet = workbook.getSheetAt(0);

                            Row firstRow = firstSheet.getRow(2);
                            String crsCode = firstRow.getCell(0).getStringCellValue();
                            String stuSession = firstRow.getCell(1).getStringCellValue();

                            for (int i = 4; i < firstSheet.getPhysicalNumberOfRows(); i++) {
                                user e = new user();
                                e.setUserType("Student");
                                e.setCrsCode(crsCode);
                                e.setSession(stuSession);

                                Row row = firstSheet.getRow(i);
                                if (row != null) {
                                    for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
                                        Cell cell = row.getCell(j);
                                        if (cell != null && row.getCell(4).getNumericCellValue() != 0) {
                                            int columnIndex = cell.getColumnIndex();

                                            switch (columnIndex) {
                                                case 1:
                                                    String matricNo = cell.getStringCellValue();
                                                    e.setMatricNo(matricNo);
                                                    e.setEmail(matricNo.toLowerCase() + "@ocean.umt.edu.my");
                                                    e.setPassword(matricNo.toLowerCase() + "@ocean.umt.edu.my");
                                                    break;
                                                case 2:
                                                    String name = cell.getStringCellValue();
                                                    e.setName(name);
                                                    break;
                                                case 3:
                                                    String pgm = cell.getStringCellValue();
                                                    e.setPgm(pgm);
                                                    break;
                                                case 4:
                                                    int sem = (int) cell.getNumericCellValue();
                                                    e.setSem(sem);
                                                    break;
                                            }
                                        }
                                    }
                                    status = userDao.enrollUser(e);

                                    if (status < 0) {
                                        request.setAttribute("enrollError", "Enrollment Failed");
                                    } else {
                                        assessmentDao.addEvaluation(e.getMatricNo());
                                    }
                                }
                            }
                            dir.delete();
                            rd.forward(request, response);
                        }catch(Exception e){
                            request.setAttribute("enrollError", "Enrollment Failed");
                            rd.forward(request, response);
                        }
                    }
                }
                break;
            }

            //Controller to insert a student or a supervisor
            case "ADD1": {
                if (userType.equals("Supervisor")) {
                    rd = request.getRequestDispatcher("coUserManage.jsp?type=Supervisor");

                    String svName = request.getParameter("name").toUpperCase();
                    String email = null;
                    String HP = null;

                    if (user.isValidEmail(request.getParameter("email")) == true) {
                        email = request.getParameter("email");
                    } else {
                        request.setAttribute("emailError", "Please use UMT email");
                        request.getRequestDispatcher("coUserAdd.jsp?type=Student").forward(request, response);
                    }

                    if (user.isValidPhnNo(request.getParameter("HP")) == true) {
                        HP = request.getParameter("HP");
                    } else {
                        request.setAttribute("hpError", "Insert valid phone number without '-'..!");
                        request.getRequestDispatcher("coUserAdd.jsp?type=Student").forward(request, response);
                    }

                    int groupNo = Integer.parseInt(request.getParameter("groupNo"));

                    Boolean existingGroup = false;

                    List<user> svList = userDao.getAllUser("Supervisor");
                    for (user sv : svList) {
                        if (groupNo == sv.getGroupNo()) {
                            existingGroup = true;

                            request.setAttribute("insertError", "Existed Group No");
                            request.getRequestDispatcher("coUserAdd.jsp?type=Supervisor").forward(request, response);
                        }
                    }

                    if (existingGroup == false) {
                        user e = new user();
                        e.setName(svName);
                        e.setEmail(email);
                        e.setPassword(email);
                        e.setHP(HP);
                        e.setGroupNo(groupNo);
                        e.setUserType("Supervisor");

                        status = userDao.enrollUser(e);

                        if (status > 0) {
                            rd.forward(request, response);
                        } else {
                            request.setAttribute("insertError", "Failed to add supervisor's account");
                            request.getRequestDispatcher("coUserAdd.jsp?type=Supervisor").forward(request, response);
                        }
                    }
                } else if (userType.equals("Student")) {
                    rd = request.getRequestDispatcher("coUserManage.jsp?type=Student");

                    String matricNo = request.getParameter("matricNo").toUpperCase();
                    String email = matricNo + "@ocean.umt.edu.my";
                    int groupNo = Integer.parseInt(request.getParameter("groupNo"));
                    String name = request.getParameter("name").toUpperCase();
                    String program = request.getParameter("program");
                    int sem = Integer.parseInt(request.getParameter("sem"));
                    String stuSession = request.getParameter("stuSession");
                    String courseCode = request.getParameter("courseCode");

                    user e = new user();
                    e.setMatricNo(matricNo);
                    e.setName(name);
                    e.setPassword(email);
                    e.setEmail(email);
                    e.setPgm(program);
                    e.setSem(sem);
                    e.setCrsCode(courseCode);
                    e.setGroupNo(groupNo);
                    e.setSession(stuSession);
                    e.setUserType("Student");

                    status = userDao.enrollUser(e);

                    if (status > 0) {
                        assessmentDao.addEvaluation(e.getMatricNo());
                        rd.forward(request, response);
                    } else {
                        request.setAttribute("insertError", "Failed to add student's account");
                        request.getRequestDispatcher("coUserAdd.jsp?type=Student").forward(request, response);
                    }
                }
                break;
            }
            //Controller for coordinator to update user's information
            case "UPDATE": {
                user user;

                switch (userType) {
                    case "Supervisor":
                        rd = request.getRequestDispatcher("coUserUpdate.jsp?type=Supervisor");

                        user = new user();
                        user.setSvName(request.getParameter("name"));
                        user.setEmail(request.getParameter("email"));
                        user.setHP(request.getParameter("HP"));
                        user.setGroupNo(Integer.parseInt(request.getParameter("groupNo")));
                        user.setUserType("Supervisor");
                        user.setPassword(request.getParameter("password"));
                        user.setUserID(Integer.parseInt(request.getParameter("userID")));
                        user.setSvID(Integer.parseInt(request.getParameter("svID")));
                        user.setGroupLink(request.getParameter("groupLink"));

                        status = userDao.updateUser(user);

                        if (status > 0) {
                            request.getRequestDispatcher("coUserManage.jsp?type=Supervisor").forward(request, response);
                        } else {
                            request.setAttribute("updateError", "Update Failed");
                            rd.forward(request, response);
                        }
                        break;
                    case "Student":
                        rd = request.getRequestDispatcher("coUserUpdate.jsp?type=Student");

                        user = new user();
                        user.setMatricNo(request.getParameter("matricNo"));
                        user.setGroupNo(Integer.parseInt(request.getParameter("groupNo")));
                        user.setName(request.getParameter("name"));
                        user.setIC(request.getParameter("IC"));
                        user.setEmail(request.getParameter("email"));
                        user.setHP(request.getParameter("HP"));
                        user.setPgm(request.getParameter("program"));
                        user.setSem(Integer.parseInt(request.getParameter("sem")));
                        user.setCrsCode(request.getParameter("crsCode"));
                        user.setUserType("Student");
                        user.setPassword(request.getParameter("password"));
                        user.setUserID(Integer.parseInt(request.getParameter("userID")));

                        status = userDao.updateUser(user);
                        if (status > 0) {
                            request.getRequestDispatcher("coUserManage.jsp?type=Student").forward(request, response);
                        } else {
                            request.setAttribute("updateError", "Update Failed");
                            rd.forward(request, response);
                        }
                        break;
                    case "Officer":
                        rd = request.getRequestDispatcher("coUserManage.jsp?type=Officer");
                        int id = Integer.parseInt(request.getParameter("userID"));

                        user officer = userDao.getUserByID(id);

                        user = new user();
                        user.setName(officer.getName());
                        user.setEmail(officer.getEmail());
                        user.setHP(officer.getHP());
                        user.setPassword(officer.getPassword());
                        user.setUserID(officer.getUserID());
                        user.setOffID(officer.getOffID());
                        user.setUserType(officer.getUserType());

                        String validation = officer.getOffLoginValid();
                        if ("To Valid".equals(validation) || "Invalid".equals(validation)) {
                            user.setOffLoginValid("Valid");
                        } else if ("Valid".equals(validation)) {
                            user.setOffLoginValid("Invalid");
                        }

                        status = userDao.updateUser(user);

                        if (status < 0) {
                            request.setAttribute("updateError", "Update Failed");
                            rd.forward(request, response);
                        }
                        rd.forward(request, response);
                        break;

                    default:
                        break;
                }
                break;
            }
            //Controller for user to update their personal information
            case "UPDATEPERSONAL": {
                user user = (user) session.getAttribute("login");
                userType = user.getUserType();

                user old = new user();
                old = userDao.getUserByID(user.getUserID());

                rd = request.getRequestDispatcher("userPersonalInfo.jsp");

                String email = null;

                if (user.isValidEmail(request.getParameter("email")) == true) {
                    email = request.getParameter("email");
                } else {
                    request.setAttribute("emailError", "Please use UMT email");
                    rd.forward(request, response);
                }

                String password = request.getParameter("password");
                String newPass = request.getParameter("newPass");
                String conPass = request.getParameter("conPass");
                int userID = Integer.parseInt(request.getParameter("userID"));

                user = new user();
                user.setEmail(email);
                if (!newPass.isEmpty() && !conPass.isEmpty() && newPass.equals(conPass)) {
                    if (user.isValidPassword(newPass) == true) {
                        user.setPassword(newPass);
                    } else {
                        user.setPassword(password);
                        request.setAttribute("passwordError", "Password must contains 8-20 charcters, a lowercase, an uppercase, a special symbol..!");
                        rd.forward(request, response);
                    }
                } else if (newPass.isEmpty() || conPass.isEmpty()) {
                    user.setPassword(password);
                    request.setAttribute("changePass", "To Change Password Please Fill In Both New and Confirm Password");
                } else if (!newPass.equals(conPass)) {
                    request.setAttribute("updateError", "New Password and Confirm Password Are Different");
                    rd.forward(request, response);
                }
                user.setUserID(userID);
                user.setUserType(userType);

                if (userType.equals("Supervisor")) {
                    String name = request.getParameter("name");
                    int groupNo = Integer.parseInt(request.getParameter("groupNo"));
                    String groupLink = null;
                    int svID = Integer.parseInt(request.getParameter("svID"));
                    String HP = null;

                    if (user.isValidPhnNo(request.getParameter("HP")) == true) {
                        HP = request.getParameter("HP");
                    } else {
                        request.setAttribute("hpError", "Insert valid phone number without '-'..!");
                        rd.forward(request, response);
                    }

                    if (schedule.isValidLink(request.getParameter("groupLink")) == true) {
                        groupLink = request.getParameter("groupLink");
                    } else {
                        request.setAttribute("linkError", "Insert complete link start with http:// or https://..!");
                        rd.forward(request, response);
                    }

                    user.setSvName(name);
                    user.setHP(HP);
                    user.setGroupNo(groupNo);
                    user.setGroupLink(groupLink);
                    user.setSvID(svID);

                } else if (userType.equals("Student")) {
                    String matricNo = request.getParameter("matricNo");
                    int groupNo = Integer.parseInt(request.getParameter("groupNo"));
                    String name = request.getParameter("name").toUpperCase();
                    String IC = null;
                    String HP = null;
                    String program = request.getParameter("program");
                    int sem = Integer.parseInt(request.getParameter("sem"));
                    String crsCode = request.getParameter("crsCode");

                    if (user.isValidPhnNo(request.getParameter("HP")) == true) {
                        HP = request.getParameter("HP");
                    } else {
                        request.setAttribute("hpError", "Insert valid phone number without '-'..!");
                        rd.forward(request, response);
                    }

                    if (user.isValidIcNo(request.getParameter("IC")) == true) {
                        IC = request.getParameter("IC");
                    } else {
                        request.setAttribute("icError", "Insert valid IC No. with '-'..!");
                        rd.forward(request, response);
                    }

                    user.setMatricNo(matricNo);
                    user.setGroupNo(groupNo);
                    user.setName(name);
                    user.setIC(IC);
                    user.setHP(HP);
                    user.setPgm(program);
                    user.setSem(sem);
                    user.setCrsCode(crsCode);

                } else if (userType.equals("Officer")) {
                    String name = request.getParameter("name").toUpperCase();
                    String HP = null;
                    int offID = Integer.parseInt(request.getParameter("offID"));
                    String offLoginValid = request.getParameter("offLoginValid");

                    if (user.isValidPhnNo(request.getParameter("HP")) == true) {
                        HP = request.getParameter("HP");
                    } else {
                        request.setAttribute("hpError", "Insert valid phone number without '-'..!");
                        rd.forward(request, response);
                    }

                    user.setName(name);
                    user.setHP(HP);
                    user.setOffID(offID);
                    user.setOffLoginValid(offLoginValid);
                }
                status = userDao.updateUser(user);

                if (status > 0) {
                    rd.forward(request, response);
                } else {
                    request.setAttribute("updateError", "Update Failed");
                    rd.forward(request, response);
                }
                break;
            }

            case "DELETE": {
                String sid = request.getParameter("id");
                int id = Integer.parseInt(sid);

                status = userDao.deleteUser(id);
                if (status > 0) {
                    response.sendRedirect("coUserManage.jsp?type=" + userType);
                } else {
                    request.setAttribute("deleteError", "Unable To Delete Employee Account");
                    request.getRequestDispatcher("coUserManage.jsp?type=" + userType).include(request, response);
                }
                break;
            }
            case "DELETEGROUP": {
                int pairID = Integer.parseInt(request.getParameter("pairID"));
                int svUserID = Integer.parseInt(request.getParameter("svUserID"));

                status = userDao.deleteGroup(pairID);
                if (status > 0) {
                    response.sendRedirect("coUserGroup.jsp?svUserID=" + svUserID);
                } else {
                    request.setAttribute("deleteError", "Unable to remove student from group");
                    request.getRequestDispatcher("coUserGroup.jsp?svUserID=" + svUserID).include(request, response);
                }
                break;
            }
            case "ADDGROUP": {
                int svUserID = Integer.parseInt(request.getParameter("svUserID"));
                int svID = Integer.parseInt(request.getParameter("svID"));
                int groupNo = Integer.parseInt(request.getParameter("groupNo"));
                rd = request.getRequestDispatcher("coUserGroup.jsp?svUserID=" + svUserID);

                int count = Integer.parseInt(request.getParameter("count"));

                user group = new user();
                group.setSvID(svID);
                group.setGroupNo(groupNo);

                for (int i = 0; i < count; i++) {

                    if (!request.getParameter("matricNo" + i).isEmpty()) {
                        group.setMatricNo(request.getParameter("matricNo" + i));

                        status = userDao.addGroup(group);

                        if (status < 0) {
                            request.setAttribute("addError", "Failed to add student into group");
                            rd.forward(request, response);
                        }
                    }
                }
                rd.forward(request, response);
                break;
            }
            default:
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
