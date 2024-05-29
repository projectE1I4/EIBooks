<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- <meta name="viewport" content="width=1280"> -->
<meta name="format-detection" content="telephone=no">
<meta name="description" content="EIBooks">
<meta property="og:type" content="website">
<meta property="og:title" content="EIBooks">
<meta property="og:description" content="EIBooks">
<meta property="og:image"
	content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg" />
<meta property="og:url"
	content="http://hyerin1225.dothome.co.kr/EIBooks" />
<title>EIBooks</title>
<link rel="icon" href="images/favicon.png">
<link rel="apple-touch-icon" href="images/favicon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;500&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="/EIBooks/styles/css/jquery-ui.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/swiper-bundle.min.css">
<link rel="stylesheet" href="/EIBooks/styles/css/aos.css">
<link rel="stylesheet"
	href="/EIBooks/styles/css/common.css?v=<?php echo time(); ?>">
<link rel="stylesheet"
	href="/EIBooks/styles/css/header.css?v=<?php echo time(); ?>">
<link rel="stylesheet"
	href="/EIBooks/styles/css/footer.css?v=<?php echo time(); ?>">
<link rel="stylesheet"
	href="/EIBooks/styles/css/main.css?v=<?php echo time(); ?>">
<link rel="stylesheet"
	href="/EIBooks/styles/css/Uproduct_main/userProductList.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<script type="text/javascript">
  $(document).ready( function() {
	    
      $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
      $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다
    
    });
    </script>
<title>Product List</title>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
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
	<%}%>
    $('#userPaging').html(html);
}

function userSearch(){
	// searchWord 1	
	console.log("search_book_java: ", "<%=searchWord%>");
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals(""))
		? request.getParameter("category")
		: category%>";
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
    	html += '<td class="price'+ b['book_seq'] + '">' + b['price'] + '</td>';
    	html += '<td>' 
	       	+ '<div>'
            + '<button type="button" onclick="decreaseBtn('+ b['book_seq'] +')">-</button>'
            + '<input id="quantity'+ b['book_seq'] +'" type="number" name="'+b['book_seq'] +'" value="1"'
            + 'min="1" readonly style="width:30px;">'
            + '<button type="button" onclick="increaseBtn('+ b['book_seq'] +')">+</button>'
        + '</div>'
		+ '<button type="button" onclick="buying('+ b['book_seq'] + ');">주문하기</button></td>';
    	html += '<td><button type="button" onclick="goToCustomerCart('+b['book_seq'] + ');">장바구니</button></td>';
    	html += '</tr>';         
    }
    $('#userBooks').html(html);
}

function userCategory(){
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals(""))
		? request.getParameter("category")
		: category%>";
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
        },
        error: function (request, status, error) {
            console.log(request, status, error);
        }
    });
}


function goToCustomerCart(book_seq){
    var cartICount = $('input[name="'+book_seq+'"]').val();
    $.ajax({
        type: "POST",
        url: "<%=request.getContextPath()%>/customerCartInsert.cc",
        data: {
            book_seq: book_seq,
            cartICount: cartICount
        },
        success: function(response) {
            alert("장바구니에 담겼습니다.");
            // 여기서 response를 사용하여 필요한 처리를 할 수 있습니다.
        },
        error: function(xhr, status, error) {
            console.error("Error: " + error);
        }
    });
}


$(function(){
	<%if (request.getParameter("searchWord") != null) {%>
		$('input[name="searchWord"]').val("<%=request.getParameter("searchWord")%>");
		<%} else {%>
		searchWord = "<%=searchWord%>";
        $('input[name="searchWord"]').val("<%=searchWord%>");
        <%}%>
            
	userSearch();
	userCategory();
	userPaging();

	$('.sort_main').click(function() {
        $(this).next('.sort_menu').slideToggle();
    });
	
	$(document).click(function(e) {
        if (!$(e.target).closest('.sort_wrap').length) {
            $('.sort_menu').slideUp();
        }
    });
	
    $('.sort_menu li a').click(function(e) {
        e.preventDefault();
        var selectedText = $(this).text();
        $('.sort').text(selectedText);
        $('.sort_menu').slideUp();
        window.location.href = $(this).attr('href');
    });

});

//  주문하기 버튼 클릭 시 주문하기 페이지로 이동
function buying(book_seq){
	var className = "cartICount" + book_seq;
    var cartICount = $('input[name="'+book_seq+'"]').val();
    var cus_seq = "<%=session.getAttribute("cus_seq")%>"
    var priceClass = 'price' + book_seq;
    var price = $('.' + priceClass).text(); 
    
    location.href = "<%=request.getContextPath()%>/customerBuyOrder.cc?"
          + "book_seq=" +book_seq
          + '&cartICount=' + cartICount
          + '&totalCartPrice=' + (price*cartICount);
                                                                                                                                                                                                                                                                                                                                                                                                          
}





</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="../common/menu.jsp"%>
		<!-- 제목 -->
		<header id="header"></header>
		<main id="container">
			<section class="list_main">
				<!-- 카테고리 -->
				<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->
				<div class="category">
					<div class="catrgory_wrap">
						<h3 class="category_title">CATEGORY</h3>
						<ul id="userCategory" class="userCategory">
							<li class="category_List"><a
								href="userBookList.bo?pageNum=1&searchWord=&category=">[전체]</a></li>
							<li class="category_List"><a
								href="userBookList.bo?pageNum=1&searchWord=&category=만화">[만화]</a></li>
							<li class="category_List"><a
								href="userBookList.bo?pageNum=1&searchWord=&category=소설/시/희곡">[소설
									/ 시 / 희곡]</a></li>
							<li class="category_List"><a
								href="userBookList.bo?pageNum=1&searchWord=&category=수험서/자격증">[수험서
									/ 자격증]</a></li>
							<li class="category_List"><a
								href="userBookList.bo?pageNum=1&searchWord=&category=인문학">[인문학]</a></li>
						</ul>
					</div>
				</div>
				<!-- 전체 목록 -->
				<div class="main_contents">


					<div class="middle_bar">
						<div class="sort">
							<ul class="sort_wrap">
								<li class="sort_main">
								<%= "latest".equals(list) ? "최신순" 
									:"oldest".equals(list) ? "오래된순" 
									: "popular".equals(list) ? "인기순" 
									: "최신순" %> 
									<img src="../styles/images/undo_tabler_io.svg" alt="" />
								</li>
								<ul class="sort_menu">
								<li><a
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&list=latest"
									<%list = "latest";%>>최신순</a></li>
								<li><a
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&list=oldest"
									<%list = "oldest";%>>오래된 순</a></li>
								<li><a
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&list=popular"
									<%list = "popular";%>>인기순</a></li>
								<%
								request.setAttribute("list", list);
								%>
								</ul>
							</ul>
						</div>
						<div class="result_wrap">
							<div class="searchWord_wrap">
								<%if (searchWord != null && !searchWord.isEmpty()) {%>
									<p class="searchWord_text">
										검색어 : '<b><%=searchWord%></b>'
									</p>
								<%} else {%>
									<p class="searchWord_text"></p>
								<% } %>
							<div>
								전체 수 :
								<%=totalCount%>
							</div>
							</div>
						</div>
							<div>
								<form onsubmit="userSearch();">
									<input type="hidden" name="category" value="<%=category%>">
									<input type="text" name="searchWord"
										<%if (searchWord != null && !searchWord.equals("")) {%>
										value="<%=searchWord%>" <%}%> placeholder="검색어를 입력하세요.">
									<input type="submit" value="Search">
								</form>
							</div>
							
						

					</div>
					<div class="main_books">
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
					</div>
				</div>
			</section>


			<table border="1" width="90%">
				<tr>
					<td colspan="8" id="userPaging"></td>
				</tr>
			</table>
		</main>
		<footer id="footer"></footer>
	</div>
</body>
</html>