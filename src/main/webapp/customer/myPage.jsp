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
	out.print(orderList.size());
%>      
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/mypage/myOrderList.css?v=<?php echo time(); ?>">
</head>
<body>
<script type="text/javascript">
function goToPage(pur_seq) {
	location.href = "myOrderDetail.or?pur_seq=" + pur_seq;
}
</script>
<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
<%@ include file="../common/header.jsp" %>
<main id="container">
<div class="inner">
<div id="mypage">
<div class="side_menu_wrap">
<h2>마이페이지</h2>
<ul class="side_menu">
	<li>
		<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
	</li>
	<li>
		<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
	</li>
	<li>
		<a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
	</li>
	<li>
		<a href="/EIBooks/orderQna/qnaList.oq">1:1문의 내역</a>
	</li>
</ul>
</div>

<div class="content">
	<div class="tit_wrap">
		<h1>주문 조회</h1>
		<form  method="get">
		<div class="search_wrap">
			<input class="search_text" type="text" name="searchWord" <% if(searchWord != null) { %>value="<%=searchWord %>"<% } %>>
			<input class="search_btn" type="submit" value="Search" >
		</div>
		</form>
	</div>
	
	<div class="card_area">
<% 
    if(orderList.isEmpty()) { %>  
    <b>주문 목록이 없습니다.</b>
<% } else {
   	OrderDTO prevItem = null;
   	int cnt = 0;
   	out.print(orderList);
    for(OrderDTO orderItem : orderList) {
    	
    	// 이전 항목과 현재 항목이 동일한지 확인
        boolean isSameItem = prevItem != null && prevItem.getPur_seq() == orderItem.getPur_seq();
        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
        	 cnt++;
        out.print(cnt);
%>

		<div class="card_wrap">
			<div class="left_info">
				<div class="top_info">
					<span class="numbering">No.<%=cnt %></span>
					<span>주문번호 <%=orderItem.getPur_seq() %></span>
				</div>
				<div class="bottom_info">
					<span class="title"><%=orderItem.getBookInfo().getTitle() %></span>
					<% 
			    		OrderDTO dto = new OrderDTO(); 
			    		int pur_seq = orderItem.getPur_seq();
			    		dto.setPur_seq(pur_seq);
			    		OrderDAO dao = new OrderDAO();
			    		int titleCnt = dao.selectTitleCount(dto);
			    		
			    		if (titleCnt != 0) {
			    	%>
			    		<span class="etc_text">외 <%=titleCnt %>권</span>
			    	<% } %>
		    	</div>
		    	<input class="detail_btn btn" type="button" value="주문 상세 내역 보기" onclick="goToPage(<%=orderItem.getPur_seq()%>)">
			</div>
			
			<div class="right_info">
				<span><%=orderItem.getOrderDate() %></span>
				<div class="bottom_info">
					<span>수령인: <%=orderItem.getCustomerInfo().getName() %></span>
					<span class="price"><%	
					int totalPrice = dao.selectTotalPrice(dto);
				%>
				<%=totalPrice %> 원</span>
				</div>
			</div>
		</div>
<%
        } // if(!isSameItem)
        prevItem = orderItem; // 현재 항목을 이전 항목으로 설정
       
    } // for
} // else
%>  
	</div>
	
	<div class="pagination">
		<%if (p.isPrev()) {%>
		<a class="first arrow" href="myPage.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=1">
		    <span class="blind">첫 페이지</span>
		</a>
		<%} else { %>
		<a class="first arrow off"><span class="blind">첫 페이지</span></a>
		<% } %>
		
		<%if (p.isPrev()) {%>
		<a class="prev arrow" href="myPage.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getStartPage()-1%>">
		    <span class="blind">이전 페이지</span>
		</a>
		<%} else { %>
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
		<%} %>
		
		<%for (int i = p.getStartPage(); i <= p.getEndPage(); i++) {%>
		<%if (i == p.getPageNum()) {%>
		<a class="number active"><%=i %>
		</a>
		<%} else {%>
		<a class="number" href="myPage.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=i%>"><%=i %>
		</a>
		<%} %>
		<%} %>
		
		<%if (p.isNext()) {%>
		<a class="next arrow" href="myPage.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getEndPage()+1%>">
		    <span class="blind">다음 페이지</span>
		</a>
		<%} else { %>
		<a class="next arrow off"><span class="blind">다음 페이지</span></a>
		<%} %>
		
		<%if (p.isNext()) {%>
		<a class="last arrow" href="myPage.or?<% if(searchWord != null) { %>searchWord=<%=searchWord %>&<%}%>pageNum=<%=p.getRealEnd()%>">
		    <span class="blind">마지막 페이지</span>
		</a>
		<%} else {%>
		<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
		<%} %>
	</div>
</div>
</div>
</div>
</main>
</div>
</body>
</html>