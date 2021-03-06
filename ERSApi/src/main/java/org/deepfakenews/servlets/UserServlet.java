package org.deepfakenews.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.deepfakenews.daos.UserInfoDao;
import org.deepfakenews.models.UserInfo;

import com.fasterxml.jackson.databind.ObjectMapper;

public class UserServlet extends HttpServlet {
  private UserInfoDao userDao = UserInfoDao.currentImplementation;

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    super.service(req, resp);
//    resp.addHeader("Access-Control-Allow-Origin", "http://localhost:4200");
    resp.addHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, HEAD");
    resp.addHeader("Access-Control-Allow-Headers",
        "Origin, Methods, Credentials, X-Requested-With, Content-Type, Accept");
    resp.addHeader("Access-Control-Allow-Credentials", "true");
    resp.setContentType("application/json");
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.getWriter().write("Hello from our user servlet DFNERS");
    List<UserInfo> users;

    users = userDao.findAll();

    ObjectMapper om = new ObjectMapper();
    String json = om.writeValueAsString(users);

    resp.addHeader("content-type", "application/json");
    resp.getWriter().write(json);
  }

}
