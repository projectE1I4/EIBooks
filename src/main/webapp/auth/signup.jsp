<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .container {
            margin: 0 auto;
            width: 50%;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }

        .form-group .optional {
            font-size: 0.9em;
            color: grey;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border: none;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #555;
        }

        .error-message {
            color: red;
            margin-bottom: 15px;
        }
    </style>
    <script>
        function validateForm() {
            var cus_id = document.getElementById("cus_id").value;
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var tel = document.getElementById("tel").value;
            var name = document.getElementById("name").value;
            var postalCode = document.getElementById("postalCode").value;

            // ID 유효성 검사
            var idRegex = /^[a-zA-Z0-9]{4,12}$/;
            if (!idRegex.test(cus_id)) {
                alert("아이디는 4글자 이상, 12글자 이하의 영어 또는 숫자만 가능합니다.");
                return false;
            }

            // 비밀번호 유효성 검사
            var pwRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
            if (!pwRegex.test(password)) {
                alert("비밀번호는 8글자 이상이어야 하며, 영문, 숫자, 특수문자를 포함해야 합니다.");
                return false;
            }

            // 비밀번호 확인 검사
            if (password !== confirmPassword) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                return false;
            }

            // 이름 유효성 검사
            var nameRegex = /^[a-zA-Z가-힣\s]+$/;
            if (!nameRegex.test(name)) {
                alert("이름에는 특수문자가 포함될 수 없습니다.");
                return;
            }

            // 전화번호 유효성 검사
            var telRegex = /^\d{11}$/;
            if (!telRegex.test(tel.replace(/-/g, ""))) {
                alert("전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                return false;
            }

            // 우편번호 유효성 검사
            var postalCodeRegex = /^\d{5}$/;
            if (!postalCodeRegex.test(postalCode)) {
                alert("우편번호는 숫자 5자리여야 합니다.");
                return false;
            }

            alert("회원가입 되었습니다.");
            return true;
        }

        function checkIdAvailability() {
            var cus_id = document.getElementById("cus_id").value;
            var idRegex = /^[a-zA-Z0-9]{4,12}$/;
            if (!idRegex.test(cus_id)) {
                document.getElementById("idCheckResult").innerText = "아이디는 4글자 이상, 12글자 이하의 영어 또는 숫자만 가능합니다.";
                return;
            }

            var xhr = new XMLHttpRequest();
            xhr.open("GET", "checkIdProc.cs?cus_id=" + encodeURIComponent(cus_id), true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    var resultElement = document.getElementById("idCheckResult");
                    if (response.exists) {
                        resultElement.innerText = "이미 존재하는 아이디입니다.";
                        resultElement.style.color = "red";
                    } else {
                        resultElement.innerText = "사용 가능한 아이디입니다.";
                        resultElement.style.color = "green";
                    }
                }
            };
            xhr.send();
        }
    </script>
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<div class="container">
    <h1>회원가입</h1>
    <form action="signupProc.cs" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="cus_id">아이디 <span>*</span></label>
            <input type="text" id="cus_id" name="cus_id" required placeholder="아이디를 입력해주세요">
            <button type="button" onclick="checkIdAvailability()">중복 확인</button>
            <div id="idCheckResult" class="check-result"></div>
        </div>
        <div class="form-group">
            <label for="password">비밀번호 <span>*</span></label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">비밀번호 확인 <span>*</span></label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message"><%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>
        <div class="form-group">
            <label for="name">이름 <span>*</span></label>
            <input type="text" id="name" name="name" required placeholder="ex) 홍길동">
        </div>
        <div class="form-group">
            <label for="tel">전화번호 <span>*</span></label>
            <input type="text" id="tel" name="tel" required>
        </div>
        <div class="form-group">
            <label for="postalCode">우편번호 <span>*</span></label>
            <input type="text" id="postalCode" name="postalCode" required>
        </div>
        <div class="form-group">
            <label for="addr">주소 <span>*</span></label>
            <input type="text" id="addr" name="addr" required>
        </div>
        <div class="form-group">
            <label for="addr_detail">상세주소 <span class="optional">(선택사항)</span></label>
            <input type="text" id="addr_detail" name="addr_detail">
        </div>
        <div class="form-group">
            <label for="email">이메일 <span class="optional">(선택사항)</span></label>
            <input type="email" id="email" name="email">
        </div>
        <div class="form-group">
            <button type="submit" class="btn">가입하기</button>
        </div>
    </form>
</div>
</body>
</html>