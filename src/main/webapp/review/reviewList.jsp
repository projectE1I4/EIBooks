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
String reviewNum = (String)request.getAttribute("reviewNum");
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
			location.href = "<%=request.getContextPath()%>/review/reviewDeleteProc.do?bookNum=<%=bookNum %>&userId=<%=userId %>&reviewNum=<%=reviewNum %>";
		}else{
			alert("삭제를 취소했습니다.");
			return;
		}
	}
</script>
</head>
<body>
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
<td colspan="3">
<a href="reviewUpdate.do?bookNum=<%=bookNum %>&userId=<%=userId %>">[수정하기]</a> 
<a href="javascript:del('<%=dto.getReviewNum() %>')">[삭제하기]</a>
</td>
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