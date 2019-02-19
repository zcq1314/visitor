package com.dsp.visitor.services;


import com.dsp.visitor.dao.VisitorDao;
import com.dsp.visitor.entity.Visitor;
import com.dsp.visitor.utils.aop.Describe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 访客Service层
 */
@Service("VisitorServiceImpl")
public class VisitorServiceImpl {

    @Autowired
    private VisitorDao visitorDao;

    public List<Visitor> list(Visitor visitor) {
        return visitorDao.list(visitor);
    }

    @Describe(opModule = "访客模块",opType = 1,opContent = "新增的访客为：【#{#visitor.name}】")
    public Integer add(Visitor visitor) {
        return visitorDao.add(visitor);
    }

    @Describe(opModule = "访客模块",opType = 1,opContent = "批量新增")
    public Integer batchSave(List<Visitor> visitors) {
        return visitorDao.batchSave(visitors);
    }

    @Describe(opModule = "访客模块",opType = 2,opContent = "修改的访客为：【#{#visitor.name}】")
    public Integer update(Visitor visitor) {
        return visitorDao.update(visitor);
    }

    @Describe(opModule = "访客模块",opType = 1,opContent = "删除的访客编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return visitorDao.delete(id);
    }
}
