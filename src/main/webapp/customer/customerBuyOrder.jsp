<%@page import="eibooks.dto.AddressDTO"%>
<%@page import="eibooks.dto.CustomerDTO"%>
<%@page import="eibooks.dao.CustomerDAO"%>
<%@page import="eibooks.dao.BookDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@page import="eibooks.dto.cartDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
    out.print("왔냐?");

	// 주문한 고객 정보 불러오기
	int cus_seq = (int)session.getAttribute("cus_seq");
	
	CustomerDAO customerDAO = new CustomerDAO();
	CustomerDTO customer = customerDAO.getCustomerDetails(cus_seq);
	AddressDTO addrInfo = customer.getAddrInfo();

	// 장바구니에 담은 책 정보 불러오기
    cartDTO cartdto = new cartDTO();
    List<BookDTO> bookList = new ArrayList<>();
    BookDTO book = new BookDTO();
    book.setBook_seq((int)request.getAttribute("book_seq"));
    
    BookDAO dao = new BookDAO();
    
    BookDTO resultBook = dao.getBook(book);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>customerOrder</title>

</head>
<body data-cus-seq="<%= request.getAttribute("cusSeq") %>" data-cart-seq="<%= request.getAttribute("cartSeq") %>">
<%@ include file="../common/menu.jsp" %>
<h2>주문 / 결제</h2>

<form id="cartForm" action="customerBuyOrder.cc" method="post">
    <table border="1" width="95%">
        <tr>
            <th>수령자명</th>
            <td><%= customer.getName() %></td>
        </tr>
        <tr>
            <th>연락처</th>
            <td><%= customer.getTel() %></td>
        </tr>
        <tr>
            <th>이메일</th>
            <td><%= customer.getEmail() %></td>
        </tr>
        <tr>
            <th>배송지</th>
            <td>
                <%= addrInfo.getPostalCode() %><br>
                <%= addrInfo.getAddr() %><br>
                <%= addrInfo.getAddr_detail() %>
            </td>
        </tr>
        
        <tr>
        	<th width="20%">이미지</th>
        	<th width="20%">도서명</th>
        	<th width="20%">수량</th>
        	<th width="20%">가격</th>
        </tr>
        <%       
           	// bookList를 반복하여 book_seq가 1인 BookDTO 객체를 찾습니다.
			String titleOfBookSeq = null;
			if(resultBook != null){
			%>
           <tr>
           	<td>
				<img src="<%=resultBook.getImageFile() %>">
			</td>
               <td><%=resultBook.getTitle() %></td>
               <td><%=request.getAttribute("cartICount") %>권</td>
               <td><%=(int)request.getAttribute("totalCartPrice") -3000 %>원</td>               
           </tr>
           <%} %>
    </table>

</form>
<div>
	<h3>총 가격: <span id="totalPrice"><%=(int)request.getAttribute("totalCartPrice") - 3000 %></span>원</h3>
    <h3>배송비: <span>3000</span>원</h3>
    <h3>총 가격: <span id="totalCartPrice"><%=(int)request.getAttribute("totalCartPrice") %></span>원</h3>
    <button type="button" onclick="location.href='./customer/customerOrderComplete.jsp'">결제하기</button>


</div>

</body>
</html>