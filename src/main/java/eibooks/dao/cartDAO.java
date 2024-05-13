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
			String sql= "select * from cart_item where cus_seq = ?";
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, cusSeq);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				cartDTO cartItem = new cartDTO();
				cartItem.setCartISeq(rs.getInt("cart_i_seq"));
				cartItem.setCartSeq(rs.getInt("cart_seq"));
				cartItem.setCusSeq(rs.getInt("cus_seq"));
				cartItem.setBookSeq(rs.getInt("book_seq"));
				cartItem.setCartICount(rs.getInt("cart_i_count"));

				// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
				BookDTO bookInfo = getBookInfo(rs.getInt("book_seq"));
				cartItem.setBookInfo(bookInfo);
				
				cartList.add(cartItem);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}

		return cartList;
	}
	
	// 도서 순차번호로 도서 정보 불러오기
	private BookDTO getBookInfo(int bookSeq) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BookDTO bookInfo = null;
		
		try {
            conn = JDBCConnect.getConnection(); // DB 연결
            
            // 책 정보 조회 쿼리
            String sql = "SELECT imageFile, title, publisher, pubDate, isbn13, price FROM books " +
                         "WHERE book_seq = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, bookSeq);
            rs = pstmt.executeQuery();
            
            // 결과 처리
            if (rs.next()) {
                bookInfo = new BookDTO();
                bookInfo.setTitle(rs.getString("title"));
                bookInfo.setPublisher(rs.getString("publisher"));
                bookInfo.setPubDate(rs.getString("pubDate"));
                bookInfo.setIsbn13(rs.getString("isbn13"));
                bookInfo.setPrice(rs.getInt("price"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }
        
        return bookInfo;

	}
}
