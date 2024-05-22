<%@page import="dao.ReviewDAO"%>
<%@page import="common.PageDTO"%>
<%@page import="dto.ReviewDTO"%>
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
int userNum = 0;
if (sUserNum != null) {
	userNum = Integer.parseInt(sUserNum);
}
PageDTO p = (PageDTO)request.getAttribute("paging");
ReviewDTO myReview = (ReviewDTO)request.getAttribute("myReview");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>review/reviewList</title>
<script>
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
<h1>리뷰 보기</h1>
<ul>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=latest" <%="latest".equals(orderBy)%>>최신순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=oldest" <%="oldest".equals(orderBy)%>>오래된순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=highest" <%="highest".equals(orderBy)%>>평점높은순</a></li>
	<li><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage() %>&orderBy=lowest" <%="lowest".equals(orderBy)%>>평점낮은순</a></li>
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
<%if(userNum != 0 && (userNum == dto.getUserNum())) {%>
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
<%if(p.isPrev()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=1&orderBy=<%=orderBy %>">[처음]</a><% } %>
<%if(p.isPrev()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getStartPage()-1 %>&orderBy=<%=orderBy %>">[이전]</a><%} %>
<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()) {%>
		<b>[<%=i %>]</b>
		<%}else {%>
		<a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&reviewNum=<%=myReview.getReviewNum() %>&pageNum=<%=i %>&orderBy=<%=orderBy %>">[<%=i %>]</a>
		<%} %>
	<%} %>
<%if(p.isNext()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getEndPage()+1 %>&orderBy=<%=orderBy %>">[다음]</a><%} %>
<%if(p.isNext()) {%><a href="reviewList.do?bookNum=<%=bookNum %>&userNum=<%=userNum %>&pageNum=<%=p.getRealEnd() %>&orderBy=<%=orderBy %>">[마지막]</a><% } %>
</td>
</tr>
<%} %>
</table>
</body>
</html>