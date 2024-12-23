package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.model.User;
import com.example.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/uploadAvatar")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10,   // 10 MB
    location = ""                        // 临时文件存储位置
)
public class UploadAvatarServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 获取当前登录用户
            User user = (User) request.getSession().getAttribute("loginUser");
            if (user == null) {
                out.print("{\"code\":1,\"msg\":\"请先登录\"}");
                return;
            }

            // 获取上传的文件
            Part filePart = request.getPart("file");
            if (filePart == null) {
                out.print("{\"code\":1,\"msg\":\"请选择文件\"}");
                return;
            }

            // 删除旧头像
            if (user.getProfilePicture() != null) {
                FileUtil.deleteImage(user.getProfilePicture());
            }

            // 保存新头像
            String newAvatarPath = FileUtil.saveImage(filePart);
            
            // 更新数据库
            if (userDAO.updateAvatar(user.getId(), newAvatarPath)) {
                // 更新session中的用户信息
                user.setProfilePicture(newAvatarPath);
                request.getSession().setAttribute("loginUser", user);
                
                out.print("{\"code\":0,\"msg\":\"上传成功\",\"data\":\"" + newAvatarPath + "\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"更新失败\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
} 