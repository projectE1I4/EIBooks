<%@page import="eibooks.dao.OrderQnaDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="eibooks.dao.OrderDAO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.OrderDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
List<OrderDTO> orderList = (List<OrderDTO>)request.getAttribute("orderList");
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
<meta property="og:image" content="http://hyerin1225.dothome.co.kr/EIBooks/images/EIBooks_logo.jpg" />
<meta property="og:url" content="http://hyerin1225.dothome.co.kr/EIBooks" />
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
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaWrite2.css?v=<?php echo time(); ?>">
<script src="/EIBooks/styles/js/jquery-3.7.1.min.js"></script>
<script src="/EIBooks/styles/js/jquery-ui.min.js"></script>
<script src="/EIBooks/styles/js/swiper-bundle.min.js"></script>
<script src="/EIBooks/styles/js/aos.js"></script>
<script src="/EIBooks/styles/js/ui-common.js?v=<?php echo time(); ?>"></script>
<title>review/replyList.jsp</title>
<script>
$(document).ready( function() {
    
});

function limitText(field, maxLength) {
	if (field.value.length > maxLength) {
		field.value = field.value.substring(0, maxLength);
		alert('최대 ' + maxLength + '자까지 작성할 수 있습니다.');
	}
}

function previewImage(event) {
    let reader = new FileReader();

    reader.onload = function () {
        let output = document.getElementById('imagePreview');
        output.src = reader.result;
    }
    reader.readAsDataURL(event.target.files[0]);
}

</script>
</head>
<body>

<%@ include file="../common/header.jsp" %>
<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<header id="header"></header>
	<main id="container">
		<div class="inner">
			<h2>1:1문의</h2>
			<ul class="qna_form">
				<li class="">
					<form class="write_form" enctype="multipart/form-data" name="writeForm" method="post" action="/EIBooks/orderQna/qnaWriteProc.oq">
						<div class="qna_input">
							<p>문의유형</p>
							<select name="type" id="typeSelect">
								<option value="배송">배송</option>
								<option value="주문/결제">주문/결제</option>
								<option value="취소/교환/환불">취소/교환/환불</option>
							</select>
						</div>
						<div class="qna_input">
							<div class="purchase">
							    <p>주문내역</p>
							    <em>3개월 이내의 주문내역</em>
							</div>
						    <div class="info_wrap">
						    <%
							 	OrderDTO prevItem = null;
							   	int cnt = 0;
						   	
							   	for (int i = 0; i < orderList.size(); i++) {
							    	boolean isSameItem = prevItem != null && prevItem.getPur_seq() == orderList.get(i).getPur_seq();
							        if(!isSameItem) { // 이전 항목과 다를 경우에만 표시
							    	%>
							        <% OrderDTO o = orderList.get(i); %>
							        <div class="radio_wrap">
							            <input type="radio" id="info_text_<%= i %>" name="pur_seq" value="<%= o.getPur_seq() %>">
							            <label for="info_text_<%= i %>">
							            	<div class="txt">
							            		<p><%=o.getPur_seq() %></p>
								                <div class="title_i">
								                	<p><%=o.getBookInfo().getTitle() %></p>
								                	<%
								                	OrderDTO dto = new OrderDTO();
							            			dto.setPur_seq(o.getPur_seq());	
							            			OrderDAO dao = new OrderDAO();
							            			int titleCnt = dao.selectTitleCount(dto);
							            			
							            			if(titleCnt > 0) {
								                	%>
								                	<p>외 <%=titleCnt %>권</p>
								                	<% } %>
								                </div>
								                <p><%=o.getOrderDate() %></p>
							            	</div>
							            </label>
							        </div>
							    <%
							        } // if(!isSameItem)
							        prevItem = orderList.get(i); // 현재 항목을 이전 항목으로 설정
							    	
							    } // for
								%>
						    </div>
						</div>
						
						
						<div class="qna_input">
							<p>제목</p>
							<input type="text" name="title" oninput="limitText(this, 50)">
						</div>
						<div class="qna_input text_area">
							<p>내용</p>
							<textarea class="write_content" name="content" oninput="limitText(this, 500)"></textarea>
						</div>
						 <div class="img_wrap">
                            <img id="imagePreview" src="/EIBooks/styles/images/photo.svg" alt="Preview">
                            <input type="file" name="imageFile" onchange="previewImage(event)">
                        </div>
						<div class="write_btn_wrap">
						<% for(OrderDTO o : orderList) { %>
							<input type="hidden" name="book_seq" value="<%=o.getBook_seq() %>">
					    	<input type="hidden" name="pur_i_seq" value="<%=o.getPur_i_seq() %>">
						<% } %>
							<input class="btn" type="button" value="취소" onclick="goToPage()">
							<input class="btn write_btn" type="submit" value="작성하기">
						</div>
					</form>
				</li>
			</ul>
		</div>
	</main>
</div>	

</body>
</html>