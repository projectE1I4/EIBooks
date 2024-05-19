package eibooks.dao;

import eibooks.common.JDBCConnect;
import eibooks.dto.AddressDTO;
import eibooks.dto.CustomerDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CustomerDAO {
    // 고객 리스트 조회
    public List<CustomerDTO> selectPageList(Map<String, String> map) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // search 여부 판단
        boolean isSearch = false;
        if (map.get("searchWord") != null && map.get("searchWord").length() != 0) {
            isSearch = true;
        }

        // customer 정보를 담을 list컬렉션
        List<CustomerDTO> customerList = new ArrayList<>();

        // 조회에 사용될 쿼리문
        String sql = "select * from customer ";

        // 검색 한다면 where절조건
        if (isSearch) {
            sql += "where " + map.get("searchField") + " like ? ";
        }
        sql += "order by cus_seq desc ";

        // 한번에 보여질 글과 페이지 개수 제한
        sql += "limit ? offset ? ";

        try {
            conn = JDBCConnect.getConnection();
            pstmt = conn.prepareStatement(sql);

            if (isSearch) {
                pstmt.setString(1, "%" + map.get("searchWord") + "%");
                pstmt.setInt(2, Integer.parseInt(map.get("amount")));
                pstmt.setInt(3, Integer.parseInt(map.get("offset")));
            } else {
                pstmt.setInt(1, Integer.parseInt(map.get("amount")));
                pstmt.setInt(2, Integer.parseInt(map.get("offset")));
            }

            rs = pstmt.executeQuery();

            while (rs.next()) {
                int cus_seq = rs.getInt("cus_seq");
                String cus_id = rs.getString("cus_id");
                String password = rs.getString("password");
                String name = rs.getString("name");
                String tel = rs.getString("tel");
                String email = rs.getString("email");
                String regDate = rs.getString("regDate");

                CustomerDTO dto = new CustomerDTO(cus_seq, cus_id, password, name, tel, email, regDate);
                customerList.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            JDBCConnect.close(rs, pstmt, conn);

        }
        return customerList;
    }

    // 조건에 따른 고객리스트 갯수 카운트 메서드
    public int selectCount(Map<String, String> map) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 검색 결과에 따른 결과 개수를 담을 변수
        int totalCount = 0;
        List<CustomerDTO> customerList = new ArrayList<>();

        // 검색 여부
        boolean isSearch = false;
        if (map.get("searchWord") != null && map.get("searchWord").length() != 0) {
            isSearch = true;
        }
        // 쿼리문
        String sql = "select count(cus_seq) as cnt from customer";

        // 만약 검색을 진행했다면?
        if (isSearch) {
            sql += " where " + map.get("searchField") + " like ? ";
        }

        conn = JDBCConnect.getConnection();

        try {
            pstmt = conn.prepareStatement(sql);

            if (isSearch) {
                pstmt.setString(1, "%" + map.get("searchWord") + "%");
            }

            // 쿼리 실행
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 쿼리 조회 결과를 totalCount에 할당
                totalCount = rs.getInt("cnt");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }

        return totalCount;
    }

    // 전체 고객수 카운트 메서드
    public int selectTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 검색 결과에 따른 결과 개수를 담을 변수
        int totalCustomerCount = 0;

        // 쿼리문
        String sql = "select count(cus_seq) as cnt from customer";

        conn = JDBCConnect.getConnection();
        try {
            pstmt = conn.prepareStatement(sql);

            // 쿼리 실행
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 쿼리 조회 결과를 totalCustomerCount에 할당
                totalCustomerCount = rs.getInt("cnt");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }

        return totalCustomerCount;
    }

    // 고객 리스트 항목을 하나 클릭하면 cus_seq에 해당하는 정보를 보여주는 메서드
    public CustomerDTO getCustomerDetails(int cus_seq) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        CustomerDTO customer = null;

        String sql = "SELECT c.cus_seq, c.cus_id, c.password, c.name, c.tel, c.email, c.regDate, " +
            "a.postalCode, a.addr, a.addr_detail " +
            "FROM customer c " +
            "LEFT JOIN customer_addr a ON c.cus_seq = a.cus_seq " +
            "WHERE c.cus_seq = ?";

        conn = JDBCConnect.getConnection();

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cus_seq);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                customer = new CustomerDTO();
                customer.setCus_seq(rs.getInt("cus_seq"));
                customer.setCus_id(rs.getString("cus_id"));
                customer.setPassword(rs.getString("password"));
                customer.setName(rs.getString("name"));
                customer.setTel(rs.getString("tel"));
                customer.setEmail(rs.getString("email"));
                customer.setRegDate(rs.getString("regDate"));

                AddressDTO addr = new AddressDTO();
                addr.setPostalCode(rs.getString("postalCode"));
                addr.setAddr(rs.getString("addr"));
                addr.setAddr_detail(rs.getString("addr_detail"));

                customer.setAddrInfo(addr);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }
        return customer;
    }

    // 고객 정보 업데이트 메서드
    public void updateCustomer(CustomerDTO customer) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement addrPstmt = null;

        String sql = "UPDATE customer SET password=?, name=?, tel=?, email=? WHERE cus_seq=?";
        String addrSql = "UPDATE customer_addr SET postalCode=?, addr=?, addr_detail=? WHERE cus_seq=?";

        conn = JDBCConnect.getConnection();

        try {
            pstmt = conn.prepareStatement(sql);
            addrPstmt = conn.prepareStatement(addrSql);

            // 고객정보 업데이트
            pstmt.setString(1, customer.getPassword());
            pstmt.setString(2, customer.getName());
            pstmt.setString(3, customer.getTel());
            pstmt.setString(4, customer.getEmail());
            pstmt.setInt(5, customer.getCus_seq());
            pstmt.executeUpdate();

            // 주소정보 업데이트
            AddressDTO addr = customer.getAddrInfo();
            addrPstmt.setString(1, addr.getPostalCode());
            addrPstmt.setString(2, addr.getAddr());
            addrPstmt.setString(3, addr.getAddr_detail());
            addrPstmt.setInt(4, addr.getCus_seq());
            addrPstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(addrPstmt, pstmt, conn);
        }


    }

    // 고객 정보 삭제 메서드
    public void deleteCustomer(int cus_seq) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement addrPstmt = null;

        String sql = "DELETE FROM customer WHERE cus_seq=?";
        String addrSql = "DELETE FROM customer_addr WHERE cus_seq=?";

        conn = JDBCConnect.getConnection();

        try {

            // 주소 정보 삭제
            addrPstmt = conn.prepareStatement(addrSql);
            addrPstmt.setInt(1, cus_seq);
            addrPstmt.executeUpdate();

            // 고객 정보 삭제
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cus_seq);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(addrPstmt, pstmt, conn);
        }


    }

}