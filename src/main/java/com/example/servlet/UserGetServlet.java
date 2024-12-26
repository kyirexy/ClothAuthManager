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

@WebServlet("/user/get")
public class UserGetServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"code\":1,\"msg\":\"用户ID不能为空\"}");
                return;
            }
            
            int id = Integer.parseInt(idStr.trim());
            User user = userDAO.getUserById(id);
            
            if (user != null) {
                // 确保返回所有需要的字段
                String jsonData = "{\"code\":0,\"msg\":\"success\",\"data\":{" +
                    "\"id\":" + user.getId() + "," +
                    "\"username\":\"" + user.getUsername() + "\"," +
                    "\"email\":\"" + user.getEmail() + "\"," +
                    "\"phone\":\"" + user.getPhone() + "\"," +
                    "\"status\":\"" + user.getStatus() + "\"" +
                    "}}";
                out.print(jsonData);
            } else {
                out.print("{\"code\":1,\"msg\":\"用户不存在\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
}