<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.manager.BookDTO" %>
<%@ page import="bookshop.manager.BookTypeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%! SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분"); %>

<%
// DTO : Data Transfer Object, VO : Value Object
// DAO : Data Access   Object

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

// 화면에 보여줄 책들의 정보를 저장할 저장소를 가리키는 참조변수 
List<BookDTO> bookList = null;

// 이 페이지가 시작될 때 필요한 책의 타입 정보를 알아낸다.
String	book_kind = "";
book_kind = request.getParameter("book_kind");
System.out.println("book_kind => " + book_kind);

// 책의 타입에 대한 데이터를 가져온다.
// ==> 책의 타입을 선택하면 그 타입에 해당하는 책들만 가져오기 위해서
List<BookTypeDTO>	bookTypes	= null;
BookDAO	bookDAO	= BookDAO.getInstance();
bookTypes		= bookDAO.getBookTypes();

BookTypeDTO	bookType	= null;

// 한 페이지에서 보여줄 책 목록의 개수를 정의한다.
final int	NUM_OF_PAGE = 4; 

// 현재 페이지의 값을 저장할 변수. 페이지 값이 없을 경우는 1페이지를 기본으로 한다.
int	pageNumber = 1;

// 다른 페이지에서 페이지 값을 가지고 오는 경우는 넘겨 받은 값으로 현재 페이지의 값을 저장한다.
// 웹에서 넘어오는 모든 데이터는 자동으로 문자열로 처리되기 때문에 
//   다른 타입으로 사용하려면 형변환 처리를 해야한다.
if(request.getParameter("pageNumber") != null) {
	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
}

// 현재 페이지에서 보여줄 데이터의 startRow, endRow를 계산한다.
// 현재 보고자하는 페이지는 (pageNumber-1) * NUM_OF_PAGE + 1가 된다.
int startRow	= (pageNumber-1) * NUM_OF_PAGE + 1;
// 현재 페이지의 마지막 행은 페이지번호 x 한 페이지당 보여줄 목록의 수 
int	endRow		= pageNumber * NUM_OF_PAGE;

int	totalCount	= 0;	// 화면에 보여줄 전체 데이터 건수
int	number		= 0;	// 현재 화면에 보이는 책목록의 일련번호

// 선택한 책의 종류에 대해 화면에 보여줄 전체 데이터 건수를 알아낸다.
totalCount	= bookDAO.getBookCount(book_kind);

// 보여줄 데이터가 있는 경우만 현재 페이지와 책 종류에 해당하는 책들의 모든 정보를 가져온다.
if(totalCount > 0) {
	bookList = bookDAO.getBooks(book_kind, startRow, NUM_OF_PAGE);
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 목록 보기</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<h3 align="center"><span class="label label-primary"> 책 목록 </span></h3>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<% if(book_kind.equals("all")) { %>
				<h3 align="center"><span class="label label-warning">종류 : 전체&nbsp;&nbsp;<%=totalCount%>권</span></h3>
			<% } else {
				for(int x = 0; x < bookTypes.size(); x++) {
					bookType = (BookTypeDTO)bookTypes.get(x);
					if(book_kind.equals(bookType.getId())) {
				%>
				<h3 align="center"><span class="label label-warning">종류 : <%=bookType.getName()%>&nbsp;&nbsp;<%=totalCount%>권</span></h3>
				<%	}	
				}
			} %>
		</div>
	</div>

	<table class="table">
		<tr>
			<td>
				<div class="btn-group">
					<button type="button" class="btn btn-info dropdown=toggle" data-toggle="dropdown" aria-expanded="false">
						도서종류 <span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="bookList.jsp?book_kind=all">전체목록보기</a></li>
						<% for(int i = 0; i < bookTypes.size(); i++) {
							bookType = (BookTypeDTO)bookTypes.get(i); %>
							<li><a href="bookList.jsp?book_kind=<%=bookType.getId()%>"><%=bookType.getName()%></a></li>
						<% } %>
					</ul>
				</div>
			</td>
			<td align="right">
				<h5>
					<a href="bookRegisterForm.jsp"	class="btn btn-primary">책 등록</a>
					<a href="../managerMain.jsp"	class="btn btn-info">메인메뉴</a>
				</h5>
			</td>
		</tr>
	</table>
	

	<% // 검색된 책이 한 권도 없을 경우
	if(totalCount < 1) {
		out.println("<table class='table table-bordered>");
			out.println("<tr>");
				out.println("<td align=center><h2>등록된 책이 한 권도 없습니다.</h2></td>");
			out.println("</tr>");
		out.println("</table>");
	} else { // 검색된 책이 한 권이라도 있으면 테이블형태로 화면에 보여준다.
		//---------------------------------------------------------------------------------------------------------
System.out.println("전체권수 : " + bookList.size()); 
	%>
		<table class="table table-bordered table-striped table-hover">
			<tr class="info">
				<td align=center width=20>번호</td>
				<td align=center width=34>책종류</td>
				<td align=center width=99>제목</td>
				<td align=center width=40>가격</td>
				<td align=center width=30>수량</td>

				<td align=center width=70>저자</td>
				<td align=center width=70>출판사</td>
				<td align=center width=50>출판일</td>
				<td align=center width=50>책이미지</td>
				<td align=center width=24>할인율</td>

				<td align=center width=99>등록일</td>
				<td align=center width=50>수정</td>
				<td align=center width=50>삭제</td>
			</tr>
			<% 	// 검색된 데이터의 건 수만큼만 화면에 보여준다. 
				// NUM_OF_PAGE 이하 만큼만 
			int startNo = 0;
			startNo = (pageNumber -1) * NUM_OF_PAGE;
			for(int i = 0; i < bookList.size(); i++)
			{
				BookDTO book = (BookDTO)bookList.get(i);
			%>
			<tr>
				<td align=right><%=++startNo %></td>
				<td align=center><%=book.getBook_kind() %></td>
				<td align=left><%=book.getBook_title() %></td>
				<td align=right><%=NumberFormat.getInstance().format(book.getBook_price()) %>원</td>
				<%if(book.getBook_count() < 1) { // 재고가 없는 경우 %>
					<td align=center><font color=red><b>재고 없음</b></font></td>
				<%} else { // 재고가 있는 경우%>
					<td align="right"><%=NumberFormat.getInstance().format(book.getBook_count()) %>권</td>
				<%} %>
				<td align=center><%=book.getAuthor() %></td>
				<td align=center><%=book.getPublishing_com() %></td>
				<td align=center><%=book.getPublishing_date() %></td>
				<td align=center><%=book.getBook_image() %></td>
				<td align=right><%=book.getDiscount_rate() %>%</td>
				<td align=center><%=sdf.format(book.getReg_date()) %></td>
				<td align=center>
					<a href="bookUpdateForm.jsp?book_id=<%=book.getBook_id() %>&book_kind=<%=URLEncoder.encode(book.getBook_kind(), "UTF-8") %>">수정</a>
				</td>
				<td align=center>
					<a href="bookDeleteForm.jsp?book_id=<%=book.getBook_id() %>&book_kind=<%=URLEncoder.encode(book.getBook_kind(), "UTF-8") %>&book_title=<%=URLEncoder.encode(book.getBook_title(), "UTF-8") %>">삭제</a>
				</td>
			</tr>				
			
			<% } %>
			
		</table>	
	
		<h6 align=center>	
		<%
		//---------------------------------------------------------------------------------------------------------
		if(totalCount > 0) {
			// pageCount : 보여져야할 페이지의 수
			// 보여줄 페이지는 종류에 따른 전체 책권수를 나누어 나머지가 생기면 1페이지를 추가한다.
			// 짜투리 수(나머지 수)는 별도로 1페이지를 추가한다.
			int pageCount	= totalCount / NUM_OF_PAGE
							+ (totalCount % NUM_OF_PAGE == 0 ? 0 : 1);
			
			// 화면 하단에 보여지는 페이지의 개수
			int pageBlock = 10;
			
			// 선택한 페이지 번호가 pageBlock내에 있으면 startPage를 하단에 보여줄 페이지 번호의 맨 앞번호로 한다.
			// 현재 페이지가 5이고 페이지 블럭이 3이라면 하단에는 [4][5][6]을 보여준다.
			// (pageNumber-1) : endPage 번호를 앞의 번호들의 계산에 맞추기 위해서 
			int startPage	= (int)((pageNumber-1)/pageBlock)*pageBlock+1;
			int endPage		= startPage + pageBlock -1;	
			
			// 계산한 endPage가 실제 가지고 있는 페이지의 수보다 클 경우,
			// 마지막 보여줄 페이지(endPage)는 총 페이지수(pageCount)로 변경한다.
			if(endPage > pageCount) endPage = pageCount;
			
			// 이전 페이지
			// startPage가 pageBlock보다 큰 경우에는 [이전]을 보여준다.
			// [이전]버튼을 누르면 현재 보고있는 화면의 startPage에서 pageBlock만큼 뺀 값이
			// 다음 화면의 첫페이지가 되도록한다. pageNumber = startPage - pageBlock;
			if(startPage > pageBlock) { %>
				<a href="bookList.jsp?pageNumber=<%=startPage-pageBlock%>&book_kind=<%=book_kind%>">[이전]</a>
			<%}

			// 하단에 페이지 번호를 보여준다. startPage부터 endPage까지 보여준다.
			for(int num = startPage; num <= endPage; num++) { %>
				<a href="bookList.jsp?pageNumber=<%=num%>&book_kind=<%=book_kind%>">[<%=num %>]</a>
			<%} 
			
			// 다음 페이지
			// 화면에 보여줄 총 페이지 수보다 endPage가 작은 경우만 [다음]버튼을 나타나게 한다.
			// startPage+pageBlock 또는 endPage+1
			if(endPage < pageCount) { %>
				<a href="bookList.jsp?pageNumber=<%=startPage+pageBlock%>&book_kind=<%=book_kind%>">[다음]</a>
			<%}
		}
		%>
	
		</h6>
	
	<% } // End - 검색된 책이 한 권이라도 있으면 %>
	

</div>	
</body>
</html>


















