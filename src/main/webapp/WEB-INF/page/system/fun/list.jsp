<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
    <title>资源管理</title>
</head>

<body>
<form class="layui-form">
    <div class="layui-form-item layui-elem-quote">
        <label class="layui-form-label">资源名称</label>
        <div class="layui-input-inline">
            <input type="text" name="name" id="name" autocomplete="off" placeholder="请输入资源名称" class="layui-input">
        </div>
        <button type="button" class="layui-btn btnSearch" lay-filter="search" lay-submit>查询</button>
        <button type="button" class="layui-btn layui-btn-normal btnAdd">+ 新增资源</button>
    </div>
</form>
<table class="layui-table layui-form" id="tableList" lay-filter="tableList" style="text-align: center"></table>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<style>
    .hide{display:none}
</style>
<script>
    layui.config({
        base: '/js/',
    });
    layui.use('treetable', function(){
        var treetable = layui.treetable;
        var $ = layui.jquery;

        var data;

        //加载设备类型下拉列表
        $.ajax({
            url: '/fun/list',
            type: 'post',
            dataType: "json",
            async: false,
            beforeSend: function () {
                //console.log(JSON.stringify(data.field));
            },
            success: function (resultData) {
                if(resultData.code === 0){
                   data = resultData.data;
                }
            }
        });
        //加载表格
        treetable.render({
            elem: '#tableList'
            ,data: data
            ,field: 'name'
            ,space: 10
            //,is_checkbox: true
            //,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,cols: [
                {field:'id', title: '编号', width: '4%',align:'center',},
                {field:'name', title: '资源名称',width: '20%', align:'center',template:function (d) {
                    if(d.pid===0){
                        return "<left>&nbsp;&nbsp;"+d.name+"</left>";
                    }else{
                        return "<left>"+d.name+"</left>";
                    }
                }},
                {field:'url', title: '资源路径', width: '20%',align:'center',template:function (d) {
                        if(d.url==null) {
                            return '';
                        }else{
                            return d.url;
                        }
                    }},
                {field:'icon', title: '资源图标',width:'6%', align:'center',template:function (d) {
                        return '<i class="layui-icon '+d.icon+'" style="font-size: 22px;"></i>';
                    }},
                {field:'pid', title: '父级编号',width: '10%', align:'center'},
                {field:'addTime', title: '创建时间',width: '10%', align:'center'},
                {fixed: 'right', width:'15%', title: '操作', align:'center', template:function (d) {
                    var item = [];
                    item.push('<a class="layui-btn layui-btn-xs" lay-filter="edit">编辑</a>');
                    item.push('<a class="layui-btn layui-btn-danger layui-btn-xs" lay-filter="del">删除</a>');
                    return "<center>"+item.join(' ')+"<center>";
                }}
            ],
            page: true
        });
        $("table tr").each(function () {
            $(this).children("td:eq(1)").css("text-align","left");
            $(this).children("td:eq(2)").css("text-align","left");
        });
        //重载表格
        $('.btnSearch').on('click',function(){
            treetable.reload('tableList',{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                where: {
                    'name': $('#name').val()
                }
            });
        });
        treetable.on('treetable(edit)',function (obj) {
            var data = obj.item;
            layer.open({
                title: '编辑信息',
                type: 2,
                shade: false,
                area: ['850px', '510px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/page/system/fun/edit',
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
        });
        treetable.on('treetable(del)',function (obj) {
            var data = obj.item;
            layer.confirm('服务标题：'+data.name, {icon: 3, title:'是否确定删除?'}, function(index){
                $.ajax({
                    url:'/fun/delete',
                    type:'post',
                    data:{'id':data.id},
                    dataType:"json",
                    beforeSend:function(){//console.log(JSON.stringify(data.field));
                    },
                    success:function(data){//do something
                        if(data.code==0){
                            layer.alert('恭喜，删除成功！',{icon:1},function () {
                                layer.close(index);
                                parent.location.reload();
                            });
                        } else {
                            layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
                            layer.close(index);
                        }
                    },
                    error:function(data){//do something
                        layer.msg('与服务器连接失败',{icon: 2});
                    }
                });

            });
        });
        //新增菜单
        $('.btnAdd').on('click',function(){
            layer.open({
                title: '新增资源',
                type: 2,
                shade: false,
                area: ['850px', '510px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/page/system/fun/add',
                zIndex: layer.zIndex, //重点1
                success: function(layero){
                    //layer.setTop(layero); //顶置窗口
                },
                yes: function(index, layero){
                    //确认按钮
                }
            });
        });
    });
</script>
</body>
</html>