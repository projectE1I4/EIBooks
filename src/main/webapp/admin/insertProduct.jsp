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
	let stockInput = document.getElementsByName("stock")[0];
    let currentValue = parseInt(stockInput.value);
    
    if (!isNaN(currentValue) && currentValue > 0) {
      stockInput.value = currentValue - 1;
    }
}

function increase() {
	let stockInput = document.getElementsByName("stock")[0];
    let currentValue = parseInt(stockInput.value);
    
    if (!isNaN(currentValue)) {
      stockInput.value = currentValue + 1;
    }
}

function previewImage(event) {
    let reader = new FileReader();
    
    reader.onload = function() {
      let output = document.getElementById('imagePreview');
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
<table border="1" width="60%">
	<tr>
		<td colspan="4"><input type="text" name="title" style="width:90%" placeholder="도서 명"></td>
	</tr>
	<tr>
		<td colspan="4"><input type="text" name="author" style="width:90%" placeholder="저자 명"></td>	
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
				<td colspan="4"><input type="text" name="price" style="width:90%" placeholder="가격"></td>
			</tr>
			<tr>
				<td colspan="4">
					도서 분류 &nbsp;
					<select name="category">
						<option value="만화">만화</option>
						<option value="소설/시/희곡">소설/시/희곡</option>
						<option value="수험서/자격증">수험서/자격증</option>
						<option value="인문학">인문학</option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="50%">출판사 &nbsp;<input type="text" name="publisher"></td>
				<td>출간일 &nbsp;<input type="text" name="pubDate"></td>
			</tr>
				<td>isbn10 &nbsp;<input type="text" name="isbn10"></td>
				<td>isbn13 &nbsp;<input type="text" name="isbn13"></td>
			<tr>
			</tr>
			<tr>
				<td colspan="4">
					<textarea name="description" style="width:90%; height:100px" placeholder="상세 설명"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					재고 수량 &nbsp; 
					<input type="button" value="-" onclick="decrease()">
					<input type="text" name="stock">
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