package org.deepfakenews.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.deepfakenews.daos.UserInfoDao;
import org.deepfakenews.models.UserInfo;
import org.deepfakenews.models.UserLogin;
import org.deepfakenews.models.UsernameAndPW;
import org.deepfakenews.util.AuthUtil;

import com.fasterxml.jackson.databind.ObjectMapper;

public class AuthServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private static Logger log = Logger.getRootLogger();
  private static ObjectMapper objMapper = new ObjectMapper();
  private static UsernameAndPW inUNPW = new UsernameAndPW();
  private static UserInfo sessionUser = new UserInfo();
  private static UserInfoDao userInfoDao = UserInfoDao.currentImplementation;
  private static final String LOGIN_URI = "/DFNERSApi/auth/login";
  private static final String SESSION_USER_URI = "/DFNERSApi/auth/session-user";

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.addHeader("Access-Control-Allow-Origin", "http://localhost:5500");
    resp.addHeader("Access-Control-Allow-Methods", "POST, GET");
    resp.addHeader("Access-Control-Allow-Headers",
        "Origin, Methods, Credentials, X-Requested-With, Content-Type, Accept");
    resp.addHeader("Access-Control-Allow-Credentials", "true");
    resp.setContentType("application/json");
    // TODO Auto-generated method stub
    super.service(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String reqUri = req.getRequestURI();
    log.debug("doPost in AuthServlet");
    log.debug("reqUri = " + reqUri);

    if (LOGIN_URI.equals(req.getRequestURI())) {

      ObjectMapper om = new ObjectMapper();

      inUNPW = (UsernameAndPW) om.readValue(req.getReader(), UsernameAndPW.class);
      log.debug(inUNPW);
      UserLogin ulogin = AuthUtil.instance.login(inUNPW.getUsername(), inUNPW.getPassword());
      if (ulogin == null) {
        resp.setStatus(401); // Unauthorized status code
        log.debug("login failed");
        return;
      } else {
        resp.setStatus(201);
        sessionUser = userInfoDao.findByUsername(inUNPW.getUsername());
        req.getSession().setAttribute("sessionUser", sessionUser);
        resp.getWriter().write(om.writeValueAsString(ulogin));
        Object test = req.getSession().getAttribute("sessionUser");
        log.debug(test);
      }
    }
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    log.debug("doGet in AuthServlet");
    log.debug("reqUri = " + req.getRequestURI());
    if (SESSION_USER_URI.equals(req.getRequestURI())) {
      log.debug("uri matches");
      ObjectMapper om = new ObjectMapper();
      Object json = req.getSession().getAttribute("sessionUser");
      log.debug(json);
      resp.getWriter().write(om.writeValueAsString(json));
    }
  }

}
