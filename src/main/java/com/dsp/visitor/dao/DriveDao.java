package com.dsp.visitor.dao;

import com.dsp.visitor.entity.Drive;

import java.util.List;


public interface DriveDao {

    public List<Drive> list(Drive drive);

    public Integer add(Drive drive);

    public Integer update(Drive drive);

    public Integer delete(Integer id);
}
