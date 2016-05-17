<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="cms"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/localizer.tld" prefix="slim"%>

<cms:content var="document" contentId="${contentId }">
	<div class="errorMessage" id="searchErrorMessage" style="display: none">
		<h4 style="color: red"></h4>
	</div>
	
	<!--  Q4FY14 Guest down time message changes start here -->
	<cms:accessLevelCheck level="0">
		<c:if test="${sessionScope.GUEST_DWN_TIME_FLG != null}" > 
				<c:if test="${sessionScope.GUEST_DWN_TIME_FLG == 'Y'}" > 
				  ${sessionScope.GUEST_DWN_TIME_MSG}
				</c:if>
		</c:if>
		 <div class="spacer10"></div>
	</cms:accessLevelCheck>
	<div class="content">
		<div class="clear"></div>
		<div class="beloweMenu">
			<div class="brdKrm">
			<ul>
				<li><a href="javascript:_cpc.catalog.openProductView()"><slim:message
							appShortName="CPC" key="LABEL.HEADER.PRODUCTS" /></a></li>
				<li>&gt;</li>
				<li><span>${document.pagename}</span></li>
			</ul>				
			</div>
			<div class="clear"></div>
			<div class="mainHeading" >
					<h2 id="pageTitle">${document.pagename}</h2>
					<!-- Q1FY15 Bnp Wskp parity -->
					<jsp:include page="/jsp/common/nextGenCartIcon.jsp"></jsp:include>
				</div>
		
			<div class="clear"></div>
		</div>
		<h2 style="display: none;" id="browserTitle">${document.browserTitle}</h2>
	</div>
	<div class="spacer20"></div>
	<div style="display: none ;">
  
    <div id="getResult">
 </div>
</div>
	<!-- <div id="backTop" style="display: block;"><a href="javascript://"></a></div> -->

	<div style="display: none ;">
		<div id="survey" class="survey-modal">
		    <img src=".../../images/survey-logo.png" alt="">
		    <div class="spacer10"></div>
		    <h3><slim:message appShortName="CPC" key="label.popsurvey.feedback" /></h3>
		    <p><slim:message appShortName="CPC" key="message.popupsurvey.ciscoexp" /></p>
		    <div class="spacer20 border-bottom"></div>
		    <div class="surveyModalBtn marginT10">
		      <input type="button" class="floatRight takeSurvey" value="<slim:message appShortName="CPC" key="label.popupsurvey.takeSurvey" />">
		      <input type="button" onclick="$.fancybox.close();" class="marginR10 disableBTN rejectSurvey" value="<slim:message appShortName="CPC" key="label.popupsurvey.cancelSurvey" />">
		      <!-- <input type="button" onclick="$.fancybox.close(); disableSurveyPopupBox();" value="No, Thanks" class="marginR10 disableBTN"> -->
		    </div>
	  	</div>
	</div>

</cms:content>
<script>
$(document).ready(function() {
	
	//Survey Feedback Model CR
	var surveyPopupDisabled = $.cookie("surveyPopupDisabled");
	if((guestUser=="Y" || userAccessLevel==1) && !surveyPopupDisabled){
		if(popupSurveyTimeout != null && popupSurveyTimeout != "" && popupSurveyTimeout != undefined  && popupSurveyTimeout != "undefined"){
			var surveyTimeout = parseInt(popupSurveyTimeout);
		}else{
			var surveyTimeout = 4000;
		}
		if($.cookie("browserCounter")!=null){
			var currentCount = parseInt($.cookie("browserCounter"));
			$.cookie("browserCounter", currentCount+1, { domain: '.cisco.com', path: '/', expires: 365 });
		}else{
			$.cookie("browserCounter", 1, { domain: '.cisco.com', path: '/', expires: 365 });
		}
		if((parseInt($.cookie("browserCounter"))==3 && $.cookie("guestCntry")=="US" && $.cookie("guestLang")=="en_US" && guestUser=="Y")||(($.cookie("browserCounter"))==3 && userAccessLevel==1 && registeredUserCountry=="US" && guestLanguage=="en_US")){
			setTimeout(function(){
				$.fancybox({
					'width' : 525 ,
			  		'titlePosition' : 'inside',
			  		'transitionIn' : 'none',
			  		'transitionOut' : 'none',
			  		'autoDimensions' :'true',
			  		'height': 400,
			  		'titleShow'	: false,
			  		'href':'#survey',
			  		'onComplete':function(){
			  			$('#fancybox-wrap').addClass('fancywrapbox_surveyPopup');
						$('#fancybox-content').addClass('fancybox-content_surveyPopup');
						$('#fancybox-close').addClass('fancywrapbox_closeAddProductBox1');
						$('#fancybox-outer').addClass('fancybox-outer_surveyPopup');
				    }
			    });
				$(".takeSurvey").click(function(){
				    $.fancybox.close();
				    window.open(popupSurveyURL);
				    disableSurveyPopupBox();
				    return false;  
				});
				$(".rejectSurvey").click(function(){
				    $.fancybox.close();
				    disableSurveyPopupBox();
				    return false;  
				});
			},surveyTimeout);
		}
	}
});
</script>