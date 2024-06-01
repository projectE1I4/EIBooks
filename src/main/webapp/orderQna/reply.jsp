<%@page import="java.util.List"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.OrderQnaDTO"%>
<%@page import="eibooks.dao.OrderQnaDAO"%>
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

	function del(pur_q_seq){
		const input = confirm("문의를 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/orderQna/depthOneDeleteProc.oq?pur_q_seq=" + pur_q_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	function delReply(pur_q_seq, ref_seq){
		const input = confirm("답변을 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/orderQna/replyDeleteProc.oq?pur_q_seq=" + pur_q_seq + "&ref_seq=" + ref_seq + "&pageNum=<%=p.getPageNum()%>";
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
<div id="wrap" class="admin">
	<%@ include file="../common/header.jsp" %>
	<main id="container">
		<div class="inner">
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
						<tr><td colspan="8">&nbsp;<b>문의가 없습니다.</b></td></tr>
					<% } else { %>
						<% for(OrderQnaDTO qna : qnaList){ %>	
							<tr class="qna_wrap">
								<td class="title_text"><%=qna.getTitle() %></td>
								<td>
									<a class="orderView" href="/EIBooks/admin/orderView.or?pur_seq=<%=qna.getPur_seq() %>">
										<%=qna.getPur_seq() %>
									</a>
								</td>
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
										<div class="cus_content">
											<p><%=qna.getContent() %></p>
										
										<% if(qna.getImageFile() != null && !qna.getImageFile().isEmpty()) { %>
											<div class="img_wrap">
						                        <img src="<%=qna.getImageFile() %>" alt="첨부파일">
						                    </div>
					                    <% } %>
					                    </div>
										<div class="btn_wrap">
											<% if(qna.getState().equals("답변대기")) { %>
											<a class="btn insert_btn" href="<%=request.getContextPath()%>/orderQna/replyWrite.oq?pur_q_seq=<%=qna.getPur_q_seq()%>&isReply=1&pageNum=<%=p.getPageNum() %>">답변 달기
												<span class="blind">답변 달기</span>
											</a>
											<% } %>
											<a class="btn" href="javascript:del('<%=qna.getPur_q_seq() %>');">삭제</a>
										</div>
									</div>
									<%
									OrderQnaDAO dao = new OrderQnaDAO();
									OrderQnaDTO reply = dao.selectReply(qna);
									
									if(reply.getContent() != null) {
									%>
									<div class="admin_content_wrap">
										<div class="admin_content">
											<p><%=reply.getContent() %></p>
										</div>
										<div class="btn_wrap">
											<a class="update_btn" href="<%=request.getContextPath()%>/orderQna/replyUpdate.oq?pur_q_seq=<%=reply.getPur_q_seq()%>&isReply=1&pageNum=<%=p.getPageNum() %>">
												<span class="blind">수정</span>
											</a>
											<a class="delete_btn" href="javascript:delReply('<%=reply.getPur_q_seq() %>','<%=reply.getRef_seq() %>');">
												<span class="blind">삭제</span>
											</a>
										</div>
									</div>
									<% } %> <!-- if(reply) -->
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
				<a class="first arrow" href="reply.oq?pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="reply.oq?pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="reply.oq?pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="reply.oq?pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="reply.oq?pageNum=<%=p.getRealEnd() %>">
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