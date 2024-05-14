<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 가져오는 방식에 대해서 고민
	// 검색 시 얘가 지금 null 값으로 가져오는 중임
	List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList");
	BookDTO bookdto = new BookDTO();
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 목록 보기</title>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">

// 주석 안된 것처럼 보이지만 주석처리 됨
 /*	function categorySelect(value){
	var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // 서버로부터 응답을 받았을 때 실행할 코드
            console.log('성공');
            $('#selectCategory').val(value);
        }
    };
    xhttp.open("GET", "<%=request.getContextPath()%>/user/userBookList.bo?selectCategory=" + value, true);
	console.log(value);
    xhttp.send();
    
    // 서브밋 되면 새로고침 일어남 서브밋 사용 불가 AJAX 사용해야함
     // $('#cateMenu').submit();
}

$(function (){ 
	// 카테고리 셀렉 함수
	//$('input:radio').click(function(){
		//var value = $(this).val();
		// 기본 checked를 1에 걸어두고
	// checked 된 라디오 버튼이 없을 경우에
	var listVar;
	if(listVar == $('input:radio').val() ){
		$('input:radio').prop('checked', true);
		$('input:radio').not(this).prop('checked', false);
	} else {
		$('input:radio:first').prop('checked', true);
	}
    
	// 라디오 버튼을 클릭했을 때
    $('input:radio').click(function(){
        // 클릭된 라디오 버튼 이외의 다른 라디오 버튼의 checked 속성을 제거
		listVar = $('input[name=selectCategory]:checked').val();
    	console.log(listVar);
		categorySelect(listVar);
    });	
})
*/
</script>

</head>
<body>
<%@ include file="../common/menu.jsp" %>
<!-- 제목 --> 
<h2>도서 목록 보기</h2>

<!-- 카테고리 -->
<!-- all / 만화 / 소설,시,희곡, / 수험서, 자격증 / 인문학 -->
<h3>카테고리</h3>
<form id="cateMenu" enctype="multipart/form-data">
<table border="1" width="90%">
	<tr>
	<td width="20%"><input name="selectCategory" type="radio" value="전체"/>전체</td>
	<td width="20%"><input name="selectCategory" type="radio" value="만화" />만화</td>
	<td width="20%"><input name="selectCategory" type="radio" value="소설/시/희곡"/>소설/시/희곡</td>
	<td width="20%"><input name="selectCategory" type="radio" value="수험서/자격증"/>수험서/자격증</td>
	<td width="20%"><input name="selectCategory" type="radio" value="인문학"/>인문학</td>
	</tr>
</table>
<input type="text" id="selectCategory" value="">
</form>
<!-- 검색창 -->
<form method="get">
<table border="1" width="90%">
	
	<%
	String searchWord = request.getParameter("searchWord");
	if (searchWord != null && !searchWord.isEmpty()) {
    	// 입력 값이 있을 때 실행할 코드%> 
   	 	<tr><td>검색어 : '<b><%=searchWord %></b>'</td></tr>
   	 	<%} else {// 입력 값이 없을 때 실행할 코드%><br><%}%>
	<tr><td>
		<input type="text" name="searchWord" <%if(searchWord !=null){%> value="<%=searchWord%>" <%} %> placeholder="검색어를 입력하세요.">
		<input type="submit" value="Search">
	</td></tr>
</table>
</form>

<!-- 전체 목록 -->


<table border="1" width="90%">
<tr><td colspan="4">
&nbsp;<b>카테고리 :<% if(bookdto.getCategory()==null){ 
%> 전체 <% }else{ 
%> document.getElementById("selectCategory").value<% } %></b></td>
<td colspan="4">&nbsp;<b>전체 :<%=p.getPageNum() %> / <%=totalCount %></b></td></tr>
	<tr>
		<th width="5%">넘버링</th>
		<th width="10%">이미지</th>
		<th width="20%">도서 명</th>
		<th width="10%">저자 명</th>
		<th width="8%">출판사</th>
		<th width="8%">출간일</th>
		<th width="35%">디스크립션</th>
		<th width="20%">금액</th>
		<th width="20%">버튼</th>
	</tr>
	<% if(bookList.isEmpty()) { %>	
	<tr><td colspan="8">&nbsp;<b>Data Not Found!!</b></td></tr>
<% } else { 
int cnt = 1;
%>
	<% for(BookDTO book : bookList){ %>	
		<tr align="center">
			<td><%=cnt++ %></td>
			<td><img alt="" src="<%=book.getImageFile() %>"></td>
			<td align="left"><%=book.getTitle() %></td>
			<td align="left"><%=book.getAuthor() %></td>
			<td align="left"><%=book.getPublisher() %></td>
			<td><%=book.getPubDate() %></td>
			<td><%=book.getDescription() %></td>
			<td><%=book.getPrice() %>원</td>
			<td>
			<button type="button">주문하기</button>
			<button type="button">장바구니</button>
			</td>
		</tr>
	<%} %>
<%} %>
<tr>
<td colspan="8">
<%-- first는 하드 코딩 (1번으로 가기 때문에 당연함) --%>
<% System.out.print("프리브"+p.isNext()); %>
<%if(p.isPrev()) {%><a href="userBookList.bo?pageNum=1">[First]</a><% } %>
<%-- getStartPage는 이전 10개 전으로 돌아감. 수식 확인 필요 --%>
<%if(p.isPrev()) {%><a href="userBookList.bo?pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
<%for(int i=p.getStartPage(); i<= p.getEndPage(); i++) {%>
	<%if(i == p.getPageNum()){%>
		<b>[<%=i %>]</b>
	<%}else{ %>
	<a href="userBookList.bo?pageNum=<%=i%>">[<%=i %>]</a>
	<%} %>
<%} %>
<%if(p.isNext()){%><a href="userBookList.bo?pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
<%if(p.isNext()){%><a href="userBookList.bo?pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
</td>
</tr>

</table>

</body>
</html>