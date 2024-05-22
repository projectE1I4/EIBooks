<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //장바구니 리스트 가져오기
    List<cartDTO> cartList = (List<cartDTO>)request.getAttribute("cartList");
    cartDTO cartdto = new cartDTO();   
    int totalCartPrice = (int)request.getAttribute("totalCartPrice");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 장바구니 목록 보기</title>
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>회원 장바구니 보기</h2>
<button id="selectAllBtn" type="button">전체 </button>
<button id="deleteSelectedBtn" type="button"> 선택 삭제 </button>


<!-- 장바구니 목록 -->
<form id="cartForm" action="deleteSelectedItems.cc" method="post">
	<table border="1" width="95%">
	<tr>
		<th width="3%">선택</th>
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
	
	    for(cartDTO cartItem : cartList) {
	        // 이전 항목과 현재 항목이 동일한지 확인
	        boolean isSameItem = prevItem != null && prevItem.getBookInfo().getBook_seq() == cartItem.getBookInfo().getBook_seq();
	        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
	%>
	<tr>
		<td><input type="checkbox" name="selectedItems" value=<%= cartItem.getCartISeq() %>></td>
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
	<%
	        } // if(!isSameItem)
	        prevItem = cartItem; // 현재 항목을 이전 항목으로 설정
	    }
	}
	%>
	<tr>
	
	</tr>
	</table>
</form>
<!-- 총 가격 표시 -->
<div>
    <h3>총 가격: <span id="totalPrice"><%=totalCartPrice - 3000 %></span>원</h3>
    <h3>배송비: <span>3000</span>원</h3>
    <h3>총 가격: <span id="totalCartPrice"><%=totalCartPrice %></span>원</h3>
    <button type="button">주문하기</button>
</div>

<script>
// 전체 선택 토글
var isAllChecked = false;
document.getElementById("selectAllBtn").addEventListener("click", function() {
    var allItems = document.querySelectorAll("input[name='selectedItems']");
    isAllChecked = !isAllChecked;
    allItems.forEach(function(selectBox) {
        selectBox.checked = isAllChecked;
    });
});


//항목 개별 선택
document.getElementById("deleteSelectedBtn").addEventListener("click", function() {
    var selectedItems = document.querySelectorAll("input[name='selectedItems']:checked");
    if (selectedItems.length === 0) {
        alert("선택된 항목이 없습니다.");
    } else {
        document.getElementById("cartForm").submit();
    }
});


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
    getTotalPrice();
};

</script>
</body>
</html>

