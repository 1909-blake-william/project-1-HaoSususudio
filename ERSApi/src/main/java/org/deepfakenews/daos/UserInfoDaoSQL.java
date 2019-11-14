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
    String username = rs.getString("ers_username");
    String firstName = rs.getString("user_first_name");
    String lastName = rs.getString("user_last_name");
    String email = rs.getString("user_email");
    String userRole = rs.getString("user_role");
    return new UserInfo(userId, username, firstName, lastName, email, userRole);
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
    log.debug("Attempting to find user by id from DB");

    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_user_info_by_userid(?, ?)");
      cs.setInt(1, userId);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();

      ResultSet rs = (ResultSet) cs.getObject(2);
      if (rs.next()) {
        return extractUserInfo(rs);
      } else {
        return null;
      }

    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }

  }

  @Override
  public UserInfo findByUsername(String username) {
    log.debug("Attempting to find user by username from DB");

    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_user_info_by_username(?, ?)");
      cs.setString(1, username);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();

      ResultSet rs = (ResultSet) cs.getObject(2);
      if (rs.next()) {
        return extractUserInfo(rs);
      } else {
        return null;
      }
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }

  }

}
