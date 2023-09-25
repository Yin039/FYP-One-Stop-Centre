package com.model;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author TEOH YI YIN
 */
public class user {
    private int userID, svID, offID, pairID;
    private String matricNo;
    private String email, password, userType;
    private String name, HP;
    private String svName, groupLink;
    private int groupNo, sem, number;
    private String IC, pgm, session;
    private String crsCode, crsName;
    private String offLoginValid;

    public String getSvName() {
        return svName;
    }

    public void setSvName(String svName) {
        this.svName = svName;
    }
    
    public int getSvID() {
        return svID;
    }

    public void setSvID(int svID) {
        this.svID = svID;
    }

    public int getOffID() {
        return offID;
    }

    public void setOffID(int offID) {
        this.offID = offID;
    }

    public int getPairID() {
        return pairID;
    }

    public void setPairID(int pairID) {
        this.pairID = pairID;
    }
    
    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHP() {
        return HP;
    }

    public void setHP(String HP) {
        this.HP = HP;
    }

    public int getGroupNo() {
        return groupNo;
    }

    public void setGroupNo(int groupNo) {
        this.groupNo = groupNo;
    }

    public int getSem() {
        return sem;
    }

    public void setSem(int sem) {
        this.sem = sem;
    }

    public String getIC() {
        return IC;
    }

    public void setIC(String IC) {
        this.IC = IC;
    }

    public String getPgm() {
        return pgm;
    }

    public void setPgm(String pgm) {
        this.pgm = pgm;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getCrsCode() {
        return crsCode;
    }

    public void setCrsCode(String crsCode) {
        this.crsCode = crsCode;
    }

    public String getCrsName() {
        return crsName;
    }

    public void setCrsName(String crsName) {
        this.crsName = crsName;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getOffLoginValid() {
        return offLoginValid;
    }

    public void setOffLoginValid(String offLoginValid) {
        this.offLoginValid = offLoginValid;
    }

    public String getGroupLink() {
        return groupLink;
    }

    public void setGroupLink(String groupLink) {
        this.groupLink = groupLink;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }
    
    public static boolean isValidPassword(String password) {
        String regex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%_]).{8,26}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }

    public static boolean isValidPhnNo(String phnNo) {
        String regex = "^\\d{10,11}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(phnNo);
        return matcher.matches();
    }

    public static boolean isValidEmail(String email) {
        String regex = "^[\\w-\\.]+@ocean.umt.edu.my$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }
    
    public static boolean isValidIcNo(String icNo) {
        String regex = "^\\d{6}-\\d{2}-\\d{4}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(icNo);
        return matcher.matches();
    }
}