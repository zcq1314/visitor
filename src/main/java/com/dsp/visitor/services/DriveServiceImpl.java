package com.dsp.visitor.services;

import com.dsp.visitor.dao.AddressDao;
import com.dsp.visitor.dao.DriveDao;
import com.dsp.visitor.entity.Address;
import com.dsp.visitor.entity.Drive;
import com.dsp.visitor.utils.aop.Describe;
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

    @Describe(opModule = "设备模块",opType = 1,opContent = "新增的设备为：【#{#drive.name}】")
    public Integer add(Drive drive) {
        return driveDao.add(drive);
    }

    @Describe(opModule = "设备模块",opType = 2,opContent = "修改的设备为：【#{#drive.name}】")
    public Integer update(Drive drive) {
        return driveDao.update(drive);
    }


    @Describe(opModule = "设备模块",opType = 3,opContent = "删除的设备编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return driveDao.delete(id);
    }
}
