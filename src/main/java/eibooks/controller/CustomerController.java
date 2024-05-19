package eibooks.controller;

import eibooks.common.PageDTO;
import eibooks.dao.CustomerDAO;
import eibooks.dto.AddressDTO;
import eibooks.dto.CustomerDTO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("*.cs")
public class CustomerController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8"); // 한글처리

        String uri = request.getRequestURI();
        String action = uri.substring(uri.lastIndexOf("/"));
        System.out.println(uri);

        if (action.equals("/customerList.cs")) {

            // 검색필드,검색어를 req객체에서 받아옴
            String searchField = request.getParameter("searchField");
            String searchWord = request.getParameter("searchWord");

            // map에 받아온 값을 저장
            Map<String, String> map = new HashMap<>();
            map.put("searchField", searchField);
            map.put("searchWord", searchWord);

            // 페이징에 사용될 정보
            int amount = 10; // 한 페이지에 표시할 항목 수
            int pageNum = 1; // 기본 페이지 번호

            // 페이지 번호가 요청 파라미터로 전달된 경우 이를 정수로 변환하여 사용
            String sPageNum = request.getParameter("pageNum");
            if (sPageNum != null) pageNum = Integer.parseInt(sPageNum);
            int offset = (pageNum - 1) * amount; // 데이터베이스 조회 시작 위치 계산

            // 페이징 정보를 맵에 저장
            map.put("offset", offset + "");
            map.put("amount", amount + "");


            // dao 객체에서 메서드이용
            CustomerDAO dao = new CustomerDAO();
            List<CustomerDTO> customerList = dao.selectPageList(map);
            int totalCount = dao.selectCount(map);
            int totalCustomerCount = dao.selectTotalCount();

            // 페이징
            PageDTO paging = new PageDTO(pageNum, amount, totalCount);

            // req 객체에 값 싣어보내기
            request.setAttribute("customerList", customerList);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("paging", paging);
            request.setAttribute("searchField", searchField);
            request.setAttribute("searchWord", searchWord);
            request.setAttribute("totalCustomerCount", totalCustomerCount);

            String path = "/admin/customerList.jsp";
            request.getRequestDispatcher(path).forward(request, response);

        } else if (action.equals("/customerView.cs")) {

            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO customer = dao.getCustomerDetails(cus_seq);

            request.setAttribute("customer", customer);

            String path = "/admin/customerView.jsp";
            request.getRequestDispatcher(path).forward(request, response);

        } else if (action.equals("/updateCustomer.cs")) {
            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO customer = dao.getCustomerDetails(cus_seq);

            request.setAttribute("customer", customer);

            String path = "/admin/updateCustomer.jsp";
            request.getRequestDispatcher(path).forward(request, response);

        } else if (action.equals("/updateCustomerProc.cs")) {

            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String tel = request.getParameter("tel");
            String email = request.getParameter("email");
            String postalCode = request.getParameter("postalCode");
            String addr = request.getParameter("addr");
            String addr_detail = request.getParameter("addr_detail");

            CustomerDTO customer = new CustomerDTO();
            customer.setCus_seq(cus_seq);
            customer.setPassword(password);
            customer.setName(name);
            customer.setTel(tel);
            customer.setEmail(email);

            AddressDTO addrInfo = new AddressDTO();
            addrInfo.setCus_seq(cus_seq);
            addrInfo.setPostalCode(postalCode);
            addrInfo.setAddr(addr);
            addrInfo.setAddr_detail(addr_detail);

            customer.setAddrInfo(addrInfo);

            CustomerDAO dao = new CustomerDAO();
            dao.updateCustomer(customer);

            response.sendRedirect("customerView.cs?cus_seq=" + cus_seq);

        } else if (action.equals("/deleteCustomerProc.cs")) {

            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));

            CustomerDAO dao = new CustomerDAO();
            dao.deleteCustomer(cus_seq);

            System.out.println("실행됨");
            response.sendRedirect("customerList.cs");

        }

    }
}