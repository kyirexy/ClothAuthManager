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

@WebServlet("/user/add")
public class UserAddServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 获取表单数据
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            // 检查用户名是否已存在
            if (userDAO.isUsernameExists(username)) {
                out.print("{\"code\":1,\"msg\":\"用户名已存在\"}");
                return;
            }
            
            // 创建用户对象
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setPhone(phone);
            user.setStatus("active"); // 设置默认状态
            
            // 保存到数据库
            boolean success = userDAO.addUser(user);
            
            if (success) {
                out.print("{\"code\":0,\"msg\":\"添加成功\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"添加失败\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
} 