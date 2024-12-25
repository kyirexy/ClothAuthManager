package com.example.servlet;

import com.example.dao.AdminDAO;
import com.example.dao.UserDAO;
import com.example.model.Admin;
import com.example.model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            
            User user = (User) request.getSession().getAttribute("loginUser");
            Admin admin = (Admin) request.getSession().getAttribute("loginAdmin");
            
            boolean updated = false;
            
            if (admin != null) {
                // 验证管理员原密码
                if (adminDAO.verifyPassword(admin.getId(), oldPassword)) {
                    updated = adminDAO.updatePassword(admin.getId(), newPassword);
                } else {
                    result.put("code", 1);
                    result.put("msg", "原密码错误");
                    out.write(new Gson().toJson(result));
                    return;
                }
            } else if (user != null) {
                // 验证用户原密码
                if (userDAO.verifyPassword(user.getId(), oldPassword)) {
                    updated = userDAO.updatePassword(user.getId(), newPassword);
                } else {
                    result.put("code", 1);
                    result.put("msg", "原密码错误");
                    out.write(new Gson().toJson(result));
                    return;
                }
            } else {
                result.put("code", 1);
                result.put("msg", "请先登录");
                out.write(new Gson().toJson(result));
                return;
            }
            
            if (updated) {
                result.put("code", 0);
                result.put("msg", "密码修改成功");
                // 清除session
                request.getSession().invalidate();
            } else {
                result.put("code", 1);
                result.put("msg", "修改失败");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 1);
            result.put("msg", "系统错误: " + e.getMessage());
        }
        
        out.write(new Gson().toJson(result));
    }
} 