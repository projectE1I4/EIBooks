<%@page import="eibooks.dao.BookDAO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="eibooks.dao.ReviewDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
int allReviewCount = (int)request.getAttribute("allReviewCount");
int userNum = (int)session.getAttribute("cus_seq");
PageDTO p = (PageDTO)request.getAttribute("paging");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- <meta name="viewport" content="width=1280"> -->
<meta name="format-detection" content="telephone=no">
<meta name="description" content="EIBooks">
<meta property="og:type" content="website">
<meta property="og:title" content="EIBooks">
<meta property="og:description" content="EIBooks">
<meta property="og:image" content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg" />
<meta property="og:url" content="http://hyerin1225.dothome.co.kr/EIBooks" />
<title>EIBooks</title>
<link rel="icon" href="images/favicon.png">
<link rel="apple-touch-icon" href="images/favicon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/EIBooks/styles/css/jquery-ui.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/swiper-bundle.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/aos.css">
<link rel="stylesheet" href="/EIBooks/styles/css/common.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/header.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/footer.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/main.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/review/replyList.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<title>review/replyList.jsp</title>
<script>
$(document).ready( function() {
    
    $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
    $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다
  
});

	function del(reviewNum){
		const input = confirm("리뷰를 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/review/depthOneDeleteProc.do?reviewNum=" + reviewNum;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	function delReply(reviewNum, ref_seq){
		const input = confirm("답글을 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/review/replyDeleteProc.do?reviewNum=" + reviewNum + "&ref_seq=" + ref_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
</script>
<style type="text/css">

</style>
</head>
<body>
<%@ include file="../common/menu.jsp" %>

<header id="header"></header>

<main id="container" class="sub_container review_list_area">

<div class="tit_wrap">
<h1>리뷰 전체보기</h1>
<p class="total_count">전체 리뷰 수: <%=allReviewCount %></p>
</div>

<div class="review_list_wrap">
<ul class="review_list">
<% if(reviewList.isEmpty()) { %>
	<li class="no_review"><b>리뷰가 없습니다.</b></li>
<% } else { %>
<%for(ReviewDTO dto:reviewList) {%>
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
			<li class="book_title"><a href="/EIBooks/admin/productView.bo?book_seq=<%=dto.getBookNum()%>"><%=bDto.getTitle() %></a></li>
			<li><a href="/EIBooks/customer/myOrderDetail.or?pur_seq=<%=dto.getPur_seq() %>">상세 주문 내역</a></li>
			
			<li class="review content review_content">
                <%= dto.getContent() %>
            </li>
            
            <%if(!(userNum == dto.getUserNum())) {%>
            <li class="review_btn_wrap">
            	<% if(dto.getRef_YN().equals("Y")) { %>
            			<a>
						 <img src="../styles/images/review_comment.svg" alt="답글 달기" class="disable_btn"/>
						</a>
					<% } else { %>
						<a href="replyWrite.do?bookNum=<%=dto.getBookNum() %>&reviewNum=<%=dto.getReviewNum() %>&isReply=1&pageNum=<%=p.getPageNum() %>">
						<img src="../styles/images/review_comment.svg" alt="답글 달기"/>
						</a> 
				<% } %>
				<a href="javascript:del('<%=dto.getReviewNum() %>')"><img src="../styles/images/delete.svg" alt="리뷰 삭제하기"/></a>
            </li>
		<% } %>
		</ul>
		
		<%
		ReviewDAO dao = new ReviewDAO();
		ReviewDTO reply = dao.selectReply(dto);
		System.out.println(reply);
		if (reply.getContent() != null) {
		%>
		<ul class="reply reply_info">
			<img class="reply_icon" src="../styles/images/arrow_right.png" alt=""/>
            <li>관리자</li>
            <li><%= reply.getReviewDate() %></li>
            <li class="reply content reply_content"><%= reply.getContent() %></li>
            <%if(userNum == reply.getUserNum()) {%>
            <li class="review_btn_wrap">
            	<a href="replyUpdate.do?reviewNum=<%=reply.getReviewNum() %>&isReply=1"><img src="../styles/images/edit.svg" alt="답글 수정하기"/></a> 
				<a href="javascript:delReply('<%=reply.getReviewNum() %>', '<%=reply.getRef_seq()%>')"><img src="../styles/images/delete.svg" alt="답글 삭제하기"/></a>
            </li>
            <%} %>
		</ul>
		<%} %>
	</li>
		<%} %>
</ul>
</div>

<div class="pagination">
	<%if(p.isPrev()) {%>
	<a class="first arrow" href="replyList.do?pageNum=1">
		<span class="blind">첫 페이지</span>
	</a>
	<%} else { %>
		<a class="first arrow off"><span class="blind">첫 페이지</span></a>
	<% } %>
	
	<%if(p.isPrev()) {%>
	<a class="prev arrow" href="replyList.do?pageNum=<%=p.getStartPage()-1 %>">
		<span class="blind">이전 페이지</span>
	</a>
	<%} else { %>
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
	<%} %>
	
	<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()) {%>
			<a class="number active"><%=i %></a>
		<%}else {%>
			<a class="number" href="replyList.do?pageNum=<%=i %>"><%=i %></a>
		<%} %>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="next arrow" href="replyList.do?pageNum=<%=p.getEndPage()+1 %>">
		<span class="blind">다음 페이지</span>
	</a>
	<%} else {%>
		<a class="next arrow off"><span class="blind">다음 페이지</span></a>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="last arrow" href="replyList.do?pageNum=<%=p.getRealEnd() %>">
		<span class="blind">마지막 페이지</span>
	</a>
	<%} else { %>
		<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
	<%} %>
</div>
<%} %>
</main>

<footer id="footer"></footer>
</body>
</html>