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
String sState = request.getParameter("state");
int state = 5;
if (sState != null) {
	state = Integer.parseInt(sState);
}
%>  
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaList.css?v=<?php echo time(); ?>">
</head>

<body>
<script>
$(document).ready( function() {
    
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
					<a href="/EIBooks/customer/myPage.or">나의 주문목록</a>
				</li>
				<li>
					<a href="/EIBooks/customer/updateMyPage.cs">회원정보 수정</a>
				</li>
				<li class="list_mypage">
					<a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
				</li>
				<li>
					<a href="/EIBooks/orderQna/qnaList.oq">1:1문의 내역</a>
				</li>
			</ul>
		</div>
		
		<div class="tit_wrap">
		<h1>상품 문의</h1>
		<ul class="sort_wrap">
				<li class="sort_main">
				<%= state == 5 ? "전체보기" :
			         state == 0 ? "답변대기" :
			         state == 1 ? "답변완료" : "전체보기" %>
			     	<img src="../styles/images/undo_tabler_io.svg" alt=""/>
				</li>
				<li class="sort_menu">
					<ul>
						<li>
							<a href="/EIBooks/qna/qnaList.qq?state=5">전체보기</a>
						</li>
						<li>
							<a href="/EIBooks/qna/qnaList.qq?state=0">답변대기</a>
						</li>
						<li>
							<a href="/EIBooks/qna/qnaList.qq?state=1">답변완료</a>
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
						<tr><td colspan="8">&nbsp;<b>문의가 없습니다.</b></td></tr>
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
											<p class="author"><%=qna.getBookInfo().getAuthor() %></p>
										</div>
									</div>
								</td>
								<td class="title_text"><%=qna.getTitle() %></td>
								<td><%=qna.getType() %></td>
								<td><%=qna.getRegDate() %></td>
								<td>
									<div class="col">
										<em>
										<%if(qna.getState() == 0) %>답변대기
										<%if(qna.getState() == 1) %>답변완료
										</em>
										<% if (qna.getState() == 0) { %>
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
										<div class="admin_content_wrap">
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
				<a class="first arrow" href="qnaList.qq?<%if(state != 5) { %>state=<%=state %>&<%} %>pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="qnaList.qq?<%if(state != 5) { %>state=<%=state %>&<%} %>pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="qnaList.qq?<%if(state != 5) { %>state=<%=state %>&<%} %>pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="qnaList.qq?<%if(state != 5) { %>state=<%=state %>&<%} %>pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="qnaList.qq?<%if(state != 5) { %>state=<%=state %>&<%} %>pageNum=<%=p.getRealEnd() %>">
					<span class="blind">마지막 페이지</span>
				</a>
				<%} else { %>
					<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
				<%} %>
			</div>
		<% } %>
			</div> <!-- mypage -->
		</div> <!-- inner -->
	</main> <!-- container -->
	<%@ include file="../common/footer.jsp" %>
</div> <!-- wrap -->
</body>
</html>