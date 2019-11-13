package org.deepfakenews.drivers;

import java.util.List;

import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;
import org.deepfakenews.models.Reimbursement;

public class TestDriver {
  public static void main(String[] args) {
    ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
    UserInfoDao userInfoDao = UserInfoDao.currentImplementation;

    List<Reimbursement> allReimbs = reimbDao.findAll();
    for (Reimbursement each : allReimbs) {
      System.out.println(each);
    }

//    List<UserInfo> allUserInfo = userInfoDao.findAll();
//    for (UserInfo each : allUserInfo) {
//      System.out.println(each);
//    }
//
//    List<Reimbursement> reimbsByAuthor = reimbDao.findByAuthorUsername("chip");
//    for (Reimbursement each : reimbsByAuthor) {
//      System.out.println(each);
//    }
//
//    List<Reimbursement> reimbsByStatus = reimbDao.findByStatus("PENDING");
//    for (Reimbursement each : reimbsByStatus) {
//      System.out.println(each);
//    }

//    List<Reimbursement> reimbsByAuthorAndStatus = reimbDao.findByAuthorAndStatus("chip", "PENDING");
//    for (Reimbursement each : reimbsByAuthorAndStatus) {
//      System.out.println(each);
//    }
  }
}