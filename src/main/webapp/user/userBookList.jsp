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
	String category = (String)request.getAttribute("category");
	String list = (String)request.getAttribute("list");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Product List</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
function goToPage(book_seq) {
	location.href = "userBookDetail.bo?book_seq=" + book_seq;
}

function userPaging(pageNum){
	var searchWord = $('input[name="searchWord"]').val();
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals("") ) ? request.getParameter("category") : category%>";
	console.log("ppcategory_book_java: ", "<%=category %>", category);
	var list = "<%=list%>";
	var pageNum = <%=p.getPageNum()%>;
	$.ajax({
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userPaging.uapi',
        dataType:'json',
        data: {
        	pageNum: <%=p.getPageNum()%>, 
        	searchWord: searchWord,
        	category: category,
        	list : list
        },
        success: function (response) {
        	//, searchWord를 검색하고 페이지를 넘겨서 다시 받아오는 과정에서 문제 발생
	       var newUrl = window.location.pathname + "?pageNum="+ pageNum 
        	+ '&searchWord=' + encodeURIComponent(searchWord)
        	+ '&category=' + encodeURIComponent(category) +'&order=' + encodeURIComponent(list);
       		window.history.pushState({ path: newUrl }, '', newUrl);
	       makePaging(response, searchWord, category);  
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}

function makePaging(data){
	let html = ''; 
	<% if(p.isPrev()) {%>
		html += '<a href="userBookList.bo?pageNum=1&searchWord=<%=searchWord%>&category=<%=category%>'
			 +'&order=<%=list%>">[First]</a>';
	<%}%>	
	<%if(p.isPrev()) {%> 
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getStartPage()-1%>
			+ '&searchWord=<%=searchWord%>&category=<%=category%>' +'&order=<%=list%>">[Prev]</a>'; 
	<% } %>
	<%
	for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {
		%>
		<%if(i == p.getPageNum()){%>
			html += '<b>[' + <%=i %> + ']</b>';
		<%}else{ %>
			html += '<a href="userBookList.bo?pageNum=' + <%=i%> 
				+ '&searchWord=<%=searchWord%>&category=<%=category%>' +'&order=<%=list%>">[' + <%=i %> +']</a>';
		<%}
	} 
	%>
	<%if(p.isNext()){%>
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getEndPage()+1%> 
			+ '&searchWord=<%=searchWord%>&category=<%=category%>' +'&order=<%=list%>">[Next]</a>';
	<% } %>
	<%if(p.isNext()){%>
		html += '<a href="userBookList.bo?pageNum=' + <%=p.getRealEnd()%>+ 
			'&searchWord=<%=searchWord%>&category=<%=category%>' +'&order=<%=list%>">[Last]</a>';
	<% } %>
    $('#userPaging').html(html);
    console.log(html);
}

function userSearch(){
	// searchWord 1	
	console.log("search_book_java: ", "<%=searchWord %>");
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals("") ) ? request.getParameter("category") : category%>";
	console.log("ssscategory_book_java: ", "<%=category %>", category);
	var list = "<%=list%>";
	// 제일 먼저 실행	
	$.ajax({
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userSearch.uapi',
        dataType:'json',
        data: {
        	pageNum: pageNum,
        	searchWord: searchWord,
        	category: category,
        	list : list
        },
        success: function (response) {
            var newUrl = window.location.pathname + "?pageNum="+ pageNum 
            + '&searchWord=' + encodeURIComponent(searchWord)
    		+ '&category=' + encodeURIComponent(category) +'&order=' + encodeURIComponent(list);
            window.history.pushState({ path: newUrl }, '', newUrl);
            makeSearch(response, searchWord, category); 
            userPaging();
        },
        error: function (request, status, error) {
            console.log(request, status, error);
        }
    });
}

//수량 증가 함수
function increaseBtn(bookSeq) {
	 var quantityInput = $('#quantity' + bookSeq);
	 var currentQuantity = parseInt(quantityInput.val());
	 quantityInput.val(currentQuantity + 1);
}

// 수량 감소 함수
function decreaseBtn(bookSeq) {
	var quantityInput = $('#quantity' + bookSeq);
    var currentQuantity = parseInt(quantityInput.val());
    if (currentQuantity > 1) {
        quantityInput.val(currentQuantity - 1);
    }
}

function makeSearch(data){
	let html = ''; 
	let cnt = 0;
    for(b of data){            	
		html += '<tr>';
    	html += '<td>' + (cnt += 1) + '</td>';
    	html += '<td  onclick="goToPage('+ b['book_seq'] + ')"><img alt="' + b['title'] + '" src="' + b['imageFile'] + '" ></td>';
    	html += '<td  onclick="goToPage('+ b['book_seq'] + ')">' + b['title'] + '</td>';
    	html += '<td>' + b['author'] + '</td>';
    	html += '<td>' + b['publisher'] + '</td>';
    	html += '<td>' + b['pubDate'] + '</td>';
    	html += '<td>' + b['description'] + '</td>';
    	html += '<td>' + b['price'] + '</td>';
    	html += '<td>' 
	       	+ '<div>'
            + '<button type="button" onclick="decreaseBtn('+ b['book_seq'] +')">-</button>'
            + '<input id="quantity'+ b['book_seq'] +'" type="number" name="cartICount" value="1"'
            + 'min="1" readonly>'
            + '<button type="button" onclick="increaseBtn('+ b['book_seq'] +')">+</button>'
        + '</div>'
		+ '<button type="button" onclick="buying('+ b['book_seq'] + ');">주문하기</button></td>';
    	html += '<td><button type="button">장바구니</button></td>';
    	html += '</tr>';         
    }
    $('#userBooks').html(html);
}

function userCategory(){
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals("") ) ? request.getParameter("category") : category%>";
	console.log("ccccategory_book_java: ", "<%=category %>", category);
	var list = "<%=list%>";
	$.ajax({
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userCategory.uapi',
        dataType:'json',
        data: {
        	pageNum: pageNum,
        	searchWord: searchWord,
        	category : category,
        	list : list
        },
        success: function (response) {
            var newUrl = window.location.pathname + "?pageNum="+ pageNum 
            		+ '&searchWord=' + encodeURIComponent(searchWord)
            		+ '&category=' + encodeURIComponent(category) +'&order=' + encodeURIComponent(list);
            window.history.pushState({ path: newUrl }, '', newUrl);
            makeCategory(response, searchWord, category); 
        },
        error: function (request, status, error) {
            console.log(request, status, error);
        }
    });
}

function makeCategory(data){
	let html = ''; 
	let cnt = 0;
		html += '<li><a href="userBookList.bo?pageNum=1&searchWord=&category=">[전체]</a></li>';
		html += '<li><a href="userBookList.bo?pageNum=1&searchWord=&category=만화">[만화]</a></li>';
		html += '<li><a href="userBookList.bo?pageNum=1&searchWord=&category=소설/시/희곡">[소설 / 시 / 희곡]</a></li>';
		html += '<li><a href="userBookList.bo?pageNum=1&searchWord=&category=수험서/자격증">[수험서 / 자격증]</a></li>';
		html += '<li><a href="userBookList.bo?pageNum=1&searchWord=&category=인문학">[인문학]</a></li>';
    $('#userCategory').html(html);
}

$(function(){
	<%if (request.getParameter("searchWord") != null){%>
		$('input[name="searchWord"]').val("<%=request.getParameter("searchWord")%>");
		<%} else {%>
		searchWord = "<%= searchWord %>";
        $('input[name="searchWord"]').val("<%=searchWord%>");
        <%	}%>
        
	userSearch();
	userCategory();
	userPaging();
	console.log("카테", "<%=category%>");
});


function buying(book_seq){
	console.log("buying");
    var cartICount = $('input[name="cartICount"]').val();
    console.log(cartICount);
    var cus_seq = "<%=session.getAttribute("cus_seq")%>"
    console.log(cus_seq);
    $.ajax({
        url: '<%=request.getContextPath()%>/user/customerOrder.uapi',
        method: 'POST', // 또는 'GET'
        data: {
            book_seq: book_seq,
            cartICount: cartICount,
            cus_seq: cus_seq,
        },
        success: function(response) {
            // 성공 시 처리 (예: 다른 페이지로 이동)
            location.href = "<%=request.getContextPath()%>/customerBuyOrder.cc";
        },
        error: function(error) {
            console.error('에러 발생:', error);
        }
    });
	                                                                                                                                                                                                                                                                                                                                                                                                       
}
</script>
</head>
<body>
	<%@ include file="../common/menu.jsp"%>
	<!-- 제목 -->
	<h2>도서 목록 보기</h2>
	
	<!-- 카테고리 -->
	<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->
	<table border="1">
		<tr>
			<td>카테고리</td>	
		</tr>
		<tr>
			<td>
				<ul id="userCategory">
					
				</ul>	
			</td>
		</tr>
	</table>
	
	<!-- 전체 목록 -->
	<table border="1">
	<% 	
	if (searchWord != null && !searchWord.isEmpty()) { %>
		<tr>
			<td>검색어 : '<b><%=searchWord %></b>'</td>
		</tr>
		<%} else {%> <br> <%}%>
		<tr>
			<td>
				<ul>
					<li><a href="userBookList.bo?pageNum=<%=p.getPageNum() %>&searchWord=<%=searchWord %>&category=<%=category%>&list=latest"<%list = "latest";%>>최신순</a></li>
					<li><a href="userBookList.bo?pageNum=<%=p.getPageNum() %>&searchWord=<%=searchWord %>&category=<%=category%>&list=oldest"<%list = "oldest";%>>오래된 순</a></li>
					<li><a href="userBookList.bo?pageNum=<%=p.getPageNum() %>&searchWord=<%=searchWord %>&category=<%=category%>&list=popular"<%list = "popular";%>>인기순</a></li>					
				<%request.setAttribute("list", list);%>
				</ul>
			</td>
			<td>
			<form onsubmit="userSearch();">
				<input type="hidden" name="category"  value="<%=category%>" >
				<input type="text" name="searchWord"
					<%if(searchWord != null && !searchWord.equals("")){%> value="<%=searchWord%>" <%}%>
				placeholder="검색어를 입력하세요."> 
				<input type="submit" value="Search" >
			</form>
			</td>
			<td>
				전체 수 : <%=totalCount %>
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