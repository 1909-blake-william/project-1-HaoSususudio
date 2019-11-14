package org.deepfakenews.servlets;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Dispatcher {
  private static UserInfoDao userDao = UserInfoDao.currentImplementation;
  private static ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
  private static final String USER_URI = "/DFNERSApi/api/users";
  private static final String REIMBURSEMENT_URI = "/DFNERSApi/api/reimbursements";
  private static ObjectMapper mapper = new ObjectMapper();
  private static Logger log = Logger.getRootLogger();

  public static Object dispatch(HttpServletRequest request, HttpServletResponse response) {
    String httpMethod = request.getMethod();

    switch (httpMethod) {
    case "GET":
      return dispatchGET(request, response);
    case "POST":
      return dispatchPOST(request, response);
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
      log.debug("dispatchGETUse");
      return dispatchGETUser(request, response);
    } else if (reqURI.startsWith(REIMBURSEMENT_URI)) {
      return dispatchGETReimbursements(request, response);
    } else {
      return null;
    }
  }

  public static Object dispatchGETUser(HttpServletRequest request, HttpServletResponse response) {
    String username = request.getParameter("username");
    String userIdStr = request.getParameter("userid");
    System.out.println(userIdStr);
    if (username != null) {
      return userDao.findByUsername(username);
    } else if (userIdStr != null) {
      int userId = Integer.valueOf(userIdStr);
      return userDao.findById(userId);
    } else {
      return userDao.findAll();
    }
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

  private static Object dispatchPOST(HttpServletRequest request, HttpServletResponse response) {
    // TODO Auto-generated method stub
    return null;
  }

}