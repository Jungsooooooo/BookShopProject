<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
request.setCharacterEncoding("UTF-8");

// 로그인을 하고 입장한 경우와 아닌 경우에 따라 메뉴를 다르게 보여준다.
if(session.getAttribute("userID") == null)
{
	// sticky-top은 상단 공간을 차지하면서 위에 고정하고,
	// fixed-top은  상단 공간을 자지하지 않고 위에 고정된다.
	// 일부 내용이 상단 메뉴바에 가려져서 안보일 수 잇다.
	// <nav class="navbar navbar-inverse navbar-fixed-top">
%>
<nav class="navbar navbar-inverse navbar-sticky-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<h1><a class="navbar-brand" href="../shopping/shopMain.jsp">도서 쇼핑몰</a></h1>
		</div>
		
		<div>
			<!-- form-group이 있어야 삼선 버튼에 메뉴가 출력된다. -->
			<!-- button에 있는 data-target에는 #을 붙여야 아이디로 정의한 이름과 연결된다. -->
			<div class="form-group collapse navbar-collapse" id="myNavbar">
				<!-- 메뉴에서 로그인을 할 수 있도록 form을 사용한다. -->
				<form class="navbar-form navbar-right" method="post" action="../shopping/logon/loginPro.jsp">
					<a href="../shopping/bookList.jsp?book_kind=all" class="btn btn-success" aria-pressed="true">
						<span class="glyphicon glyphicon-list-alt"></span> 책방둘러보기
					</a>
					<div class="form-group">
						<input type="text"     class="form-control" name="id" size="12" maxlength="12" placeholder="아이디"/>
						<input type="password" class="form-control" name="passwd" size="12" maxlength="12" placeholder="비밀번호"/>
					</div>
					<button type="submit" class="btn btn-primary">
						<span class="glyphicon glyphicon-log-in"></span> 로그인
					</button>
					<a href="../shopping/member/memberInsertForm.jsp" class="btn btn-danger" aria-pressed="true">
						<span class="glyphicon glyphicon-user"></span> 회원가입
					</a>
				</form>
			</div>
		</div>
	</div>
</nav>

<% } else { // 로그인을 정상적으로 하고 들어온 경우 %>

<nav class="navbar navbar-inverse navbar-sticky-top">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<h1><a class="navbar-brand" href="../shopping/shopMain.jsp">도서 쇼핑몰</a></h1>
		</div>
		<div>
			<!-- form-group이 있어야 삼선 버튼에 메뉴가 출력된다. -->
			<!-- button에 있는 data-target에는 #을 붙여야 아이디로 정의한 이름과 연결된다. -->
			<div class="form-group collapse navbar-collapse navbar-right" id="myNavbar">
				<p class="navbar-text"><b><%=session.getAttribute("userID")%></b> 님, 즐거운 쇼핑시간 되십시오.</p>
				<a href="../shopping/bookList.jsp?book_kind=all" class="btn btn-success" aria-pressed="true">
					<span class="glyphicon glyphicon-list-alt"></span> 책방둘러보기
				</a>
				
				<a href="../shopping/cartList.jsp?book_kind=all" class="btn btn-primary" aria-pressed="true">
					<span class="glyphicon glyphicon-shopping-cart"></span> 장바구니보기
				</a>
				
				<a href="../shopping/buyList.jsp" class="btn btn-warning" aria-pressed="true">
					<span class="glyphicon glyphicon-list-alt"></span> 구매목록보기
				</a>
				
				<a href="../shopping/member/memberUpDelForm.jsp" class="btn btn-info" aria-pressed="true">
					<span class="glyphicon glyphicon-user"></span> 회원정보수정
				</a>
				
				<a href="../shopping/logon/logout.jsp" class="btn btn-danger" aria-pressed="true">
					<span class="glyphicon glyphicon-log-out"></span> 로그아웃
				</a>
			</div>  	
		</div>
	</div>
</nav>

<% } %>










