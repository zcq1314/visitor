package com.dsp.visitor.services;


import com.dsp.visitor.dao.UserDao;
import com.dsp.visitor.entity.User;
import com.dsp.visitor.utils.aop.Describe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 用户Service层
 */
@Service("UserServiceImpl")
public class UserServiceImpl{

    @Autowired
    private UserDao userDao;

    public User login(User user) {
        return userDao.login(user);
    }

    public User findByUserName(String userName) {
        return userDao.findByUserName(userName);
    }

    public List<User> list(User user) {
        return userDao.list(user);
    }

    public Long getTotal(Map<String, Object> map) {
        return userDao.getTotal(map);
    }


    @Describe(opModule = "角色模块",opType = 1,opContent = "新增的用户为：【#{#user.trueName}】")
    public Integer add(User user) {
        return userDao.add(user);
    }

    @Describe(opModule = "用户模块",opType = 2,opContent = "修改的用户为：【#{#user.trueName}】")
    public Integer update(User user) {
        return userDao.update(user);
    }

    @Describe(opModule = "用户模块",opType = 1,opContent = "删除的用户编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return userDao.delete(id);
    }
}
