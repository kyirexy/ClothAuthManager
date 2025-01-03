package com.example.servlet;

import com.example.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user/delete")
public class UserDeleteServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 获取要删除的用户ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"code\":1,\"msg\":\"用户ID不能为空\"}");
                return;
            }
            
            int id = Integer.parseInt(idStr);
            
            // 执行删除操作
            boolean success = userDAO.deleteUser(id);
            
            if (success) {
                out.print("{\"code\":0,\"msg\":\"删除成功\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"删除失败\"}");
            }
            
        } catch (NumberFormatException e) {
            out.print("{\"code\":1,\"msg\":\"无效的用户ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
} 