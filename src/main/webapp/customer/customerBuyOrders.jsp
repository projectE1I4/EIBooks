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
  <link rel="stylesheet" href="/EIBooks/styles/css/cart/customerBuyOrders.css?v=<?php echo time(); ?>">
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
   </script>
   
<title>장바구니 주문하기</title>
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
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<h2>주문 / 결제</h2>

<form id="cartForm" action="customerBuyOrder.cc" method="post">
    <table border="1" width="95%">
        <tr>
            <th>수령자명</th>
            <td><%= customer.getName() %></td>
        </tr>
        <tr>
            <th>연락처</th>
            <td><%= customer.getTel() %></td>
        </tr>
        <tr>
            <th>이메일</th>
            <td><%= customer.getEmail() %></td>
        </tr>
        <tr>
            <th>배송지</th>
            <td>
                <%= addrInfo.getPostalCode() %><br>
                <%= addrInfo.getAddr() %><br>
                <%= addrInfo.getAddr_detail() %>
            </td>
        </tr>
        
        <tr>
        	<th width="20%">이미지</th>
        	<th width="20%">도서명</th>
        	<th width="20%">수량</th>
        	<th width="20%">가격</th>
        </tr>
        <% for (cartDTO dto : cartList) { %>
        <tr>
        	<td><img src="<%=dto.getBookInfo().getImageFile() %>"></td>
        	<td><%=dto.getBookInfo().getTitle() %></td>
        	<td><%=dto.getCartICount() %>권</td>
        	<td><%=dto.getBookInfo().getPrice() %>원</td>
        </tr>
        <% } %>
    </table>

</form>
<div>
	<h3>총 가격: <span id="totalPrice"><%=map.get("totalCartPrice") - 3000 %></span>원</h3>
    <h3>배송비: <span>3000</span>원</h3>
    <h3>총 가격: <span id="totalCartPrice"><%=map.get("totalCartPrice") %></span>원</h3>
    <button type="button" id="buyButton" onclick="buy();">결제하기</button>
</div>

</body>
</html>