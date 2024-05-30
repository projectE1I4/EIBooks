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
int userNum = (int)session.getAttribute("cus_seq");
PageDTO p = (PageDTO)request.getAttribute("paging");
ReviewDTO myReview = (ReviewDTO)request.getAttribute("myReview");
int allReviewCount = (int)request.getAttribute("allReviewCount");
String sReviewNum = request.getParameter("reviewNum");
int reviewNum = Integer.parseInt(sReviewNum);
String content = request.getParameter("content");

// 0이면 답글 X, 1이면 답글 O
int isReply = 0;
if(request.getParameter("isReply") != null) {
	isReply = Integer.parseInt(request.getParameter("isReply"));
}
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
<link rel="stylesheet" href="/EIBooks/styles/css/review/replyWrite.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<title>replyUpdate.jsp</title>

<script type="text/javascript">
function validateForm(refYN) {
	const form = document.writeForm;
	if(refYN === "Y"){
		console.log(reviewCount);
		alert("이미 작성한 리뷰가 있습니다.");
		location.href = "<%=request.getContextPath() %>/review/replyUpdate.do?reviewNum=<%=reviewNum%>";
		return;
	}else if(form.content.value === ""){
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

function del(reviewNum){
	const input = confirm("리뷰를 삭제하시겠습니까?");
	if(input){
		location.href = "<%=request.getContextPath()%>/review/depthOneDeleteProc.do?reviewNum=" + reviewNum;
	}else{
		alert("삭제를 취소했습니다.");
		return;
	}
	location.href = "<%=request.getContextPath()%>/review/replyUpdate.do?reviewNum=" + reviewNum + "&isReply=1"
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

function isReply(reviewNum) {
	isReply = 1;
	location.href="replyUpdate.do?reviewNum=" + reviewNum + "&isReply=<%=isReply%>";
}

function goToPage() {
	location.href = "/EIBooks/review/replyList.do";
}

window.onload = function() {
    const targetElement = document.querySelector('.review');
    if (targetElement) {
        targetElement.scrollIntoView({
            behavior: 'auto' 
        });
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
		<div class="review_btn_wrap">
			<%if(dto.getRef_YN().equals("Y")) { %>
            			<a>
						 	<img src="../styles/images/review_comment.svg" alt="답글 달기"  class="disable_btn"/>
						</a>
					<% } else if(reviewNum != dto.getReviewNum()) { %>
						<a href="replyWrite.do?bookNum=<%=dto.getBookNum() %>&reviewNum=<%=dto.getReviewNum() %>&isReply=1&pageNum=<%=p.getPageNum() %>">
							<img src="../styles/images/review_comment.svg" alt="답글 달기"/>
						</a> 
				<% } else {%>
					<a>
						<img src="../styles/images/review_comment.svg" alt="답글 달기" class="disable_btn"/>
					</a>
				<%} %>
			
			<a href="javascript:del('<%=dto.getReviewNum() %>')">
				<img src="../styles/images/delete.svg" alt="리뷰 삭제하기"/>
			</a>
		</div>
		<%} %>
		</ul>
	<%
	ReviewDAO dao = new ReviewDAO();
	ReviewDTO reply = dao.selectReply(dto);
	if (reply.getContent() != null) {
	%>
		<% if (reviewNum == reply.getReviewNum() && isReply == 1) { %>
		<ul class="reply reply_info write_info">
		<img class="reply_icon" src="../styles/images/arrow_right.png" alt=""/>
		<li class="reply content write">
		<form class="write_form" name="writeForm" method="post" action="/EIBooks/review/replyUpdateProc.do?reviewNum=<%=reply.getReviewNum() %>">
			<textarea class="write_content" name="content" placeholder="답글 작성 최대 200자" oninput="limitText(this, 200)"><%=reply.getContent() %></textarea>
			<div class="write_btn_wrap">
				<input class="write_btn" type="submit" value="수정 확인" onclick="validateForm('<%=dto.getRef_YN() %>')">
				<input class="write_btn" type="button" value="수정 취소" onclick="goToPage()">
			</div>
		</form>
		</li>
		</ul>
		<% } %>
		
	<%
	if (reply.getContent() != null && reply.getReviewNum() != reviewNum) { // 댓글내용이 있으면 무조건 보여줘
	%>
		<%if(reviewNum != dto.getReviewNum()) {%> <%// 현재 보고 있는 답글이 아닌 경우에만 표시 %>
			<% if(userNum != reply.getUserNum()) { %> <%// 현재 사용자가 해당 답글의 작성자가 아닌 경우에만 표시 %>
			<% } else if(reviewNum != dto.getReviewNum()) { %> <%//현재 보고 있는 답글인 경우에만 표시 %>
		
		<ul class="reply reply_info">
			<img class="reply_icon" src="../styles/images/arrow_right.png" alt=""/>
            <li>관리자</li>
            <li><%= reply.getReviewDate() %></li>
            <li class="reply content reply_content"><%= reply.getContent() %></li>
            <li class="reply_btn_wrap">
            	<a href="replyUpdate.do?reviewNum=<%=reply.getReviewNum() %>&isReply=1">
            		<img src="../styles/images/edit.svg" alt="답글 수정하기"/>
            	</a> 
				<a href="javascript:delReply('<%=reply.getReviewNum() %>', '<%=reply.getRef_seq()%>')">
					<img src="../styles/images/delete.svg" alt="답글 삭제하기"/>
				</a>
            </li>
		</ul>
		<%} %>
		<%} %>
	<%} %>

	<%} %>
<%} %>

<div class="pagination">
	<%if(p.isPrev()) {%>
	<a class="first arrow" href="replyUpdate.do?reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=p.getStartPage() %>">
		<span class="blind">첫 페이지</span>
	</a>
	<%} else { %>
		<a class="first arrow off"><span class="blind">첫 페이지</span></a>
	<% } %>
	
	<%if(p.isPrev()) {%>
	<a class="prev arrow" href="replyUpdate.do?reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=p.getStartPage()-1 %>">
		<span class="blind">이전 페이지</span>
	</a>
	<%} else { %>
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
	<%} %>
	
	<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()) {%>
			<a class="number active"><%=i %></a>
		<%}else {%>
			<a class="number" href="replyUpdate.do?reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=i %>"><%=i %></a>
		<%} %>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="next arrow" href="replyUpdate.do?reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=p.getEndPage()+1 %>">
		<span class="blind">다음 페이지</span>
	</a>
	<%} else {%>
		<a class="next arrow off"><span class="blind">다음 페이지</span></a>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="last arrow" href="replyUpdate.do?reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=p.getEndPage() %>">
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