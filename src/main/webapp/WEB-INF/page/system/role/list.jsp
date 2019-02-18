<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
    <title>角色管理</title>
</head>

<body>
<form class="layui-form">
    <div class="layui-form-item layui-elem-quote">
        <label class="layui-form-label">角色名称</label>
        <div class="layui-input-inline">
            <input type="text" name="name" id="name" autocomplete="off" placeholder="请输入角色名称" class="layui-input">
        </div>
        <button type="button" class="layui-btn btnSearch" lay-filter="search" lay-submit>查询</button>
        <button type="button" class="layui-btn layui-btn-normal btnAdd">+ 新增角色</button>
    </div>
</form>
<table class="layui-hide" id="tableList" lay-filter="demo"></table>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script>
    layui.use('table', function(){
        var table = layui.table;
        var $ = layui.jquery;

        //加载表格
        table.render({
            elem: '#tableList'
            ,url:'/role/list'
            ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,cols: [[
                {field:'id', title: '编号', align:'center'},
                {field:'name', title: '角色名称', align:'center'},
                {field:'remark', title: '角色备注', align:'center'},
                {field:'addTime', title: '创建时间', align:'center'},
                {fixed: 'right', width:150, title: '操作', align:'center', toolbar: '#barDemo'}
            ]],
            page: true
        });
        //重载表格
        $('.btnSearch').on('click',function(){
            table.reload('tableList',{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                where: {
                    'name': $('#name').val()
                }
            });
        });
        //监听工具条
        table.on('tool(demo)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('服务标题：'+data.name, {icon: 3, title:'是否确定删除?'}, function(index){
                    $.ajax({
                        url:'/role/delete',
                        type:'post',
                        data:{'id':data.id},
                        dataType:"json",
                        beforeSend:function(){//console.log(JSON.stringify(data.field));
                        },
                        success:function(data){//do something
                            if(data.code===0){
                                layer.msg('恭喜，删除成功！',{icon:1});
                            } else {
                                layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
                            }
                            layer.close(index);
                            layui.table.reload('tableList');
                        },
                        error:function(data){//do something
                            layer.msg('与服务器连接失败',{icon: 2});
                        }
                    });

                });
            }else if(obj.event === 'edit'){
                layer.open({
                    title: '编辑信息',
                    type: 2,
                    area: ['700px', '450px'],
                    maxmin: true,
                    btnAlign: 'c',
                    anim: 0,
                    shade: [0.5, 'rgb(0,0,0)'],
                    content: '/page/system/role/edit',
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
        //新增账号
        $('.btnAdd').on('click',function(){
            layer.open({
                title: '新增角色',
                type: 2,
                area: ['700px', '450px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/page/system/role/add',
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