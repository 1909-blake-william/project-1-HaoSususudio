package org.deepfakenews.drivers;

import java.util.List;

import org.apache.log4j.Logger;
import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;
import org.deepfakenews.daos.UserLoginDao;
import org.deepfakenews.models.Reimbursement;
import org.deepfakenews.models.UserLogin;

public class TestDriver {
  private static Logger log = Logger.getRootLogger();

  public static void main(String[] args) {
    ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
    UserInfoDao userInfoDao = UserInfoDao.currentImplementation;
    UserLoginDao userLoginDao = UserLoginDao.currentImplementation;
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

    UserLogin uLogin = userLoginDao.findByUsername("chip");
    log.debug(uLogin);
  }
}