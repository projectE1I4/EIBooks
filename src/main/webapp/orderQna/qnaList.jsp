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
%>      
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaList2.css?v=<?php echo time(); ?>">
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
				<li>
					<a href="/EIBooks/qna/qnaList.qq">상품문의 내역</a>
				</li>
				<li class="list_mypage">
					<a href="/EIBooks/orderQna/qnaList.oq">1:1문의 내역</a>
				</li>
			</ul>
		</div>
		
		<div class="tit_wrap">
		<h1>1:1 문의</h1>
		<div class="btn_wrap">
			<a class="btn insert_btn" href="<%=request.getContextPath()%>/orderQna/qnaWrite.oq?pageNum=<%=p.getPageNum()%>">작성하기</a>
		</div>
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
							<a href="/EIBooks/orderQna/qnaList.oq">전체보기</a>
						</li>
						<li>
							<a href="/EIBooks/orderQna/qnaList.oq?state=답변대기">답변대기</a>
						</li>
						<li>
							<a href="/EIBooks/orderQna/qnaList.oq?state=답변완료">답변완료</a>
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
										<% if (qna.getState().equals("답변대기")) { %>
											<a class="btn delete_btn" href="javascript:del('<%=qna.getPur_q_seq() %>');">
												삭제
											</a>
										<% } %>
									</div>
								</td>
							</tr>
							<tr class="reply_wrap">
								<td colspan="4">
									<div class="reply_wrap_content">
										<div class="cus_content">
											<p><%=qna.getContent() %></p>
										</div>
										<% if(qna.getImageFile() != null && !qna.getImageFile().isEmpty()) { %>
											<div class="img_wrap">
						                        <img src="<%=qna.getImageFile() %>" alt="첨부파일">
						                    </div>
					                    <% } %>
										<%
										OrderQnaDAO dao = new OrderQnaDAO();
										OrderQnaDTO reply = dao.selectReply(qna);
										
										if(reply.getContent() != null) {
										%>
										<div class="admin_content_wrap">
											<div class="admin_content">
												<p><%=reply.getContent() %></p>
												<p><%=reply.getRegDate() %></p>
											</div>
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
				<a class="first arrow" href="qnaList.oq?pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="qnaList.oq?pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="qnaList.oq?pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="qnaList.oq?pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="qnaList.oq?pageNum=<%=p.getRealEnd() %>">
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
</div>

</body>
</html>