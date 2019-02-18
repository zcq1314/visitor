package com.dsp.visitor.entity;

import java.util.Date;

public class HandleLog {

    private Integer id;
    private Integer userId;
    private String userName;
    private String opMethod;
    private String opModule;
    private Integer opType;
    private String opContent;
    private Date addTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getOpMethod() {
        return opMethod;
    }

    public void setOpMethod(String opMethod) {
        this.opMethod = opMethod;
    }

    public String getOpModule() {
        return opModule;
    }

    public void setOpModule(String opModule) {
        this.opModule = opModule;
    }

    public Integer getOpType() {
        return opType;
    }

    public void setOpType(Integer opType) {
        this.opType = opType;
    }

    public String getOpContent() {
        return opContent;
    }

    public void setOpContent(String opContent) {
        this.opContent = opContent;
    }

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }
}
