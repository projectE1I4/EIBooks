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
String pageNum = (String)request.getAttribute("pageNum");
%>    
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet" href="/EIBooks/styles/css/yeon/qnaWrite2.css?v=<?php echo time(); ?>">
<script>

function validateForm() {
    const form = document.writeForm;
    
    if (form.pur_seq.value === "") {
        alert('주문내역을 선택해주세요.');
        form.pur_seq.focus();
        return;
    } else if (form.title.value === "") {
        alert('제목을 입력해주세요.');
        form.title.focus();
        return;
    } else if (form.content.value === "") {
        alert('내용을 입력해주세요.');
        form.content.focus();
        return;
    }

    form.submit();

}

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

<div id="skip_navi">
  <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
	<%@ include file="../common/header.jsp" %>
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
								                	<p><%=o.getBookInfo().getTitle() %>
								                	<%
								                	OrderDTO dto = new OrderDTO();
							            			dto.setPur_seq(o.getPur_seq());	
							            			OrderDAO dao = new OrderDAO();
							            			int titleCnt = dao.selectTitleCount(dto);
							            			
							            			if(titleCnt > 0) {
								                	%>
								                	<p class="pos">외 <em><%=titleCnt %></em>권</p>
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
							<input class="btn write_btn" type="button" value="작성하기" onclick="validateForm()">
						</div>
					</form>
				</li>
			</ul>
		</div>
	</main>
	<%@ include file="../common/footer.jsp" %>
</div>	

</body>
</html>