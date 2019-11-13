package org.deepfakenews.servlets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Dispatcher {
  private UserInfoDao userDao = UserInfoDao.currentImplementation;
  private ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
  private static final String USER_URI = "/DFNERSApi/users";
  private static final String REIMBURSEMENT_URI = "/DFNERSApi/reimbursments";
  private static ObjectMapper mapper = new ObjectMapper();

  public static Object dispatch(HttpServletRequest req, HttpServletResponse resp) {

    return null;
  }

}
