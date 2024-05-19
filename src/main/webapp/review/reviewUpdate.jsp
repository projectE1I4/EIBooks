<%@page import="common.PageDTO"%>
<%@page import="dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
int totalCount = (int)request.getAttribute("totalCount");
String orderBy = (String)request.getAttribute("orderBy");
String bookNum = (String)request.getAttribute("bookNum");
String userId = (String)request.getAttribute("userId");
PageDTO p = (PageDTO)request.getAttribute("paging");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>review/reviewUpdate</title>
<script type="text/javascript">
function validateForm() {
	const form = document.updateForm;
	console.dir(form); // input 
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

function goToPage(bookNum, userId) {
	location.href = "reviewList.do?" + "bookNum=" + bookNum + "&userId=" + userId;
}
</script>
</head>
<body>
<h1>리뷰 수정</h1>
<form name="updateForm" method="post" action="/EIBooks/review/reviewUpdateProc.do?bookNum=<%=bookNum %>">
	<table border="1" width="90%">
		<tr>
		<td>별점
		<select name="grade">
			<option name="grade" value="5">5</option>
			<option name="grade" value="5">4</option>
			<option name="grade" value="5">3</option>
			<option name="grade" value="5">2</option>
			<option name="grade" value="5">1</option>
		</select>
		</td>
		</tr>
		<td><textarea name="content" style="width:100%; height:100px" placeholder="리뷰 작성 최대 200자" oninput="limitText(this, 200)"></textarea></td>
	</table>
	<input type="button" value="리뷰 수정" onclick="validateForm()">
	<input type="button" value="수정 취소" onclick="goToPage(<%=bookNum %>,<%=userId %>)">
</form>
<h1>리뷰 전체보기</h1>
<ul>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage() %>&orderBy=latest" <%="latest".equals(orderBy)%>>최신순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage() %>&orderBy=oldest" <%="oldest".equals(orderBy)%>>오래된순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage() %>&orderBy=highest" <%="highest".equals(orderBy)%>>평점높은순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage() %>&orderBy=lowest" <%="lowest".equals(orderBy)%>>평점낮은순</a></li>
</ul>
<span align="right">전체 리뷰 수: <%=totalCount %></span>
<table border="1" width="90%">
<% if(reviewList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>리뷰가 없습니다.</b></td></tr>
<% } else { %>
<%for(ReviewDTO dto:reviewList) {%>
	<tr>
		<td width="30%"><%=dto.getGrade() %></td>
		<td width="30%"><%=dto.getUserId() %></td>
		<td width="30%"><%=dto.getReviewDate() %></td>
	</tr>
<tr>
	<td colspan="3"><%=dto.getContent() %></td>
</tr>
<%if(userId != null && userId.equals(dto.getUserId())) {%>
<tr>
<td colspan="3">[수정하기] [삭제하기]</td>
</tr>
<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage() %>">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getStartPage()-1 %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=i %>&orderBy=<%=orderBy %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getEndPage()+1 %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userId=<%=userId %>&pageNum=<%=p.getEndPage() %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>
</body>
</html>