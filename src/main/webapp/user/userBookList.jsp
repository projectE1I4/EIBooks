<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 가져오는 방식에 대해서 고민
	List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList");
	BookDTO bookdto = new BookDTO();
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 목록 보기</title>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
	<%
	BookDTO dto = new BookDTO();
	%>

function userGetBooks(){
	$.ajax({
        // contentType: "application/json",
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userBookList.uapi',
        dataType:'json',
        data: {pageNum: <%=p.getPageNum()%>, searchWord: $('input[name="searchWord"]').val()},
        // data:JSON.stringify(param),
        success: function (response) {
        	//console.log(response);
            makeList(response);            
        },
        error: function (response, request, status, error)
       {
            console.log(request, status, error);
        }
    });
}

function userPaging(){
	$.ajax({
        //contentType: "application/json",
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userPaging.uapi',
        dataType:'json',
        //data:param,
        //data:JSON.stringify(param),
        data:{searchWord: $('input[name="searchWord"]').val()},
        success: function (response) {
            console.log(response);
            makePaging(response);            
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}

function userSearch(){
	$.ajax({
        //contentType: "application/json",
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userSearch.uapi',
        dataType:'json',
        data:{pageNum: <%=p.getPageNum()%>, searchWord: $('input[name="searchWord"]').val()},
        //data:JSON.stringify(param),
        success: function (response) {
            console.log(response);
            makeSearch(response); 
            console.log(data);
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}

function userCategory(){
	$.ajax({
        //contentType: "application/json",
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userCategory.uapi',
        dataType:'json',
        //data:param,
        //data:JSON.stringify(param),
        success: function (response) {
            console.log(response);
            makePaging(response);            
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}

function makeList(data){
	let html = ''; 
	let cnt = 0;
	
    for(b of data){            	
		html += '<tr>';
    	html += '<td>' + (cnt += 1) + '</td>';
    	html += '<td>' + '<img alt="' + b['title'] + '" src="' + b['imageFile'] + '" >' + '</td>';
    	html += '<td>' + b['title'] + '</td>';
    	html += '<td>' + b['author'] + '</td>';
    	html += '<td>' + b['publisher'] + '</td>';
    	html += '<td>' + b['pubDate'] + '</td>';
    	html += '<td>' + b['description'] + '</td>';
    	html += '<td>' + b['price'] + '</td>';
    	html += '<td>' + '<button type="button">주문하기</button>' + '</td>';
    	html += '<td>' + '<button type="button">장바구니</button>' + '</td>';
    	html += '</tr>\n';         
    }
    $('#userBooks').html(html);
}

function makePaging(data){
	let html = ''; 
	let cnt = 0;
	
	console.log("데이터", data);
	console.log(<%=p.getStartPage()%>);
    	<% System.out.print("프리브"+p.isNext()); %>
    	<%if(p.isPrev()) {%>
    		html += '<a href= "userBookList.bo?pageNum=1
    			<%if($('input[name="searchWord"]').val() != null){%>
    				 '&searchWord=' + $('input[name="searchWord"]').val() 
   				<%}%> '>[First]</a>';
    	<%-- getStartPage는 이전 10개 전으로 돌아감. 수식 확인 필요 --%>
    	<%if(p.isPrev()) {%> 
    		html += '<a href=' + '"userBookList.bo?pageNum=' + <%=p.getStartPage()-1%> +
    		<%if($('input[name="searchWord"]').val() != null){
				%>+ '&searchWord=' +<%=$('input[name="searchWord"]').val()%> <%
			}%>
			+ '">[Prev]</a>'; 
    	<% } %>
    	<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
    		<%if(i == p.getPageNum()){%>
    			html += '<b>[' + <%=i %> + ']</b>';
    		<%}else{ %>
    			html += '<a href="userBookList.bo?pageNum=' + <%=i%> 
    			<%if($('input[name="searchWord"]').val() != null){
					%>+ '&searchWord=' +<%=$('input[name="searchWord"]').val()%> 
				<%}%>
				'">[' + <%=i %> +']</a>';
    		<%} %>
    	<%} %>
    	<%if(p.isNext()){%>
    		html += '<a href="userBookList.bo?pageNum=' + <%=p.getEndPage()+1%> + <%if($('input[name="searchWord"]').val() != null){
				%>+ '&searchWord=' +<%=$('input[name="searchWord"]').val()%> <%
			}%>+ '">[Next]</a>';
    	<% } %>
    	<%if(p.isNext()){%>
    		html += '<a href="userBookList.bo?pageNum=' + <%=p.getRealEnd()%>+ <%if($('input[name="searchWord"]').val() != null){
				%>+ '&searchWord=' +<%=$('input[name="searchWord"]').val()%> <%
			}%>+ '">[Last]</a>';
    	<% } %>
    $('#userPaging').html(html);
}

function makeSearch(data){
	let html = ''; 
	let cnt = 0;
	
    for(b of data){            	
		html += '<tr>';
    	html += '<td>' + (cnt += 1) + '</td>';
    	html += '<td>' + '<img alt="' + b['title'] + '" src="' + b['imageFile'] + '" >' + '</td>';
    	html += '<td>' + b['title'] + '</td>';
    	html += '<td>' + b['author'] + '</td>';
    	html += '<td>' + b['publisher'] + '</td>';
    	html += '<td>' + b['pubDate'] + '</td>';
    	html += '<td>' + b['description'] + '</td>';
    	html += '<td>' + b['price'] + '</td>';
    	html += '<td>' + '<button type="button">주문하기</button>' + '</td>';
    	html += '<td>' + '<button type="button">장바구니</button>' + '</td>';
    	html += '</tr>\n';         
    }
    $('#userBooks').html(html);
}

$(function(){
	if($('input[name="searchWord"]').val() == null){
		userGetBooks();		
	} else {
		userSearch();
	}
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
		<%
	String searchWord = request.getParameter("searchWord");
	if (searchWord != null && !searchWord.isEmpty()) {
    	// 입력 값이 있을 때 실행할 코드%>
		<tr>
			<td>검색어 : '<b><%=searchWord %></b>'
			</td>
		</tr>
		<%} else {// 입력 값이 없을 때 실행할 코드%><br>
		<%}%>
		<tr>
			<td><input type="text" name="searchWord"
				<%if(searchWord !=null){%> value="<%=searchWord%>" <%} %>
				placeholder="검색어를 입력하세요."> <input type="button"
				value="Search" onclick="userSearch()"></td>
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