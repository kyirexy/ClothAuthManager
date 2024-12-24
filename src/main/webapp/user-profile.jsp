<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人信息 - 时尚服装购物网站</title>
    <link rel="stylesheet" href="static/layui/css/layui.css"/>
    <script src="static/layui/layui.js"></script>
    <style>
        body {
            background-color: #f5f5f5;
            padding: 20px;
        }
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }
        .back-btn {
            position: absolute;
            left: 0;
            top: 0;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 60px;
            margin: 0 auto 20px;
            display: block;
            border: 4px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            object-fit: cover;
        }
        .profile-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 30px;
        }
        .info-section {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .info-title {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .layui-form-label {
            width: 100px;
        }
        .layui-input-block {
            margin-left: 130px;
        }
        .action-buttons {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("loginUser");
        if (user != null) {
    %>
    <div class="profile-container">
        <div class="profile-header">
            <button class="layui-btn layui-btn-primary back-btn" onclick="window.location.href='index.jsp'">
                <i class="layui-icon layui-icon-left"></i> 返回首页
            </button>
            <img src="<%= user.getProfilePicture() %>" 
                 alt="用户头像" 
                 class="profile-avatar"
                 onerror="this.src='static/images/smail.jpg'">
            <h1 class="profile-title">个人信息</h1>
        </div>

        <form class="layui-form" action="updateProfile" method="post">
            <div class="info-section">
                <h2 class="info-title">基本信息</h2>
                <div class="layui-form-item">
                    <label class="layui-form-label">用户名</label>
                    <div class="layui-input-block">
                        <input type="text" name="username" value="<%= user.getUsername() %>" 
                               class="layui-input" readonly>
                    </div>
                </div>
                
                <div class="layui-form-item">
                    <label class="layui-form-label">邮箱</label>
                    <div class="layui-input-block">
                        <input type="email" name="email" value="<%= user.getEmail() %>" 
                               required lay-verify="required|email" 
                               placeholder="请输入邮箱" class="layui-input">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">性别</label>
                    <div class="layui-input-block">
                        <input type="radio" name="gender" value="M" title="男" <%= "M".equals(user.getGender()) ? "checked" : "" %>>
                        <input type="radio" name="gender" value="F" title="女" <%= "F".equals(user.getGender()) ? "checked" : "" %>>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h2 class="info-title">联系方式</h2>
                <div class="layui-form-item">
                    <label class="layui-form-label">手机号码</label>
                    <div class="layui-input-block">
                        <input type="text" name="phone" value="<%= user.getPhone() %>" 
                               required lay-verify="required|phone" 
                               placeholder="请输入手机号" class="layui-input">
                    </div>
                </div>
            </div>

            <div class="info-section">
                <h2 class="info-title">头像设置</h2>
                <div class="layui-form-item">
                    <label class="layui-form-label">更换头像</label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn" id="uploadAvatar">
                            <i class="layui-icon layui-icon-upload"></i> 上传图片
                        </button>
                        <div class="layui-form-mid layui-word-aux">支持jpg、png格式，大小不超过2MB</div>
                    </div>
                </div>
            </div>

            <div class="action-buttons">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="updateProfile">
                    <i class="layui-icon layui-icon-ok"></i> 保存修改
                </button>
                <button type="button" class="layui-btn layui-btn-primary" onclick="window.location.href='index.jsp'">
                    <i class="layui-icon layui-icon-close"></i> 取消
                </button>
            </div>
        </form>
    </div>

    <script>
    layui.use(['form', 'upload', 'layer'], function(){
        var form = layui.form,
            upload = layui.upload,
            layer = layui.layer,
            $ = layui.jquery;

        // 头像上传
        upload.render({
            elem: '#uploadAvatar',
            url: 'uploadAvatar',
            accept: 'images',
            acceptMime: 'image/*',
            size: 2048,
            done: function(res){
                if(res.code === 0){
                    layer.msg('上传成功', {icon: 1});
                    $('.profile-avatar').attr('src', res.data.src);
                } else {
                    layer.msg(res.msg || '上传失败', {icon: 2});
                }
            }
        });

        // 表单提交
        form.on('submit(updateProfile)', function(data){
            $.ajax({
                url: 'updateProfile',
                type: 'POST',
                data: data.field,
                success: function(res){
                    if(res.code === 0){
                        layer.msg('更新成功', {
                            icon: 1,
                            time: 1500
                        }, function(){
                            window.location.reload();
                        });
                    } else {
                        layer.msg(res.msg || '更新失败', {icon: 2});
                    }
                },
                error: function(){
                    layer.msg('服务器错误，请稍后重试', {icon: 2});
                }
            });
            return false;
        });
    });
    </script>
    <%
        } else {
    %>
    <div class="profile-container">
        <div class="layui-card">
            <div class="layui-card-header">提示</div>
            <div class="layui-card-body">
                请先登录后查看个人信息
                <div style="margin-top: 15px;">
                    <a href="index.jsp" class="layui-btn">返回首页</a>
                </div>
            </div>
        </div>
    </div>
    <%
        }
    %>
</body>
</html>

