<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.BuyMonthDTO" %>
<%@ page import="bookshop.shopping.BuyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>

<%
request.setCharacterEncoding("utf-8");

String	managerId	= (String)session.getAttribute("managerID");

// 세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp");
}

// 보고자 하는 년도
String year = request.getParameter("year");

BuyMonthDTO	buyMonthList	= null;
BuyDAO		buyDAO			= BuyDAO.getInstance();
// 년도에 해당하는 데이터를 가져온다.
buyMonthList				= buyDAO.buyMonth(year);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>월별 판매 목록(꺽은선 그래프)</title>
	<%@ include file="../../module/topInclude.jsp" %>
	<link href="../../css/morris.css" rel="stylesheet"/>
	<script src="../../js/morris.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
</head>
<body>

<div class="container">
	<h4 align="center"><b>월별 판매 목록</b></h4>
	<form class="form-horizontal"  role="form" method="post" name="monthStatsForm" action="monthStatsForm.jsp">
		<div class="form-group">
			<div class="col-sm-1">
				<h4><span class="label label-info">검색년도</span></h4>
			</div>
			<div class="col-sm-2">
				<input type="text" class="form-control" id="year" name="year" placeholder="Enter Year"/>
			</div>
			<input class="btn btn-danger btn-sm" type="submit" value="검색하기"/>
			
			<input class="btn btn-danger btn-sm" type="button" id="btnGo" value="검색하기"
				onclick="selectYear();"/>
			<input class="btn btn-danger btn-sm" type="submit" value="검색하기"
				onclick="javascript:window.location='monthStatsForm.jsp"/>
			<input class="btn btn-info btn-sm" type="button" value="메인으로"
				onclick="javascript:window.location='../managerMain.jsp'"/>
		</div>
		
		<table class="table table-bordered" width="700" cellpadding="0" cellspacing="0" align="center">
			<thead>
				<tr class="info" height="30">
					<td align="center">1월</td>
					<td align="center">2월</td>
					<td align="center">3월</td>
					<td align="center">4월</td>
					<td align="center">5월</td>
					<td align="center">6월</td>
					<td align="center">7월</td>
					<td align="center">8월</td>
					<td align="center">9월</td>
					<td align="center">10월</td>
					<td align="center">11월</td>
					<td align="center">12월</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="right"><%=buyMonthList.getMonth01() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth02() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth03() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth04() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth05() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth06() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth07() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth08() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth09() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth10() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth11() %> 권</td>
					<td align="right"><%=buyMonthList.getMonth12() %> 권</td>
				</tr>
				<tr class="danger">
					<td align="right" colspan="12">
						<h4><p class="bg-danger">총 판매 수량 : <%=buyMonthList.getTotal() %> 권</p></h4>
					</td>
				</tr>
			</tbody>
		</table>
	</form>

	<div id="MonthChart" style="height:	400px;"></div>

</div>

<script>
var	m01	= <%=year %> + "-01";
var	m02	= <%=year %> + "-02";
var	m03	= <%=year %> + "-03";
var	m04	= <%=year %> + "-04";
var	m05	= <%=year %> + "-05";
var	m06	= <%=year %> + "-06";
var	m07	= <%=year %> + "-07";
var	m08	= <%=year %> + "-08";
var	m09	= <%=year %> + "-09";
var	m10	= <%=year %> + "-10";
var	m11	= <%=year %> + "-11";
var	m12	= <%=year %> + "-12";

new Morris.Line({
	// 그래프를 표시하기 위한  객체의 ID
	element:	'MonthChart',
	// 그래프의 데이터 : 각 요소가 하나의 그래프 y축에 해당하는 값이 된다.
	data:	[
		{ year:	m01,  value: <%=buyMonthList.getMonth01() %> },
		{ year:	m02,  value: <%=buyMonthList.getMonth02() %> },
		{ year:	m03,  value: <%=buyMonthList.getMonth03() %> },
		{ year:	m04,  value: <%=buyMonthList.getMonth04() %> },
		{ year:	m05,  value: <%=buyMonthList.getMonth05() %> },
		{ year:	m06,  value: <%=buyMonthList.getMonth06() %> },
		{ year:	m07,  value: <%=buyMonthList.getMonth07() %> },
		{ year:	m08,  value: <%=buyMonthList.getMonth08() %> },
		{ year:	m09,  value: <%=buyMonthList.getMonth09() %> },
		{ year:	m10,  value: <%=buyMonthList.getMonth10() %> },
		{ year:	m11,  value: <%=buyMonthList.getMonth11() %> },
		{ year:	m12,  value: <%=buyMonthList.getMonth12() %> }
	],
	// 그래프 데이터의 x축에 해당하는 값의 이름
	xkey:	'year',
	// 그래프 데이터의 y축에 해당하는 값의 이름
	ykeys:	['value'],
	// 각 가밧에 대해서 마우스 오버시 표시하기 위한 레이블
	labels:	['value']
});
</script>




<script>
$(".btnGo").click(function() {
	document.form.action = "monthStatsForm.jsp?year" + <%=year%>;
	document.form.submit();
});
function selectYear() {
	document.btnGo.action="monthStatsForm.jsp?year" + <%=year%>;
	document.btnGo.submit;
	//location.href="monthStatsForm.jsp?year" + <%=year%>;
}
</script>

</body>
</html>








