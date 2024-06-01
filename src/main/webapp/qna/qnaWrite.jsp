<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BookDTO book = (BookDTO)request.getAttribute("book");
%>    
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaWrite.css?v=<?php echo time(); ?>">
<script>
$(document).ready( function() {
    
});

function limitText(field, maxLength) {
	if (field.value.length > maxLength) {
		field.value = field.value.substring(0, maxLength);
		alert('최대 ' + maxLength + '자까지 작성할 수 있습니다.');
	}
}
</script>
</head>
<body>

<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<%@ include file="../common/header.jsp" %>
	<main id="container">
		<div class="inner">
			<h2>상품문의</h2>
			<div class="info">
				<div><img src="<%=book.getImageFile() %>"></div>
				<div>
					<p><%=book.getPublisher() %></p>
					<p><%=book.getTitle() %></p>
					<p><%=book.getAuthor() %></p>
				</div>
			</div>
			<ul class="qna_form">
				<li class="">
					<form class="write_form" name="writeForm" method="post" action="/EIBooks/qna/qnaWriteProc.qq?book_seq=<%=book.getBook_seq() %>">
						<div class="qna_input">
							<p>문의유형</p>
							<select name="type">
								<option value="상품상세문의">상품상세문의</option>
								<option value="재입고">재입고</option>
							</select>
						</div>
						<div class="qna_input">
							<p>제목</p>
							<input type="text" name="title" oninput="limitText(this, 50)">
							<div class="checkbox_wrap">
								<input type="checkbox" id="protect_YN" name="protect_YN" value="Y">
								<label for="protect_YN">비밀글</label>
							</div>
						</div>
						<div class="qna_input text_area">
							<p>내용</p>
							<textarea class="write_content" name="content" oninput="limitText(this, 500)"></textarea>
						</div>
						<div class="write_btn_wrap">
							<input class="btn" type="button" value="취소" onclick="goToPage()">
							<input class="btn write_btn" type="submit" value="작성하기">
						</div>
					</form>
				</li>
			</ul>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>	

</body>
</html>