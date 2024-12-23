package com.example.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Data
@Entity
@Table(name = "admin")
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank
    @Column(length = 50, unique = true, nullable = false)
    private String username;

    @NotBlank
    @Column(length = 255, nullable = false)
    private String password;

    @Email
    @Column(length = 100, unique = true)
    private String email;

    @Pattern(regexp = "^\\d{11}$", message = "手机号必须是11位数字")
    @Column(length = 20, unique = true)
    private String phone;

    @Column(length = 50)
    private String role;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @UpdateTimestamp
    @Column(name = "last_login")
    private Date lastLogin;

    @Column(length = 20)
    @NotNull
    private String status = "active";

    @Column(name = "profile_picture", length = 255)
    private String profilePicture;

    @Column(name = "login_type", length = 20)
    @Enumerated(EnumType.STRING)
    private LoginType loginType;

    @CreationTimestamp
    @Column(name = "registration_date")
    private Date registrationDate;

    // 登录类型枚举
    public enum LoginType {
        email, phone, username
    }
} 