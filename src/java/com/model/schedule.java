package com.model;

import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author TEOH YI YIN
 */
public class schedule {
    private int scheduleID, materialID, detailID;
    private String courseCode, oldCode;
    private String courseName;
    private int week;
    private Date date;
    private String activity, action, materialName, materialLink, materialType;
    private byte[] materialDoc;

    public int getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public int getMaterialID() {
        return materialID;
    }

    public void setMaterialID(int materialID) {
        this.materialID = materialID;
    }

    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getOldCode() {
        return oldCode;
    }

    public void setOldCode(String oldCode) {
        this.oldCode = oldCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public int getWeek() {
        return week;
    }

    public void setWeek(int week) {
        this.week = week;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }
    
    public String getMaterialLink() {
        return materialLink;
    }

    public void setMaterialLink(String materialLink) {
        this.materialLink = materialLink;
    }

    public String getMaterialType() {
        return materialType;
    }

    public void setMaterialType(String materialType) {
        this.materialType = materialType;
    }

    public byte[] getMaterialDoc() {
        return materialDoc;
    }

    public void setMaterialDoc(byte[] materialDoc) {
        this.materialDoc = materialDoc;
    }

    public static boolean isValidLink(String link) {
        String regex = "^((http|https):\\/\\/.)[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(link);
        return matcher.matches();
    }
}
