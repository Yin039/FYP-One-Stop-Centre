package com.dao;

import com.model.appointment;
import com.model.meeting;
import com.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 *
 * @author TEOH YI YIN
 */
public class appointmentDao {

    public static int appoint(appointment appoint) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into appointment(meetID, matricNo, appointVerify) values (?,?,?)");
            ps.setInt(1, appoint.getMeetID());
            ps.setString(2, appoint.getMatricNo());
            ps.setString(3, appoint.getAppointVerify());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int addAppoint(meeting meet, appointment appoint) {
        int status = 0;

        java.sql.Date meetDate = new java.sql.Date(meet.getMeetDate().getTime());

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into meeting(svID, meetDate, meetTime, meetLocate, meetMode) values (?,?,?,?,?)");
            ps.setInt(1, meet.getSvID());
            ps.setDate(2, meetDate);
            ps.setTime(3, meet.getMeetTime());
            ps.setString(4, meet.getMeetLocate());
            ps.setString(5, meet.getMeetMode());

            status = ps.executeUpdate();

            if (status > 0) {
                ps = con.prepareStatement("select * from meeting ORDER BY meetID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    ps = con.prepareStatement("insert into appointment(meetID, matricNo, appointVerify) values (?,?,?)");
                    ps.setInt(1, rs.getInt("meetID"));
                    ps.setString(2, appoint.getMatricNo());
                    ps.setString(3, appoint.getAppointVerify());

                    status = ps.executeUpdate();
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<appointment> getAppointByMatricNo(String matricNo) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where matricNo=? and appointVerify!='Approved'");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<appointment> getApprovedAppointByMatricNo(String matricNo) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where matricNo=? and appointVerify='Approved'");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<appointment> getApprovedAppointBySvID(int svID) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment INNER JOIn svgroup USING (matricNo) where svID=? and appointVerify='Approved';");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<appointment> getAppointBySvID(int svID) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment LEFT JOIN meeting USING (meetID) where svID=? ORDER BY meetDate DESC");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
     public static List<appointment> searchAppointByMatricNo(int svID, String matricNo) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment  AS A LEFT JOIN meeting USING (meetID) where svID=? AND A.matricNo LIKE ? ORDER BY meetDate DESC ");
            ps.setInt(1, svID);
            ps.setString(2, "%" + matricNo + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<appointment> getListAppointByMeetID(int meetID) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where meetID=?");
            ps.setInt(1, meetID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<appointment> getAllAppointApprovedBySvID(int svID) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment LEFT JOIN meeting USING (meetID) where appointVerify='Approved' and svID=? ORDER BY meetDate DESC");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }    
    
    public static List<appointment> searchAppointApprovedByMatricNo(int svID, String matricNo) {
        List<appointment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select *, A.svID from appointment INNER JOIN svgroup AS A USING (matricNo) INNER JOIN meeting USING (meetID) where appointVerify='Approved' and A.svID=? and matricNo LIKE ? ORDER BY meetDate DESC");
            ps.setInt(1, svID);
            ps.setString(2, "%" + matricNo + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment appoint = new appointment();
                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));

                list.add(appoint);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static appointment getAppointByID(int appointID) {
        appointment appoint = new appointment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where appointID=?");
            ps.setInt(1, appointID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                appoint.setAppointID(appointID);
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appoint;
    }

    public static appointment getAppointByMeetID(int meetID) {
        appointment appoint = new appointment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where meetID=?");
            ps.setInt(1, meetID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appoint;
    }
    
    public static appointment getAppointByMatricNoMeetID(int meetID, String matricNo) {
        appointment appoint = new appointment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment where meetID=? and matricNo=?");
            ps.setInt(1, meetID);
            ps.setString(2, matricNo);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                appoint.setAppointID(rs.getInt("appointID"));
                appoint.setMeetID(rs.getInt("meetID"));
                appoint.setAppointVerify(rs.getString("appointVerify"));
                appoint.setMatricNo(rs.getString("matricNo"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appoint;
    }

    public static int updateAppointStatus(int appointID, String appointVerifye) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update appointment set appointVerify=? where appointID=?");
            ps.setString(1, appointVerifye);
            ps.setInt(2, appointID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int deleteAppointment(int appointID) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from appointment where appointID=?");            
            ps.setInt(1, appointID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }   
}
