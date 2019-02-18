layui.use(['element','layer'],function(){
	var element = layui.element;
	var layer = layui.layer;
	var $ = layui.jquery;
	bodierAutoHeight();
	$(window).resize(function(e){
		bodierAutoHeight();
	});
	//自适应高度
	function bodierAutoHeight(){
		var winHeight = $(window).height(); //浏览器高度
		$('.layui-bodier').height(winHeight-80); //主界面高度
		$('.tabFrame').height(winHeight-200);
	}
	//navTab导航事件
	$('.nav-tab').on('click', function(e){
		var t = $(this).children('label').text();//标题
		var id = $(this).attr('lay-id');//tab位置
		var url = $(this).attr('lay-href');//数据地址
		var tabFrame = '<iframe src="'+url+'" class="tabFrame" frameborder="0"></iframe>';
		if($(this).attr('data-type')=='tabAdd'){
			tab.tabAdd(t,id,tabFrame);
			$(this).attr('data-type','tabChange');
		} else {
			tab.tabChange(id);	
		}
		bodierAutoHeight();
	});
	//tab触发事件
	var tab = {
		tabAdd: function(t,id,tabFrame){
			//新增一个Tab项
			element.tabAdd('tab', {
				title: t //用于演示
				,content: tabFrame//内容
				,id: id //Tab项唯一ID
			});
			element.tabChange('tab', id);//切换到新增Tab项
		}
		,tabDelete: function(othis){
			//删除指定Tab项
			element.tabDelete('tab', id); //删除：“商品管理”
			othis.addClass('layui-btn-disabled');;
		}
		,tabChange: function(id){
			//切换到指定Tab项
			element.tabChange('tab', id); //切换到：用户管理
		}
	};
	//tab关闭监听事件
	element.on('tabDelete(tab)', function(data){
		var id = $(this).parent().attr('lay-id');//tab位置
		$('.nav-tab[lay-id='+id+']').attr('data-type','tabAdd');//nav位置
	});
	//隐藏左侧导航
	$('.flexible').on('click',function(){
		var objHeader = $('.layui-header');
		var objSide = $('.layui-side');
		var objBody = $('.layui-bodier');
		var objIcon = $(this).find('i');
		var objNavChild = $('.layui-nav-child');
		if(objSide.css('width')=='60px'){
			//objHeader.animate({'marginLeft':'220px'});
			objBody.animate({'marginLeft':'260px'});
			objSide.animate({'width':'260px'});
			objSide.animate({'border-radius':'20px'});
			objIcon.removeClass('layui-icon-spread-left');
			objIcon.addClass('layui-icon-shrink-right');
			objNavChild.animate({'padding-left':'40px'});
		} else {
			//objHeader.animate({'marginLeft':'0px'});
			objBody.animate({'marginLeft':'60px'});
			objSide.animate({'width':'60px'});
			objSide.animate({'border-radius':'10px'});
			objIcon.removeClass('layui-icon-shrink-right');
			objIcon.addClass('layui-icon-spread-left');
			objNavChild.animate({'padding-left':'0px'});
		}
	});
	//展示左侧导航
	$('.layui-side').on('mouseover',function(){
		/*if($(this).width()==60){
			$('.flexible').trigger('click');
		}*/
	});
	//刷新当前页面
	$('.refresh').on('click',function(){
		var layid = $('.layui-tab .layui-this .layui-tab-close').parent().attr("lay-id");
		$('.layui-tab .layui-this .layui-tab-close').trigger('click');
		$('.layui-nav a[lay-id="'+layid+'"]').trigger('click');
	});
	//安全退出
	$('.logout').on('click',function(){
		layer.confirm('是否确定退出系统？', {icon: 3, title:'系统信息'}, function(index){
			$.ajax({
				url:'/user/logout',
				type:'post',
				beforeSend:function(){//console.log(JSON.stringify(data.field));
				},
				success:function(data){//do something
					if(data.code===0){
						layer.msg('安全退出！',{icon:1});
						window.location.href = '/';
					} else {
						layer.alert(data.msg,{icon:2});
					}
				},
				error:function(data){//do something
					layer.msg('与服务器连接失败',{icon: 2});
				}
			});
			layer.close(index);
		});
	});

	//个人资料
	$('#personalEdit').on('click',function(){
		layer.open({
			title: '个人资料',
			type: 2,
			shade: false,
			area: ['600px', '400px'],
			maxmin: true,
			btnAlign: 'c',
			anim: 0,
			shade: [0.5, 'rgb(0,0,0)'],
			content: '/page/system/user/personalEdit',
			zIndex: layer.zIndex, //重点1
			success: function(layero){
				//layer.setTop(layero); //顶置窗口
			},
			yes: function(index, layero){
				//确认按钮
			}
		});
	});

	//修改密码
	$('#personalPassword').on('click',function(){
		layer.open({
			title: '修改密码',
			type: 2,
			area: ['400px', '330px'],
			maxmin: true,
			btnAlign: 'c',
			anim: 0,
			shade: [0.5, 'rgb(0,0,0)'],
			content: '/page/system/user/modifyPwd',
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