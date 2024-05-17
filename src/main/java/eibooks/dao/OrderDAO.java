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
import eibooks.dto.OrderDTO;

public class OrderDAO {

		//회원 주문 내역 조회
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
						+ "order by orderDate ";
				
				if(orderBy != null && orderBy.equals("recent")) {
					sql += "desc ";
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
					System.out.println(order);

				}
			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}

			return orderList;
		}
		
		public int selectTotalPrice(OrderDTO dto) {
			
			//DB연결
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			int pur_seq = dto.getPur_seq();
			int totalPrice = 0;
			
			try {
				//conn
				conn = JDBCConnect.getConnection();

				//sql + 쿼리창
				String sql= "select sum(price) + 3000 as totalPrice from purchase_item i "
						+ "join purchase p "
						+ "on i.pur_seq = p.pur_seq "
						+ "join books b "
						+ "on i.book_seq = b.book_seq "
						+ "where i.pur_seq = ?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, pur_seq);

				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					totalPrice = rs.getInt("totalPrice");
				}

			} catch (Exception e) {
				e.printStackTrace();
				
			} finally {
				JDBCConnect.close(rs, pstmt, conn);
			}
			
			return totalPrice;
		}

		public int selectCount() {
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;		

			int totalCount = 0;
			
			String sql = "select count(pur_seq) as cnt from purchase";

			try {
				// 2. connection
				conn = JDBCConnect.getConnection();
				
				// 3. sql창
				pstmt = conn.prepareStatement(sql);
				
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
						+ "where i.pur_seq = ?";
				
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
		
}
