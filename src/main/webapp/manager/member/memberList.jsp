<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.MemberDTO" %>
<%@ page import="bookshop.shopping.MemberDAO" %>
<%@ page import="java.util.List" %>
<%
String	managerID	= (String)session.getAttribute("managerID");

//세션 아이디에 값이 없으면 로그인 화면으로 돌려보낸다.
if(managerID == null || managerID.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp?useSSL=false");
}

request.setCharacterEncoding("UTF-8");

// mode 	=> 검색 조건
// modeVal 	=> 검색 조건을 선택하고 입력한 값
// mode : 이름(1), 가입일자(2), 주소(3)
String	mode	= "0";
String	modeVal	= "0";
mode			= request.getParameter("mode");
modeVal			= request.getParameter("modeVal");

// pageSize : 화면에 표시할 회원목록의 개수를 설정한다.
int	pageSize	= 3;

// pageNum : memberList.jsp로 넘어오는 pageNum의 값을 받는 변수. 값이 없으면 1로 설정한다.
String	pageNum	= request.getParameter("pageNum");
if(pageNum == null) {
	pageNum = "1";
}

// Integer.parseInt(pageNum)은 pageNum의 값이 String 타입이기 때문에 정수타입으로 변환시키기 위해서
// Integer 객체의 parseInt()메서드를 사용한다. 왜냐하면 웹에서 넘어오는 모든 데이터는 자동으로 문자열로
// 처리되기 때문에 다른 타입으로 사용하려면 처리를 해주어야 한다.
int	currentPage	= Integer.parseInt(pageNum);

// startRow : 현재 페이지의 회원목록에서 표시할 시작번호를 설정.
// startRow는 현재 페이지의 시작 회원 번호를 가지고 있다.
int startRow = (currentPage-1) * pageSize +  1; // 전페이지 마지막 번호 + 1

// endRow : 현재 페이지의 회원목록에서 마지막으로 표시할 번호를 설정.
// endROw는 현재 페이지의 마지막 회원 번호를 가지고 있다.
int endRow	= currentPage * pageSize;

int	totalCount	= 0; // 검색조건에 따른 데이터의 총 건수
int	number		= 0; // 데이터 건수에 따른 row 번호

List<MemberDTO>	memberList	= null;
MemberDAO		memberDAO	= MemberDAO.getInstance();
// 조건(이름, 가입일자, 주소)에 따라 보여줄 데이터의 총 건수를 찾아낸다.
totalCount					= memberDAO.getMemberCount(mode, modeVal);

// 보여줄 데이터가 있으면 조건에 맞는 데이터만 찾아오는데 현재 페이지에 보여줄 만큼만 가져온다.
if(totalCount > 0) {
	memberList = memberDAO.getMembers(mode, modeVal, startRow, pageSize);
}

// 화면 좌측에 보이는 일련번호 : 전체 레코드 건수로 부터 순서를 정한다.
// number : 현재 화면에서 보이는 일련번호의 첫 숫자를 의미한다.
number = totalCount - (currentPage-1) * pageSize;
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객 명단</title>
	<%@ include file="../../module/topInclude.jsp" %>
</head>
<body>
<div class="container-fluid">

	<h4 align="center"><b>회원목록(회원수 : <%=totalCount %>)</b></h4>
	<h3 align="center"><span class="label label-danger">&nbsp;&nbsp;고&nbsp;&nbsp;객&nbsp;&nbsp;명&nbsp;&nbsp;단&nbsp;&nbsp;</span></h3>
	
	<form class="form-horizontal" role="form" method="post" name="memberListForm" action="memberList.jsp">
		<div class="form-group">
			<div class="col-sm-1">
				<h4 align="right"><span class="label label-primary">검색조건</span></h4>
			</div>
			<div class="col-sm-1">
				<select class="form-control" name="mode">
					<option value="0">전체</option>
					<option value="1">이름</option>
					<option value="2">등록일</option>
					<option value="3">주소</option>
				</select>
			</div>
			<div class="col-sm-2">
				<input type="text" class="form-control" id="modeVal" name="modeVal" placeholder="Enter Value"/>
			</div>
			<div class="col-sm-2">
				<input class="btn btn-danger btn-sm" type="submit" value="검색하기"/>
				<input class="btn btn-info   btn-sm" type="button" value="메인으로"
					onclick="javascript:window.location='../managerMain.jsp'"/>
			</div>
		</div>
		
		<table class="table table-bordered table-hover">
			<thead>
				<tr class="info" height="30">
					<td align="center" width= "20">번호</td>
					<td align="center" width= "50">아이디</td>
					<td align="center" width= "50">이  름</td>
					<td align="center" width= "50">비밀번호</td>
					<td align="center" width= "50">등록일</td>
					<td align="center" width= "50">전화번호</td>
					<td align="center" width="200">주    소</td>
				</tr>
			</thead>
			<tbody>
			<%for(int i = 0; i < memberList.size(); i++) 
			{
				MemberDTO member = memberList.get(i); %>
				<tr>
					<td align="center"><%=number-- %></td>	
					<td><a href="#" onclick="return openUser('<%=member.getId()%>');"><%=member.getId() %></a></td>
					<td><%=member.getName() %></td>
					<td><%=member.getPasswd() %></td>
					<td><%=member.getReg_date() %></td>
					<td><%=member.getTel() %></td>
					<td><%=member.getAddress() %></td>
				</tr>
			<%} %>
			</tbody>
		</table>
	</form>
	
	<!-- 화면 하단에 보여줄 페이지 번호 -->
	<h6 align="center">
	<% // 데이터가 한 건이라도 있으면 페이지 번호를 보여준다.
	if(totalCount > 0) {
		// pageCount : 보여져야할 페이지 수
		// 한 화면에 보이는 개수로 나누어 나머지가 있으면 한 페이지를 더 보여야 한다.
		int pageCount 	= totalCount / pageSize + (totalCount % pageSize == 0 ? 0 : 1);
		
		int pageBlock	= 3; // 화면 하단에 보여줄 페이지의 개수 [1][2][3] [4][5][6]
			
		// 선택한 페이지번호가 pageBlock내에 있으면 startPage를 하단에 보여줄 번호의 맨 앞번호로 한다. 
		// currentPage(5), pageBlock(3) 이라면 하단에는 [4][5][6]을 ;보여준다.
		int startPage	= (int)((currentPage-1)/pageBlock)*pageBlock+1;
		int	endPage		= startPage + pageBlock -1;
		
		// 계산한 endPage가 실제 가지고 있는 페이지의 수보다 많으면 가장 마지막 페이지의 값을 endPage로 한다.
		if(endPage > pageCount)	endPage = pageCount;
		
		// 시작페이지가 페이지 블럭보다 큰 경우에는 [이전]버튼을 보여준다.
		if(startPage > pageBlock) { %>
			<a href="memberList.jsp?pageNum=<%=startPage-pageBlock%>&mode=<%=mode%>&modeVal=<%=modeVal%>">[이전]</a>
		<%}
		
		// 화면 하단에 페이지 번호를 보여준;다.
		for(int num = startPage; num <= endPage; num++) { %>
			<a href="memberList.jsp?pageNum=<%=num%>&mode=<%=mode%>&modeVal=<%=modeVal%>">[<%=num%>]</a>
		<%}
		
		// 총페이지 건 수가 endPage보다 크면 [다음]버튼을 보여준다.
		if(endPage < pageCount) { %>
		<a href="memberList.jsp?pageNum=<%=startPage+pageBlock%>&mode=<%=mode%>&modeVal=<%=modeVal%>">[이전]</a>
	<%}
		
	}
	%>	
	</h6>
	
</div>

<script>
function openUser(userId) {
	window.open('memberUpDelForm.jsp?userId='+ userId, '',
			'left=400, top= 100, width=860, height=660, scrollbars=no, status=o, resizable=no, fullscreen=no, channelmode=no');
}
</script>

</body>
</html>


















