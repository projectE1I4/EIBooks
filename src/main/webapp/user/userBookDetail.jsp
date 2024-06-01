<%@page import="eibooks.dao.QnaDAO"%>
<%@page import="eibooks.common.PageDTO"%>
<%@page import="eibooks.dto.QnaDTO"%>
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
	
	// qna
	List<QnaDTO> qnaList = (List<QnaDTO>)request.getAttribute("qnaList");
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int number = qnaList.size();
	int cnt = 0;
	Boolean protect = false;
	String sProtect = "";
	if (request.getParameter("protect") != null) {
		sProtect = request.getParameter("protect");
	}
	if (sProtect.equals("true")) {
		protect = true;
	}
	int cus_seq = 0;
	if (session.getAttribute("cus_seq") != null) {
		cus_seq = (int)session.getAttribute("cus_seq");
	}
%>  
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
	href="/EIBooks/styles/css/Uproduct_main/userProductDetail.css?v=<?php echo time(); ?>">
<link rel="stylesheet"
	href="/EIBooks/styles/css/yeon/bookDetail.css?v=<?php echo time(); ?>">
</head>
<body>
<script type="text/javascript">
  $(document).ready( function() {
	    
      $('.qna_wrap').click(function() {
          $(this).next('.reply_wrap').toggle();
      });
     
     $(document).click(function(e) {
          if (!$(e.target).closest('.sort_wrap').length) {
              $('.sort_menu').slideUp();
          }
          
          if (!$(e.target).closest('.qna_wrap').length) {
          	$('.reply_wrap').slideUp();
          }
          
      });
     
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
	if (<%=cus_seq%> == 0) {
		location.href="/EIBooks/auth/login.cs";
	} else {
	    var cartICount = $('input[name="cartICount"]').val();
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
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div class="wrap">
<%@ include file="../common/header.jsp" %>
<main id="container">
<div class="inner">
<section class="detail_top">
	<div class="category"><p><%=dto.getCategory() %></p></div>
</section>

<section class="detail_main">
	<div class="book_info">
		<ul class="title_Author">
			<li class="book_title"><p><%=dto.getTitle() %></p></li>
			<li class="book_author"><p><%=dto.getAuthor()%></p></li>
		</ul>
		<div class="info_area">
			<div class="info_wrap">
				<div class="image_wrap">
					<img src="<%=dto.getImageFile() %>" alt="표지이미지" width=200>
				</div>
				<div class="info_box">
					<div class="book_price">
						<p class="price"><%=dto.getPrice() %></p><p>원</p>
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
        				<input id="quantity" type="number" name="cartICount" value="1" min="1" readonly">
           				<div class="inde_btn_wrap">
           					<button type="button" class="btn inde_btn" onclick="increaseBtn(<%=dto.getBook_seq()%>)">+</button>
							<button type="button"class="btn inde_btn" onclick="decreaseBtn(<%=dto.getBook_seq()%>)">-</button>           		
           				</div>
        			</div>
        			<div class="buyBtn_wrap">
						<input class="btn buyNow" type="submit" value="바로구매" onclick="buying(<%=dto.getBook_seq()%>)"/>
						<input class="btn goCart" type="submit" value="장바구니" onclick="goToCustomerCart(<%=dto.getBook_seq()%>);"/>				        	
        			</div>
				</div>
				<div class="discription_wrap">
					<strong>책 소개</strong>
					<div class="discription"><p><%=dto.getDescription() %></p></div>
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

<section class="review">
	<div class="review_top">
		<div class="title_wrap">
			<h2>도서 리뷰</h2><h2><%=reviewAvg %> / 5</h2>
		</div>
		<a href="/EIBooks/review/reviewList.do?bookNum=<%=book_seq%>" class="review_link"> 전체보기 (<%=reviewCount %>개)</a>
	</div>
	<ul class="review_list">
	<% if(topReviews.isEmpty()) { %>	
		<li class="empty">리뷰가 없습니다.</li>
	<% } else { %>
		<%for(ReviewDTO rDto:topReviews) {%>
			<li class="notEmpty">
				<ul class="review_wrap">
					<li class="stars"><% if (rDto.getGrade() != 0 && rDto.getGrade() <6){
					for (int i = 0; i < rDto.getGrade(); i++ ){
						%><div class="star_wrap"><img src="../styles/images/star_full.png" /></div><%
					}
					for (int j=0; j < 5 - rDto.getGrade(); j++){%>
						<div class="star_wrap"><img src="../styles/images/star_empty.png" /></div>
						 <%}
				}%></li>
					<li class="info_wrap"><p><%=rDto.getCusInfo().getCus_id() %></p> <p><%=rDto.getReviewDate() %></p></li>
					<li class="content_wrap"><p><%=rDto.getContent() %></p></li>
				</ul>
			</li>
		<%} %>
	<%} %>
	</ul>
</section>

<section class="qna">

<div class="board_list_wrap">
	<div class="qna_tit">
		<h2>Q&A 상품문의 (<%=qnaList.size() %>)</h2>
		<div class="btn_wrap">
			<% if(protect == false) { %>
				<a class="protect" href="/EIBooks/user/userBookDetail.bo?book_seq=<%=book_seq %>&protect_YN=N&protect=true">비밀글 제외</a>
			<% } else { %>
				<a class="protect" href="/EIBooks/user/userBookDetail.bo?book_seq=<%=book_seq %>">비밀글 포함</a>
			<% } %>
			<div>
				<a class="btn insert_btn" href="<%=request.getContextPath()%>/qna/qnaWrite.qq?book_seq=<%=book_seq %>">작성하기</a>
			</div>
		</div>
	</div>
	<% if(qnaList.isEmpty()) { %>	
	<div class="not">
		<p>문의가 없습니다.</p>
	</div>
	<% } else { %>
	<table>
		<thead>
			<tr>
				<th class="num">NO</th>
				<th class="state">답변여부</th>
				<th class="type">구분</th>
				<th class="qna_title">내용</th>
				<th class="cus_id">작성자</th>
				<th class="date">등록일자</th>
			</tr>
		</thead>
		<tbody>
			
				<% for(QnaDTO qna : qnaList){ %>	
					<tr class="qna_wrap">
						<td><%= number - cnt %><% cnt++; %></td>
						<td class="state"><%=qna.getState() %></td>
						<td><%=qna.getType() %></td>
						<% if(qna.getProtect_YN().equals("N")) { %>
						<td class="title_text"><%=qna.getTitle() %></td>
						<% } else { %>
						<td class="title_text">상품 관련 문의입니다.<img src="../styles/images/key.svg" alt="비밀글"></td>
						<% } %>
						<td><%=qna.getCusInfo().getCus_id() %></td>
						<td><%=qna.getRegDate() %></td>
					</tr>
					<% if(qna.getProtect_YN().equals("N") || qna.getCus_seq() == cus_seq) { %>
					<tr class="reply_wrap">
						<td colspan="6">
							<div class="reply_wrap_content">
								<div class="cus_content">
									<p class="book_tit"><%=qna.getBookInfo().getTitle() %></p>
									<p class="reply_content"><%=qna.getContent() %></p>
								</div>
								<%
								QnaDAO qDao = new QnaDAO();
								QnaDTO reply = qDao.selectReply(qna);
								
								if(reply.getContent() != null) {
								%>
								<div class="admin_wrap">
									<div class="admin1">
										<div class="admin_name"><p>관리자</p></div>
										<div class="admin_content"><p><%=reply.getContent() %></p></div>
									</div>
									<div class="admin_regDate"><p><%=reply.getRegDate() %></p></div>
								</div>
								<% } %> <!-- if(reply) -->
							</div>
						</td>
					</tr>
					<% } %>
				<% } %>  <!-- for  -->
			<% } %> <!-- if -->
		</tbody>
	</table>
</div>

<% if(!qnaList.isEmpty()) { %>
			<div class="pagination">
				<%if(p.isPrev()) {%>
				<a class="first arrow" href="userBookDetail.bo?book_seq=<%=book_seq %>&pageNum=1">
					<span class="blind">첫 페이지</span>
				</a>
				<%} else { %>
					<a class="first arrow off"><span class="blind">첫 페이지</span></a>
				<% } %>
				
				<%if(p.isPrev()) {%>
				<a class="prev arrow" href="userBookDetail.bo?book_seq=<%=book_seq %>&pageNum=<%=p.getStartPage()-1 %>">
					<span class="blind">이전 페이지</span>
				</a>
				<%} else { %>
					<a class="prev arrow off"><span class="blind">이전 페이지</span></a>
				<%} %>
				
				<%for(int i=p.getStartPage(); i<=p.getEndPage(); i++) {%>
					<%if(i == p.getPageNum()) {%>
						<a class="number active"><%=i %></a>
					<%}else {%>
						<a class="number" href="userBookDetail.bo?book_seq=<%=book_seq %>&pageNum=<%=i %>"><%=i %></a>
					<%} %>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="next arrow" href="userBookDetail.bo?book_seq=<%=book_seq %>&pageNum=<%=p.getEndPage()+1 %>">
					<span class="blind">다음 페이지</span>
				</a>
				<%} else {%>
					<a class="next arrow off"><span class="blind">다음 페이지</span></a>
				<%} %>
				
				<%if(p.isNext()) {%>
				<a class="last arrow" href="userBookDetail.bo?pageNum=<%=p.getRealEnd() %>">
					<span class="blind">마지막 페이지</span>
				</a>
				<%} else { %>
					<a class="last arrow off"><span class="blind">마지막 페이지</span></a>
				<%} %>
			</div>
		<% } %>

</section>
</div>
</main>
<%@ include file="../common/footer.jsp"%>
</div>
</body>
</html>