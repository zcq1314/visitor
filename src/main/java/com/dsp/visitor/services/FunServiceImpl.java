package com.dsp.visitor.services;


import com.dsp.visitor.dao.FunDao;
import com.dsp.visitor.entity.Fun;
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

    public Integer add(Fun fun) {
        return funDao.add(fun);
    }

    public Integer update(Fun fun) {
        return funDao.update(fun);
    }

    public Integer delete(Integer id) {
        return funDao.delete(id);
    }
}
