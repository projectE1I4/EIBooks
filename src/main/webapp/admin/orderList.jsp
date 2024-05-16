<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
    //장바구니 리스트 가져오기
    List<OrderDTO> cartList = (List<OrderDTO>)request.getAttribute("orderList");
	OrderDTO cartdto = new OrderDTO();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>orderList.jsp</title>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>주문 내역 보기(관리자)</h2>


<!-- 장바구니 목록 -->
<table border="1" width="90%">
<tr>
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
    int cnt = 1;
    orderDTO prevItem = null; // 이전 항목 저장용 변수

    for(orderDTO cartItem : cartList) {
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
    } // for
} // else
%>  
</table>

</body>
</html>