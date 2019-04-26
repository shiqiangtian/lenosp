package com.len.service.impl;

import com.len.base.BaseMapper;
import com.len.base.impl.BaseServiceImpl;
import com.len.entity.SysNew;
import com.len.entity.SysRoleUser;
import com.len.entity.SysUser;
import com.len.mapper.SysNewMapper;
import com.len.service.NewService;
import com.len.service.SysUserService;
import com.len.util.Checkbox;
import com.len.util.JsonUtil;
import com.len.util.ReType;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by 师利梅 on 2019/4/24.
 */
@Service
public class NewServiceImpl extends BaseServiceImpl<SysNew, String> implements NewService {

    @Autowired
    private SysNewMapper sysNewMapper;

    @Override
    public BaseMapper<SysNew, String> getMappser() {
        return sysNewMapper;
    }

    @Override
    public List<SysNew> selectListByPage(SysNew record) {
        List<SysNew> sysNews = sysNewMapper.selectListByPage(record);
        return sysNews;
    }
}
