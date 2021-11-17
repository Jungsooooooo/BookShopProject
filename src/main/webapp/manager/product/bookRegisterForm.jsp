<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.manager.BookTypeDTO" %>
<%
// 세션 값이 없으면 로그인 화면으로 돌려보내고,
// 세션 값이 있으면 책을 등록할 수 있게 한다.
String managerID = "";	// 세션 값을 저장할 변수

// 매니저의 세션 정보를 가져온다.
managerID = (String) session.getAttribute("managerID");
System.out.println("매니저 아이디 : " + managerID);

// 세션 값이 없으면 로그인 화면으로 보낸다.
if(managerID == null || managerID.equals("")) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('먼저 로그인을 하셔야 합니다.')");
	pw.println("location.href='../logon/managerLoginForm.jsp'");
	pw.println("</script>");
}

// 시간 정보를 가져온다.
Timestamp nowTime = new Timestamp(System.currentTimeMillis());
// System.out.println(nowTime.toString());
// 2021-09-07 10:42:39.438
// substring(인덱스) : 인덱스(포함)부터 끝까지 
// substring(시작인덱스, 두번째인덱스) : 시작인덱스(포함) 부터 두번째 인덱스(미포함) 전까지
int lastYear = Integer.parseInt(nowTime.toString().substring(0, 4));

// 도서 타입에 대한 데이터를 가져온다.
List<BookTypeDTO>	bookTypes	= null;
BookTypeDTO			bookType	= null;

BookDAO	bookDAO	= BookDAO.getInstance();	// BookDAO 객체의 정보를 가져온다.
bookTypes		= bookDAO.getBookTypes();	// bookType 테이블에 있는 모든 데이터를 가져온다.

System.out.println(bookTypes);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 등록 페이지</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container">
	<form class="form-horizontal" name="bookRegisterForm" action="bookRegisterPro.jsp" method="post"
		enctype="multipart/form-data">
	
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">책 등록</h2>
			</div>
			<div class="col-sm-3">
				<a href="../managerMain.jsp" class="btn btn-success">관리자메인</a>
				<a href="bookList.jsp?book_kind=all" class="btn btn-info">책 목록</a>
			</div>
		</div>	
		
		<div class="form-group">
			<label class="control-label col-sm-2">책 종류</label>
			<div class="col-sm-2">
				<select class="form-control" name="book_kind" id="book_kind">
				<% for(int i = 0; i < bookTypes.size(); i++) { 
					bookType = (BookTypeDTO)bookTypes.get(i); %>
					<option value="<%= bookType.getId() %>"><%= bookType.getName() %></option>
				<% } %>
				</select>
			</div>
		</div>
	
		<div class="form-group">
			<label class="control-label col-sm-2">제  목</label>
			<div class="col-sm-8">
				<input type="text" class="form-control" maxlength="100" name="book_title" 
					onkeydown="nextFocus(book_price)" placeholder="제목"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">가  격</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" maxlength="6" name="book_price" 
						onkeydown="nextFocus(book_count)" placeholder="가격"/>
					<span class="input-group-addon"> 원</span>
				</div>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">수  량</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" maxlength="6" name="book_count"
						onkeydown="nextFocus(author)" placeholder="수량"/>
				</div>
			</div>
		</div>
	
		<div class="form-group">
			<label class="control-label col-sm-2">저  자</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" maxlength="40" name="author"
					onkeydown="nextFocus(publishing_com)" placeholder="저자"/>
			</div>
		</div>
	
		<div class="form-group">
			<label class="control-label col-sm-2">출판사</label>
			<div class="col-sm-4">
				<input type="text" class="form-control" maxlength="40" name="publishing_com"
					onkeydown="nextFocus(publishing_year)" placeholder="출판사"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">출판일</label>
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_year" 
						onkeydown="nextFocus(publishing_month)">
						<% for(int year = lastYear; year >= 2010; year--) { %>
							<option value="<%=year%>"><%=year%></option>
						<% } %>
					</select>
					<span class="input-group-addon">년</span>
				</div>
			</div>
		
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_month"
						onkeydown="nextFocus(publishing_day)">
						<% for(int month = 1; month <= 12; month++) { %>
							<option value="<%=month%>"><%=month%></option>
						<% } %>
					</select>
					<span class="input-group-addon">월</span>
				</div>
			</div>
		
			<div class="col-sm-2">
				<div class="input-group">
					<select class="form-control" name="publishing_day"
						onkeydown="nextFocus(book_image)">
						<% for(int day = 1; day <= 31; day++) { %>
							<option value="<%=day%>"><%=day%></option>
						<% } %>
					</select>
					<span class="input-group-addon">일</span>
				</div>
			</div>
		
		</div>
	
		<div class="form-group">
			<label class="control-label col-sm-2">파  일</label>
			<div class="col-sm-4">
				<input type="file" class="form-control" name="book_image" onkeydown="nextFocus(book_content)"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">내  용</label>
			<div class="col-sm-7">
				<textarea class="form-control col-sm-5" rows="10" cols="100" name="book_content" placeholder="책의 내용"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">할인율</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="text" class="form-control" size="4" maxlength="4" name="discount_rate"
						onkeydown="nextFocus(btn_OK)" placeholder="할인율"/>
					<span class="input-group-addon"> %</span>
				</div>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-2">
				<input type="reset"	 class="btn btn-warning" value="다시작성"/>
				<input type="button" class="btn btn-primary" name="btn_OK" onclick="checkBookRegisterForm(this.form)" value="등록"/>
			</div>
		</div>
	
	</form>
	
</div>


<script>
// 포커스를 이동시키는 함수
function nextFocus(where) {
	// alert("포커스를 이동시키는 함수");
	if(event.keyCode == 13) { // Enter Key를 눌렀으면 
		where.focus();
	}
}
</script>

<script>
function checkBookRegisterForm(bookRegisterForm) {
	
	// jQuery로 사용할 때의 방법
	// if($("#book_kind option:selected").val())	<= id   값을 비교할 때
	// if($("select[name=book_kind]").val())		<= name 값을 비교할 때
	
	if(!bookRegisterForm.book_kind.value) {
		alert("책의 종류를 선택하십시오.");
		bookRegisterForm.book_kind.focus();
		return false;
	}
	
	if(!bookRegisterForm.book_title.value) {
		alert("책의 제목을 입력하십시오.");
		bookRegisterForm.book_title.focus();
		return false;
	}
	
	if(!bookRegisterForm.book_price.value) {
		alert("책의 가격을 입력하십시오.");
		bookRegisterForm.book_price.focus();
		return false;
	}
	
	if(!bookRegisterForm.book_count.value) {
		alert("책의 수량을 입력하십시오.");
		bookRegisterForm.book_count.focus();
		return false;
	}
	
	if(!bookRegisterForm.author.value) {
		alert("책의 저자를 입력하십시오.");
		bookRegisterForm.author.focus();
		return false;
	}
	
	if(!bookRegisterForm.publishing_com.value) {
		alert("출판사를 입력하십시오.");
		bookRegisterForm.publishing_com.focus();
		return false;
	}
	
	if(!bookRegisterForm.discount_rate.value) {
		alert("할인율을 입력하십시오.");
		bookRegisterForm.discount_rate.focus();
		return false;
	}
	
	// 항목들 검사를 모두 통과하였으면, 다음 프로그램으로 이동시킨다.
	bookRegisterForm.action = "bookRegisterPro.jsp"
	bookRegisterForm.submit();
}
</script>

</body>
</html>





















