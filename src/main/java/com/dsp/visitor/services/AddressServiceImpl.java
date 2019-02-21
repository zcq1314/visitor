package com.dsp.visitor.services;

import com.dsp.visitor.dao.AddressDao;
import com.dsp.visitor.dao.RoleDao;
import com.dsp.visitor.entity.Address;
import com.dsp.visitor.entity.Role;
import com.dsp.visitor.utils.aop.Describe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


/**
 * 登记点Service层
 */
@Service("AddressServiceImpl")
public class AddressServiceImpl {

    @Autowired
    private AddressDao addressDao;

    public List<Address> list(Address address) {
        return addressDao.list(address);
    }

    @Describe(opModule = "登记点模块",opType = 1,opContent = "新增的登记点为：【#{#address.address}】")
    public Integer add(Address address) {
        return addressDao.add(address);
    }

    @Describe(opModule = "登记点模块",opType = 2,opContent = "修改的登记点为：【#{#address.address}】")
    public Integer update(Address address) {
        return addressDao.update(address);
    }

    @Describe(opModule = "登记点模块",opType = 3,opContent = "删除的登记点编号为：【#{#id}】")
    public Integer delete(Integer id) {
        return addressDao.delete(id);
    }
}
