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
import eibooks.dao.BookDAO;
import eibooks.dao.QnaDAO;
import eibooks.dao.ReviewDAO;
import eibooks.dto.BookDTO;
import eibooks.dto.QnaDTO;
import eibooks.dto.ReviewDTO;

@WebServlet("*.qq")
public class QnaController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public QnaController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProcess(request, response);
	}
	
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8"); // 한글처리

		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		
		if(action.equals("/qnaList.qq")) {
			Map<String, String> map = new HashMap<>();
			
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String state = request.getParameter("state");
			map.put("state", state);
				
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			map.put("cus_seq", cus_seq + "");
			
			QnaDTO dto = new QnaDTO();
			dto.setCus_seq(cus_seq);
            
			QnaDAO dao = new QnaDAO();
            List<QnaDTO> qnaList = dao.getQnaList(map);
            int totalCount = dao.selectCount(dto);
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
            request.setAttribute("state", state);

            // forward
            String path = "./qnaList.jsp"; // 전체 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/deleteProc.qq")) {
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");

			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
			Map<String, String> map = new HashMap<>();

			// paging info
			int amount = 10;
			int pageNum = 1;

			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset+"");
			map.put("amount", amount+"");
			map.put("cus_seq", cus_seq + "");

			QnaDTO dto = new QnaDTO();
			dto.setBook_seq(book_seq);
			
			QnaDAO dao = new QnaDAO();
			List<QnaDTO> qnaList = dao.getQnaList(map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 delete dao
			QnaDTO dDto = new QnaDTO();
			dDto.setQna_seq(qna_seq);
			dao.deleteWrite(dDto);

			request.setAttribute("qnaList", qnaList);
			request.setAttribute("paging", paging);

			String path = "/EIBooks/qna/qnaList.qq";
			response.sendRedirect(path);
			
		} else if(action.equals("/reply.qq")) {
			Map<String, String> map = new HashMap<>();
			
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String state = request.getParameter("state");
			map.put("state", state);
				
			// paging info
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			
			QnaDTO dto = new QnaDTO();
			QnaDAO dao = new QnaDAO();
            List<QnaDTO> qnaList = dao.getQnaAllList(map);
            int totalCount = dao.selectAllCount();
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
            request.setAttribute("state", state);

            // forward
            String path = "./reply.jsp"; // 전체 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/replyWrite.qq")) {
			// 값 받기
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
			// 페이징
			int amount = 5;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;
			
			Map<String, String> map = new HashMap<>();
			
			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			QnaDAO dao = new QnaDAO();
            List<QnaDTO> qnaList = dao.getQnaAllList(map);
            int totalCount = dao.selectAllCount();
			
			// paging DTO
            PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// request - setAtt
			request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
			
			// forward
			String path = "./replyWrite.jsp?book_seq=" + book_seq + "&qna_seq=" + qna_seq;
			request.getRequestDispatcher(path).forward(request, response);
			
		}  else if(action.equals("/replyWriteProc.qq")) {
			
			// 값 받기
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
			// 폼 값
			String content = request.getParameter("content");
			
			// DTO
			QnaDTO dto = new QnaDTO(book_seq, cus_seq, content);
			dto.setRef_seq(qna_seq);
			QnaDAO dao = new QnaDAO();
            dao.insertReply(dto);
            
            QnaDTO qDto = new QnaDTO();
            qDto.setQna_seq(qna_seq);
            qDto.setState("답변완료");
            dao.updateState(qDto);
            
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
			List<QnaDTO> qnaList = dao.getQnaAllList(map);
			int totalCount = dao.selectAllCount();
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// request - setAtt
			request.setAttribute("qnaList", qnaList);
			request.setAttribute("paging", paging);
            
			// forward
            String path = "/EIBooks/qna/reply.qq";
            response.sendRedirect(path);
            
		} else if(action.equals("/replyUpdate.qq")) {
			// 값 받기
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
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
			QnaDAO dao = new QnaDAO();
			List<QnaDTO> qnaList = dao.getQnaAllList(map);
			int totalCount = dao.selectAllCount();
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// request - setAtt
			request.setAttribute("qnaList", qnaList);
			request.setAttribute("paging", paging);
			
			// forward
			String path = "./replyUpdate.jsp?qna_seq=" + qna_seq;
			request.getRequestDispatcher(path).forward(request, response);
			
		}  else if(action.equals("/replyUpdateProc.qq")) {
			request.setCharacterEncoding("utf-8"); // 한글 처리
			
			// 값 받기
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");

			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
			// 폼 값
			String content = request.getParameter("content");
			
			// DTO
			QnaDTO dto = new QnaDTO();
			dto.setContent(content);
			dto.setQna_seq(qna_seq);
			
			QnaDAO dao = new QnaDAO();
			dao.updateReply(dto);
			
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
			List<QnaDTO> qnaList = dao.getQnaAllList(map);
			int totalCount = dao.selectAllCount();
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// request - setAtt
			request.setAttribute("qnaList", qnaList);
			request.setAttribute("paging", paging);
            
			// forward
            String path = "/EIBooks/qna/reply.qq";
            response.sendRedirect(path);
            
		}  else if(action.equals("/replyDeleteProc.qq")) {
			request.setCharacterEncoding("utf-8");

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);
			
			String sRef_seq = request.getParameter("ref_seq");
			int ref_seq = Integer.parseInt(sRef_seq);
			
			// 회원의 처리 상태 변경
			QnaDTO dto = new QnaDTO();
			dto.setQna_seq(ref_seq);
			dto.setState("답변대기");
			
			QnaDAO dao = new QnaDAO();
			dao.updateState(dto);
			
			// 관리자 댓글 삭제
			dto.setQna_seq(qna_seq);
			dao.deleteWrite(dto);
			
			String path = "/EIBooks/qna/reply.qq";
			response.sendRedirect(path);
			
		}  else if(action.equals("/depthOneDeleteProc.qq")) {
			request.setCharacterEncoding("utf-8");

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			// 회원의 문의 번호
			String sQna_seq = request.getParameter("qna_seq");
			int qna_seq = Integer.parseInt(sQna_seq);

			QnaDTO dto = new QnaDTO();
			dto.setQna_seq(qna_seq);
			
			QnaDAO dao = new QnaDAO();
			dao.deleteWrite(dto);
			
			String path = "/EIBooks/qna/reply.qq";
			response.sendRedirect(path);
			
		} else if(action.equals("/qnaWrite.qq")) {
			// 값 받기
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			Map<String, String> map = new HashMap<>();
			
			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);
			BookDAO dao = new BookDAO();
			BookDTO book = dao.getBook(dto);

			request.setAttribute("book", book);
			
			// forward
			String path = "./qnaWrite.jsp?book_seq=" + book_seq;
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/qnaWriteProc.qq")) {
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);
			
			String type = request.getParameter("type");
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			String protect_YN = request.getParameter("protect_YN");
			if (protect_YN == null) {
				protect_YN = "N";
			}
			
			QnaDTO dto = new QnaDTO(book_seq, cus_seq, type, title, content, protect_YN);
			QnaDAO dao = new QnaDAO();
			dao.insertQna(dto);
			
			//qna
			Map<String, String> map = new HashMap<>();
			
			map.put("protect_YN", protect_YN);
				
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			map.put("book_seq", book_seq + "");
			
			QnaDTO qDto = new QnaDTO();
			qDto.setBook_seq(book_seq);
            
			QnaDAO qDao = new QnaDAO();
            List<QnaDTO> qnaList = qDao.getQnaAllListNew(map);
            int totalCount = qDao.selectCount(qDto);
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
            
			// forward
            String path = "/EIBooks/user/userBookDetail.bo?book_seq=" + book_seq;
            response.sendRedirect(path);
			
		}
	}

}
