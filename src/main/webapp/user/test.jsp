<%@page import="eibooks.common.PageDTO"%>
<%@page import="java.util.List"%>
<%@page import="eibooks.dto.BookDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 가져오는 방식에 대해서 고민
	List<BookDTO> bookList = (List<BookDTO>)request.getAttribute("bookList");
	BookDTO bookdto = new BookDTO();
	PageDTO p = (PageDTO)request.getAttribute("paging");
	int totalCount = (int)request.getAttribute("totalCount");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>

<script>
function userGetBooks(){
	$.ajax({
        // contentType: 'application/json',
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userBookList.uapi',
        dataType:'json',
        data: {pageNum: <%=p.getPageNum()%>, searchWord: $('input[name="searchWord"]').val()},
        // data:JSON.stringify(param),
        success: function (response) {
        	//console.log(response);
            makeList(response);            
        },
        error: function (response, request, status, error)
       {
            console.log(request, status, error);
        }
    });
}
function userPaging(){
	$.ajax({
        //contentType: "application/json",
        type:'GET',
        url:'<%=request.getContextPath()%>/user/userPaging.uapi',
        dataType:'json',
        //data:param,
        //data:JSON.stringify(param),
        data:{searchWord: $('input[name="searchWord"]').val()},
        success: function (response) {
            console.log(response);
            makePaging(response);            
        },
        error: function (request, status, error) {
            console.log(request, status,error);
        }
    });
}
</script>
</head>
<body>

</body>
</html>