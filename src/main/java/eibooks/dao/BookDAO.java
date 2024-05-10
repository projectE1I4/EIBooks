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

public class BookDAO {

	public List<BookDTO> selectPageList(Map<String, String> map) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}	
		
		List<BookDTO> bookList = new ArrayList<>();

		String sql = "select * from books ";
		
		if(isSearch) {
			sql += "where " + map.get("searchField") + " like ? ";
		}
		sql += "order by book_seq desc ";
		sql += "limit ? offset ? "; // 2page
		
		try {
			conn = JDBCConnect.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			if(isSearch) {
				pstmt.setString(1, "%" + map.get("searchWord") + "%");
				pstmt.setInt(2, Integer.parseInt(map.get("amount")));
				pstmt.setInt(3, Integer.parseInt(map.get("offset")));
			} else {
				pstmt.setInt(1, Integer.parseInt(map.get("amount")));
				pstmt.setInt(2, Integer.parseInt(map.get("offset")));
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				int book_seq = rs.getInt("book_seq");
				String title = rs.getString("title");
				String author = rs.getString("author");
				String publisher = rs.getString("publisher");
				String category = rs.getString("category");
				String imageFile = rs.getString("imageFile");
				String description = rs.getString("description");
				int price = rs.getInt("price");
				int stock = rs.getInt("stock");
				String isbn10 = rs.getString("isbn10");
				String isbn13 = rs.getString("isbn13");
				String pubDate = rs.getString("pubDate");
				
				BookDTO dto = new BookDTO(book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate);
				bookList.add(dto);
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		return bookList;
	}
	
	public int selectCount(Map<String, String> map) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int totalCount = 0;
		List<BookDTO> bookList = new ArrayList<>();
		
		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}
		
		String sql = "select count(book_seq) as cnt from books";
		if(isSearch) {
			//sql += " and " + map.get("searchField") + " like concat('%',?,'%')";
			sql += " where " + map.get("searchField") + " like ? ";
		}

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql창
			pstmt = conn.prepareStatement(sql);
			if(isSearch) {
				//pstmt.setString(1, map.get("searchWord"));
				pstmt.setString(1, "%" + map.get("searchWord") + "%");
			}
			
			// 4. execute
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
	
	public void updateViewCount(BookDTO dto) {
		Connection conn = null;
	    PreparedStatement pstmt = null;  
	    try {
	       // 2. conn
	       conn = JDBCConnect.getConnection();
	       
	       // 3. sql + 쿼리창
	       String sql = "update books set viewCount = viewCount + 1 ";
	       sql += " where book_seq = ?";
	       pstmt = conn.prepareStatement(sql);
	       
	       // 4. ? 세팅
	       pstmt.setInt(1, dto.getBook_seq());
	       
	       // 5. execute 실행
	       pstmt.executeUpdate();
	       
	    } catch (Exception e) {
	       e.printStackTrace();
	    }finally {
	       JDBCConnect.close(pstmt, conn);
	    }
	}

	public BookDTO selectView(BookDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;				

		String sql = "select title, author, imageFile, price, category, publisher, pubDate, isbn10, isbn13, description, stock ";
		sql += " from books " ;
		sql += " where book_seq = ? ";
		conn = JDBCConnect.getConnection();

		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBook_seq());
			rs = pstmt.executeQuery();
			
			dto = null;
			if(rs.next()) {
				String title = rs.getString("title");
				String author = rs.getString("author");
				String imageFile = rs.getString("imageFile");
				int price = rs.getInt("price");
				String category = rs.getString("category");
				String publisher = rs.getString("publisher");
				String pubDate = rs.getString("pubDate");
				String isbn10 = rs.getString("isbn10");
				String isbn13 = rs.getString("isbn13");
				String description = rs.getString("description");
				int stock = rs.getInt("stock");
				dto = new BookDTO(title, author, publisher, category, imageFile,
		                   description, price, stock, isbn10, isbn13, pubDate);	
			}

		} catch (SQLException e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
		}
		
		return dto;
	}

	public int insertProduct(BookDTO dto) {
		Connection conn = null;
	    PreparedStatement pstmt = null;  
	    int rs = 0;
	    try {
	       // 2. conn
	       conn = JDBCConnect.getConnection();
	       
	       // 3. sql + 쿼리창
	       String sql = "insert into books(title, author, publisher, category, imageFile"
	       		+ ", description, price, stock, isbn10, isbn13, pubDate) "
	       		+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	       pstmt = conn.prepareStatement(sql);
	       
	       // 4. ? 세팅
	       pstmt.setString(1, dto.getTitle());
	       pstmt.setString(2, dto.getAuthor());
	       pstmt.setString(3, dto.getPublisher());
	       pstmt.setString(4, dto.getCategory());
	       pstmt.setString(5, dto.getImageFile());
	       pstmt.setString(6, dto.getDescription());
	       pstmt.setInt(7, dto.getPrice());
	       pstmt.setInt(8, dto.getStock());
	       pstmt.setString(9, dto.getIsbn10());
	       pstmt.setString(10, dto.getIsbn13());
	       pstmt.setString(11, dto.getPubDate());
	       
	       // 5. execute 실행
	       rs = pstmt.executeUpdate();
	       
	    } catch (Exception e) {
	       e.printStackTrace();
	    }finally {
	       JDBCConnect.close(pstmt, conn);
	    }
	    return rs;
	}

	public int deleteProduct(BookDTO dto) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; // select

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql 창,  탙퇴 처리
			String	sql = "delete from books where book_seq =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBook_seq());
			// 4. execute
			result = pstmt.executeUpdate(); // insert, update, delete


		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(pstmt, conn);
			
		}
		
		return result;
	}

	public int updateProduct(BookDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0; 

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql 창
			String sql = "update books set title = ?, author = ?, publisher = ?, category = ?, imageFile = ?, "
					+ "description = ?, price = ?, stock = ?, isbn10 = ?, isbn13 = ?, pubDate = ? where book_seq =? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,dto.getTitle());
			pstmt.setString(2,dto.getAuthor());
			pstmt.setString(3,dto.getPublisher());
			pstmt.setString(4,dto.getCategory());
			pstmt.setString(5,dto.getImageFile());
			pstmt.setString(6,dto.getDescription());
			pstmt.setInt(7,dto.getPrice());
			pstmt.setInt(8,dto.getStock());
			pstmt.setString(9,dto.getIsbn10());
			pstmt.setString(10,dto.getIsbn13());
			pstmt.setString(11,dto.getPubDate());
			pstmt.setInt(12,dto.getBook_seq());

			// 4. execute
			rs = pstmt.executeUpdate();	// insert, update, delete
			
		} catch(Exception e){
			e.printStackTrace();
			
		} finally{
			JDBCConnect.close(pstmt, conn);
			
		}
		return rs;
	}
	
}
