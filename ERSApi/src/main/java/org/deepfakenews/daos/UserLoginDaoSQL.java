package org.deepfakenews.daos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;
import org.deepfakenews.models.UserLogin;
import org.deepfakenews.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

public class UserLoginDaoSQL implements UserLoginDao {
  private Logger log = Logger.getRootLogger();

  UserLogin extractUser(ResultSet rs) throws SQLException {
    String username = rs.getString("ers_username");
    String secureKey = rs.getString("ers_secure_key");
    String salt = rs.getString("ers_salt");
    String role = rs.getString("user_role");
    return new UserLogin(username, secureKey, salt, role);
  }

  @Override
  public UserLogin findByUsername(String username) {
    log.debug("Attempting to find user login credential by username from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_user_login_by_username(?,?)");

      cs.setString(1, username);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(2);

      if (rs.next()) {
        return extractUser(rs);
      } else {
        return null;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

}
