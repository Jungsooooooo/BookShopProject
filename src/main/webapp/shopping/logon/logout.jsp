<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
// 로그아웃은 세션을 제거한다.
session.invalidate();

// 메시지 보여주고 메인화면으로 돌려보낸다.
PrintWriter pw	= response.getWriter();

pw.println("<script>");
pw.println("alert('로그아웃이 되었습니다.')");
pw.println("location.href='../shopMain.jsp'");
pw.println("</script>");
%>