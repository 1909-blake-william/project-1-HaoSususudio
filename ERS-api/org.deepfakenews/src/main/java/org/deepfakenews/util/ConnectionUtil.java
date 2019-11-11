package org.deepfakenews.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionUtil {
  static {
    try {
      Class.forName("oracle.jdbc.OracleDriver");
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }

  public static Connection getConnection() throws SQLException {
    // jdbc:oracle:thin:@hostname:port Number:databaseName
    String url = System.getenv("AWS_DEMO_1909_DB_URL");
    String username = System.getenv("DFN_ERS_DB_USERNAME");
    String password = System.getenv("DFN_ERS_DB_PASSWORD");
    return DriverManager.getConnection(url, username, password);
  }
}
