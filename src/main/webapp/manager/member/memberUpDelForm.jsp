<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDTO" %>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%
String	managerID	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerID == null || managerID.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

request.setCharacterEncoding("UTF-8");

// 수정할 사용자 아이디를 전 페이지로 부터 받아들인다.
String buyer = request.getParameter("userId");

// 선택한 buyer에 해당하는 정보를 가져온다.
MemberDAO	memberDAO	= MemberDAO.getInstance();
MemberDTO	memberDTO	= memberDAO.getMember(buyer);

// 전화번호를 3단위로 나누어 저장할 변수
String	tel1	= "";
String	tel2	= "";
String	tel3	= "";

tel1	= memberDTO.getTel().substring(0, 3);
if(memberDTO.getTel().length() == 12) { // 가운데 자리수가 3인 경우
	tel2	= memberDTO.getTel().substring(4,  7);
	tel3	= memberDTO.getTel().substring(8, 12);
} else { // 가운데 자리수가 4인 경우
	tel2	= memberDTO.getTel().substring(4,  8);
	tel3	= memberDTO.getTel().substring(9, 13);
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객정보 수정/탈퇴</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container">
	<form class="form-horizontal" method="post" name="memberUpDelForm" action="memberUpDelModalForm.jsp">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">고객 정보 수정/탈퇴</h2>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">아이디</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="id" name="id" maxlength="12" value="<%=buyer%>" readonly/>
			</div>
		</div>

		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="passwd" name="passwd" maxlength="12" value="<%=memberDTO.getPasswd()%>"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호확인</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="repasswd" name="repasswd" maxlength="12" value="<%=memberDTO.getPasswd()%>"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">이  름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="name" name="name" maxlength="10" value="<%=memberDTO.getName()%>"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">주  소</label>
			<div class="col-sm-7">
				<input type="text" class="form-control" id="address" name="address" maxlength="100" value="<%=memberDTO.getAddress()%>"/>
			</div>
		</div>
		
			<div class="form-group">
			<label class="control-label col-sm-2">휴대폰</label>
			<div class="col-sm-2">
				<select class="form-control" name="tel1">
					<option value="010" <%if(tel1.equals("010")) {%>selected<%}%>>010</option>
					<option value="011" <%if(tel1.equals("011")) {%>selected<%}%>>011</option>
					<option value="017" <%if(tel1.equals("017")) {%>selected<%}%>>017</option>
					<option value="018" <%if(tel1.equals("018")) {%>selected<%}%>>018</option>
					<option value="019" <%if(tel1.equals("019")) {%>selected<%}%>>019</option>
				</select>
			</div>
			<div class="input-group col-sm-3">
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel2" maxlength="4" value="<%=tel2%>"/></div>
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel3" maxlength="4" value="<%=tel3%>"/></div>
			</div>
		</div>
		
		<!-- 수정/삭제 버튼 -->
		<div class="form-group">
			<div  class="col-sm-offset-2 col-sm-6">
				<button type="button" class="btn btn-success" onclick="memberUpDelCheckForm(this.form, 'UP')" >회원정보수정</button>
				<button type="button" class="btn btn-danger"  onclick="memberUpDelCheckForm(this.form, 'DEL')">회원정보삭제</button>
			</div>
		</div>
	</form>
</div>

</body>
<%@ include file="function.jsp" %>
</html>












