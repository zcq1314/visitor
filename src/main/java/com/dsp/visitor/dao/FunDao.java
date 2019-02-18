package com.dsp.visitor.dao;

import com.dsp.visitor.entity.Fun;

import java.util.List;


public interface FunDao {


    public List<Fun> list(Fun fun);

    public List<Fun> all();

    /**
     * 添加菜单
     * @param fun
     * @return
     */
    public Integer add(Fun fun);

    /**
     * 修改菜单
     * @param fun
     * @return
     */
    public Integer update(Fun fun);

    /**
     * 删除菜单
     * @param id
     * @return
     */
    public Integer delete(Integer id);

}
