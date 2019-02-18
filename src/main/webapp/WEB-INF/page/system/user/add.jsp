<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/1/21
  Time: 22:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
    <style>
        .frameContent {padding:30px}
        .frameBtn {text-align:center;margin:20px 0px 0px 30px;padding-top:20px;border-top:1px rgb(204,204,204) dashed}
        .funList {float: left;}
        .role-bor{
            border: 1px solid rgb(230, 230, 230);
            border-radius: 2px;
            /*box-shadow: 0 2px 5px 0 rgba(0,0,0,.1);*/
            padding: 5px 0px;
        }
        .role-title{
            margin: 0px -10px 10px -10px;
            background-color: #f2f2f2;
            padding: 10px;
        }
    </style>
</head>
<body>
<div>
    <form class="layui-form frameContent layui-form-pane" lay-filter="form">
        <div class="layui-form-item">
            <div class="layui-form-label">账号</div>
            <div class="layui-input-inline">
                <input type="text" name="userName"  placeholder="账号" autocomplete="off" class="layui-input" >
            </div>
            <div class="layui-form-label">密码</div>
            <div class="layui-input-inline">
                <input type="text" name="password"  placeholder="密码" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">真实姓名</div>
            <div class="layui-input-inline">
                <input type="text" name="trueName" required lay-verify="required" placeholder="请输入真实姓名" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-label">角色</div>
            <div class="layui-input-inline">
                <select name="roleId" id="role" lay-verify="required">
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">邮箱</div>
            <div class="layui-input-inline">
                <input type="text" name="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-label">电话</div>
            <div class="layui-input-inline">
                <input type="text" name="phone"  placeholder="请输入电话" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">用户备注</div>
            <div class="layui-input-block">
                <input type="text" name="remark"  placeholder="请输入用户备注" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="frameBtn">
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <button class="layui-btn" lay-submit lay-filter="submit">保存</button>
        </div>
    </form>
</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script>

    layui.use(['form'], function(){
        var form = layui.form;
        var $ = layui.jquery;

        //获取角色列表
        $.ajax({
            url:'/role/all',
            type:'get',
            dataType:"json",
            success:function(data){

                var html = '';
                if(data.code===0){
                    $.each(data.data,function(index,value){
                        html += '<option value="'+value.id+'">'+value.name+'</option>';
                        //alert(html);
                    });
                    //alert(html);
                    $('#role').html(html);
                    form.render('select');
                } else {
                    layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
                }
            },
        });

        //监听提交
        form.on('submit(submit)',function(data){

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
                        parent.layer.msg('新增成功', {icon : 1});
                        parent.layer.close(index);
                        parent.layui.table.reload('tableList');//重新加载父级tabel数据
                    } else {
                        layer.alert(data.msg,{icon:2});
                    }
                },
                error:function(data){
                    //do something
                    layer.msg('与服务器连接失败',{icon: 2});
                }
            });
            return false;
        });
    });
</script>
</html>
