package com.model;

import java.sql.Timestamp;

/**
 *
 * @author TEOH YI YIN
 */
public class logbook {
    private int logID, meetID;
    private String matricNo;
    private String projectAct, projectProb, projectSolveSuggest, logValidate;
    private Timestamp Timestamp;

    public int getLogID() {
        return logID;
    }

    public void setLogID(int logID) {
        this.logID = logID;
    }

    public int getMeetID() {
        return meetID;
    }

    public void setMeetID(int meetID) {
        this.meetID = meetID;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public Timestamp getTimestamp() {
        return Timestamp;
    }

    public void setTimestamp(Timestamp Timestamp) {
        this.Timestamp = Timestamp;
    }

    public String getProjectAct() {
        return projectAct;
    }

    public void setProjectAct(String projectAct) {
        this.projectAct = projectAct;
    }

    public String getProjectProb() {
        return projectProb;
    }

    public void setProjectProb(String projectProb) {
        this.projectProb = projectProb;
    }

    public String getProjectSolveSuggest() {
        return projectSolveSuggest;
    }

    public void setProjectSolveSuggest(String projectSolveSuggest) {
        this.projectSolveSuggest = projectSolveSuggest;
    }

    public String getLogValidate() {
        return logValidate;
    }

    public void setLogValidate(String logValidate) {
        this.logValidate = logValidate;
    }
    
    
}
