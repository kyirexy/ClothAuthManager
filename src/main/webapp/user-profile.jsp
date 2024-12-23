<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户个人信息 - 时尚服装购物网站</title>
    <link rel="stylesheet" href="static/layui/css/layui.css"/>
    <script src="static/layui/layui.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }
        .container {
            max-width: 800px;
            margin: 2em auto;
            padding: 2em;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 1em;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>用户个人信息</h1>
    <%
        User user = (User) session.getAttribute("loginUser");
        if (user != null) {
    %>
    <img src="<%= user.getAvatarUrl() %>" alt="User Avatar" class="user-avatar">
    <form class="layui-form" action="updateProfile" method="post">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" value="<%= user.getUsername() %>" required lay-verify="required" class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="email" name="email" value="<%= user.getEmail() %>" required lay-verify="required|email" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="phone" value="<%= user.getPhone() %>" required lay-verify="required|phone" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="updateProfile">更新信息</button>
            </div>
        </div>
    </form>
    <%
    } else {
    %>
    <p>请先登录查看个人信息。</p>
    <a href="index.jsp" class="layui-btn">返回首页</a>
    <%
        }
    %>
</div>

<script>
    layui.use(['form'], function() {
        var form = layui.form;

        form.on('submit(updateProfile)', function(data) {
            layui.jquery.ajax({
                url: 'updateProfile',
                type: 'POST',
                data: data.field,
                success: function(res) {
                    if (res.code === 0) {
                        layer.msg('更新成功', {icon: 1});
                    } else {
                        layer.msg(res.msg || '更新失败', {icon: 2});
                    }
                },
                error: function() {
                    layer.msg('服务器错误，请稍后重试', {icon: 2});
                }
            });
            return false;
        });
    });
</script>
</body>
</html>

