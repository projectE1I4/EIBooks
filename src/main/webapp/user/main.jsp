<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
  <link rel="stylesheet" href="/EIBooks/styles/css/Uproduct_main/mainPage.css?v=<?php echo time(); ?>">
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
<title>Insert title here</title>
</head>
<body>
<div id="wrap">
<header id="header"></header>
<main id="container">
	<div class="inner">
	<section class="main_slider">
		<div class="swiper-container main_sliders">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="../styles/images/main_slide1.png" alt="메인 슬라이드1"></div>
				<div class="swiper-slide"><img src="../styles/images/main_slide2.png" alt="메인 슬라이드2"></div>
				<div class="swiper-slide"><img src="../styles/images/main_slide3.png" alt="메인 슬라이드3"></div>
			</div>
			<div class="swiper-pagination"></div>
			
			<div class="swiper-button-prev"></div>
			<div class="swiper-button-next"></div>
			
		</div>
	</section>
	<section class="main_search">
		<div class="search_wrap">
			<input type="search" placeholder="검색어를 입력해주세요.">
			<input class="search_btn" type="submit" value="">
		</div>
	</section>
	<section class="category">
		<div class="category_wrap">
			<ul class="category_list">
				<li><a href="userBookList.bo?pageNum=1&searchWord=&category=">all</a></li>
				<li><a href="userBookList.bo?pageNum=1&searchWord=&category=만화">만화</a></li>
				<li><a href="userBookList.bo?pageNum=1&searchWord=&category=소설/시/희곡">수험서/자격증</a></li>
				<li><a href="userBookList.bo?pageNum=1&searchWord=&category=수험서/자격증">인문학</a></li>
				<li><a href="userBookList.bo?pageNum=1&searchWord=&category=인문학">에세이</a></li>
			</ul>
		</div>
	</section>
	<section class="bestSeller">
		<div class="bestSeller_wrap">
			<div class="bestSeller_top">
				<h3>베스트셀러</h3>
				<div class="swiper-container best_slider">
					<div class="swiper-wrapper">
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
					</div>
				<div class="swiper-pagination"></div>
			
				<div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div>
			
				</div>
			</div>
		</div>
	</section>
	<section class="newList">
		<div class="newList_wrap">
			<div class="newList_top">
				<h3>주목 할 만한 신간 리스트</h3>
				<div class="swiper-container new_slider">
					<div class="swiper-wrapper">
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
						<div class="swiper-slide"></div>
					</div>
				<div class="swiper-pagination"></div>
			
				<div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div>
			
				</div>
			</div>
		</div>
	</section>
</div>
</main>
<footer id="footer"></footer>
</div>
</body>
</html>