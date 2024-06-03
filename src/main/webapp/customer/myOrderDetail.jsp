<%@page import="eibooks.dao.ReviewDAO" %>
<%@page import="eibooks.dto.ReviewDTO" %>
<%@page import="eibooks.dto.OrderDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    OrderDTO order = (OrderDTO) request.getAttribute("order");
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/mypage/myOrderDetail.css?v=<?php echo time(); ?>">
</head>
<body>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<!-- 제목 -->
<div id="wrap">
    <%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="mypage">
                <div class="side_menu_wrap">
                    <h2>마이페이지</h2>
                    <ul class="side_menu">
                        <li class="list_mypage">
                            <a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
                        </li>
                        <li>
                            <a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
                        </li>
                        <li>
                            <a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
                        </li>
                        <li>
                            <a href="/EIBooks/orderQna/qnaList.oq">1:1문의 내역</a>
                        </li>
                    </ul>
                </div>
                <!-- 컨텐츠 부분 -->
                <div class="content">
                    <div class="tit_wrap">
                        <h1>주문 상세내역</h1>
                    </div>
                    <div class="user_info">
                        <div class="delivery_info">
                            <div class="number_orderdate">
                                <span>주문번호&nbsp;<%=order.getPur_seq() %></span>
                                <span><%=order.getOrderDate() %></span>
                            </div>
                            <div class="info_bottom">
                                <div class="name">
                                    <strong><%=order.getCustomerInfo().getName() %>
                                    </strong>
                                </div>
                                <div class="tel">
                                    <span><%=order.getCustomerInfo().getTel() %></span>
                                </div>
                                <% if (!order.getCustomerInfo().getEmail().equals("")) {%>
                                <div class="email">
                                    <span><%=order.getCustomerInfo().getEmail() %></span>
                                </div>
                                <% } %>
                                <div class="postal_code">
                                    <span><%=order.getCustomerInfo().getAddrInfo().getPostalCode() %></span>
                                </div>
                                <div class="address">
                                    <span><%=order.getCustomerInfo().getAddrInfo().getAddr() %></span>
                                    <% if (!order.getCustomerInfo().getAddrInfo().getAddr_detail().equals("")) {%>
                                    <span><%=order.getCustomerInfo().getAddrInfo().getAddr_detail() %></span>
                                    <% } %>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="order_info_wrap">
                        <h2>총 <%=orderList.size() %>권</h2>
                        <div class="card_area">
                            <% for (OrderDTO orderItem : orderList) { %>
                            <div class="card">
                                <div class="card_left">
                                    <div class="img_wrap">
                                        <img src="<%=orderItem.getBookInfo().getImageFile() %>" alt="표지이미지">
                                    </div>
                                    <div class="description">
                                        <strong><%=orderItem.getBookInfo().getTitle() %>
                                        </strong>
                                        <span><%=orderItem.getBookInfo().getPrice() * orderItem.getPur_i_count() %>원</span>
                                        <span><%=orderItem.getPur_i_count() %>권</span>
                                    </div>
                                </div>
                                <div class="card_right">
                                    <%
                                        ReviewDTO dto = new ReviewDTO();
                                        dto.setPur_i_seq(orderItem.getPur_i_seq());
                                        ReviewDAO dao = new ReviewDAO();
                                        dto = dao.selectView(dto);
                                        System.out.println(dto);

                                        if (dto != null) {
                                    %>
                                    <a class="btn update" href="../review/reviewUpdate.do?bookNum=<%=orderItem.getBook_seq()%>&pur_i_seq=<%=orderItem.getPur_i_seq()%>&reviewNum=<%=dto.getReviewNum()%>">
                                        리뷰 수정</a>
                                    <% } else { %>
                                    <a class="btn write" href="./reviewWrite.do?bookNum=<%=orderItem.getBook_seq()%>&pur_seq=<%=orderItem.getPur_seq()%>&pur_i_seq=<%=orderItem.getPur_i_seq()%>">
                                        리뷰 작성</a>
                                    <% } %>
                                </div>

                            </div>
                            <% } %>
                            </tr>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>
