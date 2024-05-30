package eibooks.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.net.URLEncoder;
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
import eibooks.dao.CustomerDAO;
import eibooks.dao.QnaDAO;
import eibooks.dao.ReviewDAO;
import eibooks.dto.BookDTO;
import eibooks.dto.QnaDTO;
import eibooks.dto.ReviewDTO;

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

		String uri = request.getRequestURI();
		String action = uri.substring(uri.lastIndexOf("/"));
		System.out.println(uri);
		
		if(action.equals("/productList.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")			
			System.out.println(action);

			String searchField = request.getParameter("searchField");
			String searchWord = request.getParameter("searchWord");

			Map<String, String> map = new HashMap<>();
			map.put("searchField", searchField);
			map.put("searchWord", searchWord);

			// paging info
			int amount = 10;
			int pageNum = 1;
			
			String sPageNum = request.getParameter("pageNum");
			if(sPageNum != null) pageNum = Integer.parseInt(sPageNum);
			int offset = (pageNum-1) * amount;

			map.put("offset", offset+"");
			map.put("amount", amount+"");
			
			BookDAO dao = new BookDAO();
			
			List<BookDTO> bookList = dao.selectPageList(map);
			int totalCount = dao.selectCount(map);

			// Paging
			PageDTO paging = new PageDTO(pageNum, amount, totalCount);
			
			request.setAttribute("bookList", bookList);
			request.setAttribute("paging", paging);
			request.setAttribute("totalCount", totalCount);
			request.setAttribute("searchField", searchField);
			request.setAttribute("searchWord", searchWord);

			// forward
			String path =  "/admin/productList.jsp"; // 1
			request.getRequestDispatcher(path).forward(request, response);

		} else if(action.equals("/productView.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")
			System.out.println(action);

			request.setCharacterEncoding("utf-8");
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);
			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);

			BookDAO dao = new BookDAO();
			dto = dao.selectView(dto);

			request.setAttribute("dto", dto);

			//3. forward
			String path =  "/admin/productView.jsp"; // 1
			request.getRequestDispatcher(path).forward(request, response);

		} else if(action.equals("/writeProduct.bo")) {
			// move : get
			String path = request.getContextPath() + "/admin/insertProduct.jsp";
			response.sendRedirect(path);

		} else if(action.equals("/writeProductProc.bo")) {
			// 1. 값 받기
			request.setCharacterEncoding("utf-8");
			String saveDirectory = "C:/Mid/jspws/EIBooks/src/main/webapp/Uploads";
			String encoding = "UTF-8";
			int maxPostSize = 1024 * 1000 * 10; // 1000kb -> 1M > 10M

			MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

			String imageFile = mr.getFilesystemName("imageFile");
			String ext = imageFile.substring(imageFile.lastIndexOf("."));
			String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
			imageFile = now + ext;

			File file = new File(saveDirectory + File.separator + imageFile);
			mr.getFile("imageFile").renameTo(file);

			imageFile = "file:///C:/Mid/jspws/EIBooks/src/main/webapp/Uploads/" + imageFile;

			// 1. 값 받기
			String title = mr.getParameter("title");
			String author = mr.getParameter("author");
			String category = mr.getParameter("category");
			String sPrice = mr.getParameter("price");
			String publisher = mr.getParameter("publisher");
			String pubDate = mr.getParameter("pubDate");
			String isbn10 = mr.getParameter("isbn10");
			String isbn13 = mr.getParameter("isbn13");
			String description = mr.getParameter("description");
			String sStock = mr.getParameter("stock");

			int price = Integer.parseInt(sPrice);
			int stock = Integer.parseInt(sStock);

			BookDTO dto = new BookDTO(title, author, publisher, category, imageFile,
	                   description, price, stock, isbn10, isbn13, pubDate);

			BookDAO dao = new BookDAO();
			dao.insertProduct(dto);

			// move
			String path = request.getContextPath() + "/admin/productList.bo";
			response.sendRedirect(path);

		} else if(action.equals("/deleteProductProc.bo")) {
			// 1. 값 받기
			request.setCharacterEncoding("utf-8");
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);


			// 3. DTO
			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);

			// 4. DAO
			BookDAO dao = new BookDAO();
			dao.deleteProduct(dto);

			// 5. move : get
			String path = request.getContextPath() + "/admin/productList.bo";
			response.sendRedirect(path);

		} else if(action.equals("/updateProduct.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")
			System.out.println(action);

			request.setCharacterEncoding("utf-8");
			String sBook_seq = request.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);

			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);

			BookDAO dao = new BookDAO();

			//2. view content
			dto = dao.selectView(dto);
			System.out.println(dto);

			request.setAttribute("dto", dto);

			//3. forward
			String path =  "/admin/updateProduct.jsp"; // 1
			request.getRequestDispatcher(path).forward(request, response);

		} else if(action.equals("/updateProductProc.bo")) {
			// 1. 값 받기
			request.setCharacterEncoding("utf-8");

			request.setCharacterEncoding("utf-8");
			String saveDirectory = "C:/Mid/jspws/EIBooks/src/main/webapp/Uploads";
			String encoding = "UTF-8";
			int maxPostSize = 1024 * 1000 * 10; // 1000kb -> 1M > 10M

			MultipartRequest mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding);

			String sBook_seq = mr.getParameter("book_seq");
			int book_seq = Integer.parseInt(sBook_seq);
			System.out.println(book_seq);

			String title = mr.getParameter("title");
			System.out.println(title);
			String author = mr.getParameter("author");
			System.out.println(author);
			String category = mr.getParameter("category");
			System.out.println(category);
			String sPrice = mr.getParameter("price");
			System.out.println(sPrice);
			String publisher = mr.getParameter("publisher");
			System.out.println(publisher);
			String pubDate = mr.getParameter("pubDate");
			System.out.println(pubDate);
			String isbn10 = mr.getParameter("isbn10");
			System.out.println(isbn10);
			String isbn13 = mr.getParameter("isbn13");
			System.out.println(isbn13);
			String description = mr.getParameter("description");
			System.out.println(description);
			String sStock = mr.getParameter("stock");
			System.out.println(sStock);

			int price = Integer.parseInt(sPrice);
			int stock = Integer.parseInt(sStock);

			BookDTO imageDTO = new BookDTO();
			imageDTO.setBook_seq(book_seq);
			BookDAO imageDAO = new BookDAO();
			imageDTO = imageDAO.selectView(imageDTO);

			String imageFile = mr.getFilesystemName("imageFile");
			if (imageFile != null) {
				String ext = imageFile.substring(imageFile.lastIndexOf("."));
				String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
				imageFile = now + ext;

				File file = new File(saveDirectory + File.separator + imageFile);
				mr.getFile("imageFile").renameTo(file);

				imageFile = "file:///C:/Mid/jspws/EIBooks/src/main/webapp/Uploads/" + imageFile;
				System.out.println(imageFile);
			} else {
				imageFile = imageDTO.getImageFile();
			}


			BookDTO dto = new BookDTO(book_seq, title, author, publisher, category, imageFile,
					description, price, stock, isbn10, isbn13, pubDate);

			// 4. DAO
			BookDAO dao = new BookDAO();
			dao.updateProduct(dto);

			// 5. move : get
			String path = request.getContextPath() + "/admin/productView.bo?book_seq=" + book_seq;
			response.sendRedirect(path);
		} else if(action.equals("/main.bo")) {
			// move. get, 2. forward - reqeust.setAttribute("v","o")
			System.out.println(action);


			BookDAO bDao = new BookDAO();
			int bookCnt = bDao.getBookCount();

			CustomerDAO cDao = new CustomerDAO();
			int cusCnt = cDao.getCustomerCount();

			request.setAttribute("bookCnt", bookCnt);
			request.setAttribute("cusCnt", cusCnt);

			// forward
			String path =  "/admin/main.jsp"; // 1
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

			BookDTO dto = new BookDTO();
			dto.setBook_seq(book_seq);

			BookDAO dao = new BookDAO();
			dto = dao.getBook(dto);
			
			// 리뷰 연결 및 개수 추가
			ReviewDTO rDto = new ReviewDTO();
			rDto.setBookNum(book_seq);
			ReviewDAO rDao = new ReviewDAO();
			int reviewCount = rDao.selectCount(rDto);
			request.setAttribute("reviewCount", reviewCount);
			double reviewAvg = rDao.reviewAvg(rDto);
			request.setAttribute("reviewAvg", reviewAvg);
			List<ReviewDTO> topReviews = rDao.selectTopList(rDto);
			request.setAttribute("topReviews", topReviews);
			

			request.setAttribute("dto", dto);
			
			
			//qna
			Map<String, String> map = new HashMap<>();
			
			String protect_YN = request.getParameter("protect_YN");
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

			request.getRequestDispatcher("./userBookDetail.jsp").forward(request, response);
		}


	}
}
