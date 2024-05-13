package eibooks.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
            int cusSeq = 1; // 임시로 회원 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
            
            // 장바구니에 담긴 책 목록 조회
            cartDAO cartDao = new cartDAO();
            List<cartDTO> cartList = cartDao.getCartList(cusSeq);
            
            // 장바구니에 담긴 각 책의 정보를 가져오기
            BookDAO bookDao = new BookDAO();
            for (cartDTO cartItem : cartList) {
                int bookSeq = cartItem.getBookSeq();
                BookDTO bookInfo = bookDao.getBookInfo(bookSeq);
                cartItem.setBookInfo(bookInfo);
            }

            // 장바구니 페이지로 전달할 데이터 설정
            request.setAttribute("cartList", cartList);

            // forward
            String path = "./customerCart.jsp"; // 장바구니 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
        }
    }
}
