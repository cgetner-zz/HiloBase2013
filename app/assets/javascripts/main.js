var normal_timeout = 10000;
var timer = "";
var betaAccessFormSubmit = 1;
var bodyWidth = $(document).width();
$(window).resize(function() {
    bodyWidth = $(document).width();
    centralizePopup();
    if($("#credentials_exploreSelectDesiredRole").is(':visible')) {
        try
        {
            var _leftoffset = $('.highlightCls').offset().left;
            var _topoffset = $('.highlightCls').offset().top;

            if($("ul#career_clusters li").hasClass("highlightCls")) {
                $(".career_path_left").css("left",_leftoffset+275+"px");
            }
            $(".career_path_left").css({
                top:_topoffset-5+"px"
            });

            _leftoffset = $('.highlightCls_path').offset().left;
            _topoffset = $('.highlightCls_path').offset().top;
            
            $(".career_desiredrole_left").css("left",_leftoffset+242+"px");
            $(".career_desiredrole_left").css({
                top:_topoffset-5+"px"
            });
        }
        catch(err)
        {
            
        }
    }
});
var searchAjax = true;

var create_guest_job_seeker_flag = 1;


/******** Common functions for application ***********/
function submitBetaAccessOnce(){
    //alert(betaAccessFormSubmit);
    return (betaAccessFormSubmit--);
}

function resetBetaAccessFormSubmit(){
    betaAccessFormSubmit = 1;
}

var stopping_propagation = function(e){
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
};

String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
}

function validatePasswordForSpecialCharacters(value) {
    var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?";

    for (var i = 0; i < value.length; i++) {
        if (iChars.indexOf(value.charAt(i)) != -1) {
            return false;
        }
    }
    return true;
}


function showErrorShadow() {
    hideRefreshLink();
    $('#fade_error').show();
}

function showSuccessShadow() {
    hideRefreshLink();
    $('#fade_success').show();
}

function showNormalShadow() {
    hideRefreshLink();
    $('#fade_normal').show();
}

function hideErrorShadow() {
    $('#fade_error').hide();
}

function hideSuccessShadow() {
    $('#fade_success').hide();
}

function hideNormalShadow() {
    $('#fade_normal').hide();
}

function showVideo() {
    $("#jw_player").show();
}

function hideVideo() {
    $("#jw_player").hide();
}

// Checks for a valid password, value to be checked must be passed as an argument
function validatePassword(value) {
    var regex = /^[a-z0-9]+$/i;
    if(regex.test(value) && value.length > 5)
        return true;
    return false;
}

// Check for a valid email address, value to be checked must be passed as a parameter
function validateEmail(value) {
    if (/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i.test(value)){
        return true;
    }
    return false;
}

// Checks if a password field is not empty, can be used through out the application, accepts JS element as a parameter
function validateNotEmptyPassword(element){
    if(element.className.match(/password/)=="password") {
        if(element.type=="text") {
            value = "";
        }
        else {
            value = element.value;
        }
    }
    if(value.trim() != "") {
        return true;
    }
    return false;
}


// Function to check if a value contains characters or not. NOT TO BE USED DIRECTLY TO VALIDATE ELEMENT FIELDS. PLEASE USE validateNotEmpty function
function validateRequired(value) {
    if(value.trim() != "") {
        return true;
    }
    return false;
}

// Function to check if a text field is empty or not, can be used through out the application, pass JS element as parameter
function validateNotEmpty(element) {
    //alert(element.id);
    if(($("#"+element.id).parent().hasClass("active-input") || $("#"+element.id).parent().hasClass("input-text-active") || $("#"+element.id).parent().hasClass("input-text-error")  ) && validateRequired(element.value)) {
        return true;
    }
    else {
        return false;
    }
}

function validateNotEmpty_ta(element) {
    if(($("#"+element.id).parent().parent().hasClass("active-input") || $("#"+element.id).parent().parent().hasClass("input-text-active") || $("#"+element.id).parent().parent().hasClass("input-text-error") ) && validateRequired(element.value)) {
        return true;
    }
    else {
        return false;
    }
}

function centralizePopup() {
    var popupWidth = 0;
    var left = 0;
    $(".white_content").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-16;
        $(this).css("left",left+"px");
	
    });
    $(".detiled_content").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-16;
        $(this).css("left",left+"px");
	
    });
    $(".cs-introduction-container").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2);
        $(this).css("left",left+"px");
	
    });
    $(".credentials_exploreSelectDesiredRole").each(function() {
        popupWidth = 870;
        left = ((bodyWidth - popupWidth)/2)-10;
        $(this).css("left",left+"px");

    });
    
}
/******** End Common functions for application ***********/

/******** Functions for landing page ***********/

$(function() {
    $('.signIn-button').click(function(e){
        showLoginBox();
        e.stopPropagation();
    });
	
    $('.login-arrow').click(function(){
        hideLoginBox();
    });
});
function openLoginBox() {
    $("#fade_normal_status").show();
    $("#fade_normal_status").css('z-index','1001');
    $("#sign-in-box").show();
    $('#login_form_submit').show();
    $('#forgot_pass').show();
    $("#fade_normal_status").click(function(){
        if(!$("#loader-img").is(':visible'))
            closeLoginBox();
    });
    $('#login_name').val($('#login_name_placeholder').val());
    $("#header .hil-info-link-section .info-links a").addClass('white');
    $('#login_name').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_name').parent().addClass('input-text');
    $('#login_pass').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_pass').parent().addClass('input-text');
    changeInputType(document.getElementById("login_pass"),"text","");
    $('#login_pass').val($('#login_pass_placeholder').val());
    $('#login_form_submit').removeClass('enter-button-active');
    $('#login_form_submit').addClass('enter-button');
    $("#login_form_submit").unbind('click').bind('click', function(){
        inactiveSignInButton();
    });
    $(".footer-links .hilo").addClass('white');
    addFocusTextField('login_name');
}
function closeLoginBox() {
    $("#fade_normal_status").hide();
    $("#header .hil-info-link-section .info-links a").removeClass('white');
    $("#sign-in-box").hide();
    $(".footer-links .hilo").removeClass('white');
}
function showLoginBox() {
    $('.signIn-block').slideDown('fast');
    $('#login_form_submit').show();
    $('#forgot_pass').show();
    $('#login_name').val($('#login_name_placeholder').val());
    $('#login_name').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_name').parent().addClass('input-text');
    $('#login_pass').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_pass').parent().addClass('input-text');
    changeInputType(document.getElementById("login_pass"),"text","");
    $('#login_pass').val($('#login_pass_placeholder').val());
    //$('#login_form_submit').removeClass('enter-button-active');
    //$('#login_form_submit').addClass('enter-button');
    $("#login_form_submit").unbind().click(function() {
        inactiveSignInButton();
    });
    addFocusTextField('login_name');
    BrowserDetect.init();
      
    if ( BrowserDetect.browser == "Explorer" )
    {
        //wiring to onkeydown event
        //alert("IE");
        document.getElementById('login_pass').attachEvent('onkeydown', function(e){
            editorEvents(document.getElementById('login_pass'), e);
        });
		      
    }
		    
    else if ( BrowserDetect.browser == "Chrome" || BrowserDetect.browser == "Safari" ){
		      
        document.getElementById('login_pass').addEventListener('keydown',function(e){
            editorEvents(document.getElementById('login_pass'), e);
        }, false);
    }

//setTimeout(loginPopupEmailFieldHandler, 200);
}

function loginPopupEmailFieldHandler(){
    if($('#login_name').val() == "Email" && $('#login_name').parent().hasClass('input-text-active')){
        $('#login_name').parent().removeClass('input-text-active');
    }
}

function hideLoginBox() {
    if(!$("#loader-img").is(':visible'))
        $('.signIn-block').slideUp('fast');
}

function showBetaPopup() {
    showNormalShadow();
    $('#beta_access').show();
    $('#coderequest_email').val('Email address');
    $('#coderequest_email').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#coderequest_email').parent().addClass('input-text');
    $('#beta_button').removeClass("enter-button-active");
    $('#beta_button').addClass("enter-button");
    //$('#beta_button').attr("disabled","disabled");
    centralizePopup();
	
    $("#beta_button").unbind('click').bind('click',function(){
		
        if(validateEmptyBetaAccess()){
        
        }
        else{
            //document.forms["beta_form"].submit();
            $("#beta_form").submit();
        }
		
    });
}

function hideBetaPopup() {
    //        $.ajax({
    //        url:'/home/closeSharing',
    //        cache: false,
    //        success: function(){
    //        }
    //    });
    $('#beta_access').hide();
    $('#fade_normal').hide();
}

function showErrorBeta() {
    showErrorShadow();
    $('#beta_error').show();
    centralizePopup();
}

function hideErrorBeta() {
    hideErrorShadow();
    $('#beta_error').hide();
}

function showSuccessBeta() {
    showSuccessShadow();
    $('#beta_success').show();
    centralizePopup();
}

function hideSuccessBeta() {
    showSuccessShadow();
    $('#beta_error').hide();
}

function showErrorLogin(){
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_error_warning").show()
        $("#login_error").show();
        centralizePopup();
    }
    else {
        showErrorShadow();
        $("#login_error").show();
        centralizePopup();
    }
}

function showAuthErr(){
    showErrorShadow();
    $("#hilo_password").blur();
    $("#auth_error").show();
    centralizePopup();
    addFocusButton('auth_error_button');
}

function hideErrorLogin() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_error_warning").hide();
        $("#login_error").hide();
    }
    else {
        hideErrorShadow();
        $("#gift_hilo_signin_failure").hide();
        $("#login_error").hide();
    }
}

function hideAuthErr(){
    hideErrorShadow();
    $("#auth_error").hide();
}

function showForgotPassword() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        //showNormalShadow();
        $("#fade_normal_second").show();
        hideLoginBox();
        $("#forgot_password").show();
        $('#email_id_email').focus();
        $('#email_id_email').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#email_id_email').parent().addClass('input-text-unactive');
        $("#email_id_email").val("Email");
        $('#submit_button').show();
        $('#loader_img2').hide();
        //$('#submit_button').removeClass("enter-button-active");
        //$('#submit_button').addClass("enter-button");
        //$('#submit_button').attr("disabled","disabled");
        $("#submit_button").unbind('click').bind('click',function(){
            if(validateEmptyForgotPswd()){

            }
            else{
                //document.forms["beta_form"].submit();
                $("#forgot_pswd_form").submit();
            }

        });
        centralizePopup();
        addFocusTextField('email_id_email');
    }
    else {
        $(".hilo_search_link").css('z-index','1');
        $(".language-selector.career_seeker").css('z-index','1');
        showNormalShadow();
        $("#forgot_password").show();
        $('#email_id_email').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#email_id_email').parent().addClass('input-text');
        $("#email_id_email").val("Email");
        $('#submit_button').show();
        $('#loader_img2').hide();
        //$('#submit_button').removeClass("enter-button-active");
        //$('#submit_button').addClass("enter-button");
        //$('#submit_button').attr("disabled","disabled");
        $("#submit_button").unbind('click').bind('click',function(){
            if(validateEmptyForgotPswd()){

            }
            else{
                //document.forms["beta_form"].submit();
                $("#forgot_pswd_form").submit();
            }

        });
        centralizePopup();
        addFocusTextField('email_id_email');
        $(".home-footer label").removeClass("year");
        $(".home-footer label").addClass("bridge");
    }

}

function showForgotPassword_singin(){
    $("#sign-in-box").hide();
    $("#fade_normal_status").hide();
    $(".info-links").children().removeClass('white');
    showNormalShadow();
    $("#forgot_password").show();
    $('#email_id_email').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#email_id_email').parent().addClass('input-text');
    $("#email_id_email").val("Email");
    $('#submit_button').show();
    $('#loader_img2').hide();
    $('#submit_button').removeClass("enter-button-active");
    $('#submit_button').addClass("enter-button");
    //$('#submit_button').attr("disabled","disabled");
    $("#submit_button").unbind('click').bind('click',function(){
        if(validateEmptyForgotPswd()){

        }
        else{
            //document.forms["beta_form"].submit();
            $("#forgot_pswd_form").submit();
        }

    });
    centralizePopup();
    $(".footer-links .hilo").addClass('white');
    addFocusTextField('email_id_email');
}

function hideForgotPassword() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_normal_second").hide();
        $("#forgot_password").hide();
        $("#email_id_email").parent().removeClass("input-text input-text-active active-input input-text-error-empty");
        $("#email_id_email").parent().addClass("input-text");
    }
    else {
        hideNormalShadow();
        $("#forgot_password").hide();
        $("#email_id_email").parent().removeClass("input-text input-text-active active-input input-text-error-empty");
        $("#email_id_email").parent().addClass("input-text");
        $('.home-footer label').addClass('year');
        $('.home-footer label').removeClass('bridge');
    }
    $(".footer-links .hilo").removeClass('white');
}

function showForgotPasswordError() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_error_warning").show();
        $("#forgot_password_error").show();
        centralizePopup();
        //$("#forgot_password_error_button").focus();
        addFocusButton('forgot_password_error_button');
    }
    else {
        showErrorShadow();
        $("#forgot_password_error").show();
        centralizePopup();
        //$("#forgot_password_error_button").focus();
        addFocusButton('forgot_password_error_button');
    }

}

function hideForgotPasswordError() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_error_warning").hide();
        $("#forgot_password_error").hide();
    }
    else {
        hideErrorShadow();
        $("#forgot_password_error").hide();
    }

}

function showForgotPasswordSuccess() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_success_bridge").show();
        $("#forgot_password_success").show();
        centralizePopup();
        addFocusButton('forgot_password_success_button');
    //$("#forgot_password_success_button").focus();
    }
    else {
        showSuccessShadow();
        $("#forgot_password_success").show();
        centralizePopup();
        addFocusButton('forgot_password_success_button');
    //$("#forgot_password_success_button").focus();
    }
    $(".footer-links .hilo").addClass('white');
    
}

function hideForgotPasswordSuccess() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_success_bridge").hide();
        $("#forgot_password_success").hide();
    }
    else {
        hideSuccessShadow();
        $("#forgot_password_success").hide();
    }
    $(".footer-links .hilo").removeClass('white');
}

function hideForgotPasswordResetWindow() {
    hideNormalShadow();
    $("div#forgot-password-reset").hide();
}

function showForgotPasswordSuccessWindow() {
    showSuccessShadow();
    $('div#forgot_password_reset_success').show();
    centralizePopup();
}

function hidePasswordSuccessWindow() {
    hideSuccessShadow();
    $('div#forgot_password_reset_success').hide();
}

function showForgotPasswordResetError() {
    showErrorShadow();
    $("div#forgot_password_reset_error").show();
    centralizePopup();
}

function hideForgotPasswordResetError() {
    hideErrorShadow();
    $("div#forgot_password_error").hide();
    $('div#forgot_password_reset_error').hide();
}

function showForgotPasswordRetryWindow() {
    window.location.href="/home";
/*showNormalShadow();
            $("div#forgot-password-reset").show();
	$('#email_id_email').parent().removeClass('input-text input-text-active active-input input-text-error');
	$('#email_id_email').parent().addClass('input-text');
	$("#email_id_email").val("Email");
	$('#submit_button').show();
	$('#loader_img2').hide();
	$('#submit_button').removeClass("enter-button-active");
	$('#submit_button').addClass("enter-button");
	$('#submit_button').attr("disabled","disabled");
	centralizePopup();*/
}

function activate_login_form(element,e) {
    var code = e.keyCode;
		
    if(document.getElementById("login_name") && document.getElementById("login_pass")) {
        email_element = document.getElementById("login_name");
        email = document.getElementById("login_name").value.trim();
        password = document.getElementById("login_pass").value;
        pass_element = document.getElementById("login_pass");
        button = document.getElementById("login_form_submit");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            $("#"+email_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email_element.id).parent().addClass("active-input");
            //button.className="enter-button-active rfloat";
            if(code == 13){
                //$("#login_form").submit();
                $("#login_form").submit();
            }
            //button.disabled="";
            $("#login_form_submit").unbind().click(function() {
                inactiveSignInButton();
            });
            $("#login_form_submit").unbind().click(function() {
                //$("#login_form").submit();
                $("#login_form").submit();
            });
        }
        else {
            //button.className="enter-button rfloat";
            if(!validateNotEmpty(email_element) && email_element == element) {
                $("#"+email_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email_element.id).parent().addClass("input-text-active");
            }
            if(!validateNotEmpty(pass_element) && pass_element == element) {
                $("#"+pass_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+pass_element.id).parent().addClass("input-text-active");
            }
            //button.disabled="true";
            $("#login_form_submit").unbind().click(function() {
                inactiveSignInButton();
            });
        }
    }
}

function inactiveSignInButton() {
    email_element = document.getElementById("login_name")
    email = document.getElementById("login_name").value.trim();
    password = document.getElementById("login_pass").value;
    pass_element = document.getElementById("login_pass");
				
				
    if(!validateNotEmpty(email_element)) {
        $("#"+email_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email_element.id).parent().addClass("input-text-error-empty");
    }
    else if(!validateEmail(email)) {
        $("#"+email_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email_element.id).parent().addClass("input-text-error");
    }
				
    if(!validateNotEmptyPassword(pass_element)) {
        $("#"+pass_element.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+pass_element.id).parent().addClass("input-text-error-empty");
    }
}
function sharing_activate_login_form() {
    if(document.getElementById("share_login_name") && document.getElementById("share_login_pass")) {
        email = document.getElementById("share_login_name").value;
        password = document.getElementById("share_login_pass").value;
        pass_element = document.getElementById("share_login_pass");
        button = document.getElementById("share_login_form_submit");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            button.className="enter-button-active rfloat";
        //button.disabled="";
        }
        else {
            button.className="enter-button rfloat";
        //button.disabled="true";
        }
    }
}

function validateAuthInfo(){
    if(document.getElementById("hilo_email") && document.getElementById("hilo_password")) {
        email = document.getElementById("hilo_email").value;
        password = document.getElementById("hilo_password").value;
        pass_element = document.getElementById("hilo_password");
        button = document.getElementById("enter_auth");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            button.className="enter-button-active rfloat";
            if($("#"+document.getElementById("hilo_password").id).parent().hasClass("input-text-active"))
                $("#"+document.getElementById("hilo_email").id).parent().removeClass("input-text-error").addClass("active-input");
            else
                $("#"+document.getElementById("hilo_email").id).parent().removeClass("input-text-error").addClass("input-text-active");
        //button.disabled="";
        }
        else {
            button.className="enter-button-active rfloat";
        //button.disabled="disabled";
        }
		
        if(validateEmail(email)){
            if($("#"+document.getElementById("hilo_password").id).parent().hasClass("input-text-active"))
                $("#"+document.getElementById("hilo_email").id).parent().removeClass("input-text-error").addClass("active-input");
            else
                $("#"+document.getElementById("hilo_email").id).parent().removeClass("input-text-error").addClass("input-text-active");
        }
    }
}

function validateBetaEmail(element){
    email = element.value;
    button = document.getElementById('beta_button');
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
		
        button.className = "enter-button-active rfloat";
        $("#coderequest_email").parent().removeClass("input-text-error").addClass("active-input");
        //button.disabled="";
        return true;
    }
    else	{
        button.className = "enter-button rfloat";
        //button.disabled="disabled";
        return false;
    }
        
	
}

function validateForgotPassEmail(element){
    email = element.value;
    button = document.getElementById('submit_button');
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
		
        //button.className="enter-button-active";
        //$("#email_id_email").parent().removeClass("input-text-error").addClass("active-input");
        //button.disabled="";
        return true;
    }
    else {
        //button.className="enter-button";
        //button.disabled="true";
        return false;
    }
	
}

/********* Gift Hilo *********/
function showGiftHiloPopup(session_exist) {
    showNormalShadow();
    $('#gift_hilo_popup').show();
    centralizePopup();
    if (session_exist == 'false')
        addFocusTextField('senders_name');
    else
        addFocusTextField('recipients_name');
}

function hideGiftHiloPopup() {
    $('#gift_hilo_popup').hide();
    hideNormalShadow();
}

function showPurchaseReviewPopup() {		
    $.ajax({
        url: "/home/purchase_review",
        cache: false,
        success: function(){

        }
    });
}

function hidePurchaseReviewPopup() {	
    $('#gift_purchase_review').empty();
    $('#fade_normal').hide();
}

function showCheckoutBillingInfoPopup() {
    $.ajax({
        url: '/home/show_checkout_billing',
        cache: false,
        success: function(){
            $("#payment-options_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
            $("#senders_name_pay").val($('#senders_name').val());
            $("#senders_email_pay").val($('#senders_email').val());
            $("#recievers_name_pay").val($('#recipients_name').val());
            $("#recievers_email_pay").val($('#recipients_email').val());
            $("#personal_msg_pay").val($('#personal_msg').val());
            $("#gifts_payment_verify_button").show();
            hideBlockShadow();
        }
    });
}

function hideCheckoutBillingInfoPopup() {
    hideCreditCarddData();
        
    $('#checkout_billing_popup').hide();
    $('#fade_normal').hide();
}

function backToGiftHiloPopup() {
    hidePurchaseReviewPopup();
    $('#oneClick-payment_gift').hide();
    showGiftHiloPopup();
}

function backToPurchaseReviewPopup() {
    $.ajax({
        url: "/home/clear_gift_session",
        cache: false,
        succes: function(){
                
        }
    });
    hideCheckoutBillingInfoPopup();
    showNormalShadow();
    $('#purchase_review_popup').show();
    centralizePopup();
}

function showErrorGiftHilo() {
    showErrorShadow();
    $('#gift_hilo_error').show();
    centralizePopup();
}

function hideErrorGiftHilo() {
    hideErrorShadow();
    $('#gift_hilo_error').hide();
}

function showSuccessGiftHilo() {
    showSuccessShadow();
    $('#gift_hilo_success').show();
    centralizePopup();
}

function hideSuccessGiftHilo() {
    hideSuccessShadow();
    $('#gift_hilo_error').hide();
}

function registeredGiftPurchase() {
    $.ajax({
        url: '/gift/gift_hilo_registered_job_seeker',
        data: '&senders_name_pay=' + $('#senders_name_pay_purchase').val()
        + '&senders_email_pay=' + $('#senders_email_pay_purchase').val()
        + '&recievers_name_pay=' + $('#recievers_name_pay_purchase').val()
        + '&recievers_email_pay=' + $('#recievers_email_pay_purchase').val()
        + '&personal_msg_pay=' + $('#personal_msg_pay_purchase').val(),
        cache: false,
        success: function(){
        }

    });
}

/********* Gift Hilo *********/

/******** End of Functions for landing page ***********/

/******** Functions for account setup page ***********/
function showPrivacyPopup() {
    showNormalShadow();
    hideVideo();
    $("#privacy_policy").show();
    $(".footer-links .hilo").addClass('white');
}

function hidePrivacyPopup() {
    hideNormalShadow();
    showVideo();
    $("#privacy_policy").hide();
    $(".footer-links .hilo").removeClass('white');
}

function showTermsPopup() {
    showNormalShadow();
    hideVideo();
    $("#terms_of_use").show();
    //$(".privacy-text-cont").animate({scrollTop:0}, 'fast');
    $(".footer-links .hilo").addClass('white');
}

function hideTermsPopup() {
    hideNormalShadow();
    showVideo();
    $("#terms_of_use").hide();
    $(".footer-links .hilo").removeClass('white');
}

function validateHasError(element) {
    if($("#"+element.id).parent().hasClass("input-text-error") || $("#"+element.id).parent().hasClass("input-text-error-empty"))
        return true;
    else
        return false;
}
function validateBasicInfo(current_element,dropdown_flag) {
    if(crack_for_IE==true) {
        crack_for_IE = false;
        return;
    }
    firstName = document.getElementById('job_seeker_first_name');
    lastName = document.getElementById('job_seeker_last_name');
    email = document.getElementById('job_seeker_email');
    //pincode = document.getElementById('job_seeker_zip_code');
    city = document.getElementById('job_seeker_city');
    city_placeholder = document.getElementById('job_seeker_city_placeholder').value;
    password = document.getElementById('job_seeker_password');
    rePassword = document.getElementById('job_seeker_password_confirmation');
    tc = document.getElementById('privacyText').checked;
    errorBox = document.getElementById('error_msg');
    error_element = document.getElementById('error_type');
	
    if(current_element==firstName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(password) && !validateHasError(rePassword) && !validateHasError(city) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
    if(current_element==lastName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(password) && !validateHasError(rePassword) && !validateHasError(city) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
    
    if(current_element==city) {
        if($(".pac-container").css('display')=="block") {
            setTimeout(function(){
                if($("#dropdown_flag").val()==0 && validateNotEmpty(city) && city.value!=="City / Location") {
                    $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+city.id).parent().addClass("input-text-error");
                    if(error_element.value=="city" || error_element.value=="") {
                        errorBox.innerHTML="Please select a location from the list.";
                        error_element.value="city";
                    }
                }
                else {
                    if(validateNotEmpty(city)){
                        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+city.id).parent().addClass("active-input");
                    }
                    else {
                        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+city.id).parent().addClass("input-text");
                    }
                    if(error_element.value=="city" || error_element.value=="") {
                        errorBox.innerHTML="";
                        error_element.value="";
                    }
                }

            }, 1000);
        } else {
            if($("#dropdown_flag").val()==0 && validateNotEmpty(city) && city.value!=="City / Location") {
                $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+city.id).parent().addClass("input-text-error");
                if(error_element.value=="city" || error_element.value=="") {
                    errorBox.innerHTML="Please select a location from the list.";
                    error_element.value="city";
                }
            }
            else {
                if(validateNotEmpty(city)){
                    if(dropdown_flag==true) {
                        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+city.id).parent().addClass("active-input");
                    }
                    else {
                        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+city.id).parent().addClass("input-text-active");
                    }
                }
                else {
                    $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+city.id).parent().addClass("input-text-unactive");
                }
                if(error_element.value=="city" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
        }
    }
    if(current_element==email)
    {
        if(email.value.length>0 && !$("#"+email.id).parent().hasClass("input-text-unactive")) {
            if(validateEmail(email.value)) {
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("input-text-active");
                if(error_element.value=="email" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("input-text-error");
                if(error_element.value=="email" || error_element.value=="") {
                    errorBox.innerHTML="Invalid email address format";
                    error_element.value="email";
                }
            }
        }
        else {
            //errorBox.innerHTML="";
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-unactive");
            if(error_element.value=="email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
    if(current_element==password && (($("#"+password.id).parent().hasClass("active-input")) || ($("#"+password.id).parent().hasClass("input-text-active")) || ($("#"+password.id).parent().hasClass("input-text-error")) )) {
        if(password.value.length>0) {
            if(validatePassword(password.value)) {
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-active");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML="";
                            error_element.value="";
                        }
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="repassword" || error_element.value=="") {
                            errorBox.innerHTML="Passwords do not match. Please try again.";
                            error_element.value="";
                        }
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-active");
                    if(error_element.value=="password" || error_element.value=="") {
                        errorBox.innerHTML="";
                        error_element.value="";
                    }
                }
            }
            else {
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                            error_element.value="password";
                        }
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                            error_element.value="password";
                        }
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-error");
                    if(error_element.value=="password" || error_element.value=="") {
                        errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                        error_element.value="password";
                    }
                }
				
            }
        }
        else {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-active");
            if(error_element.value=="password" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
		
    if(current_element==rePassword && (($("#"+rePassword.id).parent().hasClass("active-input")) || ($("#"+rePassword.id).parent().hasClass("input-text-active")) || ($("#"+rePassword.id).parent().hasClass("input-text-error")) )) {
        if(rePassword.value.length>0) {
            if(password.value==rePassword.value) {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-active");
                if(validatePassword(password.value)) {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("active-input");
                }
                
                if(error_element.value=="repassword" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-error");
                if(error_element.value=="repassword" || error_element.value=="") {
                    errorBox.innerHTML = "Passwords do not match. Please try again.";
                    error_element.value="repassword";
                }
            }
        }
        else {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-active");
            if(error_element.value=="repassword" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
	
    if(tc){
	
        if(validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(email) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value) && validateNotEmpty(city) && $("#dropdown_flag").val()==1) {
            button = document.getElementById('basic_button');
            button2 = document.getElementById('snr_button');
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
            $("#basic_button").unbind().click(function() {
                set_save_type('questionnaire');
                $("#job_seeker").submit();
            });
            $("#snr_button").unbind().click(function() {
                set_save_type('saveandreturn');
                $("#job_seeker").submit();
            });
           
            button.className="enter-button-active rfloat";
            button2.className="saveReturnLater-button-active lfloat";
        }
        else {
            button = document.getElementById('basic_button');
            button2 = document.getElementById('snr_button');
            $("#basic_button").unbind().click(function() {
                validateJobSeekerNewOnInactiveButtonClick();
            });
            $("#snr_button").unbind().click(function() {
                validateJobSeekerNewOnInactiveButtonClickSnR();
            });
            button.className="enter-button-active rfloat";
            button2.className="saveReturnLater-button-active lfloat";
 			
        }
	
    }
    else {
        button = document.getElementById('basic_button');
        button2 = document.getElementById('snr_button');
        $("#basic_button").unbind().click(function() {
            validateJobSeekerNewOnInactiveButtonClick();
        });
        $("#snr_button").unbind().click(function() {
            validateJobSeekerNewOnInactiveButtonClickSnR();
        });
        button.className="enter-button-active rfloat";
        button2.className="saveReturnLater-button-active lfloat";
        if(validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(email) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value) && validateNotEmpty(city) && $("#dropdown_flag").val()==1){
            button2 = document.getElementById('snr_button');
            $("#snr_button").unbind().click(function() {
                set_save_type('saveandreturn');
                $("#job_seeker").submit();
            });

            button2.className="saveReturnLater-button-active lfloat";
        }
    }
	
	
}

function checkForSaveReturnButton(){
    /*Added later for solving JFS-544*/
    firstName = document.getElementById('job_seeker_first_name');
    lastName = document.getElementById('job_seeker_last_name');
    email = document.getElementById('job_seeker_email');
    password = document.getElementById('job_seeker_password');
    rePassword = document.getElementById('job_seeker_password_confirmation');
    //pincode = document.getElementById('job_seeker_zip_code');
    city = document.getElementById('job_seeker_city');
    button3 = document.getElementById('snr_button');
	
    if((validateNotEmpty(email)) && validateEmail(email.value) && (validateNotEmpty(firstName)) && (validateNotEmpty(lastName)) && (validateNotEmpty(city) && $("#dropdown_flag").val()==1) ){
        if($("#"+password.id).parent().hasClass('input-text-active')||$("#"+password.id).parent().hasClass('active-input')){
            if(validatePassword(password.value)){
                if($("#"+rePassword.id).parent().hasClass('input-text-active')||$("#"+rePassword.id).parent().hasClass('active-input')||$("#"+rePassword.id).parent().hasClass('input-text-error')){
                    if(password.value == rePassword.value){
                        $("#snr_button").unbind().click(function() {
                            set_save_type('saveandreturn');
                            $("#job_seeker").submit();
                        });
						
                        //button3.disabled = "";
                        button3.className = "saveReturnLater-button-active lfloat";
                    }
                    else{
                        $("#snr_button").unbind().click(function() {
                            validateJobSeekerNewOnInactiveButtonClickSnR();
                        });
						
                        //button3.disabled = "disabled";
                        button3.className = "saveReturnLater-button-active lfloat";
                    }
                }
                else{
                    $("#snr_button").unbind().click(function() {
                        validateJobSeekerNewOnInactiveButtonClickSnR();
                    });
					
                    //button3.disabled = "disabled";
                    button3.className = "saveReturnLater-button-active lfloat";
                }
				
            }
            else{
                $("#snr_button").unbind().click(function() {
                    validateJobSeekerNewOnInactiveButtonClickSnR();
                });
				
                //button3.disabled = "disabled";
                button3.className = "saveReturnLater-button-active lfloat";
            }
        }
        else{
            $("#snr_button").unbind().click(function() {
                validateJobSeekerNewOnInactiveButtonClickSnR();
            });
			
            //button3.disabled = "disabled";
            button3.className = "saveReturnLater-button-active lfloat";
        }
    }
    else{
        $("#snr_button").unbind().click(function() {
            validateJobSeekerNewOnInactiveButtonClickSnR();
        });
		
        //button3.disabled = "disabled";
        button3.className = "saveReturnLater-button-active lfloat";
    }
}

function validatePasswordOnKeyUp(password) {
    var value = $(password).val();
    var error_element = document.getElementById('error_type');
	
	
    if(validatePasswordForSpecialCharacters(value) && ($("#"+password.id).parent().hasClass("input-text-active") || $("#"+password.id).parent().hasClass("input-text-error"))) {
        errorBox = document.getElementById('error_msg');
        if(error_element.value=="pass_spl") {
            $("#"+password.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-active");
            errorBox.innerHTML = "";
            error_element.value="";
        }
    }
    else {
        if(value.length>0) {
            if($("#"+password.id).parent().hasClass("input-text-active")) {
                errorBox = document.getElementById('error_msg');
                if(error_element.value=="") {
                    $("#"+password.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-error");
                    errorBox.innerHTML = "Please, no special characters.";
                    error_element.value="pass_spl";
                }
            }
        }
    }
}

/******** End of functions for account setup page ***********/


/******** Function for Questionaire page ******/

function showBirkmanPopup() {
    $("#form_details").show();
    $("#form_details").focus();
    showNormalShadow();
    centralizePopup();
}
function hideBirkmanPopup() {
    $.ajax({
        url: "/questionnaire/clear_pass_through",
        cache: false,
        success: function(){
                
        }
    });
    $("#form_details").hide();
    //centralizePopup();
    hideNormalShadow();
}

function showIntroductaryPopup() {
    $("div#setOnePopup").show();
    showNormalShadow();
    centralizePopup();
    addFocusButton('setOnePopup_button');
}

function hideIntroductaryPopup() {
    $("div#setOnePopup").hide();
    hideNormalShadow();
}

function showSetNumber(setNo) {
    if(setNo == "true") {
        $("span#setNumber").html("1 of 4");
    }
}

function showSetTwoIntroductaryPopup() {
    $("div#setTwoPopup").show();
    showNormalShadow();
    centralizePopup();
    addFocusButton('setTwoPopup_button');
}

function hideSetTwoIntroductaryPopup() {
    $("div#setTwoPopup").hide();
    hideNormalShadow();
}

function showSetThreeIntroductaryPopup() {
    $("div#setThreePopup").show();
    showNormalShadow();
    centralizePopup();
    addFocusButton('setThreePopup_button');
}

function hideSetThreeIntroductaryPopup() {
    $("div#setThreePopup").hide();
    hideNormalShadow();
}

function showSetFourIntroductaryPopup() {
    $("div#setFourPopup").show();
    showNormalShadow();
    centralizePopup();
    addFocusButton('setFourPopup_button');
}

function hideSetFourIntroductaryPopup() {
    $("div#setFourPopup").hide();
    hideNormalShadow();
}

function showVerifySuccess() {
    $('#verify_success').show();
    showSuccessShadow();
    centralizePopup();
    $('#verify_success_button').focus();
}
function hideVerifySuccess() {
    $('#verify_success').hide();
    hideSuccessShadow();
    $("div#setOnePopup").show();
    showNormalShadow();
    centralizePopup();
    addFocusButton('setOnePopup_button');
}
function showVerifyError() {
    $('#verify_failure').show();
    showErrorShadow();
    centralizePopup();
    $('#verify_failure_button').focus();
}
function hideVerifyError() {
    $('#verify_failure').hide();
    hideErrorShadow();
    centralizePopup();
}
function showYes(){
    $('#birkman_form').show();
    $('#button1').show();
    $('#text1_yes').show();
    $('#birkman_logo').hide();
    $('#text1_no').hide();
    $('#text2_no').hide();
    $('#text3_no').hide();
    $('#text4_no').hide();
    $('#button2').hide();
    $(".no").attr("checked", "checked");
    Custom.check($(".options-list li.no span.checkbox"));
    if(!$("#y").attr("checked")) {
        $(".yes").removeAttr("checked");
        Custom.check($(".options-list li.yes span.checkbox"));
    }
    document.getElementById("birkman_id").focus();
    $("#verify_button").unbind('click').bind('click',function(){
		
		
        if(validateEmptyVerifyBirkman()){
			
        }
        else{
            $("#verify_form").submit();
        }
		
    });
	
	
}
  
function showNo(){
    $('#birkman_logo').show();
    $('#text1_no').show();
    $('#text2_no').show();
    $('#text3_no').show();
    $('#text4_no').show();
    $('#button2').show();
    $('#birkman_form').hide();
    $('#button1').hide();
    $('#text1_yes').hide();
    $(".yes").attr("checked", "checked");
    Custom.check($(".options-list li.yes span.checkbox"));
    if(!$("#n").attr("checked")) {
        $(".no").removeAttr("checked");
        Custom.check($(".options-list li.no span.checkbox"));
    }
    addFocusButton('button-container-retake');
}

function retry_birkman_id(){
    $('#verify_failure').hide();
    $('#form_details').show();
    $('#form_details').focus();
    $('#fade_error').hide();
    $('#fade_normal').show();
}
  
function showForgotBirkmanPopup(){
    $('#forgot_birkman_id').show();
    $('#enter-ques').focus();
    showNormalShadow();
    centralizePopup();
}

function hideForgotBirkmanPopup(){
    $('#forgot_birkman_id').hide();
    hideNormalShadow();
} 
 
function work_env_questionnaire(){
    $('#verify_success').hide();
    $('#fade_success').hide();
}
  
function buttonActivation(){
    if(($('#first_name').val() != "") && $('#first_name').parent().attr('class') != "customized-input input-text" && ($('#last_name').val() != "") && $('#last_name').parent().attr('class') != "customized-input input-text" && ($('#email').val() != "") && $('#email').parent().attr('class') != "customized-input input-text" && ($('#birkman_id').val() != "") && $('#birkman_id').parent().attr('class') != "customized-input input-text-unactive" && validateBirkmanEmail($('#email').val()))
    {
        //document.getElementById('verify_button').disabled="";
        document.getElementById('verify_button').className="verify-button-active";
    }
    else{
        //document.getElementById('verify_button').disabled="disabled";
        document.getElementById('verify_button').className="verify-button-active";
    }
}
  
function validateBirkmanEmail(value) {
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value)){
        return true;
    }
    return false;
}

function closeRetake(){
    $('#form_details').hide();
    $('#fade_normal').hide();
	
}
  
function retake(){
    $('#forgot_birkman_id').hide();
    $('#fade_normal').hide();
}
/******** End of function for Questionaire page ****** /

/*Start - Congratulation popup*/
function show_congratulation_popup(job_id, pay_for){
    $.ajax({
        url: '/ajax/check_for_job_link',
        type: "POST",
        data: {
            job_id: job_id
        },
        cache: false,
        success:function(data){
            clearInterval(timer);
            $("#cc_billing_popup").hide();
            $("#cc_billing_popup").empty();
            $('#position_details').empty();
            $('#fade_normal_warning').hide();
            $('#congratulation_popup').show();
            $("#summary").val('');
            $("#summary").blur();
            $("#count_holder").html('550');
            $('#fade_error_warning').hide();
            hideNormalShadow();
            hideErrorShadow();
            hideBlockShadow();
            showSuccessShadow();
            //stopAjax();
            centralizePopup();
            if(pay_for == "interest" || pay_for == "wild" || pay_for == "interest_excluded" || pay_for == "wild_excluded"){
                var count = $(".interested").html();
                count = parseInt(count);
                $(".interested").html(count+1);

                count = $(".considering").html();
                count = parseInt(count);
                $(".considering").html(count-1);

                if($(".considering").parent().parent().hasClass('active')){
                    $('.table-headings').children().each(function(){
                        if($(this).hasClass('active')){
                            if($(this).children().hasClass('decActive')){
                                order = 'desc';
                            }
                            else{
                                order = 'asc';
                            }
                            sort = $(this).children().attr('title').toLowerCase();
                        }
                    })
                    fetch_jobs.call('considering',sort,order);
                }


                $("#job_row_"+job_id).find('img.deactivated-green').attr('width','16');
                $("#job_row_"+job_id).find('img.deactivated-green').attr('height','16');
                $("#job_row_"+job_id).find('img.deactivated-green').attr('alt','Green');
                $("#job_row_"+job_id).find('img.deactivated-green').attr('src','/assets/green-bullet.png?1323171809');
                //$("#job_row_"+job_id).find('img.deactivated-yellow').html("<img width='16' height='16' class='active-yellow' src='/assets/yellow-bullet.png?1323171809' alt='Yellow'>");
                $("#job_row_"+job_id).find('img.deactivated-green').addClass('active-green').removeClass('deactivated-green');
            }
            if ( data == "NULL") {
                $('#congratulation_popup #without-job-link-content').show();
                $('#congratulation_popup #with-job-link-content').hide();
                $("#continue-button").unbind().click(function(){
                    if(validateNotEmpty(document.getElementById('summary'))) {
                        showBlockShadow();
                        $.ajax({
                            url: '/ajax/save_cover_note',
                            type: "POST",
                            data: {
                                cover_note: $("#summary").val(),
                                job_id: job_id
                            },
                            cache: false,
                            success:function(){
                                hideBlockShadow();
                            }
                        });
                    }
                });
            } else {
                $('#congratulation_popup #without-job-link-content').hide();
                $('#congratulation_popup #with-job-link-content').show();
                $("#apply-via-button").unbind().click(function(){
                    window.open(data);
                });
            }
        }
    });
}

function close_congratulation_popup(){
    $('#congratulation_popup').hide();
    $('#fade_success').hide();
    $('#fade_normal').hide();
}
/* End - Congratulation popup*/
/*Start - Apply Promo Code*/

function _applyPromoCode(){
    //$("#coderequest_promotional_code").val("Enter promotional or gift code");
    //$('#coderequest_promotional_code').parent().removeClass('input-text input-text-active active-input input-text-error');
    //$('#coderequest_promotional_code').parent().addClass('input-text');
    $('#coderequest_promotional_code').val('');
    $('#coderequest_promotional_code').parent().removeClass('input-text-error-empty');
    blur_element(document.getElementById('coderequest_promotional_code'));
    $('#get_promo_code_popup').show();
    $('#verify_button').show();
    $('#beta-loader-img').hide();
    button = document.getElementById('verify_button');
    button.className = "apply-button-active rfloat";
    //button.disabled="disabled";
	
    $("#verify_button").unbind('click').bind('click', function(){
        if(validateEmptyDiscount()){ }
        else {
            $("#beta-loader-img").show();
            $("#verify_button").hide();
            showBlockShadow();
            $("#discount_form").submit();
        }
    });
}

function _closeApplyPromoCode(){
    $('#get_promo_code_popup').hide();
    $('#fade_normal').hide();
    $('#div_promo_code').show();
}

function showLoader(){
    //$("#fade_normal").show();
    $(".popup-loader").show();
}

function hideLoader(){
    $(".popup-loader").hide();
//$("#fade_normal").hide();
	
}

function validatePromoCode(element){	
    //promo_code = element.value;
    button = document.getElementById('verify_button');
    if (validateNotEmpty(element)) {
        button.className = "apply-button-active rfloat";
    //button.disabled="";
    }
    else	{
        button.className = "apply-button-active rfloat";
    //button.disabled="disabled";
    }
        
	
}
/*End - Apply Promo Code*/

/*Start - Confirmed Promo Code*/
function _confirmedCode(){	
    $('#code_confirmed_popup').show();
    $('#fade_normal').show();
}

function _closeConfirmedCode(){
    $('#code_confirmed_popup').hide();
    hideSuccessShadow();
    _applyPromoCode();
}
/*End - Apply Promo Code*/


/*Start - CCBillingInfo*/

//Payment popup should come here
function _openCCBillingInfo(card_type){
    $('#payment_header').text("CREDIT CARD BILLING INFORMATION");
    $('#card_num').val('Credit Card Number');
    $('#activ_cc_number').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_cc_number').addClass('input-text');
		
    $('#month').val('mm');
    $('#activ_month').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_month').addClass('input-text');
		
    $('#year').val('yyyy');
    $('#activ_year').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_year').addClass('input-text');
		
    $('#cvv').val('Security Code');
    $('#cvv').parent().removeClass('active-input input-text-error-empty input-text-error');
    $('#cvv').parent().addClass('input-text');
    changeInputType(document.getElementById("cvv"),"text","");
		
    $('.state-slector .label-default').text('State');
    $(".state-slector").removeClass("error");
    $("#billing_state").val("");
		
    $('#fname').val('First Name');
    $('#activ_fname').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_fname').addClass('input-text');
		
    $('#lname').val('Last Name');
    $('#activ_lname').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_lname').addClass('input-text');
		
    $('#billing_address_one').val('Billing Address');
    $('#activ_billing_address_one').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_billing_address_one').addClass('input-text');
		
    $('#billing_address_two').val('Apt., suite, bldg.');
    $('#activ_billing_address_two').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_billing_address_two').addClass('input-text');
		
    $('#billing_city').val('City');
    $('#activ_city').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_city').addClass('input-text');
		
    $("#state-selector span.label-default").css("color","#7F7FBB");
		
    $('#billing_zip').val('Zip Code');
    $('#activ_zipcode').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_zipcode').addClass('input-text');
		
    $('#billing_area_code').val('(Area Code)');
    $('#activ_areacode').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_areacode').addClass('input-text');
		
    $('#billing_telephone_number').val('Telephone');
    $('#activ_telephone').removeClass('active-input input-text-error-empty input-text-error');
    $('#activ_telephone').addClass('input-text');
		
    $('#paypal_error_msg').empty();
    $('#cc_billing_popup').show();
    $("#payment-options").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
    $('#fade_normal').show();
    $('#jw_player').hide();
    centralizePopup();

    $("#payment_verify_button").unbind('click').bind('click', function(){
        if (!validateEmptyPayment()){
            $("#payment_billing_popup").submit();
        }
        else{
            $('#payment_header').text("UNABLE TO VERIFY");
            
            $("#paypal_error_msg_payment").show();
            $("#paypal_error_msg_payment").html("Please complete the areas highlighted in red.");
            
            $("#paypal_error_msg").show();
            $("#paypal_error_msg").html("Please complete the areas highlighted in red.");

            var payment_card_type = document.getElementById('payment_card_type');
            if (payment_card_type.value == ''){
                $("#paypal_error_msg_payment").show();
                $("#paypal_error_msg_payment").html("Please select one payment option.");
            }
        }
    })
}

function redirectToPaypal(){
    window.location.href = "/payment/make_payment?payment_type=paypal_express";
}

function redirectToPaypal_job_payment(){
    showBlockShadow();
    window.location.href = "/job_payment/paypal_payment?change_payment="+$("#change_payment").val();
}

function redirectToPaypal_gifthilo(){
    url = $("#page_url_job").val();
    showBlockShadow();
    window.location.href = "/gift/gift_hilo_payment?payment_type=paypal_express&url=" + url;
}

function setCardType(card_type) {
    if(card_type == "master") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='master' id='master_card' />");
        $('#payment_card_type').val('master');
        $("#payment-options").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num").attr('maxlength', 16);
        $("#cvv").attr('maxlength', 3);
        $('#payment_details_text').show();
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
        $("#textToHide").show();
    } else if(card_type=="visa") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='visa' id='visa' />");
        $('#payment_card_type').val('visa');
        $("#payment-options").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num").attr('maxlength', 16);
        $("#cvv").attr('maxlength', 3);
        $('#payment_details_text').show();
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
        $("#textToHide").show();
    } else if(card_type == "american_express") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='american_express' id='american_express' />");
        $('#payment_card_type').val('american_express');
        $("#payment-options").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num").attr('maxlength', 15);
        $("#cvv").attr('maxlength', 4);
        $('#payment_details_text').show();
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
        $("#textToHide").show();
    }
    else if(card_type == "discover") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='discover' id='paypal' />");
        $('#payment_card_type').val('discover');
        $("#payment-options").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num").attr('maxlength', 16);
        $("#cvv").attr('maxlength', 3);
        $('#payment_details_text').show();
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
        $("#textToHide").show();
    }
    else if(card_type == "paypal") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='paypal' id='paypal' />");
        $("#payment-options").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
        $('#payment_details_text').hide();
        $("#credit-card-info").hide();
        $("#personal-info").hide();
        $("#paypal-info").show();
        $("#textToHide").hide();
    }
	
    $('#cvv').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#cvv').parent().addClass('input-text');
    changeInputType(document.getElementById("cvv"),"text","");
    $('#cvv').val('Security Code');
	
    $('#card_num').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#card_num').parent().addClass('input-text');
    $('#card_num').val('Credit Card Number');
    //$('#paypal_error_msg').hide();
	
    $('#month').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#month').parent().addClass('input-text');
    $('#month').val('mm');
    
    $('#year').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#year').parent().addClass('input-text');
    $('#year').val('yyyy');
    
    validateCreditCardInfo();
	
}



function _closeCCBillingInfo(){
    if(document.getElementById("page-container-siteActivation")) {
        $('#cc_billing_popup').hide();
        $('#payment_details_text').hide();
        $('#credit-card-info').hide();
        $("#personal-info").hide();
        $("#paypal-info").hide();
    //$('#payment_verify_button').removeClass("verify-button-active").addClass("verify-button");
    }
    else {
        $('#cc_billing_popup').empty();
        $('#cc_billing_popup').hide();
    }
    $('#fade_normal').hide();
    $('#jw_player').show();
    if($('div#fade_success').is(":visible")==true)
        $('div#fade_success').hide();
    if($('div#fade_error').is(":visible")==true)
        $('div#fade_error').hide();
}
/*End - By Sushant - CCBillingInfo*/

/*Start - By Sushant - PaypalPopup*/
function _openPaypalPopup(){	
    $('#paypal_popup').show();
    $('#fade_normal').show();
}

function _closePaypalPopup(){
    $('#paypal_popup').hide();
    $('#fade_normal').hide();
}
/*End - By Sushant - PaypalPopup*/

/* Start - By Sushant - set Card type */
function changeCardType(card_type){
    if(card_type == "master") {
        $('#card_entry_form').append('<input type="hidden" name="card_type" id="card_type" value="master" />');
    //$("#card_type").val = card_type;
    }
    else if(card_type == "visa") {
        if($("#card_type").val == "master") {
        }
        $('#card_entry_form').append('<input type="hidden" name="card_type" value="visa" />');
    //makeHiddenFieldEmpty($("#card_type"));
    }
    else if(card_type == "american_express") {
        $('#card_entry_form').append('<input type="hidden" name="card_type" value="american_express" />');
    }
//$('#card_type').val = card_type;
}

function makeHiddenFieldEmpty(card_type){
    card_type.val = nil;
}
/* End - By Sushant - set Card type */

$(function(){
	
    $('.retry').click(function(){
        $('#fade_normal').css('display','block');
        $('#fade_error').css('display','none');
        $('.home-popup-contnet').css('display','block');
        $('.home-popup-error').css('display','none');
    });
	
    $('.pswd-block input').focus(function(){
        $('.pswd-block span.dummyValue').css('display','none');
    });
	
    $('.pswd-block input').focusout(function(){
        var _value = $(this).val();
        if(_value == ''){
            $('.pswd-block span.dummyValue').css('display','block');
        }
    });
	
    $('.workenv-options li a').click(function(){
        $(this).parents('ul.workenv-options').find('a.active').removeClass('active');
        $(this).parents('ul.workenv-options').find('a.default').addClass('moderately');
        $(this).parents('ul.workenv-options').find('a.default').removeClass('default');
        $(this).addClass('active');
    });

    $('.options-trueNfalse .options a').click(function(){
        $(this).parent('div.options').find('a.active').removeClass('active');
        $(this).addClass('active');
    });
	
});
//added activate-deactivate divs for payment
$('div.promo-code').live("click", function() {
    if($('div.paypal').hasClass('activeBlock')) {
        $('div.paypal').removeClass('activeBlock');
    }
    $(this).addClass('activeBlock');
});

$('div.paypal').live("click", function() {
    if($('div.promo-code').hasClass('activeBlock')) {
        $('div.promo-code').removeClass('activeBlock');
    }
    $(this).addClass('activeBlock');
});
//code for activate-deactivate divs ends here
// JS for Credentials

// End of JS for credentials 


/***************** Functions for dashboard page *******************/



function resizeTable() {
    var wid = [48, 70, 160, 118, 119, 96, 65];
    var i = 0;
    if($("table#list").height()>$("#table_block").height()){
        $('table#list').attr('width','100%');
        $('table#list').find('th').each(function(){
            $(this).attr('width',wid[i]);
            i = i+1;
        })
    }
}
function sliderInit() {
    $(".right-arrow").click(function(){
        var obj = $("#outer-listing #listing ul li:first");
        $("#outer-listing #listing ul").append(obj);
    });
    $(".left-arrow").click(function(){
        $("#outer-listing  #listing ul ").prepend($("#listing ul li:last"));
    });
}
function removeButton() {
    $('.notifications ul li').hover(function(){
        $('a.remove',this).css('display','block')
    },function(){
        $('a.remove',this).css('display','none')
    });
}
function showPDFDowloadError() {
    showErrorShadow();
    $("#pdf_error").show();
    addFocusButton('pdf_error_button');
}
function hidePDFDowloadError() {
    hideErrorShadow();
    $("#pdf_error").hide();
}
var last_id = 0;
function showNotification() {
    last_id = 0;
    var _offset = $('a.notification-count').offset();
    var _height = $('#xref-tooltip').height();
    var _width =  $('#xref-tooltip').width();
    var _left = _offset.left-_width/2-89;
    var _top = _offset.top-_height+100;
     
     
    $("#fade_normal_status").show();
    $(".popup-loader-light").show();
    var ajax_var = $.ajax({
        url: '/account/fetch_notifications',
        data: "",
        cache: false,
        timeout: normal_timeout,
        error: function() {
            $("#fade_normal_status").hide();
            $(".popup-loader-light").hide();
            ajax_var.abort();
            hideNormalShadow();
            showAjaxErrorPopup();
        },
        success:function(html_data){
            $(".notification-count").html("0");
            $(".popup-loader-light").hide();
            $("#notification").html(html_data);
            $("#fade_normal_status").show();
            $('.notification-block').css({
                left:_left,
                top:_top
            });
            $(".notification-block").show();
            removeButton();
            $(".viewAll").click(function(e){
                $(".viewAll").hide();
                $(".viewAll_container").hide();
                $('.notifications').slimscroll({
                    railVisible: true,
                    allowPageScroll: true
                });
                $(".notifications").css({
                    'height':'314px'
                });
                $(".notifications").scrollTop(0);
                var scrollM = $(".notifications").scrollTop();
                var scrollT = $(".notifications").scrollTop();
                var id = fetch_last_notification_id();
                $(".notifications").unbind("scroll").scroll(function(){
                    showNotificationRows(scrollT,scrollM,id,5);
                });
                e.stopPropagation();
            });
            $('.notification-block').click(function(e) {
                e.stopPropagation();
            });
        }
    });
}

function fetch_last_notification_id() {
    var id_temp = $("#notification_rows li").last().attr('id');
    id_temp = id_temp.split('_');
    var id = id_temp[0];
    return id;
}
function showNotificationRows(scrollT,scrollM,start,limit) {
    var id = fetch_last_notification_id();
	
    if($(".notifications").scrollTop()<scrollT) {
    //No need to fire
    }
    else if($(".notifications").scrollTop()<=scrollM) {
    //No need to fire
    }
    else if(last_id==id) {
	
    }
    else {
        last_id = id;
        var scrollM_old = scrollM;
        var scrollT_old = scrollT;
        scrollM = $(".notifications").scrollTop();
        scrollT = $(".notifications").scrollTop();
        $(".notifications").unbind("scroll").scroll(function(){
            showNotificationRows(scrollT,scrollM,id,limit);
        });
        $("#rows_loader_notifications").show();
        $.ajax({
            url: '/account/fetch_notifications',
            data: "start=" + id + "&limit=" + limit + "&scroll=true",
            cache: false,
            success:function(html_data){
                $("#notification_rows").append(html_data);
                removeButton();
                $("#rows_loader_notifications").hide();
            }
        });
    }
	
	
}
function updateNotificationCount() {
	 
    $.ajax({
        url: '/account/fetch_notifications_count',
        data: "",
        cache: false,
        success:function(html_data){
            $(".notification-count").html(html_data);
        }
    });
	
}
function deleteNotification(id) {
    //alert(2);
    showBlockShadow();
    $.ajax({
        url: '/account/remove_notifications',
        data: "n_id="+id,
        cache: false,
        success:function(){
            hideBlockShadow();
            updateNotificationCount();
            $("#"+id+"_notification").remove();
            var id2 = fetch_last_notification_id();
			
            $.ajax({
                url: '/account/fetch_notifications_one_more',
                data: "start=" + id2,
                cache: true,
                success:function(html_data){
                    //hideBlockShadow();
                    $("#notification_rows").append(html_data);
                    removeButton();
                //e.stopPropagation();
                }
            });
			
        }
    });
	
}

function hideNotification() {
    $("#fade_normal_status").hide();
    $(".notification-block").empty();
}
function hideStatusBlock() {
    $("#fade_normal_status").hide();
    $('.status-details').hide();
}

/***************** End of functions for dashboard page *******************/

function validateCreditCardInfo() {
    card_num = document.getElementById('card_num');
    month = document.getElementById('month');
    year = document.getElementById('year');
    cvv = document.getElementById('cvv');
    fname = document.getElementById('fname');
    lname = document.getElementById('lname');
    billing_address_one = document.getElementById('billing_address_one');
    billing_address_two = document.getElementById('billing_address_two');
    billing_city = document.getElementById('billing_city');
    billing_zip = document.getElementById('billing_zip');
    billing_area_code = document.getElementById('billing_area_code');
    billing_state = document.getElementById('billing_state');
    billing_telephone_number = document.getElementById('billing_telephone_number');
    payment_card_type = document.getElementById('payment_card_type');
    
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
        cvv_length = 4;
    }
    else{
        card_length = 16;
        cvv_length = 3;
    }
    
    if(validateNotEmpty(card_num) && validateNotEmpty(month)&& validateNotEmpty(year) && validateNotEmptyPassword(cvv) && validateNotEmpty(fname)&& validateNotEmpty(lname) && validateNotEmpty(billing_address_one) && validateNotEmpty(billing_city) && validateNotEmpty(billing_zip) && validateNotEmpty(billing_area_code)&& validateNotEmpty(billing_telephone_number) && validateRequired(billing_state.value) && (billing_telephone_number.value.length == 7)  && (card_num.value.length == card_length) && (billing_zip.value.length >= 3) && (billing_area_code.value.length == 3) && (cvv.value.length == cvv_length) && payment_card_type.value != ''){
        $("#paypal_error_msg").html("");
        $('#payment_header').text("CREDIT CARD BILLING INFORMATION");
        $("#paypal_error_msg").hide();
        button = document.getElementById('payment_verify_button');
        //button.disabled="";
        button.className="verify-button-active complete rfloat";

    }
    else{
        button = document.getElementById('payment_verify_button');
        //button.disabled="disabled";
        button.className="verify-button-active rfloat";
    }
}

function validateGiftCreditCardInfo() {
    card_num = document.getElementById('card_num_gift');
    month = document.getElementById('month_gift');
    year = document.getElementById('year_gift');
    cvv = document.getElementById('cvv_gift');
    fname = document.getElementById('fname_gift');
    lname = document.getElementById('lname_gift');
    billing_address_one = document.getElementById('billing_address_one_gift');
    billing_address_two = document.getElementById('billing_address_two_gift');
    billing_city = document.getElementById('billing_city_gift');
    billing_zip = document.getElementById('billing_zip_gift');
    billing_area_code = document.getElementById('billing_area_code_gift');
    billing_state = document.getElementById('billing_state_gift');
    billing_telephone_number = document.getElementById('billing_telephone_number_gift');
    payment_card_type = document.getElementById('gift_payment_card_type');
    
    paypalusername_gift = document.getElementById('paypalusername_gift');
    paypalpassword_gift = document.getElementById('paypalpassword_gift');
    
    password_gift = document.getElementById('username_gift');
    password_gift = document.getElementById('password_gift');    
    
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
        cvv_length = 4;
    }
    else{
        card_length = 16;
        cvv_length = 3;
    }
    
    if(validateNotEmpty(card_num) && validateNotEmpty(month)&& validateNotEmpty(year) && validateNotEmpty(cvv) && validateNotEmpty(fname)&& validateNotEmpty(lname) && validateNotEmpty(billing_address_one) && validateNotEmpty(billing_city) && validateNotEmpty(billing_zip) && validateNotEmpty(billing_area_code)&& validateNotEmpty(billing_telephone_number) && validateRequired(billing_state.value) && (billing_telephone_number.value.length == 7)  && (card_num.value.length == card_length) && (billing_zip.value.length >= 3) && (billing_area_code.value.length == 3) && (cvv.value.length == cvv_length) && payment_card_type.value != ''){
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="";
        button.className="buy-gift-button-active rfloat";
    }
    else{
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="disabled";
        button.className="buy-gift-button rfloat";
    }
}

function setImage(card_type, seeker_type){
    switch(card_type){
        case "master" :
            if(seeker_type == "giftHiloSeeker") {
                $('div#card_entry_form_gift').html("<input type='hidden' name='card_type' value='master' id='master_card' />");
                $('input#gift_payment_card_type').val('master');
                $("div#payment_images_gift").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"giftHiloSeeker\");'><img src='/assets/Visa_2.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"giftHiloSeeker\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"giftHiloSeeker\");'><img src='/assets/Discover_2.png' alt='Discover Card' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"giftHiloSeeker\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("input#card_num_gift").attr('maxlength', 16);
                $("input#cvv_gift").attr('maxlength', 3);
                setGiftCCPopupOptions();
            }else {
                $('#card_entry_form').html("<input type='hidden' name='card_type' value='master' id='master_card' />");
                $('#payment_card_type').val('master');
                $("#payment_images").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"otherCCPayment\");'><img src='/assets/Visa_2.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"otherCCPayment\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"otherCCPayment\");'><img src='/assets/Discover_2.png' alt='Discover Card' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"otherCCPayment\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("#card_num").attr('maxlength', 16);
                $("#cvv").attr('maxlength', 3);
                setOtherCCPopupOptions();
            }
            break;
        case "visa" :
            if(seeker_type == "giftHiloSeeker") {
                $('div#card_entry_form_gift').html("<input type='hidden' name='card_type' value='visa' id='master_card' />");
                $('input#gift_payment_card_type').val('visa');
                $("div#payment_images_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setImage(\"master\", \"giftHiloSeeker\");'><img src='/assets/Mastercard_2.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"giftHiloSeeker\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"giftHiloSeeker\");'><img src='/assets/Discover_2.png' alt='Discover Card'  /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"giftHiloSeeker\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("input#card_num_gift").attr('maxlength', 16);
                $("input#cvv_gift").attr('maxlength', 3);
                setGiftCCPopupOptions();
            }
            else  {
                $('#card_entry_form').html("<input type='hidden' name='card_type' value='visa' id='master_card' />");
                $('#payment_card_type').val('visa');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\", \"otherCCPayment\");'><img src='/assets/Mastercard_2.png' alt='Master Card'  border='0' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card'  /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"otherCCPayment\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"otherCCPayment\");'><img src='/assets/Discover_2.png' alt='Discover Card' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"otherCCPayment\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("#card_num").attr('maxlength', 16);
                $("#cvv").attr('maxlength', 3);
                setOtherCCPopupOptions();
            }
            break;
        case "american_express" :
            if(seeker_type == "giftHiloSeeker") {
                $('div#card_entry_form_gift').html("<input type='hidden' name='card_type' value='american_express' id='master_card' />");
                $('input#gift_payment_card_type').val('american_express');
                $("div#payment_images_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setImage(\"master\", \"giftHiloSeeker\");'><img src='/assets/Mastercard_2.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"giftHiloSeeker\");'><img src='/assets/Visa_2.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"giftHiloSeeker\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"giftHiloSeeker\");'><img src='/assets/Discover_2.png' alt='Discover Card'  /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"giftHiloSeeker\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("input#card_num_gift").attr('maxlength', 15);
                $("input#cvv_gift").attr('maxlength', 4);
                setGiftCCPopupOptions();
            } else {
                $('#card_entry_form').html("<input type='hidden' name='card_type' value='american_express' id='master_card' />");
                $('#payment_card_type').val('american_express');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\", \"otherCCPayment\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"otherCCPayment\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"otherCCPayment\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"otherCCPayment\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"otherCCPayment\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
                $("#card_num").attr('maxlength', 15);
                $("#cvv").attr('maxlength', 4);
                setOtherCCPopupOptions();
            }
            break;
        case "discover" :
            if(seeker_type == "giftHiloSeeker") {
                $('div#card_entry_form_gift').html("<input type='hidden' name='card_type' value='discover' id='master_card' />");
                $('input#gift_payment_card_type').val('discover');
                $("div#payment_images_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setImage(\"master\", \"giftHiloSeeker\");'><img src='/assets/Mastercard_2.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"giftHiloSeeker\");'><img src='/assets/Visa_2.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"giftHiloSeeker\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover'><img src='/assets/Discover_1.png' alt='Discover Card'  /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"giftHiloSeeker\");'><img src='/assets/Paypal_2.png' alt='Paypal' /></a></li>");
                $("input#card_num_gift").attr('maxlength', 16);
                $("input#cvv_gift").attr('maxlength', 3);
                setGiftCCPopupOptions();
            } else {
                $('#card_entry_form').html("<input type='hidden' name='card_type' value='discover' id='master_card' />");
                $('#payment_card_type').val('discover');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\", \"otherCCPayment\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"otherCCPayment\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"otherCCPayment\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"otherCCPayment\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"otherCCPayment\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
                $("#card_num").attr('maxlength', 16);
                $("#cvv").attr('maxlength', 3);
                setOtherCCPopupOptions();
            }
            break;
        case "paypal" :
            if(seeker_type == "giftHiloSeeker") {
                $('div#card_entry_form_gift').html("<input type='hidden' name='card_type' value='paypal' id='paypal' />");
                $("div#payment_images_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setImage(\"master\", \"giftHiloSeeker\");'><img src='/assets/Mastercard_2.png' alt='Master Card' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"giftHiloSeeker\");'><img src='/assets/Visa_2.png' alt='Visa Card' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"giftHiloSeeker\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"giftHiloSeeker\");'><img src='/assets/Discover_2.png' alt='Discover Card' /></a></li><li><a href='javascript:void(0);' title='Paypal'><img src='/assets/Paypal_1.png' alt='Paypal' /></a></li>");
                $('div#payment_details_gift_text').hide();
                $("div#credit-card-info_gift").hide();
                $("div#personal-info_gift").hide();
                $("div#paypal-info_gift").show();
            }
            else {
                $('#card_entry_form').html("<input type='hidden' name='card_type' value='paypal' id='paypal' />");
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\", \"otherCCPayment\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\", \"otherCCPayment\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\", \"otherCCPayment\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\", \"otherCCPayment\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\", \"otherCCPayment\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
                $('#payment_details_text').hide();
                $("#credit-card-info").hide();
                $("#personal-info").hide();
                $("#paypal-info").show();
                $("#textToHide").hide();
            }
            break;
    }

    if(seeker_type == "giftHiloSeeker") {
        $('#card_num_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#card_num_gift').parent().addClass('input-text');
        $('#card_num_gift').val('Credit Card Number');

        $('input#month_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('input#month_gift').parent().addClass('input-text');
        $('input#month_gift').val('mm');

        $('input#year_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('input#year_gift').parent().addClass('input-text');
        $('input#year_gift').val('yyyy');

        $('#cvv_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#cvv_gift').parent().addClass('input-text');
        changeInputType(document.getElementById("cvv_gift"),"text","");
        $('input#cvv_gift').val('Security Code');
        validateGiftCreditCardInfo();
    }
    else {
        $('#card_num').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#card_num').parent().addClass('input-text');
        $('#card_num').val('Credit Card Number');

        $('#month').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#month').parent().addClass('input-text');
        $('#month').val('mm');

        $('#year').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#year').parent().addClass('input-text');
        $('#year').val('yyyy');

        $('#cvv').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#cvv').parent().addClass('input-text');
        changeInputType(document.getElementById("cvv"),"text","");
        $('#cvv').val('Security Code');
        validateCreditCardInfo();
    }
}

function setGiftCCPopupOptions() {
    $('div#payment_details_gift_text').show();
    $("div#credit-card-info_gift").show();
    $("div#personal-info_gift").show();
    $("div#paypal-info_gift").hide();
    $("#textToHide").show();
}

function setOtherCCPopupOptions() {
    $('#payment_details_text').show();
    $("#credit-card-info").show();
    $("#personal-info").show();
    $("#paypal-info").hide();
    $("#textToHide").show();
}

function activate_one_click(checkout) {
    if(document.getElementById("pay_name") && document.getElementById("pay_pass")) {
        email = document.getElementById("pay_name").value;
        password = document.getElementById("pay_pass").value;
        pass_element = document.getElementById("pay_pass");
        button = document.getElementById("confirm_button");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            button.className="btn-Confirm-active rfloat";
        //button.disabled="";
        }
        else {
            button.className="btn-Confirm rfloat";
        //button.disabled="disabled";
        }
    }
}

function activate_confirm(current_element) {
    reg_user_name_gift = document.getElementById('reg_user_name_gift');
    reg_user_pass_gift = document.getElementById('reg_user_pass_gift');
	
    if(validateNotEmpty(reg_user_name_gift) && validateNotEmpty(reg_user_pass_gift)) {
        button = document.getElementById('reg_confirm_gift_button');
        //button.disabled="";
        button.className="btn-Confirm-active rfloat";

    }
    else{
        button = document.getElementById('reg_confirm_gift_button');
        //button.disabled="disabled";
        button.className="btn-Confirm rfloat";
    }
}

function showAjaxErrorPopup() {
    showErrorShadow();
    $("#ajax_error").show();
    centralizePopup();
    addFocusButton('ajax_error_button');
}
function hideAjaxErrorPopup() {
    hideErrorShadow();
    $("#ajax_error").hide();
}
function showAjaxPaymentErrorPopup() {
    hideNormalShadow();
    $("#position_overview").hide();
    $("#position_overview").empty();
    $("#position_details").hide();
    $("#position_details").empty();
    showErrorShadow();
    $("#ajax_payment_error").show();
    centralizePopup();
    addFocusButton('ajax_payment_error_button');
}
function hideAjaxPaymentErrorPopup() {
    hideErrorShadow();
    $("#ajax_payment_error").hide();
}

function showPdfAjaxError() {
    hideNormalShadow();
    showErrorShadow();
    $(".popup-loader").hide();
    $("#pdf_ajax_error").show();
    centralizePopup();
    addFocusButton('pdf_ajax_error_button');
}
function hidePdfAjaxError() {
    hideErrorShadow();
    $(".popup-loader").hide();
    $("#pdf_ajax_error").hide();
}

function paymentHandlerStart() {
    hideErrorShadow();
    showNormalShadow();
    $('#payment_header').text("CREDIT CARD BILLING INFORMATION");
    $('#paypal_error_msg').empty();
    $("#payment-options-dummy").show();
    $("#payment-options").hide();
    document.getElementById('payment_close').onclick="function() {}";
    $('#payment_close').click(function() {

        });
}
function paymentHandlerStop() {
    $("#payment-options-dummy").hide();
    $("#payment-options").show();
    $('#payment_close').click(function() {
        
        _closeCCBillingInfo();
        
    });
}

function oneClickpaymentHandlerStart() {
    document.getElementById('preview_card_select').onclick="function() {}";
    $('#preview_card_select').click(function() {
			
        });
    document.getElementById('oneclick-close').onclick="function() {}";
    $('#oneclick-close').click(function() {
			
        });
}
function oneClickpaymentHandlerStop() {
    $('#preview_card_select').click(function() {
        click_payment.credit_card_show();
    });
    $('#oneclick-close').click(function() {
        hideNormalShadow();
        $('#position_overview').empty();
        job_detail_view.close();
    });
	
}

function loadCredentials() {
	
}
function activateForgotPassword(current_element) {
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    errorBox = document.getElementById('error_msg');
    if(current_element==password && (($("#"+password.id).parent().hasClass("active-input")) || ($("#"+password.id).parent().hasClass("input-text-active")) || ($("#"+password.id).parent().hasClass("input-text-error")) )) {
        if(password.value.length>0) {
            if(validatePassword(password.value)) {
                                          
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-active");
                        errorBox.innerHTML = "";
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-active");
                        errorBox.innerHTML = "";
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("active-input");
                    errorBox.innerHTML = "";
                }
            }
            else {
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-error");
                    errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                }

            }
        }
        else {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-active");
            errorBox.innerHTML = "";
        }
    }

    if(current_element==rePassword && (($("#"+rePassword.id).parent().hasClass("active-input")) || ($("#"+rePassword.id).parent().hasClass("input-text-active")) || ($("#"+rePassword.id).parent().hasClass("input-text-error")) )) {
        if(rePassword.value.length>0) {
            if(password.value==rePassword.value) {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("active-input");
                errorBox.innerHTML = "";
            }
            else {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-error");
                errorBox.innerHTML = "Passwords do not match. Please try again.";
            }
        }
        else {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-active");
            errorBox.innerHTML = "";
        }
    }
    checkForgotPasswordActivation();
}

function activateChangePassword(current_element){
    if(crack_for_IE==true) {
        crack_for_IE = false;
        return;
    }
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    errorBox = document.getElementById('error_msg');
    error_element = document.getElementById('lock');
	
    if(current_element==password && (($("#"+password.id).parent().hasClass("active-input")) || ($("#"+password.id).parent().hasClass("input-text-active")) || ($("#"+password.id).parent().hasClass("input-text-error")) )) {
        if(password.value.length>0) {
            if(validatePassword(password.value)) {
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-active");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML="";
                            error_element.value="";
                        }
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="repassword" || error_element.value=="") {
                            errorBox.innerHTML="Passwords do not match. Please try again.";
                            error_element.value="";
                        }
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-active");
                    if(error_element.value=="password" || error_element.value=="") {
                        errorBox.innerHTML="";
                        error_element.value="";
                    }
                }
            }
            else {
                if(($("#"+rePassword.id).parent().hasClass("active-input"))  || ($("#"+rePassword.id).parent().hasClass("input-text-error")) ) {
                    if(password.value==rePassword.value) {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("active-input");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                            error_element.value="password";
                        }
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-error");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                            error_element.value="password";
                        }
                    }
                }
                else {
                    $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                    $("#"+password.id).parent().addClass("input-text-error");
                    if(error_element.value=="password" || error_element.value=="") {
                        errorBox.innerHTML = "<span>Six or more alphanumeric characters.</span>";
                        error_element.value="password";
                    }
                }
				
            }
        }
        else {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-active");
            if(error_element.value=="password" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
		
    if(current_element==rePassword && (($("#"+rePassword.id).parent().hasClass("active-input")) || ($("#"+rePassword.id).parent().hasClass("input-text-active")) || ($("#"+rePassword.id).parent().hasClass("input-text-error")) )) {
        if(rePassword.value.length>0) {
            if(password.value==rePassword.value) {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-active");
                if(error_element.value=="repassword" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
				
            //
            }
            else {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-error");
                if(error_element.value=="repassword" || error_element.value=="") {
                    errorBox.innerHTML = "Passwords do not match. Please try again.";
                    error_element.value="repassword";
                }
            }
        }
        else {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-active");
            if(error_element.value=="repassword" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
    checkChangePasswordActivation();
}

function validateChangePasswordOnKeyUp(value) {
    if(validatePasswordForSpecialCharacters(value) && ($("#"+password.id).parent().hasClass("input-text-active") || $("#"+password.id).parent().hasClass("input-text-error"))) {
        errorBox = document.getElementById('error_msg');
        $("#"+password.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-active");
        errorBox.innerHTML = "";
    }
    else {
        if($("#"+password.id).parent().hasClass("input-text-active")) {
            errorBox = document.getElementById('error_msg');
            $("#"+password.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-error");
            errorBox.innerHTML = "Please, no special characters.";
        }
		
    }
	
}
function enterButtonResetPassword(e) {
    var code = e.keyCode;
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    oldpassword = document.getElementById('old_password');
    errorBox = document.getElementById('error_msg');
    if(code == 13){
        if(validateNotEmpty(oldpassword) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value)){
            $("#change_password_form").submit();
        }
        else{
            password = document.getElementById('new_password');
            rePassword = document.getElementById('confirm_password');
            old_password = document.getElementById('old_password');
            errorBox = document.getElementById('error_msg');

            if(!validateNotEmpty(old_password)) {
                $("#"+old_password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+old_password.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
            if(!validateNotEmpty(rePassword)) {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
            if(!validateNotEmpty(password)) {
                $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+password.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
            document.activeElement.blur();
            return;
        }
    }
}

function checkChangePasswordActivation(e) {
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    oldpassword = document.getElementById('old_password');
    errorBox = document.getElementById('error_msg');
	
	
	
    if(validateNotEmpty(oldpassword) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value)) {
        button = document.getElementById('update2');
        //button.disabled="";
        button.className="update-button-active rfloat";
	    
        $("#update2").unbind().click(function(){
            $("#change_password_form").submit();
        });
	    
    }
    else {
        button = document.getElementById('update2');
        //button.disabled="disabled";
        button.className="update-button-active rfloat";
		
        $("#update2").unbind().click(function(){
            password = document.getElementById('new_password');
            rePassword = document.getElementById('confirm_password');
            old_password = document.getElementById('old_password');
            errorBox = document.getElementById('error_msg');
                    
            if(!validateNotEmpty(old_password)) {
                $("#"+old_password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+old_password.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
            if(!validateNotEmpty(rePassword)) {
                $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+rePassword.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
            if(!validateNotEmpty(password)) {
                $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+password.id).parent().addClass("input-text-error-empty");
                errorBox.innerHTML="Please complete the areas highlighted in red.";
            }
                    
        });
    }
}

function checkForgotPasswordActivation() {
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    if(validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value) ) {
        button = document.getElementById('submit_button_forgot_pass');
        //button.disabled="";
        button.className="update-button-active";
        return true;
    }
    else {
        button = document.getElementById('submit_button_forgot_pass');
        //button.disabled="disabled";
        button.className="update-button";
        return false;
    }
}

function removeEmailErrorOutline(){
    if($('#Email').parent().hasClass('input-text-error')){
        if(validateEmail($('#Email').val())){
            $('#Email').parent().removeClass('input-text-error').addClass('input-text-active');
        }
    }
}

function activateUpdateButton(e){
	
    var code = e.keyCode;
    if(code == 13 && $("#update1").hasClass('update-button-active')){
        $("#change_personal_details").submit();
    }
    if(code == 13)
        return;
	
    firstname = document.getElementById('first_name');
    lastname = document.getElementById('last_name');
    email = document.getElementById('Email');
	
    if(validateNotEmpty(firstname) && validateNotEmpty(lastname) && validateNotEmpty(email) && validateEmail(email.value)){
        button = document.getElementById('update1');
        //button.disabled="";
        button.className="update-button-active rfloat";
        $("#update1").unbind().click(function(){
            $("#change_personal_details").submit();
        });
		
    }
    else{
        button = document.getElementById('update1');
        //button.disabled="disabled";
        $("#update1").unbind().click(function(){
            firstname = document.getElementById('first_name');
            lastname = document.getElementById('last_name');
            if(!validateNotEmpty(firstname)) {
                $("#"+firstname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+firstname.id).parent().addClass("input-text-error-empty");
            }
            if(!validateNotEmpty(lastname)) {
                $("#"+lastname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+lastname.id).parent().addClass("input-text-error-empty");
            }
            if(!(validateNotEmpty(email))){
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("input-text-error-empty");
            }
            if(!validateEmail(email.value) && !$('#Email').parent().hasClass('input-text-error-empty')){
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("input-text-error");
            }
			
        });
        button.className="update-button-active rfloat";
		
    }
}

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_change_personal_details = function(){
        var firstname = document.getElementById('first_name');
        var lastname = document.getElementById('last_name');
        var email = document.getElementById('Email');
        if(!validateNotEmpty(firstname)){
            $("#"+firstname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+firstname.id).parent().addClass("input-text-error-empty");
            return false;
        }
        if(!validateNotEmpty(lastname)){
            $("#"+lastname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+lastname.id).parent().addClass("input-text-error-empty");
            return false;
        }
        if(!(validateNotEmpty(email))){
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error-empty");
            return false;
        }
        if(!validateEmail(email.value)){
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error");
            return false;
        }
        $('#update1').hide();
        $('#loader_name').show();
    }

    $("#change_personal_details")
    .bind("ajax:beforeSend", loading_change_personal_details)
});

function delete_resume(){
    /*
	var flag;
	var error = "";
     */
    /*
	if($("#intro-error").html()==""){
	       flag = true ;    
	}
     */
    /*
	if($("#submit-button-intro").hasClass("active")){
		flag = true ;    
        }
	else{
	       flag  = false;
	       error = $("#intro-error").html();
	}
	if($('#contact_email').parent().hasClass('input-text-active') || $('#contact_email').parent().hasClass('active-input') || $('#contact_email').parent().hasClass('input-text-error')){
                var contact_email = $('#contact_email').val();
	}
	else{
	       var contact_email = "";
	}
	if($('#phone_one').parent().hasClass('input-text-active') || $('#phone_one').parent().hasClass('active-input') || $('#phone_one').parent().hasClass('input-text-error')){
	       var phone_one = $('#phone_one').val();
	}
	else{
	       var phone_one = "";
	}
	if($('#area_code').parent().hasClass('input-text-active') || $('#area_code').parent().hasClass('active-input') || $('#area_code').parent().hasClass('input-text-error')){
	       var area_code = $('#area_code').val();
	}
	else{
	       var area_code = "";
	}
	if($('textarea#summary').parent().hasClass('input-text-active') || $('textarea#summary').parent().hasClass('active-input')){
	       var summary = $('#summary').val()
        }
        else {
	       var summary = "";
        }
	var preferred = $("#pref_one").attr("checked")==true?"first":"second";
	var armed_forces = $("#yes").attr("checked")==true?true:false;
	
	summary = summary.replace(/(\r\n)|(\n)/g, "~~~");
	summary = summary.replace(/'/g, " ");
     */
    $.ajax({
        url: '/account/delete_resume',
        cache: 'false',
        success: function(data){
            //window.location.href = "/account/delete_resume";
            $("#resume-ajax").html(data);
        }
                
    })
	
}

function delete_photo(){
    $.ajax({
        url: '/account/delete_photo',
        cache: 'false',
        success: function(data){
            $("#photo-ajax").html(data);
        }
    })
}

function uploadFailure(){
    $("#upload-error").show();
    showErrorShadow();
    centralizePopup();
}

function uploadFailurePhoto(){
    $("#upload-error").show();
    $("#photo_err_msg").show();
    $("#cv_err_msg").hide();
    showErrorShadow();
    centralizePopup();
}

function uploadFailureCv(){
    $("#upload-error").show();
    $("#cv_err_msg").show();
    $("#photo_err_msg").hide();
    showErrorShadow();
    centralizePopup();
}

function showAuthenticationPopup(){
    $("#auth_popup").show();
    $("#hilo_password").val("");
    $("#hilo_email").parent().removeClass("input-text-error-empty");
    $("#hilo_password").parent().removeClass("input-text-error-empty");
    blur_element(document.getElementById('hilo_password'));
    showNormalShadow();
    centralizePopup();
    $("#hilo_password").focus();
    $("#hilo_password").parent().removeClass('input-text-active').addClass('input-text-unactive');
    $('#enter_auth').show();
    $('#loader_img_auth').hide();
    BrowserDetect.init();
                    
    if ( BrowserDetect.browser == "Explorer" )
    {
		      
        document.getElementById('hilo_password').attachEvent('onkeydown', function(e){
            editorEvents(document.getElementById('hilo_password'), e);
        });
		      
    }
		    
    else if ( BrowserDetect.browser == "Chrome" || BrowserDetect.browser == "Safari" ){
        document.getElementById('hilo_password').addEventListener('keydown', function(e){
            editorEvents(document.getElementById('hilo_password'), e);
        }, false);
		      
    }
	
    /* Binding */
	
    $("#enter_auth").unbind('click').bind('click', function(){
        if(validateEmptyAuth()){
        }
        else{
            $("#auth_form").submit();
        }
    })

    $('#hilo_email').keydown(function(e){
        CatchTab('hilo_email', e);
        
    });
    $('#hilo_password').keydown(function(e){
        CatchTab('hilo_password', e);
        
    });
    $('#enter_auth').keydown(function(e){
        CatchTab('enter_auth', e);
        
    });

    setTimeout(authPopupPassFieldHandler,100);

}

function authPopupPassFieldHandler(){
    if($('#hilo_password').val() == "Hilo Password" && $('#hilo_password').parent().hasClass('input-text-error')){
        $('#hilo_password').parent().removeClass('input-text-error');
    }
}

function hideAuthenticationPopup(){
    $("#auth_popup").hide();
    hideNormalShadow();
    $('#hilo_email').unbind();
    $('#hilo_password').unbind();
    $('#enter_auth').unbind();
}

function toAccount(){
    window.location.href="/account/account_info";
}

function oldPassMismatch(){
    $('#update2').show();
    $('#loader_password').hide();
    $('#old_pass_mismatch').show();
    showErrorShadow();
    centralizePopup();
    addFocusButton('old_pass_mismatch_button');
}

function updateEmailExistErrorPopup(){
    $('#update1').show();
    $('#loader_name').hide();
    $('#update_emailexist_error_popup').show();
    showErrorShadow();
    centralizePopup();
    addFocusButton('update_emailexist_error_popup_button');
}
//var _image = "";

function showEmployerViewPopup(url){
    website_1 = document.getElementById('website_1');
    website_title_1 = document.getElementById('website_title_1');
    website_2 = document.getElementById('website_2');
    website_title_2 = document.getElementById('website_title_2');
    website_3 = document.getElementById('website_3');
    website_title_3 = document.getElementById('website_title_3');
	
    showNormalShadow();
    showLoader();
    //var _image = "";
    $.ajax({
        url: '/account/employer_view',
        cache: false,
        success: function(){
            hideLoader();
            $("#employer_view_popup").show();
            centralizePopup();
            /*
			if(_image=="") {
				_image = $('p#summary').html();
			}
			
			$('p#summary').empty();
			$('p#summary').append(_image);
             */
            var _textareaText = "";
            if($('textarea#summary').parent().hasClass('input-text-active') || $('textarea#summary').parent().hasClass('active-input')){
                _textareaText = $('textarea#summary').attr('value').replace(/\n\r?/g, '<br />');
                $('p#summary').append(_textareaText);
            }
            else {
                $('p#summary').append(_textareaText);
            }
            /*
			if($('#contact_email').parent().hasClass('input-text-active') || $('#contact_email').parent().hasClass('active-input') || $('#contact_email').parent().hasClass('input-text-error')){
				$('span#email-text').html($('#contact_email').val());
			}
			else {
				$('span#email-text').html("");
			}
             */
            if($('#armed_forces').val() == "true")
                $('#usVeteran').show();
            else
                $('#usVeteran').hide();
			
            $('span#email-text').html("");
            if($("#pref_one").attr("checked")==undefined){
                if($('#contact_email').parent().hasClass('input-text-active') || $('#contact_email').parent().hasClass('active-input') || $('#contact_email').parent().hasClass('input-text-error')){
                    $('span#email-text').html($('#contact_email').val());
                }
                else {
            //$('span#email-text').html("");
            }
            }
            else if($("#pref_two").attr("checked")==undefined){
                if(($('#area_code').parent().hasClass('input-text-active') || $('#area_code').parent().hasClass('active-input') || $('#area_code').parent().hasClass('input-text-error')) ) {
                    $('span#email-text').append($('#area_code').val());
                }
                if(($('#area_code').parent().hasClass('input-text-active') || $('#area_code').parent().hasClass('active-input') || $('#area_code').parent().hasClass('input-text-error')) && ($('#phone_one').parent().hasClass('input-text-active') || $('#phone_one').parent().hasClass('active-input') || $('#phone_one').parent().hasClass('input-text-error'))) {
                    $('span#email-text').append("-");
                }
                if(($('#phone_one').parent().hasClass('input-text-active') || $('#phone_one').parent().hasClass('active-input') || $('#phone_one').parent().hasClass('input-text-error'))){
                    $('span#email-text').append($('#phone_one').val());
                }
                else{
            //$('span#email-text').html("");
            }
            }
            var website_url;
            if(validateNotEmpty(website_1) && checkURL(website_1.value) && validateNotEmpty(website_title_1)){
                website_url = website_1.value;
                website_url = website_1.value.split("//");
                if(website_url[0] == "http:" || website_url[0] == "https:") {
                    website_url = website_1.value;
                }
                else {
                    website_url = "http://"+website_1.value;
                }
                $("#weblisitng").append('<a class="website_listing" target="_blank" href="'+website_url+'">'+website_title_1.value+'</a><br />');
            }
            if(validateNotEmpty(website_2) && checkURL(website_2.value) && validateNotEmpty(website_title_2)){
                website_url = website_2.value;
                website_url = website_2.value.split("//");
                if(website_url[0] == "http:" || website_url[0] == "https:") {
                    website_url = website_2.value;
                }
                else {
                    website_url = "http://"+website_2.value;
                }
                $("#weblisitng").append('<a class="website_listing" target="_blank" href="'+website_url+'">'+website_title_2.value+'</a><br />');
            }
            if(validateNotEmpty(website_3) && checkURL(website_3.value) && validateNotEmpty(website_title_3)){
                website_url = website_3.value;
                website_url = website_3.value.split("//");
                if(website_url[0] == "http:" || website_url[0] == "https:") {
                    website_url = website_3.value;
                }
                else {
                    website_url = "http://"+website_3.value;
                }
                $("#weblisitng").append('<a class="website_listing" target="_blank" href="'+website_url+'">'+website_title_3.value+'</a><br />');
            }
        }
    })
//$(".video-container").html($(".video").html());
//if($("#checkLoad").val()=="false" && url!="") {
//	setTimeout("loadPlayer('intro-video-box-view',315,208,'"+url+"')", 3000);
//	$("#checkLoad").val("true");
//}
}

function emptyVideoSection(){
    $("#employer_view_popup").empty();
}

function emptyFormSection(){
    $("#file_upload_ie").empty();
    $("#file_upload_ie").hide();
    hideNormalShadow();
}

function hideEmployerViewPopup(){	
    $('#employer_view_popup').hide();
    hideNormalShadow();
}

var open_video_edit = {
    toggle: function(){
        $("#myint-video-form").toggle();
    },
    reload: function(){
        //window.location.reload();
        window.location.href="/account/pairing_profile";
    }
}

function hideUrlContainer(){
    $("#url-container").hide();
}

function validateYouTubeVideoUrl() {
    var element = document.getElementById('youtube_url');
    var url = document.getElementById('youtube_url').value;
    var regex = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?$/;
    var regex_short_url = /^http:\/\/?youtu.be\/([a-zA-Z0-9]+)/;

    //http://www.youtube.com/watch?v=6dt5iQDxD8g
    //http://youtu.be/6dt5iQDxD8g

    if(!validateNotEmpty(element)){
        $(element).parent().removeClass('input-text-error').addClass('input-text-active');
    }
    if( regex.test(url) || regex_short_url.test(url) ) {
        $("#embed_button").addClass("active");
        $("#youtube_url").parent().removeClass('input-text-error').addClass('input-text-active');
        $("#embed_button").unbind().click(function(){
            $("#video_form").submit();
        })
        return true;
    }
    else {
        $("#embed_button").removeClass("active");
        $("#embed_button").unbind().click(function(){
            if(validateNotEmpty(document.getElementById('youtube_url'))) {
                $("#youtube_url").parent().removeClass('active-input').addClass('input-text-error');
            } else {
                $("#youtube_url").parent().removeClass('input-text').addClass('input-text-error-empty');
            }
        })
        return false;
    }
		
}
function validateYouTubeVideoUrlOnLoad() {
    var url = document.getElementById('youtube_url').value;
    var regex = /^http:\/\/(?:www\.)?youtube.com\/watch\?(?=.*v=\w+)(?:\S+)?$/;
    var regex_short_url = /^http:\/\/?youtu.be\/([a-zA-Z0-9]+)/;
    if(regex.test(url) || regex_short_url.test(url)) {

    } else {
        $("#embed_button").removeClass("active");
        $("#embed_button").unbind().click(function(){
            if(validateNotEmpty(document.getElementById('youtube_url'))) {
                $("#youtube_url").parent().removeClass('active-input').addClass('input-text-error');
            } else {
                $("#youtube_url").parent().removeClass('input-text').addClass('input-text-error-empty');
            }
        })
    }
}
	


function resetFields(){	
    //$("#old_password").val("");
    //$("#new_password").val("");
    //$("#confirm_password").val("");
    //blur_element(document.getElementById('old_password'));
    //blur_element(document.getElementById('new_password'));
    //blur_element(document.getElementById('confirm_password'));
    //$("#old_password").val($("#old_password_placeholder").val());
    //$("#new_password").val($("#new_password_placeholder").val());
    //$("#confirm_password").val($("#confirm_password_placeholder").val());
    //$("#old_password").attr("type", "text");
    //$("#new_password").attr("type", "text");
    //$("#confirm_password").attr("type", "text");
    document.getElementById('success_msg').innerHTML = "<span>Password Changed Successfully.</span>";
    //document.getElementById('update2').disabled="disabled";
    document.getElementById('update2').className="update-button-active rfloat";
    accountLoader();
}

function accountLoader(){
    $('#loader_name').hide();
    $('#loader_password').hide();
    $('#update1').show();
//disableUpdateButton();
}

function validateForSaveIntro(element) {
    email = document.getElementById('contact_email');
    button = document.getElementById('submit-button-intro');
    error = document.getElementById('intro-error');
    area_code = document.getElementById('area_code');
    error_type = document.getElementById('error_id');
    phone = document.getElementById('phone_one');
    website_1 = document.getElementById('website_1');
    website_title_1 = document.getElementById('website_title_1');
    website_2 = document.getElementById('website_2');
    website_title_2 = document.getElementById('website_title_2');
    website_3 = document.getElementById('website_3');
    website_title_3 = document.getElementById('website_title_3');
    error_type_website = document.getElementById('error_id_website');
    error_website = document.getElementById('error_msg_website');
	
    if(element == area_code) {
        if(validateNotEmpty(area_code)) {
            if(area_code.value.length==0) {
                $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+area_code.id).parent().addClass("input-text");
                if(error_type.value=="area_code" || error_type.value=="") {
                    error.innerHTML = "";
                    error_type.value="";
                }
            }
            else if(area_code.value.length!=3) {
                $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+area_code.id).parent().addClass("input-text-error");
                if(error.innerHTML.length==0) {
                    error.innerHTML = "Invalid area code.";
                    error_type.value="area_code";
					
                }
				
            }
            else {
                $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+area_code.id).parent().addClass("active-input");
                if(error_type.value=="area_code" || error_type.value=="") {
                    error.innerHTML = "";
                    error_type.value="";
                }
            }
        }
        else {
            $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
            $("#"+area_code.id).parent().addClass("input-text");
            if(error_type.value=="area_code" || error_type.value=="") {
                error.innerHTML = "";
                error_type.value="";
            }
        }
		
    }
    if(element == email) {
        if(validateNotEmpty(email)) {
            if(validateEmail(email.value)) {
                if(error_type.value=="email") {
                    error.innerHTML = "";
                }
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("active-input");
            }
            else {
                $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+email.id).parent().addClass("input-text-error");
                if(error.innerHTML.length==0 || error_type.value=="email") {
                    error.innerHTML = "Invalid email address format.";
                    error_type.value="email";
                }
            }
        }
        else {
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
            $("#"+email.id).parent().addClass("input-text-error-empty");
            if(error_type.value=="email") {
                error.innerHTML = "Contact Email is required.";
                error_type.value="email";
            }
            else if(error.innerHTML.length==0) {
                error.innerHTML = "Contact Email is required.";
                error_type.value="email";
            }
        }
		
    }
    if(element == phone) {
        if(validateNotEmpty(phone)) {
            if(phone.value.length==0) {
                $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+phone.id).parent().addClass("input-text-unactive");
                if(error_type.value=="phone" || error_type.value=="") {
                    error.innerHTML = "";
                    error_type.value="";
                }
            }
            else if(phone.value.length!=7) {
                $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+phone.id).parent().addClass("input-text-error");
                if(error.innerHTML.length==0) {
                    error.innerHTML = "Invalid telephone number.";
                    error_type.value="phone";
					
                }
				
            }
            else {
                $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+phone.id).parent().addClass("active-input");
                if(error_type.value=="phone" || error_type.value=="") {
                    error.innerHTML = "";
                    error_type.value="";
                }
            }
        }
        else {
            $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
            $("#"+phone.id).parent().addClass("input-text");
            if(error_type.value=="phone" || error_type.value=="") {
                error.innerHTML = "";
                error_type.value="";
            }
        }
		
    }
    var website_error_flag = true;
    if(element == website_1 || element == website_2 || element == website_3 ) {
        //checkURL
        if(validateNotEmpty(element)) {
            if(!checkURL(element.value)) {
                $("#"+element.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
                $("#"+element.id).parent().addClass("input-text-error");
                website_error_flag = false;
                if(error_type_website.value==element.id || error_type_website.value=="") {
                    error_website.innerHTML = "Please enter a valid website.";
                    error_type_website.value=element.id;
                }
            }
            else {
                $("#"+element.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
                $("#"+element.id).parent().addClass("active-input");
                if(error_type_website.value==element.id) {
                    error_website.innerHTML = "";
                    error_type_website.value= "";
                }
            }
        }
        else {
            $("#"+element.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-unactive");
            $("#"+element.id).parent().addClass("input-text");
            if(error_type_website.value==element.id) {
                error_website.innerHTML = "";
                error_type_website.value= "";
            }
        }
		
    }
	
    if(validateNotEmpty(website_1)) {
        if(!validateNotEmpty(website_title_1)) {
            website_error_flag = false;
        }
    }
    else {
        if(validateNotEmpty(website_title_1)) {
            website_error_flag = false;
        }
    }
	
    if(validateNotEmpty(website_2)) {
        if(!validateNotEmpty(website_title_2)) {
            website_error_flag = false;
        }
    }
    else {
        if(validateNotEmpty(website_title_2)) {
            website_error_flag = false;
        }
    }
	
    if(validateNotEmpty(website_3)) {
        if(!validateNotEmpty(website_title_3)) {
            website_error_flag = false;
        }
    }
    else {
        if(validateNotEmpty(website_title_3)) {
            website_error_flag = false;
        }
    }
	
	
    if(!validateHasError(website_1) && !validateHasError(website_2) && !validateHasError(website_3) && !validateHasError(website_title_1) && !validateHasError(website_title_2) && !validateHasError(website_title_3)) {
        if(error_type_website.value=="") {
            error_website.innerHTML = "";
            error_type_website.value= "";
        }
    }
		
    if(validateNotEmpty(email) && validateEmail(email.value)) {
		
        var error_flag = true;
		
        if(document.getElementById('pref_one').checked) {
            if(area_code.value.length == 3 && phone.value.length == 7){
                if(document.getElementById('change').value=="true" || element.className == "checkbox") {
                    $("#submit-button-intro").addClass("active");
                    //button.disabled="";
                    $("#submit-button-intro").unbind().click(function() {
                        validateProfileIntroOnInactiveButton();
                        submitForm();
                    });
                }
            }
            else{
                //button.disabled="disabled";
                $("#submit-button-intro").removeClass("active");
                $("#submit-button-intro").unbind().click(function() {
                    validateProfileIntroOnInactiveButton();
                });
                error_flag = false;
            }
        }
        else {
            if((area_code.value.length == 3 || !validateNotEmpty(area_code))  && (phone.value.length == 7 || !validateNotEmpty(phone) ) ){
                if(document.getElementById('change').value=="true" || element.className == "checkbox") {
                    //alert("");
                    $("#submit-button-intro").addClass("active");
                    $("#submit-button-intro").unbind().click(function() {
                        validateProfileIntroOnInactiveButton();
                        submitForm();
                    });
                }
	
            }
            else{
                //button.disabled="disabled";
                $("#submit-button-intro").removeClass("active");
                $("#submit-button-intro").unbind().click(function() {
                    validateProfileIntroOnInactiveButton();
                });
                error_flag = false;
            }
            if(!validateNotEmpty(area_code)) {
                
                $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty input-text-unactive");
                $("#"+area_code.id).parent().addClass("input-text");
            }
            if(!validateNotEmpty(phone)) {
                $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty input-text-unactive");
                $("#"+phone.id).parent().addClass("input-text");
            }
            if(error_type.value=="") {
                error.innerHTML = "";
                error_type.value= "";
            }
			
        }
        if(website_error_flag && error_flag) {
            if(document.getElementById('change').value=="true") {
                $("#submit-button-intro").addClass("active");
                //button.disabled="";
                $("#submit-button-intro").unbind().click(function() {
                    validateProfileIntroOnInactiveButton();
                    submitForm();
                });
            }
        }
        else {
            //button.disabled="disabled";
            $("#submit-button-intro").removeClass("active");
            $("#submit-button-intro").unbind().click(function() {
                validateProfileIntroOnInactiveButton();
            });
        }
		
    }
    else {
        //button.disabled="disabled";
        $("#submit-button-intro").removeClass("active");
        $("#submit-button-intro").unbind().click(function() {
            validateProfileIntroOnInactiveButton();
        });
        if(!validateNotEmpty(area_code)) {
            $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty input-text-unactive");
            $("#"+area_code.id).parent().addClass("input-text");
        }
        if(!validateNotEmpty(phone)) {
            $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty input-text-unactive");
            $("#"+phone.id).parent().addClass("input-text");
        }
        if(error_type.value=="") {
            error.innerHTML = "";
            error_type.value= "";
        }
    }
	
	
}

function hideErrorPopup(exclude_payment) {
    var job_id = $("#job_id_value").val();
    var pay_for = $("input#pay_for").val();
    showNormalShadow();
    $('div#job_expiry_error').hide();
    $("#fade_error_warning").hide();
    if(pay_for=="consider") {
        consider_job.call(job_id);
    }else if(pay_for=="interest") {
        if (exclude_payment != 1){
            interest_job.call(job_id);
        }
        else{
            interest_job.exclude_payment(job_id);
        }
    } else if(pay_for=="wild") {
        if (exclude_payment != 1){
            wildcard_job.call(job_id);
        }
        else{
            wildcard_job.exclude_payment(job_id);
        }
    }
}

function hideErrorCancel() {
    showNormalShadow();
    $('div#job_expiry_error').hide();
    $("#fade_error_warning").hide();
}

function changeName(name){
    $(".header-right-container .hil-info-link-section label.welcome").text("WELCOME, "+name);
}

function activateSaveButton(){
    var button = document.getElementById('submit-button-intro');
    if(document.getElementById('intro-error').innerHTML == ""){
        button.className = "btn-save active";
    //button.disabled = "";
    }
}

function disableSaveButton(){
    var button = document.getElementById('submit-button-intro');
    $('#submit-button-intro').removeClass('active');
    $('#submit-button-intro').unbind();
//button.disabled = "disabled";
}

function verifyPaymentSuccess() {
    _closeCCBillingInfo();
    $('#payment_details_text').hide();
    $("#credit-card-info").hide();
    $("#personal-info").hide();
    $("#paypal-info").hide();
}

function activateSave() {
    document.getElementById('change').value="true";
}

function validateGiftHiloInfo(current_element) {	
    sendersName = document.getElementById('senders_name');
    sendersEmail = document.getElementById('senders_email');
    recipientsName = document.getElementById('recipients_name');
    remail = document.getElementById('recipients_email');
    v_reEmail = document.getElementById('verify_recipients_email');
    personalMsg = document.getElementById('personal_msg');
    errorBox = document.getElementById('gift_hilo_error_msg');
    error_element = document.getElementById('gift_error_type');
		
    if(current_element==sendersEmail){
        if(validateNotEmpty(sendersEmail) && !$("#"+sendersEmail.id).parent().hasClass("input-text-unactive")) {
            if(validateEmail(sendersEmail.value)) {
                $("#"+sendersEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+sendersEmail.id).parent().addClass("active-input");
                if(error_element.value=="senders_email" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+sendersEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+sendersEmail.id).parent().addClass("input-text-error");
                if(error_element.value=="senders_email" || error_element.value=="") {
                    errorBox.innerHTML="Invalid email address format";
                    error_element.value="senders_email";
                }
                $("#"+errorBox.id).show();
            }
        }
        else {
            $("#"+sendersEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+sendersEmail.id).parent().addClass("input-text");
		    
            if(error_element.value=="senders_email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
    if(current_element==remail){
        if(validateNotEmpty(remail) && !$("#"+remail.id).parent().hasClass("input-text-unactive")) {
            if(validateEmail(remail.value)) {
                $("#"+remail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+remail.id).parent().addClass("active-input");
                if(error_element.value=="re_email" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+remail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+remail.id).parent().addClass("input-text-error");
                            
                if(error_element.value=="re_email" || error_element.value=="") {
                    errorBox.innerHTML="Invalid email address format";
                    error_element.value="re_email";
                }
                $("#"+errorBox.id).show();
            }
        }
        else {
            $("#"+remail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+remail.id).parent().addClass("input-text");
		    
            if(error_element.value=="re_email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
    if(current_element==v_reEmail){
        if(validateNotEmpty(v_reEmail) && !$("#"+v_reEmail.id).parent().hasClass("input-text-unactive")) {
            if(validateEmail(v_reEmail.value)) {
                $("#"+v_reEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+v_reEmail.id).parent().addClass("active-input");
                if(error_element.value=="v_re_email" || error_element.value=="") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+v_reEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+v_reEmail.id).parent().addClass("input-text-error");
                            
                if(error_element.value=="v_re_email" || error_element.value=="") {
                    errorBox.innerHTML="Invalid email address format";
                    error_element.value="v_re_email";
                }
                $("#"+errorBox.id).show();
            }
        }
        else {
            $("#"+v_reEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+v_reEmail.id).parent().addClass("input-text");
		    
            if(error_element.value=="v_re_email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
    if(validateNotEmpty(remail) && validateNotEmpty(v_reEmail) && remail.value==v_reEmail.value && errorBox.innerHTML==""){
        $("#"+v_reEmail.id).parent().removeClass("input-text-error");
        $("#"+v_reEmail.id).parent().addClass("active-input");
    }
		
    if(validateNotEmpty(remail) && validateNotEmpty(v_reEmail) && remail.value!=v_reEmail.value){
        $("#"+v_reEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+v_reEmail.id).parent().addClass("input-text-error");
        if(error_element.value=="v_re_email" || error_element.value=="") {
            errorBox.innerHTML = "Email addresses do not match. <br/>Please check your spelling.";
            error_element.value="v_re_email";
        }
        $("#"+errorBox.id).show();
				
        button = document.getElementById('enter_button');
        //button.disabled="disabled";
        button.className="enter-button rfloat";
    }
    else{
        if(error_element.value=="v_re_email" || error_element.value=="") {
            errorBox.innerHTML = "";
            error_element.value="";
        }
    }
		
    if(validateNotEmpty(sendersName) && validateNotEmpty(recipientsName) && validateNotEmpty(sendersEmail) && validateEmail(sendersEmail.value) && validateNotEmpty(remail) && validateEmail(remail.value) && validateNotEmpty(v_reEmail) && validateEmail(v_reEmail.value) && validateNotEmpty_ta(personalMsg) && errorBox.innerHTML=="") {
		
        button = document.getElementById('enter_button');
        //button.disabled="";
        button.className="enter-button-active rfloat";
    }
    else {
        button = document.getElementById('enter_button');
        //button.disabled="disabled";
        button.className="enter-button rfloat";
    }
}

function disableForm(theform) {
    if (document.all || document.getElementById) {
        for (i = 0; i < theform.length; i++) {
            var formElement = theform.elements[i];
            if (true) {
                formElement.disabled = true;
            }
        }
    }
}
function enableForm(theform) {
    if (document.all || document.getElementById) {
        for (i = 0; i < theform.length; i++) {
            var formElement = theform.elements[i];
            if (true) {
                formElement.disabled = false;
            }
        }
    }
}
	
function resetUpdateEmail() {        
    $('#update_emailexist_error_popup').empty();
    $('update_emailexist_error_popup').hide();
    hideErrorShadow();
}

function resetForgotPassword() {
    $('#old_password').val('');
    document.getElementById('old_password').onblur();
    $('#new_password').val('');
    document.getElementById('new_password').onblur();
    $('#confirm_password').val('');
    document.getElementById('confirm_password').onblur();
    $('update2').removeClass('update-button-active');
    $('update2').addClass('update-button');
    $('#old_pass_mismatch').empty();
    $('old_pass_mismatch').hide();
    hideErrorShadow();
}

function setCardTypeGift(card_type) {
    $('#gift_error_msg').hide();
    $('#gift_error_msg').html("");
    $('#cvv_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#cvv_gift').parent().addClass('input-text');
    changeInputType(document.getElementById("cvv_gift"),"text","");
    $('#cvv_gift').val('Security Code');
	
    $('#card_num_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#card_num_gift').parent().addClass('input-text');
    $('#card_num_gift').val('Credit Card Number');
    //$('#paypal_error_msg').hide();
	
    validateGiftCreditCardInfo();
    flag = 0;
    if(card_type == "master") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='master' id='master_card' />");
        $('#gift_payment_card_type').val('master');
        $("#payment-options_gift").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num_gift").attr('maxlength', 16);
        $("#cvv_gift").attr('maxlength', 3);
        $("#credit-card-info_gift").show();
        $("#personal-info_gift").show();
        $("#paypal-info_gift").hide();
        $("#gifts_payment_verify_button").show();
        $('#hilo-info_gift').hide();
        gift_hilo.hideNonRegAuthorizeGiftPurchase();
        //hideCreditCarddData();
        hideSigninData();
        flag = 1;
		
    } else if(card_type=="visa") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='visa' id='master_card' />");
        $('#gift_payment_card_type').val('visa');
        $("#payment-options_gift").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num_gift").attr('maxlength', 16);
        $("#cvv_gift").attr('maxlength', 3);
        $("#credit-card-info_gift").show();
        $("#personal-info_gift").show();
        $("#paypal-info_gift").hide();
        $("#gifts_payment_verify_button").show();
        $('#hilo-info_gift').hide();
        gift_hilo.hideNonRegAuthorizeGiftPurchase();
        //hideCreditCarddData();
        hideSigninData();
        flag = 1;
    } else if(card_type == "american_express") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='american_express' id='master_card' />");
        $('#gift_payment_card_type').val('american_express');
        $("#payment-options_gift").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num_gift").attr('maxlength', 15);
        $("#cvv_gift").attr('maxlength', 4);
        $("#credit-card-info_gift").show();
        $("#personal-info_gift").show();
        $("#paypal-info_gift").hide();
        $("#gifts_payment_verify_button").show();
        $('#hilo-info_gift').hide();
        gift_hilo.hideNonRegAuthorizeGiftPurchase();
        //hideCreditCarddData();
        hideSigninData();
		
        flag = 1;
    } else if(card_type == "discover") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='discover' id='master_card' />");
        $('#gift_payment_card_type').val('discover');
        $("#payment-options_gift").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#card_num_gift").attr('maxlength', 16);
        $("#cvv_gift").attr('maxlength', 3);
        $("#credit-card-info_gift").show();
        $("#personal-info_gift").show();
        $("#paypal-info_gift").hide();
        $("#gifts_payment_verify_button").show();
        $('#hilo-info_gift').hide();
        gift_hilo.hideNonRegAuthorizeGiftPurchase();
        //hideCreditCarddData();
        hideSigninData();
		
        flag = 1;
    } else if(card_type == "paypal") {
        $.ajax({
            url: '/gift/express_session_gift_hilo',
            data: '&senders_name_pay=' + $('#senders_name_pay').val()
            + '&senders_email_pay=' + $('#senders_email_pay').val()
            + '&recievers_name_pay=' + $('#recievers_name_pay').val()
            + '&recievers_email_pay=' + $('#recievers_email_pay').val()
            + '&personal_msg_pay=' + $('#personal_msg_pay').val(),
            cache: false,
            success:function(){
                $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='paypal' id='master_card' />");
                $("#payment-options_gift").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
                $("#credit-card-info_gift").hide();
                $("#personal-info_gift").hide();
                $("#paypal-info_gift").show();
                gift_hilo.hideNonRegAuthorizeGiftPurchase();
                $("#gifts_payment_verify_button").hide();
                $('#hilo-info_gift').hide();
                hideCreditCarddData();
                hideSigninData();
                addFocusButton('paypal-info_gift_button');
            }
        });
    } else if(card_type == "signin"){
        $("#payment-options_gift").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setCardTypeGift(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardTypeGift(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardTypeGift(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardTypeGift(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardTypeGift(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info_gift").hide();
        $("#personal-info_gift").hide();
        $("#paypal-info_gift").hide();
        $("#gifts_payment_verify_button").show();
        $('#hilo-info_gift').show();
        //validateHiloSignupDetails();
        hideCreditCarddData();
        hideSigninData();
        gift_hilo.hideNonRegAuthorizeGiftPurchase();
        flag = 0;
        $('#gifts_payment_verify_button').unbind('click').bind('click', function(){
            //alert("100");
            if(validateEmptyGiftAuth()){
				
            }
            else{
                $("#chechout_billing_form").submit();
            }
        });
        addFocusTextField('username_gift');
    }
	
    if(flag){
        $("#gifts_payment_verify_button").unbind('click').bind('click', function(){
            //alert("200");
            if (!validateEmptyGiftPayment()){
                if (document.getElementById('chechout_billing_form')){
                    $("#chechout_billing_form").submit();
                }
                else if(document.getElementById('form_gift_payment')){
                    $("#form_gift_payment").submit();
                }
                return false;
            }
            else{
			
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('gift_payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
        });
    }
}

function validatePaypalInfo(){
    paypalusername_gift = document.getElementById('paypalusername_gift');
    paypalpassword_gift = document.getElementById('paypalpassword_gift');
	
    if(validateNotEmpty(paypalusername_gift) && validateNotEmpty(paypalpassword_gift)) {
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="";
        button.className="buy-gift-button-active rfloat";
	
    }
    else{
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="disabled";
        button.className="buy-gift-button rfloat";
    }
}

function showHiloSignupDetails(){
    $("#payment-options").html("<li><a href='javascript:void(0);' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
    $("#credit-card-info_gift").hide();
    $("#personal-info_gift").hide();
    $("#paypal-info_gift").hide();
    $('#hilo-info_gift').show();
//validateHiloSignupDetails();
}

function validateHiloSignupDetails(){
    username_gift = document.getElementById('username_gift');
    password_gift = document.getElementById('password_gift');
	
    if(validateNotEmpty(username_gift) && validateNotEmpty(password_gift)) {
        button = document.getElementById('gift_payment_verify_button');
        //button.disabled="";
        button.className="buy-gift-button-active rfloat";

    }
    else{
        button = document.getElementById('gift_payment_verify_button');
        //button.disabled="disabled";
        button.className="buy-gift-button rfloat";
    }
}

function checkPaypalCredentialsEntered(current_element) {
    paypalusername_gift = document.getElementById('paypalusername_gift');
    paypalpassword_gift = document.getElementById('paypalpassword_gift');
	
    if(validateNotEmpty(paypalusername_gift) && validateNotEmpty(paypalpassword_gift)) {
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="";
        button.className="buy-gift-button-active rfloat";

    }
    else{
        button = document.getElementById('gifts_payment_verify_button');
        //button.disabled="disabled";
        button.className="buy-gift-button rfloat";
    }
}

function checkHiloCredentialsEntered(current_element) {
    if(document.getElementById("username_gift") && document.getElementById("password_gift")) {
        email = document.getElementById("username_gift").value.trim();
        password = document.getElementById("password_gift").value;
        pass_element = document.getElementById("password_gift");
        button = document.getElementById("gifts_payment_verify_button");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            button.className="buy-gift-button-active rfloat";
        //button.disabled="";
        }
        else {
            button.className="buy-gift-button rfloat";
        //button.disabled="true";
        }
    }
}

var gift_hilo = {
    openPopup: function() {
        $.ajax({
            url: "/home/credit_card_popup",
            cache: false,
            success: function(data){
                $("#complete_purchase_one_click_gift").hide();
                $("#complete_purchase_no_one_click_gift").hide();
                $("#fade_normal_warning").hide();
                $("#gift_cc_billing_popup").html(data);
                $("#gift_hilo_payment_text").html('Please select a new one-click payment method.');
                gift_hilo.showGiftccBilingPopup();
                $('#senders_name_pay').val($("#senders_name_pay_purchase").val());
                $('#senders_email_pay').val($("#senders_email_pay_purchase").val());
                $('#recievers_name_pay').val($("#recievers_name_pay_purchase").val());
                $('#recievers_email_pay').val($("#recievers_email_pay_purchase").val());
                $('#personal_msg_pay').val($("#personal_msg_pay_purchase").val());
            //$("#summary_click_payment").show();
            }
        });
    },
    one_click_close :function(){
        showBlockShadow();
        $("#continue-button-active_one_click").hide();
        $("#verify-loader-img_one_click").show();
        $.ajax({
            url: '/gift/complete_purchase_one_click',
            cache: false
        });
    },
    success_payment: function(){
        hideBlockShadow();
        hideNormalShadow();
        $('#gift_verify-loader-img').hide();
        $('#verify-loader-img').hide();
        $('#gifts_payment_verify_button').show();
        $("#checkout_billing_info").hide();
        $("#purchase_review_popup").hide();
        $("#gift_cc_billing_popup").empty();
        showSuccessShadow();
        $("#gift_hilo_success_msg").show();
        $('#continue_button').focus();
        centralizePopup();
        addFocusButton('continue_button');
    },
    not_suuccess_payment: function(){
        hideBlockShadow();
        hideNormalShadow();
        $('#gift_verify-loader-img').hide();
        $('#gifts_payment_verify_button').show();
        $("#checkout_billing_info").hide();
        showErrorShadow();
        $("#gift_hilo_failure").show();
        centralizePopup();
        $('.gift_hilo_failure_button').focus();
    },
    signin_not_success: function(){
        hideBlockShadow();
        hideNormalShadow();
        showErrorShadow();
        $('#gift_verify-loader-img').hide();
        $('#gifts_payment_verify_button').show();
        $("#checkout_billing_info").hide();
        $("#gift_hilo_signin_failure").show();
        centralizePopup();
        $('.gift_hilo_signin_failure_button').focus();
    },
    showNonRegAuthorizeGiftPurchase: function(data){
        hideBlockShadow();
        $("#pay_name").val($('#username_gift').val());
        //$("#username_gift").val("");
        $("#gift_hilo_review_popup").show();
        //blur_element(document.getElementById('username_gift'));
        //$("#password_gift").val("");
        //blur_element(document.getElementById('password_gift'));
        $('#gift_verify-loader-img').hide();
        $('#popup-gift-bottom').css({
            'display':'none'
        });
        $('#non_reg_oneClick-payment_gift').show();
        $("#pay_method").val(data);
	
        $("#confirm_button").unbind('click').bind('click', function(){
			
            if(validateEmptyOneClickPayment()){
                                        
            }
            else{
                $("#gift_one_click_form_non_reg").submit();
            }
                                
                        
        });	
        addFocusTextField('pay_pass');
    },
    hideNonRegAuthorizeGiftPurchase: function(){
        $('.popup-bottom').css({
            'display':''
        });
        $('#non_reg_oneClick-payment_gift').hide();
        $('#gifts_payment_verify_button').hide();
        $("#gifts_payment_verify_button").show();
    },
    showGiftccBilingPopup: function(){
        $("#senders_name_pay").val($('#senders_name').val());
        $("#senders_email_pay").val($('#senders_email').val());
        $("#recievers_name_pay").val($('#recipients_name').val());
        $("#recievers_email_pay").val($('#recipients_email').val());
        $("#personal_msg_pay").val($('#personal_msg').val());
        hideBlockShadow();
        $('#verify-loader-img').hide();
        $("#checkout_billing_info").empty();
        $("#purchase_review_popup").hide();
        $("#gift_cc_billing_popup").show();
        centralizePopup();
        $("#gifts_payment_verify_button").unbind('click').bind('click', function(){
            if (!validateEmptyGiftPayment()){
                $("#form_gift_payment").submit();
            }
            else {
                $('#payment_header').text("UNABLE TO VERIFY");
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('gift_payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
        });
    },
    not_suuccess_credit_payment: function(){
        hideBlockShadow();
        hideNormalShadow();
        $('#verify-loader-img').hide();
        $('#payment_verify_button').show();
        $('#gifts_payment_verify_button').show();
        $("#paypal_error_msg").show();
        $("#paypal_error_msg").html("Please check your payment information and try again.");
        $('#payment_header').text("UNABLE TO VERIFY");
        showErrorShadow();
        centralizePopup();
    },
    checkout_billing_info: function(){
        showNormalShadow();
        $("#checkout_billing_info").show();
        $('#purchase_review_popup').hide();
        $("#gifts_payment_verify_button").show();
        centralizePopup();
	
        $("#gifts_payment_verify_button").unbind('click').bind('click', function(){
            if (!validateEmptyGiftPayment()){
                $("#chechout_billing_form").submit();
			
            }
            else{
			
                $("#gift_error_msg").show();
                $("#gift_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('gift_payment_card_type');
                if (payment_card_type.value == ''){
                    $("#gift_error_msg").show();
                    $("#gift_error_msg").html("Please select one payment option.");
                }
			
            }
        });
    },
    one_click_login_not_success: function(){
        temp1 = $("#checkout_billing").val();
        temp2 = $("#checkout_billing_purchase").val();
        $.ajax({
            url: "/home/check_login_not_success",
            data: "temp1=" + temp1 + "&temp2=" + temp2,
            cache: false,
            success: function(){
                
            }
        });  
    },
    unregistered_login_not_success: function(){
        hideBlockShadow();
        hideNormalShadow();
        showErrorShadow();
        $("#checkout_billing_info").hide();
        $("#gift_hilo_one_click_signin_failure").show();
        gift_hilo.showNonRegAuthorizeGiftPurchase($('#pay_method').val());
        centralizePopup();
        $('.gift_hilo_one_click_signin_failure_button').focus();
    },
    registered_login_not_success: function(){
        hideBlockShadow();
        hideNormalShadow();
        showErrorShadow();
        $("#purchase_review_popup").hide();
        $("#gift_hilo_registered_signin_failure").show();
        gift_hilo.showRegGiftPurchase($("#pay_method_purchase").val());
        centralizePopup();
        $('.gift_hilo_registered_signin_failure_button').focus();
    },
    retry_one_click_unregistered_failure: function(){
        hideErrorLogin();
        $('#gift_hilo_one_click_signin_failure').hide();
        showNormalShadow();
        $('#gift_one_click_loader_img1').hide();
        $("a#preview_card_select").show();
        $('#confirm_button').show();
        $('#checkout_billing_info').show();
        centralizePopup();
        document.getElementById('confirm_button').className = 'btn-Confirm rfloat';
        $("#pay_pass").val('');
        $("#pay_pass").blur();
        addFocusTextField('pay_pass');
    },
    retry_one_click_registered_failure: function(){
        hideErrorLogin();
        $('#gift_hilo_registered_signin_failure').hide();
        showNormalShadow();
        $('#gift_one_click_loader_img').hide();
        $("#preview_card_select").show();
        $('#gift_confirm_button').show();
        $('#purchase_review_popup').show();
        centralizePopup();
        document.getElementById('gift_confirm_button').className = 'btn-Confirm rfloat';
        $("#gift_pay_pass").val('');
        $("#gift_pay_pass").blur();
        addFocusTextField('gift_pay_pass');
    },
    hideCheckoutBillingClose: function(){
        $.ajax({
            url: "/home/checkout_billing_close",
            cache: false,
            success: function(){
                
            }
        });
    },
    reload_checkout_billing: function(){
        window.location.reload();
    },
    credit_card_show: function(){
        $.ajax({
            url: "/home/credit_card_show",
            cache: false,
            success: function(){
            }
        });
    },
    showRegGiftPurchase: function(data){
        $("#pay_method_purchase").val(data);
        $("#purchase_call").val("true");
        $('.popup-bottom-billing-review').css({
            'display':'none'
        });
        $('#oneClick-payment_gift').show();
	
        $("#gift_confirm_button").unbind('click').bind('click', function(){
            if(validateEmptyOneClickPaymentGift()){
                                        
            }
            else{
                $("#gift_one_click_form").submit();
            }
        });
        addFocusTextField('gift_pay_pass');
    },
    showRegGiftccBilingPopup: function(){
        $("#senders_name_pay").val($('#senders_name_pay_purchase').val());
        $("#senders_email_pay").val($('#senders_email_pay_purchase').val());
        $("#recievers_name_pay").val($('#recievers_name_pay_purchase').val());
        $("#recievers_email_pay").val($('#recievers_email_pay_purchase').val());
        $("#personal_msg_pay").val($('#personal_msg_pay_purchase').val());
        hideBlockShadow();
        $("#purchase_review_popup").hide();
        $("#gift_cc_billing_popup").show();
        centralizePopup();
        $("#gifts_payment_verify_button").unbind('click').bind('click', function(){
            if (!validateEmptyGiftPayment()){
                $("#form_gift_payment").submit();
            }
            else {
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('gift_payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
        });
    },
    showGiftPurchaseReview: function(){
        $("#senders_name_pay_purchase").val($('#senders_name').val());
        $("#senders_email_pay_purchase").val($('#senders_email').val());
        $("#recievers_name_pay_purchase").val($('#recipients_name').val());
        $("#recievers_email_pay_purchase").val($('#recipients_email').val());
        $("#personal_msg_pay_purchase").val($('#personal_msg').val());
        showNormalShadow();
        $('#gift_hilo_popup').hide();
        $('#gift_purchase_review').show();
        $("#review_purchase_summary").html("<p>To: " + $('#recipients_name').val() + " (" + $('#recipients_email').val() + ")</p><p>From: " + $('#senders_name').val() + " (" + $('#senders_email').val() + ")</p><p>" + $('#personal_msg').val()) + "</p>";
        $('.popup-bottom-billing-review').css({
            'display':'none'
        });
        $('.popup-bottom-billing-review').css({
            'display':'block'
        });
        $("#"+v_reEmail.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+v_reEmail.id).parent().addClass("input-text input-text-active active-input");
        $("#"+errorBox.id).hide();
        centralizePopup();
        addFocusButton('gift_purchase_review_button');
    },
    retry_one_click_registered_close: function(){
        $("#gift_hilo_registered_signin_failure").hide();
        hideErrorShadow();
    }
}

function hideFinishSuccessButton(){
    $('#finish-button-success').hide();
    hideSuccessShadow();
    $('#cc_billing_popup').hide();
}

function hideSigninData(){
    if($("#username_gift").parent().hasClass("input-text-error-empty")){
        $("#username_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#username_gift").parent().hasClass("input-text-error")){
        $("#username_gift").parent().removeClass("input-text-error");
    }
    
    if($("#password_gift").parent().hasClass("input-text-error-empty")){
        $("#password_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#password_gift").parent().hasClass("input-text-error")){
        $("#password_gift").parent().removeClass("input-text-error");
    }
    if(document.getElementById('username_gift')){
        $("#username_gift").val("");
        blur_element(document.getElementById('username_gift'));
        $("#password_gift").val("");
        blur_element(document.getElementById('password_gift'));
    }
}

function hideCreditCarddData(){
    if($("#card_num_gift").parent().hasClass("input-text-error-empty")){
        $("#card_num_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#card_num_gift").parent().hasClass("input-text-error")){
        $("#card_num_gift").parent().removeClass("input-text-error");
    }
    
    if($("#month_gift").parent().hasClass("input-text-error-empty")){
        $("#month_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#month_gift").parent().hasClass("input-text-error")){
        $("#month_gift").parent().removeClass("input-text-error");
    }
    
    if($("#year_gift").parent().hasClass("input-text-error-empty")){
        $("#year_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#year_gift").parent().hasClass("input-text-error")){
        $("#year_gift").parent().removeClass("input-text-error");
    }
    
    if($("#cvv_gift").parent().hasClass("input-text-error-empty")){
        $("#cvv_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#cvv_gift").parent().hasClass("input-text-error")){
        $("#cvv_gift").parent().removeClass("input-text-error");
    }
    
    if($("#fname_gift").parent().hasClass("input-text-error-empty")){
        $("#fname_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#fname_gift").parent().hasClass("input-text-error")){
        $("#fname_gift").parent().removeClass("input-text-error");
    }
    
    if($("#lname_gift").parent().hasClass("input-text-error-empty")){
        $("#lname_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#lname_gift").parent().hasClass("input-text-error")){
        $("#lname_gift").parent().removeClass("input-text-error");
    }
    
    if($("#billing_address_one_gift").parent().hasClass("input-text-error-empty")){
        $("#billing_address_one_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#billing_address_one_gift").parent().hasClass("input-text-error")){
        $("#billing_address_one_gift").parent().removeClass("input-text-error");
    }
    
    if($("#billing_city_gift").parent().hasClass("input-text-error-empty")){
        $("#billing_city_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#billing_city_gift").parent().hasClass("input-text-error")){
        $("#billing_city_gift").parent().removeClass("input-text-error");
    }
    
    if($("#billing_zip_gift").parent().hasClass("input-text-error-empty")){
        $("#billing_zip_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#billing_zip_gift").parent().hasClass("input-text-error")){
        $("#billing_zip_gift").parent().removeClass("input-text-error");
    }
    
        
    if($("#billing_area_code_gift").parent().hasClass("input-text-error-empty")){
        $("#billing_area_code_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#billing_area_code_gift").parent().hasClass("input-text-error")){
        $("#billing_area_code_gift").parent().removeClass("input-text-error");
    }
    
    if($("#billing_telephone_number_gift").parent().hasClass("input-text-error-empty")){
        $("#billing_telephone_number_gift").parent().removeClass("input-text-error-empty");
    }
    if($("#billing_telephone_number_gift").parent().hasClass("input-text-error")){
        $("#billing_telephone_number_gift").parent().removeClass("input-text-error");
    }
    
    if($(".personal-info .state-selector-block .state-slector").hasClass("error")){
        $(".state-slector").removeClass("error");
    }
    
    $("#card_num_gift").val("");
    blur_element(document.getElementById('card_num_gift'));
    $("#month_gift").val("");
    blur_element(document.getElementById('month_gift'));
    $("#year_gift").val("");
    blur_element(document.getElementById('year_gift'));
    $("#cvv_gift").val("");
    blur_element(document.getElementById('cvv_gift'));
    $("#fname_gift").val("");
    blur_element(document.getElementById('fname_gift'));
    $("#lname_gift").val("");
    blur_element(document.getElementById('lname_gift'));
    $("#billing_address_one_gift").val("");
    blur_element(document.getElementById('billing_address_one_gift'));
    $("#billing_address_two_gift").val("");
    blur_element(document.getElementById('billing_address_two_gift'));
    $("#billing_city_gift").val("");
    blur_element(document.getElementById('billing_city_gift'));
    $("#billing_zip_gift").val("");
    blur_element(document.getElementById('billing_zip_gift'));
    $("#billing_area_code_gift").val("");
    blur_element(document.getElementById('billing_area_code_gift'));
    $("#billing_telephone_number_gift").val("");
    blur_element(document.getElementById('billing_telephone_number_gift'));
}

function checkSiginValues(){
    if ($("#username_gift").parent().hasClass('input-text')){
        $("#username_gift").val("");
    }
    if ($("#password_gift").parent().hasClass('input-text')){
        $("#password_gift").val("");
    }
}

function showSuccessGiftMsg(){
    $.ajax({
        url: '/home/show_success_msg',
        cache: false,
        success: function(){
            
        }

    });
}

function showAboutHilo() {
    $('div#about-hilo').show();
    showNormalShadow();
    centralizePopup();
    if($('#aboutTeam').hasClass('active')){
        var active_pane = $("#toolbar li.active").attr('id');
        active_pane = active_pane.split("-");
        active_pane = active_pane[0]+"-pane";
        ScrollSection('insurance-pane', 'scroller', 'insurance-pane');
        ScrollSection(active_pane, 'scroller', 'insurance-pane');
    }
}

function showAbout() {
    $("div#about-about").show();
    $("div#about-corevalues").hide();
    $("div#about-team").hide();
    $("div#about-lab").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

function showCoreValues() {
    $("div#about-corevalues").show();
    $("div#about-about").hide();
    $("div#about-team").hide();
    $("div#about-lab").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

function showTeam() {
    $("div#about-team").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-lab").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
    var active_pane = $("#toolbar li.active").attr('id');
    active_pane = active_pane.split("-");
    active_pane = active_pane[0]+"-pane";
    ScrollSection('insurance-pane', 'scroller', 'insurance-pane');
    ScrollSection(active_pane, 'scroller', 'insurance-pane');
}

function showLab() {
    $("div#about-lab").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-team").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

function showPress() {
    $("div#about-press").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-lab").hide();
    $("div#about-team").hide();
    $("div#about-contact").hide();
}

function showContact() {
    $("div#about-contact").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-lab").hide();
    $("div#about-team").hide();
    $("div#about-press").hide();
}

function hideAboutHiloPopup() {
    $('div#about-hilo').hide();
    hideNormalShadow();
}

function activate_one_click_gift() {
    if(document.getElementById("gift_pay_name") && document.getElementById("gift_pay_pass")) {
        email = document.getElementById("gift_pay_name").value;
        password = document.getElementById("gift_pay_pass").value;
        pass_element = document.getElementById("gift_pay_pass");
        button = document.getElementById("gift_confirm_button");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            button.className="btn-Confirm-active rfloat"
        //button.disabled="";

        }
        else {
            button.className="btn-Confirm rfloat"
        //button.disabled="disabled";

        }
    }
}

function callPlayer(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    var all_iframes = document.getElementById('vplayer');
    if(all_iframes.parentNode.id == frame_id){
        /*The index of the IFRAME element equals the index of the iframe in
               the frames object (<frame> . */
        window.frames["empVplayer"].postMessage(JSON.stringify({
            "event": "command",
            "func": func,
            "args": args,
            "id": 1/*Can be omitted.*/
        }), "*");
    }
}

function closeVPlayer(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    playerId = $('#'+frame_id).children().attr('id');
    playerName = $('#'+frame_id).children().attr('name');
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    var all_iframes = document.getElementById(playerId);
    if(all_iframes.parentNode.id == frame_id){
        /*The index of the IFRAME element equals the index of the iframe in
               the frames object (<frame> . */
        window.frames[playerName].postMessage(JSON.stringify({
            "event": "command",
            "func": func,
            "args": args,
            "id": 1/*Can be omitted.*/
        }), "*");
    }
}

function callBetaAccessPlayer(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    var all_iframes = document.getElementById('betaAccessvplayer');
    if(all_iframes.parentNode.id == frame_id){
        /*The index of the IFRAME element equals the index of the iframe in
               the frames object (<frame> . */
        window.frames["betaAccessvplayer"].postMessage(JSON.stringify({
            "event": "command",
            "func": func,
            "args": args,
            "id": 1/*Can be omitted.*/
        }), "*");
    }
}

function stopIntroPlayer(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    var all_iframes = document.getElementById('profileIntroVplayer');
    if(all_iframes.parentNode.id == frame_id){
        /*The index of the IFRAME element equals the index of the iframe in
               the frames object (<frame> . */
        window.frames["profileIntroVplayer"].postMessage(JSON.stringify({
            "event": "command",
            "func": func,
            "args": args,
            "id": 1/*Can be omitted.*/
        }), "*");
    }
}

function stopWelcomePlayer(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    var all_iframes = document.getElementById('accountVplayer');
    if(all_iframes.parentNode.id == frame_id){
        /*The index of the IFRAME element equals the index of the iframe in
               the frames object (<frame> . */
        window.frames["accountVplayer"].postMessage(JSON.stringify({
            "event": "command",
            "func": func,
            "args": args,
            "id": 1/*Can be omitted.*/
        }), "*");
    }
}

function updateSideMenuCount() {
    $.ajax({
        url: '/account/get_job_count_ajax',
        cache: false,
        success:function(html_data){
            var count = html_data.split("_");
            //$(".inbox").html(count[0]);
            $(".employer_view").html(count[0]);
            $(".following").html(count[1]);
            $(".watchlist").html(count[2]);
            $(".history").html(count[3]);
        }
    });
}

function countdown() {
	
	
	
    function start() {
        //var t = window.setTimeout(write_time, 100);
        var t = self.setInterval(write_time, 1000);
    }
}

function write_time(set_year,set_month,set_day,set_hour,set_min,set_sec) {
		
    var deadline = new Date(Date.UTC(set_year,set_month-1,set_day,set_hour,set_min,set_sec,0));
    var current = new Date();
    var s = deadline.getTime() - current.getTime();
    
    s = Math.floor(s/1000);
    var minutes = Math.floor(s/60);
    minutes = minutes % 60;
    var sec = s;
    var hours = Math.floor(s/3600);
    var days = Math.floor(hours / 24);
    hours = hours % 24;
    sec = sec % 60;
		
		
			

    if(days.toString().length == 1)
    {
        days= "0" + days.toString();
    }

    if(minutes.toString().length == 1)
    {
        minutes = "0" + minutes.toString();
    }

    if(hours.toString().length == 1)
    {
        hours = "0" + hours.toString();
    }

    if(sec.toString().length == 1)
    {
        sec ="0" + sec.toString();
    }
    document.getElementById("days").innerHTML = String(days);
    document.getElementById("hours").innerHTML = String(hours);
    document.getElementById("minutes").innerHTML = String(minutes);
    document.getElementById("seconds").innerHTML = String(sec);
    
    if(String(days)=="00" && String(hours)=="00" && String(minutes)=="00" && String(sec)=="00") {
        clearInterval(timer);
        document.getElementById('rt').innerHTML="Expired";
        document.getElementById('buy-button').onclick="function(){}";
        $("#buy-button").unbind().bind('click', function(){
            hideNormalShadow();
            showErrorShadow();
            $("#position_overview").empty();
            $("#position_details").empty();
           
            $('#job_inactive_error').show();
            $('label.job_expiry_warning').html("THIS JOB IS CURRENTLY INACTIVE!");
            addFocusButton('continue');
        });
        
    //job_inactive_error
    }
    
		
		
}

function footerOnClosingPopup()
{
// $('.lblftrclr').css('color','#000066');
}

var done;
function areYouSure(whatWasClicked, share_id) {
    if($("#page-container-profile .button-container .btn-save").hasClass("active")){
        // Open popup
        showAreYouSurePopup();

        $("#are_you_sure_popup .close").unbind().bind('click',function(){
            hideAreYouSurePopup();
        });
        // Set actions for continue button
        $("#are_you_sure_popup #are_you_sure_popup_continue_button").unbind().bind('click',function(){
            hideAreYouSurePopup();
            if(whatWasClicked=="Personality" || whatWasClicked=="Credentials" || whatWasClicked=="Intro" || whatWasClicked=="Basics") {
                var step = whatWasClicked;
                bindParingProfileMenu(step);
            }
            else if(whatWasClicked=="dashboard") {
                window.location='/account';
            }
            else if(whatWasClicked=="opportunities") {
                window.location='/account/opportunities';
            }
            else if(whatWasClicked=="profile") {
                window.location='/account/pairing_profile';
            }
            else if(whatWasClicked=="account") {
                hideAreYouSurePopup();
                showAuthenticationPopup();
            }
            else if(whatWasClicked=="signout") {
                window.location='/login/logout';
            }
            else if(whatWasClicked=="career_code") {
                $('#career_code_popup').show();
                centralizePopup();
                showNormalShadow();
                $('#loader_img3').hide();
                $('#code_button').show();
                $('#career_code').parent().attr('class','customized-input input-text');
                $('#career_code').val('Career Code');
                addFocusTextField('career_code');
                //document.getElementById('code_button').disabled='disabled';
                document.getElementById('code_button').className='enter-button';
            }
            else if(whatWasClicked=="gift_hilo") {
                hideAreYouSurePopup();
                click_gift_hilo.gift_hilo_show();
            }
            else if(whatWasClicked=="twitter" || whatWasClicked=="linkedin") {
                hideAreYouSurePopup();
                share_hilo.share(share_id);
            }
        });

        // Set actions for save button
        $("#are_you_sure_popup .popup_btn-save").unbind().bind('click',function(){
            // Save Data
            document.getElementById('are_you_sure_popup_button').blur();
                
            var fromWhereWasItClicked;
            $('.profile-breadcrumb').children().each(function(){
                if($(this).hasClass("active")) {
                    fromWhereWasItClicked = $(this).find('a').attr('title');
                }
            })
            
            if(fromWhereWasItClicked=="Intro") {
                showBlockShadow();
                submitForm();
            }
            else if(fromWhereWasItClicked=="Credentials") {
                showBlockShadow();
                credential_save.call('update');
            }
            else if(fromWhereWasItClicked=="Basics"){
                $("#next_button").hide();
                $("#loader_basic").show();
                showBlockShadow();
                validate_pairing_basics_csv2.call('update');
				
            }
			
            // Transfer Control to clicked page
            if(whatWasClicked=="Personality" || whatWasClicked=="Credentials" || whatWasClicked=="Intro" || whatWasClicked=="Basics") {
                var step = whatWasClicked;
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        bindParingProfileMenu(step);
                        hideAreYouSurePopup();
                        clearInterval(done);
                    }
                },1000);
				
				
				
            }
            else if(whatWasClicked=="dashboard") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        window.location='/account';
                        hideAreYouSurePopup();
                        clearInterval(done);
                    }
                },1000);
            }
            else if(whatWasClicked=="opportunities") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        window.location='/account/opportunities';
                        hideAreYouSurePopup();
                        clearInterval(done);
                    }
                },1000);
				
            }
            else if(whatWasClicked=="profile") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        window.location='/account/pairing_profile';
                        hideAreYouSurePopup();
                        clearInterval(done);
                    }
                },1000);
				
            }
            else if(whatWasClicked=="account") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        hideAreYouSurePopup();
                        showAuthenticationPopup();
                        clearInterval(done);
                    }
                },1000);
				
            }
            else if(whatWasClicked=="signout") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        window.location='/login/logout';
                        hideAreYouSurePopup();
                        clearInterval(done);
                    }
                },1000);
            }
            else if(whatWasClicked=="career_code") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        hideAreYouSurePopup();
                        $('#career_code_popup').show();
                        centralizePopup();
                        showNormalShadow();
                        $('#loader_img3').hide();
                        $('#code_button').show();
                        $('#career_code').parent().attr('class','customized-input input-text');
                        $('#career_code').val('Career Code');
                        addFocusTextField('career_code');
                        //document.getElementById('code_button').disabled='disabled';
                        document.getElementById('code_button').className='enter-button';
                        clearInterval(done);
                    }
                },1000);
            }
            else if(whatWasClicked=="gift_hilo") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        hideAreYouSurePopup();
                        click_gift_hilo.gift_hilo_show();
                        clearInterval(done);
                    }
                },1000);
            }
            else if(whatWasClicked=="twitter" || whatWasClicked=="linkedin") {
                done = setInterval(function() {
                    if(!$("#page-container-profile .button-container .btn-save").hasClass("active")){
                        hideAreYouSurePopup();
                        share_hilo.share(share_id);
                        clearInterval(done);
                    }
                },1000);
            }
			
        });
		
		
        return false;
    }
    return true;
}	

function showAreYouSurePopup() {
    showErrorShadow();
    $("#are_you_sure_popup").show();
    centralizePopup();
    addFocusButton('are_you_sure_popup_button');
}

function hideAreYouSurePopup() {
    hideErrorShadow();
    $("#are_you_sure_popup").hide();
    hideBlockShadow();
}

function bindParingProfileMenu(step) {
    $('.profile-breadcrumb').children().each(function(){
        $(this).removeClass("active");
    })
	
    $('ul.profile-breadcrumb li').each(function(){
        if($(this).find('a').attr('title')==step) {
            $(this).addClass("active");
        }
    })
	
    $.ajax({
        url: '/account/profile_tabs',
        cache: false,
        timeout: normal_timeout,
        beforeSend: function (){
            $(".loader").show();
            $("#ajax").empty();
        },
        error: function() {
            $(".loader").hide();
        },
        data: "step="+step,
        success: function(){
		
        }
    });
}

function showJobForNotification(id) {
    showBlockShadow();
    $.ajax({
        url: "/account/show_job_for_code",
        cache: false,
        data: "job_code=HL"+id+"&notification=true",
        success: function(){
            hideNotification();
            hideBlockShadow();
        },
        error: function() {
			                                
        },
        timeout: normal_timeout
    });
	
}

function changeCCErrorPopupText(){
    //$(".popup-upper-block-fogetPwd #message").html("The position is inactive");
    //$("#button-block").html("");
    document.getElementById("continue").onclick="";
    $("#continue").click(function(){
        $('#job_inactive_error').hide();
        $('#fade_error_warning').hide();
        $('#fade_error').hide();
    });
    document.getElementById("close").onclick="";
    $("#close").click(function(){
        $('#job_inactive_error').hide();
        $('#fade_error_warning').hide();
        $('#fade_error').hide();
    });
}

// See 581 function validateBasicInfo
function validateJobSeekerNewOnInactiveButtonClick() {
    firstName = document.getElementById('job_seeker_first_name');
    lastName = document.getElementById('job_seeker_last_name');
    email = document.getElementById('job_seeker_email');
    //pincode = document.getElementById('job_seeker_zip_code');
    city = document.getElementById('job_seeker_city');
    password = document.getElementById('job_seeker_password');
    rePassword = document.getElementById('job_seeker_password_confirmation');
    tc = document.getElementById('privacyText').checked;
    errorBox = document.getElementById('error_msg');
    error_element = document.getElementById('error_type');
	
    if(tc && validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(lastName) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value) && validateNotEmpty(city)) {
		
    }
    else {
        if(!validateNotEmpty(firstName)) {
            $("#"+firstName.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+firstName.id).parent().addClass("input-text-error-empty");
        }
        if(!validateNotEmpty(lastName)) {
            $("#"+lastName.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+lastName.id).parent().addClass("input-text-error-empty");
        }
        if(!validateNotEmpty(email)) {
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error-empty");
        }
        else if(!validateEmail(email.value)) {
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error");
        }
        if(!validateNotEmpty(password)) {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-error-empty");
        }
		
        if(!validateNotEmpty(rePassword)) {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-error-empty");
        }
        else if(password.value!=rePassword.value) {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-error");
        }
		
        if(!validateNotEmpty(city)) {
            $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+city.id).parent().addClass("input-text-error-empty");
        }
        if(!tc){
            // Change checkbox image!
            $("#privacyText").prev().css("background-position","0pt -100px")
        }
		
        errorBox.innerHTML="Please complete the areas highlighted in red.";
    }
}
function validateJobSeekerNewOnInactiveButtonClickSnR() {
    firstName = document.getElementById('job_seeker_first_name');
    lastName = document.getElementById('job_seeker_last_name');
    email = document.getElementById('job_seeker_email');
    //pincode = document.getElementById('job_seeker_zip_code');
    city = document.getElementById('job_seeker_city');
    password = document.getElementById('job_seeker_password');
    rePassword = document.getElementById('job_seeker_password_confirmation');
    tc = document.getElementById('privacyText').checked;
    errorBox = document.getElementById('error_msg');
    error_element = document.getElementById('error_type');
	
    if(validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(lastName) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value) && validateNotEmpty(city)) {
		
    }
    else {
        if(!validateNotEmpty(firstName)) {
            $("#"+firstName.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+firstName.id).parent().addClass("input-text-error-empty");
        }
        if(!validateNotEmpty(lastName)) {
            $("#"+lastName.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+lastName.id).parent().addClass("input-text-error-empty");
        }
        if(!validateNotEmpty(email)) {
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error-empty");
        }
        else if(!validateEmail(email.value)) {
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-error");
        }
        if(!validateNotEmpty(password)) {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-error-empty");
        }
		
        if(!validateNotEmpty(rePassword)) {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-error-empty");
        }
        else if(password.value!=rePassword.value) {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-error");
        }
		
        if(!validateNotEmpty(city)) {
            $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+city.id).parent().addClass("input-text-error-empty");
        }
        /*
		else if(pincode.value.length != 5) {
			$("#"+pincode.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+pincode.id).parent().addClass("input-text-error");
		}
         */
		
        errorBox.innerHTML="Please complete the areas highlighted in red.";
    }
}

function checkURL(value) {
    var expression = /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i
    var expr_with_http = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/i
    if(expression.test(value) || expr_with_http.test(value)){
        return true;
    }else {
        return false;
    }
}

function validateProfileIntroOnInactiveButton() {
	
    email = document.getElementById('contact_email');
    button = document.getElementById('submit-button-intro');
    error = document.getElementById('intro-error');
    area_code = document.getElementById('area_code');
    error_type = document.getElementById('error_id');
    phone = document.getElementById('phone_one');
    website_1 = document.getElementById('website_1');
    website_title_1 = document.getElementById('website_title_1');
    website_2 = document.getElementById('website_2');
    website_title_2 = document.getElementById('website_title_2');
    website_3 = document.getElementById('website_3');
    website_title_3 = document.getElementById('website_title_3');
    error_type_website = document.getElementById('error_id_website');
    error_website = document.getElementById('error_msg_website');
	
    var flag = true;
	
    if(validateNotEmpty(website_1)) {
        if(!validateNotEmpty(website_title_1)) {
            $("#"+website_title_1.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_1.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_title_1.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_1.id).parent().addClass("active-input");
        }
    }
    else {
        if(validateNotEmpty(website_title_1)) {
            $("#"+website_1.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_1.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_1.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_1.id).parent().addClass("input-text");
            $("#"+website_title_1.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_1.id).parent().addClass("input-text");
        }
    }
	
    if(validateNotEmpty(website_2)) {
        if(!validateNotEmpty(website_title_2)) {
            $("#"+website_title_2.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_2.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_title_2.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_2.id).parent().addClass("active-input");
        }
    }
    else {
        if(validateNotEmpty(website_title_2)) {
            $("#"+website_2.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_2.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_2.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_2.id).parent().addClass("input-text");
            $("#"+website_title_2.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_2.id).parent().addClass("input-text");
        }
    }
	
    if(validateNotEmpty(website_3)) {
        if(!validateNotEmpty(website_title_3)) {
            $("#"+website_title_3.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_3.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_title_3.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_3.id).parent().addClass("active-input");
        }
    }
    else {
        if(validateNotEmpty(website_title_3)) {
            $("#"+website_3.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_3.id).parent().addClass("input-text-error-empty");
            flag = false;
        }
        else {
            $("#"+website_3.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_3.id).parent().addClass("input-text");
            $("#"+website_title_3.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+website_title_3.id).parent().addClass("input-text");
        }
    }
	
    if(flag==false) {
        error_website.innerHTML="Please complete the areas highlighted in red.";
    }
    else {
        error_website.innerHTML="";
    }
    if(document.getElementById('pref_one').checked) {
        if(!validateNotEmpty(area_code)){
            $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+area_code.id).parent().addClass("input-text-error-empty");
            error.innerHTML="Incomplete information.";
        }
        if(!validateNotEmpty(phone) ) {
            $("#"+phone.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+phone.id).parent().addClass("input-text-error-empty");
            error.innerHTML="Incomplete information.";
        }
    }
	
}

function validateEmptyBetaAccess(){
    var email = document.getElementById('coderequest_email');
    var flag = 1;
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
	
}

function validateEmptyForgotPswd(){
    var email = document.getElementById('email_id_email');
    var flag = 1;
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
	
}



function validateEmptyVerifyBirkman(){
    var fname = document.getElementById('first_name');
    var lname = document.getElementById('last_name');
    var email = document.getElementById('email');
    var bid = document.getElementById('birkman_id');
	
    var flag = 1;
	
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(fname)) {
        $("#"+fname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+fname.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
	
    if(!validateNotEmpty(lname)) {
        $("#"+lname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+lname.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(bid)) {
        $("#"+bid.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+bid.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
	
	
}

function checkKeyupForEnter(e){
    var code = e.keyCode;
    if(code == 13){
        /*
        if ($("#verify_button").hasClass("verify-button-active")){
            $('#verify_form').submit();
        }
         */
        if(!validateEmptyVerifyBirkman()){
            $('#verify_form').submit();
        }

    }
}

function checkEnterEventJobPayment(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#payment_verify_button").hasClass("verify-button-active")){
            $('#job_payment_form').submit();
        }

    }
}

function checkEnterForOneClick(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#confirm_button").hasClass("btn-Confirm-active")){
            if(validateEmptyOneClickPayment()){

            }
            else{
                $("#one_click_form").submit();
            }
        }
    }
}

function validateEmptyPayment(){
    var card_num = document.getElementById("card_num");
    var month = document.getElementById("month");
    var year = document.getElementById("year");
    var cvv = document.getElementById("cvv");
    var fname = document.getElementById("fname");
    var lname = document.getElementById("lname");
    var billing_address_one = document.getElementById("billing_address_one");
    var billing_city = document.getElementById("billing_city");
    var billing_zip = document.getElementById("billing_zip");
    var billing_area_code = document.getElementById("billing_area_code");
    var billing_telephone_number = document.getElementById("billing_telephone_number");
    var billing_state = document.getElementById("billing_state");
    var payment_card_type = document.getElementById('payment_card_type');
	
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
        cvv_length = 4;
    }
    else{
        card_length = 16;
        cvv_length = 3;
    }
	
    var flag = 1;
	
    if (payment_card_type.value == ''){
        flag = 0;
    }
	
    if(!validateNotEmpty(card_num)) {
        $("#"+card_num.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(card_num.value.length<card_length) {
        $("#"+card_num.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-error");
        flag = 0;
		
    }
	
    if(!validateNotEmpty(fname)) {
        $("#"+fname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+fname.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
	
    if(!validateNotEmpty(lname)) {
        $("#"+lname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+lname.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(month)) {
        $("#"+month.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+month.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(year)) {
        $("#"+year.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+year.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(cvv)) {
        $("#"+cvv.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+cvv.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(cvv.value.length<cvv_length) {
        $("#"+cvv.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+cvv.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_address_one)) {
        $("#"+billing_address_one.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_address_one.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_city)) {
        $("#"+billing_city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_city.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_zip)) {
        $("#"+billing_zip.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_zip.value.length<3) {
        $("#"+billing_zip.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_area_code)) {
        $("#"+billing_area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_area_code.value.length<3) {
        $("#"+billing_area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_telephone_number)) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_telephone_number.value.length<7) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(billing_state.value == "") {
        $(".personal-info .state-selector-block .state-slector").addClass("error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
	
}

function validateEmptyOneClickPayment(){
    var email = document.getElementById('pay_name');
    var password = document.getElementById('pay_pass');
	
    var flag = 1;
	
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(password)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validatePassword(password.value)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
}

function checkKeyupForEnter_Payment(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#payment_verify_button").hasClass("complete")){
            $('#payment_billing_popup').submit();
        }

    }
}

function validateEmptyAuth(){
    var email = document.getElementById('hilo_email');
    var password = document.getElementById('hilo_password');
	
    var flag = 1;
	
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(password)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validatePassword(password.value)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
}

function checkEnterForForm(e, buttonID, formID, classname){
    var code = e.keyCode;
    if(code == 13){
        if ($("#"+buttonID).hasClass(classname)){
            var email = $("#"+formID+" .email").val();
            var password = $("#"+formID+" .password").val();
            var flag = 1;
            if(!validateEmail(email)) {
                $("#"+formID+" .email").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+formID+" .email").parent().addClass("input-text-error");
                flag = 0;
            }

            if(!validatePassword(password)) {
                $("#"+formID+" .password").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#"+formID+" .password").parent().addClass("input-text-error");
                flag = 0;
            }
            if(flag)
                $("#"+formID).submit();
        }
    }
}

function validateCardNum(){
    var card_num = document.getElementById("card_num");
	
    var payment_card_type = document.getElementById('payment_card_type');
	
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
    //cvv_length = 4;
    }
    else{
        card_length = 16;
    //cvv_length = 3;
    }
	
    if(card_num.value.length==card_length) {
        $("#"+card_num.id).parent().removeClass("input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-active");
		
		
    }
}

function validateCardNumGift(){
    var card_num = document.getElementById("card_num_gift");

    var payment_card_type = document.getElementById('gift_payment_card_type');
    
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
    //cvv_length = 4;
    }
    else{
        card_length = 16;
    //cvv_length = 3;
    }

    if(card_num.value.length==card_length) {
        $("#"+card_num.id).parent().removeClass("input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-active");


    }
}

function validateTel(){
    var billing_telephone_number = document.getElementById("billing_telephone_number");
    if(billing_telephone_number.value.length==7) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-active");
    }
}

function validateTelGift(){
    var billing_telephone_number = document.getElementById("billing_telephone_number_gift");
    if(billing_telephone_number.value.length==7) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-active");
    }
}

function validateAreaCode(){
    var billing_area_code = document.getElementById("billing_area_code");
    if(billing_area_code.value.length==3) {
        $("#"+billing_area_code.id).parent().removeClass("input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-active");
    }
}

function validateAreaCodeGift(){
    var billing_area_code = document.getElementById("billing_area_code_gift");
    if(billing_area_code.value.length==3) {
        $("#"+billing_area_code.id).parent().removeClass("input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-active");
    }
}

function validateZip(){
    var billing_zip = document.getElementById("billing_zip");
    if(billing_zip.value.length>2) {
        $("#"+billing_zip.id).parent().removeClass("input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-active");
    }
	
}

function validateZipGift(){
    var billing_zip = document.getElementById("billing_zip_gift");
    if(billing_zip.value.length>2) {
        $("#"+billing_zip.id).parent().removeClass("input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-active");
    }

}

function validateEmptyDiscount(){
    var discount = document.getElementById('coderequest_promotional_code');
    var flag = 1;
    if(!validateNotEmpty(discount)) {
        $("#"+discount.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+discount.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
}

function unbindKeydown(){
    $(document).unbind('keydown');
}
function open_skill_tooltip_popup(){
    var _offset = $('#skillpopup-id').offset();
    var _left = _offset.left;
    var _top = _offset.top+15;
    $('#skill-tooltip').css({
        left:_left,
        top:_top
    }).show();
    $('.black_overlay_skill').show();
    return false;
}
function open_cert_tooltip_popup(){
    var _offset = $('#lic_cert_id').offset();
    var _left = _offset.left;
    var _top = _offset.top+15;
    $('#cert-tooltip').css({
        left:_left,
        top:_top
    }).show();
    $('.black_overlay_skill').show();
    return false;
}
function close_skill_tooltip_popup(){
    $('#skill-tooltip').hide();
    $('.black_overlay_skill').hide();
    return false;
}
function close_cert_tooltip_popup(){
    $('#cert-tooltip').hide();
    $('.black_overlay_skill').hide();
    return false;
}

function validateEmptyGiftPayment(){
    var card_num = document.getElementById("card_num_gift");
    var month = document.getElementById("month_gift");
    var year = document.getElementById("year_gift");
    var cvv = document.getElementById("cvv_gift");
    var fname = document.getElementById("fname_gift");
    var lname = document.getElementById("lname_gift");
    var billing_address_one = document.getElementById("billing_address_one_gift");
    var billing_city = document.getElementById("billing_city_gift");
    var billing_zip = document.getElementById("billing_zip_gift");
    var billing_area_code = document.getElementById("billing_area_code_gift");
    var billing_telephone_number = document.getElementById("billing_telephone_number_gift");
    var billing_state = document.getElementById("billing_state_gift");
    var payment_card_type = document.getElementById('gift_payment_card_type');
	
    if (payment_card_type.value == 'american_express'){
        card_length = 15;
        cvv_length = 4;
    }
    else{
        card_length = 16;
        cvv_length = 3;
    }
	
    var flag = 1;
	
    if (payment_card_type.value == ''){
        flag = 0;
    }
	
    if(!validateNotEmpty(card_num)) {
        $("#"+card_num.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(card_num.value.length<card_length) {
        $("#"+card_num.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+card_num.id).parent().addClass("input-text-error");
        flag = 0;
		
    }
	
    if(!validateNotEmpty(fname)) {
        $("#"+fname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+fname.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
	
    if(!validateNotEmpty(lname)) {
        $("#"+lname.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+lname.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(month)) {
        $("#"+month.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+month.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(year)) {
        $("#"+year.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+year.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(cvv)) {
        $("#"+cvv.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+cvv.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(cvv.value.length<cvv_length) {
        $("#"+cvv.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+cvv.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_address_one)) {
        $("#"+billing_address_one.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_address_one.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_city)) {
        $("#"+billing_city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_city.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_zip)) {
        $("#"+billing_zip.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_zip.value.length<3) {
        $("#"+billing_zip.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_area_code)) {
        $("#"+billing_area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_area_code.value.length<3) {
        $("#"+billing_area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(billing_telephone_number)) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(billing_telephone_number.value.length<7) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(billing_state.value == "") {
        $(".personal-info .state-selector-block .state-slector").addClass("error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
	
}

function checkEnterCheckoutBilling(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#gifts_payment_verify_button").hasClass("buy-gift-button-active")){
            $('#chechout_billing_form').submit();
        }

    }
}

function checkEnterGiftBilling(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#gifts_payment_verify_button").hasClass("buy-gift-button-active")){
            $('#form_gift_payment').submit();
        }

    }
}

function open_seeker_analyzer_popup(){
    var _offset = $('.envNrole-cont').offset();
    var _left = _offset.left-613;
    var _top = _offset.top-96;
    $('#envNrole-cont-seeker-analyzer-popup').css({
        left:_left,
        top:_top
    }).show();
    $('.black_seeker_analyzer').show();
    return false;
}

function close_seeker_analyzer_popup(){
    $('#envNrole-cont-seeker-analyzer-popup').hide();
    $('.black_seeker_analyzer').hide();
    return false;
}


function validateEmptyOneClickPaymentGift(){
    var email = document.getElementById('gift_pay_name');
    var password = document.getElementById('gift_pay_pass');
	
    var flag = 1;
	
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(password)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validatePassword(password.value)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
}

function validateEmptyGiftAuth(){
    var email = document.getElementById('username_gift');
    var password = document.getElementById('password_gift');
	
    var flag = 1;
	
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(!validateNotEmpty(password)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error-empty");
        flag = 0;
		
    }
    else if(!validatePassword(password.value)) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error");
        flag = 0;
    }
	
    if(flag)
        return false;
    else
        return true;
}


function gift_field_not_empty(){
    var senders_name = document.getElementById('senders_name');
    var senders_email = document.getElementById('senders_email');
    var recipients_name = document.getElementById('recipients_name');
    var recipients_email = document.getElementById('recipients_email');
    var verify_recipients_email = document.getElementById('verify_recipients_email');
    var personal_msg = document.getElementById('personal_msg');

    var flag = 1;

    if (!validateNotEmpty(senders_name)){
        $("#"+senders_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+senders_name.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    
    if(!validateNotEmpty(senders_email)){
        $("#"+senders_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+senders_email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(!validateEmail(senders_email.value)) {
        $("#"+senders_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+senders_email.id).parent().addClass("input-text-error");
        flag = 0;
    }

    if(!validateNotEmpty(recipients_name)){
        $("#"+recipients_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+recipients_name.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }

    if(!validateNotEmpty(recipients_email)){
        $("#"+recipients_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+recipients_email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(!validateEmail(recipients_email.value)) {
        $("#"+recipients_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+recipients_email.id).parent().addClass("input-text-error");
        flag = 0;
    }

    if(!validateNotEmpty(verify_recipients_email)){
        $("#"+verify_recipients_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+verify_recipients_email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if($("#recipients_email").val() != $("#verify_recipients_email").val()){
        $("#"+verify_recipients_email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+verify_recipients_email.id).parent().addClass("input-text-error");
        flag = 0;
    }

    if(!validateNotEmpty_ta(personal_msg)){
        $("#"+personal_msg.id).parent().parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+personal_msg.id).parent().parent().addClass("input-text-error-empty-ta");
        flag = 0;
    }

    if (flag != 0){
        showPurchaseReviewPopup();
    }
    else if ($("#gift_hilo_error_msg").html() == ""){
        $("#gift_hilo_error_msg").html("Please complete the areas highlighted in red.");
        $("#gift_hilo_error_msg").show();
    }
}

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_free_access = function(){
        if(!validateBetaEmail(document.getElementById('coderequest_email'))) {
            return false;
        };
        disableForm(this);
        showBlockShadow();
        $('#beta_button').hide();
        $('#loader_img1').show();
        callBetaAccessPlayer('betaAccessVideoPlayer','stopVideo');
    }
    var loaded_free_access = function(){
        hideBlockShadow();
        $('#beta_button').show();
        $('#loader_img1').hide();
        $('#coderequest_email').blur();
        enableForm(this);
        resetBetaAccessFormSubmit();
    }
    $("#beta_form")
    .bind("ajax:beforeSend", loading_free_access)
    .bind("ajax:complete", loaded_free_access)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_login = function(){
        login_status.before_call();
    }
    
    $("#login_form")
    .bind("ajax:beforeSend", loading_login)
    
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_forgot_pswd_form = function(){
        if(validateEmptyForgotPswd()){
            return false;
        }
    }

    $("#forgot_pswd_form")
    .bind("ajax:beforeSend", loading_forgot_pswd_form)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_forgot_pswd = function(){
        if(!validateForgotPassEmail(document.getElementById('email_id_email'))) {
            return false;
        };
        $('#submit_button').hide();
        $('#loader_img2').show();
        $("#email_id_email").blur();
    }
    var loaded_forgot_pswd = function(){
        $('#submit_button').show();
        $('#loader_img2').hide();
    }
    $("#forgot_pswd_form")
    .bind("ajax:beforeSend", loading_forgot_pswd)
    .bind("ajax:complete", loaded_forgot_pswd)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_birkman_yes = function(){
        showBlockShadow();
        $('#verify_button').hide();
        $('#loader-img').show();
        $('a#lostBirkmanId').hide();
        $('label#forgotBirkmanId').show();
    }
    var loaded_birkman_yes = function(){
        hideBlockShadow();
        $('#verify_button').show();
        $('#loader-img').hide();
        $('a#lostBirkmanId').show();
        $('label#forgotBirkmanId').hide();
    }
    $("#verify_form")
    .bind("ajax:beforeSend", loading_birkman_yes)
    .bind("ajax:complete", loaded_birkman_yes)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_cant_find_promo = function(){
        if(!validateBetaEmail(document.getElementById('coderequest_email'))) {
            return false;
        };

        $('#beta_button').hide();
        $('#loader_img1').show();
        showNormalShadow();
        showBlockShadow();
    }
    var loaded_cant_find_promo = function(){
        hideBlockShadow();
        $('#beta_button').show();
        $('#loader_img1').hide();
        $('#coderequest_email').blur();
    }
    $("#cant_find_promo_form")
    .bind("ajax:beforeSend", loading_cant_find_promo)
    .bind("ajax:complete", loaded_cant_find_promo)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_payment_cc_form = function(){
        if ($("#finish-button-success").is(':visible')){
            return false;
        }
        $('#payment_header').text('CREDIT CARD BILLING INFORMATION');
        showBlockShadow();
        $('#verify-loader-img').show();
        $('#payment_verify_button').hide();
        paymentHandlerStart();
    }
    var loaded_payment_cc_form = function(){
        paymentHandlerStop();
    }
    var error_payment_cc_form = function(){
        paymentHandlerStop();
    }
    $("#payment_billing_popup")
    .bind("ajax:beforeSend", loading_payment_cc_form)
    .bind("ajax:complete", loaded_payment_cc_form)
    .bind("ajax:error", error_payment_cc_form)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_search_roles = function(){
        showBlockShadow();
        $("#searchRoleClicked").val(1);
        $("div#duplicateRoleErrorMsg").hide();
    }
    var loaded_search_roles = function(){
        hideBlockShadow();
    }
    $("#search-roles-credentials")
    .bind("ajax:beforeSend", loading_search_roles)
    .bind("ajax:complete", loaded_search_roles)
});

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_auth_form = function(){
        $('#enter_auth').hide();
        $('#loader_img_auth').show();
    }
    
    $("#auth_form")
    .bind("ajax:beforeSend", loading_auth_form)
});

/*
jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_change_personal_details = function(){
        $('#update1').hide();
        $('#loader_name').show();
    }

    $("#change_personal_details")
    .bind("ajax:beforeSend", loading_change_personal_details)
});
 */

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_change_password_form = function(){
        $('#update2').hide();
        $('#loader_password').show();
    }

    $("#change_password_form")
    .bind("ajax:beforeSend", loading_change_password_form)
});

function bridge_menu_handler(whatToOpen) {
    $(".cs-introduction-container").each(function(){
        $(this).hide();
    });
    if(whatToOpen=="intro") {
        if($('#bridge_user_response').val()=="no")
            $(".cs-introduction-container#step1-nothanks").show();
        else
            $(".cs-introduction-container#step1-learn-more").show();
    }
    else if(whatToOpen=="cfg") {
        $(".cs-introduction-container#step2-cfg").show();
        var active_pane = $("#toolbar-personality li.active").attr('id');
        active_pane = active_pane.split("-");
        active_pane = active_pane[0]+"-pane";
        ScrollSectionPersonality('role-pane', 'personalityScroller', 'role-pane');
        ScrollSectionPersonality(active_pane, 'personalityScroller', 'role-pane');
    }
    else if(whatToOpen=="position-detail") {
        $(".cs-introduction-container#step3-position-detail").show();
    }
    else if(whatToOpen=="pricing") {
        $(".cs-introduction-container#step4-pricing").show();
    }
}

function bridge_stopVideos() {
    closeVPlayer('step4-pricing-video','pauseVideo');
    closeVPlayer('step1-nothanks-video','pauseVideo');
    closeVPlayer('step1-learn-more-video','pauseVideo');
}

function set_session_for_bridge() {
    $.ajax({
        type: 'POST',
        url: "/job/capture_user_response_for_bridge",
        data: "response="+$('#bridge_user_response').val()+"&job_id="+$('#track_shared_job_id').val()+"&platform_id="+$('#track_shared_platform_id').val(),
        cache: false,
        success: function(){
            window.location='/job_seeker/new';
        }
    });
}

function set_session_for_comp_bridge(){
    $.ajax({
        type: 'POST',
        url: "/company_postings/capture_sessions",
        data: "response="+$('#bridge_response').val()+"&comp_id="+$('#track_shared_company_id').val()+"&platform_id="+$('#track_shared_platform_id').val(),
        cache: false,
        success: function(){
            window.location='/job_seeker/new';
        }
    });
}

function set_session_for_ics_bridge(){
    $.ajax({
        type: 'POST',
        url: "/company_internal_candidates/capture_sessions",
        data: "response="+$('#bridge_response').val()+"&comp_id="+$('#track_shared_company_id').val()+"&platform_id="+$('#track_shared_platform_id').val()+"&random_token="+$('#random_token').val()+"&internal_candidate="+$('#internal_candidate').val(),
        cache: false,
        success: function(){
            window.location='/job_seeker/new';
        }
    });
}

function centerPopupNew(){
    //request data for centering
    var windowWidth = document.documentElement.clientWidth;
    //var windowHeight = document.documentElement.clientHeight;
    //var popupHeight = $(".credentials_exploreSelectDesiredRole").height();
    var popupWidth = $(".credentials_exploreSelectDesiredRole").width();
    //centering
    $(".credentials_exploreSelectDesiredRole").css({
        "position": "absolute",
        "top": 20+"px"
    });
    centralizePopup();
}

function showMilitaryPopup(){
    showNormalShadow();
    $('#military_details').show();
    centralizePopup();
    $('#enter').focus();
}

function viewCreditHistory() {
    $.ajax({
        url: "/ajax/credit_history",
        beforeSend: function() {
            showBlockShadow();
        },
        cache: false
    });
}

function viewPaymentHistory() {
    $.ajax({
        url: "/ajax/payment_history",
        beforeSend: function() {
            showBlockShadow();
        },
        cache: false
    });
}

function openCredentialsForUpdate() {
    window.location.href='/account/pairing_profile?show=credential';
}

function CatchTab(ele, e){
    if(e.keyCode==9){
        if(ele == 'hilo_email'){
            $('#hilo_email').blur();
            $('#hilo_password').focus();
        }
        else if(ele == 'hilo_password'){
            $('#hilo_password').blur();
            $('#enter_auth').focus();
        }
        else if(ele == 'enter_auth'){
            $('#enter_auth').blur();
            $('#hilo_email').focus();
        }
        e.stopImmediatePropagation();
        e.preventDefault();
    }
}

function calculateChars(obj, max, attr){
    var dest = "";
    var char_length = 0;
    if($(obj).is("textarea")){
        setMaxLength(obj, max);
        char_length = obj.value.length;
        if (attr == "job_seeker"){
            dest = $("#count_holder");
        }
        else {
            dest = $(obj).parent().parent().parent().prev().find("span.character-remaining");
        }
    }else{
        dest = $("#resp_char_remain");
        char_length = $(obj).val().length;
    }

    var char_remaining=max;
    max = parseInt(max, 10);
    if($(obj).val()==$(obj).prev().val())
        char_remaining=max;
    else{
        char_remaining = max - char_length;
    }
    dest.text(char_remaining);
    return;
}

function setMaxLength(obj, mlength){
    if (obj.getAttribute && obj.value.length>mlength)
        obj.value=obj.value.substring(0,mlength)
}

function showSaveSerach(){
    $('#search_name').val('');
    $('#search_name').blur();
    $('#search_name').parent().removeClass('input-text-error-empty').addClass('input-text');
    $("#save_search_popup").show();
    showNormalShadow();
    //$("#show_search").hide();
    centralizePopup();
    $('#search_name').focus();
    $('#search_name').parent().removeClass('input-text-active').addClass('input-text-unactive');
}

function closeSaveSearch(){
    $("#save_search_popup").hide();
    hideNormalShadow();
}

function saveSearchKeyword(){
    if (searchAjax){
        $.ajax({
            type: 'POST',
            url:'/ajax/save_seeker_search',
            cache:false,
            data: 'keyword='+encodeURIComponent($('#search_value').val())+'&name='+encodeURIComponent($('#search_name').val()),
            beforeSend: function(){
                if($('#search_name').val().trim() == $('#search_name_placeholder').val() || $('#search_name').val().trim() == ""){
                    $("#search_name").parent().removeClass('input-text-active active-input input-text').addClass('input-text-error-empty');
                    return false;
                }
                else{
                    searchAjax = false;
                }
                showBlockShadow();
                $('#save_search').hide();
                $('#search_save_loader').show();
            },
            success: function(){
                hideBlockShadow();
                $('#search_save_loader').hide();
                $('#save_search').show();
                closeSaveSearch();
                $("#show_search").hide();
                searchAjax = true;
            }

        })
    }
}

function copyToTextBox(e){
    document.getElementById('search').value = e.childNodes[0].getAttribute("keyword");
    $("#search-selector").hide();
    $("#search-selector .options-content").hide();
    $("#search").parent().removeClass('input-text').addClass('active-input');
    $("#save_show_emp").val('0');
    $('#show_search').hide();
}

function showOptions(e){
    if($("#search").parent().hasClass('input-text-error-empty')){
        $("#search").parent().removeClass('input-text-error-empty').addClass('input-text');
    }
    $("#search-selector").show();
    $("#search-selector .options-content").show();
    e.stopPropagation();
}

function setShowSave(){
    $("#save_show_emp").val('1');
}

function resetSearchChanges(){
    //reset search changes here
    $('.reset-container').css('visibility','hidden');
    $('#search_result_arr').val("-1");
    $('#show_search').hide();
    $('#search').parent().removeClass('input-text-error-empty input-text-error').addClass('input-text');
    $('tr').each(function(){
        if ($(this).attr('id') != undefined){
            if($(this).hasClass('filter')){
                $(this).removeClass('filter');
            }
        }
    });
    $("#search").val("");
    $("#search").blur();
    $('#save_show_emp').val('1');
    $('#error_msg_empty_table').hide();
}

function deleteSavedSearch(e, ev){
    $.ajax({
        type: 'POST',
        url: '/ajax/delete_saved_search',
        cache:false,
        data: 'saved_id='+e.getAttribute('id'),
        success: function(){
            if(e.parentNode.parentNode.childNodes.length-1 == 0){
                $(".arrow").hide();
                $("#search-selector").hide();
                $("#search-selector .options-content").hide();
            }
            e.parentNode.parentNode.removeChild(e.parentNode);
        }
    });
    ev.stopPropagation();
}

function checkForEnter(e){
    if(e.keyCode == 13){
        saveSearchKeyword();
    }
}

function validate_blur_search(){
    var obj = document.getElementById('search');
    if (!(validateNotEmpty(obj))){
        $(obj).parent().removeClass('input-text-error').addClass('input-text-active');
        $(obj).val('');
    }

}

function openCSLearnMorePopup() {
    $(".language-selector.career_seeker").addClass("white");
    hideLoginBox();
    showNormalShadow();
    //$('#sharing_external_login').show();
    $(".cs-introduction-container#step1-learn-more").show();
    $(".home-footer label").removeClass("year");
    $(".home-footer label").addClass("bridge");
    $(".signIn-button").addClass("bridge");
    $(".signIn-block").addClass("bridge");
    $(".white_content").css("z-index", "1011");
    centralizePopup();
    $("#bridge_user_response").val('bridge');
    $("#fade_normal").click(function(){
        closeCSLearnMorePopup();
    });
    $(".hilo_search_link").css('z-index','1003');
    $(".language-selector.career_seeker").css('z-index','1003');
}

function closeCSLearnMorePopup() {
    $(".language-selector.career_seeker").removeClass("white");
    hideNormalShadow();
    $(".cs-introduction-container").hide();
    $(".home-footer label").addClass("year");
    $(".home-footer label").removeClass("bridge");
    $(".signIn-button").removeClass("bridge");
    $(".signIn-block").removeClass("bridge");
    $(".white_content").css("z-index", "1002");
    $("#bridge_user_response").val('');
    bridge_stopVideos();
}
var graph_ajax_1, graph_ajax_2, graph_ajax_3, graph_ajax_4;
function location_graph(lat, lng, src, fullscreen){
    if(fullscreen){
        showBlockShadow();
        $.ajax({
            type: 'POST',
            url: '/hilo_search/location_graph',
            data: 'lat='+lat+'&long='+lng+'&src='+src+'&fullscreen='+fullscreen,
            cache: false,
            success: function(data){
                hideBlockShadow();
                $("#fade_white").html(data);
                $("#fade_white").show();
            }
        });
        return;
    }
    $('.button-container').show();
    $('.graph_boxes').show();
    $("#location_graph .graph-loader").next().remove();
    $("#location_graph .graph-loader").show();
    if(graph_ajax_1)
        graph_ajax_1.abort();
    graph_ajax_1 = $.ajax({
        type: 'POST',
        url: '/hilo_search/location_graph',
        data: 'lat='+lat+'&long='+lng+'&src='+src,
        cache: false,
        success: function(data){
            $("#location_graph .graph-loader").next().remove();
            $("#location_graph .graph-loader").hide();
            $('#location_graph').append(data);
            $('.graph_boxes').show();
        }
    });
}

function birkman_graph(lat, lng, src, fullscreen){
    if(fullscreen){
        showBlockShadow();
        $.ajax({
            type: 'POST',
            url: '/hilo_search/birkman_graph',
            data: 'lat='+lat+'&long='+lng+'&src='+src+'&fullscreen='+fullscreen,
            cache: false,
            success: function(data){
                hideBlockShadow();
                $("#fade_white").html(data);
                $("#fade_white").show();
            }
        });
        return;
    }
    $("#birkman_graph .graph-loader").next().remove();
    $("#birkman_graph .graph-loader").show();
    if(graph_ajax_2)
        graph_ajax_2.abort();
    graph_ajax_2 = $.ajax({
        type: 'POST',
        url: '/hilo_search/birkman_graph',
        data: 'lat='+lat+'&long='+lng+'&src='+src,
        cache: false,
        success: function(data){
            $("#birkman_graph .graph-loader").next().remove();
            $("#birkman_graph .graph-loader").hide();
            $('#birkman_graph').append(data);
            $('.graph_boxes').show();
        }
    });
}

function role_cluster_graph(lat, lng, src, fullscreen){
    if(fullscreen){
        showBlockShadow();
        $.ajax({
            type: 'POST',
            url: '/hilo_search/role_cluster_graph',
            data: 'lat='+lat+'&long='+lng+'&src='+src+'&fullscreen='+fullscreen,
            cache: false,
            success: function(data){
                hideBlockShadow();
                $("#fade_white").html(data);
                $("#fade_white").show();
            }
        });
        return;
    }
    $("#role_cluster_graph .graph-loader").next().remove();
    $("#role_cluster_graph .graph-loader").show();
    if(graph_ajax_3)
        graph_ajax_3.abort();
    graph_ajax_3 = $.ajax({
        type: 'POST',
        url: '/hilo_search/role_cluster_graph',
        data: 'lat='+lat+'&long='+lng+'&src='+src,
        cache: false,
        success: function(data){
            $("#role_cluster_graph .graph-loader").next().remove();
            $("#role_cluster_graph .graph-loader").hide();
            $('#role_cluster_graph').append(data);
            $('.graph_boxes').show();
        }
    });
}

function wordle_graph(lat, lng, src, fullscreen){
    if(fullscreen){
        showBlockShadow();
        $.ajax({
            type: 'POST',
            url: '/hilo_search/wordle_graph',
            data: 'lat='+lat+'&long='+lng+'&src='+src+'&fullscreen='+fullscreen,
            cache: false,
            success: function(data){
                hideBlockShadow();
                $("#fade_white").html(data);
                $("#fade_white").show();
            }
        });
        return;
    }
    $('.graph_boxes').show();
    $("#wordle_graph .graph-loader").next().remove();
    $("#wordle_graph .graph-loader").show();
    if(graph_ajax_4)
        graph_ajax_4.abort();
    graph_ajax_4 = $.ajax({
        type: 'POST',
        url: '/hilo_search/wordle_graph',
        data: 'lat='+lat+'&long='+lng+'&src='+src,
        cache: false,
        success: function(data){
            $("#wordle_graph .graph-loader").next().remove();
            $("#wordle_graph .graph-loader").hide();
            $('#wordle_graph').append(data);
            $('.graph_boxes').show();
        }
    });
}

function showHiloEmailPopup(){
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $(".hilo_search_link").css('z-index','1003');
        $(".language-selector.career_seeker").css('z-index','1003');
        $(".language-selector.career_seeker").addClass("white");
        $("#fade_normal_second").show();
    }
    else {
        $(".hilo_search_link").css('z-index','1');
        $(".language-selector.career_seeker").css('z-index','1');
        $(".language-selector.career_seeker").removeClass("white");
        showNormalShadow();
    }
    $('#hilo_email_popup').show();
    $("#guest_job_seeker_email").val('Email');
    $("#guest_job_seeker_email").parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $("#guest_job_seeker_email").parent().addClass('input-text');
    addFocusTextField('guest_job_seeker_email');
    centralizePopup();
    $(".home-footer .year").addClass('bridge');
    $('#submit_button_hilo_search').unbind('click').bind('click', function(){
        if(validateEmptyHiloEmail()){

        }
        else{
            $("#create_guest_job_seeker").submit();
        }
    });
}

function closeHiloEmailPopup() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_normal_second").hide();
    }
    else {
        hideNormalShadow();
    }
    $('#hilo_email_popup').hide();
    $('.home-footer .year').removeClass('bridge');
    
}

function checkForGuestSearchEnter(e){
    if (e.keyCode == 13){
        if(validateEmptyHiloEmail()){
            prevDefault(e);
        }
        else{
            $("#create_guest_job_seeker").submit();
        }
    }
}

function validateEmptyHiloEmail(){
    var email = document.getElementById('guest_job_seeker_email');
    var flag = 1;
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = 0;
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
        flag = 0;
    }

    if(flag)
        return false;
    else
        return true;
}

function closeGraphFullScreen() {
    $('#fade_white').html('');
    $('#fade_white').hide();
    $('body').removeAttr('style');
}

function validateSearchLocationOnBlur(element){
    var location = document.getElementById('location');
    if(!validateNotEmpty(location)) {
        $(location).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
        $(location).parent().addClass("input-text");
    }
    setTimeout(function(){
        if(validateNotEmpty(location)) {
            if($("#search_dropdown_check_flag").val() == "0") {
                $(location).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
                $(location).parent().addClass("input-text-error");
            } else {
                $(location).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
                $(location).parent().addClass("active-input");
            }
        } else {
            $(location).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $(location).parent().addClass("input-text");
        }
    }, 1000);
}

function prevDefault(e)//Function to prevent Default Events
{
    if (e.preventDefault)
        e.preventDefault();
    else
        e.returnValue = false;
}

var job_seeker_delete = {
    showDeleteConfirmationPopup: function(){
        showBlockShadow();
        $.ajax({
            url: '/ajax/delete_confirmation',
            cache: false,
            success: function(){
                hideBlockShadow();
                showErrorShadow();
                $('#delete_confirmation_popup').show();
                centralizePopup();
                addFocusButton('delete_confirmation_popup_cancel_button');
            }
        });
    },
    hideDeleteConfirmationPopup: function(){
        $('#delete_confirmation_popup').hide();
        hideErrorShadow();
    },
    continueDeleteConfirmationPopup: function(){
        $.ajax({
            url: '/ajax/continue_delete_confirmation',
            cache: false,
            success: function(){
                
            }
        });
    }
}

function showHiloEmployerSearchPopup(){
    showNormalShadow();
    $('#hilo_employer_search_popup').show();
    $(".footer-links .hilo").addClass('white');
    addFocusButton('hilo_employer_search_popup_button');
}

function hideHiloEmployerSearchPopup(){
    hideNormalShadow();
    $('#hilo_employer_search_popup').hide();
    $('.footer-links .hilo').removeClass('white');
}

function showHiloSearchWorkEnv(){
    showBlockShadow();
    $.ajax({
        url: '/ajax/show_hilo_search_work_env',
        cache: false,
        success: function(){
            
        }
    });
}

function hideHiloSearchWorkEnv(){
    hideNormalShadow();
    $('#hilo_search_work_env_popup').hide();
    $('.footer-links .hilo').removeClass('white');
}

function hideSearchJobSeekersFewRecordPopup(msg, from){

    if (msg == 'no_record'){
        if (from == 'employer'){
            window.location.href = "/employer/index";
        }
        else if (from == 'job_seeker'){
            window.location.href = "/home/index";
        }
    }
    else if (msg == 'record'){
        hideErrorShadow();
        $("#hilo_search_job_seekers_few_records").hide();
        $(".footer-links .hilo").removeClass('white');
    }
}

function selectCityFromPopup(obj, hidden_id){
    $("input#location").blur();
    $('#location').val($('#'+hidden_id+"_name_placeholder").val());
    $("#search_latitude").val($('#'+hidden_id).val().split('_')[0]);
    $("#search_longitude").val($('#'+hidden_id).val().split('_')[1]);
    $('#search_dropdown_check_flag').val('1');
    $('#location').parent().removeClass("input-text input-text-active active-input input-text-error");
    $('#location').parent().addClass("active-input");
    hideSearchJobSeekersFewRecordPopup('record');
    $('a#submitSearchJobSeekersform').click();
}

function closeSearchJobMsgPopup(){
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_normal_second").hide();
    }
    else {
        hideNormalShadow();
    }
    $('#search_job_msg').hide();
    $('.home-footer .year').removeClass('bridge');
}

function hideSearchJobMsg(){
    $('#hilo_search_work_env_job').hide();
    hideNormalShadow();
}

function refreshHandler(){
    $("#search").val();
    $("#search").blur();
    $(".activity-list").children().each(function(){
        if($(this).hasClass('active')){
            $(this).click();
            return false;
        }
    });
    $("#my_hilo_heading").click();
    hideRefreshLink();
}

function hideRefreshLink(){
    if($("#refresh_link")){
        $("#refresh_link").children().unbind();
        $("#refresh_link").hide();
    }
}
