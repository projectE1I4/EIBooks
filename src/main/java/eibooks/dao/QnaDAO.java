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
					+ "where q.cus_seq = ? and depth = 1 ";
			
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
				qna.setBook_seq(rs.getInt("book_seq"));
				qna.setType(rs.getString("type"));
				qna.setTitle(rs.getString("q.title"));
				qna.setContent(rs.getString("content"));
				qna.setProtect_YN(rs.getString("protect_YN"));
				qna.setRegDate(rs.getString("q.regDate"));
				qna.setState(rs.getString("state"));
				qna.setDepth(rs.getInt("depth"));
				qna.setRef_seq(rs.getInt("ref_seq"));
				
				BookDTO book = new BookDTO();
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
				int qna_seq = rs.getInt("qna_seq");
				String content = rs.getString("content");
				ref_seq = rs.getInt("ref_seq");
				String regDate = rs.getString("q.regDate");
				reply.setQna_seq(qna_seq);
				reply.setContent(content);
				reply.setRef_seq(ref_seq);
				reply.setRegDate(regDate);
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

	// 회원별 상품 문의 내역 리스트
	public List<QnaDTO> getQnaAllList(Map<String, String> map) {
		List<QnaDTO> qnaList = new ArrayList<>();

		//DB연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

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
					+ "where depth = 1 ";
			
			if (state != null) {
				sql += "and state = ? ";
			}
			
			sql += "limit ? offset ? "; // 2page
			
			pstmt = conn.prepareStatement(sql);
			
			if (state != null) {
				pstmt.setString(1, state);
				pstmt.setInt(2, amount);
				pstmt.setInt(3, offset);
			} else {
				pstmt.setInt(1, amount);
				pstmt.setInt(2, offset);
			}

			rs = pstmt.executeQuery();

			while(rs.next()) {
				
				QnaDTO qna = new QnaDTO();
				qna.setQna_seq(rs.getInt("qna_seq"));
				qna.setBook_seq(rs.getInt("book_seq"));
				qna.setType(rs.getString("type"));
				qna.setTitle(rs.getString("q.title"));
				qna.setContent(rs.getString("content"));
				qna.setProtect_YN(rs.getString("protect_YN"));
				qna.setRegDate(rs.getString("q.regDate"));
				qna.setState(rs.getString("state"));
				qna.setDepth(rs.getInt("depth"));
				qna.setRef_seq(rs.getInt("ref_seq"));
				
				BookDTO book = new BookDTO();
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
	
	public int selectAllCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int cus_seq = 0;
		int totalCount = 0;
		
		String sql = "select count(qna_seq) as cnt from qna where depth = 1 ";

		try {
			conn = JDBCConnect.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			
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

	public void insertReply(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " INSERT INTO qna (book_seq, cus_seq, content, depth, ref_seq) VALUES (?, ?, ?, 2, ?);";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getBook_seq());
			pstmt.setInt(2, dto.getCus_seq());
			pstmt.setString(3, dto.getContent());
			pstmt.setInt(4, dto.getRef_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void updateState(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "update qna set state = ? where qna_seq = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getState());
			pstmt.setInt(2, dto.getQna_seq()); 
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void updateReply(QnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " update qna set content = ? where qna_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getQna_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}
	
	// 회원별 상품 문의 내역 리스트
		public List<QnaDTO> getQnaAllListNew(Map<String, String> map) {
			List<QnaDTO> qnaList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			int amount = Integer.parseInt(map.get("amount"));
			int offset = Integer.parseInt(map.get("offset"));
			int book_seq = Integer.parseInt(map.get("book_seq"));
			String protect_YN = map.get("protect_YN");
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select RPAD(substr(cus_id, 1, 3), 6, '*') as cus_id_q, "
						+ "DATE_FORMAT(q.regDate, '%Y-%m-%d') as regDate_q, q.*, b.*, c.* "
						+ "from qna q "
						+ "join books b "
						+ "on q.book_seq = b.book_seq "
						+ "join customer c "
						+ "on q.cus_seq = c.cus_seq "
						+ "where q.book_seq = ? and depth = 1 ";

				if(protect_YN != null) {
					sql += "and protect_YN = ? ";
				}
				
				sql += "order by qna_seq desc ";
				sql += "limit ? offset ? "; // 2page
				
				pstmt = conn.prepareStatement(sql);
				
				if(protect_YN != null) {
					pstmt.setInt(1, book_seq);
					pstmt.setString(2, protect_YN);
					pstmt.setInt(3, amount);
					pstmt.setInt(4, offset);
				} else {
					pstmt.setInt(1, book_seq);
					pstmt.setInt(2, amount);
					pstmt.setInt(3, offset);
				}

				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					QnaDTO qna = new QnaDTO();
					qna.setQna_seq(rs.getInt("qna_seq"));
					qna.setCus_seq(rs.getInt("cus_seq"));
					qna.setBook_seq(rs.getInt("book_seq"));
					qna.setType(rs.getString("type"));
					qna.setTitle(rs.getString("q.title"));
					qna.setContent(rs.getString("content"));
					qna.setProtect_YN(rs.getString("protect_YN"));
					qna.setRegDate(rs.getString("regDate_q"));
					qna.setState(rs.getString("state"));
					qna.setDepth(rs.getInt("depth"));
					qna.setRef_seq(rs.getInt("ref_seq"));
					
					BookDTO book = new BookDTO();
					book.setTitle(rs.getString("b.title"));
					book.setAuthor(rs.getString("author"));
					book.setPublisher(rs.getString("publisher"));
					book.setImageFile(rs.getString("imageFile"));
					book.setPrice(rs.getInt("price"));
					
					CustomerDTO customer = new CustomerDTO();
					customer.setCus_id(rs.getString("cus_id_q"));
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

		public void insertQna(QnaDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			try {
				conn = JDBCConnect.getConnection();
				
				String sql = " insert into qna (book_seq, cus_seq, type, title, content, protect_YN, state) values (?, ?, ?, ?, ?, ?, '답변대기') ";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, dto.getBook_seq());
				pstmt.setInt(2, dto.getCus_seq());
				pstmt.setString(3, dto.getType());
				pstmt.setString(4, dto.getTitle());
				pstmt.setString(5, dto.getContent());
				pstmt.setString(6, dto.getProtect_YN());
				
				pstmt.executeUpdate();
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				JDBCConnect.close(pstmt, conn);
			}
		}

		public int selectBookCount(QnaDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;		

			int book_seq = 0;
			int totalCount = 0;
			
			String sql = "select count(qna_seq) as cnt from qna ";
			
			if (dto != null) {
				book_seq = dto.getBook_seq();
				sql += "where book_seq = ? ";
			}

			try {
				conn = JDBCConnect.getConnection();
				
				pstmt = conn.prepareStatement(sql);
				
				if (dto != null) {
					pstmt.setInt(1, book_seq);
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
		
}
