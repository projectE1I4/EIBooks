<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList");
	BookDTO bookdto = new BookDTO();
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
	String searchWord = (String)request.getAttribute("searchWord");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product List</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
function userPaging(){
	
	$.ajax({
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userPaging.uapi',
        dataType:'json',
        data: {
        	pageNum: <%=p.getPageNum()%>, 
        	searchWord: "<%=searchWord%>"
        },
        success: function (response) {
        	//, searchWord
        	console.log("paging 거침", <%=searchWord%>);
	       makePaging(response, <%=searchWord%>);  
	       var newUrl = window.location.pathname + "?pageNum="+ <%=p.getPageNum()%> + '&searchWord=' + "<%=searchWord%>";
       		window.history.pushState({ path: newUrl }, '', newUrl);
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}

function makePaging(data, searchWord){
	let html = ''; 
	console.log("데이터", data);
	console.log("start", <%=p.getStartPage()%>);
	console.log("E", <%=p.getEndPage()%>);
	console.log("E", <%=p.getRealEnd()%>);
	<% if(p.isPrev()) {%>
		html += '<a href="userBookList.bo?pageNum=1&searchWord='
				+ <%=searchWord%> +'">[First]</a>';
	<%}%>	
	<%if(p.isPrev()) {%> 
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getStartPage()-1%>
			+ '&searchWord=' + <%=searchWord%> + '">[Prev]</a>'; 
	<% } %>
	
		console.log("for 전");
		console.log(<%=p.getStartPage()%>);
		console.log(<%=p.getTotal()%>);
		console.log(<%=p.getEndPage()%>);
	<%
	
	System.out.println("pageNum: " + p.getPageNum());
	System.out.println("amount: " + p.getAmount());
	System.out.println("totalCount: " + totalCount);
	System.out.println("startPage: " + p.getStartPage());
	System.out.println("endPage: " + p.getEndPage());
	System.out.println("realEnd: " + p.getRealEnd());
	
	for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {
		%> console.log("for 들어옴"); // 안들어오고 있음.
		<%if(i == p.getPageNum()){%>
		console.log("if 들어옴");
			html += '<b>[' + <%=i %> + ']</b>';
		<%}else{ %>
			html += '<a href="userBookList.bo?pageNum=' + <%=i%> 
				+ '&searchWord=<%=searchWord%>' + '">[' + <%=i %> +']</a>';
		console.log(html);
		<%}
	} 
	%>
	<%if(p.isNext()){%>
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getEndPage()+1%> 
			+ '&searchWord=' + <%=searchWord%> + '">[Next]</a>';
	<% } %>
	<%if(p.isNext()){%>
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getRealEnd()%>+ 
			'&searchWord=' + <%=searchWord%> + '">[Last]</a>';
	<% } %>
    $('#userPaging').html(html);
}

function userSearch(){
	// searchWord 1	
	console.log("search_book_java: ", <%=searchWord %>)
	var searchWord = "<%=searchWord%>";
	var pageNum = <%=p.getPageNum()%>;
	// 제일 먼저 실행	
	$.ajax({
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userSearch.uapi',
        dataType:'json',
        data: {
        	pageNum: pageNum,
        	searchWord: "<%=searchWord%>"
        },
        success: function (response) {
            makeSearch(response, searchWord); 
            
            var newUrl = window.location.pathname + "?pageNum="+ pageNum + '&searchWord=' + "<%=searchWord%>";
            window.history.pushState({ path: newUrl }, '', newUrl);
        },
        error: function (request, status, error) {
            console.log(request, status, error);
        }
    });
}

function makeSearch(data){
	let html = ''; 
	let cnt = 0;
    for(b of data){            	
		html += '<tr>';
    	html += '<td>' + (cnt += 1) + '</td>';
    	html += '<td><img alt="' + b['title'] + '" src="' + b['imageFile'] + '" ></td>';
    	html += '<td>' + b['title'] + '</td>';
    	html += '<td>' + b['author'] + '</td>';
    	html += '<td>' + b['publisher'] + '</td>';
    	html += '<td>' + b['pubDate'] + '</td>';
    	html += '<td>' + b['description'] + '</td>';
    	html += '<td>' + b['price'] + '</td>';
    	html += '<td><button type="button">주문하기</button></td>';
    	html += '<td><button type="button">장바구니</button></td>';
    	html += '</tr>';         
    }
    $('#userBooks').html(html);
}

$(function(){
	var urlParams = new URLSearchParams(window.location.search);
	// var searchWord = urlParams.get('searchWord');
	// var searchWord = $('input[name="searchWord"]').val();
		
	if ("<%=searchWord%>" != null){
		$('input[name="searchWord"]').val(decodeURIComponent("<%=searchWord%>"));
	} else {
		searchWord = '<%= searchWord %>';
        $('input[name="searchWord"]').val(<%=searchWord%>);
	}
	userSearch();
	userPaging();
});
</script>
</head>
<body>
	<%@ include file="../common/menu.jsp"%>
	<!-- 제목 -->
	<h2>도서 목록 보기</h2>
	
	<!-- 카테고리 -->
	<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->

	<!-- 전체 목록 -->
	<table border="1">
	<% if (searchWord != null && !searchWord.isEmpty()) { %>
		<tr>
			<td>검색어 : '<b><%=searchWord %></b>'</td>
		</tr>
		<%} else {%> <br> <%}%>
		<tr>
			<td>
				<input type="text" name="searchWord"
					<%if(searchWord != null && !searchWord.equals("")){%> value="<%=searchWord%>" <%}%>
				placeholder="검색어를 입력하세요."> 
				<input type="button" value="Search" onclick="userSearch()">
			</td>
		</tr>
	</table>
	
	<table border="1">
		<thead>
			<tr>
				<th>넘버링</th>
				<th>이미지</th>
				<th>도서명</th>
				<th>저자명</th>
				<th>출판사</th>
				<th>출간일</th>
				<th>디스크립션</th>
				<th>금액</th>
				<th>바로구매</th>
				<th>장바구니</th>
			</tr>
		</thead>
		<tbody id="userBooks">

		</tbody>
	</table>

	<table border="1" width="90%">
		<tr>
			<td colspan="8" id="userPaging"></td>
		</tr>
	</table>
</body>
</html>