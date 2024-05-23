<%@page import="eibooks.dto.BookDTO" %>
<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="eibooks.dto.AddressDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고객 정보 상세보기</title>
    <style>
        tr td:first-child {
            width: 20%;
            height: 40px;
            text-align: center;
        }
        tr td:last-child {
            padding: 10px;
        }
        div {
            width: 60%;
            text-align: right;
            height: 50px;
            vertical-align: middle;
        }
    </style>
</head>
<body>

<%@ include file="../common/menu.jsp" %>
<h2>유저 정보 상세보기 </h2>
<%
    CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
    AddressDTO addr = customer != null ? customer.getAddrInfo() : null;
%>
<table border="1" width="60%">
    <thead>
    <tr>
        <th colspan="2">고객 정보</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>아이디</td>
        <td><%= customer != null ? customer.getCus_id() : "" %></td>
    </tr>
    <tr>
        <td>비밀번호</td>
        <td><%= customer != null ? customer.getPassword() : "" %></td>
    </tr>
    <tr>
        <td>이름</td>
        <td><%= customer != null ? customer.getName() : "" %></td>
    </tr>
    <tr>
        <td>전화번호</td>
        <td><%= customer != null ? customer.getTel() : "" %></td>
    </tr>
    <tr>
        <td>이메일</td>
        <td><%= customer != null ? customer.getEmail() : "" %></td>
    </tr>
    <tr>
        <td>우편번호</td>
        <td><%= addr != null ? addr.getPostalCode() : "" %></td>
    </tr>
    <tr>
        <td>주소</td>
        <td><%= addr != null ? addr.getAddr() : "" %></td>
    </tr>
    <tr>
        <td>상세주소</td>
        <td><%= addr != null ? addr.getAddr_detail() : "" %></td>
    </tr>
    <tr>
        <td>가입일자</td>
        <td><%= customer != null ? customer.getRegDate() : "" %></td>
    </tr>
    <tr>
        <td>탈퇴여부</td>
        <td><%= customer != null ? customer.getDel_YN() : "" %></td>
    </tr>
    </tbody>
</table>
<div><a href="customerList.cs"><p>목록으로 돌아가기</p></a></div>
<div><a href="customerOrder.or?cus_seq=<%=customer.getCus_seq()%>"><p>주문내역 보기</p></a></div>
</body>
</html>