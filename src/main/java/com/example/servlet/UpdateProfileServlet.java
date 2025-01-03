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

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 获取当前登录用户
            User user = (User) request.getSession().getAttribute("loginUser");
            Admin admin = (Admin) request.getSession().getAttribute("loginAdmin");
            
            // 获取表单数据
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // 验证数据
            if (!isValidEmail(email)) {
                result.put("code", 1);
                result.put("msg", "邮箱格式不正确");
                out.write(new Gson().toJson(result));
                return;
            }

            if (!isValidPhone(phone)) {
                result.put("code", 1);
                result.put("msg", "手机号格式不正确");
                out.write(new Gson().toJson(result));
                return;
            }

            boolean updated = false;
            
            if (admin != null) {
                // 更新管理员信息
                admin.setEmail(email);
                admin.setPhone(phone);
                updated = adminDAO.updateAdmin(admin);
                if (updated) {
                    request.getSession().setAttribute("loginAdmin", admin);
                }
            } else if (user != null) {
                // 更新用户信息
                user.setEmail(email);
                user.setPhone(phone);
                updated = userDAO.updateUser(user);
                if (updated) {
                    request.getSession().setAttribute("loginUser", user);
                }
            } else {
                result.put("code", 1);
                result.put("msg", "请先登录");
                out.write(new Gson().toJson(result));
                return;
            }
            
            if (updated) {
                result.put("code", 0);
                result.put("msg", "更新成功");
            } else {
                result.put("code", 1);
                result.put("msg", "更新失败");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 1);
            result.put("msg", "系统错误: " + e.getMessage());
        }
        
        out.write(new Gson().toJson(result));
    }

    // 验证邮箱格式
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    // 验证手机号格式
    private boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return phone.matches("^1[3-9]\\d{9}$");
    }
}