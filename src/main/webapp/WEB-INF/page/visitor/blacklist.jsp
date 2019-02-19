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
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" id="name"
                       autocomplete="off" placeholder="姓名" class="layui-input">
            </div>
            <button type="button" class="layui-btn btnSearch" lay-filter="search" lay-submit="">查询</button>
        </div>
    </form>
    <table class="layui-hide" id="tableList" lay-filter="tableList1"></table>
</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script type="text/html" id="switchTpl">
    <input type="checkbox" name="type" value="{{d.id}}" lay-skin="switch" lay-text="正常|黑名单" lay-filter="type" {{ d.type === 1 ? 'checked' : '' }}>
</script>
<script>
    layui.use(["table","upload"],function(){
        var table = layui.table
            ,form = layui.form;
        var $ = layui.jquery;

        //加载表格
        table.render({
            elem: '#tableList',
            url: '/visitor/list',
            method:'post',
            cols: [[
                {field:'name', title: '姓名', align:'center'},
                {field:'sex', title: '性别', align:'center', templet:function (d) {
                    if(d.sex === 1){
                        return "男";
                    }else{
                        return "女";
                    }
                }},
                {field:'phone', title: '联系方式', align:'center'},
                {field:'address', title: '联系地址', align:'center'},
                {field:'remark', title: '备注', align:'center'},
                {field:'type', title: '类型', align:'center',templet:'#switchTpl'},
                {field:'time', title: '登记时间', align:'center'},
            ]],
            where:{
                'type':2
            },
            page:true
        });
        //重载表格
        $('.btnSearch').on('click',function(e){
            table.reload('tableList',{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                where: {
                    'name': $('#name').val(),
                }
            });
        });

        //监听性别操作
        form.on('switch(type)', function(obj){
            var type;
            if(obj.elem.checked){
                type = 1;
            }else{
                type = 2;
            }
            $.ajax({
                url:'/visitor/save',
                type:'post',
                data:{id:this.value,'type':type},
                dataType:"json",
                beforeSend:function(){//console.log(JSON.stringify(data.field));
                },
                success:function(data){//do something
                    if(data.code==0){
                        layer.alert('修改成功',{icon:1},function () {
                            window.location.reload();
                        });
                    } else {
                        layer.alert(data.msg,{icon:2});
                    }

                    //layui.table.reload('tableList');
                },
                error:function(data){//do something
                    layer.msg('与服务器连接失败',{icon: 2});
                }
            });
            //alert(this.value+" "+this.name+" "+);
        });

    })
</script>

</html>
