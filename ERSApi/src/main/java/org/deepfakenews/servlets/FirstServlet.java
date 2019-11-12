package org.deepfakenews.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class FirstServlet extends HttpServlet {
  private Logger log = Logger.getRootLogger();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    log.debug("request received with uri: " + req.getRequestURI());
    resp.getWriter().write("Hello from our first servlet DFNERS");
  }
}
