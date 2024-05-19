package eibooks.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class JDBCConnect {

	public static Connection getConnection() {
		Connection conn = null;
		try {
			String driver = "com.mysql.cj.jdbc.Driver";
			String url = "jdbc:mysql://localhost:3306/project?serverTimezone=UTC";
			String user = "root";
			String pw = "rpass";
			Class.forName(driver);
			conn = DriverManager.getConnection(url, user, pw);
			System.out.println("conn ok!!");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
	
	public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();				
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	
	public static void close(PreparedStatement pstmt, Connection conn) {
		
		try {
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();				
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 고객정보 변경시 주소 부분때문에 추가
	public static void close(PreparedStatement addrPstmt, PreparedStatement pstmt, Connection conn) {

		try {
			if(addrPstmt != null) addrPstmt.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
