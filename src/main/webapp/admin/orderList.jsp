<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
    //장바구니 리스트 가져오기
    List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
	OrderDTO cartdto = new OrderDTO();
	int totalPrice = (int)request.getAttribute("totalPrice");
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
<h2>주문 목록 보기(관리자)</h2>

<!-- 주문 목록 -->
<table border="1" width="90%">
<tr>
    <th width="8%">주문 번호</th>
    <th width="17%">주문자 명</th>
    <th width="20%">도서 명</th>
    <th width="15%">총 금액</th>
    <th width="10%">주문일자</th>
</tr>
<% 
    if(orderList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; 주문 목록이 없습니다.</td></tr>
<% } else {
	
    for(OrderDTO orderItem : orderList) {
%>
		<tr onclick="">
		    <td><%=orderItem.getPur_seq() %></td>
		    <td><%=orderItem.getCustomerInfo().getName() %></td>
		    <td><%=orderItem.getBookInfo().getTitle() %></td>
		    <td><%=totalPrice %></td>
		    <td><%=orderItem.getOrderDate() %></td>
		</tr>
<%
    } // for
} // else
%>  
</table>

</body>
</html>