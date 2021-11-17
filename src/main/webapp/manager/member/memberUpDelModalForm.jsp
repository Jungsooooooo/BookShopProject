<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%
request.setCharacterEncoding("UTF-8");

String	managerID	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerID == null || managerID.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

String	mode	= request.getParameter("mode");
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");
String	name	= request.getParameter("name");
String	tel		= request.getParameter("tel1") + "-"
				+ request.getParameter("tel2") + "-"
				+ request.getParameter("tel3");
String	address	= request.getParameter("address");
%>

<jsp:useBean id="memberDTO" scope="page" class="bookshop.shopping.MemberDTO">
</jsp:useBean>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원 정보 수정/탈퇴</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container">
	<h2 align="center">고객 정보 <%if(mode.equals("UP")) {%> 수정 <%} else {%> 삭제 <%} %></h2>
	
	<button class="btn btn-primary btn-sm" data-toggle="modal" data-target="#myModal">
		<h4 align="center">고객 정보 <%if(mode.equals("UP")) {%> 수정 <%} else {%> 삭제 <%} %></h4>
	</button>
	
	<form class="form-horizontal" role="form" method="post" name="memberUpDelModalForm" action="memberUpDelPro.jsp">
		<input type="hidden" name="mode"	value="<%=mode 		%>">
		<input type="hidden" name="id"		value="<%=id 		%>">
		<input type="hidden" name="passwd"	value="<%=passwd 	%>">
		<input type="hidden" name="name"	value="<%=name 		%>">
		<input type="hidden" name="tel"		value="<%=tel 		%>">
		<input type="hidden" name="address"	value="<%=address	%>">
		
		<!-- Modal -->
		<div class="modal fade" id="myModal" >
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button  type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
						<h4 class="modal-title" id="myModalLabel">고객 정보를 <%if(mode.equals("UP")) {%> 수정 <%} else {%> 삭제 <%} %></h4>
					</div>
					
					<div class="modal-body">
						<h3>고객 정보를 <%if(mode.equals("UP")) {%> 수정 <%} else {%> 삭제 <%} %> 하시겠습니까?</h3>
					</div>
					
					<div class="modal-footer">
						<button type="button" class="btn btn-warning" data-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-danger">고객 정보 <%if(mode.equals("UP")) {%> 수정 <%} else {%> 삭제 <%} %></button> 
					</div>
				</div>
			</div>
		</div>
		
	</form>
</div>

<script>
// 프로그램 구동시 모달 창이 띄어진 상태로 만든다.
$(function() {
	$('#myModal').modal({
		keyboard:	true
	});
});
</script>
</body>
</html>

















