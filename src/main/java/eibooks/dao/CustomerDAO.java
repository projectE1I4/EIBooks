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

    // 고객 회원가입 메서드
    public void insertCustomer(CustomerDTO customer) {

        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement addrPstmt = null;

        String sql = "INSERT INTO customer (cus_id, password, name, tel, email) VALUES (?, ?, ?, ?, ?)";
        String addrSql = "INSERT INTO customer_addr (cus_seq, postalCode, addr, addr_detail) VALUES (LAST_INSERT_ID(), ?, ?, ?)";

        conn = JDBCConnect.getConnection();
        try {
            pstmt = conn.prepareStatement(sql);
            addrPstmt = conn.prepareStatement(addrSql);

            // 고객정보 삽입
            pstmt.setString(1, customer.getCus_id());
            pstmt.setString(2, customer.getPassword());
            pstmt.setString(3, customer.getName());
            pstmt.setString(4, customer.getTel());
            pstmt.setString(5, customer.getEmail());
            pstmt.executeUpdate();

            // 주소정보 삽입
            AddressDTO addr = customer.getAddrInfo();
            addrPstmt.setString(1, addr.getPostalCode());
            addrPstmt.setString(2, addr.getAddr());
            addrPstmt.setString(3, addr.getAddr_detail());
            addrPstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(addrPstmt, pstmt, conn);
        }
    }

    // 고객 로그인 메서드
    public CustomerDTO getCustomerById(String cus_id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        CustomerDTO customer = null;

        String sql = "SELECT c.cus_seq, c.cus_id, c.password, c.name, c.tel, c.email, c.regDate, " +
            "a.postalCode, a.addr, a.addr_detail " +
            "FROM customer c " +
            "LEFT JOIN customer_addr a ON c.cus_seq = a.cus_seq " +
            "WHERE c.cus_id = ?";

        try {
            conn = JDBCConnect.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cus_id);
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
                addr.setCus_seq(rs.getInt("cus_seq"));

                customer.setAddrInfo(addr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }

        return customer;
    }

    // 로그인 유효성 검사 메서드
    public boolean checkIdExists(String cus_id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM customer WHERE cus_id = ?";

        try {
            conn = JDBCConnect.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cus_id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JDBCConnect.close(rs, pstmt, conn);
        }

        return exists;
    }

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

    public int updateMyPage(CustomerDTO dto) {
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
