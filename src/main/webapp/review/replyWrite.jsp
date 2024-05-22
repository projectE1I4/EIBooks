<%@page import="eibooks.dao.ReviewDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
String sBookNum = request.getParameter("bookNum");
int bookNum = Integer.parseInt(sBookNum);
String sUserNum = request.getParameter("userNum");
int userNum = Integer.parseInt(sUserNum);
PageDTO p = (PageDTO)request.getAttribute("paging");
ReviewDTO myReview = (ReviewDTO)request.getAttribute("myReview");
int allReviewCount = (int)request.getAttribute("allReviewCount");
String sReviewNum = request.getParameter("reviewNum");
int reviewNum = Integer.parseInt(sReviewNum);

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
<title>review/replyWrite.jsp</title>
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
	location.href = "<%=request.getContextPath()%>/review/replyWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum%>&reviewNum=<%=reviewNum%>&isReply=1"
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
	location.href="replyWrite.do?userNum=<%=userNum %>&reviewNum=" + reviewNum + "&isReply=<%=isReply%>";
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
<h1>답글 작성</h1>
 
<h1>리뷰 전체보기</h1>
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
		<% if(reviewNum == dto.getReviewNum()) { %>
			 [답글 달기]
		<% } else if(reviewNum != dto.getReviewNum()) { %>
			<a href="replyWrite.do?bookNum=<%=dto.getBookNum() %>&userNum=<%=userNum%>&reviewNum=<%=dto.getReviewNum() %>&isReply=1">[답글 달기]</a> 
		<% } %>
		<a href="javascript:del('<%=dto.getReviewNum() %>')">[리뷰 삭제]</a>
		</td>
		</tr>
	<%} %>
<% if (reviewNum == dto.getReviewNum() && isReply == 1) { %>
<tr>
	<td colspan="5" class="insert">
		<form name="writeForm" method="post" action="/EIBooks/review/replyWriteProc.do?bookNum=<%=bookNum %>&userNum=<%=userNum%>&reviewNum=<%=reviewNum%>">
			관리자
			<textarea name="content" style="width:100%; height:100px" placeholder="답글 작성 최대 200자" oninput="limitText(this, 200)"></textarea>
			<input type="button" value="등록 확인" onclick="validateForm('<%=dto.getRef_YN() %>')">
			<input type="button" value="답글 취소" onclick="goToPage()">
	</form>
	</td>
</tr>
<% } %>
	<%
	ReviewDAO dao = new ReviewDAO();
	ReviewDTO reply = dao.selectReply(dto);
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
			<a>[답글 수정]</a> 
			<a>[답글 삭제]</a>
			</td>
			</tr>
		<%} %>
	<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="replyWrite.do?userNum=<%=userNum %>&pageNum=1">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="replyWrite.do?userNum=<%=userNum %>&pageNum=<%=p.getStartPage()-1 %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="replyWrite.do?userNum=<%=userNum %>&reviewNum=<%=reviewNum %>&isReply=<%=isReply %>&pageNum=<%=i %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="replyWrite.do?userNum=<%=userNum %>&pageNum=<%=p.getEndPage()+1 %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="replyWrite.do?userNum=<%=userNum %>&pageNum=<%=p.getRealEnd() %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>

</body>
</html>