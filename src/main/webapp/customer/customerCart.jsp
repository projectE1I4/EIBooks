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
        $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
        $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다

        // .arrow_icon 클릭 시 셀렉트 요소 클릭 트리거
        $('.select_container').on('click', '.arrow_icon', function() {
            $('#mySelect').click();
        });
    });
    
        
        function deleteAll() {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "<%=request.getContextPath()%>/deleteCartAll", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // 요청이 성공적으로 완료되면 페이지 리다이렉트
                    window.location.href = "./customerCartOut.cc";
                }
            };

            // AJAX 요청 보내기
            xhr.send("cus_seq=<%=session.getAttribute("cus_seq").toString() %>");
        }
    
    
   </script>
<title>회원 장바구니 목록 보기</title>
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>

<div id="customerCart_wrap">
	<!-- 헤더 -->
	<header id="header"></header>

	<main id="container">
		<div class="inner">
			<h1> 장바구니</h1>

<!-- 장바구니 목록 -->
<input type=button onclick="deleteAll()" value="전체 삭제"/>
<form id="cartForm" method="post">
	<table border="1" width="95%">
	<ul>
	    <th width="7%">도서 번호</th>
	    <th width="15%">도서 이미지</th>
	    <th width="15%">도서 제목</th>
	    <th width="10%">출판사</th>
	    <th width="10%">출간일</th>
	    <th width="10%">ISBN</th>
	    <th width="10%">수량</th>
	    <th width="10%">가격</th>
	    <th width="10%">삭제</th>
	</tr>
	<% 
	    if(cartList.isEmpty()) { %>  
	    <tr><td colspan="8">&nbsp; 장바구니에 아무것도 없습니다.</td></tr>
	<% } else {
	    cartDTO prevItem = null; // 이전 항목 저장용 변수
	    Map<String, Integer> map = new HashMap<>();
	    for(cartDTO cartItem : cartList) {
	        // 이전 항목과 현재 항목이 동일한지 확인
	        boolean isSameItem = prevItem != null && prevItem.getBookInfo().getBook_seq() == cartItem.getBookInfo().getBook_seq();
	        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
	%>
	<tr>
	    <td><%=cartItem.getBookInfo().getBook_seq() %></td>
	    <td><img src="<%=cartItem.getBookInfo().getImageFile() %>"></td>
	    <td><%=cartItem.getBookInfo().getTitle() %></td>
	    <td><%=cartItem.getBookInfo().getPublisher() %></td>
	    <td><%=cartItem.getBookInfo().getPubDate() %></td>
	    <td><%=cartItem.getBookInfo().getIsbn13() %></td>
	    
	    <td>
	    <!-- 수량 업데이트 -->
	     <form id="updateForm<%= cartItem.getCartISeq() %>" action="updateCart.cc" method="post" style="display: flex; align-items: center;">
        	<input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
	        <div style="display: flex; align-items: center;">
	            <button type="button" onclick="decreaseBtn(<%= cartItem.getCartISeq() %>)">-</button>
	            <input id="quantity<%= cartItem.getCartISeq() %>" type="number" name="cartICount" value="<%= cartItem.getCartICount() %>"
	            min="1" readonly style="width: 30px; margin: 0 10px;">
	            <button type="button" onclick="increaseBtn(<%= cartItem.getCartISeq() %>)">+</button>
	        </div>
    	</form>
    	
	    </td>
	    <td id="price<%= cartItem.getCartISeq() %>"><%=cartItem.getBookInfo().getPrice() * cartItem.getCartICount()%>원</td>
	    <td>
	    <!-- 선택된 항목 삭제 -->
        <form action="deleteCart.cc" method="post">
            <input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
            <button type="submit">삭제</button>
        </form>
	    </td>
	</tr>
	<% /*
		map.put("book_seq"+cartItem.getBookInfo().getBook_seq(), cartItem.getBook_seq());
		map.put("cartICount"+cartItem.getBookInfo().getBook_seq(), cartItem.getCartICount());
		map.put("b_id", cartItem.getBookInfo().getBook_seq()); /**/
	        } // if(!isSameItem) 
	        prevItem = cartItem; // 현재 항목을 이전 항목으로 설정
	    }
	    
	    map.put("totalCartPrice", totalCartPrice);
		session.setAttribute("map", map);
	}
	%>

	</table>
  </form>
  <!-- 총 가격 표시 -->
  <div>
      <h3>총 가격: <span id="totalPrice"><%=totalCartPrice - 3000 %></span>원</h3>
      <h3>배송비: <span>3000</span>원</h3>
      <h3>총 가격: <span id="totalCartPrice"><%=totalCartPrice %></span>원</h3>
    <button id="orderBtn" type="button" onclick="submitOrder()">주문하기</button>

    </div>
  </main>
			<!-- 장바구니 목록 -->
			<form id="cartForm" action="deleteSelectedItems.cc" method="post">
				<ul class = cart_wrap>
				    <li style="width:7%">도서 번호</li>
				    <li style="width:15%">도서 이미지</li>
				    <li style="width:15%">도서 제목</li>
				    <li style="width:10%">출판사</li>
				    <li style="width:10%">출간일</li>
				    <li style="width:10%">ISBN</li>
				    <li style="width:10%">수량</li>
				    <li style="width:10%">가격</li>
				    <li style="width:10%">삭제</li>
				</ul>
				<% 
				    if(cartList.isEmpty()) { %>  
				    <tr><td colspan="8">&nbsp; 장바구니에 아무것도 없습니다.</td></tr>
				<% } else {
				    cartDTO prevItem = null; // 이전 항목 저장용 변수
				    Map<String, Integer> map = new HashMap<>();
				    for(cartDTO cartItem : cartList) {
				        // 이전 항목과 현재 항목이 동일한지 확인
				        boolean isSameItem = prevItem != null && prevItem.getBookInfo().getBook_seq() == cartItem.getBookInfo().getBook_seq();
				        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
				%>
				<ul class = cart_list>
				    <li style="width:7%"><%=cartItem.getBookInfo().getBook_seq() %></li>
				    <li style="width:15%"><img src="<%=cartItem.getBookInfo().getImageFile() %>"></li>
				    <li style="width:15%"><%=cartItem.getBookInfo().getTitle() %></li>
				    <li style="width:10%"><%=cartItem.getBookInfo().getPublisher() %></li>
				    <li style="width:10%"><%=cartItem.getBookInfo().getPubDate() %></li>
				    <li style="width:10%"><%=cartItem.getBookInfo().getIsbn13() %></li>
				    
				    <li style="width:10%">
				    <!-- 수량 업데이트 -->
				     <form id="updateForm<%= cartItem.getCartISeq() %>" action="updateCart.cc" method="post" style="display: flex; align-items: center;">
			        	<input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
				        <div style="display: flex; align-items: center;">
				            <button type="button" onclick="decreaseBtn(<%= cartItem.getCartISeq() %>)">-</button>
				            <input id="quantity<%= cartItem.getCartISeq() %>" type="number" name="cartICount" value="<%= cartItem.getCartICount() %>"
				            min="1" readonly style="width: 30px; margin: 0 10px;">
				            <button type="button" onclick="increaseBtn(<%= cartItem.getCartISeq() %>)">+</button>
				        </div>
			    	</form>
		    	
			    </li>
			    <li style="width:10%" id="price<%= cartItem.getCartISeq() %>"><%=cartItem.getBookInfo().getPrice() * cartItem.getCartICount()%>원</li>
			    <li style="width:10%">
				    <!-- 선택된 항목 삭제 -->
			        <form action="deleteCart.cc" method="post">
			            <input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
			            <button type="submit">삭제</button>
			        </form>
			    </li>
			</ul>
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
			<div>
				<h3>총 가격: <span id="totalPrice"><%=totalCartPrice - 3000 %></span>원</h3>
				<h3>배송비: <span>3000</span>원</h3>
				<h3>총 가격: <span id="totalCartPrice"><%=totalCartPrice %></span>원</h3>
		    	<button id="orderBtn" type="button" onclick="submitOrder()">주문하기</button>
			</div>
		</div>
	
</main>
  
  
  
    <footer id="footer"></footer>
  </div>
  
  
  
  
<script>
//주문 제출 함수
function submitOrder() {
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

