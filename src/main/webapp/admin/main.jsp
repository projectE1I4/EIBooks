<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int bookCnt = (int)request.getAttribute("bookCnt");
int cusCnt = (int)request.getAttribute("cusCnt");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
</head>
<body>
<%@ include file="../common/menu.jsp" %>

<div>
	<h3>회원 관리</h3>
	<div>
		<a href="/EIBooks/admin/customerList.cs">
			<strong><%=cusCnt %></strong><br>
			전체 회원
		</a>
	</div>
</div>
<hr>
<div>
	<h3>제품 관리</h3>
	<div>
		<a href="/EIBooks/admin/productList.bo">
			<strong><%=bookCnt %></strong><br>
			전체 제품
		</a>
	</div>
	<br>
	<div>
		<a href="/EIBooks/admin/writeProduct.bo">제품 등록</a>
	</div>
</div>

<br><hr><br>
<div>
	<a href="/EIBooks/admin/orderList.or">전체 주문 확인</a>
</div>

<div>
	<a href="/EIBooks/review/replyList.do?userNum=1">전체 리뷰 확인</a>
</div>

</body>
</html>