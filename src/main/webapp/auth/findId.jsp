<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
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
                success: function (response) {
                    if (response.success) {
                        $(".success-message").text(response.message).show();
                        $(".error-message").hide();
                    } else {
                        $(".error-message").text(response.message).show();
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
<div id="wrap admin">
    <%@ include file="/common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="findId">
                <div class="anoterpage"><a href="login.cs">로그인으로 돌아가기</a></div>
                <h2>아이디 찾기</h2>
                <form>
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
                    <button type="submit" class="btn">아이디 찾기</button>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>