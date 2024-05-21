<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@include file="/auth/sessionCheck.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            height: 100vh;
            margin: 0;
        }

        .login {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 300px;
            text-align: center;
        }

        .container h2 {
            font-size: 2em;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #555;
            color: #fff;
            text-align: center;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #333;
        }

        .extra-links {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            font-size: 0.9em;
            color: #999;
        }

        .extra-links a {
            text-decoration: none;
            color: #999;
        }

        .extra-links a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<%@ include file="../common/menu.jsp" %>
<body>
<div class="login">
    <div class="container">
        <h2>로그인</h2>
        <form action="loginProc.cs" method="post">
            <div class="form-group">
                <label for="cus_id">아이디</label>
                <input type="text" id="cus_id" name="cus_id" value="<%= request.getParameter("cus_id") != null ? request.getParameter("cus_id") : "" %>" required>
            </div>
            <% if (request.getAttribute("errorMessageId") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMessageId") %></div>
            <% } %>
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" value="<%= request.getParameter("password") != null ? request.getParameter("password") : "" %>" required>
            </div>
            <% if (request.getAttribute("errorMessagePw") != null) { %>
            <div class="error-message"><%= request.getAttribute("errorMessagePw") %></div>
            <% } %>
            <button type="submit" class="btn">로그인</button>
            <a href="signup.cs" class="btn">회원가입</a>
        </form>
        <div class="extra-links">
            <a href="#">아이디 찾기</a>
            <a href="#">비밀번호 재설정</a>
        </div>
    </div>
</div>
</body>
</html>
