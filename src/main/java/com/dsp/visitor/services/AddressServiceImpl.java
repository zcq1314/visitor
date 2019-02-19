package com.dsp.visitor.services;

import com.dsp.visitor.dao.AddressDao;
import com.dsp.visitor.dao.RoleDao;
import com.dsp.visitor.entity.Address;
import com.dsp.visitor.entity.Role;
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

    public Integer add(Address address) {
        return addressDao.add(address);
    }

    public Integer update(Address address) {
        return addressDao.update(address);
    }

    public Integer delete(Integer id) {
        return addressDao.delete(id);
    }
}
