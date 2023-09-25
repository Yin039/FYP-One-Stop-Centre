package com.model;

/**
 *
 * @author TEOH YI YIN
 */
public class evaluation {

    private int evaluateID, stuAssessID, assessID, stuCriteriaID, criteriaID, stuSubCriteriaID, subCriteriaID, svID, stuPLOMarkID, ploID;
    private double totalMark, stuAssessCompMark, stuCriteriaMark, stuPLOMark;
    private int stuSubCriteriaMark;
    private String grade, matricNo, stuAssessValid;

    public int getEvaluateID() {
        return evaluateID;
    }

    public void setEvaluateID(int evaluateID) {
        this.evaluateID = evaluateID;
    }

    public int getStuAssessID() {
        return stuAssessID;
    }

    public int getAssessID() {
        return assessID;
    }

    public void setAssessID(int assessID) {
        this.assessID = assessID;
    }

    public void setStuAssessID(int stuAssessID) {
        this.stuAssessID = stuAssessID;
    }

    public int getStuCriteriaID() {
        return stuCriteriaID;
    }

    public void setStuCriteriaID(int stuCriteriaID) {
        this.stuCriteriaID = stuCriteriaID;
    }

    public int getCriteriaID() {
        return criteriaID;
    }

    public void setCriteriaID(int criteriaID) {
        this.criteriaID = criteriaID;
    }

    public int getStuSubCriteriaID() {
        return stuSubCriteriaID;
    }

    public void setStuSubCriteriaID(int stuSubCriteriaID) {
        this.stuSubCriteriaID = stuSubCriteriaID;
    }

    public int getSubCriteriaID() {
        return subCriteriaID;
    }

    public void setSubCriteriaID(int subCriteriaID) {
        this.subCriteriaID = subCriteriaID;
    }

    public int getSvID() {
        return svID;
    }

    public void setSvID(int svID) {
        this.svID = svID;
    }

    public double getTotalMark() {
        return totalMark;
    }

    public void setTotalMark(double totalMark) {
        this.totalMark = totalMark;
    }

    public double getStuAssessCompMark() {
        return stuAssessCompMark;
    }

    public void setStuAssessCompMark(double stuAssessCompMark) {
        this.stuAssessCompMark = stuAssessCompMark;
    }

    public double getStuCriteriaMark() {
        return stuCriteriaMark;
    }

    public void setStuCriteriaMark(double stuCriteriaMark) {
        this.stuCriteriaMark = stuCriteriaMark;
    }

    public int getStuSubCriteriaMark() {
        return stuSubCriteriaMark;
    }

    public void setStuSubCriteriaMark(int stuSubCriteriaMark) {
        this.stuSubCriteriaMark = stuSubCriteriaMark;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getStuAssessValid() {
        return stuAssessValid;
    }

    public void setStuAssessValid(String stuAssessValid) {
        this.stuAssessValid = stuAssessValid;
    }

    public int getStuPLOMarkID() {
        return stuPLOMarkID;
    }

    public void setStuPLOMarkID(int stuPLOMarkID) {
        this.stuPLOMarkID = stuPLOMarkID;
    }

    public int getPloID() {
        return ploID;
    }

    public void setPloID(int ploID) {
        this.ploID = ploID;
    }

    public double getStuPLOMark() {
        return stuPLOMark;
    }

    public void setStuPLOMark(double stuPLOMark) {
        this.stuPLOMark = stuPLOMark;
    }

    public String checkAssessValidation(double stuMark, double compMark) {
        String stuAssessValidation = null;

        double percentage = (stuMark / compMark) * 100;
        if (percentage > 50) {
            stuAssessValidation = "Valid";
        } else {
            stuAssessValidation = "Invalid";
        }

        return stuAssessValidation;
    }

    public static String grading(double totalMark) {
        String grade = null;

        if (totalMark >= 80) {
            grade = "A";
        } else if (totalMark < 80 && totalMark >= 75) {
            grade = "A-";
        } else if (totalMark < 75 && totalMark >= 70) {
            grade = "B+";
        } else if (totalMark < 70 && totalMark >= 65) {
            grade = "B";
        } else if (totalMark < 65 && totalMark >= 60) {
            grade = "B-";
        } else if (totalMark < 60 && totalMark >= 55) {
            grade = "C+";
        } else if (totalMark < 65 && totalMark >= 50) {
            grade = "C";
        } else if (totalMark < 50 && totalMark >= 45) {
            grade = "C-";
        } else if (totalMark < 45 && totalMark >= 40) {
            grade = "D";
        } else {
            grade = "F";
        }

        return grade;
    }
}
