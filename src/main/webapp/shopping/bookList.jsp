<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.manager.BookDTO" %>
<%@ page import="bookshop.manager.BookTypeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%-- // get방식으로 한글(book_kind)을 넘겨주기 위해서는 java.net.URLEncoder가 필요하다. --%>
<%@ page import="java.net.URLEncoder" %>
<%! SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분"); %>
<%
// 세션값을 가져온다.
String	userID = (String)session.getAttribute("userID");

// 화면하단의 페이지블럭 부분을 처리하기 위해서
PrintWriter pw = response.getWriter();

//-------------------------------------------------------------------------------------------------
// 로그인 한 사람과 안한 사람의 처리를 다르게 한다면 이곳에서 세션값을 검사한다.
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// 화면에 책의 정보들을 보여주기 전에 필요한 데이터들을 가져온다.
//-------------------------------------------------------------------------------------------------
// 화면에 보여줄 정보를 담은 저장소를 가리키는 참조변수
List<BookDTO>	bookList	= null;
String			book_kind	= "";

// 이 페이지에 들어올 때 가지고온 책의 종류를 변수에 저장한다.
book_kind	= request.getParameter("book_kind");

// 책의 타입에 대한 데이터들을 가져온다.
List<BookTypeDTO> 	bookTypes	= null;
BookTypeDTO			bookType	= null;

BookDAO	bookDAO = BookDAO.getInstance();
bookTypes		= bookDAO.getBookTypes();

// 한 페이지에서 보여줄 책의 목록의 개수를 정한다.
final int NUM_OF_PAGE = 4;

// 현재 페이지의 값을 저장할 변수. 페이지값이 없는 경우는 기본값을 1페이지로 한다.
int pageNumber; // = 1;

// 다른 페이지에서 페이지 값을 가지고 오는 경우는 넘겨받은 페이지값으로 설정한다.
// 웹페이지에서 넘어오는 모든 데이터는 자동 문자열로 처리되기 때문에 
// 다른 타입으로 사용하려면 형변환을 하여야 한다.
if(request.getParameter("pageNumber") != null) {
	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
} else {
	pageNumber = 1;
}

// 전 페이지의 마지막 줄 = 지금 페이지에 한 화면에서 보여줄 개수를 곱한 것이다.
int	startRow	= (pageNumber-1) * NUM_OF_PAGE + 1;	// 전 페이지의 마지막 줄 + 1
int	endRow		= pageNumber * NUM_OF_PAGE;			// 현재페이지의 마지막 글의 줄번호

int	number		= 0;	// 화면에 보여줄 게시글의 일련번호
int	totalCount	= 0;	// 전체 데이터 건수

// 책 종류에 따른 전체 데이터 건수를 알아낸다.
totalCount	= bookDAO.getBookCount(book_kind);

// 책 종류에 따라 보여줄 데이터가 있으면 보여줄 페이지에 해당하는 책의 정보들만 가져온다.
if(totalCount > 0) {
	bookList = bookDAO.getBooks(book_kind, startRow, NUM_OF_PAGE);
}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책방</title>
	<jsp:include page="../module/topInclude.jsp"/>
</head>
<body>

<jsp:include page="../module/shopMenu.jsp"/>

<div class="container-fluid">
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<h3 align="center"><span class="label label-primary">책 목록</span></h3>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-offset-4 col-sm-3">
			<h4 align="center"><span class="label label-info"><%=totalCount%>권</span></h4>
		</div>
	</div>
	<table class="table">
		<tr>
			<td>
				<div class="btn-group">
					<button type="button" class="btn btn-default btn-warning dropdown=toggle" data-toggle="dropdown" aria-expanded="false">
						도서종류 <span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="bookList.jsp?book_kind=all">전체목록보기</a></li>
						<%for(int i = 0; i < bookTypes.size(); i++) { 
							bookType = (BookTypeDTO)bookTypes.get(i); %>
						<li><a href="bookList.jsp?book_kind=<%=bookType.getId()%>"><%=bookType.getName()%></a></li>
						<%} %>
					</ul>
				</div>
			</td>
			<td align="right">
				<h5><a href="shopMain.jsp" class="btn btn-info">메인화면</a></h5>
			</td>
		</tr>
	</table>
	
	<table class="table table-bordered table-striped table-hover">
		<thead>
			<tr class="info">
				<td align=center width=20>번호</td>
				<td align=center width=34>책분류</td>
				<td align=center width=199>제목</td>
				<td align=center width=70>저자</td>
				<td align=center width=70>출판사</td>

				<td align=center width=50>출판일</td>
				<td align=center width=30>보유수량</td>
				<td align=center width=40>가격</td>
				<td align=center width=24>할인율</td>
				<td align=center width=50>판매가격</td>

				<td align=center width=99>등록일</td>
			</tr>
		</thead>
		<tbody>
			<% // 검색된 데이터의 건수만큼만 화면에 보여준다.
			int pageNo = 0;
			pageNo = (pageNumber - 1) * NUM_OF_PAGE;
			for(int i = 0; i < bookList.size(); i++) 
			{
				BookDTO bookDTO = (BookDTO)bookList.get(i);
			%>
			<tr>
				<td align=right><%=++pageNo %></td>
				<td align=center><%=bookDTO.getBook_kind() %></td>
				<td align=left>
					<a href="bookContent.jsp?book_id=<%=bookDTO.getBook_id()%>&book_kind=<%=URLEncoder.encode(bookDTO.getBook_kind(), "UTF-8")%>">
					<%=bookDTO.getBook_title() %></a>
				</td>
				<td><%=bookDTO.getAuthor() %></td>
				<td><%=bookDTO.getPublishing_com() %></td>
				<td align=center><%=bookDTO.getPublishing_date() %></td>
				<%if(bookDTO.getBook_count() < 1) { %>
					<td align=center><font color=red><b>일시품절</b></font></td>
				<%} else {%>
					<td align=right><%=NumberFormat.getInstance().format(bookDTO.getBook_count()) %>권</td>
				<%} %>
				<td align=right><%=NumberFormat.getInstance().format(bookDTO.getBook_price()) %>원</td>
				<td align=right><%=bookDTO.getDiscount_rate() %>%</td>
				<%-- 
					판매가격 = 정가 * (100  - 할인율) / 100
					판매가격 = 정가 - (정가 * 할인율) / 100
				 --%>
				<td align=right><font color=blue><b><%=NumberFormat.getInstance().format(bookDTO.getBook_price() * (100 - bookDTO.getDiscount_rate()) / 100) %>원</b></font></td>
				<td><%=sdf.format(bookDTO.getReg_date()) %></td>
			</tr>
			<%} // End - for %>
		</tbody>
	</table>
	
	<h6 align="center">
	<%
	if(totalCount > 0) {
		// pageCount : 보여져야할 페이지의 수
		// 보여줄 페이지는 종류에 따른 전체 책수를 화면당 보여줄 책수로 나누어 계산한다.
		// 나머지가 있으면 짜투리 1 페이지를 더 포함한다.
		int pageCount 	= totalCount / NUM_OF_PAGE
						+ (totalCount % NUM_OF_PAGE == 0 ? 0 : 1);
		
		// 화면 하단에 보여지는 페이지의 개수
		int pageBlock = 3;
		
		// 현재 보고있는 페이지가 5, 페이지블럭 3이라면 하단에는 [4][5][6]을 보여준다.
		// (pageNumber-1) : endPage 번호를 앞의 번호들의 계산에 맞추기 위해서
		int startPage	= (int)((pageNumber-1)/pageBlock) * pageBlock +1;
		int endPage		= startPage + pageBlock - 1;
		
		// 계산한 endPage가 실제 가지고 있는 페이지의 수보다 클 경우에는
		// 마지막에 보여줄 페이지(endPage)는 총 페이지수(pageCount)로 변경한다.
		if(endPage > pageCount) {
			endPage = pageCount;
		}
		
		// 이전 페이지
		// startPage가 pageBlock보다 큰 경우에는 [이전]을 보여준다.
		// [이전]버튼을 누르면 현재 보고있는 화면의 startPage에서 pageBlcok만큼 뺀 값이
		// 다음 화면의 첫 페이지가 되도록 한다. pageNumber = startPage - pageBlock;
		if(startPage > pageBlock) { %>
			<a href="bookList.jsp?pageNumber=<%=startPage-pageBlock%>&book_kind=<%=book_kind%>">[이전]</a>
		<% }
		
		// 하단에 페이지 번호를 보여준다. startPage부터 endPage까지 보여준다.
		for(int num = startPage; num <= endPage; num++) { %>
			<a href='bookList.jsp?pageNumber=<%=num%>&book_kind=<%=book_kind%>'>[<%=num %>]</a>
		<% }
		
		// [다음]버튼이 나타나는 경우
		// 화면에 보여줄 총 페이지 수보다 endPage가 작은 경우만 [다음]버튼을 나타나게 한다.
		if(endPage < pageCount) { %>
			<a href="bookList.jsp?pageNumber=<%=startPage+pageBlock%>&book_kind=<%=book_kind%>">[다음]</a>
		<% }

	}
	%>
	</h6>
	
</div>

</body>
</html>












