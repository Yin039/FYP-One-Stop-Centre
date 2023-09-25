package com.dao;

import com.model.schedule;
import com.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 *
 * @author TEOH YI YIN
 */
public class scheduleDao {

    public static List<String> getFYPCourse() {
        List<String> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from fypcourse");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("courseCode"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static List<String> getCourseCodeByName(String courseName) {
        List<String> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from fypcourse where courseName=?");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getString("courseCode"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static int addScheduleDetails(schedule schedule) {
        int status = 0;
        java.sql.Date date = null;

        if (schedule.getDate() != null) {
            date = new java.sql.Date(schedule.getDate().getTime());
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into scheduleDetails(week, date, activity, action) values (?,?,?,?)");
            ps.setInt(1, schedule.getWeek());
            ps.setDate(2, date);
            ps.setString(3, schedule.getActivity());
            ps.setString(4, schedule.getAction());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateScheduleDetails(schedule schedule) {
        int status = 0;

        java.sql.Date date = null;

        if (schedule.getDate() != null) {
            date = new java.sql.Date(schedule.getDate().getTime());
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update scheduleDetails set week=?, date=?, activity=?, action=? where detailID=?");
            ps.setInt(1, schedule.getWeek());
            ps.setDate(2, date);
            ps.setString(3, schedule.getActivity());
            ps.setString(4, schedule.getAction());
            ps.setInt(5, schedule.getDetailID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateCourseCode(schedule course) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update fypcourse set courseCode=? where courseCode=?");
            ps.setString(1, course.getCourseCode());
            ps.setString(2, course.getOldCode());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<schedule> getScheduleDetails() {
        List<schedule> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from scheduleDetails ORDER BY week");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                schedule s = new schedule();
                s.setDetailID(rs.getInt("detailID"));
                s.setWeek(rs.getInt("week"));
                s.setDate(rs.getDate("date"));
                s.setActivity(rs.getString("activity"));
                s.setAction(rs.getString("action"));

                list.add(s);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }

    public static schedule getScheduleDetailsByID(int detailID) {
        schedule s = new schedule();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from scheduleDetails where detailID=?");
            ps.setInt(1, detailID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                s.setDetailID(rs.getInt("detailID"));
                s.setWeek(rs.getInt("week"));
                s.setDate(rs.getDate("date"));
                s.setActivity(rs.getString("activity"));
                s.setAction(rs.getString("action"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return s;
    }

    public static int deleteScheduleDetails(int detailID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from scheduleDetails where detailID=?");
            ps.setInt(1, detailID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int addMaterial(schedule schedule) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into material(materialName, materialDoc, materialLink, materialType) values (?,?,?,?)");
            ps.setString(1, schedule.getMaterialName());
            ps.setBytes(2, schedule.getMaterialDoc());
            ps.setString(3, schedule.getMaterialLink());
            ps.setString(4, schedule.getMaterialType());

            status = ps.executeUpdate();

            if (status > 0 && schedule.getDetailID() != 0) {
                ps = con.prepareStatement("select * from material ORDER BY materialID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    ps = con.prepareStatement("insert into schedule(detailID, materialID) values (?,?)");
                    ps.setInt(1, schedule.getDetailID());
                    ps.setInt(2, rs.getInt("materialID"));

                    status = ps.executeUpdate();
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateMaterial(schedule schedule) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update material set materialName=?, materialDoc=?, materialLink=?, materialType=? where materialID=?");
            ps.setString(1, schedule.getMaterialName());
            ps.setBytes(2, schedule.getMaterialDoc());
            ps.setString(3, schedule.getMaterialLink());
            ps.setString(4, schedule.getMaterialType());
            ps.setInt(5, schedule.getMaterialID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateSchedule(schedule schedule) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("INSERT INTO schedule(materialID, detailID) VALUES (?,?)");
            ps.setInt(1, schedule.getMaterialID());
            ps.setInt(2, schedule.getDetailID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<schedule> getMaterialByType(String materialType) {
        List<schedule> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from material where materialType=? ORDER BY materialName");
            ps.setString(1, materialType);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                schedule s = new schedule();
                s.setMaterialID(rs.getInt("materialID"));
                s.setMaterialName(rs.getString("materialName"));
                s.setMaterialLink(rs.getString("materialLink"));
                s.setMaterialDoc(rs.getBytes("materialDoc"));

                list.add(s);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public static List<schedule> getMaterialList() {
        List<schedule> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from material ORDER BY materialName");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                schedule s = new schedule();
                s.setMaterialID(rs.getInt("materialID"));
                s.setMaterialName(rs.getString("materialName"));
                s.setMaterialLink(rs.getString("materialLink"));
                s.setMaterialDoc(rs.getBytes("materialDoc"));

                list.add(s);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public static schedule getMaterialByID(int materialID) {
        schedule s = new schedule();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from material where materialID=?");
            ps.setInt(1, materialID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                s.setMaterialID(materialID);
                s.setMaterialName(rs.getString("materialName"));
                s.setMaterialLink(rs.getString("materialLink"));
                s.setMaterialType(rs.getString("materialType"));
                s.setMaterialDoc(rs.getBytes("materialDoc"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return s;
    }

    public static int deleteMaterial(int materialID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from material where materialID=?");
            ps.setInt(1, materialID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<schedule> getSchedule() {
        List<schedule> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM scheduleDetails LEFT JOIN schedule USING (detailID) LEFT JOIN material USING (materialID) ORDER BY week");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                schedule s = new schedule();
                s.setScheduleID(rs.getInt("scheduleID"));
                s.setDetailID(rs.getInt("detailID"));
                s.setWeek(rs.getInt("week"));
                s.setDate(rs.getDate("date"));
                s.setActivity(rs.getString("activity"));
                s.setAction(rs.getString("action"));
                s.setMaterialID(rs.getInt("materialID"));
                s.setMaterialName(rs.getString("materialName"));
                s.setMaterialLink(rs.getString("materialLink"));
                s.setMaterialType(rs.getString("materialType"));
                s.setMaterialDoc(rs.getBytes("materialDoc"));
                list.add(s);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return list;
    }
}
