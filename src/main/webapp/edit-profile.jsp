<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.Admin" %>
<%@ page import="com.example.model.User" %>
<%
    Admin admin = (Admin) session.getAttribute("loginAdmin");
    User user = (User) session.getAttribute("loginUser");
    String email = "";
    String phone = "";
    
    if (admin != null) {
        email = admin.getEmail();
        phone = admin.getPhone();
    } else if (user != null) {
        email = user.getEmail();
        phone = user.getPhone();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改个人信息</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
    <script src="static/common/layui/layui.js"></script>
    <style>
        .layui-form {
            padding: 20px;
        }
        .layui-form-item {
            margin-bottom: 25px;
        }
        .layui-input {
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <form class="layui-form" lay-filter="editProfileForm">
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="text" name="email" value="<%= email %>" required 
                       lay-verify="required|email" placeholder="请输入邮箱" 
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="phone" value="<%= phone %>" required 
                       lay-verify="required|phone" placeholder="请输入手机号" 
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="editProfileSubmit">
                    <i class="layui-icon layui-icon-ok"></i> 保存修改
                </button>
                <button type="reset" class="layui-btn layui-btn-primary">
                    <i class="layui-icon layui-icon-refresh"></i> 重置
                </button>
            </div>
        </div>
    </form>

    <script>
    layui.use(['form', 'layer', 'jquery'], function(){
        var form = layui.form,
            layer = layui.layer,
            $ = layui.jquery;
        
        form.on('submit(editProfileSubmit)', function(data){
            var loadIndex = layer.load(2);
            $.ajax({
                url: 'updateProfile',
                type: 'POST',
                data: data.field,
                success: function(res){
                    layer.close(loadIndex);
                    if(res.code === 0){
                        layer.msg('修改成功', {icon: 1, time: 1000}, function(){
                            // 关闭当前弹窗
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(res.msg || '修改失败', {icon: 2});
                    }
                },
                error: function(){
                    layer.close(loadIndex);
                    layer.msg('服务器错误', {icon: 2});
                }
            });
            return false;
        });
    });
    </script>
</body>
</html> 