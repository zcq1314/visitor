<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/1/21
  Time: 22:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"  isELIgnored="false"%>
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
        <input type="hidden" id="id" name="id" />
        <div class="layui-form-item">
            <div class="layui-form-label">姓名</div>
            <div class="layui-input-inline">
                <input type="text" name="name"  placeholder="姓名" autocomplete="off" class="layui-input" >
            </div>
            <div class="layui-form-label">性别</div>
            <div class="layui-input-inline">
                <select name="sex" lay-verify="required">
                    <option value="1">男</option>
                    <option value="2">女</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">联系方式</div>
            <div class="layui-input-inline">
                <input type="text" name="phone" required lay-verify="required" placeholder="联系方式" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-label">联系地址</div>
            <div class="layui-input-inline">
                <input type="text" name="address" required lay-verify="required" placeholder="联系地址" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">类型</div>
            <div class="layui-input-inline">
                <select name="type" lay-verify="required">
                    <option value="1">正常</option>
                    <option value="2">黑名单</option>
                </select>
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

    var data;
    function child(d) {
        data = d;
        //alert(data);
    }

    layui.use(['form'], function(){
        var form = layui.form;
        var $ = layui.jquery;

        //表单初始赋值
        form.val('form', {
            "id":data.id
            ,"name":data.name
            ,"sex": data.sex
            ,"phone": data.phone
            ,"address": data.address
            ,"type": data.type
            ,"remark": data.remark
        });

        form.render('select');

        //监听提交
        form.on('submit(submit)',function(formData){

            $.ajax({
                url:'/vis/save',
                type:'post',
                data:formData.field,
                dataType:"json",
                beforeSend:function(){
                },
                success:function(result){
                    //do something
                    if(result.code===0){
                        var index = parent.layer.getFrameIndex(window.name);//获取当前窗口索引

                        parent.layer.msg('修改成功', {icon : 1});
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
