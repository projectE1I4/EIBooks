<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //장바구니 리스트 가져오기
    List<cartDTO> cartList = (List<cartDTO>)request.getAttribute("cartList");
    cartDTO cartdto = new cartDTO();   
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 장바구니 목록 보기</title>
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>회원 장바구니 보기</h2>
<button id="selectAllBtn" type="button">전체 </button>
<button id="deleteSelectedBtn" type="button"> 선택 삭제 </button>


<!-- 장바구니 목록 -->
<form id="cartForm" action="deleteSelectedItems.cc" method="post">
	<table border="1" width="90%">
	<tr>
		<th width="5%">선택</th>
	    <th width="8%">도서 번호</th>
	    <th width="17%">도서 이미지</th>
	    <th width="20%">도서 제목</th>
	    <th width="15%">출판사</th>
	    <th width="10%">출간일</th>
	    <th width="10%">ISBN</th>
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
	    <td><%=cartItem.getBookInfo().getPrice() %>원</td>
	    <td>
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
	</table>
</form>
<script>

//전체 선택 체크박스 클릭 시
var isAllChecked = false;
document.getElementById("selectAllBtn").addEventListener("click", function() {
    var allItems = document.querySelectorAll("input[name='selectedItems']");
    isAllChecked = !isAllChecked; // 상태를 반전시킴
    allItems.forEach(function(selectBox) {
        console.log(selectBox.checked);
        selectBox.checked = isAllChecked; // 모든 체크박스의 상태를 설정
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
</script>
</body>
</html>
