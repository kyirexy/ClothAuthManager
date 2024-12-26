package com.example.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import com.example.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/user/status")
public class UserStatusServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            
            if (idStr == null || status == null) {
                out.print("{\"code\":1,\"msg\":\"参数错误\"}");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            boolean success = userDAO.updateUserStatus(id, status);
            
            if (success) {
                out.print("{\"code\":0,\"msg\":\"状态更新成功\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"状态更新失败\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"服务器错误\"}");
        }
    }
} 