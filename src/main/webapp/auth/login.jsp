<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/styles/css/auth/auth.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<div id="wrap">
    <%@ include file="/common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="login">
                <h2>로그인</h2>
                <form action="loginProc.cs" method="post">
                    <div class="form-group">
                        <label for="cus_id">아이디</label>
                        <input type="text" id="cus_id" name="cus_id"
                               value="<%= request.getParameter("cus_id") != null ? request.getParameter("cus_id") : "" %>"
                               required>
                    </div>
                    <% if (request.getAttribute("errorMessageId") != null) { %>
                    <div class="error-message"><%= request.getAttribute("errorMessageId") %>
                    </div>
                    <% } %>
                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password"
                               value="<%= request.getParameter("password") != null ? request.getParameter("password") : "" %>"
                               required>
                    </div>
                    <% if (request.getAttribute("errorMessagePw") != null) { %>
                    <div class="error-message"><%= request.getAttribute("errorMessagePw") %>
                    </div>
                    <% } %>
                    <div class="btn-group">
                        <button type="submit" class="btn">로그인</button>
                        <a href="signup.cs" class="btn">회원가입</a>
                    </div>
                </form>
                <div class="extra-links">
                    <a href="findId.cs">아이디 찾기</a>
                    <a href="verification.cs">비밀번호 재설정</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>