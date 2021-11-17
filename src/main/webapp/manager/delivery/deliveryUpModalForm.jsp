<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.DeliveryDTO" %>
<%@ page import="bookshop.shopping.BuyDTO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="java.net.URLDecoder" %>
<%
String	managerId	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

request.setCharacterEncoding("UTF-8");

// 전 페이지에서 넘겨준 값들을 변수에 저장한다.
//String	buyId		= request.getParameter("buyId");
//String	sanction	= request.getParameter("sanction");
String buyId	= URLDecoder.decode(request.getParameter("buyId"), "UTF-8");
String sanction	= URLDecoder.decode(request.getParameter("sanction"), "UTF-8");

System.out.println("deliveryUpModalForm.jsp ==> " + buyId + ":" + sanction);

int	rtnStatus	= 0;	// 배송상태를 저장할 변수
BuyDAO	buyDAO	= BuyDAO.getInstance();
// 배송상태를 관리하는 사람이 오직 한명이라면 굳이 테이블에서 다시 읽어오지 않아도 된다.
rtnStatus		= buyDAO.getDeliveryStatus(buyId);

// 배송상태 : 1(상품 준비중), 2(배송 중), 3(배송 완료)
// 배송상태를 막대형식(progress-bar)으로 표시하기 위해서 필요한 것들을 배열로 만든다.
String[]	deliveryName	= {"상품준비중",	"배송중",	"배송완료"};
String[]	deliveryRatio	= {"40", 			"40", 		"20"};
String[]	deliveryColor	= {"success", 		"primary", 	"danger"};
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배송상태변경</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>

<div class="container">
	<form class="form-horizontal" method="post" name="deliveryUpModalPro" action="deliveryUpModalPro.jsp">
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-6">
				<h2 align="center">배송 상태 수정</h2>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-6" align="center">
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="1" <%if(rtnStatus == 1) {%> checked <%} %>/>배송준비중
				</label>
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="2" <%if(rtnStatus == 2) {%> checked <%} %>/>배송중
				</label>
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="3" <%if(rtnStatus == 3) {%> checked <%} %>/>배송완료
				</label>
				
				<!-- 구매 아이디를 숨겨서 넘겨준다. -->
				<input type="hidden" id="buyId" name="buyId" value="<%=buyId %>"/>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-4" align="center">
				<h3>배송상황</h3>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-12" align="center">
				<div class="progress">
					<%for(int i = 0; i <= rtnStatus-1 ; i++) { %>
					<div class="progress-bar progress-bar-<%=deliveryColor[i]%> progress-bar-striped" style="width:<%=deliveryRatio[i]%>%; height:100px;">
						<%=deliveryName[i] %>
					</div>
					<%} %>
				</div>
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-4" align="center">
				<button type="submit" class="btn btn-primary">수정</button>
				<button type="reset"  class="btn btn-danger" >취소</button>
			</div>
		</div>
		
	</form>
</div>

</body>
</html>










