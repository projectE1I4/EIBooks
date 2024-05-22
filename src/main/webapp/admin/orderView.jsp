<%@page import="eibooks.dao.OrderDAO"%>
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
<meta charset="UTF-8">
<title>orderView.jsp</title>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>주문 내역 상세 보기(관리자)</h2>
<br>
<%=order.getCustomerInfo().getCus_id() %>(<%=order.getCustomerInfo().getName() %>)님의 배송 정보
<br><br>
<table border="1" width="80%">

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
		    		<li><%=order.getCustomerInfo().getAddrInfo().getPostalCode() %></li>
		    		<li><%=order.getCustomerInfo().getAddrInfo().getAddr() %></li>
		    		<li><%=order.getCustomerInfo().getAddrInfo().getAddr_detail() %></li>
		    	</ul>
		    </td>
		</tr>

</table>
<br><br>

<%=order.getCustomerInfo().getCus_id() %>(<%=order.getCustomerInfo().getName() %>)님의 주문 내역 상세 정보
<br><br>
<table border="1" width="80%">
<tr>
    <th width="10%">주문일자</th>
    <td colspan="3"><%=order.getOrderDate() %></td>
</tr>
<tr>
	<th width="10%">주문번호</th>
    <td colspan="3"><%=order.getPur_seq() %></td>
</tr>
<tr>
	<th width="10%">총 수량 합계</th>
    <td colspan="3">
    	<%
	    	OrderDTO dto = new OrderDTO(); 
			int pur_seq = order.getPur_seq();
			dto.setPur_seq(pur_seq);
			OrderDAO dao = new OrderDAO();
			int titleCnt = dao.selectTitleCount(dto);
    	%>
    	<%=titleCnt + 1 %>권
    </td>
</tr>
<tr>
    <th width="10%">총 상품 금액 합계</th>
    <td colspan="3">
    	<%
			int totalPrice = dao.selectTotalPrice(dto);
    	%>
    	<%=totalPrice - 3000 %>원
    </td>
</tr>
<tr>
    <th width="10%">배송비</th>
    <td colspan="3">3000원</td>
</tr>
<tr>
    <th width="10%">최종 결제 금액</th>
    <td colspan="3"><%=totalPrice %>원</td>
</tr>
<% 
    if(orderList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; 주문 목록이 없습니다.</td></tr>
<% } else {
    for(OrderDTO orderItem : orderList) {
%>
<tr>
	<td>
		<img src="<%=orderItem.getBookInfo().getImageFile() %>" alt="표지이미지">
	</td>
	<td>
		<ul>
			<li><%=orderItem.getBookInfo().getTitle() %></li>
			<li>출판사 <%=orderItem.getBookInfo().getPublisher() %></li>
			<li>출간일 <%=orderItem.getBookInfo().getPubDate() %></li>
			<li>isbn <%=orderItem.getBookInfo().getIsbn13() %></li>
			
		</ul>
	</td>
	<td width="10%">총 <%=orderItem.getPur_i_count() %>권</td>
	<td width="10%">총 <%=orderItem.getBookInfo().getPrice() * orderItem.getPur_i_count() %>원</td>
</tr>
<%
	  } 
	}
%>
</table>

</body>
</html>