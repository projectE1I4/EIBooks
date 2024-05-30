<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int bookCnt = (int)request.getAttribute("bookCnt");
int cusCnt = (int)request.getAttribute("cusCnt");
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
  <meta property="og:image" content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg"/>
  <meta property="og:url" content="http://hyerin1225.dothome.co.kr/EIBooks"/>
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
  <link rel="stylesheet" href="/EIBooks/styles/css/yeon/adminMain.css?v=<?php echo time(); ?>">
  <script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
  <script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
  <script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
  <script src="/EIBooks/styles/js/aos.js"></script>
  <script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
  <script type="text/javascript">   
    
    $(document).ready(function() {
        $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
        $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다

        // .arrow_icon 클릭 시 셀렉트 요소 클릭 트리거
        $('.select_container').on('click', '.arrow_icon', function() {
            $('#mySelect').click();
        });
    });
    
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
			<div class="box_wrap">
				<h3>회원 관리</h3>
				<div class="content">
					<div class="box">
						<a href="/EIBooks/admin/customerList.cs">
							<strong><%=cusCnt %></strong>
							전체 회원
						</a>
					</div>
				</div>
			</div>
			<div class="box_wrap">
				<h3>제품 관리</h3>
				<div class="content">
					<div class="box">
						<a href="/EIBooks/admin/productList.bo">
							<strong><%=bookCnt %></strong>
							전체 제품
						</a>
					</div>
					<div class="box">
						<a class="link_btn" href="/EIBooks/admin/writeProduct.bo">제품 등록</a>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="box2">
					<a href="/EIBooks/admin/orderList.or">전체 주문 확인</a>
				</div>
				
				<div class="box2">
					<a href="/EIBooks/review/replyList.do">전체 리뷰 확인</a>
				</div>
				
				<div class="box2">
					<a href="/EIBooks/qna/reply.qq">전체 상품 문의 확인</a>
				</div>
			</div>
		</div>
	</main>
	<footer id="footer"></footer>
</div>
</body>
</html>