package com.len.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.len.base.BaseController;
import com.len.core.annotation.Log;
import com.len.entity.SysJob;
import com.len.entity.SysLog;
import com.len.entity.SysNew;
import com.len.entity.SysUser;
import com.len.exception.MyException;
import com.len.service.NewService;
import com.len.util.BeanUtil;
import com.len.util.JsonUtil;
import com.len.util.ReType;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by 师利梅 on 2019/4/24.
 */
@Controller
@RequestMapping("new")
public class NewController extends BaseController{

    @Autowired
    private NewService newService;

    /**
     * 打开页面
     * @param model
     * @return
     */
    @GetMapping(value = "showNew")
    @RequiresPermissions("new:show")
    public String showUser(Model model) {
        return "/system/new/list-new";
    }

    /**
     * 分页查询
     * @param model
     * @param sysNew
     * @param page
     * @param limit
     * @return
     */
    @GetMapping(value = "showNewList")
    @RequiresPermissions("new:show")
    @ResponseBody
    public ReType showUser(Model model, SysNew sysNew, String page, String limit) {
        ReType show = newService.show(sysNew, Integer.valueOf(page), Integer.valueOf(limit));
        return show;
    }

    /**
     * 打开新增页面
     * @param model
     * @return
     */
    @GetMapping(value = "showAddNew")
    public String addJob(Model model) {
        return "/system/new/add-new";
    }

    @ApiOperation(value = "/addNew", httpMethod = "POST", notes = "添加任务类")
    @Log(desc = "添加任务")
    @PostMapping(value = "addNew")
    @ResponseBody
    public JsonUtil addNew(SysNew sysnew) {
        JsonUtil j = new JsonUtil();
        String msg = "保存成功";
        try {
            newService.insertSelective(sysnew);
        } catch (MyException e) {
            msg = "保存失败";
            j.setFlag(false);
            e.printStackTrace();
        }
        j.setMsg(msg);
        return j;
    }

    /**
     * 打开修改页面
     * @param id
     * @param model
     * @param detail
     * @return
     */
    @GetMapping(value = "updateNew")
    public String updateNew(String id, Model model, boolean detail) {
        if (StringUtils.isNotEmpty(id)) {
            SysNew sysNew = newService.selectByPrimaryKey(id);
            model.addAttribute("sysNew", sysNew);
        }
        model.addAttribute("detail", detail);
        return "system/new/update-new";
    }

    @ApiOperation(value = "/updateNew", httpMethod = "POST", notes = "更新任务")
    @Log(desc = "更新任务")
    @PostMapping(value = "updateNew")
    @ResponseBody
    public JsonUtil updateNew(SysNew sysNew) {
        JsonUtil j = new JsonUtil();
        j.setFlag(false);
        if (sysNew == null) {
            j.setMsg("获取数据失败");
            return j;
        }
        try {
            SysNew oldNew = newService.selectByPrimaryKey(sysNew.getNewId());
            BeanUtil.copyNotNullBean(sysNew, oldNew);
            newService.updateByPrimaryKey(oldNew);
            j.setFlag(true);
            j.setMsg("修改成功");
        } catch (MyException e) {
            j.setMsg("更新失败");
            e.printStackTrace();
        }
        return j;
    }
    @Log(desc = "删除任务")
    @ApiOperation(value = "/del", httpMethod = "POST", notes = "删除任务")
    @PostMapping(value = "del")
    @ResponseBody
    @RequiresPermissions("new:del")
    public JsonUtil del(String id) {
        JsonUtil j = new JsonUtil();
        j.setFlag(false);
        if (StringUtils.isEmpty(id)) {
            j.setMsg("获取数据失败");
            return j;
        }
        try {
            SysNew sysNew = newService.selectByPrimaryKey(id);
            newService.deleteByPrimaryKey(id);
            j.setFlag(true);
            j.setMsg("任务删除成功");
        } catch (MyException e) {
            j.setMsg("任务删除异常");
            e.printStackTrace();
        }
        return j;
    }


}
