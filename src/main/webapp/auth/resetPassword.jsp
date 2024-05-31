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
        // localStorage에서 사용자 데이터 가져오기
        var cus_id = localStorage.getItem("cus_id");
        if (!cus_id) {
            alert("유효하지 않은 접근입니다. 본인인증을 먼저 해주세요.");
            window.location.href = "verification.jsp";
            return;
        }

        $("#cus_id").val(cus_id);

        $("form").submit(function (event) {
            event.preventDefault(); // 기본 폼 서브밋 동작 방지

            var newPassword = $("#newPassword").val();
            var confirmPassword = $("#confirmPassword").val();

            var pwRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
            if (!pwRegex.test(newPassword)) {
                alert("비밀번호는 8글자 이상이어야 하며, 영문, 숫자, 특수문자를 포함해야 합니다.");
                return false;
            }

            if (newPassword !== confirmPassword) {
                $(".error-message").text("비밀번호가 일치하지 않습니다.").show();
                $(".success-message").hide();
                return;
            }

            // 비밀번호 재설정 요청에 사용자 ID 포함
            $.ajax({
                type: "POST",
                url: "resetPasswordProc.cs",
                data: {
                    cus_id: cus_id,
                    newPassword: newPassword,
                    confirmPassword: confirmPassword
                },
                dataType: "json",
                success: function (response) {
                    alert(response.message); // 변경 완료 알림 또는 오류 메시지
                    if (response.success) {
                        $(".error-message").hide();
                        // localStorage에서 데이터 제거
                        localStorage.removeItem("cus_id");
                        localStorage.removeItem("name");
                        localStorage.removeItem("tel");
                        window.location.href = "login.cs";
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
<div id="wrap">
    <%@ include file="/common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div id="resetPassword">
                <h2>비밀번호 재설정</h2>
                <form>
                    <div class="form-group">
                        <label for="cus_id">아이디</label>
                        <input type="text" id="cus_id" name="cus_id" readonly>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">비밀번호</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="변경 하려는 비밀번호를 입력해 주세요."
                               required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="비밀번호를 한번 더 입력해 주세요."
                               required>
                    </div>
                    <div class="error-message" style="display:none;"></div>
                    <div class="success-message" style="display:none;"></div>
                    <button type="submit" class="btn">비밀번호 재설정하기</button>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>