<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="eibooks.dto.AddressDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <style>
        tr td:first-child {
            width: 20%;
            height: 40px;
            text-align: center;
        }

        div {
            width: 60%;
            text-align: right;
            height: 50px;
            vertical-align: middle;
        }
    </style>
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
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<%
    CustomerDTO customer = (CustomerDTO) request.getAttribute("customer");
    AddressDTO addr = customer != null ? customer.getAddrInfo() : null;
%>
<h2>회원정보 수정하기</h2>
<form name="updateForm" method="post" action="updateCustomerProc.cs" onsubmit="return validateForm()">
    <input type="hidden" name="cus_seq" value="<%= customer != null ? customer.getCus_seq() : "" %>">
    <table border="1" width="60%">
        <thead>
        <tr>
            <th colspan="2">고객 정보</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>아이디</td>
            <td><%= customer != null ? customer.getCus_id() : "" %>
            </td>
        </tr>
        <tr>
            <td>비밀번호</td>
            <td><input type="password" name="password" value="<%= customer != null ? customer.getPassword() : "" %>">
            </td>
        </tr>
        <tr>
            <td>이름</td>
            <td><input type="text" name="name" value="<%= customer != null ? customer.getName() : "" %>"></td>
        </tr>
        <tr>
            <td>전화번호</td>
            <td><input type="text" name="tel" value="<%= customer != null ? customer.getTel() : "" %>"></td>
        </tr>
        <tr>
            <td>이메일</td>
            <td><input type="email" name="email" value="<%= customer != null ? customer.getEmail() : "" %>"></td>
        </tr>
        <tr>
            <td>우편번호</td>
            <td><input type="text" name="postalCode" value="<%= addr != null ? addr.getPostalCode() : "" %>"></td>
        </tr>
        <tr>
            <td>주소</td>
            <td><input type="text" name="addr" value="<%= addr != null ? addr.getAddr() : "" %>"></td>
        </tr>
        <tr>
            <td>상세주소</td>
            <td><input type="text" name="addr_detail" value="<%= addr != null ? addr.getAddr_detail() : "" %>"></td>
        </tr>
        </tbody>
    </table>
    <div style="display: flex;width: 60%;justify-content: flex-end; gap:10px">
        <input type="submit" value="수정하기">
        <p onclick="goToPage(<%=customer.getCus_seq()%>)">돌아가기</p>
    </div>
</form>
</body>
</html>