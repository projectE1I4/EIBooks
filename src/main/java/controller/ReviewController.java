package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.PageDTO;
import dao.ReviewDAO;
import dto.ReviewDTO;

@WebServlet("*.do")
public class ReviewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
	
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doProcess");
		request.setCharacterEncoding("utf-8"); // 한글 처리
		
		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		System.out.println(uri);
		
		if(action.equals("/reviewList.do")) {
			System.out.println(action);
			
			String orderBy = request.getParameter("orderBy");
			System.out.println("controller로 넘어온 order 값:" + orderBy);
			
			Map<String, String> map = new HashMap<>();
			
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(map);
			int totalCount = dao.selectCount();
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			
			String path = "./reviewList.jsp";
			request.getRequestDispatcher(path).forward(request, response);
		}
	}

}
