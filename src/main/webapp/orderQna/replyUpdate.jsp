<%@page import="eibooks.dao.OrderQnaDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.OrderQnaDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<OrderQnaDTO> qnaList = (List<OrderQnaDTO>)request.getAttribute("qnaList");
PageDTO p = (PageDTO)request.getAttribute("paging");
String state = (String)request.getAttribute("state");

String sPur_q_seq = request.getParameter("pur_q_seq");
int pur_q_seq = Integer.parseInt(sPur_q_seq);

//0이면 답글 X, 1이면 답글 O
int isReply = 0;
if(request.getParameter("isReply") != null) {
	isReply = Integer.parseInt(request.getParameter("isReply"));
}
%>          
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaReply2.css?v=<?php echo time(); ?>">
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
			location.href = "<%=request.getContextPath() %>/orderQna/replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&pageNum=<%=p.getPageNum()%>";
			return;
		}else if(form.content.value === ""){
			alert('내용을 입력해주세요.');
			form.content.focus();
			return;
		}
		
		form.submit();
	}
	
	function goToPage() {
		location.href = "/EIBooks/orderQna/reply.oq";
	}
	
	function delReply(pur_q_seq, ref_seq){
		const input = confirm("답변을 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/orderQna/replyDeleteProc.oq?pur_q_seq=" + pur_q_seq + "&ref_seq=" + ref_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	
	function isReply(pur_q_seq) {
		isReply = 1;
		location.href="replyWrite.oq?pur_q_seq=" + pur_q_seq + "&isReply=<%=isReply %>" + "&pageNum=<%=p.getPageNum()%>";
	}
	
	window.onload = function() {
	    const targetElement = document.querySelector('.reply');
	    if (targetElement) {
	        targetElement.scrollIntoView({
	            behavior: 'auto' 
	        });
	    }
	}
	
	function limitText(field, maxLength) {
		if (field.value.length > maxLength) {
			field.value = field.value.substring(0, maxLength);
			alert('답변은 최대 ' + maxLength + '자까지 작성할 수 있습니다.');
		}
	}
	
	function del(pur_q_seq){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/orderQna/deleteProc.oq?pur_q_seq=" + pur_q_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	
</script>
</head>
<body>


<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<%@ include file="../common/header.jsp" %>
	<main id="container">
		<div class="tit_wrap">
		<h1>1:1 문의</h1>
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
							<a href="/EIBooks/orderQna/reply.oq">전체보기</a>
						</li>
						<li>
							<a href="/EIBooks/orderQna/reply.oq?state=답변대기">답변대기</a>
						</li>
						<li>
							<a href="/EIBooks/orderQna/reply.oq?state=답변완료">답변완료</a>
						</li>
					</ul>
				</li>
			</ul>
		</div>
		<div class="board_list_wrap">
			<table>
				<thead>
					<tr>
						<th class="title">내용</th>
						<th class="pur_seq">주문 번호</th>
						<th class="date">작성일</th>
						<th class="state">처리 상태</th>
					</tr>
				</thead>
				<tbody>
					<% if(qnaList.isEmpty()) { %>	
						<tr><td colspan="8">&nbsp;<b>Data Not Found!!</b></td></tr>
					<% } else { %>
						<% for(OrderQnaDTO qna : qnaList){ %>	
							<tr class="qna_wrap">
								<td class="title_text"><%=qna.getTitle() %></td>
								<td><%=qna.getPur_seq() %></td>
								<td><%=qna.getRegDate() %></td>
								<td>
									<div class="col">
										<em><%=qna.getState() %></em>
									</div>
								</td>
							</tr>
							<tr class="reply_wrap">
								<td colspan="4">
									<div class="reply_wrap_content">
										<div class="cus_content reply">
											<p><%=qna.getContent() %></p>
											<div class="btn_wrap">
												<% if(qna.getState().equals("답변대기") && pur_q_seq != qna.getPur_q_seq()) { %>
												<a class="btn insert_btn" href="<%=request.getContextPath()%>/orderQna/replyWrite.oq?pur_q_seq=<%=qna.getPur_q_seq()%>&isReply=1&pageNum=<%=p.getPageNum() %>">답변 달기
													<span class="blind">답변 달기</span>
												</a>
												<% } %>
												<a class="btn" href="javascript:del('<%=qna.getPur_q_seq() %>');">
													삭제
												</a>
											</div>
										</div>
										<% if(qna.getImageFile() != null && !qna.getImageFile().isEmpty()) { %>
											<div class="img_wrap">
						                        <img src="<%=qna.getImageFile() %>" alt="표지이미지">
						                    </div>
					                    <% } %>
										<%
										OrderQnaDAO dao = new OrderQnaDAO();
										OrderQnaDTO reply = dao.selectReply(qna);
										%>
									</div>
									<div class="reply_input">
										<% if (pur_q_seq == reply.getPur_q_seq() && isReply == 1) { %>
											<ul class="reply_form">
												<li class="">
													<form class="write_form" name="writeForm" method="post" action="/EIBooks/orderQna/replyUpdateProc.oq?pageNum=<%=p.getPageNum()%>">
														<div class="text_area">
															<textarea class="write_content" name="content" oninput="limitText(this, 500)"><%=reply.getContent() %></textarea>
														</div>
														<div class="write_btn_wrap">
															<input type="hidden" name="pur_q_seq" value="<%=reply.getPur_q_seq() %>">
															<input class="btn write_btn" type="submit" value="수정 완료" >
															<input class="btn" type="button" value="수정 취소" onclick="goToPage()">
														</div>
													</form>
												</li>
											</ul>
										<% } %>
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
				<a class="first arrow" href="replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&isReply=1&pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&isReply=1&pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&isReply=1&pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&isReply=1&pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="replyUpdate.oq?pur_q_seq=<%=pur_q_seq %>&isReply=1&pageNum=<%=p.getRealEnd() %>">
					<span class="blind">마지막 페이지</span>
				</a>
				<%} else { %>
					<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
				<%} %>
			</div>
		<% } %>
		
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>