<%@page import="eibooks.dao.ReviewDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
int totalCount = (int)request.getAttribute("totalCount");
String orderBy = (String)request.getAttribute("orderBy");
String sBookNum = request.getParameter("bookNum");
int bookNum = Integer.parseInt(sBookNum);
int userNum = (int)session.getAttribute("cus_seq");
/*
String sPur_seq = request.getParameter("pur_seq");
int pur_seq = Integer.parseInt(sPur_seq);
/**/
String sPur_i_seq = request.getParameter("pur_i_seq");
int pur_i_seq = Integer.parseInt(sPur_i_seq);

PageDTO p = (PageDTO)request.getAttribute("paging");
String reviewNum = (String)request.getParameter("reviewNum");
ReviewDTO myReview = (ReviewDTO)request.getAttribute("myReview");
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
<link rel="stylesheet" href="/EIBooks/styles/css/review/reviewList.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<title>review/reviewUpdate</title>
<script type="text/javascript">
function validateForm() {
	const form = document.updateForm;
	if(form.content.value === ""){
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

function goToPage() {
	location.href = "<%=request.getContextPath()%>/review/reviewList.do?bookNum=<%=bookNum%>";
}

function del(reviewNum){
	const input = confirm("정말 삭제하시겠습니까?");
	if(input){
		location.href = "<%=request.getContextPath()%>/review/reviewDeleteProc.do?bookNum=<%=bookNum %>&reviewNum=" + reviewNum;
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

<div id="wrap">

<header id="header"></header>

<main id="container" class="sub_container review_list_area">

<h1 class="write_tit">리뷰 수정</h1>
<ul class="write_info">
	<li class="content write">
		<form class="write_form" name="updateForm" method="post" action="/EIBooks/review/reviewUpdateProc.do?bookNum=<%=bookNum %>&pur_i_seq=<%=pur_i_seq %>&reviewNum=<%=reviewNum %>">
		
		<div class="content_tit">
			<span>별점</span>
			<select class="write_grade" name="grade">
				<option name="grade" value="5" <% if(myReview.getGrade() == 5) { %>selected<% } %>>5</option>
				<option name="grade" value="4" <% if(myReview.getGrade() == 4) { %>selected<% } %>>4</option>
				<option name="grade" value="3" <% if(myReview.getGrade() == 3) { %>selected<% } %>>3</option>
				<option name="grade" value="2" <% if(myReview.getGrade() == 2) { %>selected<% } %>>2</option>
				<option name="grade" value="1" <% if(myReview.getGrade() == 1) { %>selected<% } %>>1</option>
			</select>
		</div>
			
		<textarea class="write_content" name="content" placeholder="리뷰 작성 최대 200자" oninput="limitText(this, 200)"><%=myReview.getContent()%></textarea>
			
		<div class="update_btn_wrap">
			<input class="update_btn" type="button" value="리뷰 수정" onclick="validateForm()">
			<input class="update_btn" type="button" value="수정 취소" onclick="goToPage()">
		</div>
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
				<li><a href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getStartPage() %>&orderBy=latest" <%="latest".equals(orderBy)%>>최신순</a></li>
				<li><a href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getStartPage() %>&orderBy=oldest" <%="oldest".equals(orderBy)%>>오래된순</a></li>
				<li><a href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getStartPage() %>&orderBy=highest" <%="highest".equals(orderBy)%>>평점높은순</a></li>
				<li><a href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getStartPage() %>&orderBy=lowest" <%="lowest".equals(orderBy)%>>평점낮은순</a></li>
			</ul>
	</ul>
	
	<p class="total_count">전체 리뷰 수: <%=totalCount %></p>
</div>

<div class="review_list_wrap">
<ul class="review_list">
<% if(reviewList.isEmpty()) { %>	
    <li class="no_review"><b>리뷰가 없습니다.</b></li>
<% } else { %>
<% for(ReviewDTO dto : reviewList) { %>
	<li class="review">
		<ul class="review_info">
			<li class="grade">
		          <% for (int i = 0; i < dto.getGrade(); i++) { %>
		           <img src="../styles/images/star_full.png" alt=""/>
		          <% 
		           } 
		           for (int i = 0; i < 5 - dto.getGrade(); i++) {
		          %>
		           <img src="../styles/images/star_empty.png" alt=""/>
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
	
		<%if(userNum == dto.getUserNum()) {%>
		<li class="review_btn_wrap">
		    <a href="reviewUpdate.do?bookNum=<%=bookNum %>&pur_i_seq=<%=dto.getPur_i_seq() %>&reviewNum=<%=dto.getReviewNum() %>">
		      <img src="../styles/images/edit.svg" alt="수정하기"/>
		    </a>
		    <a href="javascript:del('<%=dto.getReviewNum() %>')">
		      <img src="../styles/images/delete.svg" alt="삭제하기"/>
		    </a>
		</li>
		<%} %>
	</ul>
	
	<%
        ReviewDAO dao = new ReviewDAO();
        ReviewDTO reply = dao.selectReply(dto);
        if (reply.getContent() != null) {
     %>
        <ul class="reply reply_info">
        <img class="reply_icon" src="../styles/images/arrow_right.png" alt=""/>
            <li>관리자</li>
            <li><%= reply.getReviewDate() %></li>
            <li class="reply content reply_content"><%= reply.getContent() %></li>
        </ul>
        <% } %>
        
	</li>
	<%} %>
</ul>
</div>

<div class="pagination">
	<%if(p.isPrev()) {%>
	<a class="first arrow" href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=1&orderBy=<%=orderBy %>">
		<span class="blind">첫 페이지</span>
	</a>
	<%} else { %>
		<a class="first arrow off"><span class="blind">첫 페이지</span></a>
	<% } %>
	
	<%if(p.isPrev()) {%>
	<a class="prev arrow"a href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getStartPage()-1 %>&orderBy=<%=orderBy %>">
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
	</a>
	<%} else { %>
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
	<%} %>
	
	<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()) {%>
			<a class="number active"><%=i %></a>
		<%}else {%>
			<a class="number" href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=i %>&orderBy=<%=orderBy %>"><%=i %></a>
		<%} %>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="next arrow" href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getEndPage()+1 %>&orderBy=<%=orderBy %>">
		<span class="blind">다음 페이지</span>
	</a>
	<%} else { %>
		<a class="next arrow off"><span class="blind">다음 페이지</span></a>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="last arrow" href="reviewUpdate.do?bookNum=<%=bookNum %>&pageNum=<%=p.getRealEnd() %>&orderBy=<%=orderBy %>">
		<span class="blind">마지막 페이지</span>
	</a>
	<%} else {%>
		<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
	<%} %>
</div>
<%} %>
</main>

<footer id="footer"></footer>
</div>
</body>
</html>