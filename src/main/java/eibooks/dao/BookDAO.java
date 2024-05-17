package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import eibooks.common.JDBCConnect;
import eibooks.dto.BookDTO;

public class BookDAO {

	// 책 페이지 리스트 
	public List<BookDTO> selectPageList(Map<String, String> map) {
		
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}	
		
		// bookList List 형태로 만들기
		List<BookDTO> bookList = new ArrayList<>();

		// 모든 책을 불러오는 sql문
		String sql = "select * from books ";
		
		// search 여부가 true일 때
		if(isSearch) {
			// sql 문에다가 where 절 추가
			sql += "where " + map.get("searchField") + " like ? ";
		}
		// 페이지 당 얼마나 보여줄 것인지, 정렬 방법에 대해서
		sql += "order by book_seq desc ";
		sql += "limit ? offset ? "; // 2page
		
		try {
			
			// JDBCConnect에서 Connection 연결
			conn = JDBCConnect.getConnection();
			// sql문 할당
			pstmt = conn.prepareStatement(sql);
			
			// search가 true일 경우 아래와 같이 설정
			if(isSearch) {
				// 서치 키워드에서만 만들기 위해서 다음과 같아짐
				pstmt.setString(1, "%" + map.get("searchWord") + "%"); // searchWord 설정
				pstmt.setInt(2, Integer.parseInt(map.get("amount"))); // amount 설정
				pstmt.setInt(3, Integer.parseInt(map.get("offset"))); // offset 설정
			} else {
				// false일 경우 아래와 같아짐
				pstmt.setInt(1, Integer.parseInt(map.get("amount"))); // amount 설정
				pstmt.setInt(2, Integer.parseInt(map.get("offset"))); // offset 설정
			}
			System.out.println("searchWord: "+ pstmt);
			
			// 쿼리의 결과 등록
			rs = pstmt.executeQuery();
			
			// 결과의 값이 있으면 아래의 반복문 진행
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
				
				// bookdto에다가 해당 내용들을 집어넣음
				BookDTO dto = new BookDTO(book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate);
				// 그에 대한 결과를 bookList에 집어넣음
				bookList.add(dto);
			}
			
		} catch(Exception e) {
			// 오류 구문 출력
			e.printStackTrace();
			
		} finally {
			// JDBCConnect에서 rs, pstmt, conn을 닫아줌
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		//bookList 반환
		return bookList;
	}
	
// 효빈 작업 AJAX	
public List<BookDTO> userPageList(Map<String, String> map) {
		
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		
		
		// bookList List 형태로 만들기
		List<BookDTO> bookList = new ArrayList<>();	
		
		try {	
			// 모든 책을 불러오는 sql문
			System.out.println("옾셋>>>>>>>>"+map.get("offset"));
			String sql = "select * from books ";
			sql += "order by book_seq desc ";
			sql += "limit ? offset ? "; // 2page
			
			// JDBCConnect에서 Connection 연결
			conn = JDBCConnect.getConnection();
			// sql문 할당
			pstmt = conn.prepareStatement(sql);
			
			int num = 1;
				pstmt.setInt(num, Integer.parseInt(map.get("amount"))); // amount 설정
				num += 1;
				pstmt.setInt(num, Integer.parseInt(map.get("offset"))); // offset 설정
				num = 0;
			num = 0;
			System.out.println("pstmt: "+ pstmt);
			
			// 쿼리의 결과 등록
			rs = pstmt.executeQuery();
			
			// 결과의 값이 있으면 아래의 반복문 진행
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
				
				// bookdto에다가 해당 내용들을 집어넣음
				BookDTO dto = new BookDTO(book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate);
				// 그에 대한 결과를 bookList에 집어넣음
				bookList.add(dto);
			}
			
		} catch(Exception e) {
			// 오류 구문 출력
			e.printStackTrace();
			
		} finally {
			// JDBCConnect에서 rs, pstmt, conn을 닫아줌
			JDBCConnect.close(rs, pstmt, conn);
		}
		//bookList 반환
		return bookList;
	}
	
	// 효빈 작업: 서치
	public List<BookDTO> userSelectPageList(Map<String, String> map) {
		
		
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		
		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}	
		
		// bookList List 형태로 만들기
		List<BookDTO> bookList = new ArrayList<>();
		
		// 모든 책을 불러오는 sql문
		String sql = "select * from books ";
		
		// search 여부가 true일 때
		if(isSearch) {
			// sql 문에다가 where 절 추가
			
			sql += " where title like ? ";
			sql += "or author like ? ";
			sql += "or publisher like ? ";
		}
		// 페이지 당 얼마나 보여줄 것인지, 정렬 방법에 대해서
		sql += "order by book_seq desc ";
		sql += "limit ? offset ? "; // 2page
		
		
		try {
			
			// JDBCConnect에서 Connection 연결
			conn = JDBCConnect.getConnection();
			// sql문 할당
			pstmt = conn.prepareStatement(sql);
			
			int num = 1;
			// search가 true일 경우 아래와 같이 설정
			if(isSearch) {
				// 서치 키워드에서만 만들기 위해서 다음과 같아짐
				pstmt.setString(num, "%" + map.get("searchWord") + "%"); // searchWord 설정
				num += 1;
				pstmt.setString(num, "%" + map.get("searchWord") + "%"); // searchWord 설정
				num += 1;
				pstmt.setString(num, "%" + map.get("searchWord") + "%"); // searchWord 설정
				num += 1;
				pstmt.setInt(num, Integer.parseInt(map.get("amount"))); // amount 설정
				num += 1;
				pstmt.setInt(num, Integer.parseInt(map.get("offset"))); // offset 설정
				System.out.println("searchWord: "+ sql);
				num = 0;
			} else {
				// false일 경우 아래와 같아짐
				// amount 설정
				pstmt.setInt(num, Integer.parseInt(map.get("amount"))); // amount 설정
				num = 2;
				pstmt.setInt(num, Integer.parseInt(map.get("offset"))); // offset 설정
				num = 0;
			}
			num = 0;
			System.out.println("1pstmt: "+ pstmt);
			
			// 쿼리의 결과 등록
			rs = pstmt.executeQuery();
			
			// 결과의 값이 있으면 아래의 반복문 진행
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
				
				// bookdto에다가 해당 내용들을 집어넣음
				BookDTO dto = new BookDTO(book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate);
				// 그에 대한 결과를 bookList에 집어넣음
				bookList.add(dto);
			}
			
		} catch(Exception e) {
			// 오류 구문 출력
			e.printStackTrace();
			
		} finally {
			// JDBCConnect에서 rs, pstmt, conn을 닫아줌
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		//bookList 반환
		return bookList;
	}
	
	//정렬기능	
	// selectCount 기능 (총계)
	public int selectCount(Map<String, String> map) {
		
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		// totalCount 선언
		int totalCount = 0;
		// bookList ArrayList로 만들기
		List<BookDTO> bookList = new ArrayList<>();
		
		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}
		
		// 기본 sql문 
		String sql = "select count(book_seq) as cnt from books";
		if(isSearch) {
			//search 시에 들어갈 내용
			sql += " where " + map.get("searchField") + " like ? ";
		}

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql창
			pstmt = conn.prepareStatement(sql);
			if(isSearch) {
				//pstmt.setString(1, map.get("searchWord"));
				// search 내용 합치기 위한 부분
				pstmt.setString(1, "%" + map.get("searchWord") + "%");
			}
			
			// 4. execute
			// 결과 내용 내보냄
			rs = pstmt.executeQuery();
			
			// rs의 값이 있을 경우에 totalCount에 적재
			if(rs.next()) {
				totalCount = rs.getInt("cnt");
			}
			
			// 에러 메시지 보여줌
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			// 연결 닫기
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		
		// totalCount 리턴
		return totalCount;
	}
	
public int userSelectCount(Map<String, String> map) {
		
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		// totalCount 선언
		int totalCount = 0;
		// bookList ArrayList로 만들기
		List<BookDTO> bookList = new ArrayList<>();
		
		// search 여부
		boolean isSearch = false;
		if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
			isSearch = true;
		}
		
		// 기본 sql문 
		String sql = "select count(book_seq) as cnt from books ";
		if(isSearch) {
			//sql += " and " + map.get("searchField") + " like concat('%',?,'%')";
			
			//search 시에 들어갈 내용
			sql += "where title like ? ";
			sql += "or author like ? ";
			sql += "or publisher like ? ";
		}

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql창
			pstmt = conn.prepareStatement(sql);
			if(isSearch) {
				//pstmt.setString(1, map.get("searchWord"));
				// search 내용 합치기 위한 부분
				pstmt.setString(1, "%" + map.get("searchWord") + "%");
				pstmt.setString(2, "%" + map.get("searchWord") + "%");
				pstmt.setString(3, "%" + map.get("searchWord") + "%");
			}
			
			// 4. execute
			// 결과 내용 내보냄
			rs = pstmt.executeQuery();
			
			// rs의 값이 있을 경우에 totalCount에 적재
			if(rs.next()) {
				totalCount = rs.getInt("cnt");
			}
			
			// 에러 메시지 보여줌
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			// 연결 닫기
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		
		// totalCount 리턴
		return totalCount;
	}


	
	// books(전체 책)를 가져오는 내용
	public List<BookDTO> getBooks(int listNum, int offset) {
		// DB 연결
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		// List로 bookList 선언
		List<BookDTO> bookList = new ArrayList<>();

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();			
			
			// 3. sql창
			String sql = "select book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate from books ";
			sql += " limit ? offset ?"; // 2page
			pstmt = conn.prepareStatement(sql);
			// 리스트 번호
			pstmt.setInt(1, listNum);
			// offset
			pstmt.setInt(2, offset);
			
			// 4. execute
			rs = pstmt.executeQuery();
			
			// 5. rs처리 : id값만 list에 저장
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
	
	
	// book 하나만 가져오기
	public BookDTO getBook(BookDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null; // select , 회원가입은 insert할 것이므로 주석 !

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql 창
			String sql = "select book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate from books where book_seq = ? ";
			pstmt = conn.prepareStatement(sql);
			// 문자니까 setString, 날짜면 setDate 등등 ...
			pstmt.setInt(1, dto.getBook_seq());
			
			// 4. execute
			rs = pstmt.executeQuery(); // select

			// 있는지 판단
			dto = null;
			if (rs.next()) { // id 존재
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
				
				dto = new BookDTO(book_seq, title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate);
			} 

		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		return dto;
	}
	
	// 책 등록
	public void insertBook(BookDTO dto){
		Connection conn = null;
	    PreparedStatement pstmt = null;  
	    
	    try {
	       // 2. conn
	       conn = JDBCConnect.getConnection();
	       
	       // 3. sql + 쿼리창
	       String sql = "insert into books(title, author, publisher, category, imageFile, description, price, stock, isbn10, isbn13, pubDate) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
	       pstmt.executeUpdate();
	       
	    } catch (Exception e) {
	       e.printStackTrace();
	       
	    } finally {
	       JDBCConnect.close(pstmt, conn);
	    }
	    
	}
	
	
	// 책 업데이트 
	public int update(BookDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0; 

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql 창
			String sql = "update books set title = ?, author = ?, publisher = ?, category = ?, imageFile = ?, description = ?, price = ?, stock = ?, isbn10 = ?, isbn13 = ?, pubDate = ? where book_seq =? ";
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

	
	// 책 삭제
	public int delete(BookDTO dto) {
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
	
	// 조회수
	public int viewCount(BookDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int rs = 0; 

		try {
			// 2. connection
			conn = JDBCConnect.getConnection();
			
			// 3. sql 창
			String sql = "update books set viewCount = ? where book_seq =? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,dto.getViewCount());
			pstmt.setInt(2,dto.getBook_seq());
	

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
