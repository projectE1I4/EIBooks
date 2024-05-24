<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="eibooks.dto.CustomerDTO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메뉴</title>
</head>
<body>
<ul>
    <li><a href="<%=request.getContextPath()%>">Index</a></li>

    <%
        String managerYN = (String) session.getAttribute("manager_YN");
        CustomerDTO SessionCustomer = (CustomerDTO) session.getAttribute("customer");
    %>

    <% if (SessionCustomer != null && "Y".equals(managerYN)) { %>
    <!-- 관리자만 볼 수 있는 페이지 -->
    <li><a href="/EIBooks/admin/main.bo">관리자 메인 페이지</a></li>
    <% } %>

    <% if (SessionCustomer == null) { %>
    <!-- 세션이 없는 상태 (로그인 하기 전) -->
    <li><a href="/EIBooks/auth/signup.cs">회원가입</a> &nbsp;|&nbsp; <a href="/EIBooks/auth/login.cs">로그인</a></li>
    <li><a href="<%=request.getContextPath()%>/user/userBookList.bo">유저 제품 리스트</a></li>
    <% } else { %>
    <!-- 일반회원 로그인 상태 -->
    <li><a href="<%=request.getContextPath()%>/user/userBookList.bo">유저 제품 리스트</a></li>
    <li><%=SessionCustomer.getCus_id() %>(<%=SessionCustomer.getName() %>)님 환영합니다.</li>
    <li><a href="/EIBooks/customer/customerCart.cc">장바구니</a> | <a href="/EIBooks/customer/myPage.or">마이 페이지</a> | <a href="logoutProc.cs">로그아웃</a></li>
    <% } %>
    <li><a href="/EIBooks/review/reviewList.do?bookNum=1">유저 리뷰 보기</a></li>
</ul>
<hr>
</body>
</html>