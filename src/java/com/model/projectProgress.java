package com.model;

import java.sql.Timestamp;

/**
 *
 * @author TEOH YI YIN
 */
public class projectProgress {
    private int trackID, subTaskID, mainTaskID, projectID, moduleTrackID;
    private String trackStatus, subTask, mainTask, courseName, module;
    private int submitID;
   private String matricNo, documentName;
   private Timestamp submitDate;
   private byte[] document;

    public int getTrackID() {
        return trackID;
    }

    public void setTrackID(int trackID) {
        this.trackID = trackID;
    }

    public int getSubTaskID() {
        return subTaskID;
    }

    public void setSubTaskID(int subTaskID) {
        this.subTaskID = subTaskID;
    }

    public int getMainTaskID() {
        return mainTaskID;
    }

    public void setMainTaskID(int mainTaskID) {
        this.mainTaskID = mainTaskID;
    }

    public int getProjectID() {
        return projectID;
    }

    public void setProjectID(int projectID) {
        this.projectID = projectID;
    }

    public int getModuleTrackID() {
        return moduleTrackID;
    }

    public void setModuleTrackID(int moduleTrackID) {
        this.moduleTrackID = moduleTrackID;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }
    
    public String getTrackStatus() {
        return trackStatus;
    }

    public void setTrackStatus(String trackStatus) {
        this.trackStatus = trackStatus;
    }

    public String getSubTask() {
        return subTask;
    }

    public void setSubTask(String subTask) {
        this.subTask = subTask;
    }

    public String getMainTask() {
        return mainTask;
    }

    public void setMainTask(String mainTask) {
        this.mainTask = mainTask;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public int getSubmitID() {
        return submitID;
    }

    public void setSubmitID(int submitID) {
        this.submitID = submitID;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getDocumentName() {
        return documentName;
    }

    public void setDocumentName(String documentName) {
        this.documentName = documentName;
    }

    public Timestamp getSubmitDate() {
        return submitDate;
    }

    public void setSubmitDate(Timestamp submitDate) {
        this.submitDate = submitDate;
    }

    public byte[] getDocument() {
        return document;
    }

    public void setDocument(byte[] document) {
        this.document = document;
    }
}
