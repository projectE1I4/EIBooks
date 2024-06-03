package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import eibooks.common.JDBCConnect;
import eibooks.dto.AddressDTO;
import eibooks.dto.BookDTO;
import eibooks.dto.CustomerDTO;
import eibooks.dto.OrderDTO;
import eibooks.dto.cartDTO;

public class OrderDAO {
		
		// order 저장 - insert (효빈) (작동 미확인)
		public void insertOrderList(Map<String, Integer> map){
			Connection conn = null;
			PreparedStatement pstmt = null;
			PreparedStatement purPstmt = null;
			int rs = 0;
			
			int book_seq = map.get("book_seq");
			int cus_seq = map.get("cus_seq");
			int pur_i_count = map.get("cartICount");
			
			String pursql = "insert into purchase(cus_seq) values(?)";
			
			String sql= "insert into purchase_item(book_seq, cus_seq, pur_i_count, pur_seq) "
					+ "values((select book_seq from books where book_seq = ?), ?, ?, (select pur_seq from purchase where cus_seq = ? order by pur_seq desc limit 1))";
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				purPstmt = conn.prepareStatement(pursql);
				purPstmt.setInt(1, cus_seq);
				purPstmt.executeUpdate();

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, book_seq);
				pstmt.setInt(2, cus_seq);
				pstmt.setInt(3, pur_i_count);
				pstmt.setInt(4, cus_seq);
				pstmt.executeUpdate();
				

			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.purClose(purPstmt, pstmt, conn);
			}
		}

		public void updateStock(Map<String, Integer> map) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			int book_seq = map.get("book_seq");
			int pur_i_count = map.get("cartICount");
			
			String sql = "update books set stock = stock - ? where book_seq = ? ";
			
			try {
				//conn
				conn = JDBCConnect.getConnection();
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_i_count);
				pstmt.setInt(2, book_seq);
				pstmt.executeUpdate();
				
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(pstmt, conn);
			}
		}
		
		public void updateStock(cartDTO dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			String sql = "update books set stock = stock - ? where book_seq = ? ";
			
			try {
				//conn
				conn = JDBCConnect.getConnection();
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getCartICount());
				pstmt.setInt(2, dto.getBook_seq());
				pstmt.executeUpdate();
				
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(pstmt, conn);
			}
		}
		
		public void cartList(cartDTO dto){
			Connection conn = null;
			PreparedStatement pstmt = null;
			PreparedStatement purPstmt = null;
			
			int cus_seq = dto.getCusSeq();
			int book_seq = dto.getBook_seq();
			int pur_i_count = dto.getCartICount();
			
			String sql= "insert into purchase_item(book_seq, cus_seq, pur_i_count, pur_seq) "
					+ "values(?, ?, ?, (select pur_seq from purchase where cus_seq = ? order by pur_seq desc limit 1))";
			try {
				//conn
				conn = JDBCConnect.getConnection();
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, book_seq);
				pstmt.setInt(2, cus_seq);
				pstmt.setInt(3, pur_i_count);
				pstmt.setInt(4, cus_seq);
				pstmt.executeUpdate();
				
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.purClose(purPstmt, pstmt, conn);
			}
		}
		public void cartOrderList(cartDTO dto){
			Connection conn = null;
			PreparedStatement pstmt = null;
			PreparedStatement purPstmt = null;
			ResultSet rs = null;
			int pur_seq = 0;
			
			int cus_seq = dto.getCusSeq();
			
			String pursql = "insert into purchase(cus_seq) values(?)";
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				purPstmt = conn.prepareStatement(pursql);
				purPstmt.setInt(1, cus_seq);
				purPstmt.executeUpdate();
				
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.purClose(purPstmt, pstmt, conn);
			}
		}
		
		
		// 전체 회원 주문 내역 조회
		public List<OrderDTO> getOrderList(Map<String, String> map) {
			List<OrderDTO> orderList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			int amount = Integer.parseInt(map.get("amount"));
			int offset = Integer.parseInt(map.get("offset"));
			String orderBy = map.get("orderBy");
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "order by i.pur_seq ";
				
				if(orderBy != null && orderBy.equals("recent")) {
					sql += "desc, i.book_seq asc ";
				}
				
				sql += "limit ? offset ? "; // 2page
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, amount);
				pstmt.setInt(2, offset);

				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					OrderDTO order = new OrderDTO();
					order.setPur_i_seq(rs.getInt("pur_i_seq"));
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setBook_seq(rs.getInt("book_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					order.setPur_i_count(rs.getInt("pur_i_count"));
					order.setOrderDate(rs.getString("orderDate"));
					
					BookDTO book = new BookDTO();
					book.setBook_seq(rs.getInt("book_seq"));
					book.setTitle(rs.getString("title"));
					book.setPrice(rs.getInt("price"));
					
					CustomerDTO customer = new CustomerDTO();
					customer.setCus_seq(rs.getInt("cus_seq"));
					customer.setCus_id(rs.getString("cus_id"));
					customer.setName(rs.getString("name"));
					
					order.setBookInfo(book);
					order.setCustomerInfo(customer);
	                
					// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
					orderList.add(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}
		
		// 주문 내역 별 총 가격
		public int selectTotalPrice(OrderDTO dto) {
			
			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			int pur_seq = dto.getPur_seq();
			List<Integer> total = new ArrayList<Integer>();
			int totalPrice = 0;
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select sum(price * pur_i_count) as totalPrice from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "where i.pur_seq = ? "
						+ "group by i.book_seq ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_seq);

				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					total.add(rs.getInt("totalPrice"));
				}
				
				for (int t : total) {
					totalPrice += t;
				}

			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}
			
			return totalPrice + 3000;
		}

		// 전체 주문 목록 총 개수
		public int selectCount(OrderDTO dto) {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;		

			int cus_seq = 0;
			int totalCount = 0;
			
			String sql = "select count(pur_seq) as cnt from purchase ";
			
			if (dto != null) {
				cus_seq = dto.getCus_seq();
				sql += "where cus_seq = ? ";
			}

			try {
				// 2. connection
				conn = JDBCConnect.getConnection();
				
				// 3. sql창
				pstmt = conn.prepareStatement(sql);
				
				if (dto != null) {
					pstmt.setInt(1, cus_seq);
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
		
		// 외 n권 표시 위한 책 제목 카운팅
		public int selectTitleCount(OrderDTO dto) {
			
			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			int pur_seq = dto.getPur_seq();
			int cnt = 0;
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select count(title) - 1 as cnt from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "where i.pur_seq = ? ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_seq);

				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					cnt = rs.getInt("cnt");
				}

			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}
			
			return cnt;
		}
		
		// 회원별 주문 목록 조회
		public List<OrderDTO> getCustomerOrder(Map<String, String> map) {
			List<OrderDTO> orderList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			// search 여부
			boolean isSearch = false;
			if(map.get("searchWord") != null && map.get("searchWord").length() != 0) {
				isSearch = true;
			}
			
			int cus_seq = Integer.parseInt(map.get("cus_seq"));
			int amount = Integer.parseInt(map.get("amount"));
			int offset = Integer.parseInt(map.get("offset"));
			String orderBy = map.get("orderBy");
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "where i.cus_seq = ? ";
				
				if(isSearch) {
					sql += "and title like ? ";
				}
				
				sql += "order by i.pur_seq desc ";
				
				if(orderBy != null && orderBy.equals("recent")) {
					sql += "desc, i.book_seq asc ";
				}
				
				sql += "limit ? offset ? "; // 2page
				
				pstmt = conn.prepareStatement(sql);
				
				if(isSearch) {
					pstmt.setInt(1, cus_seq);
					pstmt.setString(2, "%" + map.get("searchWord") + "%");
					pstmt.setInt(3, amount);
					pstmt.setInt(4, offset);
				} else {
					pstmt.setInt(1, cus_seq);
					pstmt.setInt(2, amount);
					pstmt.setInt(3, offset);
				}
				
				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					OrderDTO order = new OrderDTO();
					order.setPur_i_seq(rs.getInt("pur_i_seq"));
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setBook_seq(rs.getInt("book_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					order.setPur_i_count(rs.getInt("pur_i_count"));
					order.setOrderDate(rs.getString("orderDate"));
					
					BookDTO book = new BookDTO();
					book.setBook_seq(rs.getInt("book_seq"));
					book.setTitle(rs.getString("title"));
					book.setPrice(rs.getInt("price"));
					
					CustomerDTO customer = new CustomerDTO();
					customer.setCus_seq(rs.getInt("cus_seq"));
					customer.setCus_id(rs.getString("cus_id"));
					customer.setName(rs.getString("name"));
					
					order.setBookInfo(book);
					order.setCustomerInfo(customer);
	                
					// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
					orderList.add(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}
		
		// 회원별 주문 목록 조회(qna)
		public List<OrderDTO> getCustomerOrder(OrderDTO dto) {
			List<OrderDTO> orderList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase p "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "where i.cus_seq = ? ";
				
				sql += "order by i.pur_seq ";
				
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setInt(1, dto.getCus_seq());
			
				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					OrderDTO order = new OrderDTO();
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					
					CustomerDTO customer = new CustomerDTO();
					customer.setCus_seq(rs.getInt("cus_seq"));
					customer.setCus_id(rs.getString("cus_id"));
					customer.setName(rs.getString("name"));
					
					order.setCustomerInfo(customer);
	                
					// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
					orderList.add(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}
		
		// 회원별 주문 목록 조회(qna)
		public List<OrderDTO> getCustomerOrderDetail(OrderDTO dto) {
			List<OrderDTO> orderList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "where i.pur_seq = ? ";
				
				sql += "order by i.pur_seq ";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, dto.getPur_seq());
			
				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					OrderDTO order = new OrderDTO();
					order.setPur_i_seq(rs.getInt("pur_i_seq"));
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setBook_seq(rs.getInt("book_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					order.setPur_i_count(rs.getInt("pur_i_count"));
					order.setOrderDate(rs.getString("orderDate"));
					
					BookDTO book = new BookDTO();
					book.setBook_seq(rs.getInt("book_seq"));
					book.setTitle(rs.getString("title"));
					book.setPrice(rs.getInt("price"));
					
					order.setBookInfo(book);
	                
					// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
					orderList.add(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}

		// 주문 내역의 도서 정보
		public List<OrderDTO> getOrderDetail(OrderDTO dto) {
			List<OrderDTO> orderList = new ArrayList<>();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			int pur_seq = dto.getPur_seq();

			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "join customer_addr a "
						+ "on i.cus_seq = a.cus_seq "
						+ "where i.pur_seq = ? "
						+ "order by pur_i_seq;";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_seq);

				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					OrderDTO order = new OrderDTO();
					order.setPur_i_seq(rs.getInt("pur_i_seq"));
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setBook_seq(rs.getInt("book_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					order.setPur_i_count(rs.getInt("pur_i_count"));
					order.setOrderDate(rs.getString("orderDate"));
					
					BookDTO book = new BookDTO();
					book.setBook_seq(rs.getInt("book_seq"));
					book.setImageFile(rs.getString("imageFile"));
					book.setTitle(rs.getString("title"));
					book.setPublisher(rs.getString("publisher"));
					book.setPubDate(rs.getString("pubDate"));
					book.setIsbn13(rs.getString("isbn13"));
					book.setPrice(rs.getInt("price"));
					
					order.setBookInfo(book);
	                
					// 장바구니에 담긴 각 도서의 정보를 가져와서 추가
					orderList.add(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}
		
		// 주문 내역의 회원 정보
		public OrderDTO getCustomerDetail(OrderDTO dto) {
			OrderDTO order = new OrderDTO();

			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			int pur_seq = dto.getPur_seq();

			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select * from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "join customer c "
						+ "on i.cus_seq = c.cus_seq "
						+ "join customer_addr a "
						+ "on i.cus_seq = a.cus_seq "
						+ "where i.pur_seq = ? "
						+ "order by pur_i_seq;";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_seq);

				rs = pstmt.executeQuery();

				while(rs.next()) {
					
					order.setPur_i_seq(rs.getInt("pur_i_seq"));
					order.setPur_seq(rs.getInt("pur_seq"));
					order.setBook_seq(rs.getInt("book_seq"));
					order.setCus_seq(rs.getInt("cus_seq"));
					order.setPur_i_count(rs.getInt("pur_i_count"));
					order.setOrderDate(rs.getString("orderDate"));

					AddressDTO addr = new AddressDTO();
					addr.setPostalCode(rs.getString("postalCode"));
					addr.setAddr(rs.getString("addr"));
					addr.setAddr_detail(rs.getString("addr_detail"));
					
					CustomerDTO customer = new CustomerDTO();
					customer.setCus_seq(rs.getInt("cus_seq"));
					customer.setCus_id(rs.getString("cus_id"));
					customer.setName(rs.getString("name"));
					customer.setTel(rs.getString("tel"));
					customer.setEmail(rs.getString("email"));
					customer.setAddrInfo(addr);
					
					order.setCustomerInfo(customer);
				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return order;
		}
		
		public int getPurchaseCount() {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        int purCnt = 0;

	        try {
	            // 2. connection
	            conn = JDBCConnect.getConnection();

	            String sql = "select distinct count(pur_seq) as cnt from purchase";
	            // 3. sql창
	            pstmt = conn.prepareStatement(sql);

	            // 4. execute
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	            	purCnt = rs.getInt("cnt");
	            }

	        } catch (Exception e) {
	            e.printStackTrace();

	        } finally {
	            JDBCConnect.close(rs, pstmt, conn);

	        }
	        return purCnt;
	    }
		
}
