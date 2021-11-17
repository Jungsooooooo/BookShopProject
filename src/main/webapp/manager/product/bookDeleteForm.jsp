<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.URLEncoder" %>

<%
//세션 값이 없으면 로그인 화면으로 돌려보내고,
//세션 값이 있으면 책을 등록할 수 있게 한다.
String managerID = "";	// 세션 값을 저장할 변수

//매니저의 세션 정보를 가져온다.
managerID = (String) session.getAttribute("managerID");
System.out.println("매니저 아이디 : " + managerID);

//세션 값이 없으면 로그인 화면으로 보낸다.
if(managerID == null || managerID.equals("")) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('먼저 로그인을 하셔야 합니다.')");
	pw.println("location.href='../logon/managerLoginForm.jsp'");
	pw.println("</script>");
}

// 이전 페이지로 부터 책의 아이디와 종류를 가져온다.
int		book_id		= Integer.parseInt(request.getParameter("book_id"));
String	book_kind	= request.getParameter("book_kind");
String	book_title	= request.getParameter("book_title");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 정보 삭제</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container">
	<form class="form-horizontal" method="post" name="deleteForm" action="bookDeletePro.jsp">
		
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">책 정보 삭제</h2>
			</div>
			<div class="col-sm-4">
				<a href="../managerMain.jsp" class="btn btn-success">관리자메인</a>
				<a href="bookList.jsp?book_kind=all" class="btn btn-info">책 목록</a>
				<a href="bookList.jsp?book_kind=<%=book_kind %>" class="btn btn-info">책 목록(분류선택)</a>
			</div>
		</div>	
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2"><h2>책 아이디</h2></div>
			<div class="col-sm-6">
				<h2 align="left"><%= book_id %></h2>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2"><h2>책 제목</h2></div>
			<div class="col-sm-6">
				<h2 align="left"><%= book_title %></h2>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2"></div>
			<div class="col-sm-2">
				<input type="button" class="btn btn-danger" value="삭제" name="btnDel" id="btnDel"/>
			</div>
		</div>
		
	</form>
</div>

<script>
$(function() {
	$("#btnDel").on("click", function() {
		var result = confirm('정말 삭제하시겠습니까?');
		if(result) { // true
			location.replace('bookDeletePro.jsp?book_id=<%=book_id%>&book_kind=<%=URLEncoder.encode(book_kind, "UTF-8")%>');
		} else { // false
			location.href='bookList.jsp?&book_kind=all'; // 삭제를 취소하면 목록화면으로 돌려보낸다.
		}
	});
});
</script>

</body>

</html>












