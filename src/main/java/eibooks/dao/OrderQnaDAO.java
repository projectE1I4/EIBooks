package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import eibooks.common.JDBCConnect;
import eibooks.dto.BookDTO;
import eibooks.dto.CustomerDTO;
import eibooks.dto.OrderDTO;
import eibooks.dto.OrderQnaDTO;
import eibooks.dto.QnaDTO;

public class OrderQnaDAO {

	// 회원별 상품 문의 내역 리스트
	public List<OrderQnaDTO> getQnaList(Map<String, String> map) {
		List<OrderQnaDTO> qnaList = new ArrayList<>();

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
			String sql= "select * from order_qna q "
					+ "join books b "
					+ "on q.book_seq = b.book_seq "
					+ "join customer c "
					+ "on q.cus_seq = c.cus_seq "
					+ "join purchase_item i "
					+ "on q.pur_i_seq = i.pur_i_seq "
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
				
				OrderQnaDTO qna = new OrderQnaDTO();
				qna.setPur_q_seq(rs.getInt("pur_q_seq"));
				qna.setBook_seq(rs.getInt("book_seq"));
				qna.setPur_seq(rs.getInt("pur_seq"));
				qna.setType(rs.getString("q.type"));
				qna.setTitle(rs.getString("q.title"));
				qna.setContent(rs.getString("q.content"));
				qna.setImageFile(rs.getString("q.imageFile"));
				qna.setRegDate(rs.getString("q.regDate"));
				qna.setState(rs.getString("state"));
				qna.setDepth(rs.getInt("depth"));
				qna.setRef_seq(rs.getInt("ref_seq"));
				
				OrderDTO order = new OrderDTO();
				order.setPur_seq(rs.getInt("pur_seq"));
				order.setPur_i_seq(rs.getInt("pur_i_seq"));
				order.setBook_seq(rs.getInt("book_seq"));
				
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
				
				qna.setOrderInfo(order);
				qna.setBookInfo(book);
				qna.setCusInfo(customer);
                
				// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
				qnaList.add(qna);

			}
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return qnaList;
	}

	public int selectCount(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int cus_seq = 0;
		int totalCount = 0;
		
		String sql = "select count(pur_q_seq) as cnt from order_qna ";
		
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
	

	public int selectAllCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int totalCount = 0;
		
		String sql = "select count(pur_q_seq) as cnt from order_qna ";

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
	
	public OrderQnaDTO selectReply(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		
		OrderQnaDTO reply = new OrderQnaDTO();
		
		String sql = " select * from order_qna "
				   + " where ref_seq = ? ";
		
		conn = JDBCConnect.getConnection();
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPur_q_seq());
			rs = pstmt.executeQuery();
			
			dto = null;
			
			if(rs.next()) {
				int pur_q_seq = rs.getInt("pur_q_seq");
				String content = rs.getString("content");
				int ref_seq = rs.getInt("ref_seq");
				String regDate = rs.getString("regDate");
				reply.setPur_q_seq(pur_q_seq);
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
	
	// 회원의 주문번호 리스트 가져오기
	public List<OrderDTO> getOrderList(OrderDTO dto) {
		List<OrderDTO> orderList = new ArrayList<>();

		//DB연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int cus_seq = dto.getCus_seq();
		
		
		try {
			//conn
			conn = JDBCConnect.getConnection();

			//sql + 쿼리창
			String sql= "select DATE_FORMAT(orderDate, '%Y-%m-%d') as orderDate_i, i.*, b.* from purchase_item i "
					+ "join books b "
					+ "on i.book_seq = b.book_seq "
					+ "join purchase p "
					+ "on i.pur_seq = p.pur_seq "
					+ "where i.cus_seq = ? and orderDate >= date_sub(now(), interval 3 month) ";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cus_seq);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				
				OrderDTO order = new OrderDTO();
				order.setBook_seq(rs.getInt("book_seq"));
				order.setPur_seq(rs.getInt("pur_seq"));
				order.setPur_i_seq(rs.getInt("pur_i_seq"));
				order.setOrderDate(rs.getString("orderDate_i"));
				
				BookDTO book = new BookDTO();
				book.setImageFile(rs.getString("imageFile"));
				book.setTitle(rs.getString("b.title"));
				book.setAuthor(rs.getString("author"));
				book.setPublisher(rs.getString("publisher"));
				book.setPubDate(rs.getString("pubDate"));
				book.setIsbn13(rs.getString("isbn13"));
				book.setPrice(rs.getInt("price"));
				
				order.setBookInfo(book);
				
				orderList.add(order);

			}
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return orderList;
	}
	
	public void insertOrderQna(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int cus_seq = dto.getCus_seq();
		int book_seq = dto.getBook_seq();
		int pur_seq = dto.getPur_seq();
		int pur_i_seq = dto.getPur_i_seq();
		String type = dto.getType();
		String title = dto.getTitle();
		String content = dto.getContent();
		String imageFile = dto.getImageFile(); 
		
		String sql= " insert into order_qna(cus_seq, book_seq, pur_seq, pur_i_seq, type, title, content, state, imageFile) "
				+ " values(?, ?, ?, ?, ?, ?, ?, '답변대기', ?) ";
		try {
			//conn
			conn = JDBCConnect.getConnection();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cus_seq);
			pstmt.setInt(2, book_seq);
			pstmt.setInt(3, pur_seq);
			pstmt.setInt(4, pur_i_seq);
			pstmt.setString(5, type);
			pstmt.setString(6, title);
			pstmt.setString(7, content);
			pstmt.setString(8, imageFile);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void deleteWrite(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "delete from order_qna "
					+ " where pur_q_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getPur_q_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public List<OrderQnaDTO> getQnaAllList(Map<String, String> map) {
		List<OrderQnaDTO> qnaList = new ArrayList<>();

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
			String sql= "select * from order_qna q "
					+ "join books b "
					+ "on q.book_seq = b.book_seq "
					+ "join customer c "
					+ "on q.cus_seq = c.cus_seq "
					+ "join purchase_item i "
					+ "on q.pur_i_seq = i.pur_i_seq ";
			
			if (state != null) {
				sql += "where state = ? ";
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
				
				OrderQnaDTO qna = new OrderQnaDTO();
				qna.setPur_q_seq(rs.getInt("pur_q_seq"));
				qna.setBook_seq(rs.getInt("book_seq"));
				qna.setPur_seq(rs.getInt("pur_seq"));
				qna.setType(rs.getString("q.type"));
				qna.setTitle(rs.getString("q.title"));
				qna.setContent(rs.getString("q.content"));
				qna.setImageFile(rs.getString("q.imageFile"));
				qna.setRegDate(rs.getString("q.regDate"));
				qna.setState(rs.getString("state"));
				qna.setDepth(rs.getInt("depth"));
				qna.setRef_seq(rs.getInt("ref_seq"));
				
				OrderDTO order = new OrderDTO();
				order.setPur_seq(rs.getInt("pur_seq"));
				order.setPur_i_seq(rs.getInt("pur_i_seq"));
				order.setBook_seq(rs.getInt("book_seq"));
				
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
				
				qna.setOrderInfo(order);
				qna.setBookInfo(book);
				qna.setCusInfo(customer);
                
				// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
				qnaList.add(qna);

			}
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return qnaList;
	}

	public void insertReply(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " insert into order_qna (cus_seq, content, depth, ref_seq) VALUES (?, ?, 2, ?) ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, dto.getCus_seq());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getRef_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void updateState(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "update order_qna set state = ? where pur_q_seq = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getState());
			pstmt.setInt(2, dto.getPur_q_seq()); 
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

	public void updateReply(OrderQnaDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = " update order_qna set content = ? where pur_q_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getPur_q_seq());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
	}

}
