<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
OrderDTO order = (OrderDTO)request.getAttribute("order");
List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>myOrderDetail.jsp</title>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>주문 상세 내역</h2>
<br>
<table border="1" width="80%">

		<tr>
			<td width="10%">주문번호</th>
		    <td colspan="3"><%=order.getPur_seq() %></td>
		</tr>
		<tr>
		    <td width="10%">주문일자</td>
		    <td colspan="3"><%=order.getOrderDate() %></td>
		</tr>
		<tr>
		    <td width="5%">수령인</th>
		    <td><%=order.getCustomerInfo().getName() %></td>
		</tr>
		<tr>
			<td width="5%">연락처</th>
		    <td><%=order.getCustomerInfo().getTel() %></td>
		</tr>
		<tr>
			<td width="5%">이메일</th>
		    <td><%=order.getCustomerInfo().getEmail() %></td>
		</tr>
		<tr>
		    <td width="5%">배송지</th>
		    <td>
		    	<ul>
		    		<li><%=order.getCustomerInfo().getAddrInfo().getAddr() %></li>
		    		<li><%=order.getCustomerInfo().getAddrInfo().getAddr_detail() %>(<%=order.getCustomerInfo().getAddrInfo().getPostalCode() %>)</li>
		    	</ul>
		    </td>
		</tr>

</table>
<br><br>

<table border="1" width="80%">
<thead>
	<th colspan="2" align="left">주문상품</th>
	<th colspan="2" align="left">총<%=orderList.size() %>권</th>
	<th align="center">리뷰</th>
</thead>

<tbody>
<% 
    if(orderList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; 주문 목록이 없습니다.</td></tr>
<% } else {
    for(OrderDTO orderItem : orderList) {
%>
<tr>
	<td width="16%">
		<img src="<%=orderItem.getBookInfo().getImageFile() %>" alt="표지이미지">
	</td>
	<td width=50%><%=orderItem.getBookInfo().getTitle() %></td>
	<td width="10%" align="center"><%=orderItem.getPur_i_count() %>권</td>
	<td width="10%" align="center"><%=orderItem.getBookInfo().getPrice() * orderItem.getPur_i_count() %>원</td>
	<td align="center"><a href="reviewWrite.do?bookNum=<%=orderItem.getBook_seq()%>&userNum=<%=orderItem.getCus_seq()%>">리뷰 작성</a></td>
</tr>
<%
	  } 
	}
%>
</tbody>
</table>

</body>
</html>