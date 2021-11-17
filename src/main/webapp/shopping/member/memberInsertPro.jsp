<%@page import="org.apache.commons.collections4.bag.SynchronizedSortedBag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="bookshop.shopping.MemberDTO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.io.PrintWriter" %>

<%
request.setCharacterEncoding("UTF-8");

// 전 페이지에서 넘져준 자료를 정리한다.
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");
String	name	= request.getParameter("name");
String	tel		= request.getParameter("tel1") + "-"
				+ request.getParameter("tel2") + "-"
				+ request.getParameter("tel3");
String	address	= request.getParameter("address");

// 데이터를 MemberDTO를 생서하고 MemberDTO Bean에 담는다
// MemberDTO memberDTO = new MemberDTO();
%>
<jsp:useBean id="memberDTO" scope="page" class="bookshop.shopping.MemberDTO"></jsp:useBean>
<%
memberDTO.setId(id);
memberDTO.setPasswd(passwd);
memberDTO.setName(name);
memberDTO.setTel(tel);
memberDTO.setAddress(address);
memberDTO.setReg_date(new Timestamp(System.currentTimeMillis()));

// DB에 작업할 인스턴스를 가져온다.
MemberDAO memberDAO	= MemberDAO.getInstance();

// memberDTO 를 MemberDAO에 넘겨주고 작업(회원가입)을 시킨다.
int	result	= memberDAO.insertMember(memberDTO);
System.out.println("회원가입 :  " + result);

PrintWriter	pw	= response.getWriter();

if(result == 1) { // 회원 가입 성공
	pw.println("<script>");
	pw.println("alert('회원가입이 되었습니다.')");
	pw.println("location.href='../shopMain.jsp'");
	pw.println("</script>");
	// 홈페이지로 이동한다.
	//response.sendRedirect("../shopMain.jsp");
} else { // 회원 가입 처리 중 문제 발생
	pw.println("<script>");
	pw.println("alert('회원가입처리 중에 문제가 생겼습니다.\n잠시후에 다시 해주십시오.')");
	pw.println("history.go(-1)");
	pw.println("</script>");
}

// response.sendRedirect("../shojpMain.jsp");  <= 메시지 화면이 보이지 않고 바로 이동해버린다.

%>











