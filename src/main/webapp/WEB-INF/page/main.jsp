<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--<%@page language="java" import="java.util.*" errorPage="jsps/error.jsp"%>--%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="/layui/css/layui.css" media="all">
	<link rel="stylesheet" href="/css/main.css" media="all">
</head>
<body>
<div class="layui-layout">
	<!-- 头部区域 -->
	<div class="layui-header">
		<ul class="box">
			<li class="header-left">
				<div class="layui-logo" lay-href="/">
					<span style="padding: 0px 20px;font-size: 20px;letter-spacing: 5px;">访客管理系统</span>
					<%--<img src="/images/logo.png" style="height:40px;margin:10px" />--%>
					<span>|</span>
					<a href="javascript:;" class="btnHeader flexible" title="侧边伸缩">
						<i class="layui-icon layui-icon-shrink-right"></i>
					</a>
				</div>
			</li>
			<li class="header-right">
				<a class="btnHeader refresh" title="刷新">
					<i class="layui-icon layui-icon-refresh-3" style="font-size: 14px"> 刷新</i>
				</a>
				<span class="navHeader">
					<div class="layui-nav">
						<div class="layui-nav-item">
							<a href="javascript:;">
								<cite>${sessionScope.userInfo.trueName}</cite>
							</a>
							<dl class="layui-nav-child">
								<dd><a id="personalEdit">个人资料</a></dd>
								<dd><a id="personalPassword">修改密码</a></dd>
							</dl>
						</div>
					</div>
				</span>

				<a class="btnHeader logout">安全退出</a>
			</li>
		</ul>
	</div>
	<!-- 侧边菜单 -->
	<div class="layui-side">
		<div class="layui-side-scroll">
			<div class="layui-logo" lay-href="/vn/page/index" style="padding: 20px;text-align: center">
				<span>控制台</span>
			</div>
			<ul class="layui-nav layui-nav-tree layui-bg-cyan" lay-filter="nav" id="menu">

			</ul>
		</div>
	</div>
	<!-- 主体内容 -->
	<div class="layui-bodier">
		<div class="layui-tab" lay-filter="tab" lay-allowClose="true">
			<ul class="layui-tab-title">
				<li class="firstTab layui-this" lay-id="home1">首页</li>
			</ul>
			<div class="layui-tab-content">
				<div class="layui-tab-item layui-show">
					<iframe src="/page/index" frameborder="0" name="tabFrame" class="tabFrame"></iframe>
				</div>
			</div>
		</div>
	</div>
	<!-- 版权信息 -->
	<div class="layui-footer">
		<span>Copyright 2019 访客管理系统 备案号：渝ICP备xxx-xxxxx号</span>
	</div>
</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script src="/js/main.js" charset="utf-8"></script>
<script type="text/javascript">

	layui.use(['element'],function(){
		var $ = layui.jquery;
		var element = layui.element;

		//获取角色列表
		$.ajax({
			url:'/role/findUserFun',
			type:'get',
			dataType:"json",
			async:false,
			beforeSend:function(){
				//console.log(JSON.stringify(data.field));
			},
			success:function(data){
				if(data.code===0){

					var html = '';
					$.each(data.data,function (index,value) {
						if(index === 0){
							html+='<li data-name="get" class="layui-nav-item layui-this">' +
									'<a href="javascript:;" lay-href="'+value.parent.url+'" class="nav-tab" lay-id="home1" data-type="tabChange" lay-tips="'+value.parent.name+'"> ' +
									'<i class="layui-icon '+value.parent.icon+'"></i><label>'+value.parent.name+'</label>' +
								'</a></li>';
						}else{
							html+='<li class="layui-nav-item">' +
									'<a href="javascript:;">' +
									'<i class="layui-icon '+value.parent.icon+'"></i><label>'+value.parent.name+'</label>' +
									'</a><dl class="layui-nav-child">';
							$.each(value.childs,function (idx,val) {
								html += '<dd><a lay-href="'+val.url+'" class="nav-tab" lay-id="'+index+"_"+idx+'" data-type="tabAdd" lay-tips="'+val.name+'">\n' +
										'<i class="layui-icon '+val.icon+'"></i><label>'+val.name+'</label>\n' +
										'</a></dd>'
							});
							html += '</dl></li>';
						}
					});

					$('#menu').html(html);
					element.render();
				} else {
					layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
				}
			},
			error:function(data){
				//do something
				layer.msg('与服务器连接失败',{icon: 2});
			}
		});

	})
//个人资料
</script>
</html>