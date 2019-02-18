package com.dsp.visitor.controller;

import com.dsp.visitor.entity.LoginLog;
import com.dsp.visitor.entity.Result;
import com.dsp.visitor.entity.Role;
import com.dsp.visitor.entity.User;
import com.dsp.visitor.services.LogServiceImpl;
import com.dsp.visitor.services.UserServiceImpl;
import com.dsp.visitor.utils.HttpUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    private UserServiceImpl userService;

    @Autowired
    private LogServiceImpl logService;

    /**
     * 查询所有访客信息
     * @param page
     * @param limit
     * @param s_user
     * @param response
     * @return
     */
    @RequestMapping(value = "/list")
    @ResponseBody
    public Result list(Integer page, Integer limit , User s_user,
                       HttpServletResponse response)throws Exception{


        PageHelper.startPage(page,limit);
        List<User> customerList = userService.list(s_user);
        PageInfo<User> pageInfo = new PageInfo<>(customerList);

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
     * 查询所有用户
     * @param s_user
     * @param response
     * @return
     */
    @RequestMapping(value = "/findAll")
    @ResponseBody
    public Result list(User s_user, HttpServletResponse response)throws Exception{


        List<User> customerList = userService.list(s_user);

        Result result = new Result();

        result.setSuccess("获取成功");
        result.setData(customerList);
        result.setCount(customerList.size());

        return result;
    }

    /**
     * 添加或修改用户
     * @param s_user
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/save")
    @ResponseBody
    public Result save(User s_user, HttpServletRequest request, HttpServletResponse response)throws Exception{

        Result result = new Result();
        int resultTotal = 0;
        if(s_user.getId()==null){
            s_user.setAddTime(new Date());
            resultTotal=userService.add(s_user);
        }else{
            resultTotal=userService.update(s_user);

            User sesUser = (User) request.getSession().getAttribute("userInfo");

            if(s_user.getId().equals(sesUser.getId())){
                request.getSession().setAttribute("userInfo",s_user);
            }

        }

        if(resultTotal>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

    /**
     * 修改密码
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/updatePwd")
    @ResponseBody
    public Result updatePwd(HttpServletRequest request, HttpServletResponse response)throws Exception{


        User resultUser = (User) request.getSession().getAttribute("userInfo");

        String password = resultUser.getPassword();

        String password1 = request.getParameter("password1");


        Result result = new Result();

        if(!(password.equals(password1))){
            result.setError("原密码不正确");
        }else{
            password = request.getParameter("password3");
            resultUser.setPassword(password);
            userService.update(resultUser);
            result.setSuccess("成功");
        }

        return result;


    }

    /**
     * 删除用户
     * @param id
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/delete")
    @ResponseBody
    public Result delete(Integer id, HttpServletResponse response)throws Exception{

        Integer num = userService.delete(id);

        Result result = new Result();

        if(num>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

    /**
     * 修改用户密码
     * @param s_user
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/modifyPassword")
    @ResponseBody
    public Result modifyPassword(User s_user,HttpServletResponse response) throws Exception{

        int resultTotal = userService.update(s_user);

        Result result = new Result();

        if(resultTotal>0){
            result.setSuccess("成功");
        }else{
            result.setError("失败");
        }

        return result;
    }

    /**
     * 退出登录
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/logout")
    @ResponseBody
    public Result logout(HttpSession session){
        session.invalidate();
        Result result = new Result();
        result.setSuccess("成功");
        return result;
    }
}
