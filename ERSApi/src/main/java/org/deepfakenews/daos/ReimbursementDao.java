package org.deepfakenews.daos;

import java.util.List;

import org.deepfakenews.models.Reimbursement;

public interface ReimbursementDao {
  ReimbursementDao currentImplementation = new ReimbursementDaoSQL();

  int requestNew(Reimbursement reimb);

  void approve(int reimbId, int resolverId);

  void deny(int reimbId, int resolverId);

  Reimbursement findById(int reimbId);

  List<Reimbursement> findAll();

  List<Reimbursement> findByAuthorUsername(String authorUsername);

}
