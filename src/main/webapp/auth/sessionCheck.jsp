<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    // 로그인 안된 상태
    if(session.getAttribute("customer") != null){
        response.sendRedirect("/EIBooks/");
    }
%>
