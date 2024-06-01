<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int bookCnt = (int)request.getAttribute("bookCnt");
int cusCnt = (int)request.getAttribute("cusCnt");
%>    
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/adminMain.css?v=<?php echo time(); ?>">
</head>
<body>
<script>
	$(document).ready(function() {
		// .arrow_icon 클릭 시 셀렉트 요소 클릭 트리거
		$('.select_container').on('click', '.arrow_icon', function() {
			$('#mySelect').click();
		});
	});
</script>
<div id="skip_navi">
	<a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
	<%@ include file="/common/header.jsp" %>
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
				
				<div class="box2">
					<a href="/EIBooks/orderQna/reply.oq">전체 1:1 문의 확인</a>
				</div>
			</div>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>