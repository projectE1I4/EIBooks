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
			
			String bookNum = request.getParameter("bookNum");
			System.out.println("controller로 넘어온 bookNum 값:" + bookNum);
			
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
			
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (bookNum != null) dto.setBookNum(Integer.parseInt(bookNum));
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount();
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			
			String path = "./reviewList.jsp";
			request.getRequestDispatcher(path).forward(request, response);
		}else if(action.equals("/reviewWrite.do")) {
			String path = "./reviewWrite.do";
			request.getRequestDispatcher(path).forward(request, response);
		}else if(action.equals("/reviewWriteProc.do")) {
			request.setCharacterEncoding("utf-8");
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			int bookNum = Integer.parseInt(request.getParameter("bookNum"));
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			
			System.out.println("userNum:" + userNum);
			System.out.println("bookNum:" + bookNum);
			System.out.println("grade:" + grade);
			System.out.println("content" + content);
			
			// 임시로 회원,도서 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
            
			ReviewDTO dto = new ReviewDTO(userNum, bookNum, grade, content);
            
            ReviewDAO dao = new ReviewDAO();
            dao.insertWrite(dto);
            
            String path = request.getContextPath() + "./reviewWrite.do";
            response.sendRedirect(path);
		}
	}

}
