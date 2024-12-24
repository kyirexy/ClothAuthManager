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
        }
        .layui-tab {
            margin: 0;
        }
        .layui-form {
            padding: 20px;
        }
        .layui-form-item:last-child {
            margin-bottom: 0;
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

<!-- 在用户信息部分添加头像上传功能 -->
<div class="layui-upload">
    <button type="button" class="layui-btn" id="uploadAvatar">
        <i class="layui-icon">&#xe67c;</i>上传头像
    </button>
    <div class="layui-upload-list">
        <img class="layui-upload-img" id="previewImg" src="${loginUser.profilePicture}">
        <p id="uploadText"></p>
    </div>
</div>

<script>
// 确保只初始化一次
var initialized = false;

layui.use(['layer', 'form', 'element'], function(){
    if (initialized) return;
    initialized = true;

    var layer = layui.layer,
        form = layui.form,
        element = layui.element,
        $ = layui.jquery;

    console.log('layui 初始化完成');

    // 登录按钮点击事件
    $('#loginBtn').on('click', function(){
        console.log('登录按钮被点击');
        
        // 打开弹窗
        var index = layer.open({
            type: 1,
            title: '登录/注册',
            area: ['360px', 'auto'],
            content: $('#sign'),
            shadeClose: true,
            closeBtn: 1,
            shade: false,
            offset: '100px',
            success: function(layero, index){
                console.log('弹窗打开成功');
                
                // 登录表单提交
                form.on('submit(login)', function(data){
                    console.log('提交登录表单', data.field);
                    // 添加表单验证
                    if(!data.field.username || !data.field.password) {
                        layer.msg('用户名和密码不能为空', {icon: 2});
                        return false;
                    }
                    
                    $.ajax({
                        url: 'login',
                        type: 'POST',
                        data: data.field,
                        success: function(res){
                            try {
                                console.log('登录响应:', res);
                                if(res.code === 0){
                                    layer.msg('登录成功', {
                                        icon: 1,
                                        time: 1000,
                                        end: function(){
                                            window.location.reload();
                                        }
                                    });
                                } else {
                                    layer.msg(res.msg || '登录失败', {icon: 2});
                                }
                            } catch(e) {
                                console.error('处理响应时出错:', e);
                                layer.msg('系统错误，请稍后重试', {icon: 2});
                            }
                        },
                        error: function(xhr, status, error){
                            console.error('Ajax请求失败:', error);
                            layer.msg('网络错误，请稍后重试', {icon: 2});
                        }
                    });
                    return false;
                });

                // 重新渲染表单
                form.render();
            }
        });
    });
});

// 防止重复初始化
$(function(){
    if (window.loginInitialized) return;
    window.loginInitialized = true;
});
</script>

<!-- 添加表单验证 -->
<script>
layui.use(['form', 'layer'], function(){
    var form = layui.form;
    var layer = layui.layer;
    
    // 自定义验证规则
    form.verify({
        pass: [
            /^[\S]{6,12}$/,
            '密码必须6到12位，且不能出现空格'
        ],
        repass: function(value) {
            var password = $('input[name=password]').val();
            if(value !== password) {
                return '两次密码输入不一致！';
            }
        }
    });
    
    // 监听登录提交
    form.on('submit(login)', function(data){
        $.ajax({
            url: 'login',
            type: 'POST',
            data: data.field,
            success: function(res){
                if(res.code === 0){
                    layer.msg('登录成功', {icon: 1});
                    setTimeout(function(){
                        window.location.reload();
                    }, 1000);
                } else {
                    layer.msg(res.msg || '登录失败', {icon: 2});
                }
            },
            error: function(){
                layer.msg('服务器错误，请稍后重试', {icon: 2});
            }
        });
        return false;
    });
    
    // 监听注册提交
    form.on('submit(register)', function(data){
        $.ajax({
            url: 'register',
            type: 'POST',
            data: data.field,
            success: function(res){
                if(res.code === 0){
                    layer.msg('注册成功', {icon: 1});
                    // 切换到登录标签
                    $('.layui-tab-title li:first').click();
                } else {
                    layer.msg(res.msg || '注册失败', {icon: 2});
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

<!-- 在页面底部添加脚本，注意要放在 body 标签结束前 -->
<script>
layui.use(['layer', 'form', 'element', 'jquery'], function(){
    var $ = layui.jquery,
        layer = layui.layer,
        form = layui.form,
        element = layui.element;
    
    console.log('layui 初始化完成');

    // 绑定登录按钮点击事件
    $('#loginBtn').on('click', function(){
        console.log('登录按钮被点击');
        
        layer.open({
            type: 1,
            title: '登录/注册',
            area: ['360px', 'auto'],
            content: $('#sign'),
            shadeClose: true,  // 点击遮罩关闭
            shade: 0.6,        // 遮罩透明度
            closeBtn: 1,       // 显示关闭按钮
            anim: 1,          // 动画效果
            success: function(layero, index){
                console.log('弹窗打开成功');
                
                // 重新渲染表单
                form.render();
                
                // 绑定登录表单提交事件
                form.on('submit(login)', function(data){
                    console.log('登录表单提交', data.field);
                    $.ajax({
                        url: 'login',
                        type: 'POST',
                        data: data.field,
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('登录成功', {icon: 1});
                                setTimeout(function(){
                                    window.location.reload();
                                }, 1000);
                            } else {
                                layer.msg(res.msg || '登录失败', {icon: 2});
                            }
                        },
                        error: function(){
                            layer.msg('服务器错误，请稍后重试', {icon: 2});
                        }
                    });
                    return false;
                });

                // 绑定注册表单提交事件
                form.on('submit(register)', function(data){
                    console.log('注册表单提交', data.field);
                    $.ajax({
                        url: 'register',
                        type: 'POST',
                        data: data.field,
                        success: function(res){
                            if(res.code === 0){
                                layer.msg('注册成功', {icon: 1});
                                // 切换到登录标签
                                element.tabChange('user-tab', '1');
                            } else {
                                layer.msg(res.msg || '注册失败', {icon: 2});
                            }
                        },
                        error: function(){
                            layer.msg('服务器错误，请稍后重试', {icon: 2});
                        }
                    });
                    return false;
                });
            }
        });
    });
});
</script>

<script>
layui.use(['jquery'], function(){
    var $ = layui.jquery;
    
    console.log('初始化头像菜单交互');
    
    // 头像点击事件
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

