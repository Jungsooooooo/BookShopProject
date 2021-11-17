<%@page import="org.apache.commons.collections4.bag.SynchronizedSortedBag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bookshop.manager.BookDAO" %>
<%
request.setCharacterEncoding("utf-8");

// managerLoginForm.jsp에서 넘겨준 아이디와 비밀번호를 가져온다.
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");
// System.out.println("id : " 		+ id);
// System.out.println("passwd : " 	+ passwd);

// 아이디와 비밀번호가 DB에 있는지 검사하기 위한 메서드가 있는 DAO의 정보를 얻는다.
BookDAO bookDAO	= BookDAO.getInstance();

// managerLoginForm.jsp에서 넘겨준 아이디와 비밀번호가 DB에 있는지 검사한다.
int returnCheck = bookDAO.managerCheck(id, passwd);
System.out.println("리턴값 : " + returnCheck);

PrintWriter pw = response.getWriter();

// 검사결과에 따라 처리를 다르게 한다.
// 존재한다면 메니져 메뉴 화면을 보여주고,
// 아니면 로그인 화면으로 돌려보낸다.
if(returnCheck == 1) { // 인증 성공
	// 정상적으로 로그인이 검증되었기 때문에 세션을 발급한다.
	session.setAttribute("managerID", id);

	pw.println("<script>");
	pw.println("alert('인증성공.')");
	//pw.println("location.href('../managerMain.jsp')");
	pw.println("</script>");
	response.sendRedirect("../managerMain.jsp");
	
	// 세션정보를 가지고 매니저 관리페이지로 이동한다.
	//response.sendRedirect("../managerMain.jsp");
} else if(returnCheck == 0) { // 아이디는 있는데 비밀번호가 틀린경우
	pw.println("<script>");
	pw.println("alert('비밀번호가 맞지 않습니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
} else { // 아이디 자체가 존재하지 않는 경우
	pw.println("<script>");
	pw.println("alert('아이디가 존재하지 않습니다.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
}

%>








