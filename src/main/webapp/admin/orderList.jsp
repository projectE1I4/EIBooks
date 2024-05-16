<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
    //��ٱ��� ����Ʈ ��������
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
<!-- ���� --> 
<h2>�ֹ� ���� ����(������)</h2>


<!-- ��ٱ��� ��� -->
<table border="1" width="90%">
<tr>
    <th width="8%">���� ��ȣ</th>
    <th width="17%">���� �̹���</th>
    <th width="20%">���� ����</th>
    <th width="15%">���ǻ�</th>
    <th width="10%">�Ⱓ��</th>
    <th width="10%">ISBN</th>
    <th width="10%">����</th>
    <th width="10%">����</th>
</tr>
<% 
    if(cartList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; ��ٱ��Ͽ� �ƹ��͵� �����ϴ�.</td></tr>
<% } else {
    int cnt = 1;
    orderDTO prevItem = null; // ���� �׸� ����� ����

    for(orderDTO cartItem : cartList) {
        // ���� �׸�� ���� �׸��� �������� Ȯ��
        boolean isSameItem = prevItem != null && prevItem.getBookInfo().getBook_seq() == cartItem.getBookInfo().getBook_seq();
        if(!isSameItem) { // ���� �׸�� �ٸ� ��쿡�� ǥ��
%>
<tr>
    <td><%=cartItem.getBookInfo().getBook_seq() %></td>
    <td><img src="<%=cartItem.getBookInfo().getImageFile() %>"></td>
    <td><%=cartItem.getBookInfo().getTitle() %></td>
    <td><%=cartItem.getBookInfo().getPublisher() %></td>
    <td><%=cartItem.getBookInfo().getPubDate() %></td>
    <td><%=cartItem.getBookInfo().getIsbn13() %></td>
    <td><%=cartItem.getBookInfo().getPrice() %>��</td>
    <td>
        <form action="deleteCart.cc" method="post">
            <input type="hidden" name="cartISeq" value="<%= cartItem.getCartISeq() %>">
            <button type="submit">����</button>
        </form>
    </td>
</tr>
<%
        } // if(!isSameItem)

        prevItem = cartItem; // ���� �׸��� ���� �׸����� ����
    } // for
} // else
%>  
</table>

</body>
</html>