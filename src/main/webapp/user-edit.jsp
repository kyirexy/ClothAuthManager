<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑用户</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/common/layui/css/layui.css">
</head>
<body>
    <form class="layui-form" lay-filter="editUserForm" style="padding: 20px;">
        <input type="hidden" name="id" value="${param.id}">
        
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" required lay-verify="required" 
                       placeholder="请输入用户名" autocomplete="off" class="layui-input">
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
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <select name="status" lay-verify="required">
                    <option value="active">正常</option>
                    <option value="inactive">禁用</option>
                </select>
            </div>
        </div>
        
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="editUserSubmit">保存</button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>

    <script src="${pageContext.request.contextPath}/static/common/layui/layui.js"></script>
    <script>
    layui.use(['form', 'layer'], function(){
        var form = layui.form,
            layer = layui.layer,
            $ = layui.jquery;
        
        // 获取用户ID并加载数据
        var userId = $('input[name="id"]').val();
        console.log('当前编辑的用户ID:', userId);  // 调试日志
        
        if (userId) {
            // 加载用户数据
            $.ajax({
                url: 'user/get',
                type: 'GET',
                data: { id: userId },
                success: function(res){
                    console.log('获取到的用户数据:', res);  // 调试日志
                    if(res.code === 0 && res.data){
                        form.val('editUserForm', res.data);
                        form.render();
                    } else {
                        layer.msg(res.msg || '加载用户数据失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error){
                    console.error('加载用户数据失败:', error);  // 调试日志
                    layer.msg('服务器错误', {icon: 2});
                }
            });
        }
        
        // 监听提交
        form.on('submit(editUserSubmit)', function(data){
            console.log('提交的表单数据:', data.field);  // 调试日志
            $.ajax({
                url: 'user/update',
                type: 'POST',
                data: data.field,
                success: function(res){
                    if(res.code === 0){
                        layer.msg('修改成功', {icon: 1, time: 1000}, function(){
                            // 刷新父页面表格
                            parent.layui.table.reload('userTable');
                            // 关闭弹层
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(res.msg || '修改失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error){
                    console.error('更新失败:', error);  // 调试日志
                    layer.msg('服务器错误', {icon: 2});
                }
            });
            return false;
        });
    });
    </script>
</body>
</html> 