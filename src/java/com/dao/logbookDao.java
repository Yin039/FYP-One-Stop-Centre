package com.dao;

import com.model.*;
import com.util.DBConnection;
import java.sql.*;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class logbookDao {

    public static int addLogBook(logbook lb) throws ParseException {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into logbook(meetID, matricNo, timestamp, projectAct, projectProb, probSolveSuggest, logValidate) values (?,?,?,?,?,?,?)");
            ps.setInt(1, lb.getMeetID());
            ps.setString(2, lb.getMatricNo());
            ps.setTimestamp(3, lb.getTimestamp());
            ps.setString(4, lb.getProjectAct());
            ps.setString(5, lb.getProjectProb());
            ps.setString(6, lb.getProjectSolveSuggest());
            ps.setString(7, lb.getLogValidate());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static logbook getLBByMatricNoMeetID(String matricNo, int meetID) {
        logbook lb = new logbook();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from logbook where matricNo=? and meetID=?");
            ps.setString(1, matricNo);
            ps.setInt(2, meetID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                lb.setLogID(rs.getInt("logID"));
                lb.setMeetID(rs.getInt("meetID"));
                lb.setMatricNo(rs.getString("matricNo"));
                lb.setProjectAct(rs.getString("projectAct"));
                lb.setProjectProb(rs.getString("projectProb"));
                lb.setProjectSolveSuggest(rs.getString("probSolveSuggest"));
                lb.setLogValidate(rs.getString("logValidate"));
                lb.setTimestamp(rs.getTimestamp("timestamp"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lb;
    }

    public static List<logbook> getListLBBySvID(int svID) {
        List<logbook> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from logbook INNER JOIN meeting USING (meetID) where svID=?");
            ps.setInt(1, svID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                logbook lb = new logbook();
                lb.setLogID(rs.getInt("logID"));
                lb.setMeetID(rs.getInt("meetID"));
                lb.setMatricNo(rs.getString("matricNo"));
                lb.setProjectAct(rs.getString("projectAct"));
                lb.setProjectProb(rs.getString("projectProb"));
                lb.setProjectSolveSuggest(rs.getString("probSolveSuggest"));
                lb.setLogValidate(rs.getString("logValidate"));
                lb.setTimestamp(rs.getTimestamp("timestamp"));

                list.add(lb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static logbook getLBByID(int logID) {
        logbook lb = new logbook();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from logbook where logID=?");
            ps.setInt(1, logID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                lb.setLogID(rs.getInt("logID"));
                lb.setMeetID(rs.getInt("meetID"));
                lb.setMatricNo(rs.getString("matricNo"));
                lb.setProjectAct(rs.getString("projectAct"));
                lb.setProjectProb(rs.getString("projectProb"));
                lb.setProjectSolveSuggest(rs.getString("probSolveSuggest"));
                lb.setLogValidate(rs.getString("logValidate"));
                lb.setTimestamp(rs.getTimestamp("timestamp"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lb;
    }

    public static int updateLB(logbook lb) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update logbook set timestamp=?, projectAct=?, projectProb=?, probSolveSuggest=?, logValidate=? where logID=?");
            ps.setTimestamp(1, lb.getTimestamp());
            ps.setString(2, lb.getProjectAct());
            ps.setString(3, lb.getProjectProb());
            ps.setString(4, lb.getProjectSolveSuggest());
            ps.setString(5, lb.getLogValidate());
            ps.setInt(6, lb.getLogID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int getMeetingFrequency(String matricNo) {
        int mFrequency = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("SELECT COUNT(logValidate) AS mFrequency FROM logbook WHERE matricNo=? AND logValidate='Valid'");
            ps.setString(1, matricNo);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                mFrequency = rs.getInt("mFrequency");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return mFrequency;
    }
    
    public static List<Integer> getAllMeetFrequency() {
        List<Integer> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("SELECT COUNT(logValidate) AS mFrequency FROM logbook WHERE logValidate='Valid';");
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                int mFrequency = 0;
                
                mFrequency = rs.getInt("mFrequency");
                list.add(mFrequency);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
    
    public static List<Integer> getAllNumberStu() {
        List<Integer> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("SELECT A.matricNo, COUNT(B.logValidate='Valid') AS mFrequency FROM appointment AS A LEFT JOIN logbook AS B ON (A.matricNo=B.matricNo AND A.meetID=B.meetID) WHERE appointVerify='Approved' GROUP BY A.matricNo;");
            
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                int stuNo = 0;
                
                stuNo = rs.getInt("mFrequency");
                list.add(stuNo);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }
}
