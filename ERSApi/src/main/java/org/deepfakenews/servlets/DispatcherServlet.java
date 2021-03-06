package org.deepfakenews.servlets;

import java.io.IOException;
import java.util.Collections;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class DispatcherServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final ObjectMapper mapper = new ObjectMapper();

  public DispatcherServlet() {
    mapper.enable(SerializationFeature.INDENT_OUTPUT);
  }

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.addHeader("Access-Control-Allow-Origin", "http://localhost:5500");
    resp.addHeader("Access-Control-Allow-Methods", "POST, GET, PUT");
    resp.addHeader("Access-Control-Allow-Headers",
        "Origin, Methods, Credentials, X-Requested-With, Content-Type, Accept");
    resp.addHeader("Access-Control-Allow-Credentials", "true");
    resp.setContentType("application/json");
    super.service(req, resp);
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.setContentType("application/json");
    Object response = Dispatcher.dispatch(req, resp);
    if (response != null) {

      try {
        resp.getOutputStream().write(mapper.writeValueAsBytes(response));
      } catch (IOException e) {
        resp.getOutputStream().write(mapper
            .writeValueAsBytes(Collections.singletonMap("error", "Failed to write JSON in doGet")));
      }
    } else {
      resp.setStatus(400);
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.setContentType("application/json");

    Object response = Dispatcher.dispatch(req, resp);
    if (response != null) {

      try {
        resp.getOutputStream().write(mapper.writeValueAsBytes(response));
      } catch (IOException e) {

        resp.getOutputStream().write(mapper.writeValueAsBytes(
            Collections.singletonMap("error", "Failed to write Failed to write JSON in doPost")));
      }
    } else {
      resp.setStatus(400);
    }
  }

  @Override
  protected void doPut(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    resp.setContentType("application/json");

    Object response = Dispatcher.dispatch(req, resp);
    if (response != null) {

      try {
        resp.getOutputStream().write(mapper.writeValueAsBytes(response));
      } catch (IOException e) {

        resp.getOutputStream().write(mapper.writeValueAsBytes(
            Collections.singletonMap("error", "Failed to write Failed to write JSON in doPut")));
      }
    } else {
      resp.setStatus(400);
    }
  }
}
