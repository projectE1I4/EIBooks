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
  <link rel="stylesheet" href="/EIBooks/styles/css/yeon/updateProduct.css?v=<?php echo time(); ?>">
  <script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
  <script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
  <script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
  <script src="/EIBooks/styles/js/aos.js"></script>
  <script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
  <script type="text/javascript">
	  $(document).ready(function() {
	      $("#header").load("../styles/common/header.html");  // 원하는 파일 경로를 삽입하면 된다
	      $("#footer").load("../styles/common/footer.html");  // 추가 인클루드를 원할 경우 이런식으로 추가하면 된다
	  });
	  
	function validateForm() {
		const form = document.forms['writeForm']; // 폼 참조 방식 수정
	    let isValid = true;
	    const errorMessages = {
	        title: "도서 명 필수값입니다.",
	        author: "저자 명 필수값입니다.",
	        category: "도서 분류 필수값입니다.",
	        price: "가격 필수값입니다.",
	        publisher: "출판사 필수값입니다.",
	        pubDate: "출간일 필수값입니다.",
	        isbn10: "isbn10 필수값입니다.",
	        isbn13: "isbn13 필수값입니다.",
	        description: "상세 설명 필수값입니다.",
	        stock: "재고 수량 필수값입니다."
	    };
	
	    function showError(element, message) {
	        const errorEm = document.createElement('em');
	        errorEm.className = 'error';
	        errorEm.textContent = message;
	        element.parentNode.appendChild(errorEm);
	    }
	
	    function clearErrors() {
	        const errors = document.querySelectorAll('em.error');
	        errors.forEach(error => error.remove());
	    }
	
	    clearErrors();
	
	    if (form.title.value === "") {
	        isValid = false;
	        showError(form.title, errorMessages.title);
	        form.title.focus();
	    }
	
	    if (form.author.value === "") {
	        isValid = false;
	        showError(form.author, errorMessages.author);
	        form.author.focus();
	    }
	
	    if (form.category.value === "") {
	        isValid = false;
	        showError(form.category, errorMessages.category);
	        form.category.focus();
	    }
	
	    if (form.price.value === "") {
	        isValid = false;
	        showError(form.price, errorMessages.price);
	        form.price.focus();
	    } 
	    
	    if (form.publisher.value === "") {
	        isValid = false;
	        showError(form.publisher, errorMessages.publisher);
	        form.publisher.focus();
	    }
	
	    if (form.pubDate.value === "") {
	        isValid = false;
	        showError(form.pubDate, errorMessages.pubDate);
	        form.pubDate.focus();
	    }
	
	    if (form.isbn10.value === "") {
	        isValid = false;
	        showError(form.isbn10, errorMessages.isbn10);
	        form.isbn10.focus();
	    } 
	    
	    if (form.isbn13.value === "") {
	        isValid = false;
	        showError(form.isbn13, errorMessages.isbn13);
	        form.isbn13.focus();
	    } 
	    
	    if (form.description.value === "") {
	        isValid = false;
	        showError(form.description, errorMessages.description);
	        form.description.focus();
	    }
	    
	    if (form.stock.value === "") {
	        isValid = false;
	        showError(form.stock, errorMessages.stock);
	        form.stock.focus();
	    }
	
	    if (isValid) {
	        form.submit();
	    }
	}
	
	function decrease() {
		var stockInput = document.getElementsByName("stock")[0];
	    var currentValue = parseInt(stockInput.value);
	    if (!isNaN(currentValue) && currentValue > 0) {
	      stockInput.value = currentValue - 1;
	    }
	}
	
	function increase() {
		var stockInput = document.getElementsByName("stock")[0];
	    var currentValue = parseInt(stockInput.value);
	    if (!isNaN(currentValue)) {
	      stockInput.value = currentValue + 1;
	    }
	}
	
	function previewImage(event) {
	    var reader = new FileReader();
	    reader.onload = function() {
	      var output = document.getElementById('imagePreview');
	      output.src = reader.result;
	    }
	    reader.readAsDataURL(event.target.files[0]);
	  }
	
	</script>
<style>
	em {
		display: block;
		color: red;
	}
</style>
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
            <form name="writeForm" enctype="multipart/form-data" method="post" action="<%=request.getContextPath()%>/updateProductProc.bo">
              <input type="hidden" name="book_seq" value="<%=book_seq%>">
              <div>
              	<input class="title" type="text" name="title"  placeholder="도서 명" value="<%=dto.getTitle() %>">
              </div>
              <div>
              	<input class="author" type="text" name="author" placeholder="저자 명" value="<%=dto.getAuthor() %>">
              </div>
              <hr>
              <div class="info_wrap">
                <div class="img_wrap">
                  <img id="imagePreview" src="<%=dto.getImageFile() %>" alt="Preview"><br>
                  <input type="file" name="imageFile" onchange="previewImage(event)">
                </div>
                <div class="product_info">
                  <div class="flex_wrap">
                    <input type="text" name="price" placeholder="가격" value="<%=dto.getPrice() %>">
                  </div>
                  <div class="flex_wrap">
                    <p class="col">도서 분류</p>
                    <select name="category">
                     	<option value="만화" <% if(dto.getCategory().equals("만화")) { %> selected <% } %>>만화</option>
						<option value="소설/시/희곡" <% if(dto.getCategory().equals("소설/시/희곡")) { %> selected <% } %>>소설/시/희곡</option>
						<option value="수험서/자격증" <% if(dto.getCategory().equals("수험서/자격증")) { %> selected <% } %>>수험서/자격증</option>
						<option value="인문학" <% if(dto.getCategory().equals("인문학")) { %> selected <% } %>>인문학</option>
                    </select>
                  </div>
                  <div class="txt_wrap">
                    <div class="flex_wrap">
                      <p class="col">출판사</p>
                      <input type="text" name="publisher" value="<%=dto.getPublisher() %>">
                    </div>
                    <div class="flex_wrap">
                      <p class="col">출간일</p>
                      <input type="text" name="pubDate" value="<%=dto.getPubDate() %>">
                    </div>
                  </div>
                  <div class="txt_wrap">
                    <div class="flex_wrap">
                      <p class="col">isbn10</p>
                      <input type="text" name="isbn10" value="<%=dto.getIsbn10() %>">
                    </div>
                    <div class="flex_wrap">
                      <p class="col">isbn13</p>
                      <input type="text" name="isbn13" value="<%=dto.getIsbn13( )%>">
                    </div>
                  </div>
                  <textarea name="description"  placeholder="상세 설명"><%=dto.getDescription() %></textarea>
                  <div class="stock_wrap">
                    <p>재고 수량</p>
                    <input type="button" value="-" onclick="decrease()">
                    <input type="text" name="stock" value="<%=dto.getStock() %>">
                    <input type="button" value="+" onclick="increase()">
                  </div>
                  <div class="btn_wrap">
                    <a class="btn cancel_btn" href="productList.bo">취소</a>
					<input class="btn update_btn" type="button" value="완료" onclick="validateForm();">
                  </div>
                </div>
              </div>
            </form>
            
          </div>
        </div>
    </main>
    
    <footer id="footer"></footer>
  </div>

</body>
</html>