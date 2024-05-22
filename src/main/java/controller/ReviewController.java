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
			
			// 값 받기
			String orderBy = request.getParameter("orderBy");
			String bookNum = request.getParameter("bookNum");
			String sUserNum = request.getParameter("userNum");
			int userNum = 0;
			if (sUserNum != null) {
				userNum = Integer.parseInt(sUserNum);
			}
			
			// 받아온 값 확인하기
			System.out.println("orderBy 값:" + orderBy);
			System.out.println("bookNum 값:" + bookNum);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			// DTO
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (bookNum != null) dto.setBookNum(Integer.parseInt(bookNum));
			dto.setUserNum(userNum);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			ReviewDTO myReview = new ReviewDTO();
			if (bookNum != null && userNum != 0) {
				myReview.setBookNum(Integer.parseInt(bookNum));
				myReview.setUserNum(userNum);
				myReview = dao.selectView(myReview);
				request.setAttribute("myReview", myReview);
			}
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			
			// forward
			String path = "./reviewList.jsp?" + "userNum=" + userNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWrite.do")) {
			// 값 받기
			String orderBy = request.getParameter("orderBy");
			String bookNum = request.getParameter("bookNum");
			String sUserNum = request.getParameter("userNum");
			int userNum = Integer.parseInt(sUserNum);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			// DTO
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (bookNum != null) dto.setBookNum(Integer.parseInt(bookNum));
			dto.setUserNum(userNum);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(Integer.parseInt(bookNum));
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("reviewCount", reviewCount);
			request.setAttribute("myReview", myReview);
			
			// forward
			String path = "./reviewWrite.jsp?" + "bookNum=" + bookNum  + "&userNum=" + userNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWriteProc.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			int userNum = Integer.parseInt(request.getParameter("userNum")); // 임시로 회원번호 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			String orderBy = request.getParameter("orderBy");
			
			// DTO
            ReviewDTO rDto = new ReviewDTO(bookNum, userNum, grade, content);
            ReviewDAO rDao = new ReviewDAO();
            rDao.insertWrite(rDto);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			// DTO
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (sBookNum != null) dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(bookNum);
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("reviewCount", reviewCount);
			request.setAttribute("myReview", myReview);
            
			// forward
            String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum  + "&userNum=" + userNum;
            response.sendRedirect(path);
		} else if(action.equals("/reviewUpdate.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			String sUserNum = request.getParameter("userNum");
			int userNum = Integer.parseInt(sUserNum);
			String orderBy = request.getParameter("orderBy");
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			// DTO
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (sBookNum != null) dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			if (sReviewNum != null) dto.setReviewNum(reviewNum);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(bookNum);
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("myReview", myReview);
			
			// forward
			String path = "./reviewUpdate.jsp?" + "bookNum=" + bookNum  + "&userNum=" + userNum +"&reviewNum=" + reviewNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewUpdateProc.do")) {
			
			request.setCharacterEncoding("utf-8");
			
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			
			// 임시로 회원,도서 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
            ReviewDTO rDto = new ReviewDTO();
            rDto.setBookNum(bookNum);
            rDto.setUserNum(userNum);
            rDto.setGrade(grade);
            rDto.setContent(content);
            
            ReviewDAO rDao = new ReviewDAO();
            
            String orderBy = request.getParameter("orderBy");
			
			Map<String, String> map = new HashMap<>();
			
			// paging info
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("orderBy", orderBy);
			
			ReviewDTO dto = new ReviewDTO(pageNum, offset, uri, orderBy, sPageNum);
			if (sBookNum != null) dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 업데이트 dao
			ReviewDTO uDto = new ReviewDTO();
			uDto.setBookNum(bookNum);
			uDto.setReviewNum(reviewNum);
			uDto.setGrade(grade);
			uDto.setContent(content);
			uDto.setUserNum(userNum);
			dao.updateWrite(uDto);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(bookNum);
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("myReview", myReview);
            
            String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum  + "&userNum=" + userNum;
            response.sendRedirect(path);
		}else if(action.equals("/reviewDeleteProc.do")) {
			request.setCharacterEncoding("utf-8");

			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(request.getParameter("bookNum"));
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);

			// 임시로 회원,도서 번호를 지정, 실제로는 세션 등을 통해 로그인한 사용자의 정보를 가져와야 함
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			
			ReviewDAO rDao = new ReviewDAO();

			Map<String, String> map = new HashMap<>();

			// paging info
			int amount = 5;
			int pageNum = 1;

			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset+"");
			map.put("amount", amount+"");

			if (sBookNum != null) dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 delete dao
			ReviewDTO dDto = new ReviewDTO();
			dDto.setBookNum(bookNum);
			dDto.setReviewNum(reviewNum);
			dDto.setUserNum(userNum);
			int deleteReview = dao.deleteWrite(dDto);
			

			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(bookNum);
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);

			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", sReviewNum);
			request.setAttribute("myReview", myReview);

			String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum  + "&userNum=" + userNum;
			response.sendRedirect(path);
			
		} else if(action.equals("/replyList.do")) {
			System.out.println(action);
			
			// 값 받기
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = 0;
			if (sReviewNum != null) {
				reviewNum = Integer.parseInt(sReviewNum);
			}
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectAllList(map);
			int allReviewCount = dao.allReviewCount();
			
			ReviewDTO myReview = new ReviewDTO();
			if(sReviewNum != null) {
				myReview.setReviewNum(reviewNum);
				myReview = dao.selectReplyView(myReview);
				request.setAttribute("myReview", myReview);
			}
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("allReviewCount", allReviewCount);
			
			// forward
			String path = "./replyList.jsp?";
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/replyWrite.do")) {
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = 0;
			if (sBookNum != null) {
				bookNum = Integer.parseInt(sBookNum);
			}
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectAllList(map);
			int allReviewCount = dao.allReviewCount();
			
			// re_seq당 하나의 답댓만 달 수 있게 해야 함(cnt)
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setUserId("admin");
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("myReview", myReview);
			request.setAttribute("allReviewCount", allReviewCount);
			
			// forward
			String path = "./replyWrite.jsp?bookNum=" + bookNum + "&userNum=" + userNum + "&reviewNum=" + reviewNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/replyWriteProc.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			// 회원 리뷰 넘버
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			// 폼 값
			String content = request.getParameter("content");
			
			// DTO
            ReviewDTO rDto = new ReviewDTO();
            rDto.setBookNum(bookNum);
            rDto.setUserNum(userNum);
            rDto.setContent(content);
            rDto.setRef_seq(reviewNum);
            ReviewDAO rDao = new ReviewDAO();
            rDao.insertReply(rDto);
            
            ReviewDTO uDto = new ReviewDTO();
            uDto.setReviewNum(reviewNum);
            ReviewDAO dao = new ReviewDAO();
            uDto.setRef_YN("Y");
            dao.updateRefYn(uDto);
            
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			// DAO
			List<ReviewDTO> reviewList = dao.selectAllList(map);
			int allReviewCount = dao.allReviewCount();
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setBookNum(bookNum);
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("bookNum", bookNum);
			request.setAttribute("myReview", myReview);
			request.setAttribute("allReviewCount", allReviewCount);
            
			// forward
            String path = "/EIBooks/review/replyList.do?userNum=" + userNum;
            response.sendRedirect(path);
		} else if(action.equals("/replyUpdate.do")) {
			// 값 받기
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectAllList(map);
			int allReviewCount = dao.allReviewCount();
			
			// re_seq당 하나의 답댓만 달 수 있게 해야 함(cnt)
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setUserId("admin");
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("myReview", myReview);
			request.setAttribute("allReviewCount", allReviewCount);
			
			// forward
			String path = "./replyUpdate.jsp?userNum=" + userNum + "&reviewNum=" + reviewNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/replyUpdateProc.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			// 폼 값
			String content = request.getParameter("content");
			
			// DTO
            ReviewDTO rDto = new ReviewDTO();
            rDto.setUserNum(userNum);
            rDto.setContent(content);
            rDto.setReviewNum(reviewNum);
            ReviewDAO rDao = new ReviewDAO();
            rDao.updateReply(rDto);
            
            ReviewDTO uDto = new ReviewDTO();
            uDto.setReviewNum(reviewNum);
            ReviewDAO dao = new ReviewDAO();
            uDto.setRef_YN("Y");
            dao.updateRefYn(uDto);
            
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			// DAO
			List<ReviewDTO> reviewList = dao.selectAllList(map);
			int allReviewCount = dao.allReviewCount();
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setUserNum(userNum);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("myReview", myReview);
			request.setAttribute("allReviewCount", allReviewCount);
            
			// forward
            String path = "/EIBooks/review/replyList.do?userNum=" + userNum;
            response.sendRedirect(path);
		} else if(action.equals("/replyDeleteProc.do")) {
			request.setCharacterEncoding("utf-8");

			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			int ref_seq = Integer.parseInt(request.getParameter("ref_seq"));
			
			ReviewDAO dao = new ReviewDAO();
			
			// 리뷰 delete dao
			ReviewDTO uDto = new ReviewDTO();
			uDto.setReviewNum(ref_seq);
			System.out.println("ref_seq"+ref_seq);
			uDto.setRef_YN("N");
			dao.updateRefYn(uDto);
			
			ReviewDTO dto = new ReviewDTO();
			dto.setReviewNum(reviewNum);
			dao.deleteReply(dto);
			
			String path = "/EIBooks/review/replyList.do?userNum=" + userNum;
			response.sendRedirect(path);
			
		}  else if(action.equals("/depthOneDeleteProc.do")) {
			request.setCharacterEncoding("utf-8");

			int userNum = Integer.parseInt(request.getParameter("userNum"));
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);

			ReviewDAO dao = new ReviewDAO();
			
			// 리뷰 delete dao
			ReviewDTO dto = new ReviewDTO();
			dto.setReviewNum(reviewNum);
			dto.setUserNum(userNum);
			dao.deleteReply(dto);
			
			String path = "/EIBooks/review/replyList.do?userNum=" + userNum;
			response.sendRedirect(path);
			
		} 
	}

}
