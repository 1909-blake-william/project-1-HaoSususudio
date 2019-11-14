package org.deepfakenews.servlets;

import java.io.BufferedReader;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.deepfakenews.models.UsernameAndPW;

import com.fasterxml.jackson.databind.ObjectMapper;

public class AuthServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private static Logger log = Logger.getRootLogger();
  private static final ObjectMapper objMapper = new ObjectMapper();
  private static UsernameAndPW providedUNPW = new UsernameAndPW();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String reqUri = req.getRequestURI();
    log.debug("doPost in AuthServlet");
    log.debug("reqUri = " + reqUri);
    BufferedReader reqReader = req.getReader();

    providedUNPW = (UsernameAndPW) objMapper.readValue(reqReader, UsernameAndPW.class);
    log.debug(providedUNPW);


//    log.debug("username = " + providedCreds.getUsername() + ", password = "
//        + providedCreds.getPassword());

//    if ("william".equals(username) && "password".equals(password)) {
////      objMapper.read
//      // Session, cookies,
//      // On a cookie, you specify a name, a value, and path (At least). Cookies are
//      // stored on the browser,
//      // and every time the browser send an HTTP request to that path, the cookie will
//      // be included
//      req.getSession().setAttribute("currentUser", "william");
//      req.getSession().setAttribute("age", 26);
//
//      // At this point in time, what are you trying to do?
//      // Go to the home page!
//      // This is not used in REST API's. Only when using Server Side Rendering (In our
//      // case, JSP).
//      req.getRequestDispatcher("/home.jsp").include(req, resp);
//      return;
//    } else {
//      resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
//      return;
//    }
  }

}
