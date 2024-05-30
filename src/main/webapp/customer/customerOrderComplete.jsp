<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="eibooks.dao.OrderDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
	// 주문한 고객 정보 불러오기
	int cus_seq = (int)session.getAttribute("cus_seq");
	
	// OrderDAO 인스턴스 생성
	OrderDAO orderDAO = new OrderDAO();
	
	// 주문 목록을 가져옵니다.
	Map<String, String> map = new HashMap<>();
	map.put("cus_seq", String.valueOf(cus_seq));
	map.put("amount", "1");
	map.put("offset", "0");
	map.put("orderBy", "recent");
	List<OrderDTO> orderList = orderDAO.getCustomerOrder(map);

	// 가장 최근의 주문을 가져옵니다.
	OrderDTO recentOrder = null;
	if (!orderList.isEmpty()) {
	    recentOrder = orderList.get(0);
	}
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
  <link rel="stylesheet" href="/EIBooks/styles/css/cart/customerOrderComplete.css?v=<?php echo time(); ?>">
  <script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
  <script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
  <script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
  <script src="/EIBooks/styles/js/aos.js"></script>
  <script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
  <script type="text/javascript">   
	$(document).ready(function() {
	
	    // .arrow_icon 클릭 시 셀렉트 요소 클릭 트리거
	    $('.select_container').on('click', '.arrow_icon', function() {
	        $('#mySelect').click();
	    });
	});
	    // AJAX 요청 보내기
	    xhr.send("cus_seq=" + encodeURIComponent(cusSeq));
	}
   </script>
<title>주문 완료</title>

</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<div id="customer_wrap" class="customer">
	<!-- 헤더 -->

	<main id="container">
		<div class="inner">
			<h1>주문 완료</h1>
			<div class = "done">
				<strong>주문이 완료되었습니다.</strong>
				<span>자세한 주문 내역은 주문 내역 확인을 통하여 확인 가능합니다.</span>
				<% if (recentOrder != null) { %>
				<p>주문 번호 : <%= recentOrder.getPur_i_seq() %></p>
				<p>주문 일자 : <%= recentOrder.getOrderDate() %></p>
				<% } else { %>
					<p>주문 정보를 찾을 수 없습니다.</p>
				<% } %>
				<div>
					<button type="button" onclick="location.href='/EIBooks/'">메인으로 이동</button>
					<button type="button" onclick="location.href='/EIBooks/customer/myPage.or'">주문 내역 확인</button>
				</div>
			</div>
		</div>
	</main>
</div>
<!-- footer -->

</body>
</html>
