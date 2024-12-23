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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.register(user);
        
        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();
        
        if (success) {
            out.write("{\"code\":0,\"msg\":\"注册成功\"}");
        } else {
            out.write("{\"code\":1,\"msg\":\"注册失败，请检查用户名是否已存在\"}");
        }
    }
} 