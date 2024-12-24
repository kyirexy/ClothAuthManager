package com.example.dao;

import com.example.model.User;
import com.example.util.DBUtil;

import java.sql.*;

public class UserDAO {
    
    // 默认头像路径
    private static final String DEFAULT_AVATAR = "static/images/smail.jpg";
    
    public User login(String username, String password) {
        String sql = "SELECT * FROM user WHERE (username = ? OR email = ? OR phone = ?) AND password = ? AND status = 'active'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, username);
            pstmt.setString(3, username);
            pstmt.setString(4, password);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setFullName(rs.getString("full_name"));
                user.setGender(rs.getString("gender"));
                user.setAddress(rs.getString("address"));
                user.setStatus(rs.getString("status"));
                user.setProfilePicture(rs.getString("profile_picture"));
                
                // 正确处理枚举类型
                String loginTypeStr = rs.getString("login_type");
                if (loginTypeStr != null) {
                    user.setLoginType(User.LoginType.valueOf(loginTypeStr.toLowerCase()));
                }
                
                // 处理日期
                java.sql.Timestamp lastLoginTime = rs.getTimestamp("last_login");
                if (lastLoginTime != null) {
                    user.setLastLogin(new Date(lastLoginTime.getTime()));
                }
                
                java.sql.Timestamp registrationDate = rs.getTimestamp("registration_date");
                if (registrationDate != null) {
                    user.setRegistrationDate(new Date(registrationDate.getTime()));
                }
                
                // 更新最后登录时间
                updateLastLogin(user.getId());
                
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    private void updateLastLogin(int userId) {
        String sql = "UPDATE user SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public boolean register(User user) {
        String sql = "INSERT INTO user (username, password, email, phone, profile_picture, login_type) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, DEFAULT_AVATAR);
            
            // 设置登录类型
            User.LoginType loginType = user.getLoginType();
            pstmt.setString(6, loginType != null ? loginType.name() : User.LoginType.username.name());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAvatar(int userId, String avatarPath) {
        String sql = "UPDATE user SET profile_picture = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, avatarPath);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE user SET " +
                    "email = ?, " +
                    "phone = ?, " +
                    "gender = ?, " +
                    "full_name = ?, " +
                    "address = ?, " +
                    "status = ?, " +
                    "profile_picture = ?, " +
                    "login_type = ? " +
                    "WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getEmail());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getGender());
            pstmt.setString(4, user.getFullName());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getStatus());
            pstmt.setString(7, user.getProfilePicture());
            
            // 处理枚举类型
            User.LoginType loginType = user.getLoginType();
            pstmt.setString(8, loginType != null ? loginType.name() : null);
            
            pstmt.setInt(9, user.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private User.LoginType mapLoginType(String dbValue) {
        if (dbValue == null) return null;
        try {
            return User.LoginType.valueOf(dbValue.toLowerCase());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return User.LoginType.username; // 默认使用用户名登录
        }
    }

}