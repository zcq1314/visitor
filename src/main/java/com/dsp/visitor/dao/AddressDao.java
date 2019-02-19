package com.dsp.visitor.dao;


import com.dsp.visitor.entity.Address;

import java.util.List;


public interface AddressDao {


    public List<Address> list(Address address);

    public Integer add(Address address);

    public Integer update(Address address);

    public Integer delete(Integer id);

    public Address findById(Integer id);
}
