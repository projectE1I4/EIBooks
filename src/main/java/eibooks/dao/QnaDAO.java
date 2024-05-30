package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import eibooks.common.JDBCConnect;
import eibooks.dto.BookDTO;
import eibooks.dto.CustomerDTO;
import eibooks.dto.QnaDTO;
import eibooks.dto.ReviewDTO;

public class QnaDAO {
	
	// 회원별 상품 문의 내역 리스트
	public List<QnaDTO> getQnaList(Map<String, String> map) {
		List<QnaDTO> qnaList = new ArrayList<>();

		//DB연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int cus_seq = Integer.parseInt(map.get("cus_seq"));
		int amount = Integer.parseInt(map.get("amount"));
		int offset = Integer.parseInt(map.get("offset"));
		String state = map.get("state");
		
		try {
			//conn
			conn = JDBCConnect.getConnection();

			//sql + 쿼리창
			String sql= "select * from qna q "
					+ "join books b "
					+ "on q.book_seq = b.book_seq "
					+ "join customer c "
					+ "on q.cus_seq = c.cus_seq "
					+ "where q.cus_seq = ? ";
			
			if (state != null) {
				sql += "and state = ? ";
			}
			
			sql += "limit ? offset ? "; // 2page
			
			pstmt = conn.prepareStatement(sql);
			
			if (state != null) {
				pstmt.setInt(1, cus_seq);
				pstmt.setString(2, state);
				pstmt.setInt(3, amount);
				pstmt.setInt(4, offset);
			} else {
				pstmt.setInt(1, cus_seq);
				pstmt.setInt(2, amount);
				pstmt.setInt(3, offset);
			}

			rs = pstmt.executeQuery();

			while(rs.next()) {
				
				QnaDTO qna = new QnaDTO();
				qna.setQna_seq(rs.getInt("qna_seq"));
				qna.setType(rs.getString("type"));
				qna.setTitle(rs.getString("q.title"));
				qna.setContent(rs.getString("content"));
				qna.setProtect_YN(rs.getString("protect_YN"));
				qna.setRegDate(rs.getString("q.regDate"));
				qna.setState(rs.getString("state"));
				qna.setDepth(rs.getInt("depth"));
				qna.setRef_seq(rs.getInt("ref_seq"));
				
				BookDTO book = new BookDTO();
				book.setBook_seq(rs.getInt("book_seq"));
				book.setTitle(rs.getString("b.title"));
				book.setAuthor(rs.getString("author"));
				book.setPublisher(rs.getString("publisher"));
				book.setImageFile(rs.getString("imageFile"));
				book.setPrice(rs.getInt("price"));
				
				CustomerDTO customer = new CustomerDTO();
				customer.setCus_seq(rs.getInt("cus_seq"));
				customer.setCus_id(rs.getString("cus_id"));
				customer.setName(rs.getString("name"));
				
				qna.setBookInfo(book);
				qna.setCusInfo(customer);
                
				// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
				qnaList.add(qna);
				System.out.println(qna);

			}
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return qnaList;
	}

	public int selectCount(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int cus_seq = 0;
		int totalCount = 0;
		
		String sql = "select count(qna_seq) as cnt from qna ";
		
		if (dto != null) {
			cus_seq = dto.getCus_seq();
			sql += "where cus_seq = ? ";
		}

		try {
			conn = JDBCConnect.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			
			if (dto != null) {
				pstmt.setInt(1, cus_seq);
			}
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				totalCount = rs.getInt("cnt");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		return totalCount;
	}

	public QnaDTO selectReply(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int book_seq = dto.getBook_seq();
		int ref_seq = dto.getQna_seq();
		
		QnaDTO reply = new QnaDTO();
		
		String sql = " select * from qna q "
				+ " join customer c "
				+ " on q.cus_seq = c.cus_seq "
				+ " join books b "
				+ " on q.book_seq = b.book_seq "
				+ " where q.book_seq = ? "
				+ " and ref_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, book_seq);
			pstmt.setInt(2, ref_seq);
			rs = pstmt.executeQuery();
			
			dto = null;
			
			if(rs.next()) {
				String content = rs.getString("content");
				reply.setContent(content);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return reply;
	}

	public void deleteWrite(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "delete from qna "
					+ " where qna_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getQna_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	
}
