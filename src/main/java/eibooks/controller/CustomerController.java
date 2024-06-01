package eibooks.controller;

import eibooks.common.PageDTO;
import eibooks.dao.CustomerDAO;
import eibooks.dto.AddressDTO;
import eibooks.dto.CustomerDTO;
import org.json.JSONObject;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.IOException;


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
//        System.out.println(uri);

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
            CustomerDTO dto = new CustomerDTO();
            dto.setCus_seq(cus_seq);
            dao.deleteCustomer(dto);

            System.out.println("실행됨");
            response.sendRedirect("customerList.cs");

        } else if (action.equals("/signup.cs")) { // 회원가입으로 이동

            request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);

        } else if (action.equals("/signupProc.cs")) { // 회원가입 처리 프록시

            // 회원가입 처리
            String cus_id = request.getParameter("cus_id");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String name = request.getParameter("name");
            String tel = request.getParameter("tel");
            String postalCode = request.getParameter("postalCode");
            String addr = request.getParameter("addr");
            String addr_detail = request.getParameter("addr_detail");
            String email = request.getParameter("email");

            // 유효성 검사
            if (cus_id == null || !cus_id.matches("^[a-zA-Z0-9]{4,12}$")) {
                request.setAttribute("errorMessage", "아이디는 4글자 이상, 12글자 이하의 영어 또는 숫자만 가능합니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            CustomerDAO dao = new CustomerDAO();

            if (dao.checkIdExists(cus_id)) {
                request.setAttribute("errorMessage", "이미 존재하는 아이디입니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            if (password == null || !password.matches("^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$")) {
                request.setAttribute("errorMessage", "비밀번호는 8글자 이상이어야 하며, 영문, 숫자, 특수문자를 포함해야 합니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            if (name == null || !name.matches("^[a-zA-Z가-힣\\s]+$")) {
                request.setAttribute("errorMessage", "이름에는 특수문자가 포함될 수 없습니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            if (tel == null || !tel.replaceAll("-", "").matches("^\\d{11}$")) {
                request.setAttribute("errorMessage", "전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            if (postalCode == null || !postalCode.matches("^\\d{5}$")) {
                request.setAttribute("errorMessage", "우편번호는 숫자 5자리여야 합니다.");
                request.getRequestDispatcher("/auth/signup.jsp").forward(request, response);
                return;
            }

            // 회원정보 담기
            CustomerDTO customer = new CustomerDTO();
            customer.setCus_id(cus_id);
            customer.setPassword(password);
            customer.setName(name);
            customer.setTel(tel);
            customer.setEmail(email);

            // 회원주소 담기
            AddressDTO addrInfo = new AddressDTO();
            addrInfo.setPostalCode(postalCode);
            addrInfo.setAddr(addr);
            addrInfo.setAddr_detail(addr_detail);
            customer.setAddrInfo(addrInfo);

            dao.insertCustomer(customer);

            response.sendRedirect("login.cs");

        } else if (action.equals("/login.cs")) { // 로그인 페이지로 이동

            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);

        } else if (action.equals("/loginProc.cs")) {  // 로그인 처리 프록시

            String cus_id = request.getParameter("cus_id");
            String password = request.getParameter("password");

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO customer = dao.getCustomerById(cus_id);

            if (customer == null) {
                // 유효성 검사를 서버에서 처리하는 경우
                // 아이디가 존재하지 않는 경우
                request.setAttribute("errorMessageId", "아이디가 존재하지 않습니다.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            } else if (!customer.getPassword().equals(password)) {
                // 비밀번호가 일치하지 않는 경우
                request.setAttribute("errorMessagePw", "비밀번호가 일치하지 않습니다.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            } else {
                // 로그인 성공
                HttpSession session = request.getSession();
                session.setAttribute("customer", customer);
                session.setAttribute("cus_id", customer.getCus_id());
                session.setAttribute("cus_seq", customer.getCus_seq());
                session.setAttribute("name", customer.getName());
                session.setAttribute("manager_YN", customer.getManager_YN());

                if ("Y".equals(session.getAttribute("manager_YN"))) {
                    System.out.println("관리자 접속");
                    response.sendRedirect("/EIBooks/admin/main.bo");
                } else {
                    response.sendRedirect("/EIBooks/userMain.bo");
                }
            }

        } else if (action.equals("/checkIdProc.cs")) { // 아이디 중복검사

            String cus_id = request.getParameter("cus_id");

            CustomerDAO dao = new CustomerDAO();
            boolean exists = dao.checkIdExists(cus_id);

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"exists\":" + exists + "}");
            out.flush();
            out.close();

        } else if (action.equals("/findId.cs")) { // 아이디 찾기 페이지로 이동

            request.getRequestDispatcher("/auth/findId.jsp").forward(request, response);

        } else if (action.equals("/findIdProc.cs")) { // 아이디 찾기 프록시

            String name = request.getParameter("name");
            String tel = request.getParameter("tel");

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO dto = new CustomerDTO();
            dto.setName(name);
            dto.setTel(tel);
            CustomerDTO customer = dao.findCustomerInfo(dto);

            // proc주소 노출방지를 위해 ajax 통신으로 출력
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();

            JSONObject jsonResponse = new JSONObject();
            if (customer != null) {
                String message = customer.getName() + " 회원님의 아이디는 " + customer.getCus_id() + " 입니다.";
                jsonResponse.put("success", true);
                jsonResponse.put("message", message);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "존재하지 않는 정보입니다.");
            }

            out.print(jsonResponse.toString());
            out.close();

        } else if (action.equals("/verification.cs")) { // 비밀번호 변경 전 본인인증페이지 이동

            request.getRequestDispatcher("/auth/verification.jsp").forward(request, response);

        } else if (action.equals("/verificationProc.cs")) { // 비밀번호 재설정 전 본인확인
            String cus_id = request.getParameter("cus_id");
            String name = request.getParameter("name");
            String tel = request.getParameter("tel");

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO dto = new CustomerDTO();
            dto.setCus_id(cus_id);
            dto.setName(name);
            dto.setTel(tel);

            CustomerDTO customer = dao.findCustomerInfo(dto);
            JSONObject jsonResponse = new JSONObject();

            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();

            if (customer == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "해당하는 정보가 없습니다.");
            } else {
                jsonResponse.put("success", true);
                jsonResponse.put("message", "본인인증 성공\n2초 뒤 비밀번호 재설정 페이지로 이동합니다.");
            }
            System.out.println("Verification Response: " + jsonResponse.toString()); // 응답 로그 추가
            out.print(jsonResponse.toString());
            out.close();

        } else if (action.equals("/resetPassword.cs")) { // 비밀번호 재설정 페이지 이동

            request.getRequestDispatcher("/auth/resetPassword.jsp").forward(request, response);

        } else if (action.equals("/resetPasswordProc.cs")) { // 비밀번호 재설정 처리
            String cus_id = request.getParameter("cus_id");
            String newPassword = request.getParameter("newPassword");

            CustomerDTO customer = new CustomerDTO();
            customer.setCus_id(cus_id);
            customer.setPassword(newPassword);

            CustomerDAO dao = new CustomerDAO();
            String resultMessage = dao.updateCustomerPassword(customer);

            JSONObject jsonResponse = new JSONObject();

            if (resultMessage.equals("비밀번호가 성공적으로 변경되었습니다.")) {
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
            }
            jsonResponse.put("message", resultMessage);

            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.close();
        } else if (action.equals("/logoutProc.cs")) {

            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("/EIBooks/userMain.bo");

        } else if (action.equals("/updateMyPage.cs")) {

            HttpSession session = request.getSession();
            int cus_seq = (int) session.getAttribute("cus_seq");
            
            CustomerDTO dto = new CustomerDTO();
            dto.setCus_seq(cus_seq);

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO customer = dao.getCustomer(dto);

            request.setAttribute("customer", customer);

            String path = "./updateMyPage.jsp";
            request.getRequestDispatcher(path).forward(request, response);

        } else if (action.equals("/updateMyPageProc.cs")) {

        	int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));
            String cus_id = request.getParameter("cus_id");
        	String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String name = request.getParameter("name");
            String tel = request.getParameter("tel");
            String postalCode = request.getParameter("postalCode");
            String addr = request.getParameter("addr");
            String addr_detail = request.getParameter("addr_detail");
            String email = request.getParameter("email");


            CustomerDAO dao = new CustomerDAO();

            if (password == null || !password.matches("^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$")) {
                request.setAttribute("errorMessage", "비밀번호는 8글자 이상이어야 하며, 영문, 숫자, 특수문자를 포함해야 합니다.");
                request.getRequestDispatcher("/customer/updateMyPage.cs").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                request.getRequestDispatcher("/customer/updateMyPage.cs").forward(request, response);
                return;
            }

            if (name == null || !name.matches("^[가-힣a-zA-Z\\\\s]*$")) {
                request.setAttribute("errorMessage", "이름에는 특수문자가 포함될 수 없습니다.");
                request.getRequestDispatcher("/customer/updateMyPage.cs").forward(request, response);
                return;
            }

            if (tel == null || !tel.replaceAll("-", "").matches("^\\d{11}$")) {
                request.setAttribute("errorMessage", "전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                request.getRequestDispatcher("/customer/updateMyPage.cs").forward(request, response);
                return;
            }

            if (postalCode == null || !postalCode.matches("^\\d{5}$")) {
                request.setAttribute("errorMessage", "우편번호는 숫자 5자리여야 합니다.");
                request.getRequestDispatcher("/customer/updateMyPage.cs").forward(request, response);
                return;
            }
        	
            AddressDTO aDto = new AddressDTO();
            aDto.setPostalCode(postalCode);
            aDto.setAddr(addr);
            aDto.setAddr_detail(addr_detail);

            CustomerDTO dto = new CustomerDTO(cus_seq, cus_id, password, name, tel, email);
            dto.setAddrInfo(aDto);

            dao.updateCustomer(dto);
            dao.updateAddress(dto);

            String path = "./updateMyPage.cs";
            request.getRequestDispatcher(path).forward(request, response);

        } else if (action.equals("/deleteMyPageProc.cs")) {

            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));
            String password = request.getParameter("password");
            boolean isCheck = false;

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO dto = new CustomerDTO();
            dto.setCus_seq(cus_seq);

            // 맞는 유저의 정보를 dto에 다시 넣어줌
            dto = dao.getCustomer(dto);

            if (dto != null) {
                // req에 입력된 pw와 dto에 있는 pw가 같은지 검증
                if (password.equals(dto.getPassword())) {
                    isCheck = true;
                    dao.deleteCustomer(dto);
                }
            }

            String path = "";

            if (isCheck) {
                path = "/EIBooks/index.jsp";
            } else {
                path = "/EIBooks/customer/deleteMypage.jsp";
            }
            response.sendRedirect(path);
        }
    }

}