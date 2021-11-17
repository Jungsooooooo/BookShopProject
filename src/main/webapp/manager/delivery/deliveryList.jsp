<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.DeliveryDTO" %>
<%@ page import="bookshop.shopping.BuyDTO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%
String	managerId	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

List<BuyDTO>	buyLists		= null;
BuyDTO			buyList			= null;
DeliveryDTO		deliveryList	= null;
int				count			= 0;

// 화면에 보여줄 데이터 건수를 알아낸다.
BuyDAO	buyDAO	= BuyDAO.getInstance();
count			= buyDAO.getListCount();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배송 목록</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container-fluid">

<%if(count <= 0) { // 자료가 한 건도 없다면 %>
	<h3><b>배송 목록</b></h3>
	<table>
		<tr>
			<td><h4>배송자료가 없습니다.</h4></td>
		</tr>
		<tr>
			<td><a href="../managerMain.jsp">관리자 메인화면으로</a></td>
		</tr>
	</table>

<%} else { // 화면에 보여줄 자료가 존재한다면 
	// 데이터를 추출해서 가져온다. 
	buyLists = buyDAO.getBuyList(); %>
	<h3 align="center"><b>배송 목록</b></h3>
	<a href="../managerMain.jsp">관리자 메뉴로</a>
	
	<form class="form-horizontal" method="post" name="deliveryList" action="deliveryList.jsp">
		<table class="table table-bordered table-striped table-hover">
			<tr class="info">
				<td align="center">주문번호</td>
				<td align="center">주문번호</td>
				<td align="center">배송상황</td>
				<td align="center">주문자</td>
				<td align="center">책이름</td>
				<td align="center">주문가격</td>
				<td align="center">주문수량</td>
				<td align="center">주문일자</td>
				<td align="center">결제계좌</td>
				<td align="center">배송명</td>
				<td align="center">배송지전화</td>
				<td align="center">배송지주소</td>
			</tr>
			<%for(int i = 0; i < buyLists.size(); i++) 
			{ 
				buyList = (BuyDTO)buyLists.get(i); %>
			<tr>
				<td align="center">
					<a href="#" onclick="return openNo('<%= buyList.getBuy_id()%>', '<%=buyList.getSanction()%>');"><%= buyList.getBuy_id()%></a>
				</td>
				<td align="center">
					<a href='deliveryUpModalForm.jsp?buyId=<%= buyList.getBuy_id()%>&sanction=<%=URLEncoder.encode(buyList.getSanction(), "UTF-8") %>' ><%=buyList.getBuy_id()%></a>
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
				<td align="center">	<%=buyList.getBuyer() %></td>
				<td>				<%=buyList.getBook_title() %></td>
				<td align="right">	<%=buyList.getBuy_price() %> 원</td>
				<td align="right">	<%=buyList.getBuy_count() %> 권</td>
				<td>				<%=buyList.getBuy_date().toString() %></td>
				<td>				<%=buyList.getAccount() %></td>
				<td>				<%=buyList.getDeliveryName() %></td>
				<td>				<%=buyList.getDeliveryTel() %></td>
				<td>				<%=buyList.getDeliveryAddress() %></td>
			</tr>
			<%} %>
		</table>
	</form>
<%} %>
</div>

</body>

<script>
function openNo(buyId, sanction) 
{
	var uri = "deliveryUpModalForm.jsp?buyId=" +  buyId + "&sanction=" + sanction;
	// alert(uri);
	
	window.open(encodeURI(uri), '',
	'left=400, top=100, width=900, height=600, scrollbars=no, status=no, resizable=no, fullscreen=no, channelmode=no');
}
</script>

</html>












