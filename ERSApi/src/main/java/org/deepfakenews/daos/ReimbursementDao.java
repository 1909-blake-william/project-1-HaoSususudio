package org.deepfakenews.daos;

import java.util.List;

import org.deepfakenews.models.NewReimbReq;
import org.deepfakenews.models.Reimbursement;

public interface ReimbursementDao {
  ReimbursementDao currentImplementation = new ReimbursementDaoSQL();

  Reimbursement postNewReimbursement(NewReimbReq newReimb);

  Reimbursement updateStatus(int reimbId, int statusId, int resolverId);

  Reimbursement findById(int reimbId);

  List<Reimbursement> findAll();

  List<Reimbursement> findByAuthorUsername(String authorUsername);

  List<Reimbursement> findByStatus(String status);

  List<Reimbursement> findByAuthorAndStatus(String authorUsername, String status);



}
