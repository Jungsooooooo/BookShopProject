
<script>
//---------------------------------------------------------------------
//각종 검사
//---------------------------------------------------------------------
function isNumberCheck ( inputVal ) 
{
	var var_normalize = /[^0-9]/gi; //정규식
	if (var_normalize.test(inputVal) == true) return false;
	else return true;
}

//최상위 체크 로직(chars로 넘긴 값이 있다면 false)
function containsChars(input, chars) 
{
	for (var inx = 0; inx < input.length; inx++) {
		if (chars.indexOf(input.charAt(inx)) != -1)
			return true;
	}
	return false;
}
//최상위 체크 로직(chars로 넘긴 값이 있다면 true)
function containsCharsOnly(input, chars) 
{
	for (var inx = 0; inx < input.length; inx++) {
		if (chars.indexOf(input.charAt(inx)) == -1)
			return false;
	}
	return true;
}
//숫자 체크
function isNum(input) 
{
	var chars = "0123456789";
	return containsCharsOnly(input, chars);
}

//영숫자 판별
function isAlphaNumCheck(input) 
{ 
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	return containsCharsOnly(input, chars);
}

//이름체크
function isNameCheck(input) 
{
	var chars = "0123456789~!@#$%^&*()_-+=|{}[]<>,./?";
	return containsCharsOnly(input, chars);
}

//---------------------------------------------------------------------
//회원 정보 수정/탈퇴
//---------------------------------------------------------------------
function memberUpDelCheckForm(memberUpDelForm, selectVal)
{
	if(!memberUpDelForm.passwd.value) {
		alert("비밀번호를 입력하십시오.");
		memberUpDelForm.passwd.focus();
		return false;
	}
	if(isAlphaNumCheck(memberUpDelForm.passwd.value) == false) {
		alert("비밀번호는 숫자와 영문자만 가능합니다.");
		memberUpDelForm.passwd.focus();
		return false;
	}
	if( (memberUpDelForm.passwd.value.length < 4) || (memberUpDelForm.passwd.value.length > 10)) {
		alert("비밀번호는 4자리에서 10자리를 입력하셔야 합니다.");
		memberUpDelForm.passwd.focus();
		return false;
	}
	
	if(!memberUpDelForm.repasswd.value) {
		alert("비밀번호확인을 입력하십시오.");
		memberUpDelForm.repasswd.focus();
		return false;
	}
	if(isAlphaNumCheck(memberUpDelForm.repasswd.value) == false) {
		alert("비밀번호확인은 숫자와 영문자만 가능합니다.");
		memberUpDelForm.repasswd.focus();
		return false;
	}
	if( (memberUpDelForm.repasswd.value.length < 4) || (memberUpDelForm.repasswd.value.length > 10)) {
		alert("비밀번호확인은 4자리에서 10자리를 입력하셔야 합니다.");
		memberUpDelForm.repasswd.focus();
		return false;
	}
	
	if( (memberUpDelForm.passwd.value) != (memberUpDelForm.repasswd.value) ) {
		alert("비밀번호와 비밀번호확인이 틀립니다.");
		memberUpDelForm.passwd.focus();
		return false;
	}
	
	//수정일 경우만 필드를 검사한다.
	if(selectVal == "UP")
	{
		if(!memberUpDelForm.name.value) {
			alert("이름을 입력하십시오.");
			memberUpDelForm.name.focus();
			return false;
		}
		if(isNameCheck(memberUpDelForm.passwd.value) == false) {
			alert("이름에는 숫자나 특수문자를 입력할 수 없습니다.");
			document.memberUpDelForm.name.focus();
			return false;
		}
		if(!memberUpDelForm.address.value) {
			alert("주소를 입력하십시오.");
			memberUpDelForm.address.focus();
			return false;
		}

		if(!memberUpDelForm.tel1.value) {
			alert("전화번호를 입력하십시오.");
			memberUpDelForm.tel1.focus();
			return false;
		}
		if(!memberUpDelForm.tel2.value) {
			alert("전화번호 2번째 자리를 입력하십시오.");
			memberUpDelForm.tel2.focus();
			return false;
		}
		if(isNumberCheck(memberUpDelForm.tel2.value) == false) {
			alert("전화번호는 숫자만 입력 가능합니다.");
			memberUpDelForm.tel2.focus();
			return false;
		}
		if(memberUpDelForm.tel2.value.length < 3) {
			alert("전화번호 2번째 자리는 최소 3자를 입력하셔야 합니다.");
			memberUpDelForm.tel2.focus();
			return false;
		}
		
		if(!memberUpDelForm.tel3.value) {
			alert("전화번호 3번째 자리를 입력하십시오.");
			memberUpDelForm.tel3.focus();
			return false;
		}
		if(isNumberCheck(memberUpDelForm.tel3.value) == false) {
			alert("전화번호는 숫자만 입력 가능합니다.");
			memberUpDelForm.tel3.focus();
			return false;
		}
		if(memberUpDelForm.tel3.value.length < 4) {
			alert("전화번호 3번째 자리는 4자를 입력하셔야 합니다.");
			memberUpDelForm.tel3.focus();
			return false;
		}
	}

	memberUpDelForm.action = "memberUpDelModalForm.jsp?mode=" + selectVal;
	memberUpDelForm.submit();
}


</script>

