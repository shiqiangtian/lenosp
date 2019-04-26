package com.len.service;

import com.len.base.BaseService;
import com.len.entity.SysNew;

import java.util.List;

/**
 * Created by 师利梅 on 2019/4/24.
 */
public interface NewService extends BaseService<SysNew,String> {

    @Override
    List<SysNew> selectListByPage(SysNew record);
}
