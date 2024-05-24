<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
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

                // 이름 유효성 검사
                var name = $("#name").val();
                var namePattern = /^[a-zA-Z가-힣\s]+$/; // 한글, 영문, 공백만 허용
                if (!namePattern.test(name)) {
                    alert("이름에는 특수문자가 포함될 수 없습니다.");
                    return;
                }
                // 전화번호 유효성 검사
                var tel = $("#tel").val();
                var telPattern = /^\d{11}$/;
                if (!telPattern.test(tel)) {
                    alert("전화번호는 '-'를 제외하고 숫자 11자리여야 합니다.");
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "findIdProc.cs",
                    data: $(this).serialize(),
                    dataType: "json", // 서버 응답을 JSON 형식으로 기대
                    success: function(response) {
                        if (response.success) {
                            $(".success-message").text(response.message).show();
                            $(".error-message").hide();
                        } else {
                            $(".error-message").text(response.message).show();
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
        <h2>아이디 찾기</h2>
        <form>
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
            <button type="submit" class="btn">아이디 찾기</button>
        </form>
    </div>
</div>
</body>
</html>