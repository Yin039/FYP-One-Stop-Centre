package com.model;

/**
 *
 * @author TEOH YI YIN
 */
public class project {
    private  int projectID;
    private String matricNo, projectTitle, projectType, projectDesc, projectApproval;
    private String coSvName, coSvHp;
    private Double projectProgress;

    public int getProjectID() {
        return projectID;
    }

    public void setProjectID(int projectID) {
        this.projectID = projectID;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public String getProjectDesc() {
        return projectDesc;
    }

    public void setProjectDesc(String projectDesc) {
        this.projectDesc = projectDesc;
    }

    public String getProjectApproval() {
        return projectApproval;
    }

    public void setProjectApproval(String projectApproval) {
        this.projectApproval = projectApproval;
    }

    public String getCoSvName() {
        return coSvName;
    }

    public void setCoSvName(String coSvName) {
        this.coSvName = coSvName;
    }

    public String getCoSvHp() {
        return coSvHp;
    }

    public void setCoSvHp(String coSvHp) {
        this.coSvHp = coSvHp;
    }

    public Double getProjectProgress() {
        return projectProgress;
    }

    public void setProjectProgress(Double projectProgress) {
        this.projectProgress = projectProgress;
    }
    
}
