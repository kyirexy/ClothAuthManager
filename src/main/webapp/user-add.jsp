<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加用户</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
    <style>
        .layui-form {
            padding: 20px;
        }
    </style>
</head>
<body>
    <form class="layui-form" lay-filter="addUserForm">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" required lay-verify="required" 
                       placeholder="请输入用户名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <input type="password" name="password" required lay-verify="required" 
                       placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="text" name="email" required lay-verify="required|email" 
                       placeholder="请输入邮箱" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="text" name="phone" required lay-verify="required|phone" 
                       placeholder="请输入手机号" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="addUserSubmit">立即提交</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
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
            username: function(value) {
                if (value.length < 3 || value.length > 20) {
                    return '用户名长度必须在3-20位之间';
                }
            },
            password: [
                /^[\S]{6,12}$/,
                '密码必须6到12位，且不能出现空格'
            ],
            phone: [
                /^1[3-9]\d{9}$/,
                '请输入正确的手机号'
            ]
        });
        
        // 监听提交
        form.on('submit(addUserSubmit)', function(data){
            var loadIndex = layer.load(2);
            $.ajax({
                url: 'user/add',
                type: 'POST',
                data: data.field,
                success: function(res){
                    layer.close(loadIndex);
                    if(res.code === 0){
                        layer.msg('添加成功', {icon: 1, time: 1000}, function(){
                            // 刷新父页面表格
                            parent.layui.table.reload('userTable');
                            // 关闭弹层
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(res.msg || '添加失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error){
                    layer.close(loadIndex);
                    console.error('添加用户失败:', error);
                    layer.msg('服务器错误，添加失败', {icon: 2});
                }
            });
            return false;
        });
    });
    </script>
</body>
</html> 