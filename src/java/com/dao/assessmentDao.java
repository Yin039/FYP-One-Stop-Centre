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
public class assessmentDao {

    public static int addCloPlo(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into cloplo(clo, ploID, loDesc, courseName) values (?,?,?,?)");
            ps.setString(1, a.getClo());
            ps.setInt(2, a.getPloID());
            ps.setString(3, a.getLoDesc());
            ps.setString(4, a.getCourseName());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addAssessComp(assessment a) {
        int status = 0;

        Date startDate = null, endDate = null;

        if (a.getAssessStartDate() != null && a.getAssessEndDate() != null) {
            startDate = new Date(a.getAssessStartDate().getTime());
            endDate = new Date(a.getAssessEndDate().getTime());
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into assessment(assessComponent, courseName, compPercentage, assessStartDate, assessEndDate) values (?,?,?,?,?)");
            ps.setString(1, a.getAssessComponent());
            ps.setString(2, a.getCourseName());
            ps.setDouble(3, a.getCompPercentage());
            ps.setDate(4, startDate);
            ps.setDate(5, endDate);

            status = ps.executeUpdate();

            if (status > 0) {
                ps = con.prepareStatement("select * from assessment ORDER BY assessID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    a.setAssessID(rs.getInt("assessID"));
                }
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addAssessCriteria(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into assessmentCriteria(assessCriteria, criteriaPercentage, cloploID, assessID) values (?,?,?,?)");
            ps.setString(1, a.getAssessCriteria());
            ps.setDouble(2, a.getCriteriaPercentage());
            ps.setInt(3, a.getCloploID());
            ps.setInt(4, a.getAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addSubCriteria(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into subCriteria(criteriaID, subCriteria) values (?,?)");
            ps.setInt(1, a.getCriteriaID());
            ps.setString(2, a.getSubCriteria());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addGradingScale(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into gradingScale(subCriteriaID, gradingScale, scaleDesc) values (?,?,?)");
            ps.setInt(1, a.getSubCriteriaID());
            ps.setInt(2, a.getGradingScale());
            ps.setString(3, a.getScaleDesc());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentAssessment(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentAssessment(matricNo, assessID, stuAssessCompMark) values (?,?,?)");
            ps.setString(1, e.getMatricNo());
            ps.setInt(2, e.getAssessID());
            ps.setDouble(3, e.getStuAssessCompMark());

            status = ps.executeUpdate();

            if (status > 0) {
                ps = con.prepareStatement("select * from studentAssessment ORDER BY stuAssessID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    e.setStuAssessID(rs.getInt("stuAssessID"));
                }
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentPLOMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into stuPLOMark(stuAssessID, ploID, stuPLOMark) values (?,?,?)");
            ps.setInt(1, e.getStuAssessID());
            ps.setInt(2, e.getPloID());
            ps.setDouble(3, e.getStuPLOMark());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStuPresentPLOMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into stuPresentPLOMark(stuPresentAssessID, ploID, stuPresentPLOMark) values (?,?,?)");
            ps.setInt(1, e.getStuAssessID());
            ps.setInt(2, e.getPloID());
            ps.setDouble(3, e.getStuPLOMark());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentCriteriaMark(stuAssessID, criteriaID, stuCriteriaMark) values (?,?,?)");
            ps.setInt(1, e.getStuAssessID());
            ps.setInt(2, e.getCriteriaID());
            ps.setDouble(3, e.getStuCriteriaMark());

            status = ps.executeUpdate();

            if (status < 0) {
                ps = con.prepareStatement("delete from studentAssessment where stuAssessID=?");
                ps.setInt(1, e.getStuAssessID());
            } else {
                ps = con.prepareStatement("select * from studentCriteriaMark ORDER BY stuCriteriaID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    e.setStuCriteriaID(rs.getInt("stuCriteriaID"));
                }
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentSubCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentSubCriteriaMark(stuCriteriaID, subCriteriaID, stuSubCriteriaMark) values (?,?,?)");
            ps.setInt(1, e.getStuCriteriaID());
            ps.setInt(2, e.getSubCriteriaID());
            ps.setDouble(3, e.getStuSubCriteriaMark());

            status = ps.executeUpdate();

            if (status < 0) {
                ps = con.prepareStatement("delete from studentAssessment where stuAssessID=?");
                ps.setInt(1, e.getAssessID());

            } else {
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentPresentAssess(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentPresentAssess(matricNo, assessID, svID, stuAssessCompMark) values (?,?,?,?)");
            ps.setString(1, e.getMatricNo());
            ps.setInt(2, e.getAssessID());
            ps.setInt(3, e.getSvID());
            ps.setDouble(4, e.getStuAssessCompMark());

            status = ps.executeUpdate();

            if (status > 0) {
                ps = con.prepareStatement("select * from studentPresentAssess ORDER BY stuPresentAssessID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                }
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentPresentCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentPresentCriteriaMark(stuPresentAssessID, criteriaID, stuCriteriaMark) values (?,?,?)");
            ps.setInt(1, e.getStuAssessID());
            ps.setInt(2, e.getCriteriaID());
            ps.setDouble(3, e.getStuCriteriaMark());

            status = ps.executeUpdate();

            if (status < 0) {
                ps = con.prepareStatement("delete from studentPresentAssess where stuPresentAssessID=?");
                ps.setInt(1, e.getStuAssessID());
            } else {
                ps = con.prepareStatement("select * from studentPresentCriteriaMark ORDER BY stuPresentCriteriaID DESC LIMIT 1;");

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    e.setStuCriteriaID(rs.getInt("stuPresentCriteriaID"));
                }
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addStudentPresentSubCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into studentPresentSubCriteriaMark(stuPresentCriteriaID, subCriteriaID, stuSubCriteriaMark) values (?,?,?)");
            ps.setInt(1, e.getStuCriteriaID());
            ps.setInt(2, e.getSubCriteriaID());
            ps.setDouble(3, e.getStuSubCriteriaMark());

            status = ps.executeUpdate();

            if (status < 0) {
                ps = con.prepareStatement("delete from studentAssess where stuPresentAssessID=?");
                ps.setInt(1, e.getAssessID());

            } else {
            }
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int addEvaluation(String matricNo) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("insert into evaluation(matricNo, grade) values (?,?)");
            ps.setString(1, matricNo);
            ps.setString(2, "F");

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updatePlo(assessment a) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update plo set ploSelection=? where ploID=?");
            ps.setString(1, a.getPloSelection());
            ps.setInt(2, a.getPloID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateCloPlo(assessment a) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update cloplo set clo=?, ploID=?, loDesc=?, courseName=? where cloploID=?");
            ps.setString(1, a.getClo());
            ps.setInt(2, a.getPloID());
            ps.setString(3, a.getLoDesc());
            ps.setString(4, a.getCourseName());
            ps.setInt(5, a.getCloploID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateAssessComp(assessment a) {
        int status = 0;

        Date startDate = null, endDate = null;

        if (a.getAssessStartDate() != null && a.getAssessEndDate() != null) {
            startDate = new Date(a.getAssessStartDate().getTime());
            endDate = new Date(a.getAssessEndDate().getTime());
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update assessment set assessComponent=?, courseName=?, compPercentage=?, assessStartDate=?, assessEndDate=? where assessID=?");
            ps.setString(1, a.getAssessComponent());
            ps.setString(2, a.getCourseName());
            ps.setDouble(3, a.getCompPercentage());
            ps.setDate(4, startDate);
            ps.setDate(5, endDate);
            ps.setInt(6, a.getAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateAssessCriteria(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update assessmentCriteria set assessCriteria=?, criteriaPercentage=?, cloploID=? where criteriaID=?");
            ps.setString(1, a.getAssessCriteria());
            ps.setDouble(2, a.getCriteriaPercentage());
            ps.setInt(3, a.getCloploID());
            ps.setInt(4, a.getCriteriaID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateSubCriteria(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update subCriteria set subCriteria=? where subCriteriaID=?");
            ps.setString(1, a.getSubCriteria());
            ps.setInt(2, a.getSubCriteriaID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateGradingScale(assessment a) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update gradingScale set gradingScale=?, scaleDesc=? where scaleID=?");
            ps.setInt(1, a.getGradingScale());
            ps.setString(2, a.getScaleDesc());
            ps.setInt(3, a.getScaleID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentAssessment(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentAssessment set stuAssessCompMark=?, stuAssessValid=? where stuAssessID=?");
            ps.setDouble(1, e.getStuAssessCompMark());
            ps.setString(2, e.getStuAssessValid());
            ps.setInt(3, e.getStuAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStuPLOMarkByIDs(evaluation e) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("update stuPLOMark set stuPLOMark=? where stuAssessID=? and ploID=?");
            ps.setDouble(1, e.getStuPLOMark());
            ps.setInt(2, e.getStuAssessID());
            ps.setInt(3, e.getPloID());

            status = ps.executeUpdate();

        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStuPresentPLOMarkByIDs(evaluation e) {
        int status = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("update stuPresentPLOMark set stuPresentPLOMark=? where stuPresentAssessID=? and ploID=?");
            ps.setDouble(1, e.getStuPLOMark());
            ps.setInt(2, e.getStuAssessID());
            ps.setInt(3, e.getPloID());

            status = ps.executeUpdate();

        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStuAssessValid(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentAssessment set stuAssessValid=? where stuAssessID=?");
            ps.setString(1, e.getStuAssessValid());
            ps.setInt(2, e.getStuAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentCriteriaMark set stuCriteriaMark=? where stuCriteriaID=?");
            ps.setDouble(1, e.getStuCriteriaMark());
            ps.setInt(2, e.getStuCriteriaID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentSubCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentSubCriteriaMark set stuSubCriteriaMark=? where stuSubCriteriaID=?");
            ps.setInt(1, e.getStuSubCriteriaMark());
            ps.setInt(2, e.getStuSubCriteriaID());

            status = ps.executeUpdate();

        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentPresentAssess(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentPresentAssess set stuAssessCompMark=?,stuPresentAssessValid=? where stuPresentAssessID=?");
            ps.setDouble(1, e.getStuAssessCompMark());
            ps.setString(2, e.getStuAssessValid());
            ps.setInt(3, e.getStuAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStuPresentAssessValid(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentPresentAssess set stuPresentAssessValid=? where stuPresentAssessID=?");
            ps.setString(1, e.getStuAssessValid());
            ps.setInt(2, e.getStuAssessID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentPresentCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentPresentCriteriaMark set stuCriteriaMark=? where stuPresentCriteriaID=?");
            ps.setDouble(1, e.getStuCriteriaMark());
            ps.setInt(2, e.getStuCriteriaID());

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateStudentPresentSubCriteriaMark(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update studentPresentSubCriteriaMark set stuSubCriteriaMark=? where stuPresentSubCriteriaID=?");
            ps.setInt(1, e.getStuSubCriteriaMark());
            ps.setInt(2, e.getStuSubCriteriaID());

            status = ps.executeUpdate();

        } catch (SQLException ex) {
        }
        return status;
    }

    public static int updateEvaluation(evaluation e) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("update evaluation set totalMark=?, grade=? where matricNo=?");
            ps.setDouble(1, e.getTotalMark());
            ps.setString(2, e.getGrade());
            ps.setString(3, e.getMatricNo());

            status = ps.executeUpdate();

        } catch (SQLException ex) {
        }
        return status;
    }

    public static assessment getPloByID(int ploID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from plo where ploID=? GROUP BY plo");
            ps.setInt(1, ploID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setPloID(rs.getInt("ploID"));
                a.setPlo(rs.getString("plo"));
                a.setPloDesc(rs.getString("ploDesc"));
                a.setPloSelection(rs.getString("ploSelection"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }
    
    public static assessment getPloByIDCrsName(int ploID, String courseName) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM plo INNER JOIN cloplo USING (ploID) WHERE ploID=? AND courseName=?");
            ps.setInt(1, ploID);
            ps.setString(2, courseName);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setPloID(rs.getInt("ploID"));
                a.setPlo(rs.getString("plo"));
                a.setPloDesc(rs.getString("ploDesc"));
                a.setPloSelection(rs.getString("ploSelection"));
                a.setClo(rs.getString("clo"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getCloPloByID(int cloploID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from cloplo where cloploID=?");
            ps.setInt(1, cloploID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setCloploID(rs.getInt("cloploID"));
                a.setClo(rs.getString("clo"));
                a.setPloID(rs.getInt("ploID"));
                a.setLoDesc(rs.getString("loDesc"));
                a.setCourseName(rs.getString("courseName"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getAssessCompByID(int assessID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessment where assessID=?");
            ps.setInt(1, assessID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setAssessID(rs.getInt("assessID"));
                a.setAssessComponent(rs.getString("assessComponent"));
                a.setCompPercentage(rs.getDouble("compPercentage"));
                a.setCourseName(rs.getString("courseName"));
                a.setAssessStartDate(rs.getDate("assessStartDate"));
                a.setAssessEndDate(rs.getDate("assessEndDate"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getAssessCriteriaByID(int criteriaID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessmentCriteria INNER JOIN cloplo USING (cloploID) INNER JOIN plo USING (ploID) where criteriaID=?");
            ps.setInt(1, criteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setCriteriaID(rs.getInt("criteriaID"));
                a.setAssessCriteria(rs.getString("assessCriteria"));
                a.setCloploID(rs.getInt("cloploID"));
                a.setPloID(rs.getInt("ploID"));
                a.setCriteriaPercentage(rs.getDouble("criteriaPercentage"));
                a.setAssessID(rs.getInt("assessID"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getSubCriteriaByID(int subCriteriaID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from subCriteria where subCriteriaID=?");
            ps.setInt(1, subCriteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setCriteriaID(rs.getInt("criteriaID"));
                a.setSubCriteriaID(rs.getInt("subCriteriaID"));
                a.setSubCriteria(rs.getString("subCriteria"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getGradingScaleByCompare(int subCriteriaID, int mFrequency) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM assessment INNER JOIN assessmentCriteria USING (assessID) INNER JOIN subCriteria USING (criteriaID) INNER JOIN gradingScale USING (subCriteriaID) WHERE subCriteriaID=? AND scaleDesc LIKE ?");
            ps.setInt(1, subCriteriaID);
            ps.setString(2, "%" + mFrequency + "%");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setScaleID(rs.getInt("scaleID"));
                a.setGradingScale(rs.getInt("gradingScale"));
                a.setScaleDesc(rs.getString("scaleDesc"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static evaluation getStuAssessmentByMatricNoID(String matricNo, int assessID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentAssessment where matricNo=? and assessID=?");
            ps.setString(1, matricNo);
            ps.setInt(2, assessID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(assessID);
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static evaluation getStuPresentAssessByMatricNoID(String matricNo, int svID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentPresentAssess where matricNo=? and svID=?");
            ps.setString(1, matricNo);
            ps.setInt(2, svID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static evaluation getStuAssessmentByID(int stuAssessID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentAssessment where stuAssessID=?");
            ps.setInt(1, stuAssessID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(rs.getInt("assessID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static evaluation getStuCriteriaMarkByIDs(int stuAssessID, int criteriaID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentCriteriaMark where stuAssessID=? and criteriaID=?");
            ps.setInt(1, stuAssessID);
            ps.setInt(2, criteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setStuCriteriaID(rs.getInt("stuCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static assessment getStuSubCriteriaMarkByIDs(int stuCriteriaID, int subCriteriaID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentSubCriteriaMark INNER JOIN subCriteria USING (subCriteriaID) INNER JOIN gradingScale USING (subCriteriaID) WHERE stuSubCriteriaMark = gradingScale AND stuCriteriaID=? and subCriteriaID=?");
            ps.setInt(1, stuCriteriaID);
            ps.setInt(2, subCriteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setGradingScale(rs.getInt("gradingScale"));
                a.setScaleDesc(rs.getString("scaleDesc"));
                a.setScaleID(rs.getInt("stuSubCriteriaID"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static evaluation getStuPresentAssessByID(int stuPresentAssessID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentPresentAssess where stuPresentAssessID=?");
            ps.setInt(1, stuPresentAssessID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(rs.getInt("assessID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static evaluation getStuPresentCriteriaMarkByIDs(int stuPresentAssessID, int criteriaID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentPresentCriteriaMark where stuPresentAssessID=? and criteriaID=?");
            ps.setInt(1, stuPresentAssessID);
            ps.setInt(2, criteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setStuCriteriaID(rs.getInt("stuPresentCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static assessment getStuPresentSubCriteriaMarkByIDs(int stuPresentCriteriaID, int subCriteriaID) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentSubCriteriaMark INNER JOIN subCriteria USING (subCriteriaID) INNER JOIN gradingScale USING (subCriteriaID) WHERE stuSubCriteriaMark = gradingScale AND stuPresentCriteriaID=? and subCriteriaID=?");
            ps.setInt(1, stuPresentCriteriaID);
            ps.setInt(2, subCriteriaID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                a.setGradingScale(rs.getInt("gradingScale"));
                a.setScaleDesc(rs.getString("scaleDesc"));
                a.setScaleID(rs.getInt("stuPresentSubCriteriaID"));
            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static List<assessment> getAllPlo() {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from plo");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setPloID(rs.getInt("ploID"));
                a.setPlo(rs.getString("plo"));
                a.setPloDesc(rs.getString("ploDesc"));
                a.setPloSelection(rs.getString("ploSelection"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<assessment> getSelectedPlo() {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from plo where ploSelection='Selected'");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setPloID(rs.getInt("ploID"));
                a.setPlo(rs.getString("plo"));
                a.setPloDesc(rs.getString("ploDesc"));
                a.setPloSelection(rs.getString("ploSelection"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<assessment> getCloPloByCourseName(String courseName) {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from cloplo where courseName=?");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setCloploID(rs.getInt("cloploID"));
                a.setClo(rs.getString("clo"));
                a.setPloID(rs.getInt("ploID"));
                a.setLoDesc(rs.getString("loDesc"));
                a.setCourseName(courseName);

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static assessment getPresentCompByCourseName(String courseName) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessment where courseName=? and assessComponent='Presentation'");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                a.setAssessID(rs.getInt("assessID"));
                a.setAssessComponent(rs.getString("assessComponent"));
                a.setCompPercentage(rs.getDouble("compPercentage"));
                a.setCourseName(courseName);
                a.setAssessStartDate(rs.getDate("assessStartDate"));
                a.setAssessEndDate(rs.getDate("assessEndDate"));

            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static assessment getAssessCompByCourseComp(String courseName, String assessComponent) {
        assessment a = new assessment();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessment where courseName=? and assessComponent=?");
            ps.setString(1, courseName);
            ps.setString(2, assessComponent);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                a.setAssessID(rs.getInt("assessID"));
                a.setAssessComponent(rs.getString("assessComponent"));
                a.setCompPercentage(rs.getDouble("compPercentage"));
                a.setCourseName(courseName);
                a.setAssessStartDate(rs.getDate("assessStartDate"));
                a.setAssessEndDate(rs.getDate("assessEndDate"));

            }
        } catch (SQLException ex) {
        }
        return a;
    }

    public static List<assessment> getAssessCompByCourseName(String courseName) {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessment where courseName=?");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setAssessID(rs.getInt("assessID"));
                a.setAssessComponent(rs.getString("assessComponent"));
                a.setCompPercentage(rs.getDouble("compPercentage"));
                a.setCourseName(courseName);
                a.setAssessStartDate(rs.getDate("assessStartDate"));
                a.setAssessEndDate(rs.getDate("assessEndDate"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<assessment> getCriteriaByAssessID(int assessID) {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from assessmentCriteria INNER JOIN assessment USING (assessID) INNER JOIN cloplo USING (cloploID) INNER JOIN plo USING (ploID) where assessID=?");
            ps.setInt(1, assessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setCriteriaID(rs.getInt("criteriaID"));
                a.setAssessCriteria(rs.getString("assessCriteria"));
                a.setCloploID(rs.getInt("cloploID"));
                a.setCriteriaPercentage(rs.getDouble("criteriaPercentage"));
                a.setAssessID(assessID);
                a.setPlo(rs.getString("plo"));
                a.setPloDesc(rs.getString("ploDesc"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<assessment> getSubCriteriaByCriteriaID(int criteriaID) {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from subCriteria where criteriaID=?");
            ps.setInt(1, criteriaID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setCriteriaID(criteriaID);
                a.setSubCriteriaID(rs.getInt("subCriteriaID"));
                a.setSubCriteria(rs.getString("subCriteria"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<assessment> getGradingScaleBySubCriID(int subCriteriaID) {
        List<assessment> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from gradingScale where subCriteriaID=?");
            ps.setInt(1, subCriteriaID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                assessment a = new assessment();
                a.setCriteriaID(subCriteriaID);
                a.setScaleID(rs.getInt("scaleID"));
                a.setGradingScale(rs.getInt("gradingScale"));
                a.setScaleDesc(rs.getString("scaleDesc"));

                list.add(a);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPresentAssessByMatricNoAssessID(String matricNo, int assessID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentPresentAssess where matricNo=? and assessID=?");
            ps.setString(1, matricNo);
            ps.setInt(2, assessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static evaluation getStuPresentCriteriaMarkByStuAssessID(int criteriaID, int stuPresentAssessID) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentPresentCriteriaMark where criteriaID=? and stuPresentAssessID=?");
            ps.setInt(1, criteriaID);
            ps.setInt(2, stuPresentAssessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setStuCriteriaID(rs.getInt("stuPresentCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }
    
    public static List<evaluation> getStuCriteriaMarkByStuAssessID(int stuAssessID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from studentCriteriaMark where stuAssessID=?");
            ps.setInt(1, stuAssessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setStuCriteriaID(rs.getInt("stuCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuAssessByAssessID(int assessID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentAssessment WHERE assessID=? GROUP BY matricNo");
            ps.setInt(1, assessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuAssessByValidStatus(int assessID, String validStatus) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentAssessment WHERE assessID=? and stuAssessValid=? GROUP BY matricNo");
            ps.setInt(1, assessID);
            ps.setString(2, validStatus);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<evaluation> getStuAssessByComp(String assessComp, String courseName) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentAssessment INNER JOIN assessment USING (assessID) WHERE assessComponent=? and courseName=?");
            ps.setString(1, assessComp);
            ps.setString(2, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(rs.getInt("assessID"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPresentAssessByAssessID(int assessID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentAssess WHERE assessID=?");
            ps.setInt(1, assessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setSvID(rs.getInt("svID"));
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPresentAssessByValidStatus(int assessID, String validStatus) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentAssess WHERE assessID=? and stuPresentAssessValid=?");
            ps.setInt(1, assessID);
            ps.setString(2, validStatus);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setSvID(rs.getInt("svID"));
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }
    
    public static List<evaluation> getStuPresentAssessByComp(String assessComp, String courseName) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentAssess INNER JOIN assessment USING (assessID) WHERE assessComponent=? and courseName=?");
            ps.setString(1, assessComp);
            ps.setString(2, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setSvID(rs.getInt("svID"));
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(rs.getInt("assessID"));
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> searchStuSubCriMark(int assessID, String mark) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentAssessment INNER JOIN studentCriteriaMark USING (stuAssessID) INNER JOIN studentSubCriteriaMark USING (stuCriteriaID) WHERE assessID=? AND stuSubCriteriaMark <= ?");
            ps.setInt(1, assessID);
            ps.setString(2, mark);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessID(rs.getInt("stuAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> searchStuPresentSubCriMark(int assessID, String mark) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentAssess INNER JOIN studentPresentCriteriaMark USING (stuPresentAssessID) INNER JOIN studentPresentSubCriteriaMark USING (stuPresentCriteriaID) WHERE assessID=? AND stuSubCriteriaMark LIKE ?");
            ps.setInt(1, assessID);
            ps.setString(2, "%" + mark + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setSvID(rs.getInt("svID"));
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(assessID);
                e.setStuAssessCompMark(rs.getDouble("stuAssessCompMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuCriteriaMarkByMatricNo(String MatricNo, int assessID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentCriteriaMark INNER JOIN studentAssessment USING (stuAssessID) WHERE matricNo=? AND assessID=?");
            ps.setString(1, MatricNo);
            ps.setInt(2, assessID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuCriteriaID(rs.getInt("stuCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPresentCriMarkByMatricNo(String MatricNo, int assessID, int svID) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM studentPresentCriteriaMark INNER JOIN studentPresentAssess USING (stuPresentAssessID) WHERE matricNo=? AND assessID=? AND svID=?");
            ps.setString(1, MatricNo);
            ps.setInt(2, assessID);
            ps.setInt(3, svID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setSvID(rs.getInt("svID"));
                e.setStuCriteriaID(rs.getInt("stuPresentCriteriaID"));
                e.setStuCriteriaMark(rs.getDouble("stuCriteriaMark"));
                e.setCriteriaID(rs.getInt("criteriaID"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static evaluation getStuPresentAssessAVGByMatricNoID(String matricNo) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, ROUND(AVG(stuAssessCompMark),2)AS avgMark FROM studentPresentAssess WHERE matricNo=? AND stuPresentAssessValid='Valid'");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuAssessID(rs.getInt("stuPresentAssessID"));
                e.setAssessID(rs.getInt("assessID"));
                e.setStuAssessCompMark(rs.getDouble("avgMark"));
                e.setStuAssessValid(rs.getString("stuPresentAssessValid"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static evaluation getEvaluationByMatricNo(String matricNo) {
        evaluation e = new evaluation();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM evaluation WHERE matricNo=?");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                e.setMatricNo(rs.getString("matricNo"));
                e.setEvaluateID(rs.getInt("evaluateID"));
                e.setTotalMark(rs.getDouble("totalMark"));
                e.setGrade(rs.getString("grade"));
            }
        } catch (SQLException ex) {
        }
        return e;
    }

    public static List<evaluation> getEvaluationListByCrsName(String courseName) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM evaluation INNER JOIN student USING (matricNo) INNER JOIN fypcourse USING (courseCode) WHERE courseName=? ORDER BY matricNo");
            ps.setString(1, courseName);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setEvaluateID(rs.getInt("evaluateID"));
                e.setTotalMark(rs.getDouble("totalMark"));
                e.setGrade(rs.getString("grade"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> searchEvaluateListByGrade(String grade, String courseName) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM evaluation INNER JOIN student USING (matricNo) INNER JOIN fypcourse USING (courseCode) WHERE courseName=? AND grade LIKE ? ORDER BY matricNo");
            ps.setString(1, courseName);
            ps.setString(2, "%" + grade + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setEvaluateID(rs.getInt("evaluateID"));
                e.setTotalMark(rs.getDouble("totalMark"));
                e.setGrade(rs.getString("grade"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPLOMarkByMatricNo(String matricNo) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *, SUM(stuPLOMark) AS sumPLOMark FROM stuPLOMark INNER JOIN studentAssessment USING (stuAssessID) WHERE matricNo=? GROUP BY ploID;");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuPLOMark(rs.getDouble("sumPLOMark"));
                e.setPloID(rs.getInt("ploID"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static List<evaluation> getStuPresentPLOMarkByMatricNo(String matricNo) {
        List<evaluation> list = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *,ROUND(AVG(stuPresentPLOMark),2) AS sumPLOMark FROM `stuPresentPLOMark` INNER JOIN studentPresentAssess USING (stuPresentAssessID) WHERE matricNo = ? GROUP BY ploID");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                evaluation e = new evaluation();
                e.setMatricNo(rs.getString("matricNo"));
                e.setStuPLOMark(rs.getDouble("sumPLOMark"));
                e.setPloID(rs.getInt("ploID"));

                list.add(e);
            }
        } catch (SQLException ex) {
        }
        return list;
    }

    public static double getStuAssessCompMark(String assessComponent, String matricNo) {
        double stuAssessMark = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select SUM(stuAssessCompMark) AS stuAssessMark from studentAssessment left join assessment using (assessID) where matricNo=? and assessComponent LIKE ?");
            ps.setString(1, matricNo);
            ps.setString(2, "%" + assessComponent + "%");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stuAssessMark = rs.getDouble("stuAssessMark");
            }
        } catch (SQLException ex) {
        }
        return stuAssessMark;
    }

    public static double getStuAssessMark(String matricNo) {
        double stuAssessMark = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("select SUM(stuAssessCompMark) AS stuAssessMark from studentAssessment where matricNo=?");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stuAssessMark = rs.getDouble("stuAssessMark");
            }
        } catch (SQLException ex) {
        }
        return stuAssessMark;
    }

    public static double getAssessCompTotalMark(String assessComponent, String courseName) {
        double totalMark = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT SUM(compPercentage) AS totalMark FROM assessment WHERE assessComponent LIKE ? AND courseName=?");
            ps.setString(1, "%" + assessComponent + "%");
            ps.setString(2, courseName);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalMark = rs.getDouble("totalMark");
            }
        } catch (SQLException ex) {
        }
        return totalMark;
    }

    public static double getEvaluateTotalMarkByMatricNo(String matricNo) {
        double totalMark = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT SUM(compPercentage) AS totalMark FROM assessment WHERE assessComponent LIKE ? AND courseName=?");
            ps.setString(1, matricNo);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalMark = rs.getDouble("totalMark");
            }
        } catch (SQLException ex) {
        }
        return totalMark;
    }

    public static double getTotalPloMarkByPlo(String courseName, int PloID) {
        double totalPloMark = 0;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT *,SUM(criteriaPercentage) AS totalPloMark FROM assessment AS A INNER JOIN assessmentCriteria USING (assessID) INNER JOIN cloplo USING (cloploID) INNER JOIN plo USING (ploID) WHERE A.courseName=? AND ploID=?");
            ps.setString(1, courseName);
            ps.setInt(2, PloID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalPloMark = rs.getDouble("totalPloMark");
            }
        } catch (SQLException ex) {
        }
        return totalPloMark;
    }

    public static int deleteCloPlo(int cloploID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from cloplo where cloploID=?");
            ps.setInt(1, cloploID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int deleteAssessComp(int assessID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from assessment where assessID=?");
            ps.setInt(1, assessID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int deleteAssessCriteria(int criteriaID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from assessmentCriteria where criteriaID=?");
            ps.setInt(1, criteriaID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int deleteSubCriteria(int subCriteriaID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from subCriteria where subCriteriaID=?");
            ps.setInt(1, subCriteriaID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }

    public static int deleteGradingScale(int scaleID) {
        int status = 0;
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("delete from gradingScale where scaleID=?");
            ps.setInt(1, scaleID);

            status = ps.executeUpdate();
        } catch (SQLException ex) {
        }
        return status;
    }
}
