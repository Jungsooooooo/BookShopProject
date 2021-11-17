<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.BuyDTO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%
if(session.getAttribute("userID") == null || session.getAttribute("userID").equals("")) {
	response.sendRedirect("shopMain.jsp");
}

// 세션 정보를 가져온다. => 세션 아이디에 해당하는 구매정보를 가져오기 위해서
String buyer	= (String)session.getAttribute("userID");

List<BuyDTO>	buyLists	= null;
BuyDTO			buyList		= null;
int				count		= 0;		// 총 구매건수
int				sum			= 0;		// 소계금액
int				total		= 0;		// 총구매금액
long			nextBuy_id	= 0;		// 현재 buy_id와 비교하기 위한 변수 

String			realFolder	= "";
String			saveFolder	= "/imageFile";
ServletContext	context		= getServletContext();
realFolder					= context.getRealPath(saveFolder);

// 데이터를 가져올 때 사용할 Bean과 연결을 한 후에 보여줄 자료가 있는지 건수를 먼저 조사한다.
BuyDAO	buyDAO	= BuyDAO.getInstance();
count			= buyDAO.getListCount(buyer);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>구매 목록</title>
	<jsp:include page="../module/topInclude.jsp"/>
</head>
<body>
<jsp:include page="../module/shopMenu.jsp"/>

<div class="container">

<% //구매한 내역이 없는 경우
if(count < 1) { %>
	<table class="table table-bordered table-striped table-hover">
		<tr class="info">
			<td align="center"><h2>구매하신 내역이 없습니다.</h2></td>
		</tr>
	</table>
<% } else { // 구매한 내역이 있는 경우는 구매내역을 화면에 보여준다. 
	buyLists = buyDAO.getBuyLists(buyer); // 화면에 보여줄 정보를 가져온다.
%>
	<table class="table table-bordered table-striped table-hover">
		<tr>
			<td colspan="6" align="center">
				<h3><span class="label label-success">구 매 목 록</span></h3>
			</td>
		</tr>
		<tr class="info">
			<td width="" align="center">번호</td>
			<td width="" align="center">제    목</td>
			<td width="" align="center">배송상태</td>
			<td width="" align="center">가격</td>
			<td width="" align="center">구매수량</td>
			<td width="" align="center">구매금액</td>
		</tr>
		<%for(int i = 0; i < buyLists.size(); i++) 
		{
			buyList = buyLists.get(i);	// 데이터를 한 건 추출한다.
			// 소계를 구하기 위해서 현재 데이터의 바로 다음 데이터의 buy_id를 구한다.
			// 다음 buy_id를 구하는데, 현재의 buy_id가 마지막 데이터라면
			// 다음 데이터가 존재하지 않으므로 -1일때 까지만 구한다.
			if(i <  buyLists.size() -1) {
				//BuyDTO	compare	= buyLists.get(i + 1);
				//compareID		= compare.getBuy_id();
				nextBuy_id	= buyLists.get(i+1).getBuy_id();
			}
		%>
		<tr>
			<td align="center"><%=buyList.getBuy_id()%></td>
			<td>
				<img src="<%=realFolder %>/<%=buyList.getBook_image() %>" width="28" height="40" valign="middle"/>
				&nbsp;<%=buyList.getBook_title()%>
			</td>
			<td align="center">
				<%if(buyList.getSanction().equals("상품준비중")) { %>
					<span class="glyphicon glyphicon-gift gi-2x"></span>
				<%} else if(buyList.getSanction().equals("배송중")) { %>
					<span class="glyphicon glyphicon-send gi-2x"></span>
				<%} else if(buyList.getSanction().equals("배송완료")) { %>
					<span class="glyphicon glyphicon-home gi-2x"></span>
				<%} %>
				<%=buyList.getSanction() %>
			</td>
			<td align="right">
				<%=NumberFormat.getInstance().format(buyList.getBuy_price()) %>&nbsp;원
			</td>
			<td align="right">
				<%=NumberFormat.getInstance().format(buyList.getBuy_count()) %>&nbsp;권
			</td>
			<td align="right">
				<%=NumberFormat.getInstance().format(buyList.getBuy_price() * buyList.getBuy_count()) %>&nbsp;원
				<% sum += buyList.getBuy_price() * buyList.getBuy_count(); %>
			</td>
		</tr>
		
		<% 	// 데이터 한 건의 출력을 완료하면 현재 buy_id와 다음 buy_id값을 비교한다.
			// 현재 buy_id와 다음 buy_id값이 다르거나, 현재 buy_id가 마지막 데이터라면 소계를 출력한다.
		if(buyList.getBuy_id() != nextBuy_id || i == buyLists.size() - 1) {%>
		<tr class="danger">
			<td colspan="6" align="right">
				<b>소 계 : <%=NumberFormat.getInstance().format(sum) %> 원</b>
				<% total += sum; sum = 0; nextBuy_id = buyList.getBuy_id(); %>
			</td>
		</tr>
		<%} // End - if
		} // End - for %>
		
		<tr class="primary">
			<td  colspan="6" align="right">
				<h3>총 구매금액 : <%=NumberFormat.getInstance().format(total) %> 원</h3>
			</td>
		</tr>
	</table>
<% } %>

</div>
</body>
</html>





