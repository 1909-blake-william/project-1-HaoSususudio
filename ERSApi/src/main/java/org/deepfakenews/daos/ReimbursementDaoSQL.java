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
import org.deepfakenews.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

public class ReimbursementDaoSQL implements ReimbursementDao {

  private Logger log = Logger.getRootLogger();

  Reimbursement extractReimb(ResultSet rs) throws SQLException {
    int reimbId = rs.getInt("reimb_id");
    Double amount = rs.getDouble("reimb_amount");
    Timestamp submittedTime = rs.getTimestamp("reimb_submitted");
    Timestamp resolvedTime = rs.getTimestamp("reimb_resolved");
    String description = rs.getString("reimb_description");
    Integer authorId = rs.getInt("reimb_author");
    Integer resolverId = rs.getInt("reimb_resolver");
    String status = rs.getString("reimb_status");
    String type = rs.getString("reimb_type");

    return new Reimbursement(reimbId, amount, submittedTime, resolvedTime, description, authorId,
        resolverId, status, type);
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
  public List<Reimbursement> findByAuthorUsername(String authorUsername) {
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_author(?, ?)");
      cs.setString(1, authorUsername);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(2);

      List<Reimbursement> reimbsByAuthor = new ArrayList<>();
      while (rs.next()) {
        reimbsByAuthor.add(extractReimb(rs));
      }
      return reimbsByAuthor;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  public List<Reimbursement> findByStatus(String status) {
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_status(?, ?)");
      cs.setString(1, status);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(2);

      List<Reimbursement> reimbsByStatus = new ArrayList<>();
      while (rs.next()) {
        reimbsByStatus.add(extractReimb(rs));
      }
      return reimbsByStatus;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  public List<Reimbursement> findByAuthorAndStatus(String authorUsername, String status) {
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_author_and_status(?, ?, ?)");
      cs.setString(1, authorUsername);
      cs.setString(2, status);
      cs.registerOutParameter(3, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(3);

      List<Reimbursement> reimbsByStatus = new ArrayList<>();
      while (rs.next()) {
        reimbsByStatus.add(extractReimb(rs));
      }
      return reimbsByStatus;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }
}
