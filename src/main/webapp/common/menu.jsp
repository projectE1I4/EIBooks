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
<li><a href="/EIBooks/review/reviewList.do?bookNum=1&userNum=2">회원 리뷰 보기</a></li>
<li><a href="/EIBooks/review/reviewWrite.do?bookNum=1&userNum=2">회원 리뷰 작성하기</a></li>
<!-- <li><a href="/EIBooks/review/reviewUpdate.do?bookNum=1&userNum=1&reviewNum=2">회원 리뷰 수정하기</a></li> -->
<!-- <li><a href="/EIBooks/review/reviewList.do?bookNum=1&userNum=1">회원 리뷰 삭제하기(=회원 리뷰 보기)</a></li> -->
<li><a href="/EIBooks/review/replyList.do?userNum=1">관리자 전체리뷰 보기</a></li>
<!-- 
<li><a href="/EIBooks/review/replyWrite.do?userNum=1&reviewNum=174&isReply=1">관리자 답글 작성하기</a></li>
<li><a href="/EIBooks/review/replyUpdate.do?userNum=1&reviewNum=174&isReply=1">관리자 답글 수정하기</a></li>
<li><a href="/EIBooks/review/replyList.do?userNum=1">관리자 답글 삭제하기(=관리자 전체리뷰 보기)</a></li>
 -->
</ul>
<hr>
</body>
</html>