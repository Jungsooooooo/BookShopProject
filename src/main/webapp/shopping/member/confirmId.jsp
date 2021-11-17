<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDAO" %>

<%
request.setCharacterEncoding("UTF-8");

String	id	= request.getParameter("id");

int	returnVal = 0;
MemberDAO	memberDAO	= MemberDAO.getInstance();
returnVal	= memberDAO.confirmId(id);

if(returnVal == -1) {
	out.println("<br/>");
	out.println("<center><h2>" + id + "는 사용할 수 있는 아이디입니다.</h2></center>");
	out.println("<br/>");
} else {
	out.println("<br/>");
	out.println("<center><h2>이미 사용 중인 아이디입니다.</h2></center>");
	out.println("<center><h2>아이디를 다시 입력하십시오.</h2></center>");
	out.println("<br/>");
}
%>

<center>
	<input type="button" value="닫기" onclick="javascript:self.close()"/>
</center>

