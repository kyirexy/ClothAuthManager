package com.example.dao;

import com.example.model.Admin;
import com.example.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import java.sql.Timestamp;

public class AdminDAO {
    public Admin login(String username, String password) {
        String sql = "SELECT * FROM admin WHERE (username = ? OR email = ? OR phone = ?) AND password = ? AND status = 'active'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, username);
            pstmt.setString(3, username);
            pstmt.setString(4, password);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setEmail(rs.getString("email"));
                admin.setPhone(rs.getString("phone"));
                admin.setRole(rs.getString("role"));
                admin.setFullName(rs.getString("full_name"));
                admin.setStatus(rs.getString("status"));
                admin.setProfilePicture(rs.getString("profile_picture"));
                
                // 正确处理枚举类型
                String loginTypeStr = rs.getString("login_type");
                if (loginTypeStr != null) {
                    admin.setLoginType(Admin.LoginType.valueOf(loginTypeStr.toLowerCase()));
                }
                
                // 处理日期
                Timestamp lastLoginTime = rs.getTimestamp("last_login");
                if (lastLoginTime != null) {
                    admin.setLastLogin(new Date(lastLoginTime.getTime()));
                }
                
                // 更新最后登录时间
                updateLastLogin(admin.getId());
                
                return admin;
            }
        } catch (Exception e) {
            System.err.println("Error in admin login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private void updateLastLogin(int adminId) {
        String sql = "UPDATE admin SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, adminId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admin SET email = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, admin.getEmail());
            pstmt.setString(2, admin.getPhone());
            pstmt.setInt(3, admin.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean verifyPassword(int adminId, String password) {
        String sql = "SELECT password FROM admin WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return password.equals(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int adminId, String newPassword) {
        String sql = "UPDATE admin SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(int adminId, String avatarPath) {
        String sql = "UPDATE admin SET profile_picture = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, avatarPath);
            pstmt.setInt(2, adminId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}