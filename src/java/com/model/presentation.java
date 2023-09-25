package com.model;

import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 *
 * @author TEOH YI YIN
 */
public class presentation {

    private int presentID, panelID, svID, locateID, presentAttendID;
    private Date presentDate;
    private Time presentStartTime, presentEndTime;
    private String presentLink, presentLocate, presentRemark, presentLocateValid, presentSetUp, panelLeader;
    private int panelGpNo, stuNum;
    private String matricNo, attendStatus;

    public int getPresentID() {
        return presentID;
    }

    public void setPresentID(int presentID) {
        this.presentID = presentID;
    }

    public int getPanelID() {
        return panelID;
    }

    public void setPanelID(int panelID) {
        this.panelID = panelID;
    }

    public int getSvID() {
        return svID;
    }

    public void setSvID(int svID) {
        this.svID = svID;
    }

    public int getLocateID() {
        return locateID;
    }

    public void setLocateID(int locateID) {
        this.locateID = locateID;
    }

    public int getPresentAttendID() {
        return presentAttendID;
    }

    public void setPresentAttendID(int presentAttendID) {
        this.presentAttendID = presentAttendID;
    }
    
    public Date getPresentDate() {
        return presentDate;
    }

    public void setPresentDate(Date presentDate) {
        this.presentDate = presentDate;
    }

    public Time getPresentStartTime() {
        return presentStartTime;
    }

    public void setPresentStartTime(Time presentStartTime) {
        this.presentStartTime = presentStartTime;
    }

    public Time getPresentEndTime() {
        return presentEndTime;
    }

    public void setPresentEndTime(Time presentEndTime) {
        this.presentEndTime = presentEndTime;
    }

    public String getPresentLink() {
        return presentLink;
    }

    public void setPresentLink(String presentLink) {
        this.presentLink = presentLink;
    }

    public String getPresentLocate() {
        return presentLocate;
    }

    public void setPresentLocate(String presentLocate) {
        this.presentLocate = presentLocate;
    }

    public String getPresentRemark() {
        return presentRemark;
    }

    public void setPresentRemark(String presentRemark) {
        this.presentRemark = presentRemark;
    }

    public String getPresentLocateValid() {
        return presentLocateValid;
    }

    public void setPresentLocateValid(String presentLocateValid) {
        this.presentLocateValid = presentLocateValid;
    }

    public String getPresentSetUp() {
        return presentSetUp;
    }

    public void setPresentSetUp(String presentSetUp) {
        this.presentSetUp = presentSetUp;
    }

    public String getPanelLeader() {
        return panelLeader;
    }

    public void setPanelLeader(String panelLeader) {
        this.panelLeader = panelLeader;
    }

    public int getPanelGpNo() {
        return panelGpNo;
    }

    public void setPanelGpNo(int panelGpNo) {
        this.panelGpNo = panelGpNo;
    }

    public int getStuNum() {
        return stuNum;
    }

    public void setStuNum(int stuNum) {
        this.stuNum = stuNum;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getAttendStatus() {
        return attendStatus;
    }

    public void setAttendStatus(String attendStatus) {
        this.attendStatus = attendStatus;
    }

    public static List<List<presentation>> assignTeams(List<presentation> svGroup, int numGroups) {
        // Shuffle the team members randomly
        Collections.shuffle(svGroup);

        List<List<presentation>> groups = new ArrayList<>();

        for (int index = 0; index < numGroups; index++) {
            List<presentation> group = new ArrayList<>();
            
            for (int i = index; i < svGroup.size(); i += numGroups) {
                group.add(svGroup.get(i));
            }
            groups.add(group);
        }

        return groups;
    }
}
