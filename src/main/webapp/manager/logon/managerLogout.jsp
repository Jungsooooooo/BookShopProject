<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
// 로그아웃 버튼을 누르면 세션을 제거한다.
session.invalidate();

// 로그아웃이 되었다는 메시지를 보여주고, managerMain.jsp로 이동시킨다.
PrintWriter pw	= response.getWriter();

pw.println("<script>");
pw.println("alert('로그아웃이 되었습니다.')");
pw.println("location.href='../managerMain.jsp'");
pw.println("</script>");
%>