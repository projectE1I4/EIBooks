<%@page import="eibooks.dao.OrderDAO" %>
<%@page import="eibooks.dto.OrderDTO" %>
<%@page import="eibooks.common.PageDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 주문 목록 리스트 가져오기
    List<OrderDTO> orderList = (List<OrderDTO>) request.getAttribute("orderList");
    PageDTO p = (PageDTO) request.getAttribute("paging");
    int totalCount = (int) request.getAttribute("totalCount");
    String orderBy = (String) request.getAttribute("orderBy");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/customerManage/orderList.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<script type="text/javascript">
    function goToPage(pur_seq) {
        location.href = "orderView.or?pur_seq=" + pur_seq;
    }
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
    <%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="customerOrder" class="board_list_wrap">
                <div class="top">
                    <div class="title">
                        <h2>주문 내역 확인하기</h2>
                    </div>
                    <div class="sort">
                        <ul>
                            <li class="<%= "recent".equals(orderBy) ? "selected" : "" %>">
                                <a href="orderList.or?orderBy=recent">최신순</a>
                            </li>
                            <li class="<%= "old".equals(orderBy) ? "selected" : "" %>">
                                <a href="orderList.or?orderBy=old">오래된순</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="content">
                    <table class="customerList">
                        <caption>주문 목록 테이블</caption>
                        <thead class="col">
                        <tr>
                            <th class="col1">주문 번호</th>
                            <th class="col2">주문자 명</th>
                            <th class="col3">도서 명</th>
                            <th class="col4">총 금액</th>
                            <th class="col5">주문일자</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (orderList.isEmpty()) { %>
                        <tr>
                            <td colspan="5">&nbsp; 주문 목록이 없습니다.</td>
                        </tr>
                        <% } else {
                            OrderDTO prevItem = null;
                            for (OrderDTO orderItem : orderList) {
                                boolean isSameItem = prevItem != null && prevItem.getPur_seq() == orderItem.getPur_seq();
                                if (!isSameItem) {
                        %>
                        <tr onclick="goToPage(<%=orderItem.getPur_seq()%>)">
                            <td><%=orderItem.getPur_seq() %></td>
                            <td><%=orderItem.getCustomerInfo().getName() %></td>
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
                            <td><%=orderItem.getOrderDate() %></td>
                        </tr>
                        <%
                                    }
                                    prevItem = orderItem;
                                }
                            } %>
                        </tbody>
                    </table>
                    <div class="pagination">
                        <% if (totalCount == 0) { %>
                        <a class="number active">1</a>
                        <% } else { %>
                        <% if (p.isPrev()) { %>
                        <a class="first arrow" href="orderList.or?<% if(orderBy != null) { %>orderBy=<%=orderBy %>&<%}%>pageNum=1">
                            <span class="blind">첫 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="first arrow off"><span class="blind">첫 페이지</span></a>
                        <% } %>

                        <% if (p.isPrev()) { %>
                        <a class="prev arrow" href="orderList.or?<% if(orderBy != null) { %>orderBy=<%=orderBy %>&<%}%>pageNum=<%=p.getStartPage()-1%>">
                            <span class="blind">이전 페이지</span></a>
                        <% } else { %>
                        <a class="prev arrow off"><span class="blind">이전 페이지</span></a>
                        <% } %>

                        <% for (int i = p.getStartPage(); i <= p.getEndPage(); i++) { %>
                        <% if (i == p.getPageNum()) { %>
                        <a class="number active"><%=i %></a>
                        <% } else { %>
                        <a class="number" href="orderList.or?<% if(orderBy != null) { %>orderBy=<%=orderBy %>&<%}%>pageNum=<%=i %>"><%=i %></a>
                        <% } %>
                        <% } %>
                        <% if (p.isNext()) { %>
                        <a class="next arrow" href="orderList.or?<% if(orderBy != null) { %>orderBy=<%=orderBy %>&<%}%>pageNum=<%=p.getEndPage()+1%>">
                            <span class="blind">다음 페이지</span></a>
                        <% } else { %>
                        <a class="next arrow off"><span class="blind">다음 페이지</span></a>
                        <% } %>

                        <% if (p.isNext()) { %>
                        <a class="last arrow" href="orderList.or?<% if(orderBy != null) { %>orderBy=<%=orderBy %>&<%}%>pageNum=<%=p.getRealEnd()%>">
                            <span class="blind">마지막 페이지</span></a>
                        <% } else { %>
                        <a class="last arrow off"><span class="blind">마지막 페이지</span></a>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>