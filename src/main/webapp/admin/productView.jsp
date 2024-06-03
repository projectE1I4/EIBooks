<%@page import="eibooks.dto.BookDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<% // param
    BookDTO dto = (BookDTO) request.getAttribute("dto");
    String sBook_seq = request.getParameter("book_seq");
    int book_seq = Integer.parseInt(sBook_seq);
%>
<!DOCTYPE html>
<html lang="ko">
 	<%@ include file="/common/head.jsp" %>
    <link rel="stylesheet" href="/EIBooks/styles/css/yeon/productView.css?v=<?php echo time(); ?>">
    <script type="text/javascript">
        $(document).ready(function () {

        });

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
</head>
<body>

<div id="skip_navi">
    <a href="#container">본문바로가기</a>
</div>
<div id="wrap" class="pv">
	<%@ include file="../common/header.jsp" %>
    <main id="container">
        <div class="product_view inner">
            <div class="productView">
                <h2 class="title"><%=dto.getTitle() %>
                </h2>
                <p class="author"><%=dto.getAuthor()%>
                </p>
                <hr>
                <div class="info_wrap">
                    <div class="img_wrap">
                        <img src="<%=dto.getImageFile() %>" alt="표지이미지">
                    </div>
                    <div class="product_info">
                        <strong class="price"><%=dto.getPrice() %>원</strong>
                        <div class="flex_wrap">
                            <p class="col">도서 분류</p>
                            <p class="category"><%=dto.getCategory() %>
                            </p>
                        </div>
                        <div class="txt_wrap">
                            <div class="flex_wrap">
                                <p class="col">출판사</p>
                                <p class="publisher"><%=dto.getPublisher() %>
                                </p>
                            </div>
                            <div class="flex_wrap">
                                <p class="col">출간일</p>
                                <p class="pubDate"><%=dto.getPubDate() %>
                                </p>
                            </div>
                        </div>

                        <div class="txt_wrap">
                            <div class="flex_wrap">
                                <p class="col">isbn10</p>
                                <p class="isbn"><%=dto.getIsbn10() %>
                                </p>
                            </div>
                            <div class="flex_wrap">
                                <p class="col">isbn13</p>
                                <p class="isbn"><%=dto.getIsbn13() %>
                                </p>
                            </div>
                        </div>

                        <p class="description"><%=dto.getDescription() %>
                        </p>
                        <div class="stock_wrap">
                            <p>재고 수량</p>
                            <p><%=dto.getStock() %>개</p>
                        </div>
                        <div class="btn_wrap">
                            <a href="updateProduct.bo?book_seq=<%=book_seq %>" class="btn update_btn">수정</a>
                            <a href="javascript:del('<%=book_seq %>');" class="btn delete_btn">삭제</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>
</body>
</html>