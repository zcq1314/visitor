package com.dsp.visitor.controller;

import com.dsp.visitor.entity.*;
import com.dsp.visitor.services.AddressServiceImpl;
import com.dsp.visitor.services.FunServiceImpl;
import com.dsp.visitor.services.RoleServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;


@Controller
@RequestMapping(value = "/address")
public class AddressController {

    @Autowired
    private AddressServiceImpl addressService;

    /**
     * 查询所有权限信息
     * @param address
     * @param response
     * @return
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Result list(Integer page, Integer limit , Address address, HttpServletResponse response)throws Exception{

        PageHelper.startPage(page,limit);
        List<Address> addresses = addressService.list(address);
        PageInfo<Address> pageInfo = new PageInfo<>(addresses);

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
     * @param address
     * @param response
     * @return
     */
    @RequestMapping(value = "/all")
    @ResponseBody
    public Result all(Address address, HttpServletResponse response)throws Exception{

        List<Address> roleList = addressService.list(address);

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
    public Result add(Address address ,HttpServletRequest request, HttpServletResponse response)throws Exception{


        int resultTotal = 0;

        if(address.getId()==null){
            address.setAddTime(new Date());
            resultTotal = addressService.add(address);
        }else{
            resultTotal = addressService.update(address);
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

        Integer num = addressService.delete(id);

        Result result = new Result();

        if(num>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

}
