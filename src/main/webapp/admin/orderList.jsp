<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
    //��ٱ��� ����Ʈ ��������
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
<!-- ���� --> 
<h2>�ֹ� ��� ����(������)</h2>

<!-- �ֹ� ��� -->
<table border="1" width="90%">
<tr>
    <th width="8%">�ֹ� ��ȣ</th>
    <th width="17%">�ֹ��� ��</th>
    <th width="20%">���� ��</th>
    <th width="15%">�� �ݾ�</th>
    <th width="10%">�ֹ�����</th>
</tr>
<% 
    if(orderList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; �ֹ� ����� �����ϴ�.</td></tr>
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