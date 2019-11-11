package org.deepfakenews.drivers;

import java.util.List;

import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.models.Reimbursement;

public class TestDriver {
  public static void main(String[] args) {
    ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
//    UserInfoDao userInfoDao = UserInfoDao.currentImplementation;

    List<Reimbursement> allReimbs = reimbDao.findAll();
    for (Reimbursement each : allReimbs) {
      System.out.println(each);
    }

//    List<UserInfo> allUserInfo = userInfoDao.findAll();
//    for (UserInfo each : allUserInfo) {
//      System.out.println(each);
//    }
  }
}