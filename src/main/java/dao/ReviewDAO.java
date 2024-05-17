package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import common.JDBCConnect;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dto.ReviewDTO;

public class ReviewDAO {
	
	public List<ReviewDTO> selectList(Map<String, String> map) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String orderBy = map.get("orderBy");
		System.out.println("DAO 로 넘어온 orderBy 값:"+orderBy);
		
		List<ReviewDTO> reviews = new ArrayList<ReviewDTO>();
		String sql = "select r.grade, c.cus_id, r.regDate, r.content from customer c "
				+ " join review r "
				+ " on c.cus_seq = r.cus_seq ";
		if (orderBy != null && orderBy.equals("latest")) {
			sql += " order by r.regDate desc ";
		} else if (orderBy != null && orderBy.equals("oldest")) {
			sql += " order by r.regDate asc ";
		} else if (orderBy != null && orderBy.equals("highest")) {
			sql += " order by r.grade desc, r.regDate desc ";
		} else if (orderBy != null && orderBy.equals("lowest")) {
			sql += " order by r.grade asc, r.regDate desc ";
		} else {
			sql += " order by r.regDate desc "; // 디폴트 정렬
		}
		sql += " limit ? offset ? ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(map.get("amount")));
			pstmt.setInt(2, Integer.parseInt(map.get("offset")));
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int grade = rs.getInt("r.grade");
				String userId = rs.getString("c.cus_id");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("r.content");
				
				ReviewDTO dto = new ReviewDTO(grade, userId, reviewDate, content);
				reviews.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return reviews;
	}
	
	public int selectCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int totalCount = 0;
		
		String sql = "select count(re_seq) as cnt from review";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return totalCount;
	}
}
