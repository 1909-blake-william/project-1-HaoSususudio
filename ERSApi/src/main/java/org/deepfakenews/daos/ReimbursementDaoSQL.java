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

    return 0;
  }

  @Override
  public Reimbursement findById(int reimbId) {
    log.debug("Attempting to find Reimbursement by reimbId = " + reimbId);
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_id(?, ?)");
      cs.setInt(1, reimbId);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(2);

      if (rs.next()) {
        return extractReimb(rs);
      } else {
        return null;
      }
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
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
    log.debug("Attempting to find Reimbursements by authorUsername from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_author(?, ?)");
      cs.setString(1, authorUsername.toLowerCase());
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
    log.debug("Attempting to find Reimbursements by status from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_status(?, ?)");
      cs.setString(1, status.toUpperCase());
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
    log.debug("Attempting to find Reimbursements by author and status from DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_reimb_by_author_and_status(?, ?, ?)");
      cs.setString(1, authorUsername.toLowerCase());
      cs.setString(2, status.toUpperCase());
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

  @Override
  public Reimbursement updateStatus(int reimbId, int statusId, int resolverId) {
    log.debug("Attempting to update reimbursements status in DB");
    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call update_reimb_status(?, ?, ?)");
      cs.setInt(1, reimbId);
      cs.setInt(2, statusId);
      cs.setInt(3, resolverId);
      cs.execute();

      cs = c.prepareCall("call get_reimb_by_id(?, ?)");
      cs.setInt(1, reimbId);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      ResultSet rs = (ResultSet) cs.getObject(2);

      if (rs.next()) {
        return extractReimb(rs);
      } else {
        return null;
      }

    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }
}
