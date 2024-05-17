package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import eibooks.common.JDBCConnect;

public class CustomerDAO {

	public int getCustomerCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int cusCnt = 0;
		
		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			String sql = "select count(cus_seq) as cnt from customer";
			// 3. sql창
			pstmt = conn.prepareStatement(sql);
			
			// 4. execute
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cusCnt = rs.getInt("cnt");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		return cusCnt;
	}
	
}
