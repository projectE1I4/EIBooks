<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	OrderDTO order = (OrderDTO)request.getAttribute("order");
	List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/customerManage/orderView.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
	<%@ include file="../common/header.jsp" %>
	<main id="container">
		<div class="inner">
			<div class="board_list_wrap">
				<div class="content-box">
					<div class="title">
						<h2>주문 내역 상세 보기(관리자)</h2>
					</div>
					<div class="content">
						<h3>배송 정보</h3>
						<table class="orderInfo">
							<tr>
								<th>수령인</th>
								<td><%=order.getCustomerInfo().getName() %></td>
							</tr>
							<tr>
								<th>연락처</th>
								<td><%=order.getCustomerInfo().getTel() %></td>
							</tr>
							<tr>
								<th>이메일</th>
								<td><%=order.getCustomerInfo().getEmail() %></td>
							</tr>
							<tr>
								<th>배송지</th>
								<td>
									<ul>
										<li><%=order.getCustomerInfo().getAddrInfo().getPostalCode() %></li>
										<li><%=order.getCustomerInfo().getAddrInfo().getAddr() %></li>
										<li><%=order.getCustomerInfo().getAddrInfo().getAddr_detail() %></li>
									</ul>
								</td>
							</tr>
						</table>

						<h3>주문 내역 상세 정보</h3>
						<table class="orderDetails">
							<tr>
								<th>주문일자</th>
								<td colspan="3"><%=order.getOrderDate() %></td>
							</tr>
							<tr>
								<th>주문번호</th>
								<td colspan="3"><%=order.getPur_seq() %></td>
							</tr>
							<tr>
								<th>총 수량 합계</th>
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
								<th>총 상품 금액 합계</th>
								<td colspan="3">
									<%
										int totalPrice = dao.selectTotalPrice(dto);
									%>
									<%=totalPrice - 3000 %>원
								</td>
							</tr>
							<tr>
								<th>배송비</th>
								<td colspan="3">3000원</td>
							</tr>
							<tr>
								<th>최종 결제 금액</th>
								<td colspan="3"><%=totalPrice %>원</td>
							</tr>
						</table>

						<h3>주문 목록</h3>
						<table class="customerList">
							<thead>
							<tr>
								<th>이미지</th>
								<th>도서 정보</th>
								<th>수량</th>
								<th>금액</th>
							</tr>
							</thead>
							<tbody>
							<% if (orderList.isEmpty()) { %>
							<tr>
								<td colspan="4">주문 목록이 없습니다.</td>
							</tr>
							<% } else { %>
							<% for (OrderDTO orderItem : orderList) { %>
							<tr>
								<td class="image-cell"><img src="<%=orderItem.getBookInfo().getImageFile() %>" alt="표지이미지"></td>
								<td class="book-info">
									<ul>
										<li class="book-title"><%=orderItem.getBookInfo().getTitle() %></li>
										<li>출판사 <%=orderItem.getBookInfo().getPublisher() %></li>
										<li>출간일 <%=orderItem.getBookInfo().getPubDate() %></li>
										<li>ISBN <%=orderItem.getBookInfo().getIsbn13() %></li>
									</ul>
								</td>
								<td><%=orderItem.getPur_i_count() %>권</td>
								<td><%=orderItem.getBookInfo().getPrice() * orderItem.getPur_i_count() %>원</td>
							</tr>
							<% } %>
							<% } %>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>
