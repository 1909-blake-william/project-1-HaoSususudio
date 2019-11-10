package org.deepfakenews.daos;

import org.deepfakenews.models.Reimbursement;

public interface ReimbursementDao {
	ReimbursementDao currentImplementation = new ReimbursementDaoSQL();

	int requestNewReimb(Reimbursement reimb);

	Reimbursement findById(int reimbId);
}
