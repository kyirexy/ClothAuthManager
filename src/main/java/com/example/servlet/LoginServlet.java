package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);
        
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();
        
        if (user != null) {
            request.getSession().setAttribute("loginUser", user);
            out.write("{\"code\":0,\"msg\":\"登录成功\"}");
        } else {
            out.write("{\"code\":1,\"msg\":\"用户名或密码错误\"}");
        }
    }
} 