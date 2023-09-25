package com.model;

import com.dao.assessmentDao;
import java.util.Date;
import java.util.List;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;

/**
 *
 * @author TEOH YI YIN
 */
public class assessment {

    private int assessID, criteriaID, subCriteriaID, cloploID, ploID, scaleID;
    private String assessComponent, courseName, assessCriteria, subCriteria, clo, loDesc, plo, ploDesc, ploSelection, scaleDesc;
    private double compPercentage, criteriaPercentage;
    private int gradingScale;
    private Date assessStartDate, assessEndDate;

    public int getAssessID() {
        return assessID;
    }

    public void setAssessID(int assessID) {
        this.assessID = assessID;
    }

    public int getCriteriaID() {
        return criteriaID;
    }

    public void setCriteriaID(int criteriaID) {
        this.criteriaID = criteriaID;
    }

    public int getSubCriteriaID() {
        return subCriteriaID;
    }

    public void setSubCriteriaID(int subCriteriaID) {
        this.subCriteriaID = subCriteriaID;
    }

    public int getCloploID() {
        return cloploID;
    }

    public void setCloploID(int cloploID) {
        this.cloploID = cloploID;
    }

    public int getPloID() {
        return ploID;
    }

    public void setPloID(int ploID) {
        this.ploID = ploID;
    }

    public int getScaleID() {
        return scaleID;
    }

    public void setScaleID(int scaleID) {
        this.scaleID = scaleID;
    }

    public String getAssessComponent() {
        return assessComponent;
    }

    public void setAssessComponent(String assessComponent) {
        this.assessComponent = assessComponent;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getAssessCriteria() {
        return assessCriteria;
    }

    public void setAssessCriteria(String assessCriteria) {
        this.assessCriteria = assessCriteria;
    }

    public String getSubCriteria() {
        return subCriteria;
    }

    public void setSubCriteria(String subCriteria) {
        this.subCriteria = subCriteria;
    }

    public String getClo() {
        return clo;
    }

    public void setClo(String clo) {
        this.clo = clo;
    }

    public String getLoDesc() {
        return loDesc;
    }

    public void setLoDesc(String loDesc) {
        this.loDesc = loDesc;
    }

    public String getPlo() {
        return plo;
    }

    public void setPlo(String plo) {
        this.plo = plo;
    }

    public String getPloDesc() {
        return ploDesc;
    }

    public void setPloDesc(String ploDesc) {
        this.ploDesc = ploDesc;
    }

    public String getPloSelection() {
        return ploSelection;
    }

    public void setPloSelection(String ploSelection) {
        this.ploSelection = ploSelection;
    }

    public String getScaleDesc() {
        return scaleDesc;
    }

    public void setScaleDesc(String scaleDesc) {
        this.scaleDesc = scaleDesc;
    }

    public double getCompPercentage() {
        return compPercentage;
    }

    public void setCompPercentage(double compPercentage) {
        this.compPercentage = compPercentage;
    }

    public double getCriteriaPercentage() {
        return criteriaPercentage;
    }

    public void setCriteriaPercentage(double criteriaPercentage) {
        this.criteriaPercentage = criteriaPercentage;
    }

    public int getGradingScale() {
        return gradingScale;
    }

    public void setGradingScale(int gradingScale) {
        this.gradingScale = gradingScale;
    }

    public Date getAssessStartDate() {
        return assessStartDate;
    }

    public void setAssessStartDate(Date assessStartDate) {
        this.assessStartDate = assessStartDate;
    }

    public Date getAssessEndDate() {
        return assessEndDate;
    }

    public void setAssessEndDate(Date assessEndDate) {
        this.assessEndDate = assessEndDate;
    }

    public static String colorCode(String plo) {
        String colorCode = null;
        int i = 0;
        String[] code = new String[]{"#fcdcf1", "#efdcfc", "#F9D5D8", "#fceddc", "#fcfadc", "#eefcdc", "#dcfce0", "#dcfcf7", "#dcedfc", "#dddcfc", "#fce7dc", "#fce1dc"};

        List<assessment> ploList = assessmentDao.getAllPlo();

        for (assessment p : ploList) {

            if (p.getPlo().equals(plo)) {
                colorCode = code[i];
            }
            i++;
        }
        return colorCode;
    }

    public static void writeHeader(XSSFSheet sheet, int count, String plo, String ploDesc, double totalPLOMark) {
        //First Row
        Row row1 = sheet.createRow(0);

        Cell row1Cell = row1.createCell(0);
        row1Cell.setCellValue("PENILAIAN" + count);

        row1Cell = row1.createCell(1);
        row1Cell.setCellValue(ploDesc.toUpperCase());

        //Second Row
        Row row2 = sheet.createRow(1);

        Cell row2Cell = row2.createCell(0);
        row2Cell.setCellValue(plo);

        //Thrid Row - total mark of that PLO
        Row row3 = sheet.createRow(2);

        Cell row3Cell = row3.createCell(0);
        row3Cell.setCellValue(totalPLOMark);

        //Forth Row - Header
        Row row4 = sheet.createRow(3);

        Cell row4Cell = row4.createCell(0);
        row4Cell.setCellValue("BIL");

        row4Cell = row4.createCell(1);
        row4Cell.setCellValue("MATRIK");

        row4Cell = row4.createCell(2);
        row4Cell.setCellValue("NAMA PELAJAR");

        row4Cell = row4.createCell(3);
        row4Cell.setCellValue("MARKAH");
    }

    public static void writeDataLines(int rowCount, int stuCount, String matricNo, String stuName, double mark, XSSFSheet sheet) {
        Row row = sheet.createRow(rowCount);

        Cell cell = row.createCell(0);
        cell.setCellValue(stuCount);

        cell = row.createCell(1);
        cell.setCellValue(matricNo);

        cell = row.createCell(2);
        cell.setCellValue(stuName);

        cell = row.createCell(3);
        cell.setCellValue(mark);
    }
}
