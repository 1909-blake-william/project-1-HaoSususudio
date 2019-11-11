package org.deepfakenews.daos;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.deepfakenews.models.Reimbursement;
import org.deepfakenews.models.UserInfo;
import org.deepfakenews.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

public class ReimbursementDaoSQL implements ReimbursementDao {

  private Logger log = Logger.getRootLogger();

  Reimbursement extractReimb(ResultSet rs) throws SQLException {
    int reimbId = rs.getInt("reimb_id");
    double amount = rs.getDouble("reimb_amount");
    Timestamp submittedTime = rs.getTimestamp("reimb_submitted");
    Timestamp resolvedTime = rs.getTimestamp("reimb_resolved");
    String description = rs.getString("reimb_description");

    int authorId = rs.getInt("ers_users_id");
    String authorFirstName = rs.getString("user_first_name");
    String authorlastName = rs.getString("user_last_name");
    String authorEmail = rs.getString("user_email");
    String authorRole = rs.getString("user_role");

    int resolverId = rs.getInt("ers_users_id");
    String resolverFirstName = rs.getString("user_first_name");
    String resolverlastName = rs.getString("user_last_name");
    String resolverEmail = rs.getString("user_email");
    String resolverRole = rs.getString("user_role");

    String status = rs.getString("reimb_status");
    String type = rs.getString("reimb_type");

    return new Reimbursement(reimbId, amount, submittedTime, resolvedTime, description,
        new UserInfo(authorId, authorFirstName, authorlastName, authorEmail, authorRole),
        new UserInfo(resolverId, resolverFirstName, resolverlastName, resolverEmail, resolverRole),
        status, type);

  }

  @Override
  public int requestNew(Reimbursement reimb) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public void approve(int reimbId, int resolverId) {
    // TODO Auto-generated method stub
  }

  @Override
  public void deny(int reimbId, int resolverId) {
    // TODO Auto-generated method stub
  }

  @Override
  public Reimbursement findById(int reimbId) {

    return null;
  }

  @Override
  public List<Reimbursement> findAll() {
    log.debug("Attempting to find all Reimbursements from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_all_reimbursements(?)");
      cs.registerOutParameter(1, OracleTypes.CURSOR);
      cs.execute();

      ResultSet rs = (ResultSet) cs.getObject(1);

      List<Reimbursement> allReimbs = new ArrayList<>();
      while (rs.next()) {
        allReimbs.add(extractReimb(rs));
      }
      return allReimbs;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  public List<Reimbursement> findByAuthorId() {
    // TODO Auto-generated method stub
    return null;
  }

}
