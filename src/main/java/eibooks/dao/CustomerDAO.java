package eibooks.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import eibooks.common.JDBCConnect;
import eibooks.dto.AddressDTO;
import eibooks.dto.CustomerDTO;

public class CustomerDAO {

	public int getCustomerCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;		

		int cusCnt = 0;
		
		try {
			conn = JDBCConnect.getConnection();
			
			String sql = "select count(cus_seq) as cnt from customer "
					+ "where del_YN = 'N' ";

			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cusCnt = rs.getInt("cnt");
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			JDBCConnect.close(rs, pstmt, conn);
			
		}
		
		return cusCnt;
	}

	public CustomerDTO getCustomer(CustomerDTO dto) {
		Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null; 
        
        try {
            conn = JDBCConnect.getConnection();

            String sql = "select * from customer c "
            		+ "join customer_addr a "
            		+ "on c.cus_seq = a.cus_seq "
            		+ "where c.cus_seq = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getCus_seq());
            
            rs = pstmt.executeQuery(); 

            dto = null;
            if (rs.next()) { 
                int cus_seq = rs.getInt("cus_seq");
                String cus_id = rs.getString("cus_id");
                String password = rs.getString("password");
                String name = rs.getString("name");
                String tel = rs.getString("tel");
                String email = rs.getString("email");
                String del_YN = rs.getString("del_YN");
                
                AddressDTO addr = new AddressDTO();
				addr.setPostalCode(rs.getString("postalCode"));
				addr.setAddr(rs.getString("addr"));
				addr.setAddr_detail(rs.getString("addr_detail"));
                
                dto = new CustomerDTO(cus_seq, cus_id, password, name, tel, email, del_YN);
                dto.setAddrInfo(addr);
            }

        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }
        return dto;
	}

	public int updateCustomer(CustomerDTO dto) {
		Connection conn = null;
        PreparedStatement pstmt = null;
        int rs = 0;

        try {
            conn = JDBCConnect.getConnection();

            String sql = "update customer "
            		+ "set password = ?, name = ?,"
            		+ "tel = ?, email = ? "
            		+ "where cus_seq =? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getPassword());
            pstmt.setString(2, dto.getName());
            pstmt.setString(3, dto.getTel());
            pstmt.setString(4, dto.getEmail());
            pstmt.setInt(5, dto.getCus_seq());

            rs = pstmt.executeUpdate();  

        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
            JDBCConnect.close(pstmt, conn);
        }
        return rs;
	}

	public void updateAddress(CustomerDTO dto) {
		Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = JDBCConnect.getConnection();

            String sql = "update customer_addr "
            		+ "set postalCode = ?, addr = ?,"
            		+ "addr_detail = ? "
            		+ "where cus_seq =? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getAddrInfo().getPostalCode());
            pstmt.setString(2, dto.getAddrInfo().getAddr());
            pstmt.setString(3, dto.getAddrInfo().getAddr_detail());
            pstmt.setInt(4, dto.getCus_seq());

            pstmt.executeUpdate();  

        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
            JDBCConnect.close(pstmt, conn);
        }
	}

	public void deleteCustomer(CustomerDTO dto) {
		Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null; // select

        try {
            conn = JDBCConnect.getConnection();

            String sql = "update customer set del_YN = 'Y' "
            		+ "where cus_seq = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getCus_seq());
            
            pstmt.executeUpdate(); 

        } catch (Exception e) {
            e.printStackTrace();
            
        } finally {
            JDBCConnect.close(pstmt, conn);
        }
	}
	
}
