package com.dsp.visitor.entity;

import java.util.Date;

/**
 *
 * @name
 */
public class Role {

    private Integer id;

    private String name;

    private String funs;

    private String remark;

    private Date addTime;

    public String getFuns() {
        return funs;
    }

    public void setFuns(String funs) {
        this.funs = funs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }
}
