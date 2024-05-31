<%@page import="eibooks.dao.QnaDAO"%>
<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@page import="eibooks.dao.BookDAO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="eibooks.dto.QnaDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.common.PageDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<QnaDTO> qnaList = (List<QnaDTO>)request.getAttribute("qnaList");
PageDTO p = (PageDTO)request.getAttribute("paging");
String state = (String)request.getAttribute("state");
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
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaList.css?v=<?php echo time(); ?>">
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
  
    $('.sort_main').click(function() {
        $(this).next('.sort_menu').slideToggle();
        $(this).toggleClass('rotate');
    });
    

    $('.qna_wrap').click(function() {
        $(this).next('.reply_wrap').toggle();
    });
   
   $(document).click(function(e) {
        if (!$(e.target).closest('.sort_wrap').length) {
            $('.sort_menu').slideUp();
        }
        
        if (!$(e.target).closest('.qna_wrap').length) {
        	$('.reply_wrap').slideUp();
        }
    });
   
    $('.sort_menu ul li a').click(function(e) {
        e.preventDefault();
        var selectedText = $(this).text();
        $('.sort').text(selectedText);
        $('.sort_menu').slideUp();
        window.location.href = $(this).attr('href');
    });
});

	function del(book_seq, qna_seq){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/qna/deleteProc.qq?book_seq=" + book_seq + "&qna_seq=" + qna_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	
</script>
</head>
<body>
<%@ include file="../common/menu.jsp" %>

<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<header id="header"></header>
	<main id="container">
		<ul>
			<li>
				<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
			</li>
			<li>
				<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
			</li>
			<li>
				<a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
			</li>
		</ul>
		<div class="tit_wrap">
		<h1>상품 문의</h1>
		<ul class="sort_wrap">
				<li class="sort_main">
				<%= "전체보기".equals(state) ? "전체보기" :
			         "답변대기".equals(state) ? "답변대기" :
			         "답변완료".equals(state) ? "답변완료" : "전체보기" %>
			     	<img src="../styles/images/undo_tabler_io.svg" alt=""/>
				</li>
				<li class="sort_menu">
					<ul>
						<li>
							<a href="/EIBooks/qna/qnaList.qq">전체보기</a>
						</li>
						<li>
							<a href="/EIBooks/qna/qnaList.qq?state=답변대기">답변대기</a>
						</li>
						<li>
							<a href="/EIBooks/qna/qnaList.qq?state=답변완료">답변완료</a>
						</li>
					</ul>
				</li>
			</ul>
		</div>
		<div class="board_list_wrap">
			<table>
				<thead>
					<tr>
						<th class="info">상품 정보</th>
						<th class="title">제목</th>
						<th class="type">문의 유형</th>
						<th class="date">작성일</th>
						<th class="state">처리 상태</th>
					</tr>
				</thead>
				<tbody>
					<% if(qnaList.isEmpty()) { %>	
						<tr><td colspan="8">&nbsp;<b>Data Not Found!!</b></td></tr>
					<% } else { %>
						<% for(QnaDTO qna : qnaList){ %>	
							<tr class="qna_wrap">
								<td>
									<div class="book_info">
										<div class="book_image">
											<img src="<%=qna.getBookInfo().getImageFile()%>" alt="표지이미지">
										</div>
										<div class="book_text">
											<p><%=qna.getBookInfo().getPublisher() %></p>
											<strong><%=qna.getBookInfo().getTitle() %></strong>
											<p><%=qna.getBookInfo().getAuthor() %></p>
										</div>
									</div>
								</td>
								<td class="title_text"><%=qna.getTitle() %></td>
								<td><%=qna.getType() %></td>
								<td><%=qna.getRegDate() %></td>
								<td>
									<div class="col">
										<em><%=qna.getState() %></em>
										<% if (qna.getState().equals("답변대기")) { %>
											<a class="btn delete_btn" href="javascript:del('<%=qna.getBook_seq() %>','<%=qna.getQna_seq() %>');">삭제
												<span class="blind">삭제</span>
											</a>
										<% } %>
									</div>
								</td>
							</tr>
							<tr class="reply_wrap">
								<td colspan="5">
									<div class="reply_wrap_content">
										<div class="cus_content">
											<p><%=qna.getContent() %></p>
										</div>
										<%
										QnaDAO dao = new QnaDAO();
										QnaDTO reply = dao.selectReply(qna);
										
										if(reply.getContent() != null) {
										%>
										<div class="admin_wrap">
											<div class="admin_name"><p>관리자</p></div>
											<div class="admin_content"><p><%=reply.getContent() %></p></div>
										</div>
										<% } %> <!-- if(reply) -->
									</div>
								</td>
							</tr>
						<% } %>  <!-- for  -->
					<% } %> <!-- if -->
				</tbody>
			</table>
		</div>
		
		<% if(!qnaList.isEmpty()) { %>
			<div class="pagination">
				<%if(p.isPrev()) {%>
				<a class="first arrow" href="qnaList.qq?pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="qnaList.qq?pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="qnaList.qq?pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="qnaList.qq?pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="qnaList.qq?pageNum=<%=p.getRealEnd() %>">
					<span class="blind">마지막 페이지</span>
				</a>
				<%} else { %>
					<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
				<%} %>
			</div>
		<% } %>
	</main>
	<footer id="footer"></footer>
</div>
</body>
</html>