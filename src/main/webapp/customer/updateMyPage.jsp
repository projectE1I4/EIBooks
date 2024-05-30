<%@page import="eibooks.dto.CustomerDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
CustomerDTO customer = (CustomerDTO)request.getAttribute("customer");
System.out.println(customer);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPageUpdate.jsp</title>

<style>
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            margin: 0 auto;
            width: 50%;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        .form-group .optional {
            font-size: 0.9em;
            color: grey;
        }
        
        .btn_wrap {
        	display: flex;
        	justify-content: space-between;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #555;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
        }
    </style>
    <script>
        function validateForm() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var tel = document.getElementById("tel").value;
            var name = document.getElementById("name").value;
            var postalCode = document.getElementById("postalCode").value;

            // 비밀번호 유효성 검사
            var pwRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
            if (!pwRegex.test(password)) {
                alert("비밀번호는 8글자 이상이어야 하며, 영문, 숫자, 특수문자를 포함해야 합니다.");
                return false;
            }

            // 비밀번호 확인 검사
            if (password !== confirmPassword) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                return false;
            }

            // 이름 유효성 검사
          	var nameRegex = /^[가-힣a-zA-Z\s]*$/;
            if (!nameRegex.test(name)) {
                alert("이름에는 특수문자가 포함될 수 없습니다.");
                return;
            }

            // 전화번호 유효성 검사
            var telRegex = /^\d{11}$/;
            if (!telRegex.test(tel.replace(/-/g, ""))) {
                alert("전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                return false;
            }

            // 우편번호 유효성 검사
            var postalCodeRegex = /^\d{5}$/;
            if (!postalCodeRegex.test(postalCode)) {
                alert("우편번호는 숫자 5자리여야 합니다.");
                return false;
            }

            return true;
        }

    </script>

</head>
<body>

<%@ include file="../common/menu.jsp" %>

<h2>마이페이지</h2>
<ul>
	<li>
		<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
</ul>

<div class="container">
    <h1>회원 정보 수정</h1>
    <form action="updateMyPageProc.cs" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="cus_id">아이디</label>
            <%=customer.getCus_id() %>
            <input type="hidden" name="cus_seq" value="<%=customer.getCus_seq() %>">
			<input type="hidden" name="cus_id" value="<%=customer.getCus_id() %>">
        </div>
        <div class="form-group">
            <label for="password">비밀번호 <span>*</span></label>
            <input type="password" id="password" name="password"  value="<%=customer.getPassword() %>" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">비밀번호 확인 <span>*</span></label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message"><%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>
        <div class="form-group">
            <label for="name">이름 <span>*</span></label>
            <input type="text" id="name" name="name" value="<%=customer.getName() %>" required>
        </div>
        <div class="form-group">
            <label for="tel">전화번호 <span>*</span></label>
            <input type="text" id="tel" name="tel" value="<%=customer.getTel() %>" required>
        </div>
        <div class="form-group">
            <label for="postalCode">우편번호 <span>*</span></label>
            <input type="text" id="postalCode" name="postalCode"  value="<%=customer.getAddrInfo().getPostalCode() %>" required>
        </div>
        <div class="form-group">
            <label for="addr">주소 <span>*</span></label>
            <input type="text" id="addr" name="addr" value="<%=customer.getAddrInfo().getAddr() %>" required>
        </div>
        <div class="form-group">
            <label for="addr_detail">상세주소 <span class="optional">(선택사항)</span></label>
            <input type="text" id="addr_detail" name="addr_detail" value="<%=customer.getAddrInfo().getAddr_detail() %>">
        </div>
        <div class="form-group">
            <label for="email">이메일 <span class="optional">(선택사항)</span></label>
           	<input type="email" id="email" name="email" <% if(customer.getEmail() != null) { %> value="<%=customer.getEmail() %>"  <% } %>>
        </div>
        
        <div class="btn_wrap">
	        <div class="form-group">
				<a href="/EIBooks/customer/deleteMyPage.jsp?cus_seq=<%=customer.getCus_seq() %>">회원 탈퇴하기</a>
			</div>
	        <div class="form-group">
	            <button type="submit" class="btn">수정</button>
	        </div>
		</div>
    </form>
</div>

</body>
</html>