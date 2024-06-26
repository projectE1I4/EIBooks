package eibooks.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import eibooks.common.JDBCConnect;
import eibooks.dto.BookDTO;
import eibooks.dto.cartDTO;

public class cartDAO {

	//회원 장바구니 리스트 조회
	public List<cartDTO> getCartList(int cusSeq) {
		List<cartDTO> cartList = new ArrayList<>();

		//DB연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			//conn
			conn = JDBCConnect.getConnection();

			//sql + 쿼리창
			String sql= "select * from cart_item i "
					+ "join books b "
					+ "on i.book_seq = b.book_seq "
					+ "where i.cus_seq = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cusSeq);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				cartDTO cartItem = new cartDTO();
				cartItem.setCartISeq(rs.getInt("cart_i_seq"));
				cartItem.setCusSeq(rs.getInt("cus_seq"));
				cartItem.setBook_seq(rs.getInt("book_seq"));
				cartItem.setCartICount(rs.getInt("cart_i_count"));
				
				
				BookDTO book = new BookDTO();
				book.setBook_seq(rs.getInt("book_seq"));
				book.setImageFile(rs.getString("imageFile"));
				book.setTitle(rs.getString("title"));
				book.setPublisher(rs.getString("publisher"));
				book.setPubDate(rs.getString("pubDate"));
				book.setIsbn13(rs.getString("isbn13"));
				book.setPrice(rs.getInt("price"));
				
                cartItem.setBookInfo(book);
                
				// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
				cartList.add(cartItem);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return cartList;
	}
	
	//회원 장바구니 리스트 조회
		public int getCart(cartDTO dto) {
			int cart_i_seq = 0;

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select cart_i_seq from cart_item "
						+ "where cus_seq = ? and book_seq = ?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getCusSeq());
				pstmt.setInt(2, dto.getBook_seq());

				rs = pstmt.executeQuery();

				if(rs.next()) {
					cart_i_seq = rs.getInt("cart_i_seq");
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return cart_i_seq;
		}			
	
		//장바구니 리스트 수량 수정
		public int insertCart (Map<String, Integer> map) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int rs = 0;
			try {
				//DB 연결
		        conn = JDBCConnect.getConnection();
				String sql = "insert into cart_item(book_seq, cart_i_count, cus_seq) values(?, ?, ?);";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, map.get("book_seq"));
				pstmt.setInt(2, map.get("cart_i_count"));
				pstmt.setInt(3, map.get("cusSeq"));
				
				rs = pstmt.executeUpdate();
				
			} catch(Exception e) {
				e.printStackTrace();
			}finally {
				JDBCConnect.close(pstmt, conn);
			}
			return rs;
		}
	
	//장바구니 리스트 항목 삭제 
	public int deleteCart (int cartISeq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			//DB 연결
			conn = JDBCConnect.getConnection();
			System.out.println("delete conn ok!");
			
			String sql = "delete from cart_item where cart_i_seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cartISeq);
			
			rs = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}
	
	//장바구니 리스트 항목 전체 삭제 
	public int deleteCartAll (int cus_seq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			//DB 연결
			conn = JDBCConnect.getConnection();
			System.out.println("delete conn ok!");
			
			String sql = "delete from cart_item where cus_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cus_seq);
			
			rs = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}
	
	//장바구니 리스트 수량 수정
	public int updateCart (int cartISeq, int cartICount) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			//DB 연결
	        conn = JDBCConnect.getConnection();
			
			String sql = "update cart_item set cart_i_count = ? where cart_i_seq = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, cartICount);
			pstmt.setInt(2, cartISeq);
			
			rs = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCConnect.close(pstmt, conn);
		}
		return rs;
	}
	
	//장바구니 리스트 수량 수정
		public int updateCartNew (int cartISeq, int cart_i_count) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int rs = 0;
			
			try {
				//DB 연결
		        conn = JDBCConnect.getConnection();
				
				String sql = "update cart_item set cart_i_count = cart_i_count + ? where cart_i_seq = ?";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, cart_i_count);
				pstmt.setInt(2, cartISeq);
				
				rs = pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			}finally {
				JDBCConnect.close(pstmt, conn);
			}
			return rs;
		}

	//장바구니 리스트 가격
	public int updatePrice(int cartISeq, int cartICount) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    int priceRs = 0;

	    try {
	        conn = JDBCConnect.getConnection();

	        String sql = "SELECT b.price FROM books b "
	                + "JOIN cart_item i ON b.book_seq = i.book_seq WHERE i.cart_i_seq = ?";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, cartISeq);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	        	priceRs = rs.getInt("price");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        JDBCConnect.close(rs, pstmt, conn);
	    }

	    return priceRs * cartICount;
	}

	//장바구니 목록 총 가격
	public int totalCartPrice(int cusSeq) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    List<Integer> total = new ArrayList<Integer>();
	    int totalPrice = 0;

	    try {
	        conn = JDBCConnect.getConnection();
	        String sql = "select sum(price * cart_i_count) as totalPrice from cart_item i "
	                  + "join books b "
	                  + "on i.book_seq = b.book_seq "
	                  + "where i.cus_seq = ? "
	                  + "group by i.book_seq" ;
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, cusSeq);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	        	total.add(rs.getInt("totalPrice"));
	        }
	        for(int t : total) {
	        	totalPrice += t;
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        JDBCConnect.close(rs, pstmt, conn);
	    }

	    return totalPrice + 3000;
	}
	

}
