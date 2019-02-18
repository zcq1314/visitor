package com.dsp.visitor.dao;


import com.dsp.visitor.entity.Role;

import java.util.List;


public interface RoleDao {

    public Role findById(Integer id);

    public List<Role> list(Role role);

    public Integer add(Role role);

    public Integer update(Role role);

    public Integer delete(Integer id);
}
