package eibooks.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import eibooks.dao.BookDAO;
import eibooks.dao.cartDAO;
import eibooks.dto.BookDTO;
import eibooks.dto.cartDTO;

// ~.cc로 끝나는 경우 여기서 처리함
@WebServlet("*.cc")
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CartController() {
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
		
		if (action.equals("/customerCart.cc")) {
			HttpSession session = request.getSession();
            int cusSeq =(int)session.getAttribute("cus_seq");

            
            // 장바구니에 담긴 책 목록 조회
            cartDAO cartDao = new cartDAO();
            List<cartDTO> cartList = cartDao.getCartList(cusSeq);
            System.out.println("cart conn ok!");
            
            int totalCartPrice = cartDao.totalCartPrice(cusSeq);
            
            // 장바구니 페이지로 전달할 데이터 설정
            request.setAttribute("cartList", cartList);
            request.setAttribute("cusSeq", cusSeq);
            request.setAttribute("totalCartPrice", totalCartPrice);

            // forward
            String path = "./customerCart.jsp"; // 장바구니 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
        }
		else if(action.equals("/deleteCart.cc")) {
		    int cartISeq = Integer.parseInt(request.getParameter("cartISeq"));

		    cartDAO cartDao = new cartDAO();
		    // 장바구니에서 항목 삭제
		    int deleteResult = cartDao.deleteCart(cartISeq);

		    // 삭제 결과에 따라 메시지 설정
		    String message;
		    if(deleteResult > 0) {
		        message = "장바구니 항목이 삭제되었습니다.";
		    } else {
		        message = "장바구니 항목 삭제에 실패했습니다.";
		    }

		    // 삭제 결과 메시지를 request에 저장하여 페이지로 전달
		    request.setAttribute("message", message);
		    
		 // 장바구니 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/customer/customerCart.cc");
		}
		else if(action.equals("/deleteSelectedItems.cc")) {
		    // 선택된 항목들을 받아옴
		    String[] selectedItems = request.getParameterValues("selectedItems");
		    if(selectedItems != null && selectedItems.length > 0) {
		        // 여러 항목 선택 시 동시 삭제를 위해 각 체크박스 값을 받아와서 for문으로 순회하며 삭제함
		        cartDAO cartDao = new cartDAO();
		        for(String selectedItem : selectedItems) {
		        	try {
		                int cartISeq = Integer.parseInt(selectedItem);
		                cartDao.deleteCart(cartISeq);
		            } catch(Exception e) {
		                // 정수로 변환할 수 없는 값이 있을 경우 처리
		                e.printStackTrace(); // 또는 로그에 기록
		            }
		        }
		        // 삭제 후, 장바구니 페이지로 리다이렉트
		        response.sendRedirect(request.getContextPath() + "/customer/customerCart.cc");
		    } else {
		        // 선택된 항목이 없을 경우 경고창을 띄우고 페이지를 리다이렉트
		        response.getWriter().println("<script>alert('선택된 항목이 없습니다.');"
		                + "location.href='" + request.getContextPath() + "/customer/customerCart.cc';</script>");
		    }
		}
		else if(action.equals("/updateCart.cc")) {
			System.out.println(action);
			request.setCharacterEncoding("utf-8");
			
			int cartISeq = 0;
		    int cartICount = 0;
		    int cusSeq = 0;
		    try {
		        // 요청에서 cartISeq와 cartICount 파라미터 값을 가져옴
		        cartISeq = Integer.parseInt(request.getParameter("cartISeq"));
		        cartICount = Integer.parseInt(request.getParameter("cartICount"));
		        cusSeq = Integer.parseInt(request.getParameter("cusSeq"));
		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    // cartDAO 인스턴스 생성 및 updateCart 메소드 호출하여 수량 업데이트
		    cartDAO cartDao = new cartDAO();
		    int updateRs = cartDao.updateCart(cartISeq, cartICount);
		    
		    // 장바구니 항목의 총 가격 계산
		    int totalPrice = cartDao.updatePrice(cartISeq, cartICount);

		    // 업데이트 결과에 따라 응답 메시지 설정
		    String message;
		    if(updateRs > 0) {
		        message = "수량이 업데이트되었습니다.";
		    } else {
		        message = "수량 업데이트에 실패했습니다.";
		    }
		    
	        int totalCartPrice = cartDao.totalCartPrice(cusSeq);

		    // 클라이언트에게 JSON 형식의 응답 보내기
		    JSONObject jsonResponse = new JSONObject();
		    jsonResponse.put("message", message);
		    jsonResponse.put("totalPrice", totalPrice);
		    jsonResponse.put("totalCartPrice", totalCartPrice);
		    System.out.println("토탈가격 : "+totalCartPrice);
		    
		    // 응답 보내기
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    PrintWriter out = response.getWriter();
		    out.print(jsonResponse.toString());
		    out.flush();
		    out.close(); // 리소스 해제
		}
		else if(action.equals("/CartPrice.cc")) {
			System.out.println(action);
			request.setCharacterEncoding("utf-8");
			
			int cusSeq = 0;
		    int cartSeq = 0;
		    try {
		        String cusSeqStr = request.getParameter("cusSeq");
		        String cartSeqStr = request.getParameter("cartSeq");
		        
		        if (cusSeqStr != null && !cusSeqStr.isEmpty()) {
		            cusSeq = Integer.parseInt(cusSeqStr);
		        }
		        
		        if (cartSeqStr != null && !cartSeqStr.isEmpty()) {
		            cartSeq = Integer.parseInt(cartSeqStr);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    System.out.println("cusSeq" + cusSeq);
		    System.out.println("cartSeq" + cartSeq);

	        // totalCartPrice 메소드 호출
		 	cartDAO cartDao = new cartDAO();
	        int totalPrice = cartDao.totalCartPrice(cusSeq);
	        System.out.println("totalPrice: " + totalPrice); // 디버깅 메시지 추가
	
	        // 클라이언트에게 JSON 형식의 응답 보내기
	        JSONObject jsonResponse = new JSONObject();
	        jsonResponse.put("totalPrice", totalPrice);
	
	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        PrintWriter out = response.getWriter();
	        out.print(jsonResponse.toString());
	        out.flush();
	        out.close(); // 리소스 해제
		}
	}
}
