<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/1/21
  Time: 22:41
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
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
</head>
<body>
<div>
    <form class="layui-form">
        <div class="layui-form-item layui-elem-quote">
            <label class="layui-form-label">登记点</label>
            <div class="layui-input-inline">
                <input type="text" name="address" id="address"
                       autocomplete="off" placeholder="登记点" class="layui-input">
            </div>
            <button type="button" class="layui-btn btnSearch" lay-filter="search" lay-submit="">查询</button>
            <button type="button" class="layui-btn layui-btn-normal btnAdd">+ 新增登记点</button>
        </div>
    </form>
    <table class="layui-hide" id="tableList" lay-filter="tableList1"></table>
</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script>
    layui.use(["table","upload"],function(){
        var table = layui.table
            ,form = layui.form;
        var $ = layui.jquery;

        //加载表格
        table.render({
            elem: '#tableList',
            url: '/address/list',
            method:'post',
            cols: [[
                {field:'address', title: '登记点', align:'center'},
                {field:'remark', title: '备注', align:'center'},
                {field:'addTime', title: '创建时间', align:'center'},
                {fixed: 'right', width:260, title: '操作', align:'center', toolbar: '#barDemo'}
            ]],
            page:true
        });
        //重载表格
        $('.btnSearch').on('click',function(e){
            table.reload('tableList',{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                where: {
                    'address': $('#address').val()
                }
            });
        });

        //监听工具条
        table.on('tool(tableList1)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('登记点：'+data.address, {icon: 3, title:'是否确定删除?'}, function(index){
                    $.ajax({
                        url:'/address/delete',
                        type:'post',
                        data:{'id':data.id},
                        dataType:"json",
                        beforeSend:function(){//console.log(JSON.stringify(data.field));
                        },
                        success:function(data){//do something
                            if(data.code===0){
                                layer.msg('恭喜，删除成功！',{icon:1});
                            } else {
                                layer.alert(data.msg,{icon:2});
                            }
                            layer.close(index);
                            layui.table.reload('tableList');
                        },
                        error:function(data){//do something
                            layer.msg('与服务器连接失败',{icon: 2});
                        }
                    });
                });
            } else if(obj.event === 'edit'){
                layer.open({
                    title: '编辑登记点',
                    type: 2,
                    shade: false,
                    area: ['500px', '350px'],
                    maxmin: true,
                    btnAlign: 'c',
                    anim: 0,
                    shade: [0.5, 'rgb(0,0,0)'],
                    content: '/page/drive/address/edit',
                    zIndex: layer.zIndex, //重点1
                    success: function(layero,index){
                        // 获取子页面的iframe
                        var iframe = window['layui-layer-iframe' + index];
                        // 向子页面的全局函数child传参
                        iframe.child(data);
                    },
                    yes: function(index, layero){
                        //确认按钮
                    }
                });
            }
        });
        $('.btnAdd').on('click',function(){
            layer.open({
                title: '新增登记点',
                type: 2,
                shade: false,
                area: ['500px', '350px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/page/drive/address/add',
                zIndex: layer.zIndex, //重点1
                success: function(layero){
                    //layer.setTop(layero); //顶置窗口
                },
                yes: function(index, layero){
                    //确认按钮
                }
            });
        });
    })
</script>

</html>
