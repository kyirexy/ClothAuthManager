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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应类型
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();
        
        try {
            // 获取当前登录用户
            User currentUser = (User) request.getSession().getAttribute("loginUser");
            if (currentUser == null) {
                result.put("code", 1);
                result.put("msg", "请先登录");
                out.write(new Gson().toJson(result));
                return;
            }

            // 获取表单数据
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");

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

            if (gender != null && !gender.matches("[MF]")) {
                result.put("code", 1);
                result.put("msg", "性别格式不正确");
                out.write(new Gson().toJson(result));
                return;
            }

            // 更新用户信息
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setGender(gender);
            
            UserDAO userDAO = new UserDAO();
            boolean updated = userDAO.updateUser(currentUser);
            
            if (updated) {
                // 更新session中的用户信息
                request.getSession().setAttribute("loginUser", currentUser);
                result.put("code", 0);
                result.put("msg", "更新成功");
                
                // 返回更新后的用户信息
                Map<String, Object> data = new HashMap<>();
                data.put("email", currentUser.getEmail());
                data.put("phone", currentUser.getPhone());
                data.put("gender", currentUser.getGender());
                result.put("data", data);
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

    // 记录日志的辅助方法
    private void logUserUpdate(User user, String field, String oldValue, String newValue) {
        System.out.println(String.format(
            "用户更新 - ID: %d, 字段: %s, 旧值: %s, 新值: %s",
            user.getId(), field, oldValue, newValue
        ));
    }
}