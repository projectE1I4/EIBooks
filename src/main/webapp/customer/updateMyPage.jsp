<%@page import="eibooks.dto.CustomerDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
CustomerDTO customer = (CustomerDTO)request.getAttribute("customer");
Boolean isNotNull = false;
Boolean isNotSame = false;
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPageUpdate.jsp</title>

<script type="text/javascript">
function validateForm() {
    const form = document.writeForm;
    let isValid = true;
    const errorMessages = {
        name: "이름을 입력해주세요.",
        password: "비밀번호를 입력해주세요.",
        password_confirm: "비밀번호 확인을 입력해주세요.",
        tel: "연락처를 입력해주세요.",
        postalCode: "우편번호를 입력해주세요",
        addr: "주소를 입력해주세요.",
        addr_detail: "상세 주소를 입력해주세요.",
        password_mismatch: "비밀번호가 일치하지 않습니다."
    };

    function showError(element, message) {
        const errorEm = document.createElement('em');
        errorEm.className = 'error';
        errorEm.textContent = message;
        element.parentNode.appendChild(errorEm);
    }

    function clearErrors() {
        const errors = document.querySelectorAll('em.error');
        errors.forEach(error => error.remove());
    }

    clearErrors();

    if (form.name.value === "") {
        isValid = false;
        showError(form.name, errorMessages.name);
        form.name.focus();
    }

    if (form.password.value === "") {
        isValid = false;
        showError(form.password, errorMessages.password);
        form.password.focus();
    }

    if (form.password_confirm.value === "") {
        isValid = false;
        showError(form.password_confirm, errorMessages.password_confirm);
        form.password_confirm.focus();
    } else if (form.password_confirm.value !== form.password.value) {
        isValid = false;
        showError(form.password_confirm, errorMessages.password_mismatch);
        form.password_confirm.focus();
    }

    if (form.tel.value === "") {
        isValid = false;
        showError(form.tel, errorMessages.tel);
        form.tel.focus();
    }

    if (form.postalCode.value === "") {
        isValid = false;
        showError(form.postalCode, errorMessages.postalCode);
        form.postalCode.focus();
    } else if (form.addr.value === "") {
        isValid = false;
        showError(form.addr, errorMessages.addr);
        form.addr.focus();
    } else if (form.addr_detail.value === "") {
        isValid = false;
        showError(form.addr_detail, errorMessages.addr_detail);
        form.addr_detail.focus();
    }

    if (isValid) {
        form.submit();
    }
}
</script>

<style>
	.box {
		border : 1px solid black;
		width : 500px;
		height : 820px
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
	.info em {
		color: red;
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
		<strong>이름</strong><em>*</em><br>
		<input type="text" name="name" style="width:90%" value="<%=customer.getName() %>">
	</div>
	<div class="info">
		<strong>비밀번호</strong><em>*</em>
		<input type="password" name="password" style="width:90%" value="<%=customer.getPassword() %>">
	</div>
	<div class="info">
		<strong>비밀번호 확인</strong><em>*</em>
		<input type="password" name="password_confirm" style="width:90%" placeholder="한 번 더 입력해주세요">
	</div>
	<div class="info">
		<strong>연락처</strong><em>*</em><br>
		<input type="text" name="tel" style="width:90%" value="<%=customer.getTel() %>">
	</div>
	<div class="info">
		<strong>이메일</strong>
		<input type="text" name="email" style="width:90%" value="<%=customer.getEmail() %>">
	</div>
	<div class="info">
		<strong>주소</strong><em>*</em><br>
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