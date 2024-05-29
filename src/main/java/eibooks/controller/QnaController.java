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
import eibooks.dao.QnaDAO;
import eibooks.dao.ReviewDAO;
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
		System.out.println("doProcess");
		request.setCharacterEncoding("utf-8"); // 한글처리

		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		System.out.println(uri);
		
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
			int amount = 5;
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
		}
	}

}
