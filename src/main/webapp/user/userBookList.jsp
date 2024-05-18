<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 가져오는 방식에 대해서 고민
	// 검색 시 얘가 지금 null 값으로 가져오는 중임
	List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList");
	BookDTO bookdto = new BookDTO();
	PageDTO p = (PageDTO)request.getAttribute("paging");
// int totalCount = (int)request.getAttribute("totalCount");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 목록 보기</title>
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>도서 목록 보기</h2>

<!-- 검색창 -->
<form method="get">
<table border="1" width="90%">
	<tr>
	<td>
	<input type="text" name="searchWord" />
	<input type="submit" value="search">
	</td>
	</tr>
</table>
</form>

<!-- 전체 목록 -->
<table border="1" width="90%">
<tr>
<td colspan="4">&nbsp;<b>카테고리 :<% if(bookdto.getCategory()==null){ %> 전체 <% }else{ %> 카테고리명<% } %></b></td>
<td colspan="4">&nbsp;<b>전체 :<%=p.getPageNum() %> / <%=p.getTotal() %></b></td>
</tr>
	<tr>
		<th width="5%">넘버링</th>
		<th width="10%">이미지</th>
		<th width="20%">도서 명</th>
		<th width="10%">저자 명</th>
		<th width="8%">출판사</th>
		<th width="8%">출간일</th>
		<th width="35%">디스크립션</th>
		<th width="20%">금액</th>
		<th width="20%">버튼</th>
	</tr>
	<% if(bookList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>Data Not Found!!</b></td></tr>
<% } else { 
int cnt = 1;
%>
	<% for(BookDTO book : bookList){ %>	
		<tr align="center">
			<td><%=cnt++ %></td>
			<td><img alt="" src="<%=book.getImageFile() %>"></td>
			<td align="left"><%=book.getTitle() %></td>
			<td align="left"><%=book.getAuthor() %></td>
			<td align="left"><%=book.getPublisher() %></td>
			<td><%=book.getPubDate() %></td>
			<td><%=book.getDescription() %></td>
			<td><%=book.getPrice() %>원</td>
			<td>
			<button type="button">주문하기</button>
			<button type="button">장바구니</button>
			</td>
		</tr>
	<%} %>
	<%} %>
<tr>
<td colspan="8">
<%if(p.isPrev()) {%><a href="userBookList.bo?pageNum=1">[First]</a><% } %>
<%if(p.isPrev()) {%><a href="userBookList.bo?pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()){%>
		<b>[<%=i %>]</b>
	<%}else{ %>
	<a href="userBookList.bo?pageNum=<%=i%>">[<%=i %>]</a>
	<%} %>
<%} %>
<%if(p.isNext()){%><a href="userBookList.bo?pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
<%if(p.isNext()){%><a href="userBookList.bo?pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
</td>
</tr>

</table>
</body>
</html>