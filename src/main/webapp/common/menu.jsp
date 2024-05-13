<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>menu</title >
</head>
<body>
<ul>
<li><a href="<%=request.getContextPath()%>">Index</a></li>
<li><a href="/EIBooks/user/userBookList.bo">유저 제품 리스트</a></li>
<li><a href="/EIBooks/admin/bookList.bo">관리자 제품 리스트</a></li>
<li><a href="/EIBooks/customer/customerCart.cc">회원 장바구니 리스트</a></li>
<li>관리자 회원리스트</li>
<li>리뷰리스트</li>
</ul>
<hr>
</body>
</html>