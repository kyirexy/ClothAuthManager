<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.model.User" %>
<%
    Admin admin = (Admin) session.getAttribute("loginAdmin");
    User user = (User) session.getAttribute("loginUser");
    String username = "";
    String role = "";
    String email = "";
    String phone = "";
    String avatar = "";
    
    if (admin != null) {
        username = admin.getUsername();
        role = "系统管理员";
        email = admin.getEmail();
        phone = admin.getPhone();
        avatar = admin.getProfilePicture();
    } else if (user != null) {
        username = user.getUsername();
        role = "普通用户";
        email = user.getEmail();
        phone = user.getPhone();
        avatar = user.getProfilePicture();
    }
    if (avatar == null || avatar.isEmpty()) {
        avatar = "static/images/smail.jpg";
    }
    
    // 获取头像路径
    String avatarPath = admin != null ? admin.getProfilePicture() : 
                       (user != null ? user.getProfilePicture() : null);
    
    // 如果没有头像，使用默认头像
    if (avatarPath == null || avatarPath.trim().isEmpty()) {
        avatarPath = "static/images/smail.jpg";
    } else if (avatarPath.startsWith("/")) {
        avatarPath = avatarPath.substring(1);
    }
    // 注意：不需要添加额外的/，因为数据库中已经包含了
    
    // 判断是管理员还是普通用户
    boolean isAdmin = (admin != null);
    String returnUrl = isAdmin ? "admin-dashboard.jsp" : "index.jsp";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
    <style>
        .profile-container {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .profile-header {
            text-align: center;
            padding: 30px 0;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
            margin-bottom: 20px;
        }
        .avatar-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 15px;
        }
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 3px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,.1);
        }
        .avatar-upload {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 36px;
            height: 36px;
            background: #1E9FFF;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,.2);
        }
        .profile-info {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
        }
        .info-group {
            margin-bottom: 25px;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 15px;
        }
        .info-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .info-value {
            color: #333;
            font-size: 16px;
        }
        .action-buttons {
            margin-top: 30px;
            text-align: center;
        }
        .action-buttons .layui-btn {
            margin: 0 10px;
        }
        .layui-btn {
            padding: 0 30px;
            height: 38px;
            line-height: 38px;
            border-radius: 19px;
        }
        .layui-btn-primary {
            border: 1px solid #C9C9C9;
        }
        .layui-btn-primary:hover {
            border-color: #009688;
            color: #009688;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <img src="<%= avatarPath %>" 
                     class="avatar" 
                     id="currentAvatar"
                     onerror="this.src='static/images/smail.jpg'">
                <div class="avatar-upload" id="uploadAvatar">
                    <i class="layui-icon layui-icon-camera"></i>
                </div>
            </div>
            <h2><%= username %></h2>
            <p style="color: #666;"><%= role %></p>
        </div>
        
        <div class="profile-info">
            <div class="info-group">
                <div class="info-label">用户名</div>
                <div class="info-value"><%= username %></div>
            </div>
            <div class="info-group">
                <div class="info-label">邮箱</div>
                <div class="info-value"><%= email %></div>
            </div>
            <div class="info-group">
                <div class="info-label">手机号</div>
                <div class="info-value"><%= phone %></div>
            </div>
            
            <div class="action-buttons">
                <button type="button" class="layui-btn" onclick="openEditProfile()">编辑资料</button>
                <button type="button" class="layui-btn layui-btn-normal" onclick="openChangePassword()">修改密码</button>
                <button type="button" class="layui-btn layui-btn-primary" onclick="returnToMain()">返回</button>
            </div>
        </div>
    </div>

    <script src="static/common/layui/layui.js"></script>
    <script>
    layui.use(['upload', 'layer'], function(){
        var upload = layui.upload,
            layer = layui.layer;
        
        upload.render({
            elem: '#uploadAvatar'
            ,url: 'uploadAvatar'
            ,accept: 'images'
            ,acceptMime: 'image/*'
            ,done: function(res){
                if(res.code === 0){
                    layer.msg('上传成功', {icon: 1});
                    // 移除前导的/
                    var avatarPath = res.data;
                    if (avatarPath.startsWith('/')) {
                        avatarPath = avatarPath.substring(1);
                    }

                    // 更新当前页面的头像
                    document.getElementById('currentAvatar').src = avatarPath + '?t=' + new Date().getTime();

                    // 更新父窗口的头像
                    if (window.parent && window.parent.updateAdminAvatar) {
                        window.parent.updateAdminAvatar(avatarPath);
                    }

                    // 更新顶层窗口的头像
                    if (window.top && window.top.updateAdminAvatar) {
                        window.top.updateAdminAvatar(avatarPath);
                    }
                } else {
                    layer.msg(res.msg || '上传失败', {icon: 2});
                }
            }
            ,error: function(){
                layer.msg('上传失败', {icon: 2});
            }
        });
        
        // 修改返回方法
        window.returnToMain = function() {
            var isAdmin = <%= isAdmin %>;
            console.log("Is Admin:", isAdmin);
            
            try {
                // 如果在iframe中
                if (window.parent && window.parent !== window) {
                    // 获取顶层窗口
                    var topWindow = window.top;
                    // 直接在顶层窗口进行跳转
                    topWindow.location.href = '<%= returnUrl %>';
                } else {
                    // 如果不在iframe中，直接跳转
                    window.location.href = '<%= returnUrl %>';
                }
            } catch (e) {
                console.error("Return error:", e);
                // 发生错误时直接跳转
                window.location.href = '<%= returnUrl %>';
            }
        };
        
        // 返回按钮点击事件
        $(document).on('click', '.layui-btn-primary', function() {
            returnToMain();
        });
        
        // 打开编辑资料窗口
        window.openEditProfile = function() {
            layer.open({
                type: 2,
                title: '编辑个人资料',
                shade: 0.6,
                area: ['500px', '400px'],
                content: 'edit-profile.jsp'
            });
        };
        
        // 打开修改密码窗口
        window.openChangePassword = function() {
            layer.open({
                type: 2,
                title: '修改密码',
                shade: 0.6,
                area: ['500px', '300px'],
                content: 'change-password.jsp'
            });
        };
    });
    
    // 添加一个直接的返回函数
    function returnToMain() {
        var isAdmin = <%= isAdmin %>;
        console.log("Direct return - Is Admin:", isAdmin); // 调试信息
        window.location.href = '<%= returnUrl %>';
    }
    
    // 编辑资料方法
    function editProfile() {
        layer.msg('编辑资料功能开发中...', {icon: 0});
    }
    
    // 修改密码方法
    function changePassword() {
        layer.msg('修改密码功能开发中...', {icon: 0});
    }
    </script>
</body>
</html>

