package com.util;

/**
 *
 * @author TEOH YI YIN
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static Connection myConnection = null;
    //private static String myURL = "jdbc:mysql://localhost:3306/s58798_FYP";
    //private static String myURL = "jdbc:mysql://localhost:3306/s58798_FYPOSC";
    private static String myURL = "jdbc:mysql://localhost:3306/FYPOneStopCentre";

    public static Connection getConnection(){
        if (myConnection != null) {
            return myConnection;
        } else try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            //myConnection = DriverManager.getConnection(myURL, "s58798", "Teoh!000309");
            myConnection = DriverManager.getConnection(myURL, "root", "admin");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return myConnection;
    }
}
