<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>관리자 로그인 화면</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- 합쳐지고 최소화된 최신 CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
	
	<!-- 부가적인 테마 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
	<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

	<style>
	.modal-header, h4, .close {
		background-color:	#5CB85C;	/* 초록색	*/
		color:				white !important;
		text-align:			center;
		font-size:			30px;
	}
	.modal - footer {
		background-color:	#F9F9F9;	/* 연한회색	*/
	}
	</style>
</head>
<body>
<div class="container">

	<h2>Manager Login</h2>
	<button type="button" class="btn btn-warning btn-lg" id="myBtn">Login</button>

	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header" style="padding: 25px 50px;">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4><span class="glyphicon glyphicon-lock"></span> Manager Login</h4>
				</div>
				
				<div class="modal-body" style="padding: 40px 50px;">
					<form class="form-horizontal" role="form" method="post" action="managerLoginPro.jsp">
						<div class="form-group">
							<label for="username"><span class="glyphicon glyphicon-user"></span> Manager ID</label>
							<input type="text" class="form-control" id="id" name="id" maxlength="12" placeholder="Enter Manager ID"/>
						</div>
						<div class="form-group">
							<label for="pwd"><span class="glyphicon glyphicon-eye-open"></span> Password</label>
							<input type="password" class="form-control" id="pwd" name="passwd" maxlength="12" placeholder="Enter Password"/>
						</div>
						<button type="submit" class="btn btn-success btn-block">
							<span class="glyphicon glyphicon-off"> Login</span>
						</button>
					</form>
				</div>
				
				<div class="modal-footer">
					<button type="submit" class="btn btn-danger pull-flef" data-dismiss="modal">
						<span class="glyphicon glyphicon-remove"></span> Cancel
					</button>
				</div>
			</div>
		</div>
	
	</div>
	
</div>

<script>
$(document).ready(function() { // 이 페이지가 로딩이 되면 
	$("#myBtn").click(function() { // Login 버튼을 눌렀을 경우
		$("#myModal").modal();		// 모달창이 나타나게 된다.
	});
});

$(function() {
	$("#myModal").modal({
		keyboard:	true
	});
});
</script>

</body>
</html>












