<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="eibooks.common.PageDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<CustomerDTO> customerList = (List<CustomerDTO>) request.getAttribute("customerList");
    int totalCount = (int) request.getAttribute("totalCount");
    PageDTO p = (PageDTO) request.getAttribute("paging");
    String searchField = (String) request.getAttribute("searchField");
    String searchWord = (String) request.getAttribute("searchWord");
    int totalCustomerCount = (int) request.getAttribute("totalCustomerCount");
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/common/head.jsp" %>
<link rel="stylesheet"
      href="/EIBooks/styles/css/customerManage/customerList.css?v=<%= new java.util.Date().getTime() %>">
<body>
<script>
    function goToPage(cus_seq) {
        location.href = "customerView.cs?cus_seq=" + cus_seq;
    }

    function del(cus_seq, event) {
        const input = confirm("정말 이 고객정보를 삭제하시겠습니까?");
        if (input) {
            location.href = "deleteCustomerProc.cs?cus_seq=" + cus_seq;
        } else {
            // 이벤트 버블링을 중지하여 tr 클릭 이벤트를 막음
            event.stopPropagation();
            alert('삭제를 취소 했습니다.');
        }
    }

    function rowClick(event, cus_seq) {
        // 삭제 버튼 클릭 시 rowClick이 호출되지 않도록 하기 위해 추가
        if (event.target.tagName.toLowerCase() === 'a') {
            return;
        }
        location.href = "customerView.cs?cus_seq=" + cus_seq;
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
                            <option value="name">회원명</option>
                            <option value="cus_id">회원아이디</option>
                        </select>
                        <input class="search_input" type="text" name="searchWord">
                        <input class="search_btn" type="submit" value="">
                    </form>
                </div>
                <div class="content">
                    <div style="width: 100%">
                        <% if (searchWord != null && !searchWord.isEmpty()) { %>
                        <p><%= searchField.equals("name") ? "회원명" : "회원아이디" %> '<%= searchWord %>' 검색 결과
                            (<%= totalCount %>
                            개)</p>
                        <% } %>
                    </div>
                    <div style="width: 100%; display: flex;justify-content: flex-end;">
                        <p>전체 회원 수: <%= totalCustomerCount %>명</p>
                    </div>
                    <div class="totalCount">
                        <p>전체</p>
                        <strong><%=totalCount %>
                        </strong>
                        <p>개</p>
                    </div>
                    <table class="customerList">
                        <caption>회원 목록 테이블</caption>
                        <thead class="col">
                        <tr>
                            <th class="col1">번호</th>
                            <th class="col2">아이디</th>
                            <th class="col3">비밀번호</th>
                            <th class="col4">이름</th>
                            <th class="col5">전화번호</th>
                            <th class="col6">이메일</th>
                            <th class="col7">가입일자</th>
                            <th class="col8">탈퇴여부</th>
                            <th class="col9" colspan="2">관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (customerList.isEmpty()) { %>
                        <tr>
                            <td colspan="10">&nbsp;<b>데이터가 없습니다.</b></td>
                        </tr>
                        <% } else { %>
                        <% for (CustomerDTO customer : customerList) { %>
                        <tr align="center" onclick="rowClick(event, <%=customer.getCus_seq()%>)">
                            <td><%=customer.getCus_seq() %>
                            </td>
                            <td><%=customer.getCus_id() %>
                            </td>
                            <td><%=customer.getPassword() %>
                            </td>
                            <td><%=customer.getName() %>
                            </td>
                            <td><%=customer.getTel() %>
                            </td>
                            <td><%=customer.getEmail() %>
                            </td>
                            <td><%=customer.getRegDate() %>
                            </td>
                            <td><%=customer.getDel_YN() %>
                            </td>
                            <td><a class="update_btn" href="updateCustomer.cs?cus_seq=<%=customer.getCus_seq() %>"
                                   onclick="event.stopPropagation();">수정</a></td>
                            <td><a class="delete_btn" href="javascript:void(0);"
                                   onclick="del('<%=customer.getCus_seq() %>', event);"><span
                                    class="blind">삭제</span></a>
                            </td>
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
                           href="customerList.cs?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=1">
                            <span class="blind">첫 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="first arrow off"><span class="blind">첫 페이지</span></a>
                        <% } %>

                        <% if (p.isPrev()) { %>
                        <a class="prev arrow"
                           href="customerList.cs?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getStartPage()-1%>">
                            <span class="blind">이전 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="prev arrow off"><span class="blind">이전 페이지</span></a>
                        <% } %>

                        <%for (int i = p.getStartPage(); i <= p.getEndPage(); i++) {%>
                        <%if (i == p.getPageNum()) {%>
                        <a class="number active"><%=i %>
                        </a>
                        <%} else { %>
                        <a class="number"
                           href="customerList.cs?<% if(searchWord != null) { %>searchField=<%=searchField %>&searchWord=<%=searchWord %>&<% } %>pageNum=<%=i %>"><%=i %>
                        </a>
                        <% } %>
                        <% } %>
                        <% if (p.isNext()) { %>
                        <a class="next arrow"
                           href="customerList.cs?<% if(searchWord != null) { %>&searchField=<%=searchField %>searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getEndPage()+1%>">
                            <span class="blind">다음 페이지</span>
                        </a>
                        <% } else { %>
                        <a class="next arrow off"><span class="blind">다음 페이지</span></a>
                        <% } %>

                        <% if (p.isNext()) { %>
                        <a class="last arrow"
                           href="customerList.cs?<% if(searchWord != null) { %>&searchField=<%=searchField %>searchWord=<%=searchWord %>&<% } %>pageNum=<%=p.getRealEnd()%>">
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