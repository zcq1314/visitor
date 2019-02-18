<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<link rel="stylesheet" href="/layui/css/layui.css" media="all">
	<style>
	.frameContent {padding:30px 30px 0px 0px}
	.frameBtn {text-align:center;margin:20px 0px 0px 30px;padding-top:20px;border-top:1px rgb(204,204,204) dashed}
	</style>
</head>
<body>
	<div>
		<form class="layui-form frameContent"  lay-filter="form">
			<div class="layui-form-item">
				<div class="layui-form-label">账号</div>
				<div class="layui-input-block">
					<input type="hidden" name="id" />
					<input type="text" name="userName" required lay-verify="user" placeholder="请输入用户名" autocomplete="off" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-form-label">姓名</div>
				<div class="layui-input-block">
					<input type="text" name="trueName" required lay-verify="required" placeholder="请输入姓名" autocomplete="off" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-form-label">邮箱</div>
				<div class="layui-input-block">
					<input type="text" name="email" required lay-verify="required" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-form-label">手机</div>
				<div class="layui-input-block">
					<input type="text" name="phone" required lay-verify="required" placeholder="请输入手机号" autocomplete="off" class="layui-input">
				</div>
			</div>
			<div class="frameBtn">
				<button class="layui-btn" lay-submit lay-filter="submit">修改保存</button>
			</div>
		</form>
	</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script>
layui.use(['form'], function(){
	var form = layui.form;
	var $ = layui.jquery;
	form.verify({
		user: function (value, item) { //value：表单的值、item：表单的DOM对象
			if (/[\u4E00-\u9FA5]/g.test(value)) {
				return '账号不能是汉字';
			}
			if (!(/^[\S]{5,16}$/).test(value)) {
				return '账号必须5到16位，且不能出现空格'
			}
			if (!new RegExp("^[a-zA-Z0-9_\u4e00-\u9fa5\\s·]+$").test(value)) {
				return '用户名不能有特殊字符';
			}
			if (/(^\_)|(\__)|(\_+$)/.test(value)) {
				return '用户名首尾不能出现下划线\'_\'';
			}
			if (/^\d+\d+\d$/.test(value)) {
				return '用户名不能全为数字';
			}
		}
	});
	//获取个人信息
	$.ajax({
		url:'/user/queryUser',
		type:'get',
		data:'',
		dataType:"json",
		beforeSend:function(){
			//console.log(JSON.stringify(data.field));
		},
		success:function(data){
			//do something
			if(data.code==0){
                //表单初始赋值
                form.val('form', {
                    "id":data.data.id
                    ,"userName":data.data.userName
                    ,"trueName": data.data.trueName
                    ,"email": data.data.email
                    ,"phone": data.data.phone
                });
                form.render();
			} else {
				layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
			}
		},
		error:function(data){
			//do something
			layer.msg('与服务器连接失败',{icon: 2});
		}
	});
	//监听提交
	form.on('submit(submit)',function(data){
		layer.confirm('是否确定保存修改？',{icon: 3, title:'系统信息'},function(index){
			$.ajax({
				url:'/user/save',
				type:'post',
				data:data.field,
				dataType:"json",
				beforeSend:function(){
					//console.log(JSON.stringify(data.field));
				},
				success:function(data){
					//do something
					if(data.code==0){
						var index = parent.layer.getFrameIndex(window.name);//获取当前窗口索引
						parent.layer.msg('修改成功', {icon : 1});
						parent.layer.close(index);
						parent.layui.table.reload('test');//重新加载父级tabel数据
					} else {
						layer.alert(data.msg,{icon:2});
					}
				},
				error:function(data){
					//do something
					layer.msg('与服务器连接失败',{icon: 2});
				}
			});
		});
		return false;
	});
});
</script>
</html>