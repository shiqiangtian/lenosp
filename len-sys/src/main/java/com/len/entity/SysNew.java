package com.len.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by 师利梅 on 2019/4/24.
 */

@Table(name = "sys_new")
@Data
@ToString
public class SysNew {

    @Id
    @Column(name = "new_id")
    private Integer newId;
    @Column(name = "new_name")
    private String newName;
    @Column(name = "new_type")
    private Integer newType;
    @Column(name = "new_Time")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date newTime;

    public SysNew() {
    }

    public SysNew(Integer newId, String newName, Integer newType, Date newTime) {
        this.newId = newId;
        this.newName = newName;
        this.newType = newType;
        this.newTime = newTime;
    }
}
