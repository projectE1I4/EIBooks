package eibooks.dao;
import eibooks.common.JDBCConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import eibooks.dto.CustomerDTO;
import eibooks.dto.ReviewDTO;

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
				+ " join purchase_item i "
				+ " on r.pur_i_seq = i.pur_i_seq "
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
				int pur_seq = rs.getInt("r.pur_seq");
				int pur_i_seq = rs.getInt("r.pur_i_seq");
				int grade = rs.getInt("r.grade");
				int reviewNum = rs.getInt("re_seq");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("r.content");
				String ref_YN = rs.getString("ref_YN");
				
				String cus_id = rs.getString("c.cus_id");
				CustomerDTO cDto = new CustomerDTO();
				cDto.setCus_id(cus_id);
				
				ReviewDTO dtos = new ReviewDTO(bookNum, userNum, pur_seq, pur_i_seq, reviewNum, grade, content, reviewDate);
				dtos.setCusInfo(cDto);
				dtos.setRef_YN(ref_YN);
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
				int pur_i_seq = rs.getInt("pur_i_seq");
				String reviewDate = rs.getString("r.regDate");
				// 재밌어서 넣었어요
				System.out.println("소름 돋아요..." + reviewDate);
				String content = rs.getString("content");
				int reviewNum = rs.getInt("re_seq");
				int refSeq = rs.getInt("ref_seq");
				
				review.setBookNum(bookNum);
				review.setUserNum(userNum);
				review.setPur_i_seq(pur_i_seq);
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
			
			String sql = "INSERT INTO review (cus_seq, book_seq, pur_seq, pur_i_seq, content, grade) VALUES (?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getUserNum());
			pstmt.setInt(2, dto.getBookNum());
			pstmt.setInt(3, dto.getPur_seq());
			pstmt.setInt(4, dto.getPur_i_seq());
			pstmt.setString(5, dto.getContent());
			pstmt.setInt(6, dto.getGrade());
			
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
		
		String sql = "select count(re_seq) as reviewCnt from review "
				+ " where pur_i_seq = ? and depth = 1 ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPur_i_seq());
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
		
		String sql = "select * from review r "
				+ " join customer c "
				+ " on r.cus_seq = c.cus_seq "
				+ " join purchase_item i "
				+ " on r.pur_i_seq = i.pur_i_seq "
				+ " where r.pur_i_seq = ? and depth = 1 ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPur_i_seq());
			rs = pstmt.executeQuery();
			
			dto = null;
			
			if(rs.next()) {
				int grade = rs.getInt("r.grade");
				String content = rs.getString("r.content");
				int bookNum = rs.getInt("r.book_seq");
				int reviewNum = rs.getInt("re_seq");
				int pur_i_seq = rs.getInt("pur_i_seq");
				
				String cus_id = rs.getString("cus_id");
				CustomerDTO cDto = new CustomerDTO();
				cDto.setCus_id(cus_id);
				
				dto = new ReviewDTO(bookNum, pur_i_seq, reviewNum, grade, content);
				dto.setCusInfo(cDto);
			}
			System.out.println("pstmt" + pstmt);
			
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
			
			String sql = "update review "
					+ " set grade = ?, content = ?"
					+ " where re_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getGrade());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getReviewNum());
			
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
			
			String sql = "delete from review "
					+ " where re_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getReviewNum());
			
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
				+ " join purchase_item i "
				+ " on r.pur_i_seq = i.pur_i_seq "
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
				int reviewNum = rs.getInt("re_seq");
				int bookNum = rs.getInt("book_seq");
				int userNum = rs.getInt("cus_seq");
				int pur_seq = rs.getInt("pur_seq");
				int pur_i_seq = rs.getInt("pur_i_seq");
				
				int grade = rs.getInt("grade");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("content");
				String refYN = rs.getString("ref_YN");
				int ref_seq = rs.getInt("ref_seq");

				String cus_id = rs.getString("c.cus_id");
				CustomerDTO cDto = new CustomerDTO();
				cDto.setCus_id(cus_id);
				
				ReviewDTO dtos = new ReviewDTO(bookNum, userNum, pur_seq, pur_i_seq, reviewNum, grade, content, reviewDate);
				dtos.setRef_YN(refYN); 
				dtos.setRef_seq(ref_seq);
				dtos.setCusInfo(cDto);
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
				+ " join purchase_item i "
				+ " on r.pur_i_seq = i.pur_i_seq "
				+ " where re_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, re_seq);
			rs = pstmt.executeQuery();
			
			myReview = null;
			
			if(rs.next()) {
				int reviewNum = rs.getInt("re_seq");
				int bookNum = rs.getInt("book_seq");
				int userNum = rs.getInt("cus_seq");
				int pur_seq = rs.getInt("pur_seq");
				int pur_i_seq = rs.getInt("pur_i_seq");
				int grade = rs.getInt("grade");
				String content = rs.getString("content");
				String reviewDate = rs.getString("r.regDate");
				int ref_seq = rs.getInt("ref_seq");

				
				String cus_id = rs.getString("cus_id");
				CustomerDTO cDto = new CustomerDTO();
				cDto.setCus_id(cus_id);
				
				myReview = new ReviewDTO(bookNum, userNum, pur_seq, pur_i_seq, reviewNum, grade, content, reviewDate);
				myReview.setRef_seq(ref_seq);
				myReview.setCusInfo(cDto);
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
			
			String sql = "delete from review where ref_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getReviewNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public double reviewAvg(ReviewDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		double gradeAvg = 0.0;
		
		String sql = "SELECT AVG(grade) AS avg_grade "
				+ " FROM review r "
				+ " JOIN books b ON r.book_seq = b.book_seq "
				+ " WHERE b.book_seq = ? ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBookNum());
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				gradeAvg = rs.getDouble("avg_grade");
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return gradeAvg;
	}

	public List<ReviewDTO> selectTopList(ReviewDTO dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		List<ReviewDTO> topReviews = new ArrayList<ReviewDTO>();
		
		String sql = "select * from review r "
				+ " join customer c "
				+ " on c.cus_seq = r.cus_seq "
				+ " join purchase_item i "
				+ " on r.pur_i_seq = i.pur_i_seq "
				+ " where r.book_seq = ? and depth = 1 "
				+ " order by r.grade desc, r.regDate asc "
				+ " limit 4 ";
		
		System.out.println(sql);
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBookNum());
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int grade = rs.getInt("r.grade");
				String reviewDate = rs.getString("r.regDate");
				String content = rs.getString("content");
				
				String cus_id = rs.getString("c.cus_id");
				CustomerDTO cDto = new CustomerDTO();
				cDto.setCus_id(cus_id);
				
				ReviewDTO dtos = new ReviewDTO();
				dtos.setGrade(grade);
				dtos.setReviewDate(reviewDate);
				dtos.setContent(content);
				dtos.setCusInfo(cDto);
				topReviews.add(dtos);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return topReviews;
	}
	
}
