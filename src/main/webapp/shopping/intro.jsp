<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 메뉴바 하단에 간단한 소개내용을 보여준다. -->
<div class="container">
	<div class="jumbotron">
		<div class="container text-center">
			<h2>도서 쇼핑몰</h2>
		</div>
	</div>
</div>

<!-- 화면 중앙에 움직이는 이미지를 보여준다. -->
<div class="container">
	<div id="myCarousel" class="carousel slide" data-ride="carousel">
		<!-- Indicators -->
		<ol class="carousel-indicators">
			<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
			<li data-target="#myCarousel" data-slide-to="1"></li>
			<li data-target="#myCarousel" data-slide-to="2"></li>
		</ol>
		<!-- Wrapper for slides : 실제로 화면에 보여줄 사진에 대한 설정 -->
		<div class="carousel-inner">
			<div class="item active">
				<!-- class="img-responsive center-block" 반응형 이미지를 가운데 정렬한다. -->
				<img class="img-responsive center-block" src="../images/bookstore05.jpeg"/>
				<!-- 그림에 대한 설명을 달아준다. -->
				<div class="carousel-caption">
					<h3>도서 목록</h3>
					<p>신간 도서</p>
				</div>
			</div>
			<div class="item">
				<img class="img-responsive center-block" src="../images/bookstore06.jpeg"/>
				<div class="carousel-caption">
					<h3>도서 목록</h3>
					<p>신간 도서</p>
				</div>
			</div>
			<div class="item">
				<img class="img-responsive center-block" src="../images/bookstore02.jpeg"/>
				<div class="carousel-caption">
					<h3>도서 목록</h3>
					<p>신간 도서</p>
				</div>
			</div>
		</div>
		
		<!-- 좌측, 우측으로 그림을 움직일 수 있게 좌, 우버튼을 설정한다. -->
		<a class="left carousel-control" href="#myCarousel" data-slide="prev">
			<span class="glyphicon glyphicon-chevron-left"></span>
		</a>
		<a class="right carousel-control" href="#myCarousel" data-slide="next">
			<span class="glyphicon glyphicon-chevron-right"></span>
		</a>
		
	</div>
</div>












