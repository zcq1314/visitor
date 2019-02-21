package com.dsp.visitor.services;


import com.dsp.visitor.dao.FunDao;
import com.dsp.visitor.entity.Fun;
import com.dsp.visitor.utils.aop.Describe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


/**
 * 用户Service层
 */
@Service("FunServiceImpl")
public class FunServiceImpl{

    @Autowired
    private FunDao funDao;

    public List<Fun> list(Fun fun) {
        return funDao.list(fun);
    }

    public List<Fun> all() {
        return funDao.all();
    }

    @Describe(opModule = "资源模块",opType = 1,opContent = "新增的资源为：【#{#fun.name}】")
    public Integer add(Fun fun) {
        return funDao.add(fun);
    }

    @Describe(opModule = "资源模块",opType = 2,opContent = "修改的资源为：【#{#fun.name}】")
    public Integer update(Fun fun) {
        return funDao.update(fun);
    }

    @Describe(opModule = "资源模块",opType = 3,opContent = "删除的资源编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return funDao.delete(id);
    }
}
