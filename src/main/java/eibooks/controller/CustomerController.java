package eibooks.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import eibooks.dao.CustomerDAO;
import eibooks.dto.AddressDTO;
import eibooks.dto.CustomerDTO;

@WebServlet("*.cu")
public class CustomerController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CustomerController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doProcess");
		request.setCharacterEncoding("utf-8"); // 한글처리

		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		System.out.println(uri);
		
		if(action.equals("/updateMyPage.cu")) {
			// 임시 seq
			int cus_seq = 1;
			
            CustomerDTO dto = new CustomerDTO();
            dto.setCus_seq(cus_seq); 

            CustomerDAO dao = new CustomerDAO();
            CustomerDTO customer = dao.getCustomer(dto);

            request.setAttribute("customer", customer);

            String path = "./updateMyPage.jsp";
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/updateMyPageProc.cu")) {
			
            int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));
            String cus_id = request.getParameter("cus_id");
            String name = request.getParameter("name");
            String password = request.getParameter("password");
            String tel = request.getParameter("tel");
            String email = request.getParameter("email");
            String postalCode = request.getParameter("postalCode");
            String addr = request.getParameter("addr");
            String addr_detail = request.getParameter("addr_detail");

            CustomerDAO dao = new CustomerDAO();
            AddressDTO aDto = new AddressDTO();
            aDto.setPostalCode(postalCode);
            aDto.setAddr(addr);
            aDto.setAddr_detail(addr_detail);
            
            CustomerDTO dto = new CustomerDTO(cus_seq, cus_id, password, name, tel, email);
            dto.setAddrInfo(aDto);
            
            dao.updateCustomer(dto);
            dao.updateAddress(dto);

            String path = "./customer/updateMyPage.cu";
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if (action.equals("/deleteMyPageProc.cu")) {

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
