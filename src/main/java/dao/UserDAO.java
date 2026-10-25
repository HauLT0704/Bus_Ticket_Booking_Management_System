/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

/**
 *
 * @author Lâm Trung Hậu (TV1)
 */
public class UserDAO extends DBContext {
    
    

    public User checkLogin(String username, String password) {
        String sql = "SELECT Id, Username, Password, Role, FullName, Email, Phone, Status, CreatedAt \n"
                + "FROM Users \n"
                + "WHERE Username = ? AND Password = ?";
        try {

            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashMd5(password));
            
            

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("Id"), rs.getString("Username"), rs.getString("Password"), rs.getString("Role"), rs.getString("FullName"), rs.getString("Email"), rs.getString("Phone"), rs.getString("Status"), rs.getTimestamp("CreatedAt"));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private String hashMd5(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] mess = md.digest(raw.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : mess) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return "";
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT Id, Username, Password, Role, FullName, Email, Phone, Status, CreatedAt \n"
                + "FROM Users \n"
                + "WHERE Username = ?";

        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("Id"), rs.getString("Username"), rs.getString("Password"), rs.getString("Role"), rs.getString("FullName"), rs.getString("Email"), rs.getString("Phone"), rs.getString("Status"), rs.getTimestamp("CreatedAt"));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(User u) {
        String sql = "Insert into Users (Username, Password, Role, FullName, Email, Phone, Status)\n"
                + "Values (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, hashMd5(u.getPassword()));
            ps.setString(3, u.getRole() != null ? u.getRole() : "user");
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getPhone());
            ps.setString(7, "Hoạt động");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
