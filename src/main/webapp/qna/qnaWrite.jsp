<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BookDTO book = (BookDTO)request.getAttribute("book");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- <meta name="viewport" content="width=1280"> -->
<meta name="format-detection" content="telephone=no">
<meta name="description" content="EIBooks">
<meta property="og:type" content="website">
<meta property="og:title" content="EIBooks">
<meta property="og:description" content="EIBooks">
<meta property="og:image" content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg" />
<meta property="og:url" content="http://hyerin1225.dothome.co.kr/EIBooks" />
<title>EIBooks</title>
<link rel="icon" href="images/favicon.png">
<link rel="apple-touch-icon" href="images/favicon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/EIBooks/styles/css/jquery-ui.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/swiper-bundle.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/aos.css">
<link rel="stylesheet" href="/EIBooks/styles/css/common.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/header.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/footer.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/main.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaWrite.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<title>review/replyList.jsp</title>
<script>
$(document).ready( function() {
    
    $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
    $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다

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

<%@ include file="../common/menu.jsp" %>
<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<header id="header"></header>
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
	<footer id="footer"></footer>
</div>	

</body>
</html>