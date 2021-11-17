<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>쇼핑몰 메인화면</title>
	<%@ include file="../module/topInclude.jsp" %>
</head>
<body>

<jsp:include page="../module/shopMenu.jsp"/>

<div class="container-fluid">
	<div class="row">
		<div class="col-sm-offset-2 col-sm-8">
			<jsp:include page="intro.jsp"/>
		</div>
	</div>
</div>

</body>
</html>