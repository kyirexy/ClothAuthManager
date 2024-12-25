<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css">
    <style>
        body {
            padding: 15px;
            background-color: #f6f6f6;
            margin: 0;
        }
        .layui-card {
            margin: 0;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
            border-radius: 4px;
        }
        .main-header {
            background-color: #2F4056;
            color: #fff;
            padding: 15px 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,.1);
        }
        .header-title {
            font-size: 20px;
            font-weight: 400;
            margin: 0;
        }
        .header-breadcrumb {
            margin-top: 8px;
            color: #CFD2D4;
        }
        .header-breadcrumb a {
            color: #CFD2D4;
        }
        .header-breadcrumb a:hover {
            color: #fff;
        }
        .layui-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #f6f6f6;
        }
        .layui-card-header .title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
        }
        .search-box {
            margin-bottom: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 4px;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
        }
        .search-box .layui-form-item {
            margin-bottom: 0;
        }
        .layui-btn {
            border-radius: 3px;
        }
        .layui-btn-normal {
            background-color: #1E9FFF;
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
    </style>
</head>
<body>
    <div class="layui-card">
        <div class="layui-card-header">
            <div class="title">用户列表</div>
            <div class="layui-btn-group">
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

    <script src="static/common/layui/layui.js"></script>
    <script>
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table,
            form = layui.form,
            layer = layui.layer;

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
                    layer.open({
                        type: 2,
                        title: '编辑用户',
                        content: 'user-edit.jsp?id=' + data.id,
                        area: ['500px', '400px'],
                        maxmin: true
                    });
                    break;
                case 'del':
                    layer.confirm('确定删除该用户吗？', function(index){
                        // 执行删除
                        layer.close(index);
                    });
                    break;
                case 'disable':
                case 'enable':
                    var action = obj.event === 'disable' ? '禁用' : '启用';
                    layer.confirm('确定' + action + '该用户吗？', function(index){
                        // 执行状态更新
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

        // 添加用户按钮点击事件
        $('#addUser').on('click', function(){
            layer.open({
                type: 2,
                title: '添加用户',
                content: 'user-add.jsp',
                area: ['500px', '400px'],
                maxmin: true
            });
        });
    });
    </script>
</body>
</html> 