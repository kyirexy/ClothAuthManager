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

@WebServlet("/user/update")
public class UserUpdateServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idStr = request.getParameter("id");
            // 添加ID验证
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"code\":1,\"msg\":\"用户ID不能为空\"}");
                return;
            }
            
            int id = Integer.parseInt(idStr.trim());
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            
            // 打印调试信息
            System.out.println("Updating user - ID: " + id);
            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Phone: " + phone);
            System.out.println("Status: " + status);
            
            // 验证数据
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
                out.print("{\"code\":1,\"msg\":\"必填字段不能为空\"}");
                return;
            }
            
            // 创建用户对象
            User user = new User();
            user.setId(id);
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setStatus(status);
            
            // 更新用户信息
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                out.print("{\"code\":0,\"msg\":\"更新成功\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"更新失败\"}");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + request.getParameter("id"));
            out.print("{\"code\":1,\"msg\":\"无效的用户ID格式\"}");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Update error: " + e.getMessage());
            out.print("{\"code\":1,\"msg\":\"服务器错误: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
} 