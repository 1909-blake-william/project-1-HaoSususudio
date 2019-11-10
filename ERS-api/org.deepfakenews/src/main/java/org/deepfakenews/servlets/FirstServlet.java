package org.deepfakenews.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class FirstServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getRootLogger();
//	@Override
//	public void init(ServletConfig config) throws ServletException {
//		super.init(config);	
//		System.out.println("Poto init param: " + config.getInitParameter("Poto"));
//		System.out.println("To context param: " + config.getServletContext().getInitParameter("To"));
//	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		log.debug("request received with uri: " + req.getRequestURI());
		resp.getWriter().write("Hello from our first servlet on DeepFakeNews");
		// redirect
//		resp.sendRedirect("https://bing.com");
		// forward
//		req.getRequestDispatcher("/pokemon").forward(req, resp);
	}
}
