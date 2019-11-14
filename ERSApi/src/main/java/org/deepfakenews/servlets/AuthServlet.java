package org.deepfakenews.servlets;

import java.io.BufferedReader;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.deepfakenews.models.UserLogin;
import org.deepfakenews.models.UsernameAndPW;
import org.deepfakenews.util.AuthUtil;

import com.fasterxml.jackson.databind.ObjectMapper;

public class AuthServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private static Logger log = Logger.getRootLogger();
  private static final ObjectMapper objMapper = new ObjectMapper();
  private static UsernameAndPW inUNPW = new UsernameAndPW();

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    System.out.println(req.getRequestURL());
    resp.addHeader("Access-Control-Allow-Origin", "http://localhost:5500");
    resp.addHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, HEAD");
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
    BufferedReader reqReader = req.getReader();

    inUNPW = (UsernameAndPW) objMapper.readValue(reqReader, UsernameAndPW.class);
    log.debug(inUNPW);
    UserLogin ulogin = AuthUtil.instance.login(inUNPW.getUsername(), inUNPW.getPassword());
    if (ulogin == null) {
      resp.setStatus(401); // Unauthorized status code
//      resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      log.debug("login failed");
      return;
    } else {
      resp.setStatus(201);
      req.getSession().setAttribute("userLogin", ulogin);
      resp.getWriter().write(objMapper.writeValueAsString(ulogin));
      Object test = req.getSession().getAttribute("userLogin");
      log.debug(test);
    }
  }

}
