<%@page import="eibooks.dao.QnaDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.QnaDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<QnaDTO> qnaList = (List<QnaDTO>)request.getAttribute("qnaList");
PageDTO p = (PageDTO)request.getAttribute("paging");
String state = (String)request.getAttribute("state");

String sBook_seq = request.getParameter("book_seq");
int book_seq = Integer.parseInt(sBook_seq);
int cus_seq = (int)session.getAttribute("cus_seq");

String sQna_seq = request.getParameter("qna_seq");
int qna_seq = Integer.parseInt(sQna_seq);

//0이면 답글 X, 1이면 답글 O
int isReply = 0;
if(request.getParameter("isReply") != null) {
	isReply = Integer.parseInt(request.getParameter("isReply"));
}
%>      
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaReply.css?v=<?php echo time(); ?>">
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaReplyWrite.css?v=<?php echo time(); ?>">
<script>
$(document).ready( function() {
    
    $('.sort_main').click(function() {
        $(this).next('.sort_menu').slideToggle();
        $(this).toggleClass('rotate');
    });
    
   $(document).click(function(e) {
        if (!$(e.target).closest('.sort_wrap').length) {
            $('.sort_menu').slideUp();
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


	function validateForm(state) {
		const form = document.writeForm;
		if(state == "답변완료"){
			console.log(reviewCount);
			alert("이미 작성한 리뷰가 있습니다.");
			location.href = "<%=request.getContextPath() %>/qna/replyUpdate.qq?qna_seq=<%=qna_seq %>&pageNum=<%=p.getPageNum()%>";
			return;
		}else if(form.content.value === ""){
			alert('내용을 입력해주세요.');
			form.content.focus();
			return;
		}
		
		form.submit();
	}
	
	function goToPage() {
		location.href = "/EIBooks/qna/reply.qq";
	}

	function del(qna_seq){
		const input = confirm("문의를 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/qna/depthOneDeleteProc.qq?qna_seq=" + qna_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	function delReply(qna_seq, ref_seq){
		const input = confirm("답변을 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/qna/replyDeleteProc.qq?qna_seq=" + qna_seq + "&ref_seq=" + ref_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	
	function isReply(qna_seq) {
		isReply = 1;
		location.href="replyWrite.qq?qna_seq=" + qna_seq + "&isReply=<%=isReply %>&pageNum=<%=p.getPageNum()%>";
	}
	
	window.onload = function() {
	    const targetElement = document.querySelector('.reply');
	    if (targetElement) {
	        targetElement.scrollIntoView({
	            behavior: 'auto' 
	        });
	    }
	}
	
</script>
</head>
<body>

<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
	<%@ include file="../common/header.jsp" %>
	<main id="container">
		<div class="inner">
		<div class="tit_wrap">
		<h1>상품 문의(관리자)</h1>
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
										<em><%=qna.getState() %></em>
									</div>
								</td>
							</tr>
							<tr class="reply_wrap">
								<td colspan="5">
									<div class="reply_wrap_content">
										<div class="cus_content">
											<p><%=qna.getContent() %></p>
											<div class="btn_wrap">
												<% if(qna.getState().equals("답변대기")) { %>
												<a class="btn insert_btn" href="<%=request.getContextPath()%>/qna/replyWrite.qq?book_seq=<%=qna.getBook_seq() %>&qna_seq=<%=qna.getQna_seq()%>&isReply=1&pageNum=<%=p.getPageNum() %>">답변 달기
													<span class="blind">답변 달기</span>
												</a>
												<% } %>
												<a class="btn" href="javascript:del('<%=qna.getQna_seq() %>');">삭제</a>
											</div>
										</div>
										<%
										QnaDAO dao = new QnaDAO();
										QnaDTO reply = dao.selectReply(qna);
										
										if(reply.getContent() != null) {
										%>
										<div class="admin_content_wrap reply">
											<img src="../styles/images/arrow_right.png">
											<div class="admin_name"><p>관리자</p></div>
											<% if(qna_seq != reply.getQna_seq()) { %>
											<div class="admin_content"><p><%=reply.getContent() %></p></div>
											<% } else { %>
											<div class="admin_content"></div>
											<% } %>
											<div class="btn_wrap">
												<% if(qna_seq != reply.getQna_seq()) { %>
												<a class="update_btn" href="<%=request.getContextPath()%>/qna/replyUpdate.qq?book_seq=<%=qna.getBook_seq() %>&qna_seq=<%=reply.getQna_seq()%>&isReply=1&pageNum=<%=p.getPageNum() %>">
													<span class="blind">수정</span>
												</a>
												<% } %>
												<a class="delete_btn" href="javascript:delReply('<%=reply.getQna_seq() %>','<%=reply.getRef_seq() %>');">
													<span class="blind">삭제</span>
												</a>
											</div>
										</div>
										<% } %> <!-- if(reply) -->
										<div class="reply_input">
											<% if (qna_seq == reply.getQna_seq() && isReply == 1) { %>
												<ul class="reply_form">
													<li class="">
														<form class="write_form" name="writeForm" method="post" action="/EIBooks/qna/replyUpdateProc.qq?pageNum=<%=p.getPageNum()%>">
															<div class="text_area">
																<textarea class="write_content" name="content" oninput="limitText(this, 500)"><%=reply.getContent() %></textarea>
															</div>
															<div class="write_btn_wrap">
																<input type="hidden" name="qna_seq" value="<%=reply.getQna_seq() %>">
																<input class="btn write_btn" type="submit" value="수정 완료" >
																<input class="btn" type="button" value="수정 취소" onclick="goToPage()">
															</div>
														</form>
													</li>
												</ul>
											<% } %>
										</div>
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
				<a class="first arrow" href="replyUpdate.qq?book_seq=<%=book_seq %>&qna_seq=<%=qna_seq %>&isReply=1&pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="replyUpdate.qq?book_seq=<%=book_seq %>&qna_seq=<%=qna_seq %>&isReply=1&pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="replyUpdate.qq?book_seq=<%=book_seq %>&qna_seq=<%=qna_seq %>&isReply=1&pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="replyUpdate.qq?book_seq=<%=book_seq %>&qna_seq=<%=qna_seq %>&isReply=1&pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="replyUpdate.qq?book_seq=<%=book_seq %>&qna_seq=<%=qna_seq %>&isReply=1&pageNum=<%=p.getRealEnd() %>">
					<span class="blind">마지막 페이지</span>
				</a>
				<%} else { %>
					<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
				<%} %>
			</div>
		<% } %>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>

</body>
</html>