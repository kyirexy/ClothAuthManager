<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.model.Admin" %>
<%
    // 获取当前登录的管理员信息
    Admin loginAdmin = (Admin) session.getAttribute("loginAdmin");
    if (loginAdmin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 获取头像路径和用户名
    String avatarPath = loginAdmin.getProfilePicture();
    String username = loginAdmin.getUsername();
    
    // 如果没有头像，使用默认头像
    if (avatarPath == null || avatarPath.trim().isEmpty()) {
        avatarPath = "static/images/smail.jpg";
    } else if (avatarPath.startsWith("/")) {
        avatarPath = avatarPath.substring(1);  // 移除前导的/
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 时尚服装购物网站</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css"/>
    <style>
        /* 全局样式 */
        .layui-layout-admin .layui-header {
            background-color: #2F4056;
            box-shadow: 0 1px 4px rgba(0,0,0,.2);
        }
        
        .layui-layout-admin .layui-logo {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            background-color: #243346;
            box-shadow: 0 1px 4px rgba(0,0,0,.1);
        }
        
        /* 顶部导航栏样式 */
        .admin-header-right {
            position: absolute;
            right: 15px;
        }
        
        .admin-header-user {
            display: flex;
            align-items: center;
            color: #fff;
        }
        
        .admin-header-user img {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid rgba(255,255,255,.3);
        }
        
        /* 侧边栏样式 */
        .layui-side {
            background-color: #2F4056;
            box-shadow: 2px 0 6px rgba(0,0,0,.1);
        }
        
        .layui-nav-tree {
            background-color: transparent;
        }
        
        .layui-nav-tree .layui-nav-item {
            margin: 5px 0;
        }
        
        .layui-nav-tree .layui-nav-item a {
            height: 50px;
            line-height: 50px;
            padding-left: 25px;
            border-radius: 0 25px 25px 0;
            margin: 0 15px 0 0;
        }
        
        .layui-nav-tree .layui-nav-item a:hover {
            background-color: rgba(255,255,255,.1);
        }
        
        .layui-nav-tree .layui-nav-child a {
            height: 40px;
            line-height: 40px;
            padding-left: 45px;
        }
        
        /* 主要内容区域样式 */
        .layui-body {
            background-color: #f6f6f6;
            padding: 15px;
            overflow: hidden;
        }
        
        .layui-body iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .welcome-card {
            background: linear-gradient(45deg, #1E9FFF, #39b8ff);
            color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,.1);
            margin-bottom: 20px;
        }
        
        .welcome-title {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .stat-cards {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            flex: 1;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin: 10px 0;
        }
        
        .stat-name {
            color: #666;
            font-size: 14px;
        }
        
        .stat-icon {
            float: right;
            font-size: 48px;
            color: rgba(47, 64, 86, 0.2);
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域 -->
    <div class="layui-header">
        <div class="layui-logo">时尚服装管理系统</div>
        <ul class="layui-nav admin-header-right">
            <li class="layui-nav-item">
                <a href="javascript:;" class="admin-header-user">
                    <img src="<%= avatarPath %>" 
                         alt="头像" 
                         onerror="this.src='static/images/smail.jpg'"
                         style="width: 35px; height: 35px; border-radius: 50%;">
                    <span><%= username %></span>
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;" data-url="user-profile.jsp" class="menu-item"><i class="layui-icon">&#xe614;</i> 个人信息</a></dd>
                    <dd><a href="javascript:;" class="logout"><i class="layui-icon">&#xe682;</i> 退出登录</a></dd>
                </dl>
            </li>
        </ul>
    </div>
    
    <!-- 左侧导航区域 -->
    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree">
                <li class="layui-nav-item layui-this">
                    <a href="javascript:;" class="menu-item" data-url="dashboard"><i class="layui-icon">&#xe68e;</i> 控制台</a>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon">&#xe770;</i> 用户管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-url="user-list.jsp" class="menu-item" id="userListMenu">用户列表</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon">&#xe698;</i> 商品管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;">商品列表</a></dd>
                        <dd><a href="javascript:;">分类管理</a></dd>
                        <dd><a href="javascript:;">库存管理</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon">&#xe65e;</i> 订单管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;">订单列表</a></dd>
                        <dd><a href="javascript:;">订单统计</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;"><i class="layui-icon">&#xe716;</i> 系统设置</a>
                </li>
            </ul>
        </div>
    </div>
    
    <!-- 内容主体区域 -->
    <div class="layui-body" id="admin-body">
        <!-- 默认显示欢迎页面内容 -->
        <div id="welcome-page">
            <!-- 欢迎卡片 -->
            <div class="welcome-card">
                <div class="welcome-title">欢迎回来，管理员</div>
                <div>今天是 <span id="current-date"></span></div>
            </div>
            
            <!-- 统计卡片 -->
            <div class="stat-cards">
                <div class="stat-card">
                    <i class="layui-icon stat-icon">&#xe770;</i>
                    <div class="stat-name">总用户数</div>
                    <div class="stat-value">1,234</div>
                    <div>较昨日 <span style="color:#52c41a">+12</span></div>
                </div>
                <div class="stat-card">
                    <i class="layui-icon stat-icon">&#xe657;</i>
                    <div class="stat-name">总订单数</div>
                    <div class="stat-value">892</div>
                    <div>较昨日 <span style="color:#52c41a">+5</span></div>
                </div>
                <div class="stat-card">
                    <i class="layui-icon stat-icon">&#xe65e;</i>
                    <div class="stat-name">今日销售额</div>
                    <div class="stat-value">12,345</div>
                    <div>较昨日 <span style="color:#52c41a">+8%</span></div>
                </div>
                <div class="stat-card">
                    <i class="layui-icon stat-icon">&#xe698;</i>
                    <div class="stat-name">商品总数</div>
                    <div class="stat-value">456</div>
                    <div>较昨日 <span style="color:#52c41a">+3</span></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="static/common/layui/layui.js"></script>
<script>
layui.use(['element', 'layer', 'jquery'], function(){
    var element = layui.element
        ,layer = layui.layer
        ,$ = layui.jquery;
    
    // 更新当前日期
    var now = new Date();
    document.getElementById('current-date').textContent = 
        now.getFullYear() + '年' + (now.getMonth() + 1) + '月' + now.getDate() + '日';
    
    // 菜单点击事件处理
    $('.menu-item').on('click', function(e){
        e.preventDefault();
        var url = $(this).data('url');
        
        if(url === 'dashboard'){ // 点击控制台
            // 显示欢迎页面
            $('#welcome-page').show();
            // 移除iframe
            $('#admin-body iframe').remove();
        } else if(url) {
            // 隐藏欢迎页面
            $('#welcome-page').hide();
            
            // 如果已经存在iframe，先移除
            $('#admin-body iframe').remove();
            
            // 创建新的iframe
            var iframe = $('<iframe>').attr({
                src: url,
                frameborder: '0',
                width: '100%',
                height: '100%'
            });
            
            $('#admin-body').append(iframe);
        }
        
        // 更新选中状态
        $('.layui-nav-item .layui-this').removeClass('layui-this');
        $(this).parent().addClass('layui-this');
    });

    // 退出登录事件
    $('.logout').on('click', function(){
        layer.confirm('确定要退出登录吗？', {
            icon: 3,
            title: '提示'
        }, function(index){
            // 直接跳转到logout servlet
            window.location.href = 'logout';
            layer.close(index);
        });
    });

    // 修改密码事件
    $('.change-password').on('click', function(){
        layer.msg('修改密码功能开发中...', {icon: 6});
    });

    window.updateAdminAvatar = function(newAvatarPath) {
        if (newAvatarPath) {
            // 如果路径以/开头，去掉开头的/
            if (newAvatarPath.startsWith('/')) {
                newAvatarPath = newAvatarPath.substring(1);
            }
            console.log('Updating avatar to:', newAvatarPath);
            
            // 更新所有头像显示
            $('.admin-header-user img').attr('src', newAvatarPath + '?t=' + new Date().getTime());
        }
    };
});
</script>
</body>
</html>

