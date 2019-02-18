<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="/layui/css/layui.css" media="all">
    <title>登录日志管理</title>
</head>

<body>
<form class="layui-form">
    <div class="layui-form-item layui-elem-quote">
        <label class="layui-form-label">开始时间</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="begintime" name="begintime" placeholder="请输入开始时间">
        </div>
        <label class="layui-form-label">结束时间</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="endtime" name = "endtime" placeholder="请输入结束时间">
        </div>
        <button type="button" class="layui-btn btnSearch" lay-filter="search" lay-submit>查询</button>
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
    layui.use(['table','laydate'], function(){
        var table = layui.table;
        var $ = layui.jquery;
        var laydate = layui.laydate;

        //开始时间
        laydate.render({
            elem: '#begintime'
        });
        //结束时间
        laydate.render({
            elem: '#endtime'
        });

        //加载表格
        table.render({
            elem: '#tableList'
            ,url:'/log/login'
            ,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,cols: [[
                {field:'id',width:'5%', title: '编号', align:'center'},
                {field:'name', title: '登录名', align:'center'},
                {field:'ip', title: '登录ip', align:'center'},
                {field:'browser', title: '登录标识', align:'center'},
                {field:'time', title: '登录时间', align:'center'},
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
                    'begintime' : $('#begintime').val(),
                    'endtime' : $('#endtime').val()
                }
            });
        });
        //监听工具条
        table.on('tool(demo)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('服务标题：'+data.name, {icon: 3, title:'是否确定删除?'}, function(index){
                    $.ajax({
                        url:'/vn/fun/delete',
                        type:'post',
                        data:{'id':data.id},
                        dataType:"json",
                        beforeSend:function(){//console.log(JSON.stringify(data.field));
                        },
                        success:function(data){//do something
                            if(data.code==0){
                                layer.msg('恭喜，删除成功！',{icon:1});
                            } else {
                                layer.alert('抱歉，系统繁忙，请稍后再试！',{icon:2});
                            }
                        },
                        error:function(data){//do something
                            layer.msg('与服务器连接失败',{icon: 2});
                        }
                    });
                    layer.close(index);
                    layui.table.reload('tableList');
                });
            }else if(obj.event === 'edit'){
                layer.open({
                    title: '编辑信息',
                    type: 2,
                    shade: false,
                    area: ['719px', '366px'],
                    maxmin: true,
                    btnAlign: 'c',
                    anim: 0,
                    shade: [0.5, 'rgb(0,0,0)'],
                    content: '/vn/page/system/fun/edit',
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
                title: '新增日志',
                type: 2,
                shade: false,
                area: ['719px', '366px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/vn/page/system/fun/add',
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