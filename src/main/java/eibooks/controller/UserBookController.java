package eibooks.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import eibooks.common.PageDTO;
import eibooks.dao.BookDAO;
import eibooks.dto.BookDTO;

@WebServlet("*.uapi")
public class UserBookController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UserBookController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doProcess_uapi");
		request.setCharacterEncoding("utf-8"); // 한글처리

		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		System.out.println(uri);

		// user 제품 목록 확인 리스트 처리
		 if(action.equals("/userSearch.uapi")) {
			int amount = 10;
			int pageNum = 1;

			BookDAO dao = new BookDAO();
			Map<String, String> map = new HashMap<>();

			// pageNum에 대해서 sPageNum으로 파라메터로 받아오기 (문자열로 들어옴)
			String sPageNum = request.getParameter("pageNum");
			String searchWord = request.getParameter("searchWord");
			String category = request.getParameter("category");
			
			//여기서도 검색 시 이미 빈문자
			System.out.println("userSearch.uapi-" + category);
			
			if (searchWord == null) {
				searchWord = "";
				// 여기까지 넘어옴 (사실상 출발지)
			}

			// sPageNum이 null이 아닌 경우 Integer로 변환
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			// offset은 (pageNum-1) * amount
			int offset = (pageNum-1) * amount;
			// map에 offset 집어넣기
			map.put("offset", offset+"");
			// map에 amount 집어넣기
			map.put("amount", amount+"");
			
			map.put("searchWord", searchWord);				
			map.put("category", category);				
			
			List<BookDTO> bookList = dao.userSelectPageList(map);
			int totalCount = dao.userSelectCount(map);
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);

			request.setAttribute("paging", paging); 
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("searchWord", searchWord);
			request.setAttribute("category", category);
			
			//json
			Gson gson = new Gson();
			String json = gson.toJson(bookList);
			System.out.println(json);

			response.setContentType("application/json; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.print(json);
		}
			else if(action.equals("/userCategory.uapi")) {
				int amount = 10;
				int pageNum = 1;

				BookDAO dao = new BookDAO();
				Map<String, String> map = new HashMap<>();

				// pageNum에 대해서 sPageNum으로 파라메터로 받아오기 (문자열로 들어옴)
				String sPageNum = request.getParameter("pageNum");
				String category  = request.getParameter("category");
				
				// sPageNum이 null이 아닌 경우 Integer로 변환
				if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
				// offset은 (pageNum-1) * amount
				int offset = (pageNum-1) * amount;
				// map에 offset 집어넣기
				map.put("offset", offset+"");
				// map에 amount 집어넣기
				map.put("amount", amount+"");
				map.put("category", category);

				int totalCount = dao.userSelectCount(map);
				PageDTO paging = new PageDTO(pageNum, amount, totalCount);

				request.setAttribute("paging", paging); 
				request.setAttribute("totalCount", totalCount);
				request.setAttribute("category", category);

				//json
				Gson gson = new Gson();
				String cate = gson.toJson(category);
				System.out.println(cate);

				response.setContentType("application/json; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.print(cate);
			}
		// 페이징을 별개로 빼봤음.
		else if(action.equals("/userPaging.uapi")) {
			int amount = 10;
			int pageNum = 1;

			BookDAO dao = new BookDAO();
			Map<String, String> map = new HashMap<>();

			// pageNum에 대해서 sPageNum으로 파라메터로 받아오기 (문자열로 들어옴)
			String sPageNum = request.getParameter("pageNum");
			String category  = request.getParameter("category");
			System.out.println("userPaging.uapi----"+category);
			
			// sPageNum이 null이 아닌 경우 Integer로 변환

			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			// offset은 (pageNum-1) * amount
			int offset = (pageNum-1) * amount;
			// map에 offset 집어넣기
			map.put("offset", offset+"");
			// map에 amount 집어넣기
			map.put("amount", amount+"");

			int totalCount = dao.userSelectCount(map);
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);

			request.setAttribute("paging", paging); 
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("category", category);
			
			//json
			Gson gson = new Gson();
			String page = gson.toJson(paging);
			System.out.println(page);

			response.setContentType("application/json; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.print(page);
		}

		
	}

}
