/*
 * Angular Controller defines all controller method and provide Routing service method for Navigation
 */

var bpLandingHTML;
var path="";
var ucsContentPath ="";

//Creating ng view module for application name defined in HTML of Layout.jsp
var app = angular.module('bpApp', ['ngSanitize', 'ngRoute']).config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, $routeParams) {	
	$locationProvider.hashPrefix("!");
	$locationProvider.html5Mode(true);

	/**
	 * Angular JS Router Provider services for Navigation 
	 * it defined a path and mapped it to view and controller * 
	 **/
	//conditions for different templateUrl for guest and other users
	if(guestUser == "Y" || showSFDCTabs){
		path = "/guest";
	}
	ucsContentPath = appContextPath+path;
	$routeProvider.
	when('/home', {
		controller: 'contentController',
		template: '<div/>'
	}).
	otherwise({redirectTo: '/home'});
}]);

/**
 * contentController used for MDF hierarchy .
 */
app.controller('contentController', function($scope , $compile, $http, $routeParams){
	
	if(window.location.search.indexOf("_escaped_fragment_") > 0) {
		addLayoutClassWrpp02();
		homeResizing();
		return;
	}
	
	var contentType = $routeParams.contentType ? $routeParams.contentType : 'bnpMain';
	var contentId = $routeParams.contentId ? $routeParams.contentId : "home";
	$(".preloaderOverlay").show();
	$(".preLoader").show();
	
	
	
	$http({
		method: 'GET', 
		url: appContextPath+path + '/content/headless/' + contentType + "/" + contentId
	}).success(function(data, status, headers, config) {
	//	$("#mainContent").html($compile(data)($scope));
	//	addLayoutClassWrpp02();
	//	homeResizing();
		// 
		$(".preloaderOverlay").hide();
		$(".preLoader").hide();
		
		if(!(($("#mainContent").find(".product-listing").length) > 0 && !(window.location.href.indexOf('content') != -1))){
			// Load landing page
			
			if(!(($("#mainContent").find("#idRdOtherProxy").length) > 0)){
				$("#mainContent").html($compile(data)($scope));
				addLayoutClassWrpp02();
				homeResizing();
			}	
		}else {
			
			// Load cart after punchout 
			addLayoutClassWrapper();
			try{
				//To reload cart after punchout
				if(window.callbackfromNextgen){
					window.callbackfromNextgen=false;
					javascript:viewCurrentQuote();	
				}
			}
			catch(err){
				loadjscssfile("wireFrameJs/master.js", "js"); 
			}
		}
		callRotateBanner();
		$("a.changeCountryhome").fancybox({
			'width' : 525 ,
			'titlePosition' : 'inside',
			'transitionIn' : 'none',
			'transitionOut' : 'none',
			'autoDimensions' :'true',
			'height': 400,
			'titleShow'	: false
		});	

		 
		 $("#nextGenCartIcon").mouseover(function(){
		       $('#nextGenCartIcon').parent().find(".sub_nav").stop(true, true).delay(500).fadeIn(200);
		});
		 $("#nextGenCartIcon").mouseleave(function() {
		        $('#nextGenCartIcon').parent().find(".sub_nav").stop(true, true).hide(0);
		 });
		 //Q1FY15: DirectEstimateCheck for Continue Shopping
		 if(checkDirectEstimate){
			 reloadDirectURL = false;
		 }else{
			 reloadDirectURL = true;			 
		 }
	}).error(function(data, status, headers, config) {
		$(".preloaderOverlay").hide();
		$(".preLoader").hide();
		// called asynchronously if an error occurs
		// or server returns response with an error status.
	});
	
});
