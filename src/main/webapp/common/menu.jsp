<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<ul>
<li><a href="/EIBooks/review/reviewList.do?bookNum=1">비회원 리뷰 보기</a></li>
<li><a href="/EIBooks/review/reviewList.do?bookNum=1&userId=admin">회원 리뷰 보기</a></li>
<li><a href="/EIBooks/review/reviewWrite.do?bookNum=1&userId=admin">회원 리뷰 작성하기</a></li>
<li><a href="/EIBooks/review/reviewUpdate.do?bookNum=1&userId=admin&reviewNum=1">회원 리뷰 수정하기</a></li>
<li>회원 리뷰 삭제하기</li>
<li>관리자 답글 조회하기</li>
<li>관리자 답글 작성하기</li>
<li>관리자 답글 수정하기</li>
<li>관리자 답글 삭제하기</li>
</ul>
<hr>
</body>
</html>