<%@page import="eibooks.dto.CustomerDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
CustomerDTO customer = (CustomerDTO)request.getAttribute("customer");
System.out.println(customer);
%>    
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/mypage/updateMyPage.css?v=<?php echo time(); ?>">
</head>
<body>
<script type="text/javascript">
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

<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>

<div id="wrap">
<%@ include file="../common/header.jsp" %>

<main id="container">
<div class="inner">
<div id="mypage">
<div class="side_menu_wrap">
<h2>마이페이지</h2>
<ul class="side_menu">
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
	<li class="list_mypage">
		<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
	</li>
	<li>
		<a href="/EIBooks/orderQna/qnaList.oq">1:1문의 내역</a>
	</li>
</ul>
</div>

<div class="content">

	<div class="tit_wrap">
		<h1>회원 정보 수정</h1>
	</div>
	
	<div class="card_area">
		<div class="card_wrap">
			<form action="updateMyPageProc.cs" method="post" onsubmit="return validateForm()">
		        <div class="form-group id_wrap">
		            <label for="cus_id">아이디</label>
		            	<span><%=customer.getCus_id() %></span>
		            <input type="hidden" name="cus_seq" value="<%=customer.getCus_seq() %>">
					<input type="hidden" name="cus_id" value="<%=customer.getCus_id() %>">
		        </div>
		        <div class="form-group pw_wrap">
		            <label for="password">비밀번호<span class="required">*</span></label>
		            <input type="password" id="password" name="password"  value="<%=customer.getPassword() %>" required>

		            <label for="confirmPassword">비밀번호 확인<span class="required">*</span></label>
		            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="한 번 더 입력해주세요." required>
		        </div>
		        <% if (request.getAttribute("errorMessage") != null) { %>
		        <div class="error-message"><%= request.getAttribute("errorMessage") %>
		        </div>
		        <% } %>
		        <div class="form-group info_wrap">
		            <label for="name">이름<span class="required">*</span></label>
		            <input type="text" id="name" name="name" value="<%=customer.getName() %>" required>

		            <label for="tel">전화번호<span class="required">*</span></label>
		            <input type="text" id="tel" name="tel" value="<%=customer.getTel() %>" required>
		        </div>
		        <div class="form-group addr_wrap">
		            <label for="postalCode">우편번호<span class="required">*</span></label>
		            <input type="text" id="postalCode" name="postalCode"  value="<%=customer.getAddrInfo().getPostalCode() %>" required>

		            <label for="addr">주소<span class="required">*</span></label>
		            <input type="text" id="addr" name="addr" value="<%=customer.getAddrInfo().getAddr() %>" required>

		            <label for="addr_detail">상세주소<span class="optional">(선택사항)</span></label>
		            <input type="text" id="addr_detail" name="addr_detail" value="<%=customer.getAddrInfo().getAddr_detail() %>">
		        </div>
		        <div class="form-group email_wrap">
		            <label for="email">이메일<span class="optional">(선택사항)</span></label>
		           	<input type="email" id="email" name="email" <% if(customer.getEmail() != null) { %> value="<%=customer.getEmail() %>"  <% } %>>
		        </div>
		        
		        <div class="btn_wrap">
			        <div class="form-group">
						<a href="/EIBooks/customer/deleteMyPage.jsp?cus_seq=<%=customer.getCus_seq() %>">회원 탈퇴하기</a>
					</div>
			        <div class="form-group">
			            <button type="submit" class="btn">수정하기</button>
			        </div>
				</div>
		    </form>
	    </div> <!-- card_wrap -->
	</div> <!-- card_area -->
</div> <!-- content -->
</div>
</div>
</main>

<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>