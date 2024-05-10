<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList"); 
PageDTO p = (PageDTO)request.getAttribute("paging");
int totalCount = (int)request.getAttribute("totalCount");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Book List</title>

<script type="text/javascript">
function goToPage(book_seq) {
	location.href = "productView.bo?book_seq=" + book_seq;
}

function del(book_seq){
	const input = confirm("정말 삭제 할까요?");
	if(input){
		location.href = "<%=request.getContextPath()%>/deleteProductProc.bo?book_seq="+book_seq;
	}else{
		alert('삭제를 취소 했습니다.');
		return;
	}
	
}
</script>

</head>
<body>

<%@ include file="../common/menu.jsp" %>
<h2>Board List</h2>
<form  method="get">
<table border="1" width="90%">
	<tr>	
	<td>
		<select name="searchField">
			<option value="category">도서 분류</option>
			<option value="title">도서 명</option>
			<option value="author">저자 명</option>
			<option value="publisher">출판사</option>
		</select>
		<input type="text" name="searchWord">
		<input type="submit" value="Search">
	</td>
	</tr>
</table>
<br>
</form>
<table border="1" width="90%">
<tr><td colspan="8">&nbsp;<b>전체 <%=totalCount %>개</b></td></tr>
	<tr>
		<th width="10%">도서 분류</th>
		<th width="32%">도서 명</th>
		<th width="20%">저자 명</th>
		<th width="16%">출판사</th>
		<th width="14%">출간일</th>
		<th width="8%">재고 수량</th>
	</tr>
<% if(bookList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>Data Not Found!!</b></td></tr>
<% } else { %>
	<% for(BookDTO book : bookList){ %>	
		<tr align="center" onclick="goToPage(<%=book.getBook_seq()%>)">
			<td><%=book.getCategory() %></td>
			<td align="left">
			<%=book.getTitle() %>
			</td>
			<td align="left"><%=book.getAuthor() %></td>
			<td align="left"><%=book.getPublisher() %></td>
			<td><%=book.getPubDate() %></td>
			<td><%=book.getStock() %></td>
			<td><a href="updateProduct.bo?book_seq=<%=book.getBook_seq() %>">[수정]</a></td>
			<td><a href="javascript:del('<%=book.getBook_seq() %>');">[삭제]</a></td>
		</tr>
	<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="productList.bo?pageNum=1">[First]</a><% } %>
<%if(p.isPrev()) {%><a href="productList.bo?pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()){%>
		<b>[<%=i %>]</b>
	<%}else{ %>
	<a href="productList.bo?pageNum=<%=i%>">[<%=i %>]</a>
	<%} %>
<%} %>
<%if(p.isNext()){%><a href="productList.bo?pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
<%if(p.isNext()){%><a href="productList.bo?pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
</td>
</tr>

</table>
</body>
</html>