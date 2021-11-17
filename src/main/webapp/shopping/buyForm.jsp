<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.manager.BookDTO" %>
<%@ page import="bookshop.manager.BookDAO" %>
<%@ page import="bookshop.shopping.MemberDTO" %>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="bookshop.shopping.CartDTO" %>
<%@ page import="bookshop.shopping.CartDAO" %>
<%@ page import="bookshop.shopping.BuyDTO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="bookshop.shopping.BankDTO" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
if(session.getAttribute("userID") == null || session.getAttribute("userID").equals("")) {
	response.sendRedirect("shopMain.jsp");
}

String	book_kind	= request.getParameter("book_id");
String	buyer		= (String)session.getAttribute("userID");

CartDTO			cartList		= null;
List<CartDTO>	cartLists		= null;
List<BankDTO>	accountLists	= null;
MemberDTO		memberDTO		= null;

int	number		= 0;	// 데이터를 출력할 때 일련번호를 보여주기 위해서
int	totalAmount	= 0;	// 총 구매금액을 저장할 변수

// 경로와 폴더이름, 프로젝트명은 대소문자를 구분한다.
String			realFolder	= "";
String			saveFolder	= "/imageFile";
ServletContext	context		= getServletContext();
realFolder					= context.getRealPath(saveFolder);

// 장바구니 정보를 가져온다.
CartDAO		cartDAO		= CartDAO.getInstance();
cartLists				= cartDAO.getCarts(buyer);

// 회원정보를 가져온다.
MemberDAO	memberDAO	= MemberDAO.getInstance();
memberDTO				= memberDAO.getMember(buyer);

// 은행계좌정보를 가져온다.
BuyDAO		buyDAO		= BuyDAO.getInstance();
accountLists			= buyDAO.getAccount();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>구매하기</title>
	<%@ include file="../module/topInclude.jsp" %>
</head>
<body>

<jsp:include page="../module/shopMenu.jsp" />

<div class="container">
	<h3 align="center"><b>구매 목록</b></h3>
	<table class="table table-bordered table-striped table-hover">
		<tr class="info">
			<td width= "50" align="center">번호</td>
			<td width="300" align="center">제    목</td>
			<td width="100" align="center">판매가격</td>
			<td width= "50" align="center">구매수량</td>
			<td width="100" align="center">구매금액</td>
		</tr>
		<% // 추출한 장바구니의 건수만큼 화면에 출력한다.
		for(int i = 0; i < cartLists.size(); i++) {
			// cartLists에서 한건을 추출한 후에 화면에 출력한다.
			cartList = cartLists.get(i); 
		%>
		<tr>
			<td align="right"><%=++number %></td>
			<td>
				<img src="<%=realFolder%>/<%=cartList.getBook_image()%>" width="30" height="40"/>&nbsp;&nbsp;<%=cartList.getBook_title()%>
			</td>
			<td align="right"><%=NumberFormat.getInstance().format(cartList.getBuy_price()) %>&nbsp;원</td>
			<td align="right"><%=NumberFormat.getInstance().format(cartList.getBuy_count()) %>&nbsp;권</td>
			<td align="right">
				<%=NumberFormat.getInstance().format(cartList.getBuy_price() * cartList.getBuy_count()) %>&nbsp;원
				<% totalAmount += cartList.getBuy_price() * cartList.getBuy_count(); %>
			</td>
		</tr>
		<% } // 장바구니에 들어있는 모든 데이터를 출력하는 작업이 끝나면 %>
		<tr class="danger">
			<td colspan="5" align="right">
				<b><font size="+2">총 구매금액 : <%=NumberFormat.getInstance().format(totalAmount) %></font></b>
			</td>
		</tr>
	</table>
	
	<!-- 주문자 정보 -->
	<form class="form-horizontal" method="post" name="buyInput" action="buyPro.jsp">
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-3">
				<h3 align="center">주문자 정보</h3>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">이    름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="name" name="name" value="<%=memberDTO.getName()%>" disabled/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">전화번호</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="tel" name="tel" value="<%=memberDTO.getTel()%>" disabled/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">주    소</label>
			<div class="col-sm-5">
				<input type="text" class="form-control" id="address" name="address" value="<%=memberDTO.getAddress()%>" disabled/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">결재계좌</label>
			<div class="col-sm-4">
				<select class="form-control" id="account" name="account">
					<%for(int i = 0; i < accountLists.size(); i++) {
						// 은행명, 계좌번호, 계좌소유주명을 하나로 합쳐서 항목에 보여준다.
						String	accountList	= accountLists.get(i).getBank()		+ "  "
											+ accountLists.get(i).getAccount()	+ "  "
											+ accountLists.get(i).getName();
					%>
					<option value="<%=accountLists.get(i).getAccount()%>"><%=accountList%></option>
					<% } %>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-3">
				<h3 align="center">배송지 정보</h3>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">이    름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="deliveryName" name="deliveryName" value="<%=memberDTO.getName()%>" />
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">전화번호</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="deliveryTel" name="deliveryTel" value="<%=memberDTO.getTel()%>" />
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-offset-2 col-sm-2">주    소</label>
			<div class="col-sm-5">
				<input type="text" class="form-control" id="deliveryAddress" name="deliveryAddress" value="<%=memberDTO.getAddress()%>" />
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-3" align="center">
				<input class="btn btn-primary btn-sm" type="submit" value="구매확인"/>&nbsp;&nbsp;
				<input class="btn btn-danger  btn-sm" type="button" value="구매취소"
						onclick="javascript:window.location='cartList.jsp?book=all'"/>
			</div>
		</div>
		
	</form>
	
	
	
	
</div>


</body>
</html>









