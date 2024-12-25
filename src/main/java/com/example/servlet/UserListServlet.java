package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/user/list")
public class UserListServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取分页参数
        int page = Integer.parseInt(request.getParameter("page"));
        int limit = Integer.parseInt(request.getParameter("limit"));
        
        // 获取搜索参数
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String status = request.getParameter("status");
        
        try {
            // 获取总数和数据列表
            int count = userDAO.getUserCount(username, email, status);
            List<User> users = userDAO.getUserList(page, limit, username, email, status);
            
            // 构造返回数据
            Map<String, Object> result = new HashMap<>();
            result.put("code", 0);
            result.put("msg", "");
            result.put("count", count);
            result.put("data", users);
            
            // 返回JSON数据
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            Map<String, Object> error = new HashMap<>();
            error.put("code", 500);
            error.put("msg", "服务器错误");
            response.getWriter().write(gson.toJson(error));
        }
    }
} 