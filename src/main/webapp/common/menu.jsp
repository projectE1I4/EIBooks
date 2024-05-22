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
    <li><a href="/EIBooks/admin/main.bo">관리자 메인 페이지</a></li>
    <li><a href="/EIBooks/user/userBookList.bo">유저 제품 리스트</a></li>
    <li><a href="/EIBooks/admin/productList.bo">관리자 제품 리스트</a> | <a href="/EIBooks/writeProduct.bo">제품 등록</a></li>
    <li><a href="/EIBooks/admin/customerList.cs">관리자 회원 리스트</a></li>
    <li><a href="/EIBooks/review/reviewList.do?bookNum=1">비회원 리뷰 보기</a></li>
    <li><a href="/EIBooks/review/replyList.do?userNum=1">관리자 전체리뷰 보기</a></li>
    <% if (session.getAttribute("customer") == null) {%>
    <li><a href="/EIBooks/auth/signup.cs">회원가입</a> &nbsp;|&nbsp; <a href="/EIBooks/auth/login.cs">로그인</a></li>
    <%} else { %>
    <li><%=session.getAttribute("cus_id") %>(<%=session.getAttribute("name") %>)님 환영합니다.</li>
    <li><a href="/EIBooks/customer/customerCart.cc">장바구니</a></li>
    <li><a href="/EIBooks/customer/myPage.or">마이 페이지</a></li>
    <li><a href="logoutProc.cs">로그아웃</a></li>
    <% } %>
</ul>
<hr>
</body>
</html>