<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 가져오는 방식에 대해서 고민
	List<BookDTO> bookdto = (List<BookDTO>)request.getAttribute("bookList"); 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 목록 보기</title>
</head>
<body>
	<% 
	// 화면에 찍히는지 확인해볼 것
	%>
</body>
</html>