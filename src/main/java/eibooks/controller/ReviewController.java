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
import javax.servlet.http.HttpSession;

import eibooks.common.PageDTO;
import eibooks.dao.OrderDAO;
import eibooks.dao.ReviewDAO;
import eibooks.dto.OrderDTO;
import eibooks.dto.ReviewDTO;

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
			
			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			
			String sPur_seq = request.getParameter("pur_seq");
			int pur_seq = 0;
			if(sPur_seq != null) {
				pur_seq = Integer.parseInt(sPur_seq);
			}
			String sPur_i_seq = request.getParameter("pur_i_seq");
			int pur_i_seq = 0;
			if(sPur_i_seq != null) {
				pur_i_seq = Integer.parseInt(sPur_i_seq);
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
			map.put("orderBy", orderBy);
			
			// DTO
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(Integer.parseInt(bookNum));
			dto.setPur_i_seq(pur_i_seq);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			ReviewDTO myReview = new ReviewDTO();
			if (bookNum != null && userNum != 0) {
				myReview.setPur_i_seq(pur_i_seq);
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
			String path = "";
			if (sPur_seq != null) {
				path = "./reviewList.jsp?" + "bookNum=" + bookNum + "&pur_seq=" + pur_seq + "&pur_i_seq=" + pur_i_seq;
			} else {
				path = "./reviewList.jsp?" + "bookNum=" + bookNum;
			}
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWrite.do")) {
			// 값 받기
			String orderBy = request.getParameter("orderBy");
			String bookNum = request.getParameter("bookNum");
			
			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			
			String sPur_seq = request.getParameter("pur_seq");
			int pur_seq = Integer.parseInt(sPur_seq);
			String sPur_i_seq = request.getParameter("pur_i_seq");
			int pur_i_seq = Integer.parseInt(sPur_i_seq);
			
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
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(Integer.parseInt(bookNum));
			dto.setPur_i_seq(pur_i_seq);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setPur_i_seq(pur_i_seq);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("reviewCount", reviewCount);
			request.setAttribute("myReview", myReview);
			
			// forward
			String path = "/review/reviewWrite.jsp?" + "bookNum=" + bookNum + "&pur_seq=" + pur_seq + "&pur_i_seq=" + pur_i_seq;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewWriteProc.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);

			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			
			String sPur_seq = request.getParameter("pur_seq");
			int pur_seq = Integer.parseInt(sPur_seq);
			String sPur_i_seq = request.getParameter("pur_i_seq");
			int pur_i_seq = Integer.parseInt(sPur_i_seq);
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			String orderBy = request.getParameter("orderBy");
			
			// DTO
            ReviewDTO rDto = new ReviewDTO(bookNum, userNum, pur_seq, pur_i_seq, grade, content);
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
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(bookNum);
			dto.setPur_i_seq(pur_i_seq);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			int reviewCount = dao.reviewCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setPur_i_seq(pur_i_seq);
			myReview = dao.selectView(myReview);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("reviewCount", reviewCount);
			request.setAttribute("myReview", myReview);
            
			// forward
            String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum  + "&pur_seq=" + pur_seq + "&pur_i_seq=" + pur_i_seq;
            response.sendRedirect(path);
		} else if(action.equals("/reviewUpdate.do")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);
			
			String sPur_i_seq = request.getParameter("pur_i_seq");
			int pur_i_seq = Integer.parseInt(sPur_i_seq);
			System.out.println("pur_Ikslfjdkj   " + pur_i_seq);
			

			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			
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
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(bookNum);
			
			// DAO
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// reviewNum 가져오기
			//*
			ReviewDTO myReview = new ReviewDTO();
			OrderDTO oDto = new OrderDTO();
			OrderDAO oDao = new OrderDAO();
			myReview.setPur_i_seq(pur_i_seq);
			myReview = dao.selectView(myReview);
			System.out.println("akdlfbqljdkjfslkdfjlsd     "+myReview);
			/**/
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("myReview", myReview);
			
			// forward
			String path = "./reviewUpdate.jsp?" + "bookNum=" + bookNum  + "&pur_i_seq" + pur_i_seq + "&reviewNum=" + reviewNum;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/reviewUpdateProc.do")) {
			
			request.setCharacterEncoding("utf-8");
			
			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(sBookNum);

			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			/*
			String sPur_seq = request.getParameter("pur_seq");
			int pur_seq = Integer.parseInt(sPur_seq);
			/**/
			String sPur_i_seq = request.getParameter("pur_i_seq");
			int pur_i_seq = Integer.parseInt(sPur_i_seq);
			
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			
			int grade = Integer.parseInt(request.getParameter("grade"));
			String content = request.getParameter("content");
			
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
			
			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(bookNum);
			dto.setUserNum(userNum);
			
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 업데이트 dao
			ReviewDTO uDto = new ReviewDTO();
			uDto.setGrade(grade);
			uDto.setContent(content);
			uDto.setReviewNum(reviewNum);
			dao.updateWrite(uDto);
			
			// reviewNum 가져오기
			ReviewDTO myReview = new ReviewDTO();
			myReview.setPur_i_seq(pur_i_seq);
			myReview = dao.selectView(myReview);
			
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("myReview", myReview);
            
            String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum;
            response.sendRedirect(path);
		}else if(action.equals("/reviewDeleteProc.do")) {
			request.setCharacterEncoding("utf-8");

			String sBookNum = request.getParameter("bookNum");
			int bookNum = Integer.parseInt(request.getParameter("bookNum"));

			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");

			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);
			
			Map<String, String> map = new HashMap<>();

			// paging info
			int amount = 5;
			int pageNum = 1;

			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset+"");
			map.put("amount", amount+"");

			ReviewDTO dto = new ReviewDTO();
			dto.setBookNum(bookNum);
			
			ReviewDAO dao = new ReviewDAO();
			List<ReviewDTO> reviewList = dao.selectList(dto, map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 delete dao
			ReviewDTO dDto = new ReviewDTO();
			dDto.setReviewNum(reviewNum);
			dao.deleteWrite(dDto);
			dao.deleteReply(dDto);

			request.setAttribute("reviewList", reviewList);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("paging", paging);

			String path = "/EIBooks/review/reviewList.do?" + "bookNum=" + bookNum;
			response.sendRedirect(path);
			
		} else if(action.equals("/replyList.do")) {
			System.out.println(action);
			
			// 값 받기
			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");

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
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, allReviewCount);
			
			// request - setAtt
			request.setAttribute("reviewList", reviewList);
			request.setAttribute("paging", paging);
			request.setAttribute("allReviewCount", allReviewCount);
			
			// forward
			String path = "./replyList.jsp?";
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/depthOneDeleteProc.do")) {
			request.setCharacterEncoding("utf-8");

			HttpSession session = request.getSession();
			int userNum = (int)session.getAttribute("cus_seq");
			
			String sReviewNum = request.getParameter("reviewNum");
			int reviewNum = Integer.parseInt(sReviewNum);

			ReviewDAO dao = new ReviewDAO();
			
			// 리뷰 delete dao
			ReviewDTO dto = new ReviewDTO();
			dto.setReviewNum(reviewNum);
			dao.deleteWrite(dto);
			dao.deleteReply(dto);
			
			String path = "/EIBooks/review/replyList.do?userNum=" + userNum;
			response.sendRedirect(path);
			
		} 
	}

}
