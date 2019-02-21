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
            <button type="button" class="layui-btn layui-btn-normal btnAdd">+ 新增访客</button>
        </div>
        <div class="layui-form-item">
            <button type="button" class="layui-btn layui-btn-sm" id="import">导 入</button>
            <button type="button" class="layui-btn layui-btn-sm  layui-btn-normal" id="export">导 出</button>
        </div>
    </form>
    <table class="layui-hide" id="tableList" lay-filter="tableList1"></table>
</div>
</body>
<script src="/layui/layui.js" charset="utf-8"></script>
<script type="text/html" id="switchTpl">
    <input type="checkbox" name="type" value="{{d.id}}" lay-skin="switch" lay-text="正常|黑名单" lay-filter="type" {{ d.type === 1 ? 'checked' : '' }}>
</script>
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
            url: '/vis/list',
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
                url:'/vis/save',
                type:'post',
                data:{id:this.value,'type':type},
                dataType:"json",
                beforeSend:function(){//console.log(JSON.stringify(data.field));
                },
                success:function(data){//do something
                    if(data.code==0){
                        layer.msg('修改成功',{icon:1});
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
            //alert(this.value+" "+this.name+" "+);
        });

        //监听工具条
        table.on('tool(tableList1)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('姓名：'+data.name, {icon: 3, title:'是否确定删除?'}, function(index){
                    $.ajax({
                        url:'/vis/delete',
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
                    title: '编辑访客',
                    type: 2,
                    shade: false,
                    area: ['736px', '460px'],
                    maxmin: true,
                    btnAlign: 'c',
                    anim: 0,
                    shade: [0.5, 'rgb(0,0,0)'],
                    content: '/page/visitor/edit',
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
                title: '新增访客',
                type: 2,
                shade: false,
                area: ['736px', '460px'],
                maxmin: true,
                btnAlign: 'c',
                anim: 0,
                shade: [0.5, 'rgb(0,0,0)'],
                content: '/page/visitor/add',
                zIndex: layer.zIndex, //重点1
                success: function(layero){
                    //layer.setTop(layero); //顶置窗口
                },
                yes: function(index, layero){
                    //确认按钮
                }
            });
        });
        var upload = layui.upload;

        //执行实例
        var uploadInst = upload.render({
            elem: '#import' //绑定元素
            ,url: '/vis/import' //上传接口
            ,accept: 'file' //允许上传的文件类型
            ,done: function(res){
                //上传完毕回调
            }
            ,error: function(){
                //请求异常回调
            }
        });

        $('#export').on('click',function(){

            var index = layer.msg('导出中', {
                icon: 16
                ,shade: false
            });
            location.href="/vis/export";

            layer.alert("导出成功",{icon:1});
            layer.close(index);
            //var index = layer.load(0, {shade: false}); //0代表加载的风格，支持0-2

            //layer.close(index);
        });
    })
</script>

</html>
