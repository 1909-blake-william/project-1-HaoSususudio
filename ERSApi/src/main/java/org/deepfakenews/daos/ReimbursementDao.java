package org.deepfakenews.daos;

import java.util.List;

import org.deepfakenews.models.Reimbursement;

public interface ReimbursementDao {
  ReimbursementDao currentImplementation = new ReimbursementDaoSQL();

  int requestNew(Reimbursement reimb);

  Reimbursement updateStatus(int reimbId, int statusId, int resolverId);

  Reimbursement findById(int reimbId);

  List<Reimbursement> findAll();

  List<Reimbursement> findByAuthorUsername(String authorUsername);

  List<Reimbursement> findByStatus(String status);

  List<Reimbursement> findByAuthorAndStatus(String authorUsername, String status);

}
