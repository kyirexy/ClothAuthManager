package com.example.servlet;

import com.example.dao.UserDAO;
import com.example.dao.AdminDAO;
import com.example.model.User;
import com.example.model.Admin;
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
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class UploadAvatarServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 获取当前登录用户
            User user = (User) request.getSession().getAttribute("loginUser");
            Admin admin = (Admin) request.getSession().getAttribute("loginAdmin");
            
            if (user == null && admin == null) {
                out.print("{\"code\":1,\"msg\":\"请先登录\"}");
                return;
            }

            // 获取上传的文件
            Part filePart = request.getPart("file");
            if (filePart == null) {
                out.print("{\"code\":1,\"msg\":\"请选择文件\"}");
                return;
            }

            // 验证文件类型
            if (!FileUtil.isImageFile(filePart)) {
                out.print("{\"code\":1,\"msg\":\"请上传图片文件\"}");
                return;
            }

            // 删除旧头像
            if (user != null && user.getProfilePicture() != null) {
                FileUtil.deleteImage(user.getProfilePicture());
            } else if (admin != null && admin.getProfilePicture() != null) {
                FileUtil.deleteImage(admin.getProfilePicture());
            }

            // 保存新头像
            String newAvatarPath = FileUtil.saveImage(filePart);
            boolean updated = false;

            // 更新数据库
            if (user != null) {
                user.setProfilePicture(newAvatarPath);
                updated = userDAO.updateAvatar(user.getId(), newAvatarPath);
                if (updated) {
                    request.getSession().setAttribute("loginUser", user);
                }
            } else if (admin != null) {
                admin.setProfilePicture(newAvatarPath);
                updated = adminDAO.updateAvatar(admin.getId(), newAvatarPath);
                if (updated) {
                    request.getSession().setAttribute("loginAdmin", admin);
                }
            }
            
            if (updated) {
                String avatarUrl = newAvatarPath + "?t=" + System.currentTimeMillis();
                out.print("{\"code\":0,\"msg\":\"上传成功\",\"data\":\"" + avatarUrl + "\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"更新失败\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"" + e.getMessage() + "\"}");
        }
    }
} 