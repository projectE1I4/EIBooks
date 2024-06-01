<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int bookCnt = (int)request.getAttribute("bookCnt");
int cusCnt = (int)request.getAttribute("cusCnt");
int purCnt = (int)request.getAttribute("purCnt");
int reCnt = (int)request.getAttribute("reCnt");
int qCnt = (int)request.getAttribute("qCnt");
int oqCnt = (int)request.getAttribute("oqCnt");
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
			<div class="admin_do_wrap">
			<div class="box_wrap one_box">
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
			<div class="box_wrap one_box">
				<h3>주문 관리</h3>
				<div class="content">
					<div class="box">
						<a href="/EIBooks/admin/orderList.or">
						<strong><%=purCnt %></strong>
						전체 주문 확인
						</a>
					</div>
				</div>
			</div>
			<div class="box_wrap one_box">
				<h3>리뷰 관리</h3>
				<div class="content">
					<div class="box">
						<a href="/EIBooks/review/replyList.do">
							<strong><%=reCnt %></strong>
							전체 리뷰 확인					
						</a>
					</div>
				</div>
			</div>
			<div class="box_wrap">
				<h3>문의 관리</h3>
				<div class="content">
					<div class="box">
						<a href="/EIBooks/qna/reply.qq">
						<strong><%=qCnt %></strong>
						전체 상품<br>문의 확인</a>
					</div>
					<div class="box">
						<a href="/EIBooks/orderQna/reply.oq">
						<strong><%=oqCnt %></strong>						
						전체 1:1<br>문의 확인</a>
					</div>
				</div>
			</div>
			<div class="box_wrap one_box">
				<h3>마이 페이지</h3>
				<div class="content">
					<div class="box">
						<a class="link_btn2" href="/EIBooks/customer/myPage.or">
							관리자<br>마이 페이지					
						</a>
					</div>
				</div>
			</div>
			</div>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>