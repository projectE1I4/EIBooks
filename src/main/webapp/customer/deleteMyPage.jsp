<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int cus_seq = (int)session.getAttribute("cus_seq");
%>    
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/mypage/deleteMyPage.css?v=<?php echo time(); ?>">
</head>

<body>
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
		<h1>회원 탈퇴</h1>
	</div>
	
	<div class="card_area">
		<div class="card_wrap">
			<form name="writeForm" method="post" action="<%=request.getContextPath() %>/deleteMyPageProc.cs">
				<div class="info">
					<strong>비밀번호<em>*</em></strong>
					<input type="password" name="password" placeholder="비밀번호를 입력해주세요.">
				</div>
				<div class="info">
					<strong>비밀번호 확인<em>*</em></strong>
					<input type="password" name="password_confirm" placeholder="한 번 더 입력해주세요.">
				</div>
				
				<div class="info btn_wrap">
					<input type="hidden" name="cus_seq" value="<%=cus_seq %>">
					<input type="button" value="탈퇴하기" onclick="validateForm();" class="btn">
				</div>
			</form>
		</div>
	</div>

</div> <!-- content -->
</div> <!-- mypage -->
</div> <!-- inner -->
</main> <!-- container -->

<%@ include file="../common/footer.jsp" %>
</div> <!-- wrap -->
</body>
</html>