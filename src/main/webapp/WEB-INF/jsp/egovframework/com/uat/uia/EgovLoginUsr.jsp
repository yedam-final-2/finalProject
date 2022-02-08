<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovLoginUsr.jsp
  * @Description : Login 인증 화면
  * @Modification Information
  * 
  * @수정일               수정자            수정내용
  *  ----------   --------   ---------------------------
  *  2009.03.03   박지욱            최초 생성
  *  2011.09.25   서준식            사용자 관리 패키지가 미포함 되었을때에 회원가입 오류 메시지 표시
  *  2011.10.27   서준식            사용자 입력 탭 순서 변경
  *  2017.07.21   장동한            로그인인증제한 작업
  *  2019.12.11   신용호            KISA 보안약점 조치 (크로스사이트 스크립트)
  *  2020.06.23   신용호            세션만료시간 보여주기
  *
  *  @author 공통서비스 개발팀 박지욱
  *  @since 2009.03.03
  *  @version 1.0
  *  @see
  *
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>

<!DOCTYPE html>
<html>
<head>
<title><spring:message code="comUatUia.title" /></title><!-- 로그인 -->
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/com.css' />">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/uat/uia/login.css' />">
<!-- 부트스트랩 cdn 링크 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css" />
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/showModalDialog.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
<script type="text/javaScript" language="javascript">

function checkLogin(userSe) {
    // 일반회원
    if (userSe == "GNR") {
        document.loginForm.rdoSlctUsr[0].checked = true;
        document.loginForm.rdoSlctUsr[1].checked = false;
        document.loginForm.rdoSlctUsr[2].checked = false;
        document.loginForm.userSe.value = "GNR";
    // 기업회원
    } else if (userSe == "ENT") {
        document.loginForm.rdoSlctUsr[0].checked = false;
        document.loginForm.rdoSlctUsr[1].checked = true;
        document.loginForm.rdoSlctUsr[2].checked = false;
        document.loginForm.userSe.value = "ENT";
    // 업무사용자
    } else if (userSe == "USR") {
        document.loginForm.rdoSlctUsr[0].checked = false;
        document.loginForm.rdoSlctUsr[1].checked = false;
        document.loginForm.rdoSlctUsr[2].checked = true;
        document.loginForm.userSe.value = "USR";
    }
}

function actionLogin() {
	if (document.loginForm.id.value =="") {
        alert("<spring:message code="comUatUia.validate.idCheck" />"); <%-- 아이디를 입력하세요 --%>
    } else if (document.loginForm.password.value =="") {
        alert("<spring:message code="comUatUia.validate.passCheck" />"); <%-- 비밀번호를 입력하세요 --%>
    } else {
        document.loginForm.action="<c:url value='/uat/uia/actionLogin.do'/>";
        console.log("asdsad");
        //document.loginForm.j_username.value = document.loginForm.userSe.value + document.loginForm.username.value;
        //document.loginForm.action="<c:url value='/j_spring_security_check'/>";
        document.loginForm.submit();
    }
}

function actionCrtfctLogin() {
    document.defaultForm.action="<c:url value='/uat/uia/actionCrtfctLogin.do'/>";
    document.defaultForm.submit();
}

function goFindId() {
    document.defaultForm.action="<c:url value='/uat/uia/egovIdPasswordSearch.do'/>";
    document.defaultForm.submit();
}

function goRegiUsr() {
	
	var useMemberManage = '${useMemberManage}';

	if(useMemberManage != 'true'){
		<%-- 사용자 관리 컴포넌트가 설치되어 있지 않습니다. \n관리자에게 문의하세요. --%>
		alert("<spring:message code="comUatUia.validate.userManagmentCheck" />");
		return false;
	}

    var userSe = document.loginForm.userSe.value;
 
    // 일반회원
    if (userSe == "GNR") {
        document.loginForm.action="<c:url value='/uss/umt/EgovStplatCnfirmMber.do'/>";
        document.loginForm.submit();
    // 기업회원
    } else if (userSe == "ENT") {
        document.loginForm.action="<c:url value='/uss/umt/EgovStplatCnfirmEntrprs.do'/>";
        document.loginForm.submit();
    // 업무사용자
    } else if (userSe == "USR") {
    	<%-- 업무사용자는 별도의 회원가입이 필요하지 않습니다. --%>
        alert("<spring:message code="comUatUia.validate.membershipCheck" />");
    }
}

function goGpkiIssu() {
    document.defaultForm.action="<c:url value='/uat/uia/egovGpkiIssu.do'/>";
    document.defaultForm.submit();
}

function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) + "; path=/; expires=" + expires.toGMTString();
}

function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
        offset = document.cookie.indexOf(search);
        if (offset != -1) { // 쿠키가 존재하면
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // 쿠키 값의 마지막 위치 인덱스 번호 설정
            if (end == -1)
                end = document.cookie.length;
            return unescape(document.cookie.substring(offset, end));
        }
    }
    return "";
}

function saveid(form) {
    var expdate = new Date();
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (form.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("saveid", form.id.value, expdate);
}

function getid(form) {
	form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
}

function fnInit() {
	/* if (document.getElementById('loginForm').message.value != null) {
	    var message = document.getElementById('loginForm').message.value;
	} */
    /* if ("<c:out value='${message}'/>" != "") {
        alert("<c:out value='${message}'/>");
    } */

    /* *************************
    document.loginForm.rdoSlctUsr[0].checked = false;
    document.loginForm.rdoSlctUsr[1].checked = false;
    document.loginForm.rdoSlctUsr[2].checked = true;
    document.loginForm.userSe.value = "USR";
    document.loginForm.id.value="TEST1";
    document.loginForm.password.value="rhdxhd12";
    **************************** */

    //getid(document.loginForm);
    // 포커스
    //document.loginForm.rdoSlctUsr.focus();
    
    getid(document.loginForm);
    
    fnLoginTypeSelect("typeGnr");

    <c:if test="${not empty fn:trim(loginMessage) &&  loginMessage ne ''}">
    alert("loginMessage:<c:out value='${loginMessage}'/>");
    </c:if>
    
    // reload "_top" frame page
    if (parent.frames["_top"] == undefined)
    	console.log("'_top' frame is not exist!");
    parent.frames["_top"].location.reload();
}

function fnLoginTypeSelect(objName){
		objName="typeGnr";
		if(objName == "typeGnr"){ //일반회원
			document.loginForm.userSe.value = "GNR";
		}else if(objName == "typeEnt"){	//기업회원
			 document.loginForm.userSe.value = "ENT";
		}else if(objName == "typeUsr"){	//업무사용자
			 document.loginForm.userSe.value = "USR";
		}
	
}

function fnShowLogin(stat) {
	if (stat < 1) {	//일반로그인
		$(".login_input").eq(0).show();
		$(".login_input").eq(1).hide();
	} else {		//공인인증서 로그인
		$(".login_input").eq(0).hide();
		$(".login_type").hide();
		$(".login_input").eq(1).show();
	}
}

</script>
<style type="text/css">
.bi-person{
   font-size : 30px ;
   width : 43px ;
   height : 44px ;
   padding-top:10px;
   padding-left:3px;
   color:	#ffffff ;
   background-color: #0c4ca4;;
}
.bi-person::before {
    content: "\f4e1";
    margin-left: 5px;
}

.bi-lock{
   font-size : 30px ;
   width : 43px ;
   height : 44px ;
   padding-top:10px;
   padding-left:3px;
   color:	#ffffff ;
   background-color: #0c4ca4;;
}

.bi-lock::before {
    content: "\f47b";
    margin-left: 5px;
}

.loginbox_bg {
    width: 1102px;
    height: 494px;
    margin: 0 auto;
    margin-top: 200px ;
    display: -webkit-box;
    display: -ms-flexbox;
    -ms-flex-wrap: wrap;
    flex-wrap: nowrap;
    box-shadow: 0 5px 20px rgb(0 0 0 / 8%);
    
}

.loginbox_img {
    display: block;
    overflow: hidden;
    width: 502px;
    height: 494px;
    background: url(/images/egovframework/com/Logo/A05.jpg)no-repeat 0 0;
}

.loginbox {
    width: 540px;
    padding: 70px 30px;
    background-color: #fff;
}

.logininpBOX{
	display: flex;
    margin-right: -1px;

}

</style>
</head>
<body onLoad="fnInit();" bgcolor="#f2f7ff">

<!-- javascript warning tag  -->
<noscript class="noScriptTitle"><spring:message code="common.noScriptTitle.msg" /></noscript>

<!-- 로그인 구성 div -->
<div class="loginbox_bg">
	<!-- 이미지 -->
	<div class="loginbox_img"></div> 
	
	<!-- 일반로그인 -->
	<div class="login_form loginbox" style="margin-left: 0px; margin-top: 0px; ">
	
		<form name="loginForm" id="loginForm" action="<c:url value='/uat/uia/actionLogin.do'/>" method="post">
		<input type="hidden" id="message" name="message" value="<c:out value='${message}'/>">

		
		<fieldset style="width:450px; height:350px;  top:200px; left: 1030px;">
			<img src="<c:url value='/images/egovframework/com/Logo/logo.png'/>" style="width:350px; height:80px;" alt="예담"  title="예담 1강 2조">
			<br>
			<br>
			<!-- 일반 , 기업 , 업무 버튼들 -->
			<%-- <div class="login_type">
				<ul id="ulLoginType">
					<li><a href="javascript:fnLoginTypeSelect('typeGnr');" id="typeGnr" title=""><spring:message code="comUatUia.loginForm.GNR"/></a></li> <!-- 일반 -->
					<li><a href="javascript:fnLoginTypeSelect('typeEnt');" id="typeEnt" title=""><spring:message code="comUatUia.loginForm.ENT"/></a></li> <!-- 기업 -->
					<li><a href="javascript:fnLoginTypeSelect('typeUsr');" id="typeUsr" title=""><spring:message code="comUatUia.loginForm.USR"/></a></li> <!-- 업무 -->
				</ul>
			</div> --%>
		
			<div class="login_input" style=" margin-top: 10px; margin-left: 50px;">
				
				<ul>
					<!-- 아이디 -->
					<c:set var="title"><spring:message code="comUatUia.loginForm.id"/></c:set>
					
					<div class = "logininpBOX" style="margin-bottom: 20px;">
						<%-- <label for="id">${title}</label> --%>
						<i class="bi bi-person"  style="  top: 108px; left: 42px;"></i>
						<input style="width:433px; height: 52px; "	type="text" name="id" id="id" maxlength="20" title="${title} ${inputTxt}" placeholder="    ${title} ${inputTxt}">
					</div>
					
					<!-- 비밀번호 -->
					<c:set var="title"><spring:message code="comUatUia.loginForm.pw"/></c:set>
					<div class = "logininpBOX" style="margin-bottom: 10px;">
						<%-- <label for="password">${title}</label> --%>
						<i class="bi bi-lock" style=" top: 158px; left: 42px;"></i>
						<input style="width:433px; height: 52px;"	type="password" name="password" id="password" maxlength="20" title="${title} ${inputTxt}" placeholder="    ${title} ${inputTxt}">
					</div>
					<!-- 아이디 저장 -->
					<c:set var="title"><spring:message code="comUatUia.loginForm.idSave"/></c:set>
					<li class="chk">
						<input type="checkbox" name="checkId" class="check2" onclick="javascript:saveid(document.loginForm);" id="checkId">${title}
					</li>
					<li>
						<input style="width:480px"	type="button" class="btn_login" value="<spring:message code="comUatUia.loginForm.login"/>" onclick="actionLogin()"> <!-- 로그인  -->
					</li>
					<li>
						<ul class="btn_idpw" >
							<li><a href="#" onclick="goRegiUsr(); return false;"><spring:message code="comUatUia.loginForm.regist"/></a></li> <!-- 회원가입  -->
						</ul>
					</li>
					<li>
						<ul class="btn_idpw" >
							<li><a href="#" onclick="fnShowLogin(1);"><spring:message code="comUatUia.loginForm.login.gpki"/></a></li><!-- 인증서로그인 -->
							<li><a href="<c:url value='/uat/uia/egovGpkiIssu.do'/>"><spring:message code="comUatUia.loginForm.gpki.info"/></a></li><!-- 인증서안내 -->
						</ul>
					</li>
					
				</ul>
			</div>
			
			<div class="login_input" style="display: none">
				<ul>
					<li>
						<label for="password"><spring:message code="comUatUia.loginForm.pw"/></label><!-- 비밀번호 -->
						<input type="password" name="pwd" id="" maxlength="20" title="${title} ${inputTxt}" placeholder="<spring:message code="comUatUia.loginForm.pw"/>"><!-- 비밀번호 -->
					</li>
					<li>
						<input type="button" class="btn_login" value="<spring:message code="comUatUia.loginForm.login.gpki"/>" onclick="actionLogin()"><!-- 인증서로그인 -->
					</li>
					<li>
						<ul class="btn_idpw" >
							<li><a href="#" onclick="fnShowLogin(0);"><spring:message code="comUatUia.loginForm.login.normal"/></a></li><!-- 일반로그인 -->
						</ul>
						<ul class="btn_idpw" >
							<li>※ <spring:message code="comUatUia.loginForm.gpki.descrption"/></li>
						</ul>
					</li>
				</ul>
				
			</div>
		</fieldset>
		
		<input name="userSe" type="hidden" value="GNR"/>
		<input name="j_username" type="hidden"/>
		</form>
	</div>
</div>

<!-- 팝업 폼 -->
<form name="defaultForm" action ="" method="post" target="_blank">
<div style="visibility:hidden;display:none;">
<input name="iptSubmit3" type="submit" value="<spring:message code="comUatUia.loginForm.submit"/>" title="<spring:message code="comUatUia.loginForm.submit"/>">
</div>
</form>
<!-- login영역 //-->



</body>
</html>


