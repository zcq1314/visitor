package com.dsp.visitor.controller;

import com.dsp.visitor.entity.Result;
import com.dsp.visitor.services.FunServiceImpl;
import com.dsp.visitor.entity.Fun;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

/**
 *
 * 资源信息视图层
 *
 */
@Controller
@RequestMapping(value = "/fun")
public class FunController {

	@Resource(name="FunServiceImpl")
	private FunServiceImpl funService;

	/**
	 * 查询所有资源信息
	 * @param page
	 * @param limit
	 * @param fun
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/list")
	@ResponseBody
	public Result list(Integer page, Integer limit , Fun fun,
					   HttpServletResponse response)throws Exception{

		Result result = new Result();

		if(page!=null && limit !=null){
			PageHelper.startPage(page,limit);
			List<Fun> funList = funService.list(fun);
			PageInfo<Fun> pageInfo = new PageInfo<>(funList);

			result.setSuccess("获取成功");
			result.setData(pageInfo.getList());
			result.setCount((int) pageInfo.getTotal());

		}else{
			List<Fun> funList = funService.list(fun);
			result.setSuccess("获取成功");
			result.setData(funList);
			result.setCount(funList.size());
		}

		return result;
	}

	/**
	 * 获取功能菜单
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/allFun")
	@ResponseBody
	public Result allFun(HttpServletRequest request, HttpServletResponse response)throws Exception{

		Result result = new Result();

		List<Fun> funs  = funService.all();

		List<Object> objs = new ArrayList<>();
		List<Fun> parent = funs.stream().filter(v -> v.getPid()==0).collect(Collectors.toList());

		for(Fun fun :parent){
			Map<String, Object> roles = new LinkedHashMap<>();
			roles.put("parent",fun);
			List<Fun> childs = funs.stream().filter(v -> Objects.equals(v.getPid(), fun.getId())).collect(Collectors.toList());
			roles.put("childs",childs);

			objs.add(roles);
		}

		if(funs.size() >= 1){
			result.setSuccess("成功");
			result.setCount(objs.size());
			result.setData(objs);
		}else{
			result.setError("失败");
		}

		return result;
	}

	/**
	 * 保存修改功能
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/save")
	@ResponseBody
	public Result add(Fun fun, HttpServletRequest request, HttpServletResponse response)throws Exception{

		int resultTotal = 0;

		if(fun.getId()==null){
			fun.setAddTime(new Date());
			resultTotal = funService.add(fun);
		}else{
			resultTotal = funService.update(fun);
		}
		Result result=new Result();

		if(resultTotal>0){
			result.setSuccess("成功");
		}else{
			result.setError("失败");
		}
		return result;
	}

	/**
	 * 删除权限
	 * @param id
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Result delete(Integer id, HttpServletResponse response)throws Exception{

		Integer num = funService.delete(id);

		Result result = new Result();

		if(num>0){
			result.setSuccess("成功");
		}else{
			result.setError("失败");
		}

		return result;
	}

}
