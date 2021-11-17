<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.io.PrintWriter" %>
<%
request.setCharacterEncoding("UTF-8");

String	managerID	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerID == null || managerID.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

String	mode	= request.getParameter("mode"	);
String	id		= request.getParameter("id"		);
String	passwd	= request.getParameter("passwd"	);
String	name	= request.getParameter("name"	);
String	tel		= request.getParameter("tel"	);
String	address	= request.getParameter("address");
%>

<jsp:useBean id="memberDTO" scope="page" class="bookshop.shopping.MemberDTO">
</jsp:useBean>

<%
memberDTO.setId			(id);
memberDTO.setPasswd		(passwd);
memberDTO.setName		(name);
memberDTO.setTel		(tel);
memberDTO.setAddress	(address);
memberDTO.setReg_date	(new Timestamp(System.currentTimeMillis()));

MemberDAO	memberDAO	= MemberDAO.getInstance();

PrintWriter pw = response.getWriter();

if(mode.equals("UP")) {
	memberDAO.updateMember(memberDTO);
	
} else if(mode.equals("DEL")) {
	int returnVal = memberDAO.deleteMember(id, passwd);
	if(returnVal == 1) {
		pw.println("<script>");
		pw.println("alert('회원 삭제가 완료되었습니다.')");
		pw.println("location.href='memberList.jsp'");
		pw.println("</script>");
	} else {
		pw.println("<script>");
		pw.println("alert('회원 삭제 중 문제가 발생되었습니다.\\n잠시 후에 다시 시도해 주십시오.')");
		pw.println("history.back()");
		pw.println("</script>");
	}
} else {
	response.sendRedirect("memberList.jsp?mode=0");
}
%>

<!-- 수정/삭제가 완료되면 팝업창을 닫히게하고, 리스트를 자동 갱신되게 만든다. -->
<script>
// 부모창에 갱신한 내용으로 새로 고쳐준다.
opener.location.reload();
// 현재 팝업 창을 닫는다.
window.close();
</script>











