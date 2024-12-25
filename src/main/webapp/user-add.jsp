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
            layer = layui.layer;
        
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