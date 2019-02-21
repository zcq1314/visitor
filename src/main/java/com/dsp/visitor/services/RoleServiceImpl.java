package com.dsp.visitor.services;

import com.dsp.visitor.dao.RoleDao;
import com.dsp.visitor.entity.Role;
import com.dsp.visitor.utils.aop.Describe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


/**
 * 用户Service层
 */
@Service("RoleServiceImpl")
public class RoleServiceImpl {

    @Autowired
    private RoleDao roleDao;

    public List<Role> list(Role role) {
        return roleDao.list(role);
    }

    public Role findById(Integer id) {
        return roleDao.findById(id);
    }

    @Describe(opModule = "角色模块",opType = 1,opContent = "新增的角色为：【#{#role.name}】")
    public Integer add(Role role) {
        return roleDao.add(role);
    }

    @Describe(opModule = "角色模块",opType = 2,opContent = "修改的角色为：【#{#role.name}】")
    public Integer update(Role role) {
        return roleDao.update(role);
    }

    @Describe(opModule = "角色模块",opType = 3,opContent = "删除的用户编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return roleDao.delete(id);
    }
}
