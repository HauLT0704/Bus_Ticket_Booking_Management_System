/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import db.DBContext;
import java.sql.Connection;

/**
 * Lớp tiện ích kết nối CSDL (Hỗ trợ theo bảng phân công TV1)
 * @author Lâm Trung Hậu (TV1)
 */
public class DBUtil {

    public static Connection getConnection() {
        DBContext db = new DBContext();
        return db.getConnection();
    }
}

