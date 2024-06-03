<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="eibooks.dto.AddressDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
    AddressDTO addr = customer != null ? customer.getAddrInfo() : null;
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
      href="/EIBooks/styles/css/customerManage/customerView.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
    <%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div class="customerView">
                <h2>고객 정보 상세보기</h2>
                <table class="customerInfo">
                    <tbody>
                    <tr>
                        <th>아이디</th>
                        <td><%= customer != null ? customer.getCus_id() : "" %></td>
                    </tr>
                    <tr>
                        <th>비밀번호</th>
                        <td><%= customer != null ? customer.getPassword() : "" %></td>
                    </tr>
                    <tr>
                        <th>이름</th>
                        <td><%= customer != null ? customer.getName() : "" %></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td><%= customer != null ? customer.getTel() : "" %></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><%= customer != null ? customer.getEmail() : "" %></td>
                    </tr>
                    <tr>
                        <th>우편번호</th>
                        <td><%= addr != null ? addr.getPostalCode() : "" %></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td><%= addr != null ? addr.getAddr() : "" %></td>
                    </tr>
                    <tr>
                        <th>상세주소</th>
                        <td><%= addr != null ? addr.getAddr_detail() : "" %></td>
                    </tr>
                    <tr>
                        <th>가입일자</th>
                        <td><%= customer != null ? customer.getRegDate() : "" %></td>
                    </tr>
                    <tr>
                        <th>탈퇴여부</th>
                        <td><%= customer != null ? customer.getDel_YN() : "" %></td>
                    </tr>
                    </tbody>
                </table>
                <div class="actions">
                    <a href="updateCustomer.cs?cus_seq=<%=customer.getCus_seq() %>">수정하기</a>
                    <a href="customerOrder.or?cus_seq=<%=customer.getCus_seq()%>">주문내역 보기</a>
                    <a href="customerList.cs">목록으로 돌아가기</a>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>