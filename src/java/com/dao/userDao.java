package com.dao;

/**
 *
 * @author TEOH YI YIN
 */
import com.model.user;
import com.util.DBConnection;
import java.sql.*;
import java.util.*;

public class userDao {

    public static user login(String email, String password) {
        user usr = null;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from useracc where email=? and password=?");
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usr = new user();
                usr.setUserID(rs.getInt("userID"));
                usr.setEmail(rs.getString("email"));
                usr.setPassword(rs.getString("password"));
                usr.setUserType(rs.getString("userType"));

                if (rs.getString("userType").equals("Officer")) {
                    PreparedStatement ps1 = con.prepareStatement("select offLoginValid from officer where userID=?");
                    ps1.setInt(1, rs.getInt("userID"));

                    ResultSet rs1 = ps1.executeQuery();
                    if (rs1.next()) {
                        usr.setOffLoginValid(rs1.getString("offLoginValid"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usr;
    }

    public static int registerUser(user e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("insert into useracc(email, password, userType) values (?,?,?)");
            ps.setString(1, e.getEmail());
            ps.setString(2, e.getPassword());
            ps.setString(3, e.getUserType());
            status = ps.executeUpdate();

            if (status > 0) {
                ps = con.prepareStatement("select userID from useracc where email= ?");
                ps.setString(1, e.getEmail());

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    ps = con.prepareStatement("insert into officer(userID, offName, offHp, offLoginValid) values(?,?,?,?)");
                    ps.setInt(1, rs.getInt("userID"));
                    ps.setString(2, e.getName());
                    ps.setString(3, e.getHP());
                    ps.setString(4, e.getOffLoginValid());

                    status = ps.executeUpdate();

                    if (status < 0) {
                        ps = con.prepareStatement("delete from useracc where userID=?");
                        ps.setInt(1, rs.getInt("userID"));

                        ps.executeUpdate();
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int enrollUser(user e) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("insert into useracc(email, password, userType) values (?,?,?)");
            ps.setString(1, e.getEmail());
            ps.setString(2, e.getPassword());
            ps.setString(3, e.getUserType());
            ps.executeUpdate();

            ps = con.prepareStatement("select * from useracc ORDER BY userID DESC LIMIT 1;");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                if (e.getUserType().equals("Supervisor")) {
                    ps = con.prepareStatement("insert into supervisor(userID, svName, svHp, groupNo) values (?,?,?,?)");
                    ps.setInt(1, rs.getInt("userID"));
                    ps.setString(2, e.getName());
                    ps.setString(3, e.getHP());
                    ps.setInt(4, e.getGroupNo());

                    status = ps.executeUpdate();

                    if (status < 0) {
                        PreparedStatement ps1 = con.prepareStatement("delete from useracc where userID=?");
                        ps1.setInt(1, rs.getInt("userID"));

                        ps1.executeUpdate();
                    }
                } else if (e.getUserType().equals("Student")) {
                    ps = con.prepareStatement("insert into student(matricNo, userID, stuName, stuIC, stuHp, stuPgm, stuSem, courseCode, stuSession) values (?,?,?,?,?,?,?,?,?)");
                    ps.setString(1, e.getMatricNo());
                    ps.setInt(2, rs.getInt("userID"));
                    ps.setString(3, e.getName());
                    ps.setString(4, e.getIC());
                    ps.setString(5, e.getHP());
                    ps.setString(6, e.getPgm());
                    ps.setInt(7, e.getSem());
                    ps.setString(8, e.getCrsCode());
                    ps.setString(9, e.getSession());

                    status = ps.executeUpdate();

                    if (status > 0) {
                        PreparedStatement ps1 = con.prepareStatement("select svID from supervisor where groupNo = ?");
                        ps1.setInt(1, e.getGroupNo());

                        rs = ps1.executeQuery();

                        if (rs.next()) {
                            ps1 = con.prepareStatement("insert into svgroup(groupNo, svID, matricNo) values (?,?,?)");
                            ps1.setInt(1, e.getGroupNo());
                            ps1.setInt(2, rs.getInt("svID"));
                            ps1.setString(3, e.getMatricNo());

                            status = ps1.executeUpdate();

                            if (status < 0) {
                                ps = con.prepareStatement("delete from useracc where userID=?");
                                ps.setInt(1, rs.getInt("userID"));

                                ps.executeUpdate();

                                ps = con.prepareStatement("delete from student where matricNo=?");
                                ps.setString(1, e.getMatricNo());

                                ps.executeUpdate();
                            }
                        }
                    } else {
                        ps = con.prepareStatement("delete from useracc where userID=?");
                        ps.setInt(1, rs.getInt("userID"));

                        ps.executeUpdate();
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateUser(user e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("update useracc set email=?, password=? where userID=?");
            ps.setString(1, e.getEmail());
            ps.setString(2, e.getPassword());
            ps.setInt(3, e.getUserID());

            status = ps.executeUpdate();

            switch (e.getUserType()) {
                case "Supervisor": {
                    ps = con.prepareStatement("update supervisor set svName=?, svHp=?, groupNo=?, groupLink=? where svID=?");
                    ps.setString(1, e.getSvName());
                    ps.setString(2, e.getHP());
                    ps.setInt(3, e.getGroupNo());
                    ps.setString(4, e.getGroupLink());
                    ps.setInt(5, e.getSvID());

                    status = ps.executeUpdate();

                    PreparedStatement ps1 = con.prepareStatement("update svgroup set groupNo=? where svID=?");
                    ps1.setInt(1, e.getGroupNo());
                    ps1.setInt(2, e.getSvID());

                    status = ps1.executeUpdate();

                    break;
                }
                case "Student": {
                    ps = con.prepareStatement("update student set stuName=?, stuIC=?, stuHp=?, stuPgm=?, stuSem=?, courseCode=? where matricNo=?");
                    ps.setString(1, e.getName());
                    ps.setString(2, e.getIC());
                    ps.setString(3, e.getHP());
                    ps.setString(4, e.getPgm());
                    ps.setInt(5, e.getSem());
                    ps.setString(6, e.getCrsCode());
                    ps.setString(7, e.getMatricNo());

                    status = ps.executeUpdate();

                    PreparedStatement ps1 = con.prepareStatement("select svID from supervisor where groupNo = ?");
                    ps1.setInt(1, e.getGroupNo());

                    ResultSet rs = ps1.executeQuery();

                    if (rs.next()) {
                        ps1 = con.prepareStatement("update svgroup set groupNo=?, svID=? where matricNo=?");
                        ps1.setInt(1, e.getGroupNo());
                        ps1.setInt(2, rs.getInt("svID"));
                        ps1.setString(3, e.getMatricNo());

                        status = ps1.executeUpdate();
                    }
                    break;
                }
                case "Officer":
                    ps = con.prepareStatement("update officer set offName=?, offHp=?, offLoginValid=? where offID=?");
                    ps.setString(1, e.getName());
                    ps.setString(2, e.getHP());
                    ps.setString(3, e.getOffLoginValid());
                    ps.setInt(4, e.getOffID());

                    status = ps.executeUpdate();
                    break;
                default:
                    break;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int deleteUser(int id) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from useracc where userID=?");
            ps.setInt(1, id);

            status = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    public static int addGroup(user group) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO svgroup(svID, groupNo, matricNo) VALUES(?,?,?)");
            ps.setInt(1, group.getSvID());
            ps.setInt(2, group.getGroupNo());
            ps.setString(3, group.getMatricNo());

            status = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    public static int deleteGroup(int pairID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from svgroup where pairID=?");
            ps.setInt(1, pairID);

            status = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static user getUserByID(int userID) {
        user usr = new user();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("Select * from useracc where userID = ?");
            ps.setInt(1, userID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usr.setUserID(userID);
                usr.setEmail(rs.getString("email"));
                usr.setPassword(rs.getString("password"));
                usr.setUserType(rs.getString("userType"));

                if (rs.getString("userType").equals("Supervisor")) {
                    ps = con.prepareStatement("select * from supervisor where userID = ?");
                    ps.setInt(1, userID);

                    rs = ps.executeQuery();
                    if (rs.next()) {
                        usr.setSvID(rs.getInt("svID"));
                        usr.setSvName(rs.getString("svName"));
                        usr.setHP(rs.getString("svHp"));
                        usr.setGroupNo(rs.getInt("groupNo"));
                        usr.setGroupLink(rs.getString("groupLink"));
                    }
                } else if (rs.getString("userType").equals("Student")) {
                    ps = con.prepareStatement("select * from student where userID = ?");
                    ps.setInt(1, userID);

                    rs = ps.executeQuery();
                    if (rs.next()) {
                        usr.setMatricNo(rs.getString("matricNo"));
                        usr.setName(rs.getString("stuName"));
                        usr.setIC(rs.getString("stuIC"));
                        usr.setHP(rs.getString("stuHp"));
                        usr.setPgm(rs.getString("stuPgm"));
                        usr.setSem(rs.getInt("stuSem"));
                        usr.setCrsCode(rs.getString("courseCode"));
                        usr.setSession(rs.getString("stuSession"));

                        PreparedStatement ps1 = con.prepareStatement("select * from svgroup INNER JOIN supervisor USING (svID) where matricNo = ?");
                        ps1.setString(1, rs.getString("matricNo"));

                        ResultSet rs1 = ps1.executeQuery();
                        if (rs1.next()) {
                            usr.setSvID(rs1.getInt("svID"));
                            usr.setGroupNo(rs1.getInt("groupNo"));
                            usr.setSvName(rs1.getString("svName"));
                            usr.setGroupLink(rs1.getString("groupLink"));
                        }

                        PreparedStatement ps2 = con.prepareStatement("select * from fypcourse where courseCode = ?");
                        ps2.setString(1, rs.getString("courseCode"));

                        ResultSet rs2 = ps2.executeQuery();
                        if (rs2.next()) {
                            usr.setCrsName(rs2.getString("courseName"));
                        }
                    }
                } else if (rs.getString("userType").equals("Officer")) {
                    ps = con.prepareStatement("select * from officer where userID = ?");
                    ps.setInt(1, userID);

                    rs = ps.executeQuery();
                    if (rs.next()) {
                        usr.setOffID(rs.getInt("offID"));
                        usr.setName(rs.getString("offName"));
                        usr.setHP(rs.getString("offHp"));
                        usr.setOffLoginValid(rs.getString("offLoginValid"));
                    }
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return usr;
    }

    public static List<user> getAllUser(String userType) {
        List<user> list = new ArrayList<>();

        try {
            PreparedStatement ps;
            ResultSet rs;
            Connection con = DBConnection.getConnection();

            if (userType.equals("Supervisor")) {
                ps = con.prepareStatement("Select * from useracc LEFT JOIN supervisor USING (userID) WHERE userType = 'Supervisor' ORDER BY groupNo");
                rs = ps.executeQuery();

                while (rs.next()) {
                    user e = new user();
                    e.setUserID(rs.getInt("userID"));
                    e.setEmail(rs.getString("email"));
                    e.setPassword(rs.getString("password"));
                    e.setSvID(rs.getInt("svID"));
                    e.setSvName(rs.getString("svName"));
                    e.setHP(rs.getString("svHp"));
                    e.setGroupNo(rs.getInt("groupNo"));

                    list.add(e);
                }
            } else if (userType.equals("Student")) {
                ps = con.prepareStatement("Select * from useracc AS A INNER JOIN student AS B USING (userID) INNER JOIN fypcourse AS C ON C.courseCode = B.courseCode INNER JOIN svgroup AS D USING (matricNo) WHERE A.userType = 'Student' ORDER BY D.groupNo");
                rs = ps.executeQuery();

                while (rs.next()) {
                    user e = new user();
                    e.setUserID(rs.getInt("userID"));
                    e.setEmail(rs.getString("email"));
                    e.setPassword(rs.getString("password"));
                    e.setMatricNo(rs.getString("matricNo"));
                    e.setName(rs.getString("stuName"));
                    e.setIC(rs.getString("stuIC"));
                    e.setHP(rs.getString("stuHp"));

                    if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)")) {
                        e.setPgm("SMSK(D)IM dK");
                    } else if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN")) {
                        e.setPgm("SMSK(KP) dK");
                    }

                    e.setSem(rs.getInt("stuSem"));
                    e.setCrsCode(rs.getString("courseCode"));

                    PreparedStatement ps1 = con.prepareStatement("select * from fypcourse where courseCode = ?");
                    ps1.setString(1, rs.getString("courseCode"));

                    ResultSet rs1 = ps1.executeQuery();
                    if (rs1.next()) {
                        e.setCrsName(rs1.getString("courseName"));
                    }

                    e.setSession(rs.getString("stuSession"));
                    e.setGroupNo(rs.getInt("groupNo"));

                    list.add(e);
                }
            } else if (userType.equals("Officer")) {
                ps = con.prepareStatement("Select * from useracc AS A INNER JOIN officer AS B USING (userID) WHERE userType = 'Officer'");
                rs = ps.executeQuery();

                while (rs.next()) {
                    user e = new user();
                    e.setUserID(rs.getInt("userID"));
                    e.setEmail(rs.getString("email"));
                    e.setPassword(rs.getString("password"));
                    e.setOffID(rs.getInt("offID"));
                    e.setName(rs.getString("offName"));
                    e.setHP(rs.getString("offHp"));
                    e.setOffLoginValid(rs.getString("offLoginValid"));

                    list.add(e);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static user getStudentDetail(String matricNo) {
        user usr = new user();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from student INNER JOIN useracc USING (userID) where matricNo = ?");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                usr.setMatricNo(matricNo);
                usr.setUserID(rs.getInt("userID"));
                usr.setName(rs.getString("stuName"));
                usr.setIC(rs.getString("stuIC"));
                usr.setHP(rs.getString("stuHp"));
                usr.setPgm(rs.getString("stuPgm"));
                usr.setSem(rs.getInt("stuSem"));
                usr.setCrsCode(rs.getString("courseCode"));
                usr.setSession(rs.getString("stuSession"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return usr;
    }

    public static List<user> getStudentByGroup(int groupNo) {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from student INNER JOIN svgroup USING (matricNo) where groupNo = ?");
            ps.setInt(1, groupNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setMatricNo(rs.getString("matricNo"));
                e.setName(rs.getString("stuName"));
                e.setIC(rs.getString("stuIC"));
                e.setHP(rs.getString("stuHp"));
                e.setSem(rs.getInt("stuSem"));
                e.setCrsCode(rs.getString("courseCode"));
                e.setSession(rs.getString("stuSession"));
                e.setGroupNo(rs.getInt("groupNo"));
                e.setUserID(rs.getInt("userID"));
                e.setPairID(rs.getInt("pairID"));

                if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)")) {
                    e.setPgm("SMSK(D)IM dK");
                } else if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN")) {
                    e.setPgm("SMSK(KP) dK");
                }

                PreparedStatement ps1 = con.prepareStatement("select * from fypcourse where courseCode = ?");
                ps1.setString(1, rs.getString("courseCode"));

                ResultSet rs1 = ps1.executeQuery();
                if (rs1.next()) {
                    e.setCrsName(rs1.getString("courseName"));
                }

                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static List<user> getStudentByCrsName(String courseName) {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from student INNER JOIN svgroup USING (matricNo) INNER JOIN fypcourse USING (courseCode) where courseName = ? ORDER BY matricNo");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setMatricNo(rs.getString("matricNo"));
                e.setName(rs.getString("stuName"));
                e.setIC(rs.getString("stuIC"));
                e.setHP(rs.getString("stuHp"));
                e.setSem(rs.getInt("stuSem"));
                e.setCrsCode(rs.getString("courseCode"));
                e.setCrsName(rs.getString("courseName"));
                e.setSession(rs.getString("stuSession"));
                e.setGroupNo(rs.getInt("groupNo"));
                e.setUserID(rs.getInt("userID"));

                if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)")) {
                    e.setPgm("SMSK(D)IM dK");
                } else if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN")) {
                    e.setPgm("SMSK(KP) dK");
                }

                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static List<user> getStudentWithoutGroup() {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("Select * from useracc AS A INNER JOIN student AS B USING (userID) INNER JOIN fypcourse AS C ON C.courseCode = B.courseCode LEFT JOIN svgroup AS D USING (matricNo) WHERE A.userType = 'Student' AND pairID IS NULL");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setMatricNo(rs.getString("matricNo"));
                e.setName(rs.getString("stuName"));
                e.setIC(rs.getString("stuIC"));
                e.setHP(rs.getString("stuHp"));
                e.setSem(rs.getInt("stuSem"));
                e.setCrsCode(rs.getString("courseCode"));
                e.setCrsName(rs.getString("courseName"));
                e.setSession(rs.getString("stuSession"));
                e.setGroupNo(rs.getInt("groupNo"));
                e.setUserID(rs.getInt("userID"));

                if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER DENGAN INFORMATIK MARITIM (KEPUJIAN)")) {
                    e.setPgm("SMSK(D)IM dK");
                } else if (rs.getString("stuPgm").equals("SARJANA MUDA SAINS KOMPUTER (KEJURUTERAAN PERISIAN) DENGAN KEPUJIAN")) {
                    e.setPgm("SMSK(KP) dK");
                }

                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static int getNumberStuFYP1BySV(int svID) {
        int count = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select COUNT(A.matricNo) as stuNo from svgroup AS A INNER JOIN student AS B USING (matricNo) INNER JOIN fypcourse AS C ON B.courseCode=C.courseCode where courseName='FYP I' and svID = ? GROUP BY svID");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("stuNo");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }

    public static int getNumberStuFYP2BySV(int svID) {
        int count = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select COUNT(A.matricNo) as stuNo from svgroup AS A INNER JOIN student AS B USING (matricNo) INNER JOIN fypcourse AS C ON B.courseCode=C.courseCode where courseName='FYP II' and svID = ? GROUP BY svID");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("stuNo");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }

    public static List<Integer> getSVGroup() {
        List<Integer> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select groupNo from supervisor");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("groupNo"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static List<user> getSVGroupDetails() {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(A.groupNo) AS numberStudent FROM svgroup AS A INNER JOIN supervisor USING (svID) GROUP BY A.groupNo");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setGroupNo(rs.getInt("groupNo"));
                e.setSvName(rs.getString("svName"));
                e.setNumber(rs.getInt("numberStudent"));
                e.setSvID(rs.getInt("svID"));

                list.add(e);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static List<user> getUnassignedSVGroup() {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(pairID) AS numStu FROM panelGroup RIGHT JOIN svgroup USING (svID) RIGHT JOIN supervisor USING (svID) WHERE panelGpNo IS NULL GROUP BY svID");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setSvID(rs.getInt("svID"));
                e.setSvName(rs.getString("svName"));
                e.setNumber(rs.getInt("numStu"));
                e.setGroupNo(rs.getInt("groupNo"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<user> getPresentStuByGpNo(int panelGpNo) {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM panelGroup INNER JOIN svgroup USING (svID) INNER JOIN student USING (matricNo) INNER JOIN fypcourse USING (courseCode) WHERE panelGpNo=? GROUP BY matricNo");
            ps.setInt(1, panelGpNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user e = new user();
                e.setMatricNo(rs.getString("matricNo"));
                e.setName(rs.getString("stuName"));
                e.setCrsName(rs.getString("courseName"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static user getSVGroupBySVID(int svID) {
        user e = new user();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(A.groupNo) AS numberStudent FROM svgroup AS A INNER JOIN supervisor USING (svID) WHERE A.svID=?");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                e.setGroupNo(rs.getInt("groupNo"));
                e.setSvName(rs.getString("svName"));
                e.setNumber(rs.getInt("numberStudent"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return e;
    }

    public static Integer getTotalSvGroupNumber() {
        int totalGroup = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM svgroup LEFT JOIN panelGroup USING (svID) WHERE panelID IS NULL GROUP BY svID");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                totalGroup += 1;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return totalGroup;
    }

    public static List<user> getNumberStuBasedFYP() {
        List<user> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(matricNo) AS Number, courseCode, courseName FROM fypcourse LEFT JOIN student USING (courseCode) GROUP BY courseCode");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                user crs = new user();
                crs.setCrsCode(rs.getString("courseCode"));
                crs.setCrsName(rs.getString("courseName"));
                crs.setNumber(rs.getInt("Number"));

                list.add(crs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }
}
