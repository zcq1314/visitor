package com.dsp.visitor.controller;

import com.dsp.visitor.entity.Fun;
import com.dsp.visitor.entity.Result;
import com.dsp.visitor.entity.Role;
import com.dsp.visitor.entity.User;
import com.dsp.visitor.services.FunServiceImpl;
import com.dsp.visitor.services.RoleServiceImpl;
import com.github.pagehelper.Page;
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
@RequestMapping(value = "/role")
public class RoleController {

    @Autowired
    private RoleServiceImpl roleService;

    @Autowired
    private FunServiceImpl funService;

    /**
     * 查询所有权限信息
     * @param role
     * @param response
     * @return
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Result list(Integer page, Integer limit ,Role role, HttpServletResponse response)throws Exception{

        PageHelper.startPage(page,limit);
        List<Role> roleList = roleService.list(role);
        PageInfo<Role> pageInfo = new PageInfo<>(roleList);

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
     * @param role
     * @param response
     * @return
     */
    @RequestMapping(value = "/all")
    @ResponseBody
    public Result all(Role role, HttpServletResponse response)throws Exception{

        List<Role> roleList = roleService.list(role);

        Result result = new Result();

        result.setSuccess("获取成功");
        result.setData(roleList);
        result.setCount(roleList.size());

        return result;
    }

    /**
     * 获取用户权限
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/findUserFun")
    @ResponseBody
    public Result findUserFun(HttpServletRequest request, HttpServletResponse response)throws Exception{

        User user = (User) request.getSession().getAttribute("userInfo");

        Role role  = roleService.findById(user.getRoleId());
        String[] roleFuns = role.getFuns().split(",");

        List<Fun> list  = funService.all();

        List<Fun> userFuns = new ArrayList<>();

        for(String rolf : roleFuns){
            for(Fun fun : list){
                if(Integer.parseInt(rolf) == fun.getId()){
                    userFuns.add(fun);
                    break;
                }
            }
        }
        List<Object> objs = new ArrayList<>();
        List<Fun> funs = list.stream().filter(v -> v.getPid()==0).collect(Collectors.toList());

        for(Fun fun :funs){
            Map<String, Object> roles = new LinkedHashMap<>();
            roles.put("parent",fun);
            List<Fun> childs = userFuns.stream().filter(v -> v.getPid().equals(fun.getId())).collect(Collectors.toList());
            roles.put("childs",childs);

            objs.add(roles);
        }
        Result result = new Result();
        if(objs.size() > 0){
            result.setSuccess("成功");
            result.setData(objs);
        }else{
            result.setError("失败");
        }

        return result;
    }

    /**
     * 获取角色权限
     * @param id
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/findFun")
    @ResponseBody
    public Result save(Integer id, HttpServletRequest request, HttpServletResponse response)throws Exception{

        Result result = new Result();

        Role role  = roleService.findById(id);

        if(role != null){
            result.setSuccess("成功");
            result.setData(role);
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
    public Result add(Role role, HttpServletRequest request, HttpServletResponse response)throws Exception{


        int resultTotal = 0;

        if(role.getId()==null){
            role.setAddTime(new Date());
            resultTotal = roleService.add(role);
        }else{
            resultTotal = roleService.update(role);
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

        Integer num = roleService.delete(id);

        Result result = new Result();

        if(num>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

}
