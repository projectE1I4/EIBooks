<%@page import="eibooks.dao.BookDAO" %>
<%@page import="eibooks.dto.BookDTO" %>
<%@page import="eibooks.dao.ReviewDAO" %>
<%@page import="eibooks.common.PageDTO" %>
<%@page import="eibooks.dto.ReviewDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
    int allReviewCount = (int) request.getAttribute("allReviewCount");
    int userNum = (int) session.getAttribute("cus_seq");
    PageDTO p = (PageDTO) request.getAttribute("paging");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/review/replyList.css?v=<?php echo time(); ?>">
</head>
<body>
<script>
    function del(reviewNum) {
        const input = confirm("리뷰를 삭제하시겠습니까?");
        if (input) {
            location.href = "<%=request.getContextPath()%>/review/depthOneDeleteProc.do?reviewNum=" + reviewNum;
        } else {
            alert("삭제를 취소했습니다.");
            return;
        }
    }
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
    <%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="review_list_area">
                <div class="tit_wrap">
                    <h1>리뷰 전체보기</h1>
                    <p class="total_count">전체 리뷰 수: <%=allReviewCount %>
                    </p>
                </div>
                <div class="review_list_wrap">
                    <ul class="review_list">
                        <% if (reviewList.isEmpty()) { %>
                        <li class="no_review"><b>리뷰가 없습니다.</b></li>
                        <% } else { %>
                        <%for (ReviewDTO dto : reviewList) {%>
                        <li class="review">
                            <ul class="review_info">
                                <li class="grade">
                                    <% for (int i = 0; i < dto.getGrade(); i++) { %>
                                    <div class="full_star"></div>
                                    <%
                                        }
                                        for (int i = 0; i < 5 - dto.getGrade(); i++) {
                                    %>
                                    <div class="empty_star"></div>
                                    <% } %>

                                    <span><%= dto.getGrade() %></span>
                                </li>
                                <li>
                                    <%= dto.getCusInfo().getCus_id() %>
                                </li>
                                <li>
                                    <%= dto.getReviewDate() %>
                                </li>
                                <%
                                    BookDTO bDto = new BookDTO();
                                    BookDAO bDao = new BookDAO();
                                    bDto.setBook_seq(dto.getBookNum());
                                    bDto = bDao.selectView(bDto);
                                %>
                                <li class="book_title"><a
                                        href="/EIBooks/admin/productView.bo?book_seq=<%=dto.getBookNum()%>"><%=bDto.getTitle() %>
                                </a></li>
                                <li><a href="/EIBooks/admin/orderView.or?pur_seq=<%=dto.getPur_seq() %>">상세 주문
                                    내역</a>
                                </li>

                                <li class="review content review_content">
                                    <%= dto.getContent() %>
                                </li>

                                <%if (!(userNum == dto.getUserNum())) {%>
                                <li class="review_btn_wrap">
                                    <a href="javascript:del('<%=dto.getReviewNum() %>')"><img
                                            src="../styles/images/delete.svg"
                                            alt="리뷰 삭제하기"/></a>
                                </li>
                                <% } %>
                            </ul>
                        </li>
                        <%} %>
                    </ul>
                </div>
                <div class="pagination">
                    <%if (p.isPrev()) {%>
                    <a class="first arrow" href="replyList.do?pageNum=1">
                        <span class="blind">첫 페이지</span>
                    </a>
                    <%} else { %>
                    <a class="first arrow off"><span class="blind">첫 페이지</span></a>
                    <% } %>

                    <%if (p.isPrev()) {%>
                    <a class="prev arrow" href="replyList.do?pageNum=<%=p.getStartPage()-1 %>">
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
                    <a class="number" href="replyList.do?pageNum=<%=i %>"><%=i %>
                    </a>
                    <%} %>
                    <%} %>

                    <%if (p.isNext()) {%>
                    <a class="next arrow" href="replyList.do?pageNum=<%=p.getEndPage()+1 %>">
                        <span class="blind">다음 페이지</span>
                    </a>
                    <%} else {%>
                    <a class="next arrow off"><span class="blind">다음 페이지</span></a>
                    <%} %>

                    <%if (p.isNext()) {%>
                    <a class="last arrow" href="replyList.do?pageNum=<%=p.getRealEnd() %>">
                        <span class="blind">마지막 페이지</span>
                    </a>
                    <%} else { %>
                    <a class="last arrow off"><span class="blind">마지막 페이지</span></a>
                    <%} %>
                </div>
                <%} %>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>