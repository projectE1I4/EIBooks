package eibooks.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import eibooks.common.PageDTO;
import eibooks.dao.BookDAO;
import eibooks.dto.BookDTO;

// ~.bo로 끝나는 경우 여기서 처리함
@WebServlet("*.bo")
public class BookController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BookController() {
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
		
		if(action.equals("/bookList.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")			
			// action에 저장한 값 bookList.bo가 출력되는지 확인
			System.out.println(action);

			// searchField에 대해서 파라메터 받아옴, searchWord에 대해서 파라메터 받아옴
			String searchField = request.getParameter("searchField");
			String searchWord = request.getParameter("searchWord");
			

			// Map을 통해서 searchField와 searchWord 처리
			Map<String, String> map = new HashMap<>();
			map.put("searchField", searchField);
			map.put("searchWord", searchWord);
			

			// paging info
			// paging 정보 10개씩 1페이지
			int amount = 10;
			int pageNum = 1;
			
			// pageNum에 대해서 sPageNum으로 파라메터로 받아오기 (문자열로 들어옴)
			String sPageNum = request.getParameter("pageNum");
			// sPageNum이 null이 아닌 경우 Integer로 변환
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			// offset은 (pageNum-1) * amount
			int offset = (pageNum-1) * amount;

			// map에 offset 집어넣기
			map.put("offset", offset+"");
			// map에 amount 집어넣기
			map.put("amount", amount+"");
			
			// BookDAO 가져옴
			BookDAO dao = new BookDAO();
			
			List<BookDTO> bookList = dao.selectPageList(map);
			int totalCount = dao.selectCount(map);

			// Paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("bookList", bookList);
			request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);

			// forward
			String path =  "./bookList.jsp"; // 1
			request.getRequestDispatcher(path).forward(request, response);
		}
		
		// 유저 북 리스트
		else if(action.equals("/userBookList.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")			
			// action에 저장한 값 bookList.bo가 출력되는지 확인
			System.out.println(action);
			
			// searchField에 대해서 파라메터 받아옴, searchWord에 대해서 파라메터 받아옴
			String searchWord = request.getParameter("searchWord");
			// 여기 카테고리가 검색 시 null이 들어옴
			// 이놈이 지금 category 값을 못 가져오는 중임...
			String category = request.getParameter("category");
			String list = request.getParameter("list");
			System.out.println("가져오자마자 userBookList - category Word:" + category);
			System.out.println("가져오자마자 userBookList - list Word:" + list);
			
			if (searchWord == null || searchWord.trim().equals("")) {
				searchWord = "";
			}
			
			if (category == null) {
				category = "";
				System.out.println("check_category: " + category);
			}
			
			if (list == null) {
				list = "latest";
				System.out.println("check_list: " + list);
			}

			request.setAttribute("searchWord", searchWord);
			request.setAttribute("category", category);
			request.setAttribute("list", list);
						
			// Map을 통해서 검색 처리
			Map<String, String> map = new HashMap<>();
			// searchWord로 보냄
			map.put("searchWord", searchWord);
			// category를 보냄
			map.put("category", category);
			map.put("list", list);
			
			// paging info
			// paging 정보 10개씩 1페이지
			int amount = 10;
			int pageNum = 1;
			
			// pageNum에 대해서 sPageNum으로 파라메터로 받아오기 (문자열로 들어옴)
			String sPageNum = request.getParameter("pageNum");
			// sPageNum이 null이 아닌 경우 Integer로 변환
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			// offset은 (pageNum-1) * amount
			int offset = (pageNum-1) * amount;
			
			// map에 offset 집어넣기
			map.put("offset", offset+"");
			// map에 amount 집어넣기
			map.put("amount", amount+"");
			
			// BookDAO 가져옴
			BookDAO dao = new BookDAO();
			
			List<BookDTO> bookList = dao.userSelectPageList(map);
			int totalCount = dao.userSelectCount(map);
			
			// Paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("bookList", bookList);
			request.setAttribute("paging", paging); 
			request.setAttribute("totalCount", totalCount);
			
			// forward
			request.getRequestDispatcher("./userBookList.jsp").forward(request, response);		
		}
		else if(action.equals("/userBookDetail.bo")) {
			System.out.println(action);
			
			request.setCharacterEncoding("utf-8");
			int book_seq = Integer.parseInt(request.getParameter("book_seq"));
			
			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>> : " + book_seq);
			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);

			BookDAO dao = new BookDAO();
			dto = dao.getBook(dto);
			
			request.setAttribute("dto", dto);
						
			request.getRequestDispatcher("./userBookDetail.jsp").forward(request, response);
		}
	}
}
