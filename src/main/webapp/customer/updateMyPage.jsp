<%@page import="eibooks.dto.CustomerDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
CustomerDTO customer = (CustomerDTO)request.getAttribute("customer");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPageUpdate.jsp</title>

<script type="text/javascript">
function validateForm() {
	const form = document.writeForm;
	console.dir(form); // input
	
	if(form.cus_id.value === "") {
		alert('아이디 필수값입니다.');
		form.cus_id.focus();
		return;
	}
	
	if(form.name.value === "") {
		alert('이름 필수값입니다.');
		form.name.focus();
		return;
	}
	
	if(form.password.value === "") {
		alert('비밀 번호 필수값입니다.');
		form.password.focus();
		return;
	}
	
	if(form.password_confirm.value === "") {
		alert('비밀 번호 확인 필수값입니다.');
		form.password_confirm.focus();
		return;
	}
	
	
	
	if(form.postalCode.value === "") {
		alert('주소 필수값입니다.');
		form.postalCode.focus();
		return;
	}
	
	if(form.addr.value === "") {
		alert('주소 필수값입니다.');
		form.addr.focus();
		return;
	}
	
	if(form.addr_detail.value === "") {
		alert('주소 필수값입니다.');
		form.addr_detail.focus();
		return;
	}
	
	
	if(form.password_confirm.value !== form.password.value) {
		alert('비밀번호가 일치하지 않습니다.');
		form.password_confirm.focus();
		return;
	} else {
		form.submit();
	}
}
</script>

<style>
	.box {
		border : 1px solid black;
		width : 500px;
		height : 730px
	}
	.info {
		padding: 30px 30px 0px 30px;
	}
	.info h2 {
		margin-left: 18px;
	}
	.info strong, .info a {
		margin-left: 18px;
	}
	.info input[type=text], input[type=password] {
		display: block;
		margin: 5px auto;
	}
	
	.btn_wrap {
		display: flex;
		margin-right: 18px;
	}
	.info input[type=button] {
		margin-left: auto; 
	}
</style>
</head>
<body>

<%@ include file="../common/menu.jsp" %>

<h2>마이페이지</h2>
<ul>
	<li>
		<a href="/EIBooks/customer/updateMyPage.cu">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
</ul>

<form name="writeForm" method="post" action="<%=request.getContextPath()%>/updateMyPageProc.cu">
<div class="box">
	<div class="info">
		<h2>회원 정보 수정</h2>
	</div>
	<div class="info">
		<strong>아이디</strong>
		<%=customer.getCus_id() %>
		<input type="hidden" name="cus_seq" value="<%=customer.getCus_seq() %>">
		<input type="hidden" name="cus_id" value="<%=customer.getCus_id() %>">
	</div>
	<div class="info">
		<strong>이름</strong><br>
		<input type="text" name="name" style="width:90%" value="<%=customer.getName() %>">
	</div>
	<div class="info">
		<strong>비밀번호</strong>
		<input type="password" name="password" style="width:90%" value="<%=customer.getPassword() %>">
		<input type="password" name="password_confirm" style="width:90%" placeholder="한 번 더 입력해주세요">
	</div>
	<div class="info">
		<strong>연락처</strong><br>
		<input type="text" name="tel" style="width:90%" value="<%=customer.getTel() %>">
	</div>
	<div class="info">
		<strong>이메일</strong>
		<input type="text" name="email" style="width:90%" value="<%=customer.getEmail() %>">
	</div>
	<div class="info">
		<strong>주소</strong><br>
		<input type="text" name="postalCode" style="width:90%" value="<%=customer.getAddrInfo().getPostalCode() %>">
		<input type="text" name="addr" style="width:90%" value="<%=customer.getAddrInfo().getAddr() %>">
		<input type="text" name="addr_detail" style="width:90%" value="<%=customer.getAddrInfo().getAddr_detail() %>">
	</div>
	
	<div class="info btn_wrap">
		<a href="/EIBooks/customer/deleteMyPage.jsp?cus_seq=<%=customer.getCus_seq() %>">회원 탈퇴하기</a>
		<input type="button" value="수정" onclick="validateForm();">
	</div>
</div>
</form>

</body>
</html>