<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>본인인증</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            height: 100vh;
            margin: 0;
        }

        .login {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background-color: #fff;
            padding: 10px 20px 50px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 300px;
            text-align: center;
        }

        .container h2 {
            font-size: 2em;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #555;
            color: #fff;
            text-align: center;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #333;
        }

        .extra-links {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #999;
        }

        .extra-links a {
            text-decoration: none;
            color: #999;
        }

        .extra-links a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: red;
            margin-top: 15px;
        }

        .success-message {
            color: black;
            margin-top: 15px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            $("form").submit(function(event) {
                event.preventDefault(); // 기본 폼 서브밋 동작 방지

                var cus_id = $("#cus_id").val();
                var name = $("#name").val();
                var tel = $("#tel").val();

                // 아이디 유효성 검사
                var idPattern = /^[a-zA-Z0-9]{4,12}$/;
                if (!idPattern.test(cus_id)) {
                    alert("아이디는 4글자 이상, 12글자 이하의 영어 또는 숫자만 가능합니다.");
                    return false;
                }

                // 이름 유효성 검사
                var namePattern = /^[a-zA-Z가-힣\s]+$/; // 한글, 영문, 공백만 허용
                if (!namePattern.test(name)) {
                    alert("이름에는 특수문자가 포함될 수 없습니다.");
                    return;
                }
                // 전화번호 유효성 검사
                var telPattern = /^\d{11}$/;
                if (!telPattern.test(tel)) {
                    alert("전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "verificationProc.cs",
                    data: $(this).serialize(),
                    dataType: "json",
                    success: function(response) {
                        console.log("AJAX 성공:", response); // 응답을 확인하기 위한 로그
                        if (response.success) {
                            // 성공 시 사용자 데이터를 localStorage에 저장
                            localStorage.setItem("cus_id", cus_id);
                            localStorage.setItem("name", name);
                            localStorage.setItem("tel", tel);

                            $(".success-message").html(response.message.replace(/\n/g, "<br>")).show();
                            $(".error-message").hide();
                            setTimeout(function() {
                                console.log("Redirecting to /EIBooks/auth/resetPassword.cs"); // 리디렉션 로그
                                window.location.href = "/EIBooks/auth/resetPassword.cs"; // 비밀번호 재설정 페이지로 이동
                            }, 2000);
                        } else {
                            $(".error-message").html(response.message.replace(/\n/g, "<br>")).show();
                            $(".success-message").hide();
                        }
                    },
                    error: function() {
                        $(".error-message").text("서버 오류가 발생했습니다.").show();
                        $(".success-message").hide();
                    }
                });
            });
        });
    </script>
</head>
<%@ include file="../common/menu.jsp" %>
<body>
<div class="login">
    <div class="container">
        <div class="extra-links"><a href="login.cs">로그인페이지로 이동하기</a></div>
        <h2>본인인증 하기</h2>
        <form>
            <div class="form-group">
                <label for="cus_id">아이디</label>
                <input type="text" id="cus_id" name="cus_id" required>
            </div>
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="tel">전화번호</label>
                <input type="text" id="tel" name="tel" required>
            </div>
            <div class="error-message" style="display:none;"></div>
            <div class="success-message" style="display:none;"></div>
            <button type="submit" class="btn">본인인증 하기</button>
        </form>
    </div>
</div>
</body>
</html>