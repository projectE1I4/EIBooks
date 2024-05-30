<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% // param
BookDTO dto = (BookDTO)request.getAttribute("dto");
String sBook_seq = request.getParameter("book_seq");
int book_seq = Integer.parseInt(sBook_seq);
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
  <meta property="og:image" content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg"/>
  <meta property="og:url" content="http://hyerin1225.dothome.co.kr/EIBooks"/>
  <title>EIBooks</title>
  <link rel="icon" href="images/favicon.png">
  <link rel="apple-touch-icon" href="images/favicon.png">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/EIBooks/styles/css/jquery-ui.min.css">
  <link rel="stylesheet" href="/EIBooks/styles/css/swiper-bundle.min.css">
  <link rel="stylesheet" href="/EIBooks/styles/css/aos.css">
  <link rel="stylesheet" href="/EIBooks/styles/css/common.css?v=<?php echo time(); ?>">
  <link rel="stylesheet" href="/EIBooks/styles/css/header.css?v=<?php echo time(); ?>">
  <link rel="stylesheet" href="/EIBooks/styles/css/footer.css?v=<?php echo time(); ?>">
  <link rel="stylesheet" href="/EIBooks/styles/css/main.css?v=<?php echo time(); ?>">
  <link rel="stylesheet" href="/EIBooks/styles/css/yeon/productView.css?v=<?php echo time(); ?>">
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
	function del(book_seq){
		const input = confirm("정말 삭제하시겠습니까?");
		if(input){
			location.href = "<%=request.getContextPath()%>/deleteProductProc.bo?book_seq="+book_seq;
		}else{
			alert('삭제를 취소했습니다.');
			return;
		}
	}
  </script>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<header id="header"></header>
	<main id="container">
        <div class="inner">
          <div class="productView">
            <h2 class="title"><%=dto.getTitle() %></h2>
            <p class="author"><%=dto.getAuthor()%></p>
            <hr>
            <div class="info_wrap">
              <div class="img_wrap">
                <img src="<%=dto.getImageFile() %>" alt="표지이미지">
              </div>
              <div class="product_info">
                <strong class="price"><%=dto.getPrice() %>원</strong>
                <div class="flex_wrap">
                  <p class="col">도서 분류</p>
                  <p class="category"><%=dto.getCategory() %></p>
                </div>
                <div class="txt_wrap">
                  <div class="flex_wrap">
                    <p class="col">출판사</p>
                    <p class="publisher"><%=dto.getPublisher() %></p>
                  </div>
                  <div class="flex_wrap">
                    <p class="col">출간일</p>
                    <p class="pubDate"><%=dto.getPubDate() %></p>
                  </div>
                </div>
                
                <div class="txt_wrap">
                  <div class="flex_wrap">
                    <p class="col">isbn10</p>
                    <p class="isbn"><%=dto.getIsbn10() %></p>
                  </div>
                  <div class="flex_wrap">
                    <p class="col">isbn13</p>
                    <p class="isbn"><%=dto.getIsbn13() %></p>
                  </div>
                </div>
              
                <p class="description"><%=dto.getDescription() %></p>
                <div class="stock_wrap">
                  <p>재고 수량</p>
                  <p><%=dto.getStock() %>개</p>
                </div>
                <div class="btn_wrap">
                  <a href="updateProduct.bo?book_seq=<%=book_seq %>" class="btn update_btn">수정</a>
                  <a href="javascript:del('<%=book_seq %>');" class="btn delete_btn">삭제</a>
                </div>
              </div>
            </div>
            
          </div>
        </div>
    </main>
    <footer id="footer"></footer>
</div>    
</body>
</html>