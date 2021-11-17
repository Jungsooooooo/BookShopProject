<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<%@ include file="../../module/topInclude.jsp" %>
	<jsp:include page="../../module/topInclude.jsp"/>
</head>
<body>

<jsp:include page="../../module/shopMenu.jsp"/>

<div class="container">
	<form class="form-horizontal" method="post" name="memInsForm" action="memberInsertPro.jsp">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">회원가입</h2>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">아이디</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="id" name="id" maxlength="12" placeholder="Enter ID"/>
			</div>
			<div class="col-sm-2">
				<input type="button" class="btn btn-danger btn-sm" name="confirmID" value="ID중복확인"
					OnClick="idConfirm();"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호</label>
			<div class="col-sm-3">
				<input type="password" class="form-control" id="passwd" name="passwd" maxlength="12" placeholder="Enter Password"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">비밀번호확인</label>
			<div class="col-sm-3">
				<input type="password" class="form-control" id="repasswd" name="repasswd" maxlength="12" placeholder="Enter Password"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">이  름</label>
			<div class="col-sm-3">
				<input type="text" class="form-control" id="name" name="name" maxlength="10" placeholder="Enter Name"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">주  소</label>
			<div class="col-sm-7">
				<input type="text" class="form-control" id="address" name="address" maxlength="100" placeholder="Enter Address"/>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">휴대폰</label>
			<div class="col-sm-2">
				<select class="form-control" name="tel1">
					<option value="010">010</option>
					<option value="011">011</option>
					<option value="017">017</option>
					<option value="018">018</option>
					<option value="019">019</option>
				</select>
			</div>
			<div class="input-group col-sm-3">
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel2" maxlength="4" placeholder="Tel"/></div>
				<div class="input-group-addon">-</div>
				<div><input type="text" class="form-control col-sm-1" name="tel3" maxlength="4" placeholder="Tel"/></div>
			</div>
		</div>
		
		<div class="form-group">
			<label class="control-label col-sm-2">회원가입동의</label>
			<div class="col-sm-10">
				<label class="radio-inline">
					<input type="radio" id="registerYn" name="registerYn" value="Y" checked> 동의합니다.
				</label>
				<label class="radio-inline">
					<input type="radio" id="registerYn" name="registerYn" value="N"> 동의하지 않습니다.
				</label>
			</div>
		</div>
		
		<div class="alert alert-info fade in col-sm-offset-2 col-sm-10">
			<strong>[ BookShop의 개인 정보 수집 및 이용 안내]</strong>
			<p><h5>
			개인 정보 제3자 제공 동의
			<br>① 개인정보를 제공받는 자: BookShop
			<br>② 개인정보를 제공받는 자의 개인 정보 이용 목적 : 영업관리, 
			설문조사 및 프로모션, 이벤트 경품 제공, eDM 발송, 행사 관련 마케팅
			<br>③ 제공하는 개인정보항목 : 이름, 이메일주소, 회사명, 직무/직책, 연락처, 휴대전화
			<br>④ 개인정보를 제공받는 자의 개인 정보 보유 및 이용 기간 :
			개인정보 취급 목적을 달성하여 더 이상 개인정보가 불 필요하게 된 경우이거나
			5년이 지나면 지체 없이 해당 정보를 파기할 것입니다.
			<br>귀하는 위와 같은 BookShop의 개인정보 수집 및 이용정책에 동의하지 
			않을 수 있으나, BookShop으로부터 솔루션, 최신 IT정보, 행사초청안내 등의 
			유용한 정보를 제공받지 못 할 수 있습니다.
			<br> 개인 정보 보호에 대한 자세한 내용은 http://www.BookShop.com 을 참조바랍니다.
			</h5></p>
			<div class="checkbox">
				<label>
					<input type="checkbox" id="is_subscribed" name="is_subscribed" value="o"/>
				</label> BookShop의 개인정보 수집 및 이용에 동의합니다.
			</div>
		</div>
		
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-10">
				<button type="button" class="btn btn-primary" onclick="memberInsertCheckForm(this.form)">회원가입</button>
			</div>
		</div>
		
	</form>
</div>


<script>
//-------------------------------------------------------------------------------------------------
// 각종 검사
//-------------------------------------------------------------------------------------------------
function isNumberCheck(inputVal) {
	var_normalize = /[^0-9]/gi;		// 정규식
	if(var_normalize.test(inputVal) == true) return false;
	else return true;
}

//-------------------------------------------------------------------------------------------------
// 검사 로직
// 최상위 체크 로직(chars로 넘긴 값이 있다면 false)
//-------------------------------------------------------------------------------------------------
function containsChars(input, chars) {
	for(var inx = 0; inx < input.length; inx++) {
		if(chars.indexOf(input.charAt(inx)) != -1)
			return true;
	}
	return false;
}

//-------------------------------------------------------------------------------------------------
//input의 문자들이 모두 chars에 포함되어야 true발생한다.
//input의 한글자라도 chars에 포함되면 false가 발생한다.
//-------------------------------------------------------------------------------------------------
function containsCharsOnly(input, chars) {
	for(var inx = 0; inx < input.length; inx++) {
		if(chars.indexOf(input.charAt(inx)) == -1)
			return false;
	}
	return true;
}

//-------------------------------------------------------------------------------------------------
// 영문자와 숫자 판별
//-------------------------------------------------------------------------------------------------
function isAlphaNumCheck(input) {
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	return containsCharsOnly(input, chars);
}

//-------------------------------------------------------------------------------------------------
// 이름 검사
//-------------------------------------------------------------------------------------------------
function isNameCheck(input) {
	var chars = "0123456789`~!@#$%^&*()_-=+|\{}[];:<>,./?\'\"";
	return containsChars(input, chars);
}

//-------------------------------------------------------------------------------------------------
// 회원 아이디 검사
//-------------------------------------------------------------------------------------------------
function idConfirm() {
	if(document.memInsForm.id.value == "") {
		alert("아이디를 입력하십시오.");
		document.memInsForm.id.focus();
		return;
	}
	if(isAlphaNumCheck(memInsForm.id.value) == false) {
		alert("고객 아이디는 숫자와 영문자만 입력 가능합니다.");
		document.memInsForm.id.focus();
		return;
	}
	if( (memInsForm.id.value.length < 4) || (memInsForm.id.value.length > 12)) {
		alert("고객 아이디는 4자리에서 12자리를 입력하셔야 합니다.");
		document.memInsForm.id.focus();
		return;
	}
	url = "confirmId.jsp?id=" + document.memInsForm.id.value;
	
	window.open(url, "아이디 중복 확인", "toolbar=no, location=no, status=no, menubar=no, scrollbar=no, \
											resizable=no, width=500, height=200, left=500, top=100");
}

//-------------------------------------------------------------------------------------------------
// 회원 등록 전 항목 검사
//-------------------------------------------------------------------------------------------------
function memberInsertCheckForm(memInsForm) {
	if(!memInsForm.id.value) {
		alert("고객 아이디를 입력하십시오.");
		document.memInsForm.id.focus();
		return;
	}
	if(isAlphaNumCheck(memInsForm.id.value) == false) {
		alert("고객 아이디는 숫자와 영문자만 입력 가능합니다.");
		document.memInsForm.id.focus();
		return;
	}
	if( (memInsForm.id.value.length < 4) || (memInsForm.id.value.length > 12)) {
		alert("고객 아이디는 4자리에서 12자리를 입력하셔야 합니다.");
		document.memInsForm.id.focus();
		return;
	}
	
	if(!memInsForm.passwd.value) {
		alert("비밀번호를 입력하십시오.");
		document.memInsForm.passwd.focus();
		return;
	}
	if(isAlphaNumCheck(memInsForm.passwd.value) == false) {
		alert("비밀번호는 숫자와 영문자만 입력 가능합니다.");
		document.memInsForm.passwd.focus();
		return;
	}
	if( (memInsForm.passwd.value.length < 4) || (memInsForm.passwd.value.length > 12)) {
		alert("비밀번호는 4자리에서 12자리를 입력하셔야 합니다.");
		document.memInsForm.passwd.focus();
		return;
	}
	
	if(!memInsForm.repasswd.value) {
		alert("비밀번호확인을 입력하십시오.");
		document.memInsForm.repasswd.focus();
		return;
	}
	if(isAlphaNumCheck(memInsForm.repasswd.value) == false) {
		alert("비밀번호확인은 숫자와 영문자만 입력 가능합니다.");
		document.memInsForm.repasswd.focus();
		return;
	}
	if( (memInsForm.repasswd.value.length < 4) || (memInsForm.repasswd.value.length > 12)) {
		alert("비밀번호확인은 4자리에서 12자리를 입력하셔야 합니다.");
		document.memInsForm.repasswd.focus();
		return;
	}
	if( (memInsForm.passwd.value) != (memInsForm.repasswd.value)) {
	//if(!memInsForm.passwd.value.equals(memInsForm.repasswd.value)) {
		alert("비밀번호와 비밀번호확인이 틀립니다.");
		memInsForm.passwd.focus();
		return;
	}
		
	if(!memInsForm.name.value) {
		alert("이름을 입력하십시오.");
		document.memInsForm.name.focus();
		return;
	}
	if(isNameCheck(memInsForm.name.value) == true) {
		alert("이름에는 숫자나 특수문자를 입력할 수 없습니다.");
		document.memInsForm.name.focus();
		return;
	}
	
	if(!memInsForm.address.value) {
		alert("주소를 입력하십시오.");
		document.memInsForm.address.focus();
		return;
	}
	
	if(!memInsForm.tel1.value) {
		alert("전화번호를 입력하십시오.");
		document.memInsForm.tel1.focus();
		return;
	}
	
	if(!memInsForm.tel2.value) {
		alert("전화번호를 입력하십시오.");
		document.memInsForm.tel2.focus();
		return;
	}
	if(!isNumberCheck(memInsForm.tel2.value)) {
		alert("전화번호는 숫자만 입력이 가능합니다.");
		document.memInsForm.tel2.focus();
		return;
	}
	if( (memInsForm.tel2.value.length < 3) || (memInsForm.tel2.value.length > 4)) {
		alert("전화번호는 최소 3자를 입력하셔야 합니다.");
		document.memInsForm.tel2.focus();
		return;
	}

	if(!memInsForm.tel3.value) {
		alert("전화번호를 입력하십시오.");
		document.memInsForm.tel3.focus();
		return;
	}
	if(!isNumberCheck(memInsForm.tel3.value)) {
		alert("전화번호는 숫자만 입력이 가능합니다.");
		document.memInsForm.tel3.focus();
		return;
	}
	if(memInsForm.tel3.value.length < 4) {
		alert("전화번호는 4자를 입력하셔야 합니다.");
		document.memInsForm.tel3.focus();
		return;
	}

	if(memInsForm.registerYn[0].checked == false) {
		alert("회원가입을 하시려면 회원가입에 동의해주셔야 합니다.");
		memInsForm.registerYn.focus();
		return;
	}
	
	if(memInsForm.is_subscribed.checked == false) {
		alert("개인정보 수집 및 이용에 동의해주셔야 회원가입을 하실 수 있습니다.");
		memInsForm.is_subscribed.focus();
		return;
	}
	
	// 회원가입시 검사항목을 모두 통과하였으므로 회원등록 데이터를 등록하도록 한다.
	document.memInsForm.submit();

	
	
}
</script>

</body>
</html>








