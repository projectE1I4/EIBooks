<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int cus_seq = (int)session.getAttribute("cus_seq");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteMyPage.jsp</title>

<script type="text/javascript">
function validateForm() {
    const form = document.writeForm;
    let isValid = true;
    const errorMessages = {
        password: "비밀번호를 입력해주세요.",
        password_confirm: "비밀번호 확인을 입력해주세요.",
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

    if (isValid) {
        form.submit();
    }
}
</script>

<style>
	.box {
		border : 1px solid black;
		width : 500px;
		height : 420px
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
<%@ include file="../common/header.jsp" %>
<h2>마이페이지</h2>
<ul>
	<li>
		<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
</ul>

<form name="writeForm" method="post" action="<%=request.getContextPath() %>/deleteMyPageProc.cs">
<div class="box">
	<div class="info">
		<h2>회원 탈퇴</h2>
	</div>
	<div class="info">
		<strong>비밀번호</strong><em>*</em>
		<input type="password" name="password" style="width:90%">
	</div>
	<div class="info">
		<strong>비밀번호 확인</strong><em>*</em>
		<input type="password" name="password_confirm" style="width:90%" placeholder="한 번 더 입력해주세요">
	</div>
	
	<div class="info btn_wrap">
		<input type="hidden" name="cus_seq" value="<%=cus_seq %>">
		<input type="button" value="탈퇴" onclick="validateForm();">
	</div>
</div>
</form>

</body>
</html>