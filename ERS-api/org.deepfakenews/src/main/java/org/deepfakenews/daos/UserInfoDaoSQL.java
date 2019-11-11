package org.deepfakenews.daos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.deepfakenews.models.UserInfo;
import org.deepfakenews.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

public class UserInfoDaoSQL implements UserInfoDao {
  private Logger log = Logger.getRootLogger();

  UserInfo extractUserInfo(ResultSet rs) throws SQLException {
    int userId = rs.getInt("ers_users_id");
    String firstName = rs.getString("user_first_name");
    String lastName = rs.getString("user_last_name");
    String email = rs.getString("user_email");
    String userRole = rs.getString("user_role");
    return new UserInfo(userId, firstName, lastName, email, userRole);
  }

  @Override
  public List<UserInfo> findAll() {
    log.debug("Attempting to find all users from DB");

    try (Connection c = ConnectionUtil.getConnection()) {

      CallableStatement cs = c.prepareCall("call get_all_user_info(?)");
      cs.registerOutParameter(1, OracleTypes.CURSOR);
      cs.execute();

      ResultSet rs = (ResultSet) cs.getObject(1);

      List<UserInfo> userInfo = new ArrayList<UserInfo>();
      while (rs.next()) {
        userInfo.add(extractUserInfo(rs));
      }
      return userInfo;
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  @Override
  public UserInfo findById(int userId) {
    // TODO Auto-generated method stub
    return null;
  }

}
