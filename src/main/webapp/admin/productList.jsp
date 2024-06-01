<%@page import="eibooks.common.PageDTO" %>
<%@page import="eibooks.dto.BookDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    List<BookDTO> bookList = (List<BookDTO>) request.getAttribute("bookList");
    PageDTO p = (PageDTO) request.getAttribute("paging");
    int totalCount = (int) request.getAttribute("totalCount");
    String searchField = (String) request.getAttribute("searchField");
    String searchWord = (String) request.getAttribute("searchWord");
%>
<!DOCTYPE html>
<html lang="ko">
  <%@ include file="/common/head.jsp" %>
  <link rel="stylesheet" href="/EIBooks/styles/css/yeon/productList.css?v=<?php echo time(); ?>">
  <script type="text/javascript">   
    
    function del(book_seq){
    	const input = confirm("정말 삭제하시겠습니까?");
    	if(input){
    		location.href = "<%=request.getContextPath()%>/deleteProductProc.bo?book_seq="+book_seq;
    	}else{
    		alert('삭제를 취소했습니다.');
    		return;
    	}
    	
    }
   </script>
</head>
<body>
<script>
    function del(book_seq) {
        const input = confirm("정말 삭제하시겠습니까?");
        if (input) {
            location.href = "<%=request.getContextPath()%>/deleteProductProc.bo?book_seq=" + book_seq;
        } else {
            alert('삭제를 취소했습니다.');
            return;
        }

    }
</script>
<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="admin">
    <%@ include file="/common/header.jsp" %>
    <main id="container">
        <div class="inner">
            <div class="board_list_wrap">
                <div>
                    <form method="get" class="search_wrap">
                        <select name="searchField">
                            <option value="category"
                                    <% if(searchField != null && searchField.equals("category")) { %>selected<% } %>>도서
                                분류
                            </option>
                            <option value="title"
                                    <% if(searchField != null && searchField.equals("title")) { %>selected<% } %>>도서 명
                            </option>
                            <option value="author"
                                    <% if(searchField != null && searchField.equals("author")) { %>selected<% } %>>저자 명
                            </option>
                            <option value="publisher"
                                    <% if(searchField != null && searchField.equals("publisher")) { %>selected<% } %>>
                                출판사
                            </option>
                        </select>
                        <input class="search_input" type="text" name="searchWord"
                               <% if(searchWord != null) { %>value="<%=searchWord %>"<% } %>>
                        <input class="search_btn" type="submit" value="">
                    </form>
                </div>
                <div class="content">
                    <div class="totalCount">
                        <p>전체</p>
                        <strong><%=totalCount %>
                        </strong>
                        <p>개</p>
                    </div>

                    <table class="productList">
                        <caption>제품 목록 테이블</caption>
                        <thead class="col">
                        <tr>
                            <th class="col1">도서 분류</th>
                            <th class="col2">도서 명</th>
                            <th class="col3">저자 명</th>
                            <th class="col4">출판사</th>
                            <th class="col5">출간일</th>
                            <th class="col6">재고 수량</th>
                            <th class="col7" colspan="2">관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (bookList.isEmpty()) { %>
                        <tr>
                            <td colspan="8">&nbsp;<b>데이터가 없습니다.</b></td>
                        </tr>
                        <% } else { %>
                        <% for (BookDTO book : bookList) { %>
                        <tr>
                            <td>
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getCategory() %>
                                </a>
                            </td>
                            <td class="title">
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getTitle() %>
                                </a>
                            </td>
                            <td class="author">
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getAuthor() %>
                                </a>
                            </td>
                            <td class="publisher">
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getPublisher() %>
                                </a>
                            </td>
                            <td>
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getPubDate() %>
                                </a>
                            </td>
                            <td>
                                <a href="productView.bo?book_seq=<%=book.getBook_seq()%>" class="link_btn">
                                    <%=book.getStock() %>
                                </a>
                            </td>
                            <td><a class="update_btn" href="updateProduct.bo?book_seq=<%=book.getBook_seq() %>">수정</a></td>
                            <td><a class="delete_btn" href="javascript:del('<%=book.getBook_seq() %>');"><span class="blind">삭제</span></a></td>
                        </tr>
                        <%} %>
                        <%} %>
                        </tbody>
                    </table>

                    <div class="pagination">
                        <% if (totalCount == 0) { %>
                        <a class="number active">1</a>
                        <% } else { %>
                        <% if (p.isPrev()) { %>
                        <a class="first arrow"
                           href="productList.bo?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=1">
                            <span class="blind">첫 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="first arrow off"><span class="blind">첫 페이지</span></a>
                        <% } %>

                        <% if (p.isPrev()) { %>
                        <a class="prev arrow"
                           href="productList.bo?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getStartPage()-1%>">
                            <span class="blind">이전 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="prev arrow off"><span class="blind">이전 페이지</span></a>
                        <% } %>

                        <% for (int i = p.getStartPage(); i <= p.getEndPage(); i++) { %>
                        <% if (i == p.getPageNum()) { %>
                        <a class="number active"><%=i %>
                        </a>
                        <% } else { %>
                        <a class="number"
                           href="productList.bo?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=<%=i %>"><%=i %>
                        </a>
                        <% } %>
                        <% } %>

                        <% if (p.isNext()) { %>
                        <a class="next arrow"
                           href="productList.bo?<% if(searchWord != null) { %>&searchField=<%=searchField %>searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getEndPage()+1%>">
                            <span class="blind">다음 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="next arrow off"><span class="blind">다음 페이지</span></a>
                        <% } %>

                        <% if (p.isNext()) { %>
                        <a class="last arrow"
                           href="productList.bo?<% if(searchWord != null) { %>&searchField=<%=searchField %>searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getRealEnd()%>">
                            <span class="blind">마지막 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="last arrow off"><span class="blind">마지막 페이지</span></a>
                        <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>

</body>
</html>