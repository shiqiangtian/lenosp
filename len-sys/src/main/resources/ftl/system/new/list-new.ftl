<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>新闻管理</title>
</head>

<meta charset="UTF-8">
<title>用户管理</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
      content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi"/>
<link rel="stylesheet" href="${re.contextPath}/plugin/layui/css/layui.css">
<link rel="stylesheet" href="${re.contextPath}/plugin/lenos/main.css">
<script type="text/javascript" src="${re.contextPath}/plugin/jquery/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${re.contextPath}/plugin/layui/layui.all.js"
        charset="utf-8"></script>
<script type="text/javascript" src="${re.contextPath}/plugin/tools/tool.js"></script>
<body>
<div class="layui-col-md12" style="height:40px;margin-top:3px;">
    <div class="layui-btn-group">
    <@shiro.hasPermission name="new:add">
        <button class="layui-btn layui-btn-normal" data-type="add">
            <i class="layui-icon">&#xe608;</i>新增
        </button>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="new:update">
        <button class="layui-btn layui-btn-normal" data-type="update">
            <i class="layui-icon">&#xe642;</i>编辑
        </button>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="new:select">
        <button class="layui-btn layui-btn-normal" data-type="detail">
            <i class="layui-icon">&#xe605;</i>查看
        </button>
    </@shiro.hasPermission>
    </div>
</div>
<table id="newList" class="layui-hide" lay-filter="new"></table>
<script type="text/html" id="toolBar">
    <@shiro.hasPermission name="new:add">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="new:update">
    <a class="layui-btn layui-btn-xs  layui-btn-normal" lay-event="edit">编辑</a>
    </@shiro.hasPermission>
    {{#  if(!d.status){ }}
    {{#  } }}
    {{# if(d.status){ }}
    {{#  } }}
    <@shiro.hasPermission name="new:del">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@shiro.hasPermission>
</script>
<script type="text/html" id="switchTpl">
    <input type="checkbox" name="newType" lay-skin="switch" lay-text="娱乐|体育|财经" lay-filter="sexDemo">
</script>
<script>
    layui.laytpl.toDateString = function(d, format){
        var date = new Date(d || new Date())
                ,ymd = [
            this.digit(date.getFullYear(), 4)
            ,this.digit(date.getMonth() + 1)
            ,this.digit(date.getDate())
        ]
                ,hms = [
            this.digit(date.getHours())
            ,this.digit(date.getMinutes())
            ,this.digit(date.getSeconds())
        ];

        format = format || 'yyyy-MM-dd HH:mm:ss';

        return format.replace(/yyyy/g, ymd[0])
                .replace(/MM/g, ymd[1])
                .replace(/dd/g, ymd[2])
                .replace(/HH/g, hms[0])
                .replace(/mm/g, hms[1])
                .replace(/ss/g, hms[2]);
    };

    //数字前置补零
    layui.laytpl.digit = function(num, length, end){
        var str = '';
        num = String(num);
        length = length || 2;
        for(var i = num.length; i < length; i++){
            str += '0';
        }
        return num < Math.pow(10, length) ? str + (num|0) : num;
    };
    layui.use('table', function () {
        var table = layui.table;
        //方法级渲染
        table.render({
            id: 'newList',
            elem: '#newList'
            , url: 'showNewList'
            , cols: [[
                {checkbox: true, fixed: true, width: '5%'}
                , {field: 'newId', title: '新闻编号', width: '10%', sort: true}
                , {field: 'newName', title: '新闻名称', width: '10%', sort: true}
                , {field: 'newType', title: '新闻类型', width: '10%', sort: true,templet:function (row) {
                    if (row.newType == 1) {
                        return "娱乐";
                    } else if (row.newType == 2) {
                        return "体育";
                    } else if (row.newType == 3) {
                        return "财经";
                    }
                }}
                , {field: 'newTime', title: '发布时间', width: '10%',templet: '<div>{{ layui.laytpl.toDateString(d.newTime,"yyyy-MM-dd") }}</div>'}
                , {field: 'text', title: '操作', width: '10%', toolbar:'#toolBar'}
            ]]
            , page: true
            ,limits: [2, 5, 10, 20, 50]
            ,height: 'full-83'
        });

        var $ = layui.$, active = {
            select: function () {
                var newName = $('#newName').val();
                var newType = $('#newType').val();
                table.reload('newList', {
                    where: {
                        newName: newName,
                        newType: newType
                    }
                });
            },
            reload:function(){
                $('#newName').val('');
                $('#newType').val('');
                table.reload('newList', {
                    where: {
                        newName: null,
                        newType: null
                    }
                });
            },
            add: function () {
                add('添加任务', 'showAddNew', 700, 450);
            },
            update: function () {
                var checkStatus = table.checkStatus('newList')
                        , data = checkStatus.data;
                if (data.length != 1) {
                    layer.msg('请选择一行编辑', {icon: 5});
                    return false;
                }
                if(data[0].status){
                    layer.msg('已经启动任务无法更新,请停止后更新',{icon:5,offset: 'rb',area:['200px','100px'],anim:2});
                    return false;
                }
                update('编辑任务', 'updateNew?id=' + data[0].id, 700, 450);
            },
            detail: function () {
            detail: function () {
                var checkStatus = table.checkStatus('newList')
                        , data = checkStatus.data;
                if (data.length != 1) {
                    layer.msg('请选择一行查看', {icon: 5});
                    return false;
                }
                detail('查看任务信息', 'updateNew?id=' + data[0].id, 700, 450);
            }
        };
        table.on('tool(new)', function (obj) {
            var data = obj.data;
            if (obj.event === 'detail') {
                detail('编辑角色', 'updateNew?id=' + data.id, 700, 450);
            } else if (obj.event === 'del') {
                if(!data.status) {
                    layer.confirm('确定删除任务[<label style="color: #00AA91;">' + data.newName + '</label>]?',
                            function () {
                                del(data.id);
                            });
                }else{
                    layer.msg('已经启动任务无法更新,请停止后删除',{icon:5,offset: 'rb',area:['200px','100px'],anim:2});
                }
            } else if (obj.event === 'edit') {
                if(!data.status){
                    update('编辑任务', 'updateNew?id=' + data.id, 700, 450);
                }else{
                    layer.msg('已经启动任务无法更新,请停止后更新',{icon:5,offset: 'rb',area:['200px','100px'],anim:2});
                }
            } else if(obj.event === 'start'){
                layer.confirm('确定开启任务[<label style="color: #00AA91;">' + data.newName + '</label>]?', function(){
                    reqByAjax(data.id,'startnew','newList');
                });
            } else if(obj.event === 'end'){
                layer.confirm('确定停止任务[<label style="color: #00AA91;">' + data.newName + '</label>]?', function(){
                    reqByAjax(data.id,'endnew','newList');
                });
            }
        });

        $('.layui-col-md12 .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        $('.select .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
    });
    function reqByAjax(id,url,tableId){
        $.ajax({
            url: url,
            type: "post",
            data: {id: id},
            success: function (d) {
                if(d.flag){
                    layer.msg(d.msg,{icon:6,offset: 'rb',area:['120px','80px'],anim:2});
                    layui.table.reload(tableId);
                }else{
                    layer.msg(d.msg,{icon:5,offset: 'rb',area:['120px','80px'],anim:2});
                }
            }
        });
    }

    function del(id) {
        $.ajax({
            url: "del",
            type: "post",
            data: {id: id},
            success: function (d) {
                if(d.flag){
                    layer.msg(d.msg,{icon:6,offset: 'rb',area:['120px','80px'],anim:2});
                    layui.table.reload('newList');
                }else{
                    layer.msg(d.msg,{icon:5,offset: 'rb',area:['120px','80px'],anim:2});
                }
            }
        });
    }
    function detail(title, url, w, h) {
        if (title == null || title == '') {
            title = false;
        }
        if (url == null || url == '') {
            url = "error/404";
        }
        if (w == null || w == '') {
            w = ($(window).width() * 0.9);
        }
        if (h == null || h == '') {
            h = ($(window).height() - 50);
        }
        layer.open({
            id: 'user-detail',
            type: 2,
            area: [w + 'px', h + 'px'],
            fix: false,
            maxmin: true,
            shadeClose: true,
            shade: 0.4,
            title: title,
            content: url + '&detail=true',
            // btn:['关闭']
        });
    }
    /**
     * 更新用户
     */
    function update(title, url, w, h) {
        if (title == null || title == '') {
            title = false;
        }
        if (url == null || url == '') {
            url = "error/404";
        }
        if (w == null || w == '') {
            w = ($(window).width() * 0.9);
        }
        if (h == null || h == '') {
            h = ($(window).height() - 50);
        }
        layer.open({
            id: 'user-update',
            type: 2,
            area: [w + 'px', h + 'px'],
            fix: false,
            maxmin: true,
            shadeClose: false,
            shade: 0.4,
            title: title,
            content: url + '&detail=false'
        });
    }

    /*弹出层*/
    /*
     参数解释：
     title   标题
     url     请求的url
     id      需要操作的数据id
     w       弹出层宽度（缺省调默认值）
     h       弹出层高度（缺省调默认值）
     */
    function add(title, url, w, h) {
        if (title == null || title == '') {
            title = false;
        }
        if (url == null || url == '') {
            url = "error/404";
        }
        if (w == null || w == '') {
            w = ($(window).width() * 0.9);
        }
        if (h == null || h == '') {
            h = ($(window).height() - 50);
        }
        layer.open({
            id: 'new-add',
            type: 2,
            area: [w + 'px', h + 'px'],
            fix: false,
            maxmin: true,
            shadeClose: false,
            shade: 0.4,
            title: title,
            content: url
        });
    }
</script>
</body>
</html>