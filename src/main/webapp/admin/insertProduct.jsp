<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% // param
BookDTO dto = (BookDTO)request.getAttribute("dto");
%>        
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>insertProduct.jsp</title>

<script type="text/javascript">
function validateForm() {
	const form = document.writeForm;
	console.dir(form); // input
	
	if(form.title.value === "") {
		alert('도서 명 필수값입니다.');
		form.title.focus();
		return;
	}
	
	if(form.author.value === "") {
		alert('저자 명 필수값입니다.');
		form.author.focus();
		return;
	}
	
	if(form.category.value === "") {
		alert('도서 분류 필수값입니다.');
		form.category.focus();
		return;
	}
	
	if(form.price.value === "") {
		alert('가격 필수값입니다.');
		form.price.focus();
		return;
	}
	
	if(form.publisher.value === "") {
		alert('출판사 필수값입니다.');
		form.publisher.focus();
		return;
	}
	
	if(form.pubDate.value === "") {
		alert('출간일 필수값입니다.');
		form.pubDate.focus();
		return;
	}
	
	if(form.isbn10.value === "") {
		alert('isbn10 필수값입니다.');
		form.isbn10.focus();
		return;
	}
	
	if(form.isbn13.value === "") {
		alert('isbn13 필수값입니다.');
		form.isbn13.focus();
		return;
	}
	
	if(form.description.value === "") {
		alert('상세 설명 필수값입니다.');
		form.description.focus();
		return;
	}
	
	if(form.stock.value === "") {
		alert('재고 수량 필수값입니다.');
		form.stock.focus();
		return;
	}
	
	form.submit();
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

</head>
<body>

<%@ include file="../common/menu.jsp" %>
<h2>제품 등록하기</h2>
<form name="writeForm" enctype="multipart/form-data" method="post" action="<%=request.getContextPath()%>/writeProductProc.bo">
<table border="1" width="90%">
	<tr>
		<td colspan="4"><input type="text" name="title" style="width:100%" placeholder="도서 명"></td>
	</tr>
	<tr>
		<td colspan="4"><input type="text" name="author" style="width:100%" placeholder="저자 명"></td>	
	</tr>
	<div>
		<div >
			<tr>
				<td>
					<img id="imagePreview" src="#" alt="Preview" width="200">
					<input type="file" name="imageFile" onchange="previewImage(event)">
				</td>
			</tr>
		</div>
		<div>
			<tr>
				<td colspan="3"><input type="text" name="price" style="width:100%" placeholder="가격"></td>
			</tr>
			<tr>
				<td>도서 분류<input type="text" name="category" style="width:100%"></td>
			</tr>
			<tr>
				<td>출판사<input type="text" name="publisher" style="width:100%"></td>
				<td>출간일<input type="text" name="pubDate" style="width:100%"></td>
			</tr>
				<td>isbn10<input type="text" name="isbn10" style="width:100%"></td>
				<td>isbn13<input type="text" name="isbn13" style="width:100%"></td>
			<tr>
			</tr>
			<tr>
				<td colspan="3">
					<textarea name="description" style="width:100%; height:100px" placeholder="상세 설명"></textarea>
				</td>
			</tr>
			<tr>
				<td>재고 수량</td>
				<td colspan="2">
					<input type="button" value="-" onclick="decrease()">
					<input type="text" name="stock" style="width:100%">
					<input type="button" value="+" onclick="increase()">
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<a href="productList.bo">[취소]</a> 
					<input type="button" value="등록" onclick="validateForm();">
				</td>
			</tr>
		</div>
	</div>
	
</table>
</form>

</body>
</html>