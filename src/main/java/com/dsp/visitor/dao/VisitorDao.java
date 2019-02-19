package com.dsp.visitor.dao;

import com.dsp.visitor.entity.Visitor;
import java.util.List;

/**
 */

/**
 * 访客Dao接口层
 */
public interface VisitorDao {

    /**
     * 查询所有访客信息
     * @param visitor
     * @return
     */
    public List<Visitor> list(Visitor visitor);

    /**
     * 添加访客
     * @param visitor
     * @return
     */
    public Integer add(Visitor visitor);

    /**
     * 添加访客
     * @param visitors
     * @return
     */
    public Integer batchSave(List<Visitor> visitors);

    /**
     * 修改访客
     * @param visitor
     * @return
     */
    public Integer update(Visitor visitor);

    /**
     * 删除访客
     * @param id
     * @return
     */
    public Integer delete(Integer id);

}
