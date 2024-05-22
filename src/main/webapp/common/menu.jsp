<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
</head>
<body>
<ul>
    <li><a href="<%=request.getContextPath()%>">Index</a></li>
<li><a href="/EIBooks/user/userBookList.bo">유저 제품 리스트</a></li>
    <li><a href="/EIBooks/admin/productList.bo">관리자 제품 리스트</a> | <a href="/EIBooks/writeProduct.bo">제품 등록</a></li>
    <li>장바구니</li>
    <li><a href="/EIBooks/admin/customerList.cs">관리자 회원 리스트</a></li>
    <li>리뷰리스트</li>
    <% if (session.getAttribute("customer") == null) {%>
    <li><a href="/EIBooks/auth/signup.cs">회원가입</a> &nbsp;|&nbsp; <a href="/EIBooks/auth/login.cs">로그인</a></li>
    <%} else { %>
    <li><%=session.getAttribute("cus_id") %>(<%=session.getAttribute("name") %>)님 환영합니다.</li>
    <li><a href="logoutProc.cs">로그아웃</a></li>
    <% } %>
</ul>
<hr>
</body>
</html>