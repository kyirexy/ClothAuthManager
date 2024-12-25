package com.example.servlet;

import com.example.dao.AdminDAO;
import com.example.dao.UserDAO;
import com.example.model.Admin;
import com.example.model.User;
import com.example.util.FileUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/uploadAvatar")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 5,      // 5MB
    maxRequestSize = 1024 * 1024 * 10    // 10MB
)
public class UploadAvatarServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    public void init() throws ServletException {
        super.init();
        FileUtil.setServletContext(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            Part filePart = request.getPart("file");
            
            // 验证文件类型
            if (!FileUtil.isImageFile(filePart)) {
                out.print("{\"code\":1,\"msg\":\"请上传图片文件\"}");
                return;
            }
            
            // 保存图片
            String newAvatarPath = FileUtil.saveImage(filePart);
            System.out.println("New avatar path: " + newAvatarPath);
            
            // 更新数据库
            boolean updated = false;
            HttpSession session = request.getSession();
            Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
            User loginUser = (User) session.getAttribute("loginUser");
            
            if (loginAdmin != null) {
                System.out.println("Updating admin avatar...");
                updated = adminDAO.updateAvatar(loginAdmin.getId(), newAvatarPath);
                if (updated) {
                    loginAdmin.setProfilePicture(newAvatarPath);
                    session.setAttribute("loginAdmin", loginAdmin);
                }
            } else if (loginUser != null) {
                System.out.println("Updating user avatar...");
                updated = userDAO.updateAvatar(loginUser.getId(), newAvatarPath);
                if (updated) {
                    loginUser.setProfilePicture(newAvatarPath);
                    session.setAttribute("loginUser", loginUser);
                }
            }
            
            if (updated) {
                out.print("{\"code\":0,\"msg\":\"上传成功\",\"data\":\"" + newAvatarPath + "\"}");
            } else {
                out.print("{\"code\":1,\"msg\":\"更新失败，请检查用户登录状态\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"code\":1,\"msg\":\"上传失败: " + e.getMessage() + "\"}");
        }
    }
} 