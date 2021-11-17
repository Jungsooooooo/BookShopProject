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
	<title>월별 판매  리스트(막대 그래프)</title>
	<%@ include file="../../module/topInclude.jsp" %>
	<link href="../../css/morris.css" rel="stylesheet"/>
	<script src="../../js/morris.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
</head>
<body>

<div class="container">

	<h4 align="center"><b>월별 판매 목록</b></h4>
	<form class="form-horizontal"  role="form" method="post" name="monthBarStatsForm" action="monthBarStatsForm.jsp">
		<div class="form-group">
			<div class="col-sm-1">
				<h4><span class="label label-info">검색년도</span></h4>
			</div>
			<div class="col-sm-2">
				<input type="text" class="form-control" id="year" name="year" placeholder="Enter Year"/>
			</div>
			<input class="btn btn-danger btn-sm" type="submit" value="검색하기"/>
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
new Morris.Bar({
	element:	'MonthChart',
	data:	[
		{ x:  '1월',		y:	<%=buyMonthList.getMonth01()%>	},
		{ x:  '2월',		y:	<%=buyMonthList.getMonth02()%>	},
		{ x:  '3월',		y:	<%=buyMonthList.getMonth03()%>	},
		{ x:  '4월',		y:	<%=buyMonthList.getMonth04()%>	},
		{ x:  '5월',		y:	<%=buyMonthList.getMonth05()%>	},
		{ x:  '6월',		y:	<%=buyMonthList.getMonth06()%>	},
		{ x:  '7월',		y:	<%=buyMonthList.getMonth07()%>	},
		{ x:  '8월',		y:	<%=buyMonthList.getMonth08()%>	},
		{ x:  '9월',		y:	<%=buyMonthList.getMonth09()%>	},
		{ x: '10월',		y:	<%=buyMonthList.getMonth10()%>	},
		{ x: '11월',		y:	<%=buyMonthList.getMonth11()%>	},
		{ x: '12월',		y:	<%=buyMonthList.getMonth12()%>	}
	],
	xkey:	'x',
	ykeys:	['y'],
	labels:	['권수'],
	barColors:	function (row, series, type) {
		if(type == 'bar') {
			var	red		= Math.floor(Math.random()*256);
			var	green	= Math.floor(Math.random()*256);
			var	blue	= Math.floor(Math.random()*256);
			return	'rgb(' + red + ',' + green + ',' + blue + ')';
		} else {
			return '#000';
		}
	} 
});
</script>

</body>
</html>















