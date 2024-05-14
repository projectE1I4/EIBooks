<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//장바구니 리스트 가져오기
	List<cartDTO> cartList =(List<cartDTO>)request.getAttribute("cartList");
	cartDTO cartdto = new cartDTO();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 장바구니 목록 보기</title>
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>회원 장바구니 보기</h2>

<!-- 장바구니 목록 -->
<table border="1" width="90%">
<tr>
    <th width="8%">도서 번호</th>
    <th width="17%">도서 이미지</th>
    <th width="20%">도서 제목</th>
    <th width="15%">출판사</th>
    <th width="10%">출간일</th>
    <th width="10%">ISBN</th>
    <th width="10%">가격</th>
</tr>
<% 
   if(cartList.isEmpty()) { %>  
   <tr><td colspan="8">&nbsp; 장바구니에 아무것도 없습니다.</td></tr>
<% } else {
   int cnt = 1;
   for(cartDTO cartItem : cartList) {
	   System.out.println(cartItem);
%>
<tr>
    <td><%=cartItem.getBookInfo().getBook_seq() %></td>
    <td><img src = "<%=cartItem.getBookInfo().getImageFile() %>"></td>
    <td><%=cartItem.getBookInfo().getTitle() %></td>
    <td><%=cartItem.getBookInfo().getPublisher() %></td>
    <td><%=cartItem.getBookInfo().getPubDate() %></td>
    <td><%=cartItem.getBookInfo().getIsbn13() %></td>
    <td><%=cartItem.getBookInfo().getPrice() %>원</td>
</tr>
<% } %>  
<% } %>

</table>
</body>
</html>