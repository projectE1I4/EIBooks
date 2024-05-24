<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="eibooks.dao.CustomerDAO"%>
<%@page import="eibooks.dto.CustomerDTO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //회원별 주문 목록 리스트 가져오기
   	int cus_seq = (int)session.getAttribute("cus_seq");
	CustomerDTO customer = new CustomerDTO();
	customer.setCus_seq(cus_seq);
	CustomerDAO cDao = new CustomerDAO();
	customer = cDao.getCustomer(customer);
	
    List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
	String searchWord = (String)request.getAttribute("searchWord");
%>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPage.jsp</title>

<script type="text/javascript">
function goToPage(pur_seq) {
	location.href = "myOrderDetail.or?pur_seq=" + pur_seq;
}
</script>

</head>
<body>

<%@ include file="../common/menu.jsp" %>

<!-- 제목 --> 
<h2>마이페이지</h2>
<ul>
	<li>
		<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
</ul>

<form  method="get">
<table width="80%">
	<tr>	
	<td align="right">
		<input type="text" name="searchWord" <% if(searchWord != null) { %>value="<%=searchWord %>"<% } %>>
		<input type="submit" value="Search" >
	</td>
	</tr>
</table>
</form>
<br>
<!-- 주문 목록 -->
<table border="1" width="80%">
<tr>
    <th width="10%">NO</th>
    <th width="20%">주문일자</th>
    <th width="15%">주문번호</th>
    <th width="12%">수령인</th>
    <th width="28%">상품 정보</th>
    <th width="15%">가격</th>
</tr>
<% 
    if(orderList.isEmpty()) { %>  
    <tr><td colspan="8">&nbsp; 주문 목록이 없습니다.</td></tr>
<% } else {
   	OrderDTO prevItem = null;
   	int cnt = 0;
    for(OrderDTO orderItem : orderList) {
    	
    	// 이전 항목과 현재 항목이 동일한지 확인
        boolean isSameItem = prevItem != null && prevItem.getPur_seq() == orderItem.getPur_seq();
        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
        	 cnt++;
%>			
		<tr onclick="goToPage(<%=orderItem.getPur_seq()%>)">
			<td align="center"><%=cnt %></td>
			<td align="center"><%=orderItem.getOrderDate() %></td>
		    <td align="center"><%=orderItem.getPur_seq() %></td>
		    <td align="center"><%=orderItem.getCustomerInfo().getName() %>
		    <td>
		    	<%=orderItem.getBookInfo().getTitle() %>
		    	<% 
		    		OrderDTO dto = new OrderDTO(); 
		    		int pur_seq = orderItem.getPur_seq();
		    		dto.setPur_seq(pur_seq);
		    		OrderDAO dao = new OrderDAO();
		    		int titleCnt = dao.selectTitleCount(dto);
		    		
		    		if (titleCnt != 0) {
		    	%>
		    		외 <%=titleCnt %>권
		    	<% } %>
		    </td>
		    <td align="right">
		    <%	
				int totalPrice = dao.selectTotalPrice(dto); 
			%>
			<%=totalPrice %>원
			</td>
		</tr>
<%
        } // if(!isSameItem)
        prevItem = orderItem; // 현재 항목을 이전 항목으로 설정
       
    } // for
} // else
%>  
	<tr>
	<td colspan="6">
	<%if(p.isPrev()) {%><a href="customerOrder.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=1">[First]</a><% } %>
	<%if(p.isPrev()) {%><a href="customerOrder.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
	<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()){%>
			<b>[<%=i %>]</b>
		<%}else{ %>
		<a href="customerOrder.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=i%>">[<%=i %>]</a>
		<%} %>
	<%} %>
	<%if(p.isNext()){%><a href="customerOrder.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
	<%if(p.isNext()){%><a href="customerOrder.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
	</td>
	</tr>
</table>
</body>
</html>