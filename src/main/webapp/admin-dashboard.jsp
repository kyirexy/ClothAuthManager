<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 时尚服装购物网站</title>
    <link rel="stylesheet" href="static/common/layui/css/layui.css"/>
    <script src="static/common/layui/layui.js"></script>
    <style>
        .layui-layout-admin .layui-logo {
            color: #fff;
            font-size: 18px;
        }
        .layui-side-scroll {
            width: 200px;
        }
        .layui-nav-tree {
            width: 100%;
        }
        .layui-layout-admin .layui-body {
            bottom: 0;
        }
        .admin-header {
            padding: 10px 15px;
            background-color: #23262E;
        }
        .admin-header-right {
            float: right;
        }
        .admin-main {
            padding: 15px;
        }
        .layui-card {
            margin-bottom: 15px;
        }
        .layui-card-header {
            font-weight: bold;
        }
        .stat-box {
            text-align: center;
            padding: 20px 0;
        }
        .stat-box .layui-icon {
            font-size: 40px;
            color: #1E9FFF;
        }
        .stat-box .stat-value {
            font-size: 24px;
            font-weight: bold;
            margin: 10px 0;
        }
        .stat-box .stat-name {
            color: #999;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域 -->
    <div class="layui-header">
        <div class="layui-logo">时尚服装购物网站管理系统</div>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item">
                <a href="javascript:;">
                    <img src="http://t.cn/RCzsdCq" class="layui-nav-img">
                    管理员
                </a>
                <dl class="layui-nav-child">
                    <dd><a href="">基本资料</a></dd>
                    <dd><a href="">安全设置</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item"><a href="">退出</a></li>
        </ul>
    </div>

    <!-- 左侧导航区域 -->
    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="test">
                <li class="layui-nav-item layui-nav-itemed">
                    <a class="" href="javascript:;">用户管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-url="user-list.jsp">用户列表</a></dd>
                        <dd><a href="javascript:;" data-url="user-add.jsp">添加用户</a></dd>
                        <dd><a href="javascript:;" data-url="user-roles.jsp">用户角色</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">商品管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-url="product-list.jsp">商品列表</a></dd>
                        <dd><a href="javascript:;" data-url="product-add.jsp">添加商品</a></dd>
                        <dd><a href="javascript:;" data-url="product-category.jsp">商品分类</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">订单管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-url="order-list.jsp">订单列表</a></dd>
                        <dd><a href="javascript:;" data-url="order-stats.jsp">订单统计</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">系统设置</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-url="system-config.jsp">网站配置</a></dd>
                        <dd><a href="javascript:;" data-url="system-log.jsp">系统日志</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>

    <!-- 内容主体区域 -->
    <div class="layui-body">
        <div class="admin-header">
            <span id="current-page">控制台</span>
            <div class="admin-header-right">
                <span id="current-time"></span>
            </div>
        </div>
        <div class="admin-main">
            <div class="layui-row layui-col-space15">
                <div class="layui-col-md3">
                    <div class="layui-card">
                        <div class="layui-card-body stat-box">
                            <i class="layui-icon layui-icon-user"></i>
                            <div class="stat-value">1,234</div>
                            <div class="stat-name">总用户数</div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md3">
                    <div class="layui-card">
                        <div class="layui-card-body stat-box">
                            <i class="layui-icon layui-icon-cart"></i>
                            <div class="stat-value">56</div>
                            <div class="stat-name">今日订单</div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md3">
                    <div class="layui-card">
                        <div class="layui-card-body stat-box">
                            <i class="layui-icon layui-icon-rmb"></i>
                            <div class="stat-value">￥9,876</div>
                            <div class="stat-name">今日销售额</div>
                        </div>
                    </div>
                </div>
                <div class="layui-col-md3">
                    <div class="layui-card">
                        <div class="layui-card-body stat-box">
                            <i class="layui-icon layui-icon-notice"></i>
                            <div class="stat-value">15</div>
                            <div class="stat-name">未处理消息</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-card">
                <div class="layui-card-header">最近活动</div>
                <div class="layui-card-body">
                    <ul class="layui-timeline">
                        <li class="layui-timeline-item">
                            <i class="layui-icon layui-timeline-axis">&#xe63f;</i>
                            <div class="layui-timeline-content layui-text">
                                <h3 class="layui-timeline-title">8:30</h3>
                                <p>用户"张三"注册成功</p>
                            </div>
                        </li>
                        <li class="layui-timeline-item">
                            <i class="layui-icon layui-timeline-axis">&#xe63f;</i>
                            <div class="layui-timeline-content layui-text">
                                <h3 class="layui-timeline-title">11:20</h3>
                                <p>新增订单：#12345</p>
                            </div>
                        </li>
                        <li class="layui-timeline-item">
                            <i class="layui-icon layui-timeline-axis">&#xe63f;</i>
                            <div class="layui-timeline-content layui-text">
                                <h3 class="layui-timeline-title">14:00</h3>
                                <p>更新商品库存：SKU001</p>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use(['element', 'layer', 'util'], function(){
        var element = layui.element
            ,layer = layui.layer
            ,util = layui.util
            ,$ = layui.jquery;

        // 更新当前时间
        function updateTime() {
            var now = new Date();
            $('#current-time').text(now.toLocaleString());
        }
        updateTime();
        setInterval(updateTime, 1000);

        // 侧边栏点击事件
        $('.layui-nav-child a').on('click', function(){
            var url = $(this).data('url');
            var title = $(this).text();
            $('#current-page').text(title);
            // 这里可以添加加载页面内容的逻辑
            layer.msg('正在加载 ' + title + ' 页面');
        });

        // 示例：触发一个弹窗
        $('.stat-box').on('click', function(){
            var statName = $(this).find('.stat-name').text();
            var statValue = $(this).find('.stat-value').text();
            layer.open({
                type: 1
                ,title: statName + '详情'
                ,area: ['300px', '200px']
                ,shade: 0.8
                ,id: 'LAY_layuipro'
                ,btn: ['确定', '取消']
                ,btnAlign: 'c'
                ,moveType: 1
                ,content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">'+ statName +': '+ statValue +'</div>'
                ,success: function(layero){
                    var btn = layero.find('.layui-layer-btn');
                    btn.find('.layui-layer-btn0').attr({
                        href: 'http://www.layui.com/'
                        ,target: '_blank'
                    });
                }
            });
        });
    });
</script>
</body>
</html>

