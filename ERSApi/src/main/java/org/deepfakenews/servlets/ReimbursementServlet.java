package org.deepfakenews.servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.deepfakenews.daos.ReimbursementDao;
import org.deepfakenews.models.Reimbursement;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ReimbursementServlet extends HttpServlet {
  private ReimbursementDao reimbDao = ReimbursementDao.currentImplementation;

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    super.service(req, resp);
//    System.out.println("To context param: " + req.getServletContext().getInitParameter("To"));

    resp.addHeader("Access-Control-Allow-Origin", "http://localhost:4200");
    resp.addHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, HEAD");
    resp.addHeader("Access-Control-Allow-Headers",
        "Origin, Methods, Credentials, X-Requested-With, Content-Type, Accept");
    resp.addHeader("Access-Control-Allow-Credentials", "true");
    resp.setContentType("application/json");
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    List<Reimbursement> reimbs;

    String authorUsername = req.getParameter("author").toLowerCase();
    String reimbStatus = req.getParameter("status").toUpperCase();

    if (authorUsername != null) { // find by authorUsername
      reimbs = reimbDao.findByAuthorUsername(authorUsername);
    } else { // find all
      reimbs = reimbDao.findAll();
    }

    ObjectMapper om = new ObjectMapper();
    String json = om.writeValueAsString(reimbs);

    resp.addHeader("content-type", "application/json");
    resp.getWriter().write("status = " + reimbStatus);
    resp.getWriter().write(json);
  }

}
