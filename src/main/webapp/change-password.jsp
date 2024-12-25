<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
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
    <form class="layui-form" lay-filter="changePasswordForm">
        <div class="layui-form-item">
            <label class="layui-form-label">原密码</label>
            <div class="layui-input-block">
                <input type="password" name="oldPassword" required 
                       lay-verify="required" placeholder="请输入原密码" 
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">新密码</label>
            <div class="layui-input-block">
                <input type="password" name="newPassword" required 
                       lay-verify="required|password" placeholder="请输入新密码" 
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">确认密码</label>
            <div class="layui-input-block">
                <input type="password" name="confirmPassword" required 
                       lay-verify="required|confirmPassword" placeholder="请再次输入新密码" 
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="changePasswordSubmit">
                    <i class="layui-icon layui-icon-ok"></i> 确认修改
                </button>
                <button type="reset" class="layui-btn layui-btn-primary">
                    <i class="layui-icon layui-icon-refresh"></i> 重置
                </button>
            </div>
        </div>
    </form>

    <script src="static/common/layui/layui.js"></script>
    <script>
    layui.use(['form', 'layer'], function(){
        var form = layui.form,
            layer = layui.layer,
            $ = layui.jquery;
        
        // 自定义验证规则
        form.verify({
            password: [
                /^[\S]{6,12}$/,
                '密码必须6到12位，且不能出现空格'
            ],
            confirmPassword: function(value) {
                var newPassword = $('input[name=newPassword]').val();
                if(value !== newPassword) {
                    return '两次输入的密码不一致';
                }
            }
        });
        
        // 监听提交
        form.on('submit(changePasswordSubmit)', function(data){
            if(data.field.newPassword === data.field.oldPassword) {
                layer.msg('新密码不能与原密码相同', {icon: 2});
                return false;
            }
            
            var loadIndex = layer.load(2);
            $.ajax({
                url: 'changePassword',
                type: 'POST',
                data: data.field,
                success: function(res){
                    layer.close(loadIndex);
                    if(res.code === 0){
                        layer.msg('密码修改成功，请重新登录', {icon: 1, time: 1500}, function(){
                            // 退出登录
                            window.top.location.href = 'logout';
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