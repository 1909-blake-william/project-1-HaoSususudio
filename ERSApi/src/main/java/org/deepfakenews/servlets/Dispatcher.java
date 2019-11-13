package org.deepfakenews.servlets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Dispatcher {
  private static UserInfoDao userDao = UserInfoDao.currentImplementation;
  private static ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
  private static final String USER_URI = "/DFNERSApi/users";
  private static final String REIMBURSEMENT_URI = "/DFNERSApi/reimbursements";
  private static ObjectMapper mapper = new ObjectMapper();

  public static Object dispatch(HttpServletRequest request, HttpServletResponse response) {
    String httpMethod = request.getMethod();

    switch (httpMethod) {
    case "GET":
      return dispatchGET(request, response);
//      break;
    case "POST":
      return null;
//      break;
    case "PUT":
      return null;
//      break;
    default:
      return null;
    }

  }

  public static Object dispatchGET(HttpServletRequest request, HttpServletResponse response) {
    String reqURI = request.getRequestURI();
    if (reqURI.startsWith(USER_URI)) {
      return userDao.findAll();
    } else if (reqURI.startsWith(REIMBURSEMENT_URI)) {
      return dispatchGETReimbursements(request, response);
    }
    return null;
  }

  public static Object dispatchGETReimbursements(HttpServletRequest request,
      HttpServletResponse response) {
    String authorUsername = request.getParameter("author");
    String reimbStatus = request.getParameter("status");
    System.out.println(authorUsername + "  " + reimbStatus);
    if (authorUsername == null && reimbStatus == null) {
      return reimbDao.findAll();
    } else if (reimbStatus == null) {
      return reimbDao.findByAuthorUsername(authorUsername);
    } else if (authorUsername == null) {
      return reimbDao.findByStatus(reimbStatus);
    } else {
      return reimbDao.findByAuthorAndStatus(authorUsername, reimbStatus);
    }
  }

}