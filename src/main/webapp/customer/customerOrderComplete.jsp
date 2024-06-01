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
<html lang="ko">
	<%@ include file="/common/head.jsp" %>
	<link rel="stylesheet" href="/EIBooks/styles/css/cart/customerOrderComplete.css?v=<?php echo time(); ?>">
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
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
<%@ include file="../common/header.jsp" %>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<main id="container">
		<div class="inner">
			<div id="complete">
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
		</div>
	</main>
<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>
