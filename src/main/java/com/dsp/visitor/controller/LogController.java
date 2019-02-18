package com.dsp.visitor.controller;

import com.dsp.visitor.entity.HandleLog;
import com.dsp.visitor.entity.LoginLog;
import com.dsp.visitor.entity.Result;
import com.dsp.visitor.services.LogServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 日志控制器
 *
 * @author Ocean
 *
 */
@Controller
@RequestMapping(value = "/log")
public class LogController {

	@Resource(name = "LogServiceImpl")
	private LogServiceImpl logService;

	/**
	 * 获取操作日志列表
	 * @param page
	 * @param limit
	 * @param log
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/handler")
	@ResponseBody
	public Result list(Integer page, Integer limit , HandleLog log,
					   HttpServletResponse response)throws Exception{

		Result result = new Result();

		PageHelper.startPage(page,limit);
		List<HandleLog> logs = logService.list(log);
		PageInfo<HandleLog> pageInfo = new PageInfo<>(logs);

		result.setSuccess("获取成功");
		result.setData(pageInfo.getList());
		result.setCount((int) pageInfo.getTotal());

		return result;
	}

	/**
	 * 获取登录日志列表
	 * @param page
	 * @param limit
	 * @param log
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/login")
	@ResponseBody
	public Result list(Integer page, Integer limit , LoginLog log,
					   HttpServletResponse response)throws Exception{

		Result result = new Result();

		PageHelper.startPage(page,limit);
		List<LoginLog> logs = logService.list(log);
		PageInfo<LoginLog> pageInfo = new PageInfo<>(logs);

		result.setSuccess("获取成功");
		result.setData(pageInfo.getList());
		result.setCount((int) pageInfo.getTotal());

		return result;
	}

}
