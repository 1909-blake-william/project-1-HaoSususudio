package org.deepfakenews.daos;

import java.util.List;

import org.deepfakenews.models.Reimbursement;

public interface ReimbursementDao {
  ReimbursementDao currentImplementation = new ReimbursementDaoSQL();

  int requestNew(Reimbursement reimb);

  int approve(Reimbursement reimb);

  int deny(Reimbursement reimb);

  Reimbursement findById(int reimbId);

  List<Reimbursement> findAll();

  List<Reimbursement> findByAuthorId();

}
