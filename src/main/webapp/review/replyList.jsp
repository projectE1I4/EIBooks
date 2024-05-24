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
<title>review/replyList.jsp</title>
<script>
	function del(reviewNum){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/review/depthOneDeleteProc.do?reviewNum=" + reviewNum;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
	function delReply(reviewNum, ref_seq){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/review/replyDeleteProc.do?reviewNum=" + reviewNum + "&ref_seq=" + ref_seq;
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
</script>
<style type="text/css">
	.reply td {
		background-color: #eee;
	}
	.content {
		height: 60px;
	}
</style>
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<h1>리뷰 전체보기</h1>
<span align="right">회원 전체 리뷰 수: <%=allReviewCount %></span>
<table border="1" width="90%">
<% if(reviewList.isEmpty()) { %>
	<tr><td colspan="8">&nbsp;<b>리뷰가 없습니다.</b></td></tr>
<% } else { %>
<%for(ReviewDTO dto:reviewList) {%>
	<tr>
		<td width="10%"><%=dto.getGrade() %></td>
		<td width="10%"><%=dto.getCusInfo().getCus_id() %></td>
		<td width="15%"><%=dto.getReviewDate() %></td>
		<%
		BookDTO bDto = new BookDTO();
		BookDAO bDao = new BookDAO();
		bDto.setBook_seq(dto.getBookNum());
		bDto = bDao.selectView(bDto);
		%>
		<td width="30%"><a href="/EIBooks/admin/productView.bo?book_seq=<%=dto.getBookNum()%>"><%=bDto.getTitle() %></a></td>
		<td width="20%"><a href="/EIBooks/customer/myOrderDetail.or?pur_seq=<%=dto.getPur_seq() %>">상세 주문 내역</a></td>
	</tr>
	<tr>
		<td colspan="5" class="content"><%=dto.getContent() %></td>
	</tr>
		<%if(!(userNum == dto.getUserNum())) {%>
			<tr>
				<td colspan="5">
					<% if(dto.getRef_YN().equals("Y")) { %>
						 [답글 달기]
					<% } else { %>
						<a href="replyWrite.do?bookNum=<%=dto.getBookNum() %>&reviewNum=<%=dto.getReviewNum() %>&isReply=1">[답글 달기]</a> 
					<% } %>
					<a href="javascript:del('<%=dto.getReviewNum() %>')">[리뷰 삭제]</a>
				</td>
		<% } %>
	</tr>
	<%
	ReviewDAO dao = new ReviewDAO();
	ReviewDTO reply = dao.selectReply(dto);
	System.out.println(reply);
	if (reply.getContent() != null) {
	%>
		<tr class="reply">
			<td width="30%">관리자</td>
			<td width="30%" colspan="4"><%=reply.getReviewDate() %></td>
		</tr>
		<tr class="reply">
			<td colspan="5" class="content"><%=reply.getContent() %></td>
		</tr>
		<%if(userNum == reply.getUserNum()) {%>
			<tr class="reply">
			<td colspan="5">
			<a href="replyUpdate.do?reviewNum=<%=reply.getReviewNum() %>&isReply=1">[답글 수정]</a> 
			<a href="javascript:delReply('<%=reply.getReviewNum() %>', '<%=reply.getRef_seq()%>')">[답글 삭제]</a>
			</td>
			</tr>
		<%} %>
	<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="replyList.do?pageNum=1">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="replyList.do?pageNum=<%=p.getStartPage()-1 %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="replyList.do?pageNum=<%=i %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="replyList.do?pageNum=<%=p.getEndPage()+1 %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="replyList.do?pageNum=<%=p.getRealEnd() %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>

</body>
</html>