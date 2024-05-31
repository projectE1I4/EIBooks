<%@page import="eibooks.dao.cartDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //장바구니 리스트 가져오기
    List<cartDTO> cartList = (List<cartDTO>)request.getAttribute("cartList");
    cartDTO cartdto = new cartDTO();   
    int totalCartPrice = (int)request.getAttribute("totalCartPrice");
    String title = request.getParameter("title");
    int cus_seq = (int) session.getAttribute("cus_seq");
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
  <link rel="stylesheet" href="/EIBooks/styles/css/cart/customerCart.css?v=<?php echo time(); ?>">
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
	
	    
	function deleteAll() {
	    
	    var cusSeq = "<%=cus_seq %>";
	     if (!cusSeq) {
	         alert("Customer sequence is not set.");
	         return;
	     }
	     
	    var xhr = new XMLHttpRequest();
	    xhr.open("POST", "<%=request.getContextPath()%>/deleteCartAll.cc", true);
	    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4 && xhr.status === 200) {
	            // 요청이 성공적으로 완료되면 페이지 리다이렉트
	            window.location.href = "./customerCartOut.cc";
	        }
	    };
	
	    // AJAX 요청 보내기
	    xhr.send("cus_seq=" + encodeURIComponent(cusSeq));
	}
   </script>
   
   
<title>회원 장바구니 목록 보기</title>
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/header.jsp" %>

<div id="customer_wrap" class="customer">
	<!-- 헤더 -->

	<main id="container">
		<div class="inner">
			<h1> 장바구니</h1>
			
			<input type = "button" onclick="deleteAll();" value="장바구니 비우기"/>

			<!-- 장바구니 목록 -->
			<form id="cartForm" method="post">
				<% 
				    if(cartList.isEmpty()) { %>  
				    <p class = "cart_empty">장바구니에 아무것도 없습니다.</p>
				<% } else {
				    cartDTO prevItem = null; // 이전 항목 저장용 변수
				    Map<String, Integer> map = new HashMap<>();
				    for(cartDTO cartItem : cartList) {
				        // 이전 항목과 현재 항목이 동일한지 확인
				        boolean isSameItem = prevItem != null && prevItem.getBookInfo().getBook_seq() == cartItem.getBookInfo().getBook_seq();
				        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
				%>
				<div class = "list_left">
				    <img src="<%=cartItem.getBookInfo().getImageFile() %>">
				    <ul>
						<li><%=cartItem.getBookInfo().getTitle() %></li>
					    <li>출판사&nbsp;&nbsp;&nbsp;&nbsp;<%=cartItem.getBookInfo().getPublisher() %></li>
					    <li>출간일&nbsp;&nbsp;&nbsp;&nbsp;<%=cartItem.getBookInfo().getPubDate() %></li>
					    <li>ISBN&nbsp;&nbsp;&nbsp;&nbsp;<%=cartItem.getBookInfo().getIsbn13() %></li>	    
				    </ul>
				    <ul class = "quantity"> <!-- 수량 업데이트 -->
						<p id="price<%= cartItem.getCartISeq() %>"><%=cartItem.getBookInfo().getPrice() * cartItem.getCartICount()%>원</p>
				    	<form id="updateForm<%= cartItem.getCartISeq() %>" action="updateCart.cc" method="post">
				        	<div class=button>
				        	<input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
					            <button type="button" onclick="decreaseBtn(<%= cartItem.getCartISeq() %>)">-</button>
					            <input id="quantity<%= cartItem.getCartISeq() %>" type="number" name="cartICount" value="<%= cartItem.getCartICount() %>"
					            min="1" readonly style="width: 30px; margin: 0 10px;">
					            <button type="button" onclick="increaseBtn(<%= cartItem.getCartISeq() %>)">+</button>
				        	</div>
			    		</form>
				    </ul>

					<form action="deleteCart.cc" method="post" class = "delete">
			            <input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
			            <button type="submit">삭제</button>
			        </form>
				</div>

			<% 
			        } // if(!isSameItem) 
			        prevItem = cartItem; // 현재 항목을 이전 항목으로 설정
			    }
			    
			    map.put("totalCartPrice", totalCartPrice);
				session.setAttribute("map", map);
			}
			%>
			</form>
			<!-- 총 가격 표시 -->
			<div class = "order">
				<p>상품 금액<span id="totalPrice"><%=totalCartPrice - 3000 %> 원</span></p>
				<p>배송비<span>+ 3000 원</span></p>
				<p>결제 예정 금액<span id="totalCartPrice"><%=totalCartPrice %> 원</span></p>
		    	<button id="orderBtn" type="button" onclick="submitOrder()">주문하기</button>
			</div>
		</div>		
	</main>

</div>
 
<script>
//주문 제출 함수
function submitOrder() {
    // 장바구니가 비어 있는지 확인
    var cartList = document.getElementById("cartForm");
    if (cartList.getElementsByClassName("list_left").length === 0) {
        alert("장바구니에 아무것도 없습니다.");
        return;
    }
	console.log("버튼 눌림");
	location.href="<%=request.getContextPath()%>/customerBuyOrders.cc";
}



//수량 증가 함수
function increaseBtn(cartISeq) {
    var inputField = document.querySelector("#quantity" + cartISeq);
    inputField.stepUp(1);
    updateCart(cartISeq, inputField.value); // AJAX 요청 보내기
}

// 수량 감소 함수
function decreaseBtn(cartISeq) {
    var inputField = document.querySelector("#quantity" + cartISeq);
    inputField.stepDown(1);
    updateCart(cartISeq, inputField.value); // AJAX 요청 보내기
}

// AJAX 요청 함수
function updateCart(cartISeq, cartICount) {
	//객체 생성
    var xhr = new XMLHttpRequest();
	//open()메서드 사용하여 요청 설정
    xhr.open("POST", "updateCart.cc", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //onreadystatechange => 서버로부터의 응답 처리
    xhr.onreadystatechange = function() {
    	 if (xhr.readyState == 4 && xhr.status == 200) {
    	        var response = JSON.parse(xhr.responseText);
    	        console.log("변동됨");
    	        document.getElementById("price" + cartISeq).innerText = response.totalPrice + "원";
    	        document.getElementById("totalPrice").innerText = response.totalCartPrice - 3000;
    	        document.getElementById("totalCartPrice").innerText = response.totalCartPrice;
    	    }
    };
    var cusSeq = document.body.getAttribute('data-cus-seq'); // cusSeq 값을 읽어옵니다.
    xhr.send("cartISeq=" + cartISeq + "&cartICount=" + cartICount + "&cusSeq=" + cusSeq);
}

// 페이지 로드 시 총 가격 가져오기
window.onload = function() {
	//totalCartPrice();
};

</script>
</body>
</html>

