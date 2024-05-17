package eibooks.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import eibooks.common.PageDTO;
import eibooks.dao.OrderDAO;
import eibooks.dto.OrderDTO;

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
			System.out.println(orderBy);
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
			
			// 임시로 회원 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
			OrderDTO dto = new OrderDTO();
			dto.setPur_seq(1);
            
            // 장바구니에 담긴 책 목록 조회
            OrderDAO dao = new OrderDAO();
            List<OrderDTO> orderList = dao.getOrderList(map);
            int totalCount = dao.selectCount();
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            // 장바구니 페이지로 전달할 데이터 설정
            request.setAttribute("orderList", orderList);
            request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);

            // forward
            String path = "./orderList.jsp"; // 장바구니 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
		}
	}
}
