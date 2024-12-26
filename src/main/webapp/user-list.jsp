<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/common/layui/css/layui.css">
    <style>
        .layui-table-tool-temp {
            padding-right: 0;
        }
        .layui-table-tool {
            background-color: #fff;
            padding: 15px;
            border-radius: 4px 4px 0 0;
        }
        .layui-table-view {
            border-radius: 0 0 4px 4px;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 2px;
            font-size: 12px;
        }
        .status-active {
            background-color: #52C41A;
            color: #fff;
        }
        .status-disabled {
            background-color: #999;
            color: #fff;
        }
        .layui-card-header {
            padding: 15px;
            border-radius: 4px 4px 0 0;
            background-color: #fff;
        }
        .layui-card-header .title {
            font-size: 16px;
            font-weight: bold;
        }
        .layui-btn-group {
            margin-left: auto;
        }
    </style>
</head>
<body>
    <div class="layui-card">
        <div class="layui-card-header" style="display: flex; justify-content: space-between; align-items: center;">
            <div class="title">用户列表</div>
            <div class="layui-btn-group" style="margin-right: 10px;">
                <button class="layui-btn layui-btn-normal" id="addUser">
                    <i class="layui-icon">&#xe654;</i> 添加用户
                </button>
                <button class="layui-btn layui-btn-primary" id="refreshTable">
                    <i class="layui-icon">&#xe669;</i> 刷新
                </button>
            </div>
        </div>
        <div class="layui-card-body">
            <!-- 搜索框 -->
            <div class="search-box">
                <form class="layui-form" lay-filter="searchForm">
                    <div class="layui-row layui-col-space15">
                        <div class="layui-col-md3">
                            <div class="layui-input-wrap">
                                <input type="text" name="username" placeholder="请输入用户名" autocomplete="off" class="layui-input">
                                <i class="layui-icon layui-input-icon">&#xe615;</i>
                            </div>
                        </div>
                        <div class="layui-col-md3">
                            <div class="layui-input-wrap">
                                <input type="text" name="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                                <i class="layui-icon layui-input-icon">&#xe615;</i>
                            </div>
                        </div>
                        <div class="layui-col-md2">
                            <select name="status" lay-verify="">
                                <option value="">全部状态</option>
                                <option value="active">正常</option>
                                <option value="disabled">禁用</option>
                            </select>
                        </div>
                        <div class="layui-col-md4">
                            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="searchSubmit">
                                <i class="layui-icon">&#xe615;</i> 搜索
                            </button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- 数据表格 -->
            <table id="userTable" lay-filter="userTable"></table>
        </div>
    </div>

    <!-- 表格工具栏模板 -->
    <script type="text/html" id="tableToolbar">
        <div class="layui-btn-container">
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="batchDelete">
                <i class="layui-icon">&#xe640;</i> 批量删除
            </button>
        </div>
    </script>

    <!-- 表格行工具栏模板 -->
    <script type="text/html" id="tableRowBar">
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-xs" lay-event="edit">
                <i class="layui-icon">&#xe642;</i> 编辑
            </button>
            <button class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">
                <i class="layui-icon">&#xe640;</i> 删除
            </button>
            {{# if(d.status === 'active'){ }}
            <button class="layui-btn layui-btn-xs layui-btn-warm" lay-event="disable">
                <i class="layui-icon">&#xe69c;</i> 禁用
            </button>
            {{# } else { }}
            <button class="layui-btn layui-btn-xs layui-btn-normal" lay-event="enable">
                <i class="layui-icon">&#xe605;</i> 启用
            </button>
            {{# } }}
        </div>
    </script>

    <!-- 状态模板 -->
    <script type="text/html" id="statusTpl">
        {{# if(d.status === 'active'){ }}
        <span class="status-badge status-active">正常</span>
        {{# } else { }}
        <span class="status-badge status-disabled">禁用</span>
        {{# } }}
    </script>

    <script src="${pageContext.request.contextPath}/static/common/layui/layui.js"></script>
    <script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table,
            form = layui.form,
            layer = layui.layer,
            $ = layui.jquery;

        // 初始化表格
        table.render({
            elem: '#userTable'
            ,url: 'user/list'
            ,toolbar: '#tableToolbar'
            ,defaultToolbar: ['filter', 'exports', 'print']
            ,cols: [[
                {type: 'checkbox', fixed: 'left'}
                ,{field: 'id', title: 'ID', width: 80, sort: true, align: 'center'}
                ,{field: 'username', title: '用户名', width: 120}
                ,{field: 'email', title: '邮箱', width: 180}
                ,{field: 'phone', title: '手机号', width: 120}
                ,{field: 'fullName', title: '姓名', width: 100}
                ,{field: 'status', title: '状态', width: 100, templet: '#statusTpl', align: 'center'}
                ,{field: 'registrationDate', title: '注册时间', width: 160, sort: true}
                ,{field: 'lastLogin', title: '最后登录', width: 160, sort: true}
                ,{fixed: 'right', title: '操作', toolbar: '#tableRowBar', width: 200, align: 'center'}
            ]]
            ,page: true
            ,limit: 10
            ,limits: [10, 20, 50, 100]
            ,skin: 'line'
            ,even: true
            ,size: 'lg'
        });

        // 表格工具栏事件
        table.on('toolbar(userTable)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'batchDelete':
                    var data = checkStatus.data;
                    if(data.length === 0){
                        layer.msg('请选择要删除的用户');
                        return;
                    }
                    layer.confirm('确定删除选中的用户吗？', function(index){
                        // 执行批量删除
                        layer.close(index);
                    });
                    break;
                case 'refresh':
                    table.reload('userTable');
                    break;
            }
        });

        // 表格行工具事件
        table.on('tool(userTable)', function(obj){
            var data = obj.data;
            switch(obj.event){
                case 'edit':
                    console.log('编辑按钮被点击，用户数据：', data);  // 调试日志
                    layer.open({
                        type: 2,
                        title: '编辑用户',
                        content: 'user-edit.jsp?id=' + data.id,
                        area: ['500px', '400px'],
                        maxmin: true,
                        success: function(layero, index){
                            console.log('弹窗打开成功');  // 调试日志
                        }
                    });
                    break;
                    
                case 'del':
                    layer.confirm('确定删除该用户吗？', function(index){
                        $.ajax({
                            url: 'user/delete',
                            type: 'POST',
                            data: { id: data.id },
                            success: function(res){
                                if(res.code === 0){
                                    layer.msg('删除成功', {icon: 1});
                                    obj.del();
                                } else {
                                    layer.msg(res.msg || '删除失败', {icon: 2});
                                }
                            }
                        });
                        layer.close(index);
                    });
                    break;
                    
                case 'disable':
                case 'enable':
                    var action = obj.event === 'disable' ? '禁用' : '启用';
                    var newStatus = obj.event === 'disable' ? 'inactive' : 'active';
                    
                    layer.confirm('确定要' + action + '该用户吗？', function(index){
                        $.ajax({
                            url: 'user/status',
                            type: 'POST',
                            data: {
                                id: data.id,
                                status: newStatus
                            },
                            success: function(res){
                                if(res.code === 0){
                                    layer.msg(action + '成功', {icon: 1});
                                    table.reload('userTable');
                                } else {
                                    layer.msg(res.msg || action + '失败', {icon: 2});
                                }
                            }
                        });
                        layer.close(index);
                    });
                    break;
            }
        });

        // 搜索表单提交
        form.on('submit(searchSubmit)', function(data){
            table.reload('userTable', {
                where: data.field,
                page: {curr: 1}
            });
            return false;
        });

        // 添加用户按钮事件监听
        $(document).on('click', '#addUser', function(){
            console.log('添加用户按钮被点击');
            layer.open({
                type: 2,
                title: '添加用户',
                shade: 0.6,
                area: ['500px', '450px'],
                content: 'user-add.jsp',
                success: function(layero, index){
                    console.log('弹窗打开成功');
                },
                end: function() {
                    table.reload('userTable');
                }
            });
        });

        // 刷新按钮事件监听
        $(document).on('click', '#refreshTable', function(){
            console.log('刷新按钮被点击');
            table.reload('userTable', {
                page: {
                    curr: 1
                }
            });
        });
    });
    </script>
</body>
</html> 