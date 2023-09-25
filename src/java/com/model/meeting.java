package com.model;

import java.sql.Time;
import java.util.Date;

/**
 *
 * @author TEOH YI YIN
 */
public class meeting {
    private int meetID, svID;
    private Date meetDate;
    private Time meetTime;
    private String meetLocate, meetMode;

    public int getMeetID() {
        return meetID;
    }

    public void setMeetID(int meetID) {
        this.meetID = meetID;
    }

    public int getSvID() {
        return svID;
    }

    public void setSvID(int svID) {
        this.svID = svID;
    }

    public Date getMeetDate() {
        return meetDate;
    }

    public void setMeetDate(Date meetDate) {
        this.meetDate = meetDate;
    }

    public Time getMeetTime() {
        return meetTime;
    }

    public void setMeetTime(Time meetTime) {
        this.meetTime = meetTime;
    }

    public String getMeetLocate() {
        return meetLocate;
    }

    public void setMeetLocate(String meetLocate) {
        this.meetLocate = meetLocate;
    }

    public String getMeetMode() {
        return meetMode;
    }

    public void setMeetMode(String meetMode) {
        this.meetMode = meetMode;
    }    
}
