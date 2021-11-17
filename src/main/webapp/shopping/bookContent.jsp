<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.manager.BookDTO" %>
<%@ page import="bookshop.manager.BookTypeDTO" %>
<%@ page import="java.text.NumberFormat" %>
<%-- // get방식으로 한글(book_kind)을 넘겨주기 위해서는 java.net.URLEncoder가 필요하다. --%>
<%@ page import="java.net.URLEncoder" %>

<%
// 이전 페이지에서 넘겨준 정보를 가져온다.
String	book_id		= request.getParameter("book_id");
String	book_kind	= request.getParameter("book_kind");
String	userID		= "";
int		buyPrice	= 0;

// 이미지 파일을 보여주어야 하므로 관련된 부분을 준비한다.
String	realFolder	= "";
String	saveFolder	= "/imageFile";
ServletContext	context	= getServletContext();
realFolder				= context.getRealPath(saveFolder);
// realFolder	= "http://localhost:8088/BookShopProject/imageFile";
// C:\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BookShopProject\imageFile
System.out.println("realFolder => " + realFolder);

// 세션 정보가 있는 사람과 없는 사람의 차이를 둔다.(장바구니에 담기 여부)
if(session.getAttribute("userID") == null) {
	userID = "NOT";
} else {
	userID = (String)session.getAttribute("userID");
}

// 화면에 보여줄 정보를 DB에서 가져온다.(book_id에 해당하는 책의 정보를 가져온다.)
BookDTO	book	= null;
BookDAO	bookDAO	= BookDAO.getInstance();
book			= bookDAO.getBook(Integer.parseInt(book_id));

// 구매금액 = 판매가 x 구매권수
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책의 상세정보</title>
	<jsp:include page="../module/topInclude.jsp"/>
</head>
<body>

<jsp:include page="../module/shopMenu.jsp"/>

<!-- 책의 상세정보를 보고 수량을 입력한 후 OK를 누르면 카트에 담는다. -->
<div class="container">

<form name="inForm" method="post" action="cartInsertPro.jsp">
	<table class="table bordered">
		<tr>
			<td rowspan="9" width="150">
				<img src="<%=realFolder%>/<%=book.getBook_image()%>" border="0" width="150"  height="200"/>
			</td>
			<td width="100">
				<font size="+1"><b>제  목</b></font>
			</td>
			<td width="400">
				<font size="+1" color="blue"><b><%=book.getBook_title() %></b></font>
			</td>
		</tr>
		<tr>
			<td><font size="+1"><b>저  자</b></font></td>
			<td><font size="+1"><%=book.getAuthor() %></font></td>
		</tr>
		<tr>
			<td><font size="+1"><b>출판사</b></font></td>
			<td><font size="+1"><%=book.getPublishing_com() %></font></td>
		</tr>
		<tr>
			<td><font size="+1"><b>출판일</b></font></td>
			<td><font size="+1"><%=book.getPublishing_date() %></font></td>
		</tr>
		<tr>
			<td><font size="+1"><b>정  가</b></font></td>
			<td><font size="+1"><%=NumberFormat.getInstance().format(book.getBook_price()) %> 원</font></td>
		</tr>
		<tr>
			<td><font size="+1"><b>할인율</b></font></td>
			<td><font size="+1" color="blue"><%=book.getDiscount_rate() %> %</font></td>
		</tr>
		<% buyPrice = book.getBook_price() * (100 - book.getDiscount_rate()) / 100; %>
		<tr>
			<td><font size="+1"><b>판매가</b></font></td>
			<td><font size="+1" color="red"><%=NumberFormat.getInstance().format(buyPrice) %> 원</font></td>
		</tr>
		<tr>
			<td><font size="+1"><b>보유수량</b></font></td>
			<td>
				<font size="+1"><%=book.getBook_count() %> 권</font>
			</td>
		</tr>
		<tr>
			<td><font size="+1"><b>구매수량</b></font></td>
			<td>
				<%if(book.getBook_count() <= 0) { %>
					<font color="red"><b>일시품절</b></font>
				<%} else { 
					// 로그인을 한 사람의 경우는 재고가 있으면 장바구니에 담을 수 있게한다.
					if(!userID.equals("NOT")) { %>
					<input type="text" id="buyCount" size="4" name="buy_count" value="1"/>권
					<b><font color="red"><label id="totalAmount"></label></font></b>
					<!-- 카트에 담을 데이터를 숨겨놓는다. -->
					<input type="hidden" name="book_id" 	value="<%=book_id %>">
					<input type="hidden" name="book_image" 	value="<%=book.getBook_image() %>">
					<input type="hidden" name="book_title" 	value="<%=book.getBook_title() %>">
					<input type="hidden" name="buy_price" 	value="<%=buyPrice %>">
					<input type="hidden" name="book_kind" 	value="<%=book.getBook_kind() %>">
					<input type="submit" class="btn btn-warning btn-sm" value="장바구니에 담기"/>
				<%	} 
				}%>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="left"><%=book.getBook_content() %></td>
		</tr>
	</table>

</form>


</div>

<script>
// 구매권수에 변화가 생기면 구매가격을 계산해서 보여준다.
// .toLocaleString() : 자바스크립트에서 값을 단위로 표시하기 위해서 사용한다.
$("#buyCount").on('input', function() {
	if(Number($("#buyCount").val()) > <%=book.getBook_count()%>) {
		alert("보유수량보다 더 많이 구매하실 수는 없습니다.\n\n구매수량을 다시 입력해주십시오.");
		//$("#buyCount").val(1);
		 document.getElementById("buyCount").value = "1";
		document.inForm.buyCount.focus();
		return false;
	}
	$("#totalAmount").text(
		"총 구매가 : " + (Number(<%=buyPrice%>) * Number($("#buyCount").val())).toLocaleString() + "원");
});
</script>

</body>
</html>
















