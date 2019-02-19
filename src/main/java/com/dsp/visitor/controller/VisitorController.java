package com.dsp.visitor.controller;

import com.dsp.visitor.entity.*;
import com.dsp.visitor.services.LogServiceImpl;
import com.dsp.visitor.services.UserServiceImpl;
import com.dsp.visitor.services.VisitorServiceImpl;
import com.dsp.visitor.utils.HttpUtil;
import com.dsp.visitor.utils.ReflexUtils;
import com.github.andyczy.java.excel.ExcelUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;


@Controller
@RequestMapping(value = "/visitor")
public class VisitorController {

    @Autowired
    private VisitorServiceImpl visitorService;

    /**
     * 查询所有访客信息
     * @param page
     * @param limit
     * @param visitor
     * @param response
     * @return
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Result list(Integer page, Integer limit , Visitor visitor,
                       HttpServletResponse response)throws Exception{

        PageHelper.startPage(page,limit);
        List<Visitor> visitors = visitorService.list(visitor);
        PageInfo<Visitor> pageInfo = new PageInfo<>(visitors);

        Result result = new Result();

        if(pageInfo.getTotal() > 0){
            result.setSuccess("获取成功");
            result.setData(pageInfo.getList());
            result.setCount((int) pageInfo.getTotal());
        }else{
            result.setSuccess("暂无数据");
            result.setCount(0);
        }

        return result;
    }

    /**
     * 添加或修改访客
     * @param visitor
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/save")
    @ResponseBody
    public Result save(Visitor visitor, HttpServletRequest request, HttpServletResponse response)throws Exception{

        Result result = new Result();
        int resultTotal = 0;
        if(visitor.getId()==null){
            visitor.setTime(new Date());
            resultTotal = visitorService.add(visitor);
        }else{
            resultTotal = visitorService.update(visitor);
        }

        if(resultTotal>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }
    
    /**
     * 删除访客
     * @param id
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/delete")
    @ResponseBody
    public Result delete(Integer id, HttpServletResponse response)throws Exception{

        Integer num = visitorService.delete(id);

        Result result = new Result();

        if(num>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }


    @RequestMapping(value = "/export")
    public void export(HttpServletResponse response){

        List<Visitor> visitors = visitorService.list(null);
        ExcelUtils excelUtils = ExcelUtils.initialization();

        String[] headers = new String[]{"编号","姓名","性别(1为男生,2为女生)","联系方式","联系地址","备注","类型(1为正常,2为黑名单)","时间"};
        // 必填项--导出数据（参数请看下面的格式）
        excelUtils.setDataLists(ReflexUtils.exportSet(visitors,headers));
        // 必填项--sheet名称（如果是多表格导出、sheetName也要是多个值！）
        excelUtils.setSheetName(new String[]{"sheet1"});
        // 文件名称(可为空，默认是：sheet 第一个名称)
        //excelUtils.setFileName(excelName);

        // web项目response响应输出流：必须填、有本地测试方法:ExcelUtils.testLocalNoStyleNoResponse()、输出地址为本地！
        excelUtils.setResponse(response);

        //执行导出
        excelUtils.exportForExcelsNoStyle();
    }

    @RequestMapping(value = "/import")
    public void importExcel(MultipartFile file) {

        List<Visitor> visitors = ReflexUtils.execlToList(Visitor.class,file);

        visitorService.batchSave(visitors);

        System.out.println("____________");
    }
    
}
