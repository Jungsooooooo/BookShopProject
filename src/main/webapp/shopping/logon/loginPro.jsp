<%@page import="org.apache.commons.collections4.bag.SynchronizedSortedBag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="java.io.PrintWriter" %>

<%
request.setCharacterEncoding("UTF-8");

// 전페이지에서 넘겨받은 아이디와 비밀번호를 변수에 저장한다.
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");

// 사용자 인증을 위해서 MemberDAO에게 일을 의뢰한다.
MemberDAO	memberDAO	= MemberDAO.getInstance();
int			checkVal	= memberDAO.memberCheck(id, passwd);
System.out.println("loginPro return => " + checkVal);

PrintWriter pw = response.getWriter();

// 의뢰한 결과에 따라 처리를 다르게 한다.
if(checkVal == 1) {
	// 정상적으로 로그인이 검증되면 세션을 발급한다.
	session.setAttribute("userID", id);
	response.sendRedirect("../shopMain.jsp");
} else if(checkVal == 0) {
	pw.println("<script>");
	pw.println("alert('비밀번호가 맞지 않습니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
} else {
	pw.println("<script>");
	pw.println("alert('존재하지 않는 아이디입니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
}
%>













