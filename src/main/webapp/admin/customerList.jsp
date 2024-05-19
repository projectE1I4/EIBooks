<%@ page import="eibooks.dto.CustomerDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="eibooks.common.PageDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<CustomerDTO> customerList = (List<CustomerDTO>) request.getAttribute("customerList");
    int totalCount = (int) request.getAttribute("totalCount");
    PageDTO p = (PageDTO) request.getAttribute("paging");
    String searchField = (String) request.getAttribute("searchField");
    String searchWord = (String) request.getAttribute("searchWord");
    int totalCustomerCount = (int) request.getAttribute("totalCustomerCount");
%>
<html>
<head>
    <title>고객 리스트</title>
    <script type="text/javascript">
        function goToPage(cus_seq) {
            location.href = "customerView.cs?cus_seq=" + cus_seq;
        }

        function del(cus_seq, event){
            const input = confirm("정말 이 고객정보를 삭제하시겠습니까?");
            if(input){
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
</head>
<body>
<%@ include file="../common/menu.jsp" %>
<h2>고객 리스트</h2>
<form method="get">
    <table border="1" width="90%">
        <tr>
            <td>
                <span>회원 검색하기 </span>
                <select name="searchField">
                    <option value="name">회원명</option>
                    <option value="cus_id">회원아이디</option>
                </select>
                <input type="text" name="searchWord">
                <input type="submit" value="Search">
            </td>
        </tr>
    </table>
</form>
<div style="width:90%; display: flex">
    <div style="width: 100%">
        <% if (searchWord != null && !searchWord.isEmpty()) { %>
        <p><%= searchField.equals("name") ? "회원명" : "회원아이디" %> '<%= searchWord %>' 검색 결과 (<%= totalCount %>
            개)</p>
        <% } %>
    </div>
    <div style="width: 100%; display: flex;justify-content: flex-end;">
        <p>전체 회원 수: <%= totalCustomerCount %>명</p>
    </div>
</div>
<table border="1" width="90%">
    <tr>
        <td colspan="10">&nbsp;<b>전체 <%=totalCount %>개</b>
        </td>
    </tr>
    <tr>
        <th width="5%">번호</th>
        <th width="10%">아이디</th>
        <th width="10%">비밀번호</th>
        <th width="10%">이름</th>
        <th width="15%">전화번호</th>
        <th width="20%">이메일</th>
        <th width="20%">가입일자</th>
    </tr>
    <% if (customerList.isEmpty()) { %>
    <tr>
        <td colspan="8">&nbsp;<b>Data Not Found!!</b></td>
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
        <td width="5%"><a href="updateCustomer.cs?cus_seq=<%=customer.getCus_seq() %>" onclick="event.stopPropagation();">[수정]</a></td>
        <td width="5%"><a href="javascript:void(0);" onclick="del('<%=customer.getCus_seq() %>', event);">[삭제]</a></td>
    </tr>
    <%} %>
    <%} %>
    <tr>
        <td colspan="10" style="text-align: center;">
            <%if (p.isPrev()) {%><a href="customerList.cs?pageNum=1">[First]</a><% } %>
            <%if (p.isPrev()) {%><a href="customerList.cs?pageNum=<%=p.getStartPage()-1%>">[Prev]</a><% } %>
            <%for (int i = p.getStartPage(); i <= p.getEndPage(); i++) {%>
            <%if (i == p.getPageNum()) {%>
            <b>[<%=i %>]</b>
            <%} else { %>
            <a href="customerList.cs?pageNum=<%=i%>">[<%=i %>]</a>
            <%} %>
            <%} %>
            <%if (p.isNext()) {%><a href="customerList.cs?pageNum=<%=p.getEndPage()+1%>">[Next]</a><% } %>
            <%if (p.isNext()) {%><a href="customerList.cs?pageNum=<%=p.getRealEnd()%>">[Last]</a><% } %>
        </td>
    </tr>
</table>
</body>
</html>