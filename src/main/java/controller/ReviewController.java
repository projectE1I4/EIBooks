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
			
			String userId = request.getParameter("userId");
			System.out.println("controller로 넘어온 userId 값:" + userId);
			
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
			if (userId != null) dto.setUserId(userId);
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("userId", userId);
			
			String path = "./reviewList.jsp?" + "userId=" + userId;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWrite.do")) {
			String orderBy = request.getParameter("orderBy");
			System.out.println("controller로 넘어온 order 값:" + orderBy);
			
			String bookNum = request.getParameter("bookNum");
			System.out.println("controller로 넘어온 bookNum 값:" + bookNum);
			
			String userId = request.getParameter("userId");
			System.out.println("controller로 넘어온 userId 값:" + userId);
			
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
			if (userId != null) dto.setUserId(userId);
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("userId", userId);
			request.setAttribute("reviewCount", reviewCount);
			
			String path = "./reviewWrite.jsp?" + "bookNum=" + bookNum  + "&userId=" + userId;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWriteProc.do")) {
			
			request.setCharacterEncoding("utf-8");
			
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			int userNum = 1;
			String userId = "admin";
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			
			// 임시로 회원,도서 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
            ReviewDTO rDto = new ReviewDTO(bookNum, userNum, grade, userId, userId, content);
            ReviewDAO rDao = new ReviewDAO();
            rDao.insertWrite(rDto);
            
            String orderBy = request.getParameter("orderBy");
			
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
			if (sBookNum != null) dto.setBookNum(bookNum);
			if (userId != null) dto.setUserId(userId);
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("userId", userId);
			request.setAttribute("reviewCount", reviewCount);
            
            String path = "/EIBooks/review/reviewWrite.do?" + "bookNum=" + bookNum  + "&userId=" + userId;
            response.sendRedirect(path);
		} else if(action.equals("/reviewUpdate.do")) {
			String orderBy = request.getParameter("orderBy");
			System.out.println("controller로 넘어온 order 값:" + orderBy);
			
			String bookNum = request.getParameter("bookNum");
			System.out.println("controller로 넘어온 bookNum 값:" + bookNum);
			
			String userId = request.getParameter("userId");
			System.out.println("controller로 넘어온 userId 값:" + userId);
			
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
			if (userId != null) dto.setUserId(userId);
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
//			int rs = dao.updateWrite(dto);
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("userId", userId);
			
			String path = "./reviewUpdate.jsp?" + "bookNum=" + bookNum  + "&userId=" + userId;
			request.getRequestDispatcher(path).forward(request, response);
		} else if(action.equals("/reviewUpdateProc.do")) {
			
			request.setCharacterEncoding("utf-8");
			
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			int userNum = 1;
			String userId = "admin";
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			
			// 임시로 회원,도서 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
            ReviewDTO rDto = new ReviewDTO(bookNum, userNum, grade, userId, userId, content);
            ReviewDAO rDao = new ReviewDAO();
//            int rs = rDao.updateWrite(rDto);
            
            String orderBy = request.getParameter("orderBy");
			
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
			if (sBookNum != null) dto.setBookNum(bookNum);
			if (userId != null) dto.setUserId(userId);
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("userId", userId);
            
            String path = "/EIBooks/review/reviewWrite.do?" + "bookNum=" + bookNum  + "&userId=" + userId;
            response.sendRedirect(path);
		}
	}

}
