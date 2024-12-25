package com.example.servlet;

import com.example.dao.UserDAO;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/user/delete")
public class UserDeleteServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        Map<String, Object> result = new HashMap<>();
        response.setContentType("application/json;charset=utf-8");
        
        try {
            int id = Integer.parseInt(idStr);
            boolean success = userDAO.deleteUser(id);
            
            if (success) {
                result.put("code", 0);
                result.put("msg", "删除��功");
            } else {
                result.put("code", 1);
                result.put("msg", "删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "服务器错误");
        }
        
        response.getWriter().write(gson.toJson(result));
    }
} 