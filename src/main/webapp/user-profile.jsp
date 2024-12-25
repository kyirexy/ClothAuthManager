<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.model.User" %>
<%
    // 获取session中的用户信息
    Admin admin = (Admin) session.getAttribute("loginAdmin");
    User user = (User) session.getAttribute("loginUser");
    String username = "";
    String role = "";
    String email = "";
    String phone = "";
    
    if (admin != null) {
        username = admin.getUsername();
        role = "系统管理员";
        email = admin.getEmail();
        phone = admin.getPhone();
    } else if (user != null) {
        username = user.getUsername();
        role = "普通用户";
        email = user.getEmail();
        phone = user.getPhone();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
    <style>
        body {
            padding: 15px;
            background-color: #f6f6f6;
        }
        .layui-card {
            margin-bottom: 15px;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
            border-radius: 4px;
        }
        .user-info-header {
            text-align: center;
            padding: 30px 0;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 15px;
        }
        .info-item {
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-label {
            color: #666;
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <div class="layui-card">
        <div class="layui-card-header">
            <span class="layui-icon layui-icon-user"></span> 个人信息
        </div>
        <div class="layui-card-body">
            <div class="user-info-header">
                <img src="static/images/avatar.jpg" class="user-avatar">
                <h2><%= username %></h2>
            </div>
            
            <div class="layui-form">
                <div class="info-item">
                    <span class="info-label">用户名：</span>
                    <span><%= username %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">角色：</span>
                    <span><%= role %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">邮箱：</span>
                    <span><%= email %></span>
                </div>
                <div class="info-item">
                    <span class="info-label">手机号：</span>
                    <span><%= phone %></span>
                </div>
                
                <div style="margin-top: 30px; text-align: center;">
                    <button class="layui-btn" onclick="editInfo()">
                        <i class="layui-icon">&#xe642;</i> 修改信息
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="static/common/layui/layui.js"></script>
    <script>
    layui.use(['layer'], function(){
        var layer = layui.layer;
    });
    
    function editInfo() {
        layer.open({
            type: 2,
            title: '修改个人信息',
            area: ['500px', '400px'],
            content: 'edit-profile.jsp',
            maxmin: true
        });
    }
    </script>
</body>
</html>

