<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% // param
BookDTO dto = (BookDTO)request.getAttribute("dto");
String sBook_seq = request.getParameter("book_seq");
int book_seq = Integer.parseInt(sBook_seq);
%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ProductView.jsp</title>

<script>
	function del(book_seq){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/deleteProductProc.bo?book_seq="+book_seq;
		}else{
			alert('삭제를 취소했습니다.');
			return;
		}
		
	}
</script>
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
			<tr><td>재고 수량</td><td colspan="3"><%=dto.getStock() %></td></tr>
			<tr>
				<td colspan="4">
				<a href="updateProduct.bo?book_seq=<%=book_seq %>">[수정]</a>
				<a href="javascript:del('<%=book_seq %>');">[삭제]</a>
				</td>
			</tr>
		</div>
	</div>
	
</table>
</body>
</html>