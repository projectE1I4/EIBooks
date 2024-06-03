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
<html lang="ko">
<%@ include file="/common/head.jsp" %>
  <link rel="stylesheet" href="/EIBooks/styles/css/cart/customerCart.css?v=<?php echo time(); ?>">
  </head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
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

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
    	        document.getElementById("price" + cartISeq).innerText =  numberWithCommas(response.totalPrice) + "원";
    	        document.getElementById("totalPrice").innerText = numberWithCommas(response.totalCartPrice - 3000) + "원";
    	        document.getElementById("totalCartPrice").innerText = numberWithCommas(response.totalCartPrice) + "원";
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
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
<%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <h1> 장바구니</h1>

            <input type = "button" onclick="deleteAll();" value="장바구니 비우기"/>

            <!-- 장바구니 목록 -->
            <div class="cart_area">
            <div class="cart_wrap">
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
                        <p id="price<%= cartItem.getCartISeq() %>">
                        <%String sCartPrice = String.format("%,d", cartItem.getBookInfo().getPrice() * cartItem.getCartICount()); %>
	                	<%=sCartPrice %>원
                        </p>
                        <form id="updateForm<%= cartItem.getCartISeq() %>" action="updateCart.cc" method="post">
                            <div class=button>
                                <input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
                                <button type="button" onclick="decreaseBtn(<%= cartItem.getCartISeq() %>)">-</button>
                                <input id="quantity<%= cartItem.getCartISeq() %>" type="number" name="cartICount" value="<%= cartItem.getCartICount() %>"
                                       min="1" readonly margin: 0 10px;">
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
            </div>
            <!-- 총 가격 표시 -->
            <div class="order_wrap">
            <div class = "order">
                <p>상품 금액<span id="totalPrice">
	                <%String sPrice = String.format("%,d", totalCartPrice - 3000); %>
	                <%=sPrice %>원
                </span></p>
                <p>배송비<span>+ 3,000 원</span></p>
                <p>결제 예정 금액<span id="totalCartPrice">
                	<%String sTotalPrice = String.format("%,d", totalCartPrice); %>
	                <%=sTotalPrice %>원
                </span></p>
                <button id="orderBtn" type="button" onclick="submitOrder()">주문하기</button>
            </div>
            </div>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>

