package com.dsp.visitor.services;

import com.dsp.visitor.dao.AddressDao;
import com.dsp.visitor.dao.DriveDao;
import com.dsp.visitor.entity.Address;
import com.dsp.visitor.entity.Drive;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


/**
 * 登记点Service层
 */
@Service("DriveServiceImpl")
public class DriveServiceImpl {

    @Autowired
    private DriveDao driveDao;

    public List<Drive> list(Drive drive) {
        return driveDao.list(drive);
    }

    public Integer add(Drive drive) {
        return driveDao.add(drive);
    }

    public Integer update(Drive drive) {
        return driveDao.update(drive);
    }

    public Integer delete(Integer id) {
        return driveDao.delete(id);
    }
}
