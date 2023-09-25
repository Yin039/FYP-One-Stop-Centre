package com.dao;

import com.model.*;
import com.sun.glass.ui.Window;
import com.util.DBConnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.swing.JOptionPane;

/**
 *
 * @author TEOH YI YIN
 */
public class presentationDao {
    
    public static int addPanelGroup(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("insert into panelGroup(svID, panelGpNo, panelLeader) values (?,?,?)");
            ps.setInt(1, p.getSvID());
            ps.setInt(2, p.getPanelGpNo());
            ps.setString(3, "No");
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int updatePanelGroup(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("update panelGroup set panelLeader=? where panelID=?");
            ps.setString(1, p.getPanelLeader());
            ps.setInt(2, p.getPanelID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static presentation getPanelGroupBySvID(int svID) {
        presentation p = new presentation();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM panelGroup INNER JOIN svgroup USING (svID) WHERE svID=? GROUP BY svID");
            ps.setInt(1, svID);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p.setPanelID(rs.getInt("panelID"));
                p.setSvID(rs.getInt("svID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                
            }
        } catch (SQLException ex) {
        }
        return p;
    }
    
    public static List<presentation> getSVWithoutPanelGroup() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM svgroup LEFT JOIN panelGroup USING (svID) WHERE panelID IS NULL GROUP BY svID");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setSvID(rs.getInt("svID"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPanelGroupByPanelGpNoSvID(int panelGpNo, int svID) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM panelGroup INNER JOIN svgroup USING (svID) WHERE panelGpNo=? AND svID != ? GROUP BY svID;");
            ps.setInt(1, panelGpNo);
            ps.setInt(2, svID);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPanelID(rs.getInt("panelID"));
                p.setSvID(rs.getInt("svID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPanelGroupByPanelGpNo(int panelGpNo) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM panelGroup INNER JOIN svgroup USING (svID) WHERE panelGpNo=? GROUP BY svID;");
            ps.setInt(1, panelGpNo);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPanelID(rs.getInt("panelID"));
                p.setSvID(rs.getInt("svID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPanelGroupBasedPanelGpNo() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(pairID) AS numStu FROM panelGroup INNER JOIN svgroup USING (svID) ORDER BY groupNo");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPanelID(rs.getInt("panelID"));
                p.setSvID(rs.getInt("svID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPanelGroupList() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(pairID) AS numStu FROM panelGroup INNER JOIN svgroup USING (svID) GROUP BY panelID ORDER BY panelGpNo, groupNo");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPanelID(rs.getInt("panelID"));
                p.setSvID(rs.getInt("svID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static int deletePanelGroupByGpNo(int panelGpNo) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("delete from panelGroup where panelGpNo=?");
            ps.setInt(1, panelGpNo);
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int deletePanel(int panelID) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("delete from panelGroup where panelID=?");
            ps.setInt(1, panelID);
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int addPresentLocate(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("insert into presentLocate(presentLocate, locateValid) values (?,?)");
            ps.setString(1, p.getPresentLocate());
            ps.setString(2, p.getPresentLocateValid());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int updatePresentLocate(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("update presentLocate set presentLocate=?, locateValid=? where locateID=?");
            ps.setString(1, p.getPresentLocate());
            ps.setString(2, p.getPresentLocateValid());
            ps.setInt(3, p.getLocateID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int getLastPanelGroupNo() {
        int panelGpNo = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("select * from panelGroup ORDER BY panelGpNo DESC LIMIT 1");
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                panelGpNo = rs.getInt("panelGpNo");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return panelGpNo;
    }
    
    public static List<presentation> getLocationList() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentLocate");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLocateValid(rs.getString("locateValid"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getValidLocationList() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentLocate LEFT JOIN presentation USING (locateID) WHERE locateValid='Valid' AND presentID IS NULL");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLocateValid(rs.getString("locateValid"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static int deletePresentLocate(int locateID) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("delete from presentLocate where locateID=?");
            ps.setInt(1, locateID);
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int addPresentation(presentation p) {
        int status = 0;
        
        Date presentDate = new Date(p.getPresentDate().getTime());
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("insert into presentation(panelGpNo, locateID, presentLink, presentDate, presentStartTime, presentEndTime, presentRemark, presentLocateValid, presentSetUp) values (?,?,?,?,?,?,?,?,?)");
            ps.setInt(1, p.getPanelGpNo());
            ps.setInt(2, p.getLocateID());
            ps.setString(3, p.getPresentLink());
            ps.setDate(4, presentDate);
            ps.setTime(5, p.getPresentStartTime());
            ps.setTime(6, p.getPresentEndTime());
            ps.setString(7, p.getPresentRemark());
            ps.setString(8, p.getPresentLocateValid());
            ps.setString(9, p.getPresentSetUp());
            
            status = ps.executeUpdate();
            
            if (status > 0) {
                ps = con.prepareStatement("select * from presentation ORDER BY presentID DESC LIMIT 1");
                
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    status = rs.getInt("presentID");
                    p.setPresentID(rs.getInt("presentID"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int updatePresentation(presentation p) {
        int status = 0;
        
        Date presentDate = new Date(p.getPresentDate().getTime());
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("update presentation set locateID=?, presentLink=?, presentDate=?, presentStartTime=?, presentEndTime=?, presentRemark=? where presentID=?");
            ps.setInt(1, p.getLocateID());
            ps.setString(2, p.getPresentLink());
            ps.setDate(3, presentDate);
            ps.setTime(4, p.getPresentStartTime());
            ps.setTime(5, p.getPresentEndTime());
            ps.setString(6, p.getPresentRemark());
            ps.setInt(7, p.getPresentID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int updatePresentationState(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("update presentation set presentRemark=?, presentLocateValid=?, presentSetUp=? where presentID=?");
            ps.setString(1, p.getPresentRemark());
            ps.setString(2, p.getPresentLocateValid());
            ps.setString(3, p.getPresentSetUp());
            ps.setInt(4, p.getPresentID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static presentation getPresentationByID(int presentID) {
        presentation p = new presentation();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentation INNER JOIN presentLocate USING (locateID) where presentID=?");
            ps.setInt(1, presentID);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p.setPresentID(rs.getInt("presentID"));
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLink(rs.getString("presentLink"));
                p.setPresentDate(rs.getDate("presentDate"));
                p.setPresentStartTime(rs.getTime("presentStartTime"));
                p.setPresentEndTime(rs.getTime("presentEndTime"));
                p.setPresentRemark(rs.getString("presentRemark"));
                p.setPresentLocateValid(rs.getString("presentLocateValid"));
                p.setPresentSetUp(rs.getString("presentSetUp"));
                
            }
        } catch (SQLException ex) {
        }
        return p;
    }
    
    public static presentation getPresentLocate(int panelGpNo) {
        presentation p = new presentation();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentation INNER JOIN presentLocate USING (locateID) where panelGpNo=?");
            ps.setInt(1, panelGpNo);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                
            }
        } catch (SQLException ex) {
        }
        return p;
    }
    
    public static List<presentation> getPresentationListByGpNo(int panelGpNo) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *,COUNT(matricNo) AS stuNum FROM presentation INNER JOIN presentLocate USING (locateID) INNER JOIN panelGroup USING (panelGpNo) INNER JOIN svgroup USING (svID) WHERE panelGpNo=? GROUP BY presentID ORDER BY panelGpNo");
            ps.setInt(1, panelGpNo);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPresentID(rs.getInt("presentID"));
                p.setPanelID(rs.getInt("panelID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLink(rs.getString("presentLink"));
                p.setPresentDate(rs.getDate("presentDate"));
                p.setPresentStartTime(rs.getTime("presentStartTime"));
                p.setPresentEndTime(rs.getTime("presentEndTime"));
                p.setPresentRemark(rs.getString("presentRemark"));
                p.setPresentLocateValid(rs.getString("presentLocateValid"));
                p.setPresentSetUp(rs.getString("presentSetUp"));
                p.setStuNum(rs.getInt("stuNum"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getStuPresentationListByGpNo(int panelGpNo) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentation INNER JOIN presentationAttendance USING (presentID) WHERE panelGpNo=? GROUP BY matricNo ORDER BY matricNo");
            ps.setInt(1, panelGpNo);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setMatricNo(rs.getString("matricNo"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getStuPresentationListByID(int presentID) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentation INNER JOIN presentLocate USING (locateID) INNER JOIN panelGroup USING (panelGpNo) INNER JOIN svgroup USING (svID) WHERE presentID=? ORDER BY panelGpNo;");
            ps.setInt(1, presentID);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPresentID(rs.getInt("presentID"));
                p.setPanelID(rs.getInt("panelID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setPanelLeader(rs.getString("panelLeader"));
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLink(rs.getString("presentLink"));
                p.setPresentDate(rs.getDate("presentDate"));
                p.setPresentStartTime(rs.getTime("presentStartTime"));
                p.setPresentEndTime(rs.getTime("presentEndTime"));
                p.setPresentRemark(rs.getString("presentRemark"));
                p.setPresentLocateValid(rs.getString("presentLocateValid"));
                p.setPresentSetUp(rs.getString("presentSetUp"));
                p.setMatricNo(rs.getString("matricNo"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPresentationList() {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentation INNER JOIN presentLocate USING (locateID) GROUP BY panelGpNo ORDER BY panelGpNo");
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPresentID(rs.getInt("presentID"));
                p.setPanelGpNo(rs.getInt("panelGpNo"));
                p.setLocateID(rs.getInt("locateID"));
                p.setPresentLocate(rs.getString("presentLocate"));
                p.setPresentLink(rs.getString("presentLink"));
                p.setPresentDate(rs.getDate("presentDate"));
                p.setPresentStartTime(rs.getTime("presentStartTime"));
                p.setPresentEndTime(rs.getTime("presentEndTime"));
                p.setPresentRemark(rs.getString("presentRemark"));
                p.setPresentLocateValid(rs.getString("presentLocateValid"));
                p.setPresentSetUp(rs.getString("presentSetUp"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static int deletePresentation(int presentID) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("delete from presentation where presentID=?");
            ps.setInt(1, presentID);
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int updatePresentAttend(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("update presentationAttendance set attendStatus=? where presentAttendID=?");
            ps.setString(1, p.getAttendStatus());
            ps.setInt(2, p.getPresentAttendID());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int addPresentAttend(presentation p) {
        int status = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            PreparedStatement ps = con.prepareStatement("insert into presentationAttendance(matricNo, presentID, attendStatus) values (?,?,?)");
            ps.setString(1, p.getMatricNo());
            ps.setInt(2, p.getPresentID());
            ps.setString(3, p.getAttendStatus());
            
            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }
    
    public static int getPresentStuNum(int presentID) {
        int presentStu = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, COUNT(attendStatus) AS presentStu FROM presentationAttendance WHERE attendStatus='Present' AND presentID=?");
            ps.setInt(1, presentID);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                presentStu = rs.getInt("presentStu");
            }
        } catch (SQLException ex) {
        }
        return presentStu;
    }
    
    public static List<presentation> getPresentationAttendanceListByPresentID(int presentID) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentationAttendance WHERE presentID=?");
            ps.setInt(1, presentID);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPresentID(rs.getInt("presentID"));
                p.setPresentAttendID(rs.getInt("presentAttendID"));
                p.setMatricNo(rs.getString("matricNo"));
                p.setAttendStatus(rs.getString("attendStatus"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<presentation> getPresentationAttendanceListByMatricNo(String matricNo) {
        List<presentation> list = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM presentationAttendance INNER JOIN presentation USING (presentID) WHERE matricNo=? ORDER BY presentDate");
            ps.setString(1, matricNo);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                presentation p = new presentation();
                p.setPresentID(rs.getInt("presentID"));
                p.setPresentAttendID(rs.getInt("presentAttendID"));
                p.setMatricNo(rs.getString("matricNo"));
                p.setAttendStatus(rs.getString("attendStatus"));
                
                list.add(p);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
}
