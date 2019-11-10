package org.deepfakenews.daos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.deepfakenews.models.Reimbursement;
import org.deepfakenews.util.ConnectionUtil;

public class ReimbursementDaoSQL implements ReimbursementDao {

  private Logger log = Logger.getRootLogger();

  Reimbursement extractReimb(ResultSet rs) throws SQLException {
    int reimbId = rs.getInt("reimb_id");
    double amount = rs.getDouble("reimb_amount");
    Timestamp submittedTime = rs.getTimestamp("reimb_submitted");
    Timestamp resolvedTime = rs.getTimestamp("reimb_resolved");
    String description = rs.getString("reimb_description");
    int authorId = rs.getInt("reimb_author");
    int resolverId = rs.getInt("reimb_resolver");
    int statusId = rs.getInt("reimb_status_id");
    int typeId = rs.getInt("reimb_type_id");
    return new Reimbursement(reimbId, amount, submittedTime, resolvedTime,
        description, authorId, resolverId, statusId, typeId);

  }

  @Override
  public int requestNew(Reimbursement reimb) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public int approve(Reimbursement reimb) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public int deny(Reimbursement reimb) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public Reimbursement findById(int reimbId) {

    return null;
  }

  @Override
  public List<Reimbursement> findAll() {
    log.debug("Attempting to find all Reimbursements from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      String sql = "SELECT * FROM Reimbursement";
//          + "LEFT JOIN pokemon_types t ON (p.pokemon_type_id = t.pokemon_types_id) "
//          + "LEFT JOIN pokemon_users u ON (p.trainer = u.user_id)";
      PreparedStatement ps = c.prepareStatement(sql);
      ResultSet rs = ps.executeQuery();
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
