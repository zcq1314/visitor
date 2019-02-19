package com.dsp.visitor.controller;

import com.dsp.visitor.entity.Address;
import com.dsp.visitor.entity.Drive;
import com.dsp.visitor.entity.Result;
import com.dsp.visitor.services.AddressServiceImpl;
import com.dsp.visitor.services.DriveServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;


@Controller
@RequestMapping(value = "/drive")
public class DriveController {

    @Autowired
    private DriveServiceImpl driveService;

    /**
     * 查询所有权限信息
     * @param drive
     * @param response
     * @return
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Result list(Integer page, Integer limit , Drive drive, HttpServletResponse response)throws Exception{

        PageHelper.startPage(page,limit);
        List<Drive> drives = driveService.list(drive);
        PageInfo<Drive> pageInfo = new PageInfo<>(drives);

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
     * 查询所有权限信息
     * @param drive
     * @param response
     * @return
     */
    @RequestMapping(value = "/all")
    @ResponseBody
    public Result all(Drive drive, HttpServletResponse response)throws Exception{

        List<Drive> roleList = driveService.list(drive);

        Result result = new Result();

        result.setSuccess("获取成功");
        result.setData(roleList);
        result.setCount(roleList.size());

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
    public Result add(Drive drive ,HttpServletRequest request, HttpServletResponse response)throws Exception{

        int resultTotal = 0;

        if(drive.getId()==null){
            drive.setAddTime(new Date());
            resultTotal = driveService.add(drive);
        }else{
            resultTotal = driveService.update(drive);
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

        Integer num = driveService.delete(id);

        Result result = new Result();

        if(num>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

}
