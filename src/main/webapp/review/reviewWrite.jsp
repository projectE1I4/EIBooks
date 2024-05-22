<%@page import="eibooks.dao.ReviewDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<ReviewDTO> reviewList = (List<ReviewDTO>)request.getAttribute("reviewList");
int totalCount = (int)request.getAttribute("totalCount");
String orderBy = (String)request.getAttribute("orderBy");
String sBookNum = request.getParameter("bookNum");
int bookNum = Integer.parseInt(sBookNum);
String sUserNum = request.getParameter("userNum");
int userNum = Integer.parseInt(sUserNum);;
PageDTO p = (PageDTO)request.getAttribute("paging");
int reviewCount = (int)request.getAttribute("reviewCount");
ReviewDTO myReview = (ReviewDTO)request.getAttribute("myReview");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>review/reviewWrite</title>
<script type="text/javascript">
function validateForm(reviewCount) {
	const form = document.writeForm;
	if(reviewCount > 0){
		console.log(reviewCount);
		alert("이미 작성한 리뷰가 있습니다. 리뷰 수정 페이지로 이동합니다.");
		location.href = "<%=request.getContextPath() %>/review/reviewUpdate.do?bookNum=<%=bookNum %>&userNum=<%=userNum %><% if(myReview != null) { %>&reviewNum=<%=myReview.getReviewNum() %><% } %>";
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
		location.href = "<%=request.getContextPath()%>/review/reviewDeleteProc.do?bookNum=<%=bookNum %>&userNum=<%=userNum %><% if(myReview != null) { %>&reviewNum=<%=myReview.getReviewNum() %><% } %>";
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
<h1>리뷰 작성</h1>
 <form name="writeForm" method="post" action="/EIBooks/review/reviewWriteProc.do?bookNum=<%=bookNum %>&userNum=<%=userNum%>">
	<table border="1" width="90%">
		<tr>
		<td>별점
		<select name="grade">
			<option name="grade" value="5">5</option>
			<option name="grade" value="4">4</option>
			<option name="grade" value="3">3</option>
			<option name="grade" value="2">2</option>
			<option name="grade" value="1">1</option>
		</select>
		</td>
		</tr>
		<td><textarea name="content" style="width:100%; height:100px" placeholder="리뷰 작성 최대 200자" oninput="limitText(this, 200)"></textarea></td>
	</table>
	<input type="button" value="리뷰 등록" onclick="validateForm(<%=reviewCount%>)">
</form>
<h1>리뷰 보기</h1>
<ul>
	<li><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=latest" <%="latest".equals(orderBy)%>>최신순</a></li>
	<li><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=oldest" <%="oldest".equals(orderBy)%>>오래된순</a></li>
	<li><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=highest" <%="highest".equals(orderBy)%>>평점높은순</a></li>
	<li><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=lowest" <%="lowest".equals(orderBy)%>>평점낮은순</a></li>
</ul>
<span align="right">전체 리뷰 수: <%=totalCount %></span>
<table border="1" width="90%">
<% if(reviewList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>리뷰가 없습니다.</b></td></tr>
<% } else { %>
<%for(ReviewDTO dto:reviewList) {%>
	<%
	ReviewDAO dao = new ReviewDAO();
	ReviewDTO reply = dao.selectReply(dto);
	if (reply.getContent() != null) {
	%>
	<tr>
		<td width="30%"><%=dto.getGrade() %></td>
		<td width="30%"><%=dto.getUserId() %></td>
		<td width="30%"><%=dto.getReviewDate() %></td>
	</tr>
	<tr>
		<td colspan="3" class="content"><%=dto.getContent() %></td>
	</tr>
<%if(userNum == dto.getUserNum()) {%>
<tr>
<td colspan="3">
<a href="reviewUpdate.do?bookNum=<%=bookNum %>&userNum=<%=userNum %><% if(myReview != null) { %>&reviewNum=<%=myReview.getReviewNum() %><% } %>">[수정하기]</a> 
<a href="javascript:del('<%=dto.getReviewNum() %>')">[삭제하기]</a>
</td>
</tr>
<%} %>
	<tr class="reply">
		<td width="30%">관리자</td>
		<td width="30%" colspan="2"><%=reply.getReviewDate() %></td>
	</tr>
	<tr class="reply">
		<td colspan="3" class="content"><%=reply.getContent() %></td>
	</tr>
	<%} %>
<%} %>
<tr>
<td colspan="6">
<%if(p.isPrev()) {%><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=1&orderBy=<%=orderBy %>">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage()-1 %>&orderBy=<%=orderBy %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=i %>&orderBy=<%=orderBy %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getEndPage()+1 %>&orderBy=<%=orderBy %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="reviewWrite.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getRealEnd() %>&orderBy=<%=orderBy %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>
</body>
</html>