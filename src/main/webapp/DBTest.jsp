<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>DBTest.jsp</title>
</head>
<body>
	<table border="1" bordercolor="skyblue">
		<tr bgcolor="skyblue">
			<td>아이디</td>
			<td>비밀번호</td>
		</tr>
			<%
			String sql = "SELECT * FROM manager";
			
			// 커넥션 연결
			DBConnection db = new DBConnection();
			Connection conn = db.getConnection();
			
			// DB에 Query문을 보낸다.
			PreparedStatement pstmt = conn.prepareStatement(sql);
			
			// 쿼리문의 결과값을 rs에 담는다.
			ResultSet rs = pstmt.executeQuery();
			
			// 결과값을 출력한다.
			while(rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString("managerId"));
				out.println("<td>" + rs.getString("managerPasswd"));
				out.println("</tr>");
			}
			
			%>
	</table>
</body>
</html>