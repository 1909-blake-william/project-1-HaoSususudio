package org.deepfakenews.servlets;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.daos.UserInfoDao;
import org.deepfakenews.models.ReimbUpdateReq;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Dispatcher {
  private static UserInfoDao userDao = UserInfoDao.currentImplementation;
  private static ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;
  private static ReimbUpdateReq reimbUpdateReq = new ReimbUpdateReq();
  private static final String USER_URI = "/DFNERSApi/api/users";
  private static final String REIMBURSEMENT_URI = "/DFNERSApi/api/reimbursements";
  private static ObjectMapper objMapper = new ObjectMapper();
  private static Logger log = Logger.getRootLogger();

  public static Object dispatch(HttpServletRequest request, HttpServletResponse response)
      throws JsonParseException, JsonMappingException, IOException {
    String httpMethod = request.getMethod();

    switch (httpMethod) {
    case "GET":
      return dispatchGET(request, response);
    case "POST":
      return dispatchPOST(request, response);
    case "PUT":
      return dispatchPUT(request, response);
//      break;
    default:
      return null;
    }

  }

  public static Object dispatchGET(HttpServletRequest request, HttpServletResponse response) {
    String reqURI = request.getRequestURI();
    if (reqURI.startsWith(USER_URI)) {
      log.debug("dispatch GET");
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
    log.debug("dispatch GET" + userIdStr);
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
    log.debug("dispatch GET Reimb");
    log.debug("authorUsername = " + authorUsername);
    log.debug("reimbStatus = " + reimbStatus);

    if (!isConcrete(authorUsername) && !isConcrete(reimbStatus)) {
      return reimbDao.findAll();
    } else if (isConcrete(authorUsername) && !isConcrete(reimbStatus)) {
      return reimbDao.findByAuthorUsername(authorUsername);
    } else if (!isConcrete(authorUsername) && isConcrete(reimbStatus)) {
      return reimbDao.findByStatus(reimbStatus);
    } else if (isConcrete(authorUsername) && isConcrete(reimbStatus)) {
      return reimbDao.findByAuthorAndStatus(authorUsername, reimbStatus);
    } else {
      response.setStatus(400);
      return null;
    }
  }

  private static Object dispatchPOST(HttpServletRequest request, HttpServletResponse response) {
    // TODO Auto-generated method stub
    return null;
  }

  private static Object dispatchPUT(HttpServletRequest request, HttpServletResponse response)
      throws JsonParseException, JsonMappingException, IOException {
    String reqURI = request.getRequestURI();
    if (reqURI.startsWith(REIMBURSEMENT_URI)) {
      log.debug("dispatch PUT on reimbursement");
      return dispatchPUTReimbursements(request, response);
    } else {
      return null;
    }
  }

  public static Object dispatchPUTReimbursements(HttpServletRequest request,
      HttpServletResponse response) throws JsonParseException, JsonMappingException, IOException {
    log.debug("Inside dispatchPUTReimbursements");
    reimbUpdateReq = (ReimbUpdateReq) objMapper.readValue(request.getReader(),
        ReimbUpdateReq.class);
//        request.getSession().getAttribute("sessionUser");
//    inUNPW = (UsernameAndPW) om.readValue(req.getReader(), UsernameAndPW.class);
    log.debug(reimbUpdateReq);
    Integer reimbId = Integer.valueOf(reimbUpdateReq.getReimbId());
    Integer statusId = Integer.valueOf(reimbUpdateReq.getStatusId());
    Integer resolverId = Integer.valueOf(reimbUpdateReq.getResolverId());
    log.debug(reimbId + "  " + statusId + " " + resolverId);
    return reimbDao.updateStatus(reimbId, statusId, resolverId);
  }

  public static boolean isConcrete(String queryArg) {
    if (queryArg != null && queryArg.length() > 0) {
      return true;
    } else {
      return false;
    }
  }
}
