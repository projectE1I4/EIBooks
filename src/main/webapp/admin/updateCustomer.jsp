<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="eibooks.dto.AddressDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
    AddressDTO addr = customer != null ? customer.getAddrInfo() : null;
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
      href="/EIBooks/styles/css/customerManage/customerUpdate.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<script>
    function goToPage(cus_seq) {
        location.href = "customerView.cs?cus_seq=" + cus_seq;
    }

    function validateForm() {
        var password = document.forms["updateForm"]["password"].value;
        var name = document.forms["updateForm"]["name"].value;
        var tel = document.forms["updateForm"]["tel"].value;
        var postalCode = document.forms["updateForm"]["postalCode"].value;
        var addr = document.forms["updateForm"]["addr"].value;

        if (password == "") {
            alert("비밀번호를 입력하세요.");
            return false;
        }
        if (name == "") {
            alert("이름을 입력하세요.");
            return false;
        }
        if (tel == "") {
            alert("전화번호를 입력하세요.");
            return false;
        }
        if (postalCode == "") {
            alert("우편번호를 입력하세요.");
            return false;
        }
        if (addr == "") {
            alert("주소를 입력하세요.");
            return false;
        }
        return true;
    }
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
    <%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div class="customerUpdate">
                <h2>고객 정보 수정하기</h2>
                <form name="updateForm" method="post" action="updateCustomerProc.cs" onsubmit="return validateForm()">
                    <input type="hidden" name="cus_seq" value="<%= customer != null ? customer.getCus_seq() : "" %>">
                    <table class="customerInfo">
                        <tbody>
                        <tr>
                            <th>아이디</th>
                            <td><%= customer != null ? customer.getCus_id() : "" %>
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호</th>
                            <td><input type="password" name="password"
                                       value="<%= customer != null ? customer.getPassword() : "" %>">
                            </td>
                        </tr>
                        <tr>
                            <th>이름</th>
                            <td><input type="text" name="name"
                                       value="<%= customer != null ? customer.getName() : "" %>"></td>
                        </tr>
                        <tr>
                            <th>전화번호</th>
                            <td><input type="text" name="tel" value="<%= customer != null ? customer.getTel() : "" %>">
                            </td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td><input type="text" name="email"
                                       value="<%= customer != null ? customer.getEmail() : "" %>"></td>
                        </tr>
                        <tr>
                            <th>우편번호</th>
                            <td><input type="text" name="postalCode"
                                       value="<%= addr != null ? addr.getPostalCode() : "" %>"></td>
                        </tr>
                        <tr>
                            <th>주소</th>
                            <td><input type="text" name="addr" value="<%= addr != null ? addr.getAddr() : "" %>"></td>
                        </tr>
                        <tr>
                            <th>상세주소</th>
                            <td><input type="text" name="addr_detail"
                                       value="<%= addr != null ? addr.getAddr_detail() : "" %>"></td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="actions">
                        <input type="submit" value="수정하기">
                        <a onclick="goToPage(<%=customer.getCus_seq()%>)">돌아가기</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>