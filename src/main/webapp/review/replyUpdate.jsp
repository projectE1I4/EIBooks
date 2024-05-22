<%@page import="dao.ReviewDAO"%>
<%@page import="common.PageDTO"%>
<%@page import="dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
String sUserNum = request.getParameter("userNum");
int userNum = Integer.parseInt(sUserNum);
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
<title>replyUpdate.jsp</title>

<script type="text/javascript">
function validateForm(refYN) {
	const form = document.writeForm;
	if(refYN === "Y"){
		console.log(reviewCount);
		alert("이미 작성한 리뷰가 있습니다.");
		location.href = "<%=request.getContextPath() %>/review/replyUpdate.do?userNum=<%=userNum %><% if(myReview != null) { %>&reviewNum=<%=myReview.getReviewNum() %><% } %>";
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
	const input = confirm("정말 삭제하시겠습니까?");
	if(input){
		location.href = "<%=request.getContextPath()%>/review/depthOneDeleteProc.do?userNum=<%=userNum%>&reviewNum=" + reviewNum;
	}else{
		alert("삭제를 취소했습니다.");
		return;
	}
	location.href = "<%=request.getContextPath()%>/review/replyUpdate.do?userNum=<%=userNum%>&reviewNum=<%=reviewNum%>&isReply=1"
}

function delReply(reviewNum){
	const input = confirm("정말 삭제하시겠습니까?");
	if(input){
		location.href = "<%=request.getContextPath()%>/review/replyDeleteProc.do?userNum=<%=userNum %><% if(myReview != null) { %>&reviewNum=<%=myReview.getReviewNum() %><% } %>";
	}else{
		alert("삭제를 취소했습니다.");
		return;
	}
}

function isReply(reviewNum) {
	isReply = 1;
	location.href="replyUpdate.do?userNum=<%=userNum %>&reviewNum=" + reviewNum + "&isReply=<%=isReply%>";
}

function goToPage() {
	location.href = "/EIBooks/review/replyList.do?userNum=<%=userNum%>";
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
	.reply td {
		background-color: #eee;
	}
	.content {
		height: 60px;
	}
	.insert {
		background-color: #E8F2FE;
	}
</style>

</head>
<body>

<%@ include file="../common/menu.jsp" %>
 
<h1>전체리뷰 보기</h1>
<span align="right">전체 리뷰 수: <%=allReviewCount %></span>
<table border="1" width="90%">
<% if(reviewList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>리뷰가 없습니다.</b></td></tr>
<% } else { %>
<%for(ReviewDTO dto:reviewList) {%>
	<tr class="review">
		<td width="5%"><%=dto.getGrade() %></td>
		<td width="10%"><%=dto.getUserId() %></td>
		<td width="20%"><%=dto.getReviewDate() %></td>
		<td width="30%"><%=dto.getBookNum() %></td>
		<td width="20%">주문 내역 버튼</td>
	</tr>
<tr>
	<td colspan="5" class="content"><%=dto.getContent() %></td>
</tr>
<%if(!(userNum == dto.getUserNum())) {%>
		<tr>
		<td colspan="5">
			 <a>[답글 달기]</a>
		<a href="javascript:del('<%=dto.getReviewNum() %>')">[리뷰 삭제]</a>
		</td>
		</tr>
	<%} %>
	<%
	ReviewDAO dao = new ReviewDAO();
	ReviewDTO reply = dao.selectReply(dto);
	if (reply.getContent() != null) {
	%>
		<% if (reviewNum == reply.getReviewNum() && isReply == 1) { %>
		<tr>
			<td colspan="5" class="insert">
				<form name="writeForm" method="post" action="/EIBooks/review/replyUpdateProc.do?userNum=<%=userNum%>&reviewNum=<%=reviewNum%>">
					<textarea name="content" style="width:100%; height:100px" placeholder="답글 작성 최대 200자" oninput="limitText(this, 200)"><%=reply.getContent() %></textarea>
					<input type="submit" value="수정 확인" onclick="validateForm('<%=dto.getRef_YN() %>')">
					<input type="button" value="수정 취소" onclick="goToPage()">
			</form>
			</td>
		</tr>
		<% } %>
		<%
	if (reply.getContent() != null) { // 댓글내용이 있으면 무조건 보여줘
	%>
		<%if(reviewNum != dto.getReviewNum()) {%> <%// 현재 보고 있는 답글이 아닌 경우에만 표시 %>
			<% if(userNum != reply.getUserNum()) { %> <%// 현재 사용자가 해당 답글의 작성자가 아닌 경우에만 표시 %>
			<% } else if(reviewNum != dto.getReviewNum()) { %> <%//현재 보고 있는 답글인 경우에만 표시 %>
		<tr class="reply">
			<td width="30%">관리자</td>
			<td width="30%" colspan="4"><%=reply.getReviewDate() %></td>
		</tr>
		<tr class="reply">
			<td colspan="5" class="content"><%=reply.getContent() %></td>
		</tr>
		<tr class="reply">
		<td colspan="5">
			<a href="replyUpdate.do?userNum=<%=userNum %>&reviewNum=<%=reply.getReviewNum() %>&isReply=1">[답글 수정]</a> 
			<a href="javascript:delReply('<%=reply.getReviewNum() %>', '<%=reply.getRef_seq()%>')">[답글 삭제]</a>
			</td>
			</tr>
		<%} %>
		<%} %>
	<%} %>

	<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="replyUpdate.do?userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="replyUpdate.do?userNum=<%=userNum %>&pageNum=<%=p.getStartPage()-1 %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="replyUpdate.do?userNum=<%=userNum %>&reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=i %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="replyUpdate.do?userNum=<%=userNum %>&pageNum=<%=p.getEndPage()+1 %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="replyUpdate.do?userNum=<%=userNum %>&pageNum=<%=p.getEndPage() %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>

</body>
</html>