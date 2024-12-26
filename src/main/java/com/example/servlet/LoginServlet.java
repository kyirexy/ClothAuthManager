package com.example.servlet;

import com.example.dao.AdminDAO;
import com.example.dao.UserDAO;
import com.example.model.Admin;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();

        try {
            if ("admin".equals(role)) {
                handleAdminLogin(request, out, username, password);
            } else {
                handleUserLogin(request, out, username, password);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"code\":500,\"msg\":\"服务器错误\"}");
        }
    }

    private void handleAdminLogin(HttpServletRequest request, PrintWriter out, String username, String password) {
        AdminDAO adminDAO = new AdminDAO();
        Admin admin = adminDAO.login(username, password);

        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginAdmin", admin);
            session.setAttribute("userRole", "admin");
            out.write("{\"code\":0,\"msg\":\"登录成功\",\"role\":\"admin\"}");
        } else {
            out.write("{\"code\":1,\"msg\":\"管理员账号或密码错误\"}");
        }
    }

    private void handleUserLogin(HttpServletRequest request, PrintWriter out, String username, String password) {
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginUser", user);
            session.setAttribute("userRole", "user");
            out.write("{\"code\":0,\"msg\":\"登录成功\",\"role\":\"user\"}");
        } else {
            out.write("{\"code\":1,\"msg\":\"用户名或密码错误\"}");
        }
    }
}