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
    </style>
</head>
<body>
<div>
    <form class="layui-form frameContent layui-form-pane" lay-filter="form">
        <input type="hidden" id="id" name="id" />
        <div class="layui-form-item">
            <div class="layui-form-label">资源名称</div>
            <div class="layui-input-inline">
                <input type="text" name="name" required lay-verify="required" placeholder="请输入资源名称" autocomplete="off" class="layui-input" >
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">资源路径</div>
            <div class="layui-input-block">
                <input type="text" name="url" placeholder="请输入资源路径(顶级目录可不填)" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-form-label">资源图标</div>
            <div class="layui-input-inline" style="width: 300px">
                <input type="text" name="icon" id="iconPicker" lay-filter="iconPicker" class="layui-input">
                <%--<input type="text" name="icon" placeholder="可不填" autocomplete="off" class="layui-input" >--%>
            </div>
            <div class="layui-form-label">父级编号</div>
            <div class="layui-input-inline">
                <select  lay-filter="pid" name = "pid" id = "pid">
                    <option value="0">顶级目录</option>
                </select>
                <%--<input type="text" name="pid" id="pid" lay-verify="num" placeholder="(不填默认为顶级目录)" autocomplete="off" class="layui-input" >--%>
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
    layui.config({
        base: '/js/'
    }).extend({
        iconPicker: './iconPicker'
    });
    layui.use(['form','iconPicker'], function(){
        var form = layui.form;
        var $ = layui.jquery;
        var iconPicker = layui.iconPicker;

        iconPicker.render({
            // 选择器，推荐使用input
            elem: '#iconPicker',
            // 数据类型：fontClass/unicode，推荐使用fontClass
            type: 'fontClass',
            // 是否开启搜索：true/false
            search: true,
            // 是否开启分页
            page: false,
            // 每页显示数量，默认12
            //limit: 12,
            // 点击回调
            click: function (data) {
                console.log(data);
            }
        });

        iconPicker.checkIcon('iconPicker', data.icon==null?"":data.icon);

        //表单初始赋值
        form.val('form', {
            "id":data.id
            ,"name":data.name
            ,"url":data.url
            //,"icon": data.icon
            ,"pid": data.pid
        });

        //加载设备类型下拉列表
        $.ajax({
            url: '/fun/allFun',
            type: 'post',
            dataType: "json",
            async: false,
            beforeSend: function () {
                //console.log(JSON.stringify(data.field));
            },
            success: function (resultData) {
                if(resultData.code === 0){
                    $.each(resultData.data,function (idx,val) {
                        $('#pid').append("<option value="+val.parent.id+">&nbsp;&nbsp;&nbsp;├&nbsp;&nbsp;"+val.parent.name+"</option>");
                    })
                }
                $('#pid').val(data.pid);
                layui.form.render("select");
            }
        });

        //监听提交
        form.on('submit(submit)',function(data){
            $.ajax({
                url:'/fun/save',
                type:'post',
                data:data.field,
                dataType:"json",
                beforeSend:function(){
                    //console.log(JSON.stringify(data.field));
                },
                success:function(data){
                    //do something
                    if(data.code===0){
                        var index = parent.layer.getFrameIndex(window.name);//获取当前窗口索引
                        layer.alert('修改成功！',{icon:1},function () {
                            parent.layer.close(index);
                            parent.parent.location.reload();
                        });
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
