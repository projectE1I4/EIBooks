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
<meta charset="EUC-KR">
<title>updateProduct.jsp</title>

<script type="text/javascript">
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
<h2>제품 수정하기</h2>
<form name="writeForm" enctype="multipart/form-data" method="post" action="<%=request.getContextPath()%>/updateProductProc.bo">
<input type="hidden" name="book_seq" value="<%=book_seq%>">
<table border="1" width="60%">
	<tr>
		<td colspan="4"><input type="text" name="title" style="width:90%" value="<%=dto.getTitle() %>"></td>
	</tr>
	<tr>
		<td colspan="4"><input type="text" name="author" style="width:90%" value="<%=dto.getAuthor() %>"></td>	
	</tr>
	<div>
		<div >
			<tr>
				<td>
					<img id="imagePreview" src="<%=dto.getImageFile() %>" alt="표지이미지" width="200">
					<input type="file" name="imageFile" onchange="previewImage(event)">
				</td>
			</tr>
		</div>
		<div>
			<tr>
				<td colspan="4"><input type="text" name="price" style="width:90%" value="<%=dto.getPrice() %>"></td>
			</tr>
			<tr>
				<td colspan="4">
					도서 분류 &nbsp;
					<select name="category">
						<option value="만화" <% if(dto.getCategory().equals("만화")) { %> selected <% } %>>만화</option>
						<option value="소설/시/희곡" <% if(dto.getCategory().equals("소설/시/희곡")) { %> selected <% } %>>소설/시/희곡</option>
						<option value="수험서/자격증" <% if(dto.getCategory().equals("수험서/자격증")) { %> selected <% } %>>수험서/자격증</option>
						<option value="인문학" <% if(dto.getCategory().equals("인문학")) { %> selected <% } %>>인문학</option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="50%">출판사 &nbsp;<input type="text" name="publisher" value="<%=dto.getPublisher() %>"></td>
				<td>출간일 &nbsp;<input type="text" name="pubDate" value="<%=dto.getPubDate() %>"></td>
			</tr>
				<td>isbn10 &nbsp;<input type="text" name="isbn10" value="<%=dto.getIsbn10() %>"></td>
				<td>isbn13 &nbsp;<input type="text" name="isbn13" value="<%=dto.getIsbn13() %>"></td>
			<tr>
			</tr>
			<tr>
				<td colspan="4">
					<textarea name="description" style="width:90%; height:100px"><%=dto.getDescription() %></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					재고 수량 &nbsp;
					<input type="button" value="-" onclick="decrease()">
					<input type="text" name="stock" value="<%=dto.getStock() %>">
					<input type="button" value="+" onclick="increase()">
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<a href="productList.bo">[취소]</a>
					<input type="button" value="완료" onclick="validateForm();">
				</td>
			</tr>
		</div>
	</div>
	
</table>
</form>

</body>
</html>