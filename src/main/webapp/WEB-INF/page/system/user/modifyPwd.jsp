<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <style>
        .frameContent {padding:30px 30px 0px 0px}
        .frameBtn {text-align:center;margin:20px 0px 0px 30px;padding-top:20px;border-top:1px rgb(204,204,204) dashed}
    </style>
</head>
<body>
<div>
    <form class="layui-form frameContent">
        <div class="layui-form-item">
            <div class="layui-form-label">旧密码</div>
            <div class="layui-input-block">
                <input type="hidden" id="id" name="id" value="${id}" />
                <input type="password" name="pwd" required lay-verify="required" placeholder="请输入旧密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">新密码</div>
            <div class="layui-input-block">
                <input type="password" name="newPwd" required lay-verify="required" placeholder="请输入新密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">确认新密码</div>
            <div class="layui-input-block">
                <input type="password" name="confirmPwd" required lay-verify="required" placeholder="请输入新密码" autocomplete="off" class="layui-input">
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
    layui.use(['form','layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;
        //监听提交
        form.on('submit(submit)',function(data){
            layer.confirm('是否确定修改密码？', {icon: 3, title:'系统信息'}, function(index){
                $.ajax({
                    url:'/user/modifyPwd',
                    type:'post',
                    data:data.field,
                    dataType:"json",
                    beforeSend:function(){
                        //console.log(JSON.stringify(data.field));
                        if(data.field.newPwd!=data.field.confirmPwd){
                            layer.msg('抱歉，两次新密不一致，请重新输一次！',{icon:2});
                            $('input[name="newPwd"]').focus();
                            layer.close(index);
                            return false;
                        }
                    },
                    success:function(data){
                        //do something
                        if(data.code===0){
                            var index = parent.layer.getFrameIndex(window.name);//获取当前窗口索引
                            parent.layer.msg('修改成功', {icon : 1});
                            parent.layer.close(index);
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
