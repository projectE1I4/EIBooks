<%@page import="eibooks.dto.ReviewDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dao.BookDAO"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% // param
	BookDTO dto = (BookDTO)request.getAttribute("dto");
	String sBook_seq = request.getParameter("book_seq");
	int book_seq = Integer.parseInt(sBook_seq);
	BookDAO dao = new BookDAO();
	int viewcount = dto.getViewCount();
	dao.userGetViewCount(book_seq);
	viewcount = dao.userViewCount(book_seq);
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
	href="/EIBooks/styles/css/Uproduct_main/userProductDetail.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<script type="text/javascript">
  $(document).ready( function() {
	    
      $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
      $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다
    
      setTimeout(function() {
    	  
	  	var $pElement = $('.book_title p');
	    var beforeElementWidth = $pElement.outerWidth(); // Get the width of the p element
	
	    $('<style>')
	      .prop('type', 'text/css')
	      .html('.book_title::before { width: ' + beforeElementWidth + 'px; }')
	      .appendTo('head');
	      
	    });
      })
    </script>
<title>userBookDetail.jsp</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
function buying(book_seq){
    var cartICount = $('input[name="cartICount"]').val();
    var cus_seq = "<%=session.getAttribute("cus_seq")%>"
    var price = $('.price').text(); 
    
    location.href = "<%=request.getContextPath()%>/customerBuyOrder.cc?"
          + "book_seq=" +book_seq
          + '&cartICount=' + cartICount
          + '&totalCartPrice=' + (price * cartICount) + '&price=' + price;
                                                                                                                                                                                                                                                                                                                                                                                                          
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
//수량 증가 함수
function increaseBtn(bookSeq) {
	 var quantityInput = $('#quantity');
	 var currentQuantity = parseInt(quantityInput.val());
	 quantityInput.val(currentQuantity + 1);
}

// 수량 감소 함수
function decreaseBtn(bookSeq) {
	var quantityInput = $('#quantity');
    var currentQuantity = parseInt(quantityInput.val());
    if (currentQuantity > 1) {
        quantityInput.val(currentQuantity - 1);
    }
}

// 

</script>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<header id="header"></header>
<main class="container">
<section class="detail_top">
	<div class="category"><p><%=dto.getCategory() %></p></div>
</section>

<section class="detail_main">
<div class="book_info">
	<ul class="title_Author">
		<li class="book_title">
			<p><%=dto.getTitle() %></p>
		</li>
		<li class="book_author">
			<p><%=dto.getAuthor()%></p>	
		</li>
	</ul>
	<div class="info_area">
	<div class="info_wrap">
		<div class="image_wrap">
				<img src="<%=dto.getImageFile() %>" alt="표지이미지" width=200>
		</div>
		<div class="info_box">
			<div class="book_price">
				<p><%=dto.getPrice() %><span>원</span></p>
			</div>
			<div class="publisher_wrap">
				<p>출판사: <span><%=dto.getPublisher() %></span></p>
			</div>
			<div class="etc_wrap">
				<p>출간일: <span><%=dto.getPubDate() %></span></p>
				<p>isbn: <span><%=dto.getIsbn13() %></span></p>
			</div>
			<div class="viewCount_wrap">
				<p>조회수: <span><%=viewcount %></span></p>
			</div>
			
		</div>		
		<div class="buy_wrap">
			<div class="quantity_wrap">
				<button type="button"class="btn inde_btn" onclick="decreaseBtn(<%=dto.getBook_seq()%>)">-</button>
        		<input id="quantity" type="number" name="<%=dto.getBook_seq() %>" value="1" min="1" readonly style="width:30px;">
           		<button type="button" class="btn inde_btn" onclick="increaseBtn(<%=dto.getBook_seq()%>)">+</button>
        	</div>
        	<div class="buyBtn_wrap">
				<input class="btn" type="submit" value="바로구매" onclick="buying(<%=dto.getBook_seq()%>)"/>
				<input class="btn" type="submit" value="장바구니" onclick="goToCustomerCart(<%=dto.getBook_seq()%>);"/>				        	
        	</div>
		</div>
	</div>
	<div class="discription_wrap">
		<strong>책 소개</strong>
		<div class="discription">
			<p><%=dto.getDescription() %></p>				
		</div>
	</div>
	</div>
</div>
</section>
<%
int reviewCount = (int)request.getAttribute("reviewCount"); // 리뷰 개수
double reviewAvg = Math.round((double)request.getAttribute("reviewAvg") * 10) / 10.0; // 별점 평균
List<ReviewDTO> topReviews = (List<ReviewDTO>)request.getAttribute("topReviews"); // 리뷰 4개 연결
%>
<h2>도서 리뷰 <%=reviewAvg %>/5</h2>
<a href="/EIBooks/review/reviewList.do?bookNum=<%=book_seq%>">전체보기 (<%=reviewCount %>개)</a>
<ul>
<% if(topReviews.isEmpty()) { %>	
<li><b>리뷰가 없습니다.</b></li>
<% } else { %>
	<%for(ReviewDTO rDto:topReviews) {%>
		<li>
			<ul>
				<li><%=rDto.getGrade() %></li>
				<li><%=rDto.getCusInfo().getCus_id() %></li>
				<li><%=rDto.getReviewDate() %></li>
				<li><%=rDto.getContent() %></li>
			</ul>
		</li>
	<%} %>
<%} %>
</ul>
</main>

<footer id="footer"></footer>
</body>
</html>