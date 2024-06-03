<%@page import="eibooks.dao.ReviewDAO" %>
<%@page import="eibooks.common.PageDTO" %>
<%@page import="eibooks.dto.ReviewDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    List<ReviewDTO> reviewList = (List<ReviewDTO>) request.getAttribute("reviewList");
    int totalCount = (int) request.getAttribute("totalCount");
    String orderBy = (String) request.getAttribute("orderBy");
    String sBookNum = request.getParameter("bookNum");
    int bookNum = Integer.parseInt(sBookNum);
    int userNum = (int) session.getAttribute("cus_seq");
    String sPur_seq = request.getParameter("pur_seq");
    int pur_seq = Integer.parseInt(sPur_seq);
    String sPur_i_seq = request.getParameter("pur_i_seq");
    int pur_i_seq = Integer.parseInt(sPur_i_seq);
    PageDTO p = (PageDTO) request.getAttribute("paging");
    int reviewCount = (int) request.getAttribute("reviewCount");
    ReviewDTO myReview = (ReviewDTO) request.getAttribute("myReview");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/review/reviewList.css?v=<?php echo time(); ?>">
</head>
<body>
<script>
    $(document).ready(function () {

        $('.sort').click(function () {
            $(this).next('.sort_menu').slideToggle();
        });

        $(document).click(function (e) {
            if (!$(e.target).closest('.sort_wrap').length) {
                $('.sort_menu').slideUp();
            }
        });

        $('.sort_menu li a').click(function (e) {
            e.preventDefault();
            var selectedText = $(this).text();
            $('.sort').text(selectedText);
            $('.sort_menu').slideUp();
            window.location.href = $(this).attr('href');
        });

    });

    function validateForm(reviewCount) {
        const form = document.writeForm;
        if (reviewCount > 0) {
            console.log(reviewCount);
            alert("이미 작성한 리뷰가 있습니다. 리뷰 수정 페이지로 이동합니다.");
            location.href = "<%=request.getContextPath() %>/review/reviewUpdate.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%><% if (myReview != null) {%>&reviewNum=<%=myReview.getReviewNum()%><%}%>";
            return;
        } else if (form.content.value === "") {
            alert('내용을 입력해주세요.');
            form.content.focus();
            return;
        }

        form.submit();

    }

    function limitText(field, maxLength) {
        if (field.value.length > maxLength) {
            field.value = field.value.substring(0, maxLength);
            alert('리뷰는 최대 ' + maxLength + '자까지 작성할 수 있습니다.');
        }
    }

    function del(reviewNum) {
        const input = confirm("리뷰를 삭제하시겠습니까?");
        if (input) {
            location.href = "<%=request.getContextPath()%>/review/reviewDeleteProc.do?bookNum=<%=bookNum %>&reviewNum=" + reviewNum;
        } else {
            alert("삭제를 취소했습니다.");
            return;
        }
    }
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
    <%@ include file="../common/header.jsp" %>
    
    <main id="container">
        <div class="inner">
            <div id="review_list_area">
                <h1 class="write_tit">리뷰 작성</h1>
                <ul class="write_info">
                    <li class="content write">
                        <form class="write_form" name="writeForm" method="post"
                              action="/EIBooks/review/reviewWriteProc.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>">

                            <div class="content_tit">
                                <span>별점</span>
                                <select class="write_grade" name="grade">
                                    <option name="grade" value="5">5</option>
                                    <option name="grade" value="4">4</option>
                                    <option name="grade" value="3">3</option>
                                    <option name="grade" value="2">2</option>
                                    <option name="grade" value="1">1</option>
                                </select>
                            </div>

                            <textarea class="write_content" name="content" placeholder="리뷰 작성 최대 200자"
                                      oninput="limitText(this, 200)"></textarea>

                            <input class="btn write_btn" type="button" value="리뷰 등록"
                                   onclick="validateForm(<%=reviewCount%>)">
                        </form>
                    </li>
                </ul>

                <div class="tit_wrap">
                    <h1>리뷰 전체보기</h1>
                    <ul class="sort_wrap">
                        <li class="sort">
                            <%= "latest".equals(orderBy) ? "최신순" :
                                    "oldest".equals(orderBy) ? "오래된순" :
                                            "highest".equals(orderBy) ? "평점높은순" :
                                                    "lowest".equals(orderBy) ? "평점낮은순" : "최신순" %>
                            <img src="../styles/images/undo_tabler_io.svg" alt=""/>
                        </li>
                        <ul class="sort_menu">
                            <li>
                                <a href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getStartPage() %>&orderBy=latest" <%="latest".equals(orderBy)%>>최신순</a>
                            </li>
                            <li>
                                <a href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getStartPage() %>&orderBy=oldest" <%="oldest".equals(orderBy)%>>오래된순</a>
                            </li>
                            <li>
                                <a href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getStartPage() %>&orderBy=highest" <%="highest".equals(orderBy)%>>평점높은순</a>
                            </li>
                            <li>
                                <a href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getStartPage() %>&orderBy=lowest" <%="lowest".equals(orderBy)%>>평점낮은순</a>
                            </li>
                        </ul>
                    </ul>

                    <p class="total_count">전체 리뷰 수: <%=totalCount %>
                    </p>
                </div>

                <div class="review_list_wrap">
                    <ul class="review_list">
                        <% if (reviewList.isEmpty()) { %>
                        <li class="no_review"><b>리뷰가 없습니다.</b></li>
                        <% } else { %>
                        <% for (ReviewDTO dto : reviewList) { %>
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
                                <li class="review content review_content">
                                    <%= dto.getContent() %>
                                </li>

                                <%if (userNum == dto.getUserNum()) {%>
                                <li class="review_btn_wrap">
                                    <a href="../review/reviewUpdate.do?bookNum=<%=bookNum %>&pur_i_seq=<%=dto.getPur_i_seq()%>&reviewNum=<%=dto.getReviewNum() %>">
                                        <img src="../styles/images/edit.svg" alt="수정하기"/>
                                    </a>
                                    <a href="javascript:del('<%=dto.getReviewNum() %>')">
                                        <img src="../styles/images/delete.svg" alt="삭제하기"/>
                                    </a>
                                </li>
                                <% } %> <!-- userNum 체크 -->
                            </ul>
                        </li>
                        <%} %>
                    </ul>
                </div>

                <div class="pagination">
                    <%if (p.isPrev()) {%>
                    <a class="first arrow"
                       href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=1&orderBy=<%=orderBy %>">
                        <span class="blind">첫 페이지</span>
                    </a>
                    <%} else { %>
                    <a class="first arrow off"><span class="blind">첫 페이지</span></a>
                    <% } %>

                    <%if (p.isPrev()) {%>
                    <a class="prev arrow"
                       href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getStartPage()-1 %>&orderBy=<%=orderBy %>">
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
                    <a class="number"
                       href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=i %>&orderBy=<%=orderBy %>"><%=i %>
                    </a>
                    <%} %>
                    <%} %>

                    <%if (p.isNext()) {%>
                    <a class="next arrow"
                       href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getEndPage()+1 %>&orderBy=<%=orderBy %>">
                        <span class="blind">다음 페이지</span>
                    </a>
                    <%} else { %>
                    <a class="next arrow off"><span class="blind">다음 페이지</span></a>
                    <%} %>

                    <%if (p.isNext()) {%>
                    <a class="last arrow"
                       href="reviewWrite.do?bookNum=<%=bookNum %>&pur_seq=<%=pur_seq%>&pur_i_seq=<%=pur_i_seq%>&pageNum=<%=p.getRealEnd() %>&orderBy=<%=orderBy %>">
                        <span class="blind">마지막 페이지</span>
                    </a>
                    <%} else {%>
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