<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDAO" %>
<%@ page import="bookshop.shopping.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.PrintWriter" %>

<%
// 세션 정보를 가져온다.
String	buyer	= (String)session.getAttribute("userID");

// 세션 값이 없으면 메인 화면으로 돌려보낸다.
if(buyer == null || buyer.equals("")) {
	PrintWriter pw	= response.getWriter();
	pw.println("<script>");
	pw.println("alert('로그인을 하셔야 합니다.')");
	pw.println("location.href='shopMain.jsp'");
	pw.println("</script>");
}

String	book_kind	= request.getParameter("book_kind");

List<CartDTO>	cartLists	= null;
CartDTO			cartList	= null;
int	count	= 0;	// buyer가 가지고 있는 카트의 건수
int	number	= 0;
int	total	= 0;

// buyer가 가지고 있는 카트의 건수를 알아낸다.
CartDAO	cartDAO	= CartDAO.getInstance();
count			= cartDAO.getListCount(buyer);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>장바구니 목록</title>
	<jsp:include page="../module/topInclude.jsp"/>
</head>
<body>
<jsp:include page="../module/shopMenu.jsp"/>

<% // 장바구니가 하나도 없으면 책방으로 돌려보낸다. 
if(count <= 0) {
	PrintWriter pw = response.getWriter();
	pw.println("<script>");
	pw.println("alert('장바구니가 하나도 없습니다.\n쇼핑몰 화면으로 이동합니다.')");
	pw.println("location.href='shopMain.jsp'");
	pw.println("</script>");
} 

String			realFolder	= "";
String			saveFolder	= "/imageFile";
ServletContext	context		= getServletContext();
realFolder					= context.getRealPath(saveFolder);

// 화면에 보여줄 장바구니의 정보들을 가져온다.
cartLists	= cartDAO.getCarts(buyer);
%>

<div class="container">
	<h3><span class="label label-success">장 바 구 니</span></h3>
	<form name="cartModifyForm" action="updateCartPro.jsp" method="post">
		<table class="table table-bordered table-striped table-hover">
			<tr class="info">
				<td width= "50">번호</td>
				<td width="300">제  목</td>
				<td width="100">판매가격</td>
				<td width="150">수  량</td>
				<td width="150">가  격</td>
			</tr>
			<%for(int i = 0; i < cartLists.size(); i++) {
				cartList = (CartDTO)cartLists.get(i); %>
			<tr>
				<td><%=++number%></td>
				<td align="left">
					<img src="<%=realFolder%>/<%=cartList.getBook_image()%>" border="0" width="30" height="50" align="middle">
					<%=cartList.getBook_title()%>
				</td>
				<td align="right"><%=NumberFormat.getInstance().format(cartList.getBuy_price()) %>&nbsp;원</td>
				<td>
					<!-- input 속성을 disabled로 하면 다음 페이지로 값이 넘어가지 않는다. -->
					<!-- 값을 다음페이지로 넘기려면 readonly속성으로 설정해야 한다. -->
					<input type="text" style="text-align:right" name="buy_countOld" size="4"
							value="<%=cartList.getBuy_count() %>" readonly>&nbsp;권
					<input type="text" style="text-align:right" name="buy_count" size="4"
							value="<%=cartList.getBuy_count() %>">&nbsp;권
							
					<input type="hidden" class="form-control" name="cart_id"	value="<%=cartList.getCart_id() %>"/>
					<input type="hidden" class="form-control" name="book_kind"	value="<%=book_kind %>"/>
					<input type="hidden" class="form-control" name="book_id"	value="<%=cartList.getBook_id() %>"/>
					
					<input type="button" class="btn btn-warning btn-xs ModifyBtn" value="수정"/>
				</td>
				<td align="right">
					<%total += cartList.getBuy_count() * cartList.getBuy_price(); %>
					<%=NumberFormat.getInstance().format(cartList.getBuy_count()*cartList.getBuy_price()) %>&nbsp;원&nbsp;
					<input type="button" class="btn btn-danger btn-xs" value="비우기"
						onclick="javascript:window.location='cartListDel.jsp?list=<%=cartList.getCart_id()%>&book_kind=<%=book_kind%>'"/>
				</td>
			</tr>
			<% } // End - for %>
			<tr class="danger">
				<td colspan="5" align="right">
					<h4>총 금액 : <%=NumberFormat.getInstance().format(total)%>&nbsp;원&nbsp;</h4>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="center">
					<input type="button" class="btn btn-warning btn-sm" value="구매하기"
						onclick="javascript:window.location='buyForm.jsp'">&nbsp;&nbsp;
					<input type="button" class="btn btn-success btn-sm" value="쇼핑계속하기"
						onclick="javascript:window.location='bookList.jsp?book_kind=<%=book_kind%>'">&nbsp;&nbsp;
					<input type="button" class="btn btn-danger btn-sm" value="장바구니 모두 비우기"
						onclick="javascript:window.location='cartListDel.jsp?list=all&book_kind=<%=book_kind%>'">&nbsp;&nbsp;
					<input type="button" class="btn btn-info btn-sm" value="메인으로"
						onclick="javascript:window.location='shopMain.jsp'">&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</form>
	
	<div class="col-lg-12" id="ex2_result1"></div>
	<div class="col-lg-12" id="ex2_result2"></div>

</div>

<script>
// 수정 버튼을 누르면
$(".ModifyBtn").click(function() {
	var str			= "";
	var tdArr		= new Array();	// 배열 선언
	var	ModifyBtn	= $(this);
	
	// alert("ModifyBtn ==> " + ModifyBtn);
	
	// ModifyBtn.parent() => ModifyBtn의 부모는 <td>이다.
	// ModifyBtn.parent().parent() ==> <td>의 부모이므로 <tr>을 말한다.
	var	tr		= ModifyBtn.parent().parent();
	var td		= tr.children();

	//-------------------------------------------------------------------------
	// 전송할 값들을 추출하여 변수에 저장한 후에 전송한다.
	//-------------------------------------------------------------------------
	var	no				= td.eq(0).text();
	var	title			= td.eq(1).text();
	var	buy_price		= td.eq(2).text();
	var buy_countOld	= td.eq(3).find('input').eq(0).val();
	var	buy_count		= td.eq(3).find('input').eq(1).val();
	var	cart_id			= td.eq(3).find('input').eq(2).val();
	var	book_kind		= td.eq(3).find('input').eq(3).val();
	var	book_id			= td.eq(3).find('input').eq(4).val();
	var	totalMoney		= td.eq(4).text();
	
	//-----------------------------------------------------------------------------------------------------------
	// 반복문을 이용해서 배열에 값을 담아 사용할 수도 있다.
	//-----------------------------------------------------------------------------------------------------------
	td.each(function(i) {
		tdArr.push(td.eq(i).text());
	});

	console.log("장바구니 배열에 담긴 값 : " + tdArr);
	
	str +=	" * 클릭된 Row의 td값 = No. : <font color='red'>" + no + "</font>" +
	", 제목 : <font color='red'>" + title + "</font>" +
	", 가격 : <font color='red'>" + buy_price + "</font>" +
	", 수정 전 수량 : <font color='red'>" + buy_countOld + "</font>" +
	", 수정 후 수량 : <font color='red'>" + buy_count + "</font>" +
	", 금액 : <font color='red'>" + totalMoney + "</font>";		

	$("#ex2_result1").html("*** 클릭한 Row의 모든 데이터 ==> " + tr.text());	
	$("#ex2_result2").html(str);

	//-----------------------------------------------------------------------------------------------------------
	// form의 전송방식을 post로 하였으나, 
	// post로 테이블에 있는 데이터를 전송하면 무조건 테이블의 첫번째 데이터가 전송된다.
	// 찾은 값들을 get방식으로 url에 담아서 보낸다.
	// var ModifyBtn = $(this); 로 받은 값에서 추출한 후에 get방식으로 전송해야 한다.
	//-----------------------------------------------------------------------------------------------------------
	var url	= "updateCartPro.jsp"
			+ "?cart_id=" 		+ cart_id
			+ "&book_kind=" 	+ book_kind 	+ "&book_id=" 	+ book_id
			+ "&buy_countOld=" 	+ buy_countOld 	+ "&buy_count=" + buy_count;
	
	cartModifyForm.action = url;
	cartModifyForm.submit();
	
});

</script>

</body>
</html>



















