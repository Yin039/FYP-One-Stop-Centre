/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.dao;

import com.model.*;
import com.util.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author TEOH YI YIN
 */
public class projectProgressDao {
    
    public static int addMainTask(projectProgress p) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into mainTask(mainTask, courseName) values (?,?)");
            ps.setString(1, p.getMainTask());
            ps.setString(2, p.getCourseName());
            
            status = ps.executeUpdate();
            
            if (status > 0) {
                ps = con.prepareStatement("select * from mainTask ORDER BY mainTaskID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    p.setMainTaskID(rs.getInt("mainTaskID"));
                }
            }
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int addSubTask(projectProgress p) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into subTask(mainTaskID, subTask) values (?,?)");
            ps.setInt(1, p.getMainTaskID());
            ps.setString(2, p.getSubTask());
            
            status = ps.executeUpdate();
            
            if (status > 0) {
                ps = con.prepareStatement("select * from subTask ORDER BY subTaskID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    p.setSubTaskID(rs.getInt("subTaskID"));
                }
            }
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int addModuleTracking(projectProgress p) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into moduleTracking(module, projectID, trackStatus) values (?,?,?)");
            ps.setString(1, p.getModule());
            ps.setInt(2, p.getProjectID());
            ps.setString(3, "Incomplete");
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int addTracking(projectProgress p) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into tracking(subTaskID, projectID, trackStatus) values (?,?,?)");
            ps.setInt(1, p.getSubTaskID());
            ps.setInt(2, p.getProjectID());
            ps.setString(3, "Incomplete");
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateProjectProgress(double projectProgress, int projectID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update project set projectProgress=? where projectID=?");
            ps.setDouble(1, projectProgress);
            ps.setInt(2, projectID);
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateTracking(projectProgress p) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update tracking set trackStatus=? where trackID=?");
            ps.setString(1, p.getTrackStatus());
            ps.setInt(2, p.getTrackID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateMainTask(projectProgress p) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update mainTask set mainTask=? where mainTaskID=?");
            ps.setString(1, p.getMainTask());
            ps.setInt(2, p.getMainTaskID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateSubTask(projectProgress p) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update subTask set subTask=? where subTaskID=?");
            ps.setString(1, p.getSubTask());
            ps.setInt(2, p.getSubTaskID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateModuleTrack(projectProgress p) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update moduleTracking set module=?, trackStatus=? where moduleTrackID=?");
            ps.setString(1, p.getModule());
            ps.setString(2, p.getTrackStatus());
            ps.setInt(3, p.getModuleTrackID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static List<projectProgress> getMainTaskByCourseName(String courseName) {
        List<projectProgress> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from mainTask where courseName=?");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                projectProgress p = new projectProgress();
                p.setMainTaskID(rs.getInt("mainTaskID"));
                p.setMainTask(rs.getString("mainTask"));

                list.add(p);
            }
        } catch (SQLException ex) {}
        return list;
    }
    
    public static String getMainTaskByID(int mainTaskID){
        String mainTask = null;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from mainTask where mainTaskID=?");
            ps.setInt(1, mainTaskID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                mainTask = rs.getString("mainTask");
            }
        } catch (SQLException ex) {}
        return mainTask;
    }
    
    public static List<projectProgress> getSubTaskByMainTaskID(int mainTaskID) {
        List<projectProgress> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from subTask where mainTaskID=?");
            ps.setInt(1, mainTaskID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                projectProgress p = new projectProgress();
                p.setSubTaskID(rs.getInt("subTaskID"));
                p.setSubTask(rs.getString("subTask"));

                list.add(p);
            }
        } catch (SQLException ex) {}
        return list;
    }
    
    public static List<projectProgress> getTrackingByProjectID(int projectID) {
        List<projectProgress> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from tracking INNER JOIN subTask USING (subTaskID) INNER JOIN mainTask USING (mainTaskID) where projectID=?");
            ps.setInt(1, projectID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                projectProgress p = new projectProgress();
                p.setTrackID(rs.getInt("trackID"));
                p.setMainTaskID(rs.getInt("mainTaskID"));
                p.setMainTask(rs.getString("mainTask"));
                p.setSubTaskID(rs.getInt("subTaskID"));
                p.setSubTask(rs.getString("subTask"));
                p.setTrackStatus(rs.getString("trackStatus"));

                list.add(p);
            }
        } catch (SQLException ex) {}
        return list;
    }
    
    public static List<projectProgress> getModuleTrackingByProjectID(int projectID) {
        List<projectProgress> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from moduleTracking where projectID=?");
            ps.setInt(1, projectID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                projectProgress p = new projectProgress();
                p.setModuleTrackID(rs.getInt("moduleTrackID"));
                p.setProjectID(projectID);
                p.setModule(rs.getString("module"));
                p.setTrackStatus(rs.getString("trackStatus"));

                list.add(p);
            }
        } catch (SQLException ex) {}
        return list;
    }
    
    public static int deleteTrackingByProjectID(int projectID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from tracking where projectID=?");
            ps.setInt(1, projectID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int deleteMainTask(int mainTaskID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from mainTask where mainTaskID=?");
            ps.setInt(1, mainTaskID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int deleteSubTask(int subTaskID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from subTask where subTaskID=?");
            ps.setInt(1, subTaskID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int deleteModuleTracking(int moduleTrackID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from moduleTracking where moduleTrackID=?");
            ps.setInt(1, moduleTrackID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int addSubmission(projectProgress p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into submission(matricNo, mainTaskID, documentName, document, submitDate) values (?,?,?,?,?)");
            ps.setString(1, p.getMatricNo());
            ps.setInt(2, p.getMainTaskID());
            ps.setString(3, p.getDocumentName());
            ps.setBytes(4, p.getDocument());
            ps.setTimestamp(5, p.getSubmitDate());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static int updateSubmission(projectProgress p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update submission set documentName=?, document=?, submitDate=? where submitID=?");
            ps.setString(1, p.getDocumentName());
            ps.setBytes(2, p.getDocument());
            ps.setTimestamp(3, p.getSubmitDate());
            ps.setInt(4, p.getSubmitID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {}
        return status;
    }
    
    public static projectProgress getSubmitByIDs(int mainTaskID, String matricNo) {
        projectProgress p = new projectProgress();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from submission where mainTaskID=? and matricNo=?");
            ps.setInt(1, mainTaskID);
            ps.setString(2, matricNo);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p.setSubmitID(rs.getInt("submitID"));
                p.setMainTaskID(rs.getInt("mainTaskID"));
                p.setMatricNo(rs.getString("matricNo"));
                p.setDocumentName(rs.getString("documentName"));
                p.setDocument(rs.getBytes("document"));
                p.setSubmitDate(rs.getTimestamp("submitDate"));
            }
        } catch (SQLException ex) {}
        return p;
    }
    
    public static projectProgress getSubmitByIDs(int submitID) {
        projectProgress p = new projectProgress();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from submission where submitID=?");
            ps.setInt(1, submitID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p.setSubmitID(rs.getInt("submitID"));
                p.setMainTaskID(rs.getInt("mainTaskID"));
                p.setMatricNo(rs.getString("matricNo"));
                p.setDocumentName(rs.getString("documentName"));
                p.setDocument(rs.getBytes("document"));
                p.setSubmitDate(rs.getTimestamp("submitDate"));
            }
        } catch (SQLException ex) {}
        return p;
    }
}
