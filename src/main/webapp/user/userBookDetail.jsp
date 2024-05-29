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

</script>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<h2>글 상세보기 </h2>
<table border="1" width="60%">
	<tr>
		<td colspan="4"><%=dto.getTitle() %></td>
	</tr>
	<tr>
		<td colspan="4"><%=dto.getAuthor()%></td>	
	</tr>
	<div>
		<div>
			<tr>
				<td><img src="<%=dto.getImageFile() %>" alt="표지이미지" width=200></td>
			</tr>
		</div>
		<div>
			<tr>
				<td colspan="4" class="price"><%=dto.getPrice() %></td>
			</tr>
			<tr>
				<td>도서 분류</td><td colspan="3"><%=dto.getCategory() %></td>
			</tr>
			<tr>
				<td>출판사</td><td width="30%"><%=dto.getPublisher() %></td>
				<td>출간일</td><td><%=dto.getPubDate() %></td>
			</tr>
			<tr>
				<td width="20%">isbn10</td><td><%=dto.getIsbn10() %></td>
				<td width="20%">isbn13</td><td><%=dto.getIsbn13() %></td>
			</tr>
			<tr rowspan="10"><td colspan="4"><%=dto.getDescription() %></td></tr>
			<tr><td colspan="4">
				<div>
					<button type="button" onclick="decreaseBtn(<%=dto.getBook_seq()%>)">-</button>
           			<input id="quantity" type="number" name="<%=dto.getBook_seq() %>" value="1" min="1" readonly style="width:30px;">
            		<button type="button" onclick="increaseBtn(<%=dto.getBook_seq()%>)">+</button>
        		</div>
				<input type="submit" value="바로구매" onclick="buying(<%=dto.getBook_seq()%>)"/>
				<input type="submit" value="장바구니" onclick="goToCustomerCart(<%=dto.getBook_seq()%>);"/>				
			</td></tr>
			<tr>
			<td>
			조회수: 
			</td>
			<td>
			<%=viewcount %>
			</td>
			</tr>
		</div>
	</div>
	
</table>

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
</body>
</html>