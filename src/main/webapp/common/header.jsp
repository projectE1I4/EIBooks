<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="eibooks.dto.CustomerDTO" %>
<%
    String managerYN = (String) session.getAttribute("manager_YN");
    CustomerDTO SessionCustomer = (CustomerDTO) session.getAttribute("customer");
%>
<header id="header">
    <div class="inner">
        <!-- 로고 부분 -->
        <div class="logo">
            <% if (SessionCustomer != null && "Y".equals(managerYN)) { %>
            <a href="<%=request.getContextPath()%>">
                <img src="/EIBooks/styles/images/EIBooks_admin_logo.png" alt="EIbooks admin"></a>
            <% } else if (!"Y".equals(managerYN)) { %>
            <a href="<%=request.getContextPath()%>">
                <img src="/EIBooks/styles/images/EIBooks_logo.png" alt="EIbooks"></a>
            <% } %>
        </div>
        <!-- 메뉴 부분 -->
        <div class="menu_wrap">
            <!-- 관리자 로그인 상태 -->
            <% if (SessionCustomer != null && "Y".equals(managerYN)) { %>
            <div class="admin_wrap">
                <ul>
                    <li><p class="userInfo"><strong><%=SessionCustomer.getCus_id() %>(<%=SessionCustomer.getName() %>)</strong>님 환영합니다.</p></li>
                    <li><a href="<%=request.getContextPath()%>/user/userBookList.bo?pageNum=1&searchWord=&category=&order=latest">도서 리스트</a></li>
                    <li><a href="main.bo" class="btn admin_btn">관리자 페이지</a></li>
                    <li><a class="btn logout_btn" href="logoutProc.cs">로그아웃</a></li>
                </ul>
            </div>
            <% } %>
            <!-- 비로그인 상태 -->
            <div class="login_wrap">
                <ul>
                    <% if (SessionCustomer == null) { %>
                    <li><a href="<%=request.getContextPath()%>/user/userBookList.bo?pageNum=1&searchWord=&category=&order=latest">도서 리스트</a></li>
                    <li><a class="btn login_btn" href="login.cs">로그인 / 회원가입</a></li>
                    <% } %>
                </ul>
            </div>
            <!-- 회원 로그인상태 -->
            <% if (SessionCustomer != null && "N".equals(managerYN)) { %>
            <div class="customer_wrap">
                <ul>
                    <li><p class="userInfo"><strong><%=SessionCustomer.getCus_id() %>(<%=SessionCustomer.getName() %>)</strong>님 환영합니다.</p></li>
                    <li><a href="<%=request.getContextPath()%>/user/userBookList.bo?pageNum=1&searchWord=&category=&order=latest">도서 리스트</a></li>
                    <li><a href="<%=request.getContextPath()%>/customer/customerCartOut.cc">장바구니</a></li>
                    <li><a class="btn mypage_btn" href="<%=request.getContextPath()%>/customer/myPage.or">마이 페이지</a></li>
                    <li><a class="btn logout_btn" href="logoutProc.cs">로그아웃</a></li>
                </ul>
            </div>
            <% } %>
        </div>
    </div>
</header>