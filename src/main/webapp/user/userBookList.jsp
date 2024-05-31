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
	//String list = (String)request.getAttribute("list");
	String list = request.getParameter("order");
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



function userSearch(){
	// searchWord 1	
	console.log("search_book_java: ", "<%=searchWord%>");
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals(""))
		? request.getParameter("category")
		: category%>";
	var list = "<%=list%>";
	console.log(list + "list");
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
    	html += '<div class="book_wrap">';
        html += '<div class="cnt_wrap"><div class="cnt">' + (cnt += 1) + '</div></div>';
        html += '<div class="img_wrap"><div onclick="goToPage(' + b['book_seq'] + ')"><img alt="' + b['title'] + '" src="' + b['imageFile'] + '"></div></div>';
        html += '<div class="info_wrap">';
        html += '<div class="title" onclick="goToPage(' + b['book_seq'] + ')">' + b['title'] + '</div>';
        html += '<div class="sort_area"><div class="left_wrap">';
        html += '<div class="author">' + b['author'] + '</div>';
        html += '<div class="pub_wrap">'
        html += '<div>' + b['publisher'] + '</div>';
        html += '<div>' + b['pubDate'] + '</div>';
        html += '</div>';
        html += '<div class="description">' + b['description'] + '</div> </div>';
        html += '<div class="right_wrap"><div class="quantity_wrap">'
        	+ '<div class="price_wrap"><div class="price' + b['book_seq'] + ' prices">' + b['price'] + '</div><div>원</div></div>'        
        + '<button type="button" class="btn de_btn" onclick="decreaseBtn(' + b['book_seq'] + ')">-</button>'
                + '<input id="quantity' + b['book_seq'] + '" class="quantity" type="number" name="' + b['book_seq'] + '" value="1"'
                + ' min="1" readonly >'
                + '<button type="button" class="btn" onclick="increaseBtn(' + b['book_seq'] + ')">+</button>'
            + '</div>'
        + '<div class="buy_wrap">'
        + '<button type="button" class="btn buy_btn" onclick="buying(' + b['book_seq'] + ');">주문하기</button>';
        html += '<button type="button" class="btn buy_btn" onclick="goToCustomerCart(' + b['book_seq'] + ');">장바구니</button></div></div>';
        html += '</div></div></div>';
    }
    $('#userBooks').html(html);
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
	// userCategory();
	//userPaging();

	$('.sort_main').click(function() {
        $(this).next('.sort_menu').slideToggle();
        $(this).toggleClass('rotate');
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
		<%@ include file="../common/header.jsp"%>
		<!-- 제목 -->
		<header id="header"></header>
		<main id="container">
			<section class="list_main">
			<div class="category_area">
			
			
				<!-- 카테고리 -->
				<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->
				<div class="category">
					<div class="catrgory_wrap">
						<h3 class="category_title">CATEGORY</h3>
						<ul id="userCategory" class="userCategory">
							<li class="category_List"><a <%if(category.equals("")){%>class="check"<%} %>
								href="userBookList.bo?pageNum=1&searchWord=&category=">[전체]</a></li>
							<li class="category_List"><a <%if(category.equals("만화")){%>class="check"<%} %>
								href="userBookList.bo?pageNum=1&searchWord=&category=만화" >[만화]</a></li>
							<li class="category_List"><a <%if(category.equals("소설/시/희곡")){%>class="check"<%} %>
								href="userBookList.bo?pageNum=1&searchWord=&category=소설/시/희곡">[소설
									/ 시 / 희곡]</a></li>
							<li class="category_List"><a <%if(category.equals("수험서/자격증")){%>class="check"<%} %>
								href="userBookList.bo?pageNum=1&searchWord=&category=수험서/자격증">[수험서
									/ 자격증]</a></li>
							<li class="category_List"><a <%if(category.equals("인문학")){%>class="check"<%} %>
								href="userBookList.bo?pageNum=1&searchWord=&category=인문학">[인문학]</a></li>
						</ul>
					</div>
				</div>
				</div>
				<!-- 전체 목록 -->
				<div class="main_contents">
					<div class="middle_bar">
					<div class="middle_top">
								<%if (searchWord != null && !searchWord.isEmpty()) {%>
									<p class="searchWord_text">
										검색어 : '<b><%=searchWord%></b>'
									</p>
								<%} else {%>
									<p class="searchWord_text"></p>
								<% } %>
					<div>
					<div class="middle_bottom">
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
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=latest"
									<%="latest".equals(list)%>>최신순</a></li>
								<li><a
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=oldest"
									<%="oldest".equals(list)%>>오래된 순</a></li>
								<li><a
									href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=popular"
									<%="popular".equals(list)%>>인기순</a></li>
								<%
								request.setAttribute("list", list);
								request.setAttribute("order", list);
								%>
								</ul>
							</ul>
						</div>
							<div class="search_box">
								<form onsubmit="userSearch();">
									<input type="hidden" name="category" value="<%=category%>">
									<input type="text" name="searchWord" class="searchWord"
										<%if (searchWord != null && !searchWord.equals("")) {%>
										value="<%=searchWord%>" <%}%> placeholder="검색어를 입력하세요.">
									<input type="submit" class="search_btn" value="">
								</form>
							</div>
							<div class="result_wrap">
								전체 수 :	<%=totalCount%>
							</div>
							</div>
						</div>
					</div>
					</div>

					<div class="main_books">							
						<div id="userBooks">

						</div>
					</div>
				</div>
			</section>


			
			<div class="pagination">
	<%
	// 여기서 이미 list가 popular로 고정인데? list 
	%> 
	<%if(p.isPrev()) {%>
	<a class="first arrow" href="userBookList.bo?pageNum=1&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
		<span class="blind">첫 페이지</span>
	</a>
	<%} else { %>
		<a class="first arrow off"><span class="blind">첫 페이지</span></a>
	<% } %>
	
	<%if(p.isPrev()) {%>
	<a class="prev arrow" href="userBookList.bo?pageNum=<%=p.getStartPage()-1%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
		<span class="blind">이전 페이지</span>
	</a>
	<%} else { %>
		<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
	<%} %>
	
	<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
		<%if(i == p.getPageNum()) {%>
			<a class="number active"><%=i %></a>
		<%}else {%>
			<a class="number" href="userBookList.bo?pageNum=<%=i%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>"><%=i %></a>
		<%} %>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="next arrow" href="userBookList.bo?pageNum=<%=p.getEndPage()+1%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
		<span class="blind">다음 페이지</span>
	</a>
	<%} else { %>
		<a class="next arrow off"><span class="blind">다음 페이지</span></a>
	<%} %>
	
	<%if(p.isNext()) {%>
	<a class="last arrow" href="userBookList.bo?pageNum=<%=p.getRealEnd()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
		<span class="blind">마지막 페이지</span>
	</a>
	<%} else {%>
		<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
	<%} %>
</div>
		</main>
		<footer id="footer"></footer>
	</div>
</body>
</html>