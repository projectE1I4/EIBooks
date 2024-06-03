<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/styles/css/auth/auth.css?v=<%= new java.util.Date().getTime() %>">
</head>
<body>
<script>
    $(document).ready(function () {
        $("form").submit(function (event) {
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
                success: function (response) {
                    console.log("AJAX 성공:", response); // 응답을 확인하기 위한 로그
                    if (response.success) {
                        // 성공 시 사용자 데이터를 localStorage에 저장
                        localStorage.setItem("cus_id", cus_id);
                        localStorage.setItem("name", name);
                        localStorage.setItem("tel", tel);

                        $(".success-message").html(response.message.replace(/\n/g, "<br>")).show();
                        $(".error-message").hide();
                        setTimeout(function () {
                            console.log("Redirecting to /EIBooks/auth/resetPassword.cs"); // 리디렉션 로그
                            window.location.href = "/EIBooks/auth/resetPassword.cs"; // 비밀번호 재설정 페이지로 이동
                        }, 2000);
                    } else {
                        $(".error-message").html(response.message.replace(/\n/g, "<br>")).show();
                        $(".success-message").hide();
                    }
                },
                error: function () {
                    $(".error-message").text("서버 오류가 발생했습니다.").show();
                    $(".success-message").hide();
                }
            });
        });
    });
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap">
    <%@ include file="/common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="verification">
                <div class="anoterpage"><a href="login.cs">로그인으로 돌아가기</a></div>
                <h2>본인인증 하기</h2>
                <form>
                    <div class="form-group">
                        <label for="cus_id">아이디</label>
                        <input type="text" id="cus_id" name="cus_id" required placeholder="아이디를 입력해주세요">
                    </div>
                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" required placeholder="이름을 입력해주세요">
                    </div>
                    <div class="form-group">
                        <label for="tel">전화번호</label>
                        <input type="text" id="tel" name="tel" required placeholder="'-'를 제외한 전화번호 11자리를 입력해주세요">
                    </div>
                    <div class="error-message" style="display:none;"></div>
                    <div class="success-message" style="display:none;"></div>
                    <button type="submit" class="btn">본인인증 하기</button>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>