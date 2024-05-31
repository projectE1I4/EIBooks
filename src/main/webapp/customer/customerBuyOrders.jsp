<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.function.Function"%>
<%@page import="eibooks.dto.AddressDTO"%>
<%@page import="eibooks.dto.CustomerDTO"%>
<%@page import="eibooks.dao.CustomerDAO"%>
<%@page import="eibooks.dao.BookDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
	// 주문한 고객 정보 불러오기
	int cus_seq = (int)session.getAttribute("cus_seq");
	
	CustomerDAO customerDAO = new CustomerDAO();
	CustomerDTO customer = customerDAO.getCustomerDetails(cus_seq);
	AddressDTO addrInfo = customer.getAddrInfo();

	// 장바구니에 담은 책 정보 불러오기
    cartDTO cartdto = new cartDTO();
    List<BookDTO> bookList = new ArrayList<>();
    BookDTO book = new BookDTO();
    //book.setBook_seq((int)request.getAttribute("book_seq"));
    
    BookDAO dao = new BookDAO();
    List<cartDTO> cartList = (List<cartDTO>)request.getAttribute("cartList");
    int totalPrice = (int)request.getAttribute("totalPrice");
    
    BookDTO resultBook = dao.getBook(book);
    
    // 결제하기 버튼 클릭 시 값을 map에 할당
    Map<String, Integer> map = (Map<String, Integer>) session.getAttribute("map");
    session.setAttribute("cartMap", map);
   

%>
<!DOCTYPE html>
	<html lang="ko">
	<%@ include file="/common/head.jsp" %>
  	<link rel="stylesheet" href="/EIBooks/styles/css/cart/customerBuyOrders.css?v=<?php echo time(); ?>">
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<script type="text/javascript">   
	$(document).ready(function() {
	
	    // .arrow_icon 클릭 시 셀렉트 요소 클릭 트리거
	    $('.select_container').on('click', '.arrow_icon', function() {
	        $('#mySelect').click();
	    });
	});
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
$(function(){
	
})

function buy() {
		console.log("try");
	    console.log("버튼눌림");
		location.href="<%=request.getContextPath()%>/cartOrder.or";
	}
</script>


<%@ include file="../common/header.jsp" %>
<div id="wrap">
	<main id="container">
		<div class="inner" style="flex-direction: column;">
			<h1>주문 / 결제</h1>
			<div class = "buyOrder">
				<div class = left>
					<form id="cartForm" action="customerBuyOrder.cc" method="post">
				    <ul>
				    	<li>
				            <p>수령자명 <span><%= customer.getName() %></span></p>
				        </li>
				        <li>
				            <p>연락처<span><%= customer.getTel() %></span></p>
				        </li>
				        <li>
				            <p>이메일<span><%= customer.getEmail() %></span></p>
				        </li>
				        <li>
				            <p>배송지<span>
				                <%= addrInfo.getPostalCode() %>, <%= addrInfo.getAddr() %>, <%= addrInfo.getAddr_detail() %>
				            </span></p>
				        </li>
				     </ul>
				        <% for (cartDTO dto : cartList) { %>
				        <div class = "book">
			        		<img src="<%=dto.getBookInfo().getImageFile() %>">
				        	<p><%=dto.getBookInfo().getTitle() %></p>
				        	<p><%=dto.getCartICount() %>권</p>
				        	<p><%=dto.getBookInfo().getPrice() %>원</p>
				    	</div>
				        <% } %>
					</form>
				</div>
				<div class = "right">
					<p>상품 금액<span id="totalPrice"><%=map.get("totalCartPrice") - 3000 %></span>원</p>
				    <p>배송비<span>+ 3000 원</span></p>
				    <p>최종 결제 금액<span id="totalCartPrice"><%=map.get("totalCartPrice") %></span>원</p>
				    <button type="button" id="buyButton" onclick="buy();">결제하기</button>
				</div>
			</div>
		</div>
	</main>
</div>
</body>
</html>