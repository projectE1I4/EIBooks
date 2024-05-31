package eibooks.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

import eibooks.common.PageDTO;
import eibooks.dao.BookDAO;
import eibooks.dao.OrderDAO;
import eibooks.dao.OrderQnaDAO;
import eibooks.dao.QnaDAO;
import eibooks.dto.BookDTO;
import eibooks.dto.OrderDTO;
import eibooks.dto.OrderQnaDTO;
import eibooks.dto.QnaDTO;

@WebServlet("*.oq")
public class OrderQnaController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public OrderQnaController() {
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
		
		if(action.equals("/qnaList.oq")) {
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
			
			OrderQnaDTO dto = new OrderQnaDTO();
			dto.setCus_seq(cus_seq);
            
			OrderQnaDAO dao = new OrderQnaDAO();
            List<OrderQnaDTO> qnaList = dao.getQnaList(map);
            int totalCount = dao.selectCount(dto);
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
            request.setAttribute("state", state);

            // forward
            String path = "./qnaList.jsp"; // 전체 주문 목록 페이지의 JSP 파일 경로
            request.getRequestDispatcher(path).forward(request, response);
            
		} else if(action.equals("/qnaWrite.oq")) {
			// 값 받기
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			OrderDTO dto = new OrderDTO();
			dto.setCus_seq(cus_seq);
			OrderQnaDAO dao = new OrderQnaDAO();
			List<OrderDTO> orderList = dao.getOrderList(dto);
			
			request.setAttribute("orderList", orderList);
			
			// forward
			String path = "./qnaWrite.jsp";
			request.getRequestDispatcher(path).forward(request, response);
			
		} else if(action.equals("/qnaWriteProc.oq")) {
			
			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");
			
			String saveDirectory = "C:/Mid/jspws/EIBooks/src/main/webapp/Uploads";
			String encoding = "UTF-8";
			int maxPostSize = 1024 * 1000 * 10; // 1000kb -> 1M > 10M

			MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

			String imageFile = "";
			if(mr.getFilesystemName("imageFile") != null) {
				imageFile = mr.getFilesystemName("imageFile");
				String ext = imageFile.substring(imageFile.lastIndexOf("."));
				String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
				imageFile = now + ext;
				
				File file = new File(saveDirectory + File.separator + imageFile);
				mr.getFile("imageFile").renameTo(file);
				
				imageFile = "/EIBooks/Uploads/" + imageFile;
			}
			
			String sBook_seq = mr.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);
			String sPur_seq = mr.getParameter("pur_seq");
			int pur_seq = Integer.parseInt(sPur_seq);
			String sPur_i_seq = mr.getParameter("pur_i_seq");
			int pur_i_seq = Integer.parseInt(sPur_i_seq);
			String title = mr.getParameter("title");
			String type = mr.getParameter("type");
			String content = mr.getParameter("content");
			
			OrderQnaDTO dto = new OrderQnaDTO(cus_seq, book_seq, pur_seq, pur_i_seq, type, title, content, imageFile);
			
			OrderQnaDAO dao = new OrderQnaDAO();
			dao.insertOrderQna(dto);
			
			//qna
			Map<String, String> map = new HashMap<>();
				
			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset + "");
			map.put("amount", amount + "");
			map.put("cus_seq", cus_seq + "");
			
			OrderQnaDTO oDto = new OrderQnaDTO();
			oDto.setCus_seq(cus_seq);
            
			OrderQnaDAO oDao = new OrderQnaDAO();
            List<OrderQnaDTO> qnaList = oDao.getQnaList(map);
            int totalCount = oDao.selectCount(oDto);
            
            // Paging
 			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
         			
            request.setAttribute("qnaList", qnaList);
            request.setAttribute("paging", paging);
            
			// forward
            String path = "/EIBooks/orderQna/qnaList.oq";
            response.sendRedirect(path);
			
		} else if(action.equals("/deleteProc.oq")) {

			HttpSession session = request.getSession();
			int cus_seq = (int)session.getAttribute("cus_seq");

			String sPur_q_seq = request.getParameter("pur_q_seq");
			int pur_q_seq = Integer.parseInt(sPur_q_seq);
			
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

			OrderQnaDTO dto = new OrderQnaDTO();
			dto.setCus_seq(cus_seq);
			
			OrderQnaDAO dao = new OrderQnaDAO();
			List<OrderQnaDTO> qnaList = dao.getQnaList(map);
			int totalCount = dao.selectCount(dto);
			
			// paging DTO
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			// 리뷰 delete dao
			OrderQnaDTO dDto = new OrderQnaDTO();
			dDto.setPur_q_seq(pur_q_seq);
			dao.deleteWrite(dDto);

			request.setAttribute("qnaList", qnaList);
			request.setAttribute("paging", paging);

			String path = "/EIBooks/orderQna/qnaList.oq";
			response.sendRedirect(path);
			
		}
	}

}
