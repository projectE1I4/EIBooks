package eibooks.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import eibooks.common.PageDTO;
import eibooks.dao.OrderDAO;
import eibooks.dao.cartDAO;
import eibooks.dto.OrderDTO;
import eibooks.dto.cartDTO;

//~.or로 끝나는 경우 여기서 처리함
@WebServlet("*.or")
public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public OrderController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/// join.jsp? login.jsp? joinProc?
		System.out.println("doProcess");
		request.setCharacterEncoding("utf-8"); // 한글처리

		// URI 받아옴
		String uri = request.getRequestURI();
		// /의 뒤에 있는 내용을 가져옴.
		String action = uri.substring(uri.lastIndexOf("/"));
		// uri 출력
		System.out.println(uri);
		
		if(action.equals("/orderList.or")) {
			String orderBy = request.getParameter("orderBy");
			Map<String, String> map = new HashMap<>();
			
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			map.put("orderBy", orderBy);
			
			OrderDTO dto = new OrderDTO();
			dto.setCus_seq(cus_seq);
            
			OrderDAO dao = new OrderDAO();
            List<OrderDTO> orderList = dao.getOrderList(map);
            int totalCount = dao.selectCount(dto);
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("orderList", orderList);
            request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("orderBy", orderBy);

            // forward
            String path = "./orderList.jsp"; // 전체 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/customerOrder.or")) {
			
			String orderBy = request.getParameter("orderBy");
			// System.out.println(orderBy);
			Map<String, String> map = new HashMap<>();
			
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			map.put("orderBy", orderBy);

			int cus_seq = Integer.parseInt(request.getParameter("cus_seq"));
			OrderDTO dto = new OrderDTO();
			dto.setCus_seq(cus_seq);
			
			map.put("cus_seq", cus_seq + "");
            
            OrderDAO dao = new OrderDAO();
            List<OrderDTO> orderList = dao.getCustomerOrder(map);
            int totalCount = dao.selectCount(dto);

            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("orderList", orderList);
            request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("orderBy", orderBy);

            // forward
            String path = "./customerOrder.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
            
		} else if(action.equals("/orderView.or")) {
			
			String sPur_seq = request.getParameter("pur_seq"); 
			int pur_seq = Integer.parseInt(sPur_seq);
			
			OrderDTO dto = new OrderDTO();
			dto.setPur_seq(pur_seq);
            
            OrderDAO dao = new OrderDAO();
            OrderDTO order = dao.getCustomerDetail(dto);
            List<OrderDTO> orderList = dao.getOrderDetail(dto);
         			
            request.setAttribute("order", order);
            request.setAttribute("orderList", orderList);

            // forward
            String path = "./orderView.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/myPage.or")) {
			
			String searchWord = request.getParameter("searchWord");

			Map<String, String> map = new HashMap<>();
			map.put("searchWord", searchWord);
			
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");

			HttpSession session = request.getSession();
			// 로그인 사용자로 바꿔야 하는 부분
			int cus_seq = (int) session.getAttribute("cus_seq");
			OrderDTO dto = new OrderDTO();
			dto.setCus_seq(cus_seq);
			
			map.put("cus_seq", cus_seq + "");
            
            OrderDAO dao = new OrderDAO();
            List<OrderDTO> orderList = dao.getCustomerOrder(map);
            int totalCount = dao.selectCount(dto);

            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("orderList", orderList);
            request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("searchWord", searchWord);

            // forward
            String path = "./myPage.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/myOrderDetail.or")) {
			
			String sPur_seq = request.getParameter("pur_seq"); 
			int pur_seq = Integer.parseInt(sPur_seq);
			
			OrderDTO dto = new OrderDTO();
			dto.setPur_seq(pur_seq);
            
            OrderDAO dao = new OrderDAO();
            OrderDTO order = dao.getCustomerDetail(dto);
            List<OrderDTO> orderList = dao.getOrderDetail(dto);
         			
            request.setAttribute("order", order);
            request.setAttribute("orderList", orderList);

            // forward
            String path = "./myOrderDetail.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/orderInsert.or")) {
			
			System.out.println("/orderInsert.or");
			
			HttpSession session = request.getSession();
			Map<String, Integer> map = (Map<String, Integer>) session.getAttribute("orderMap");
			Map<String, Integer> buyMap = (Map<String, Integer>) session.getAttribute("buyMap");
			int book_seq = 0;
			OrderDAO orderdao = new OrderDAO();
			if(map != null) {
				book_seq = map.get("book_seq");
				System.out.println(session.getAttribute("orderMap"));
				orderdao.insertOrderList(map);
				orderdao.updateStock(map);
			} else if (buyMap != null) {
				book_seq = buyMap.get("book_seq");
				System.out.println(session.getAttribute("buyMap"));
				orderdao.insertOrderList(buyMap);
				orderdao.updateStock(buyMap);
			} else {
				System.out.println("문제 발생");
			}
			
            // forward
            String path = "./customer/customerOrderComplete.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
		} 
		//장바구니에서 주문하기 
		else if(action.equals("/cartOrder.or")) {
			
			System.out.println("/cartOrder.or");
			
			HttpSession session = request.getSession();
			int cusSeq = (Integer) session.getAttribute("cus_seq");
		    
			OrderDAO orderdao = new OrderDAO();
			
		    cartDTO dto = new cartDTO();
		    dto.setCusSeq(cusSeq);
		    
		    cartDAO dao = new cartDAO();
		    List<cartDTO> cartList = dao.getCartList(cusSeq);            
		    orderdao.cartOrderList(dto);

			for(cartDTO c : cartList) {
				orderdao.cartList(c);
				orderdao.updateStock(c);
			}
			dao.deleteCartAll(cusSeq);
			
            // forward
            String path = "./customer/customerOrderComplete.jsp"; // 회원 별 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
		}
	}
}
