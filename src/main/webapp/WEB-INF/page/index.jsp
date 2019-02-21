<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="description" content="">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<link rel="stylesheet" href="/layui/css/layui.css" media="all">
</head>
<body>
	<div class="layui-fluid">

		<!-- 面板 -->
		<div class="layui-row layui-col-space15">
			<blockquote class="layui-elem-quote explain" style="letter-spacing: 2px;padding-bottom: 5px">
				<p style="">本系统界面给予Layui开发</p>
				<p><span style="color:#1E9FFF;">后台界面给予spring+springmvc+mybatis</span></p>
				<p> <span style="color:#f00;">注：【请勿盗版，谢谢】</span></p>
			</blockquote>
			<!-- 更新检查 -->
			<div class="layui-col-xs12 layui-col-sm12 layui-col-md4 layui-col-lg4">
				<div class="layui-card">
					<div class="layui-card-header">基本介绍</div>
					<div class="layui-card-body layui-text">
						<table class="layui-table">
							<colgroup>
								<col width="100">
								<col>
							</colgroup>
							<tbody>
							<tr>
								<td>当前版本</td>
								<td>Visitor v1.0</td>
							</tr>
							<tr>
								<td>开发作者</td>
								<td>邓世平</td>
							</tr>
							<tr>
								<td style="width: 100px;">当前用户权限</td>
								<td>${sessionScope.userInfo.role.name}</td>
							</tr>
							<tr>
								<td>基于框架</td>
								<td>layui-v2.4.5</td>
							</tr>
							<tr>
								<td>主要特色</td>
								<td>清爽 / 极简</td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="layui-col-xs12 layui-col-sm12 layui-col-md8 layui-col-lg8">
				<div class="layui-card">
					<div class="layui-card-header">今日访客</div>
					<div class="layui-card-body layui-text">
						<table class="layui-hide" id="tableList" lay-filter="tableList1"></table>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script>
	layui.use(["table","upload"],function() {
		var table = layui.table
				, form = layui.form;
		var $ = layui.jquery;
		//加载表格
		table.render({
			elem: '#tableList',
			url: '/visitor/todaylist',
			method: 'post',
			cols: [[
				{field: 'name', title: '姓名', align: 'center'},
				{
					field: 'sex', title: '性别', align: 'center', templet: function (d) {
						if (d.sex === 1) {
							return "男";
						} else {
							return "女";
						}
					}
				},
				{field: 'phone', title: '联系方式', align: 'center'},
				{field: 'address', title: '联系地址', align: 'center'},
				{field: 'remark', title: '备注', align: 'center'},
				{
					field: 'type', title: '类型', align: 'center', templet: function (d) {
						if (d.type === 1) {
							return "正常";
						} else {
							return "黑名单";
						}
					}
				},
				{field: 'time', title: '登记时间', align: 'center'},
			]],
			page: true
		});
	});
</script>
</html>