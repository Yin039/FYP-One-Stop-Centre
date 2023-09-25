package com.dao;

import com.model.*;
import com.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 *
 * @author TEOH YI YIN
 */
public class projectDao {

    public static int registerProject(project e, String matricNo) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into project(projectTitle, projectType, projectDesc, projectApproval, matricNo, coSvName, coSvHp, projectProgress) values (?,?,?,?,?,?,?,?)");
            ps.setString(1, e.getProjectTitle());
            ps.setString(2, e.getProjectType());
            ps.setString(3, e.getProjectDesc());
            ps.setString(4, e.getProjectApproval());
            ps.setString(5, e.getMatricNo());
            ps.setString(6, e.getCoSvName());
            ps.setString(7, e.getCoSvHp());
            ps.setDouble(8, 0);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static int updateProject(project e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("update project set projectTitle=?, projectType=?, projectDesc=?, projectApproval=?, coSvName=?, coSvHp=? where projectID=?");
            ps.setString(1, e.getProjectTitle());
            ps.setString(2, e.getProjectType());
            ps.setString(3, e.getProjectDesc());
            ps.setString(4, e.getProjectApproval());
            ps.setString(5, e.getCoSvName());
            ps.setString(6, e.getCoSvHp());
            ps.setInt(7, e.getProjectID());

            status = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static project getProjectByID(int projectID) {
        project proj = new project();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from project where projectID=?");
            ps.setInt(1, projectID);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                proj.setProjectID(rs.getInt("projectID"));
                proj.setMatricNo(rs.getString("matricNo"));
                proj.setProjectTitle(rs.getString("projectTitle"));
                proj.setProjectDesc(rs.getString("projectDesc"));
                proj.setProjectType(rs.getString("projectType"));
                proj.setProjectApproval(rs.getString("projectApproval"));
                proj.setCoSvName(rs.getString("coSvName"));
                proj.setCoSvHp(rs.getString("coSvHp"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return proj;
    }

    public static project getProjectByMatricNo(String matricNo) {
        project proj = new project();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from project INNER JOIN student USING (matricNo) where matricNo=?");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                proj.setProjectID(rs.getInt("projectID"));
                proj.setMatricNo(rs.getString("matricNo"));
                proj.setProjectTitle(rs.getString("projectTitle"));
                proj.setProjectDesc(rs.getString("projectDesc"));
                proj.setProjectType(rs.getString("projectType"));
                proj.setProjectApproval(rs.getString("projectApproval"));
                proj.setProjectProgress(rs.getDouble("projectProgress"));
                proj.setCoSvName(rs.getString("coSvName"));
                proj.setCoSvHp(rs.getString("coSvHp"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return proj;
    }

    public static List<project> getProjectByGroup(int groupNo) {
        List<project> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from project INNER JOIN svgroup USING (matricNo) where groupNo=?");
            ps.setInt(1, groupNo);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                project e = new project();
                e.setProjectID(rs.getInt("projectID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setProjectTitle(rs.getString("projectTitle"));
                e.setProjectDesc(rs.getString("projectDesc"));
                e.setProjectType(rs.getString("projectType"));
                e.setProjectApproval(rs.getString("projectApproval"));
                e.setCoSvName(rs.getString("coSvName"));
                e.setCoSvHp(rs.getString("coSvHp"));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static int updateApprovalStatus(int projectID, String approvalStatus) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("update project set projectApproval=? where projectID=?");
            ps.setString(1, approvalStatus);
            ps.setInt(2, projectID);

            status = ps.executeUpdate();

            if (approvalStatus.equals("Approved")) {
                ps = con.prepareStatement("select * from project INNER JOIN student USING (matricNo) INNER JOIN fypcourse USING (courseCode) where projectID=?");
                ps.setInt(1, projectID);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    List<projectProgress> mainTask = projectProgressDao.getMainTaskByCourseName(rs.getString("courseName"));

                    for (projectProgress main : mainTask) {
                        List<projectProgress> subTask = projectProgressDao.getSubTaskByMainTaskID(main.getMainTaskID());

                        for (projectProgress sub : subTask) {
                            projectProgress p = new projectProgress();
                            p.setProjectID(projectID);
                            p.setSubTaskID(sub.getSubTaskID());

                            projectProgressDao.addTracking(p);
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return status;
    }

    public static List<project> getProjectByApprovalStatus(String projectApproval) {
        List<project> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from project where projectApproval=?");
            ps.setString(1, projectApproval);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                project e = new project();
                e.setProjectID(rs.getInt("projectID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setProjectTitle(rs.getString("projectTitle"));
                e.setProjectDesc(rs.getString("projectDesc"));
                e.setProjectType(rs.getString("projectType"));
                e.setProjectApproval(rs.getString("projectApproval"));
                e.setCoSvName(rs.getString("coSvName"));
                e.setCoSvHp(rs.getString("coSvHp"));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<project> getStuNotRegisteredProject() {
        List<project> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM project RIGHT JOIN student USING (matricNO) WHERE projectID IS NULL");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                project e = new project();
                e.setProjectID(rs.getInt("projectID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setProjectTitle(rs.getString("projectTitle"));
                e.setProjectDesc(rs.getString("projectDesc"));
                e.setProjectType(rs.getString("projectType"));
                e.setProjectApproval(rs.getString("projectApproval"));
                e.setCoSvName(rs.getString("coSvName"));
                e.setCoSvHp(rs.getString("coSvHp"));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<project> getProjectList() {
        List<project> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from project INNER JOIN svgroup USING (matricNo) RIGHT JOIN student USING (matricNO) ORDER BY matricNo");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                project e = new project();
                e.setProjectID(rs.getInt("projectID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setProjectTitle(rs.getString("projectTitle"));
                e.setProjectDesc(rs.getString("projectDesc"));
                e.setProjectType(rs.getString("projectType"));
                e.setProjectApproval(rs.getString("projectApproval"));
                e.setProjectProgress(rs.getDouble("projectProgress"));
                e.setCoSvName(rs.getString("coSvName"));
                e.setCoSvHp(rs.getString("coSvHp"));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
