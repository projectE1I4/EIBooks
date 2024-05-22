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
	
	public List<ReviewDTO> selectList(ReviewDTO dto, Map<String, String> map) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String orderBy = map.get("orderBy");
		
		List<ReviewDTO> reviews = new ArrayList<ReviewDTO>();
		String sql = "select * from review r "
				+ " join customer c "
				+ " on c.cus_seq = r.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where r.book_seq = ? and depth = 1 ";
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
			pstmt.setInt(1, dto.getBookNum());
			pstmt.setInt(2, Integer.parseInt(map.get("amount")));
			pstmt.setInt(3, Integer.parseInt(map.get("offset")));
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int bookNum = rs.getInt("r.book_seq");
				int userNum = rs.getInt("r.cus_seq");
				int grade = rs.getInt("r.grade");
				int reviewNum = rs.getInt("re_seq");
				String userId = rs.getString("c.cus_id");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("r.content");
				
				ReviewDTO dtos = new ReviewDTO(bookNum, reviewNum, grade, userId, reviewDate, content);
				dtos.setUserNum(userNum);
				reviews.add(dtos);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return reviews;
	}
	
	public ReviewDTO selectReply(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int dBookNum = dto.getBookNum();
		int ref_seq = dto.getReviewNum();
		
		ReviewDTO review = new ReviewDTO();
		
		String sql = " select * from customer c "
				+ " join review r "
				+ " on c.cus_seq = r.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where r.book_seq = ? "
				+ " and ref_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dBookNum);
			pstmt.setInt(2, ref_seq);
			rs = pstmt.executeQuery();
			
			dto = null;
			
			if(rs.next()) {
				int bookNum = rs.getInt("book_seq");
				int userNum = rs.getInt("cus_seq");
				String reviewDate = rs.getString("r.regDate");
				// 재밌어서 넣었어요
				System.out.println("소름 돋아요..." + reviewDate);
				String content = rs.getString("content");
				int reviewNum = rs.getInt("re_seq");
				int refSeq = rs.getInt("ref_seq");
				
				review.setBookNum(bookNum);
				review.setUserNum(userNum);
				review.setReviewDate(reviewDate);
				review.setContent(content);
				review.setReviewNum(reviewNum);
				review.setRef_seq(refSeq);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return review;
	}
	
	public int selectCount(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int totalCount = 0;
		
		String sql = "select count(re_seq) as cnt from review "
				+ " where book_seq = ? "
				+ " and depth = 1 ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBookNum());
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

	public int insertWrite(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "INSERT INTO review (cus_seq, book_seq, content, grade) VALUES (?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getUserNum());
			pstmt.setInt(2, dto.getBookNum());
			pstmt.setString(3, dto.getContent());
			pstmt.setInt(4, dto.getGrade());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}

	public int reviewCount(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int reviewCount = 0;
		
		String sql = "select count(r.re_seq) as reviewCnt from review r "
				+ " join customer c "
				+ " on r.cus_seq = c.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where b.book_seq = ? "
				+ " and r.cus_seq = ? ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBookNum());
			pstmt.setInt(2, dto.getUserNum());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				reviewCount = rs.getInt("reviewCnt");
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return reviewCount;
	}
	
	public ReviewDTO selectView(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int dBookNum = dto.getBookNum();
		int userNum = dto.getUserNum();
		
		String sql = "select * from review r "
				+ " join customer c "
				+ " on r.cus_seq = c.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where r.book_seq = ? "
				+ " and r.cus_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dBookNum);
			pstmt.setInt(2, userNum);
			rs = pstmt.executeQuery();
			
			dto = null;
			
			if(rs.next()) {
				int grade = rs.getInt("r.grade");
				String content = rs.getString("r.content");
				int bookNum = rs.getInt("r.book_seq");
				String userId = rs.getString("c.cus_id");
				int reviewNum = rs.getInt("re_seq");
				dto = new ReviewDTO(bookNum, reviewNum, grade, userId, content);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	public int updateWrite(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "update review r "
					+ " join customer c "
					+ " on r.cus_seq = c.cus_seq "
					+ " join books b "
					+ " on r.book_seq = b.book_seq "
					+ " set r.grade = ?, r.content = ?"
					+ " where r.book_seq = ? "
					+ " and r.cus_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getGrade());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getBookNum());
			pstmt.setInt(4, dto.getUserNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		
		return rs;
	}

	public int deleteWrite(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "DELETE r FROM review r "
					+ " join customer c "
					+ " on c.cus_seq = r.cus_seq "
					+ " join books b "
					+ " on r.book_seq = b.book_seq "
					+ " where r.cus_seq = ? "
					+ " and r.book_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getUserNum());
			pstmt.setInt(2, dto.getBookNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}
	
	public int insertReply(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " INSERT INTO review (cus_seq, book_seq, content, depth, ref_seq) VALUES (?, ?, ?, 2, ?);";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getUserNum());
			pstmt.setInt(2, dto.getBookNum());
			pstmt.setString(3, dto.getContent());
			pstmt.setInt(4, dto.getRef_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}
	
	public int allReviewCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int allReviews = 0;
		
		String sql = "select count(re_seq) as allReviewCnt from review "
				+ " where depth = 1 ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				allReviews = rs.getInt("allReviewCnt");
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return allReviews;
	}
	
	public List<ReviewDTO> selectAllList(Map<String, String> map) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ReviewDTO> reviews = new ArrayList<ReviewDTO>();
		String sql = "select * from review r "
				+ " join customer c "
				+ " on c.cus_seq = r.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where depth = 1 "
				+ " order by r.regDate desc "
				+ " limit ? offset ? ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(map.get("amount")));
			pstmt.setInt(2, Integer.parseInt(map.get("offset")));
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int bookNum = rs.getInt("r.book_seq");
				int grade = rs.getInt("r.grade");
				int reviewNum = rs.getInt("re_seq");
				String userId = rs.getString("c.cus_id");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("r.content");
				String refYN = rs.getString("ref_YN");
				int ref_seq = rs.getInt("ref_seq");
				
				ReviewDTO dtos = new ReviewDTO(bookNum, reviewNum, grade, userId, reviewDate, content);
				dtos.setRef_YN(refYN); 
				dtos.setRef_seq(ref_seq);
				reviews.add(dtos);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return reviews;
	}

	public ReviewDTO selectReplyView(ReviewDTO myReview) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int re_seq = myReview.getReviewNum();
		
		String sql = "select * from review r "
				+ " join customer c "
				+ " on r.cus_seq = c.cus_seq "
				+ " join books b "
				+ " on r.book_seq = b.book_seq "
				+ " where re_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, re_seq);
			rs = pstmt.executeQuery();
			
			myReview = null;
			
			if(rs.next()) {
				int grade = rs.getInt("r.grade");
				String content = rs.getString("r.content");
				int bookNum = rs.getInt("r.book_seq");
				String userId = rs.getString("c.cus_id");
				int reviewNum = rs.getInt("re_seq");
				int ref_seq = rs.getInt("ref_seq");
				myReview = new ReviewDTO(bookNum, reviewNum, grade, userId, content);
				myReview.setRef_seq(ref_seq);
				
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return myReview;
	}

	public void updateRefYn(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "update review set ref_YN = ? where re_seq = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getRef_YN());
			pstmt.setInt(2, dto.getReviewNum()); 
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		
	}

	public void updateReply(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " update review set content = ? where re_seq = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getReviewNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void deleteReply(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "delete from review where re_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getReviewNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	
	
}
