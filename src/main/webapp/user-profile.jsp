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
            max-width: 1000px;
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
            text-align: center;
            margin-top: 30px;
        }
        .layui-btn {
            padding: 0 30px;
            height: 38px;
            line-height: 38px;
            border-radius: 19px;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <img src="<%= avatar != null && !avatar.isEmpty() ? avatar : "static/images/default-avatar.jpg" %>" 
                     class="avatar" id="currentAvatar">
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
                <button class="layui-btn" onclick="editProfile()">
                    <i class="layui-icon layui-icon-edit"></i> 修改信息
                </button>
                <button class="layui-btn layui-btn-primary" onclick="changePassword()">
                    <i class="layui-icon layui-icon-password"></i> 修改密码
                </button>
            </div>
        </div>
    </div>

    <script src="static/common/layui/layui.js"></script>
    <script>
    layui.use(['upload', 'layer'], function(){
        var upload = layui.upload,
            layer = layui.layer;
        
        // 头像上传
        upload.render({
            elem: '#uploadAvatar'
            ,url: 'uploadAvatar'
            ,accept: 'images'
            ,acceptMime: 'image/*'
            ,size: 5120
            ,before: function(){
                layer.load();
            }
            ,done: function(res){
                layer.closeAll('loading');
                if(res.code === 0){
                    layer.msg('上传成功', {icon: 1});
                    document.getElementById('currentAvatar').src = res.data + '?t=' + new Date().getTime();
                    if(window.parent && window.parent.updateAvatar){
                        window.parent.updateAvatar(res.data);
                    }
                    setTimeout(function(){
                        location.reload();
                    }, 1000);
                } else {
                    layer.msg(res.msg || '上传失败', {icon: 2});
                }
            }
            ,error: function(){
                layer.closeAll('loading');
                layer.msg('上传失败', {icon: 2});
            }
        });
    });
    
    // 修改信息
    function editProfile() {
        layer.open({
            type: 2,
            title: '修改个人信息',
            area: ['500px', '400px'],
            content: 'edit-profile.jsp',
            maxmin: true,
            end: function() {
                // 刷新页面以更新信息
                location.reload();
            }
        });
    }
    
    // 修改密码
    function changePassword() {
        layer.open({
            type: 2,
            title: '修改密码',
            area: ['500px', '350px'],
            content: 'change-password.jsp',
            maxmin: true
        });
    }
    </script>
</body>
</html>

