<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dao.BookDAO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% // param
	BookDTO dto = (BookDTO)request.getAttribute("dto");
	String sBook_seq = request.getParameter("book_seq");
	System.out.println("sBook_seq ------------------ : " + sBook_seq);
	int book_seq = Integer.parseInt(sBook_seq);
	BookDAO dao = new BookDAO();
	int viewcount = dto.getViewCount();
	dao.userGetViewCount(book_seq);
	viewcount = dao.userViewCount(book_seq);
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>userBookDetail.jsp</title>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<h2>글 상세보기 </h2>
<table border="1" width="60%">
	<tr>
		<td colspan="4"><%=dto.getTitle() %></td>
	</tr>
	<tr>
		<td colspan="4"><%=dto.getAuthor()%></td>	
	</tr>
	<div>
		<div >
			<tr>
				<td><img src="<%=dto.getImageFile() %>" alt="표지이미지" width=200></td>
			</tr>
		</div>
		<div>
			<tr>
				<td colspan="4"><%=dto.getPrice() %>원</td>
			</tr>
			<tr>
				<td>도서 분류</td><td colspan="3"><%=dto.getCategory() %></td>
			</tr>
			<tr>
				<td>출판사</td><td width="30%"><%=dto.getPublisher() %></td>
				<td>출간일</td><td><%=dto.getPubDate() %></td>
			</tr>
			<tr>
				<td width="20%">isbn10</td><td><%=dto.getIsbn10() %></td>
				<td width="20%">isbn13</td><td><%=dto.getIsbn13() %></td>
			</tr>
			<tr rowspan="10"><td colspan="4"><%=dto.getDescription() %></td></tr>
			<tr><td colspan="4">
				<input type="submit" value="바로구매" />
				<input type="submit" value="장바구니" />				
			</td></tr>
			<tr>
			<td>
			조회수: 
			</td>
			<td>
			<%=viewcount %>
			</td>
			</tr>
		</div>
	</div>
	
</table>

<h2>도서 리뷰 별점평균/5</h2>
<%int reviewCount = (int)request.getAttribute("reviewCount"); %>
<a href="/EIBooks/review/reviewList.do?bookNum=<%=book_seq%>">전체보기(<%=reviewCount %>)</a>
<ul>
<%// for() %>
	<li>
		<ul>
			<li>별점</li>
			<li>회원ID</li>
			<li>리뷰 작성일</li>
			<li>리뷰 내용</li>
		</ul>
	</li>
</ul>
</body>
</html>