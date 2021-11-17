<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%
// 세션 값이 없으면 로그인 화면으로 돌려보내고,
// 세션 값이 있으면 관리자 메인 화면을 보여준다.
String	managerID = "";	// 세션 값을 저장하기 위한 변수

// 매니저의 세션 아이디를 가져온다.
managerID = (String) session.getAttribute("managerID");

// 세션 값이 없으면 로그인 페이지로 돌려본내다.
if(managerID == null || managerID.equals("")) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('먼저 로그인을 하셔야 합니다.')");
	pw.println("location.href='./logon/managerLoginForm.jsp'");
	pw.println("</script>");
}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 메인 화면</title>
	<%@ include file="/module/topInclude.jsp" %>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

<!-- 화면의 최상단 부분 -->
<div class="container-fluid" style="background-color:#F44336; color:#FFF; height:200px;">
	<h1>도서 판매몰 관리</h1>
	<h3>관리자가 도서 쇼핑몰에 관한 모든 것을 관리하는 페이지입니다.</h3>
	<p>메뉴바는 화면이 스크롤되면 최상다네 보이게 되고, 스크롤에서 제외됩니다.</p>
</div>

<!-- 관리자 메뉴바 -->
<nav class="navbar navbar-inverse" data-spy="affix" data-offset-top="197">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#">Book Shop</a>
		</div>
		<!-- 메뉴 -->
		<div>
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav">
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 상품관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="product/bookRegisterForm.jsp">상품등록</a></li>
							<li><a href="product/bookList.jsp?book_kind=all">상품목록(수정/삭제)</a></li>
						</ul>
					</li>
					
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 배송관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="delivery/deliveryList.jsp">배송목록</a></li>
						</ul>
					</li>
					
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 통계관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="statistics/monthStatsForm.jsp">월별 판매 목록(꺽은선 그래프)</a></li>
							<li><a href="statistics/monthBarStatsForm.jsp">월별 판매 목록(막대 그래프)</a></li>
							<li><a href="statistics/bookKindStatsForm.jsp">도서종류별 연간 판매 비율</a></li>
						</ul>
					</li>
					
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#"> 회원관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="member/memberList.jsp?mode=0">회원목록</a></li>
						</ul>
					</li>
					
					
					<li class="dropdown">
						<a href="logon/managerLogout.jsp">로그아웃</a>
					</li>
				</ul>
			</div>
		</div>
	</div>


</nav>


</body>
</html>














