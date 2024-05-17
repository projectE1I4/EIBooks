<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //회원별 주문 목록 리스트 가져오기
    int cus_seq = (int)request.getAttribute("cus_seq");
    List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>customerOrder.jsp</title>

<script type="text/javascript">
function goToPage(pur_seq) {
	location.href = "orderView.or?pur_seq=" + pur_seq;
}
</script>

</head>
<body>

<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>주문 목록 보기(관리자)</h2>

<!-- CustomerDAO 파일 받오면 넣기 -->
님의 주문 이력
<!-- 정렬 -->
<ul>
	<li>
		<a href="customerOrder.or?cus_seq=<%=cus_seq %>&orderBy=recent">최신순</a>
	</li>
	<li>
		<a href="customerOrder.or?cus_seq=<%=cus_seq %>&orderBy=old">오래된순</a>
	</li>
</ul>

<!-- 주문 목록 -->
<table border="1" width="90%">
<tr>
    <th width="10%">주문 번호</th>
    <th width="28%">도서 명</th>
    <th width="12%">총 금액</th>
    <th width="20%">주문일자</th>
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
%>
		<tr onclick="goToPage(<%=orderItem.getPur_seq()%>)">
		    <td><%=orderItem.getPur_seq() %></td>
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
		    <td>
		    <%	
				int totalPrice = dao.selectTotalPrice(dto); 
			%>
			<%=totalPrice %>
			</td>
		    <td><%=orderItem.getOrderDate() %></td>
		</tr>
<%
        } // if(!isSameItem)

        prevItem = orderItem; // 현재 항목을 이전 항목으로 설정
    } // for
} // else
%>  
	<tr>
	<td colspan="6">
	<%if(p.isPrev()) {%><a href="customerOrder.or?pageNum=1">[First]</a><% } %>
	<%if(p.isPrev()) {%><a href="customerOrder.or?pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
	<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()){%>
			<b>[<%=i %>]</b>
		<%}else{ %>
		<a href="customerOrder.or?pageNum=<%=i%>">[<%=i %>]</a>
		<%} %>
	<%} %>
	<%if(p.isNext()){%><a href="customerOrder.or?pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
	<%if(p.isNext()){%><a href="customerOrder.or?pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
	</td>
	</tr>
</table>

</body>
</html>