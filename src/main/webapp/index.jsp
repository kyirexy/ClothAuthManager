<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>时尚服装购物网站</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css"/>
    <script src="static/common/layui/layui.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }
        header {
            background-color: #393D49;
            color: white;
            padding: 1em;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        nav {
            background-color: #444;
            padding: 0.5em;
            text-align: center;
        }
        nav a {
            color: white;
            text-decoration: none;
            padding: 0.5em 1em;
        }
        main {
            padding: 2em;
            text-align: center;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
        }
        .user-menu {
            position: absolute;
            right: 1em;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            display: none;
        }
        .user-menu a {
            display: block;
            padding: 0.5em 1em;
            color: #333;
            text-decoration: none;
        }
        .user-menu a:hover {
            background-color: #f0f0f0;
        }
        .user-info {
            position: relative;
        }
        .user-avatar {
            transition: all 0.3s;
        }
        .user-avatar:hover {
            transform: scale(1.1);
        }
        .user-menu {
            min-width: 150px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
        .user-menu a {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
        }
        .user-menu a:hover {
            background-color: #f2f2f2;
        }
        .user-info {
            position: relative;
            display: inline-block;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            object-fit: cover;
            border: 2px solid #fff;
        }
        .user-menu {
            position: absolute;
            right: 0;
            top: 45px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
            min-width: 120px;
        }
        .menu-item {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
        }
        .menu-item:last-child {
            border-bottom: none;
        }
        .menu-item a {
            color: #333;
            text-decoration: none;
            display: block;
        }
        .menu-item a:hover {
            color: #009688;
        }
        .layui-layer-page .layui-layer-content {
            overflow: visible !important;
            background-color: #fff;
        }
        .layui-tab {
            margin: 0;
            background-color: #fff;
        }
        .layui-form {
            padding: 20px;
        }
        .layui-form-item:last-child {
            margin-bottom: 0;
        }
        #sign {
            background-color: #fff;
        }
    </style>
</head>
<body>
<header>
    <h1>时尚服装购物网站</h1>
    <div>
        <%
            User loginUser = (User) session.getAttribute("loginUser");
            if (loginUser != null) {
        %>  
        <div class="user-info">
            <img src="<%= loginUser.getProfilePicture() %>" 
                 alt="User Avatar" 
                 class="user-avatar" 
                 id="userAvatar" 
                 onerror="this.src='static/images/smail.jpg'">
            <div class="user-menu" id="userMenu" style="display: none;">
                <div class="menu-item">
                    <span>欢迎，<%= loginUser.getUsername() %></span>
                </div>
                <div class="menu-item">
                    <a href="user-profile.jsp">个人信息</a>
                </div>
                <div class="menu-item">
                    <a href="logout">退出登录</a>
                </div>
            </div>
        </div>
        <%
        } else {
        %>
        <div class="operation layui-pull-right">
            <button type="button" class="layui-btn" id="loginBtn">
                <i class="layui-icon layui-icon-user"></i>登录/注册
            </button>
        </div>
        <%
            }
        %>
    </div>
</header>
<nav>
    <a href="#">首页</a>
    <a href="#">商品分类</a>
    <a href="#">热卖商品</a>
    <a href="#">关于我们</a>
</nav>
<main>
    <h2>欢迎来到时尚服装购物网站</h2>
    <p>这里有最新、最潮的服装等你来选购！</p>
</main>

<!-- 登录注册弹窗 -->
<div id="sign" style="display: none; padding: 20px;">
    <div class="layui-tab layui-tab-brief" lay-filter="user-tab">
        <ul class="layui-tab-title">
            <li class="layui-this">登录</li>
            <li>注册</li>
        </ul>
        <div class="layui-tab-content">
            <!-- 登录表单 -->
            <div class="layui-tab-item layui-show">
                <form class="layui-form" lay-filter="loginForm">
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="text" name="username" required lay-verify="required"
                                   placeholder="用户名/邮箱/手机号" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="password" name="password" required lay-verify="required"
                                   placeholder="密码" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="radio" name="role" value="user" title="用户" checked>
                            <input type="radio" name="role" value="admin" title="管理员">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="login">登录</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- 注册表单 -->
            <div class="layui-tab-item">
                <form class="layui-form" lay-filter="registerForm">
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="text" name="username" required lay-verify="required"
                                   placeholder="请设置用户名" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="password" name="password" required lay-verify="required|pass"
                                   placeholder="请设置密码" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="password" name="repassword" required lay-verify="required|repass"
                                   placeholder="请确认密码" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="text" name="email" required lay-verify="required|email"
                                   placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <input type="text" name="phone" required lay-verify="required|phone"
                                   placeholder="请输入手机号" autocomplete="off" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block" style="margin-left: 0;">
                            <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="register">注册</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<script>
// 将所有的初始化逻辑放在一个统一的初始化函数中
layui.use(['layer', 'form', 'element', 'jquery'], function(){
    var layer = layui.layer,
        form = layui.form,
        element = layui.element,
        $ = layui.jquery;  // 确保使用 layui 的 jQuery

    console.log('layui 初始化完成');

    // 登录按钮点击事件
    $('#loginBtn').on('click', function(){
        console.log('登录按钮被点击');

        // 打开弹窗
        layer.open({
            type: 1,
            title: '登录/注册',
            area: ['360px', 'auto'],
            content: $('#sign'),
            shadeClose: true,
            closeBtn: 1,
            shade: 0.3,
            offset: '100px',
            success: function(layero, index){
                // 重置表单
                $('form[lay-filter="loginForm"]')[0].reset();
                $('form[lay-filter="registerForm"]')[0].reset();

                // 重新渲染表单
                form.render();
            }
        });
    });

    // 监听登录提交
    form.on('submit(login)', function(data){
        var loadIndex = layer.load(1);

        $.ajax({
            url: 'login',
            type: 'POST',
            data: {
                username: data.field.username,
                password: data.field.password,
                role: $('input[name="role"]:checked').val() || 'user'
            },
            dataType: 'json',
            success: function(res){
                layer.close(loadIndex);
                if(res.code === 0){
                    layer.msg('登录成功', {
                        icon: 1,
                        time: 1000
                    }, function(){
                        res.role === 'admin' ?
                            window.location.href = 'admin-dashboard.jsp' :
                            window.location.reload();
                    });
                } else {
                    layer.msg(res.msg, {icon: 2});
                }
            },
            error: function(){
                layer.close(loadIndex);
                layer.msg('服务器错误', {icon: 2});
            }
        });
        return false;
    });

    // 监听注册提交
    form.on('submit(register)', function(data){
        console.log('注册表单提交', data.field);

        // 表单验证
        if(!data.field.username || !data.field.password || !data.field.repassword ||
           !data.field.email || !data.field.phone) {
            layer.msg('请填写完整注册信息', {icon: 2});
            return false;
        }

        if(data.field.password !== data.field.repassword) {
            layer.msg('两次密码输入不一致', {icon: 2});
            return false;
        }

        var loadIndex = layer.load(1);

        $.ajax({
            url: 'register',
            type: 'POST',
            data: data.field,
            dataType: 'json',
            success: function(res){
                layer.close(loadIndex);
                console.log('注册响应:', res);

                if(res.code === 0){
                    // 注册成功后自动登录
                    $.ajax({
                        url: 'login',
                        type: 'POST',
                        data: {
                            username: data.field.username,
                            password: data.field.password,
                            role: 'user'
                        },
                        dataType: 'json',
                        success: function(loginRes){
                            if(loginRes.code === 0){
                                layer.msg('注册成功并已自动登录', {
                                    icon: 1,
                                    time: 1500
                                }, function(){
                                    window.location.reload();
                                });
                            } else {
                                layer.msg('注册成功，请手动登录', {icon: 1});
                                element.tabChange('user-tab', 0);
                            }
                        },
                        error: function(){
                            layer.msg('注册成功，请手动登录', {icon: 1});
                            element.tabChange('user-tab', 0);
                        }
                    });
                } else {
                    layer.msg(res.msg || '注册失败，请重试', {icon: 2});
                }
            },
            error: function(xhr, status, error){
                layer.close(loadIndex);
                console.error('注册请求失败:', error);
                layer.msg('服务器错误，请稍后重试', {icon: 2});
            }
        });
        return false;
    });

    // 头像菜单交互
    $('#userAvatar').on('click', function(e){
        e.stopPropagation();
        console.log('头像被点击');
        $('#userMenu').slideToggle(200);
    });

    // 点击其他区域关闭菜单
    $(document).on('click', function(){
        $('#userMenu').slideUp(200);
    });

    // 防止菜单点击关闭
    $('#userMenu').on('click', function(e){
        e.stopPropagation();
    });
});
</script>
</body>
</html>

