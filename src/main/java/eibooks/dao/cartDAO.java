package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
					+ "join cart c "
					+ "on i.cus_seq = c.cus_seq "
					+ "join books b "
					+ "on i.book_seq = b.book_seq "
					+ "where i.cus_seq = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cusSeq);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				cartDTO cartItem = new cartDTO();
				cartItem.setCartISeq(rs.getInt("cart_i_seq"));
				cartItem.setCartSeq(rs.getInt("cart_seq"));
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
	
	//장바구니 리스트 항목 삭제
	public int deleteCart (int cartISeq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0;
		
		try {
			//DB 연결
			conn = JDBCConnect.getConnection();
			System.out.println("delete conn ok!");
			
			String sql = "detele from cart_item where cart_i_seq = ?";
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
	
}
