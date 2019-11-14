package org.deepfakenews.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Enumeration;

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
      resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      log.debug("login failed");
      return;
    } else {
      resp.setStatus(201);
      req.getSession().setAttribute("user", ulogin);
      resp.getWriter().write(objMapper.writeValueAsString(ulogin));
//      req.getRequestDispatcher("/home.jsp").include(req, resp);

      Enumeration<String> attributes = req.getSession().getAttributeNames();
      while (attributes.hasMoreElements()) {
        String attribute = (String) attributes.nextElement();
        System.out.println(attribute + " : " + req.getSession().getAttribute(attribute));
      }

    }
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
