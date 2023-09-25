package com.dao;

import com.model.meeting;
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
public class meetingDao {
    
    public static int addMeet(meeting meet) {
        int status = 0;
        
        Date meetDate = new Date(meet.getMeetDate().getTime());
        
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into meeting(svID, meetDate, meetTime, meetLocate, meetMode) values (?,?,?,?,?)");
            ps.setInt(1, meet.getSvID());
            ps.setDate(2, meetDate);
            ps.setTime(3, meet.getMeetTime());
            ps.setString(4, meet.getMeetLocate());
            ps.setString(5, meet.getMeetMode());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static List<meeting> getMeetBySvID(int svID){
        List<meeting> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from meeting where svID=? ORDER BY meetDate");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                meeting meet = new meeting();
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));

                list.add(meet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<meeting> getMeetToAppointBySvID(String matricNo, java.util.Date today){
        List<meeting> list = new ArrayList<>();
        
        Date current = new Date(today.getTime());
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from student AS A INNER JOIN svgroup AS B ON (A.matricNo=B.matricNo) INNER JOIN meeting AS C ON (B.svID=C.svID) LEFT JOIN appointment AS D ON (A.matricNo=D.matricNo AND C.meetID=D.meetID) WHERE A.matricNo=? AND D.appointID IS NULL AND C.meetDate>?;");
            ps.setString(1, matricNo);
            ps.setDate(2, current);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                meeting meet = new meeting();
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));

                list.add(meet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static meeting getMeetByID(int meetID) {
        meeting meet = new meeting();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from meeting where meetID=?");
            ps.setInt(1, meetID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return meet;
    }
    
    public static int updateMeet(meeting meet) {
        int status = 0;
        
        Date meetDate = new Date(meet.getMeetDate().getTime());
        
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update meeting set meetDate=?, meetTime=?, meetLocate=?, meetMode=? where meetID=?");            
            ps.setDate(1, meetDate);
            ps.setTime(2, meet.getMeetTime());
            ps.setString(3, meet.getMeetLocate());
            ps.setString(4, meet.getMeetMode());
            ps.setInt(5, meet.getMeetID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }    
    
    public static int deleteMeet(int meetID) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from meeting where meetID=?");            
            ps.setInt(1, meetID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }   
    
    public static List<meeting> getUpcomingMeetBySvID(int svID){
        List<meeting> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM appointment LEFT JOIN meeting USING (meetID) WHERE appointVerify='Approved' and svID=? AND meetDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 7 DAY GROUP BY meetDate ORDER BY meetDate");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                meeting meet = new meeting();
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));

                list.add(meet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<meeting> getUpcomingMeetByDateSvID(java.util.Date meetDate, int svID){
        List<meeting> list = new ArrayList<>();
        
        Date date = new Date(meetDate.getTime());
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM meeting WHERE meetDate=? AND svID=? ORDER BY meetTime");
            ps.setDate(1, date);
            ps.setInt(2, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                meeting meet = new meeting();
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));

                list.add(meet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<meeting> getUpcomingMeetByMatricNo(String matricNo){
        List<meeting> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM appointment LEFT JOIN meeting USING (meetID) WHERE appointVerify='Approved' and matricNo=? AND meetDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 7 DAY GROUP BY meetDate ORDER BY meetDate");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                meeting meet = new meeting();
                meet.setMeetID(rs.getInt("meetID"));
                meet.setMeetDate(rs.getDate("meetDate"));
                meet.setMeetTime(rs.getTime("meetTime"));
                meet.setMeetLocate(rs.getString("meetLocate"));
                meet.setMeetMode(rs.getString("meetMode"));

                list.add(meet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
