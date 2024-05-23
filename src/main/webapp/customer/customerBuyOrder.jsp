<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
    //장바구니 리스트 가져오기
    List<cartDTO> cartList = (List<cartDTO>)request.getAttribute("cartList");
    cartDTO cartdto = new cartDTO();   
    int totalCartPrice = (int)request.getAttribute("totalCartPrice");
    int totalCount = (int)request.getAttribute("totalCount");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>customerOrder</title>
</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<h2>주문 / 결제</h2>

<!-- 장바구니 목록 -->
<form id="cartForm" action="deleteSelectedItems.cc" method="post">
    <table border="1" width="95%">
        <tr>
            <th>주문 상품</th>
            <th>총 <%=totalCount %>개</th>
        </tr>
        <% if (cartList == null || cartList.isEmpty()) { %>
            <tr><td colspan="8">구매목록에 아무것도 없습니다.</td></tr>
        <% } else { %>
            <% for (cartDTO cartItem : cartList) { %>
            <tr>
                <td><%=cartItem.getBookInfo().getBook_seq() %></td>
                <td><img src="<%=cartItem.getBookInfo().getImageFile() %>"></td>
                <td><%=cartItem.getBookInfo().getTitle() %></td>
                <td><%=cartItem.getBookInfo().getPublisher() %></td>
                <td><%=cartItem.getBookInfo().getPubDate() %></td>
                <td><%=cartItem.getBookInfo().getIsbn13() %></td>
                <td id="price<%= cartItem.getCartISeq() %>"><%=cartItem.getBookInfo().getPrice() * cartItem.getCartICount()%>원</td>
            </tr>
            <% } %>
        <% } %>
    </table>
</form>

<!-- 총 가격 표시 -->
<div>
    <h3>총 가격: <span id="totalPrice"><%=totalCartPrice - 3000 %></span>원</h3>
    <h3>배송비: <span>3000</span>원</h3>
    <h3>총 가격: <span id="totalCartPrice"><%=totalCartPrice %></span>원</h3>
</div>


</body>
</html>