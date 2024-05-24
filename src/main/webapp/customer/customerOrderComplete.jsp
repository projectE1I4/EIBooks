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
<title>customerOrder</title>

</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<h2>주문이 완료되었습니다.</h2>
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

</body>
</html>
