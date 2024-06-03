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
	
	int cus_seq = 0;
	if (session.getAttribute("cus_seq") != null) {
		cus_seq = (int)session.getAttribute("cus_seq");
	}
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
	href="/EIBooks/styles/css/Uproduct_main/userProductList.css?v=<?php echo time(); ?>">
</head>

<body>
<script type="text/javascript">
// userBookDetail로 이동하는 함수
function goToPage(book_seq) {
	location.href = "userBookDetail.bo?book_seq=" + book_seq;
}

// 기본 리스트 생성 AJAX 함수
function userSearch(){
	var searchWord = $('input[name="searchWord"]').val();
	var pageNum = <%=p.getPageNum()%>;
	var category = "<%=(request.getParameter("category") != null && !request.getParameter("category").equals(""))
		? request.getParameter("category")
		: category%>";
	var list = "<%=list%>";
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

// 리스트 만드는 함수
function makeSearch(data){
	let html = ''; 
	let cnt = 0;
	
    for(b of data){ 
    	html += '<div class="book_wrap">';
    	// 해당 페이지의 책 번호
        	html += '<div class="cnt_wrap">';
	        	html += '<div class="cnt">' + (cnt += 1) + '</div></div>';
        	// 책 이미지
	        html += '<div class="img_wrap">';
    	    	html += '<div onclick="goToPage(' + b['book_seq'] + ')">';
	    	    	html += '<img alt="' + b['title'] + '" src="' + b['imageFile'] + '"></div></div>';
        	// 책 정보 묶음
	    	html += '<div class="info_wrap">';
        		html += '<div class="title" onclick="goToPage(' + b['book_seq'] + ')">' + b['title'] + '</div>';
        		// 제목 제외하고 정렬
        		html += '<div class="sort_area">';
	        		// 작가, 출판사, 출간일, 디스크립션
        			html += '<div class="left_wrap">';
        				html += '<div class="author">' + b['author'] + '</div>';
       					html += '<div class="pub_wrap">'
        					html += '<div>' + b['publisher'] + '</div>';
        					html += '<div>' + b['pubDate'] + '</div>';
        				html += '</div>';
        				html += '<div class="description">' + b['description'] + '</div> </div>';
        			// 구매 관련 묶음: 가격, 수량 조절, 구매, 장바구니 버튼
        			html += '<div class="right_wrap">';
        				html += '<div class="quantity_wrap">';
        					html += '<div class="price_wrap">';
        					
        					
        					var sPrice = new Intl.NumberFormat().format(b['price']);
        					html += '<div class="price ' + b['book_seq'] + ' prices">' + sPrice + '</div><div>원</div></div>';
        					
        					html += '<button type="button" class="btn de_btn" onclick="decreaseBtn(' + b['book_seq'] + ')">-</button>';
                			html += '<input id="quantity' + b['book_seq'] + '" class="quantity" type="number" name="' + b['book_seq'] + '" value="1" min="1" readonly >';
                			html += '<button type="button" class="btn" onclick="increaseBtn(' + b['book_seq'] + ')">+</button>';
            			html += '</div>';
            			html += '<div class="stock">';
            				if(b['stock'] < 10 && b['stock'] != 0) {
		        				html += '<p><em>' + b['stock'] + '</em>개 남음</p>';
		        			}
            			html += '</div>';
		        		html += '<div class="buy_wrap">';
		        			if(b['stock'] == 0) {
		        				html += '<button type="button" class="btn">품절</button>';
		        			} else {
	        					html += '<button type="button" class="btn buy_btn" onclick="buying(' + b['book_seq'] + ',' + b['stock'] + ');">주문하기</button>';
	        					html += '<button type="button" class="btn buy_btn" onclick="goToCustomerCart(' + b['book_seq'] + ',' + b['stock'] +');">장바구니</button>';
		        			}
        				html += '</div></div>';
        			html += '</div></div></div>';
      				html += '<div style="display: none" class="price' + b['book_seq'] + ' prices">' + b['price'] + '</div></div>';
    }
    $('#userBooks').html(html);
}

// cart에 물건 담는 함수 AJAX
function goToCustomerCart(book_seq, stock){
	if(<%=cus_seq%> == 0) {
		location.href="/EIBooks/auth/login.cs";
	} else {
	    var cartICount = $('input[name="'+book_seq+'"]').val();
	    
	    if (stock < cartICount) {
	    	alert("재고 수량을 초과합니다.");
	    	return;
	    }
	    $.ajax({
	        type: "POST",
	        url: "<%=request.getContextPath()%>/customerCartInsert.cc",
	        data: {
	            book_seq: book_seq,
	            cartICount: cartICount
	        },
	        success: function(response) {
	            alert("장바구니에 담겼습니다.");
	        },
	        error: function(xhr, status, error) {
	            console.error("Error: " + error);
	        }
	    });
	}
}

// JQUERY 메인 함수
$(function(){
	<%if (request.getParameter("searchWord") != null) {%>
		$('input[name="searchWord"]').val("<%=request.getParameter("searchWord")%>");
		<%} else {%>
		searchWord = "<%=searchWord%>";
        $('input[name="searchWord"]').val("<%=searchWord%>");
        <%}%>
    
    // 리스트 만드는 함수 불러오기
	userSearch();
    
	// 정렬 기능 함수들
	$('.sort').click(function() {
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
function buying(book_seq, stock){
	var className = "cartICount" + book_seq;
    var cartICount = $('input[name="'+book_seq+'"]').val();
    
    if (stock < cartICount) {
    	alert("재고 수량을 초과합니다.");
    	return;
    }
    
    var cus_seq = "<%=session.getAttribute("cus_seq")%>"
    var priceClass = 'price' + book_seq;
    var price = $('.' + priceClass).text(); 
    
    location.href = "<%=request.getContextPath()%>/customerBuyOrder.cc?"
          + "book_seq=" +book_seq
          + '&cartICount=' + cartICount
          + '&totalCartPrice=' + (price*cartICount);                                                                                                                                                                                                                                                                                                                                                                                              
}
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
<%@ include file="../common/header.jsp"%>
<!-- 제목 -->
<main id="container">
<div class="inner">
	<!-- 카테고리 -->
	<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->
	<section class="category_area">
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
	</section>
	<!-- 카테고리 끝 -->

	<!-- 전체 목록 -->
	<section class="list_main">
		<div class="middle_bar">
		
			<div class="middle_top">
				<%if (searchWord != null && !searchWord.isEmpty()) {%>
					<p class="searchWord_text">검색어 : '<b><%=searchWord%></b>'</p>
				<%} else {%><p class="searchWord_text"></p><% } %>
			</div>
			
			<div class="middle_bottom">
			
				<ul class="sort_wrap">
					<li class="sort">
						<%= "latest".equals(list) ? "최신순" 
						:"oldest".equals(list) ? "오래된순" 
						: "popular".equals(list) ? "인기순" 
						: "최신순" %> 
						<img src="../styles/images/undo_tabler_io.svg" alt="" />
					</li>
					<li class="sort_menu">
						<ul class="sort_menu_depth">
							<li><a
								href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=latest"
								<%="latest".equals(list)%>>최신순</a></li>
							<li><a
								href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=oldest"
								<%="oldest".equals(list)%>>오래된 순</a></li>
							<li><a
								href="userBookList.bo?pageNum=<%=p.getPageNum()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=popular"
								<%="popular".equals(list)%>>인기순</a></li>
						</ul>
					</li>
				</ul>
				
				<div class="search_box">
					<form onsubmit="userSearch();">
						<input type="hidden" name="category" value="<%=category%>">
						<input type="text" name="searchWord" class="searchWord"
							<%if (searchWord != null && !searchWord.equals("")) {%>
						value="<%=searchWord%>" <%}%> placeholder="검색어를 입력하세요.">
						<input type="submit" class="search_btn" value="">
					</form>
				</div>
				
				<div class="result_cnt">전체 수 :	<%=totalCount%></div>
				
			</div>
		</div>
		
		<div class="main_books">							
			<div id="userBooks">
			<!-- AJAX로 생성 -->
			</div>
		</div>
		
		<!-- 페이징 -->
		<div class="pagination">
		<%if(p.isPrev()) {%>
			<a class="first arrow" href="userBookList.bo?pageNum=1&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
				<span class="blind">첫 페이지</span></a>
		<%} else { %>
			<a class="first arrow off"><span class="blind">첫 페이지</span></a>
		<% } %>

		<%if(p.isPrev()) {%>
			<a class="prev arrow" href="userBookList.bo?pageNum=<%=p.getStartPage()-1%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
				<span class="blind">이전 페이지</span></a>
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
				<span class="blind">다음 페이지</span></a>
		<%} else { %>
			<a class="next arrow off"><span class="blind">다음 페이지</span></a>
		<%} %>

		<%if(p.isNext()) {%>
			<a class="last arrow" href="userBookList.bo?pageNum=<%=p.getRealEnd()%>&searchWord=<%=searchWord%>&category=<%=category%>&order=<%=list%>">
				<span class="blind">마지막 페이지</span></a>
		<%} else {%>
			<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
		<%} %>
		</div>
	</section>
</div>
</main>
<%@ include file="../common/footer.jsp"%>
</div>
</body>
</html>