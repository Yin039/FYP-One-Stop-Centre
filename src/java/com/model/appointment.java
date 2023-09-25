package com.model;

import java.util.Date;

/**
 *
 * @author TEOH YI YIN
 */
public class appointment {
    private int appointID, meetID;
    private String matricNo, appointVerify;

    public int getAppointID() {
        return appointID;
    }

    public void setAppointID(int appointID) {
        this.appointID = appointID;
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

    public String getAppointVerify() {
        return appointVerify;
    }

    public void setAppointVerify(String appointVerify) {
        this.appointVerify = appointVerify;
    }
}
