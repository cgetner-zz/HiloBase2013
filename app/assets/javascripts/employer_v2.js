Array.prototype.has = function(value) {
    var i;
    for (var i = 0, loopCnt = this.length; i < loopCnt; i++) {
        if (this[i] == value) {
            return true;
        }
    }
    return false;
};

Array.prototype.clear = function() {
    this.splice(0, this.length);
};

var addFolderFlag = 1;

$(function(){
    $.extend($.fn.disableTextSelect = function() {
        return this.each(function(){
            if($.browser.mozilla){//Firefox
                $(this).css('MozUserSelect','none');
            }
            else if($.browser.msie){//IE
                $(this).bind('selectstart',function(){
                    return false;
                });
            }else{//Opera, etc.
                $(this).mousedown(function(){
                    return false;
                });
            }
        });
    });
});

String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
}

Array.prototype.clean = function(deleteValue) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == deleteValue) {
            this.splice(i, 1);
            i--;
        }
    }
    return this;
};

var timer = "";
var searchAjax = true;
var bodyWidth = $(document).width();
$(window).resize(function() {
    bodyWidth = $(document).width();
    centralizePopup();
    $('#fade_white .header').width($('#fade_white').width()-50);
    if($("#credentials_exploreSelectDesiredRole").is(':visible')) {
        try
        {
            var _leftoffset = $('.highlightCls').offset().left;
            var _topoffset = $('.highlightCls').offset().top - parseInt($(window).scrollTop());
            ;

            if($("ul#career_clusters li").hasClass("highlightCls")) {
                $(".career_path_left").css("left",_leftoffset+275+"px");
            }
            $(".career_path_left").css({
                top:_topoffset-5+"px"
            });

            _leftoffset = $('.highlightCls_path').offset().left;
            _topoffset = $('.highlightCls_path').offset().top - parseInt($(window).scrollTop());
            ;

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


$(document).ready(function () {
    placeholderReplace();
//convert radio buttons into customize radio buttons
});

(function($) {
    $.fn.hasScrollBar = function() {
        return this.get(0).scrollHeight > this.height();
    }
})(jQuery);
function placeholderReplace(){
    $('[placeholder]').keydown(function() {
        var input = $(this);
        if(input.hasClass('support-placeholder')){
            if (input.val() == input.attr('placeholder')) {
                input.val('');
                // change class from placeholder to something else
                input.removeClass('placeholder');
                input.addClass('filled-input');
                input.parent().parent().parent().parent().removeClass("error");
            }
        }
    }).blur(function() {
        var input = $(this);
        if(input.hasClass('support-placeholder')){
            if (input.val() == ''){ // || input.val() == input.attr('placeholder')) {
                // change class from placeholder to something else
                input.addClass('placeholder');
                input.removeClass('filled-input');
                input.val(input.attr('placeholder'));
            }
        }
    }).blur().parents('form').submit(function() {
        $(this).find('[placeholder]').each(function() {
            var input = $(this);
            if (input.val() == input.attr('placeholder')) {
                input.val('');
            }
        })
    });
}

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
    $(".footer-links .hilo").addClass('white');
}

function hideTermsPopup() {
    hideNormalShadow();
    showVideo();
    $("#terms_of_use").hide();
    $(".footer-links .hilo").removeClass('white');
}
function hideVideo() {
    $("#jw_player").hide();
}
function showVideo() {
    $("#jw_player").show();
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

function centralizePopup() {
    bodyWidth = $(document).width();
    var popupWidth = 0;
    var left = 0;
    $(".white_content").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-10;
        $(this).css("left",left+"px");
    });
    $(".detiled_content").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-10;
        $(this).css("left",left+"px");
    });
    $(".one_click_payment_position_white_content").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-20;
        $(this).css("left",left+"px");
    });
    $(".one_click_payment_position_white_positionProfile").each(function() {
        $(this).children().each(function(){
            popupWidth = $(this).width();
            return false;
        });
        left = ((bodyWidth - popupWidth)/2)-20;
        $(this).css("left",left+"px");
    });
    $(".credentials_exploreSelectDesiredRole").each(function() {
        popupWidth = 870;
        left = ((bodyWidth - popupWidth)/2)-10;
        $(this).css("left",left+"px");
    });
}

function employerSignInValidation(obj){
    return false;
    var first_name = $("#first_name").val();
    var last_name = $("#last_name").val();
    var email = $("#email").val();
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    if(first_name == ""){
        $("#error_msg").text("First Name can't be empty.");
        disableSignInForm();
        return false;
    }else if(last_name == ""){
        $("#error_msg").text("Last Name can't be empty.");
        disableSignInForm();
        return false;
    }
    else if(!re.test(email)){
        disableSignInForm();
        return false;
    }
    else if(passwordValidations("#password", "confirm_password") == false || passwordValidations("#confirm_password", "password") == false){
        disableSignInForm();
        return false;
    }else if($(obj).is(':checked') == false){
        disableSignInForm();
        return false;
    }
    resetPasswordFields();
    return false;
}

function change_checkbox(){
    /*var position = $('#checkbox_image').css('background-position');*/
    var position = $("#checkbox_image").attr("style");
    if(position != undefined){
        var position = position.toLowerCase();
    }
    if(position == undefined ){
        $('#checkbox_image').css('background-position', "0 -50px");
        $("#privacyText").attr('checked','checked');
    }else if(position == "background-position: 0% 0%" || position == ""){
        $('#checkbox_image').css('background-position', "0 -50px");
        $("#privacyText").attr('checked','checked');
    }
    else{
        $('#checkbox_image').css('background-position', "0 -50px");
        $("#privacyText").attr('checked','checked');
    /*
        $('#checkbox_image').css('background-position', "");
        $("#privacyText").removeAttr('checked');
         */
    }
    validateBasicInfo($('#privacyText'));
}

function resetPlaceHolder(){
    if($("#first_name").parent().hasClass("input-text"))
        $("#first_name").val("");

    if($("#last_name").parent().hasClass("input-text"))
        $("#last_name").val("");

    return false;
}

function emailValidations(obj){
    var email = $(obj).val();
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if(!re.test(email)){
        var msg = "Please enter a valid email";
        disableSignInForm(obj, msg);
        return false;
    }else{
        $("#error_msg").text("");
    //                $(obj).parent().removeClass("input-text-error");
    //                $(obj).parent().addClass("active-input");
    //                resetPasswordFields();
    }
    return true;
}

function passwordValidations(obj, obj2){
    var crnt_field = $(obj).val();
    var depnded_field = $("#" + obj2).val();

    var re = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/;
    var validPassword = re.test(crnt_field);
    var msg = "";
    if(!validPassword){
        msg = "Six or more character combination of at least one number, upper case and lower case letter.";
        disableSignInForm(obj, msg);
        return false;
    }
    else{
        $("#error_msg").text("");
    }

    if((re.test(crnt_field) && re.test(depnded_field)) && (crnt_field != depnded_field)){
        msg = "Passwords do not match. Please try again.";
        disableSignInForm(obj, msg);
        return false;
    }else{
        $("#error_msg").text("");
    }
    return true;
}

function disableSignInForm(obj, msg){
    $("#error_msg").text(msg);
    $(obj).parent().addClass("active-input input-text input-text-error");
    //$("#snr_button").attr("disabled","disabled");
    $("#basic_button").attr("disabled","disabled");
    $("#basic_button").css({
        backgroundPosition: "-63px 0"
    });
//        $("#snr_button").css({
//                backgroundPosition: "-2px -222px"
//        });
}

function resetPasswordFields(){
    $("#error_msg").text("");
    $("li div.customized-input").removeClass("input-text-error");
    //$("#snr_button").removeAttr("disabled","disabled");
    $("#basic_button").removeAttr("disabled","disabled");
    $("#basic_button").css({
        backgroundPosition: "-150px 0"
    });
//        $("#snr_button").css({
//                backgroundPosition: "-152px -222px"
//        });

}

function showErrorMessage(msg_json, is_payment_form){
    var error_str ="";
    var json_error = eval(msg_json);
    for (var i=0;i < json_error.length ;i++ )
    {
        var field = $("#" + json_error[i].key);
        if(i == 0 &&  BrowserDetect.browser !="Explorer"){
            field.focus();
        }
        field.val("");
        field.parent().removeClass("input-text");
        field.parent().addClass("input-text-error");
        error_str += unescape_str(json_error[i].msg) + "<br/>";
    }
    if(is_payment_form == true)
        $("#payment_error_msg").html(error_str);
    else{
        $("#error_msg").html(error_str);
    }
    return false;
}

function _openCCBillingInfo(card_type){
    $('#cc_billing_popup').show();
    $("#cc_billing_popup .popup-content").html("<img style='margin: 0pt auto; display: block;' src='/assets/ajax-loader-login.gif' alt='Ajax-loader-login'/>");
    $('#fade_normal').show();
    $('#jw_player').hide();
    centralizePopup();

    $.post("/employer_payment/load_payment_form", function(resp){
        $("#cc_billing_popup").html(resp);
        setCardType(card_type);
    })

}

function setCardType(card_type) {
    if(card_type == "master") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='master' id='master_card' />");
        $("#payment_images").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
    } else if(card_type=="visa") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='visa' id='visa' />");
        $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
    }
    else if(card_type == "american_express") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='american_express' id='american_express' />");
        $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
    }else if(card_type == "discover") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='discover' id='paypal' />");
        $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info").show();
        $("#personal-info").show();
        $("#paypal-info").hide();
    } else if(card_type == "paypal") {
        $('#card_entry_form').html("<input type='hidden' name='card_type' value='paypal' id='paypal' />");
        $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setCardType(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setCardType(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setCardType(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setCardType(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setCardType(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
        $("#credit-card-info").hide();
        $("#personal-info").hide();
        $("#paypal-info").show();
    }
}

function _closeCCBillingInfo(){
    $('#cc_billing_popup').hide();
    $("#fade_success").hide();
    $('#fade_normal').hide();
    if($('div#fade_success').is(":visible")==true)
        $('div#fade_success').hide();
    if($('div#fade_error').is(":visible")==true)
        $('div#fade_error').hide();
}

function resetCompanyPlaceHolder(){
    
    var company_name = document.getElementById('company_name');
    var company_address = document.getElementById('company_suite');
    var zip_code = document.getElementById('zip_code');
    var area_code = document.getElementById('area_code');
    var telephone_number = document.getElementById('telephone_number');
    var website = document.getElementById('website');
    var city = document.getElementById('city');
    var state = document.getElementById('state');
    var country = document.getElementById('country');
    var dropdown_check_flag = document.getElementById('dropdown_check_flag').value;
	
    var error_element = document.getElementById('error_element');
	
    if(!validateNotEmpty(company_name)) {
        $("#company_name").val("");
    }

    if(!validateNotEmpty(company_address)) {
        $("#company_suite").val("");
    }
	
    if(!validateNotEmpty(city)) {
        $("#city").val("");
        $("#city").removeAttr('placeholder');
    }
	
    if(!validateNotEmpty(state)) {
        $("#state").val("");
    }
	
    if(!validateNotEmpty(country)) {
        $("#country").val("");
    }
	
    if(!validateNotEmpty(zip_code)) {
        $("#zip_code").val("");
    }
	
    if(!validateNotEmpty(area_code)) {
        $("#area_code").val("");
    }
	
    if(!validateNotEmpty(telephone_number)) {
        $("#telephone_number").val("");
    }
	
    if(!validateNotEmpty(website)) {
        $("#website").val("");
    }

    return false;
}
function searchCompanyStatic(obj){
    var error_element = document.getElementById('error_element');
    if($("#company_name").parent().hasClass("input-text-error")) {
        if(error_element.value=="" || error_element.value=="company_name") {
            $("#error_msg").html("Company name already exists");
        }
    }
}

function searchCompany(obj){
    var comp_name = $(obj).val();
    var form_is_filled = $("#id").val();
    var error_element = document.getElementById('error_element');

    if(!validateNotEmpty(obj)) {
        $("#company_name").parent().removeClass("active-input input-text-active input-text-error");
        $("#company_name").parent().addClass("input-text-active");
        if(error_element.value=="" || error_element.value=="company_name") {
            $("#error_msg").html("");
            error_element.value="";
        }
        return false;
    }
    $.ajax({
        url:"/employer_payment/search_company?name=" + comp_name,
        type: "GET",
        cache: false,
        async: false,
        beforeSend: function() {
            if(error_element.value=="" || error_element.value=="company_name") {
                $("#error_msg").html("");
                $("#processing_msg").html("Processing Company Name... Please wait!");
            }
        },
        success: function(data){
            $("#processing_msg").html("");
            if(data=="Company doesn't exist") {
                $("#fill_up_company").html("<input type='hidden' value='0' id='company_exists' name='company_exists' />");
                if(error_element.value=="" || error_element.value=="company_name") {
                    $("#error_msg").html("");
                    error_element.value="";
                }
                $("#company_name").parent().removeClass("active-input input-text-active input-text-error");
                $("#company_name").parent().addClass("input-text-active");
                validateCompanyForm();
            } else if(data=="Company exists") {
                $("#fill_up_company").html("<input type='hidden' value='1' id='company_exists' name='company_exists' />");
                $("#before_validate").removeClass("hidden");
                $("#after_validate").addClass("hidden");
                if(error_element.value=="" || error_element.value=="company_name") {
                    $("#error_msg").html("Company name already exists");
                    error_element.value="company_name";
                }
                $("#company_name").parent().removeClass("active-input input-text-active");
                $("#company_name").parent().addClass("input-text-error");
                validateCompanyForm();
            }
        }
    });
}

function validateCompany(obj){
    var comp_name = $(obj).val();
    var error_element = document.getElementById('error_element');

    if(!validateNotEmpty(obj)) {
        $("#company_name").parent().removeClass("active-input input-text-active input-text-error");
        $("#company_name").parent().addClass("input-text-active");
        if(error_element.value=="" || error_element.value=="company_name") {
            $("#account_error_msg").html("");
            error_element.value="";
        }
        return false;
    }
    $.ajax({
        url:"/employer_payment/search_company?name=" + comp_name,
        type: "GET",
        cache: false,
        async: false,
        beforeSend: function() {
            if(error_element.value=="" || error_element.value=="company_name") {
                $("#account_error_msg").html("");
                $("#processing_msg").html("Processing Company Name... Please wait!");
            }
        },
        success: function(data){
            $("#processing_msg").html("");
            if(data=="Company doesn't exist") {
                $("#fill_up_company").html("<input type='hidden' value='0' id='company_exists' name='company_exists' />");
                if(error_element.value=="" || error_element.value=="company_name") {
                    $("#account_error_msg").html("");
                    error_element.value="";
                }
                $("#company_name").parent().removeClass("active-input input-text-active input-text-error");
                $("#company_name").parent().addClass("input-text-active");
            //validateCompanyForm();
            } else if(data=="Company exists") {
                $("#fill_up_company").html("<input type='hidden' value='1' id='company_exists' name='company_exists' />");
                $("#before_validate").removeClass("hidden");
                $("#after_validate").addClass("hidden");
                if(error_element.value=="" || error_element.value=="company_name") {
                    $("#account_error_msg").html("Company name already exists");
                    error_element.value="company_name";
                }
                $("#company_name").parent().removeClass("active-input input-text-active");
                $("#company_name").parent().addClass("input-text-error");
            //validateCompanyForm();
            }
        }
    });
}

function enablePayment(obj)
{
    return  true;
/*var payment_status = $("#payment_status").val();
    var company_exists = $("#company_exists").val();
    if(payment_status == "1")
            return;


    var placeholder_val = document.getElementById('company_name');
    var placeholder_val1 = document.getElementById('company_address');
    var placeholder_val2 = document.getElementById('company_suite');
    var placeholder_val8 = document.getElementById('company_name');
    var placeholder_val3 = document.getElementById('city');
    var placeholder_val4 = document.getElementById('zip_code');
    var placeholder_val5 = document.getElementById('area_code');
    var placeholder_val6 = document.getElementById('telephone_number');
    var placeholder_val7 = $('#website').val();

    if(company_exists == "0" && validateNotEmpty(placeholder_val) && validateNotEmpty(placeholder_val1) && validateNotEmpty(placeholder_val2) && validateNotEmpty(placeholder_val8) && validateNotEmpty(placeholder_val3) && validateNotEmpty(placeholder_val4) && validateNotEmpty(placeholder_val5) && validateNotEmpty(placeholder_val6) && checkURL(placeholder_val7) == 1)
        {
            $("#before_validate").addClass("hidden");
            $("#after_validate").removeClass("hidden");
        }
    else{
            $("#before_validate").removeClass("hidden");
            $("#after_validate").addClass("hidden");
    }*/
}

function validateNotEmpty(element) {
    if(element){
        if(($("#"+element.id).parent().hasClass("active-input") || $("#"+element.id).parent().hasClass("input-text-active") || $("#"+element.id).parent().hasClass("input-text-error")) && validateRequired(element.value)) {
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return true;
    }
}

function trm(str) {
    return str.replace(/^\s+|\s+$/g,"");
}
function validateRequired(value) {
    if(value.trim()!="") {
        return true;
    }
    return false;
}

function setCompanyValues(id){
    if(isNaN(id))
        return false;
    $("#search-result").hide();
    $("#search-result").html("");
    $.post("/employer_payment/set_company?id=" + id, function(data){
        $("#company-form").html(data);
        $("#new_record").val("0");
    });
}

function resetCompanyForm(obj){
    //$("#snr_button").show();
    $("#company-info ul li div.customized-inner-input").each(function(index) {
        $(this).addClass("input-text");
        $(this).removeClass("active-input");
    });

    $("#company-info ul li div input[type='text']").each(function(index) {
        $(this).removeAttr("readonly");
        var placholder  = $(this).prev().val();
        $(this).val(placholder);
    });

    $("#state").val("");
    changeColor("#state");
    $(obj).hide();
    $("#new_record").val("1");
    $("#id").val("");
    $("#search-result").hide();
    $("#search-result").html("");
    $("#before_validate").removeClass("hidden");
    $("#after_validate").addClass("hidden");
    companyFormDisable();
    //$("#site_activation_payment_dtl ul").hasClass("")
    return false;
}

function changeColor(obj){
    if($(obj).val() == "")
        $(obj).css("color","#7F7FBB");
    else
        $(obj).css("color","#000078");
}

function validateCompanyForm(){
    var company_name = document.getElementById('company_name');
    var company_address = document.getElementById('company_suite');
    var zip_code = document.getElementById('zip_code');
    var area_code = document.getElementById('area_code');
    var telephone_number = document.getElementById('telephone_number');
    var website = document.getElementById('website');
    var city = document.getElementById('city');
    var state = document.getElementById('state');
    var country = document.getElementById('country');
    var dropdown_check_flag = document.getElementById('dropdown_check_flag').value;

    if(validateNotEmpty(company_address) && validateNotEmpty(company_name) && validateNotEmpty(city) && validateNotEmpty(state) && validateNotEmpty(country) && validateNotEmpty(zip_code) && validateNotEmpty(area_code) && validateNotEmpty(telephone_number) && validateNotEmpty(website) && dropdown_check_flag == 1) {
        if(!$(company_name).parent().hasClass("input-text-error") && (!validateNotEmpty(website) || checkURL(website.value)==1)) {
            $("#snr_button").addClass("active");
            $("#basic_button").addClass("active");
            //$("#basic_button").attr("disabled","");
            $("#error_msg").html('');
            $("#basic_button").unbind().click(function(){
                $('#submit_type').val(0);
                $("#company-profile").submit();
            });

            $("#snr_button").unbind().click(function(){
                $('#submit_type').val(1);
                resetCompanyPlaceHolder();
                $("#company-profile").submit();
            });
        }
        else {
            //$("#snr_button").removeClass("active");
            //$("#basic_button").removeClass("active");
            //$("#basic_button").attr("disabled","disabled");
            $("#basic_button").unbind().click(function(){
                validateEmpOnInactiveButtonClick();
            });
            $("#snr_button").unbind("click");
        }

    }
    else {
        if(!$(company_name).parent().hasClass("input-text-error") && (!validateNotEmpty(website) || checkURL(website.value)==1) ) {
            $("#snr_button").addClass("active");
            //$("#basic_button").removeClass("active");
            //$("#basic_button").attr("disabled","disabled");
            $("#basic_button").unbind().click(function(){
                validateEmpOnInactiveButtonClick();
            });
            $("#snr_button").unbind().click(function(){
                $('#submit_type').val(1);
                resetCompanyPlaceHolder();
                $("#company-profile").submit();
            });
        }
        else {
            //$("#snr_button").removeClass("active");
            //$("#basic_button").removeClass("active");
            //$("#basic_button").attr("disabled","disabled");
            $("#basic_button").unbind().click(function(){
                validateEmpOnInactiveButtonClick();
            });
            $("#snr_button").unbind("click");
        }
    }
}
function validateCompInfo() {
    var dropdown_check_flag = document.getElementById('dropdown_check_flag').value;
    var error_element = document.getElementById('error_element');
    if($("#city_validation_flag").val()==1) {
        $("#city_validation_flag").val(0);
        return;
    }
	
    if(document.getElementById('dropdown_check_flag').value!=1) {
          
        $("#city").parent().removeClass("active-input");
        $("#city").parent().addClass("input-text-error");
	  
        if(error_element.value=="" || error_element.value=="city") {
            $("#error_msg").html("Please select a location from the list.");
            error_element.value="city";
        }
    }
    else {
        $("#city").parent().removeClass("input-text-error");
        //$("#city").parent().addClass("input-text-error");
        if(error_element.value=="" || error_element.value=="city") {
            $("#error_msg").html("");
            error_element.value="";
        }
    }
}

function websiteFieldError(obj){
    var error_element = document.getElementById('error_element');
    var website = $(obj).val();

    if(validateNotEmpty(obj)) {
        if(checkURL(website) == 0){
            $(obj).parent().removeClass("input-text");
            $(obj).parent().addClass("input-text-error");
            if(error_element.value=="" || error_element.value=="website") {
                $("#error_msg").html("Please enter a valid URL");
                error_element.value="website";
            }

        }else{
            $(obj).parent().addClass("input-text-active");
            $(obj).parent().removeClass("input-text-error");
            //$(obj).parent().addClass("input-text");
            if(error_element.value=="" || error_element.value=="website") {
                $("#error_msg").html("");
                error_element.value="";
            }
        }
    }
    else {
        $(obj).parent().addClass("input-text-unactive");
        $(obj).parent().removeClass("input-text-error");
        if(error_element.value=="" || error_element.value=="website") {
            $("#error_msg").html("");
            error_element.value="";
        }
    }
    validateCompanyForm();

}

function companyFormEnable(){
    var payment_made = $("#payment_status").val();
    if(payment_made == "1"){ //enable Enter button
        $("#basic_button").removeAttr("disabled");
        $("#basic_button").css({
            backgroundPosition: "-150px 0"
        });
    }
}

function companyFormDisable(){
    $("#company-form-loader-img").hide();
    $("#basic_button").show();
    $("#basic_button").attr("disabled", "disabled");
    $("#basic_button").css({
        backgroundPosition: "-63px 0"
    });
}


function validatePaymentForm(){
    //placed client side validation
    $("#payment_verify_button").hide();
    $("#verify-loader-img").show();

    $("#payment-form").ajaxSubmit({
        type: 'post',
        //target : '#feedback-form',
        evalScripts: true,
        success : function(resp) {
            if(resp == "done"){
                $('#fade_normal').hide();
                $("#fade_success").show();
                $("#payment_error_msg").hide();
                $("#payment_header").html("CREDIT CARD PAYMENT VERIFIED!");
                $("#verify-loader-img").hide();
                $("#payment_verify_button").hide();
                $("#finish-button-success").show();
                $("#verify-loader-img").hide();
                $("#payment_status").val(1); //set payment status 1
                $("#finish-button-success").click(function(){
                    $("#cc_billing_popup").hide();
                    $("#fade_success").hide();
                });
                $("#basic_button").removeAttr("disabled");
                $("#basic_button").css({
                    backgroundPosition: "-150px 0"
                });
                $("#before_validate").removeClass("hidden");
                $("#after_validate").addClass("hidden");
                $("ul.method-icon li").each(function(index) {
                    $(this).addClass("disable" + (index + 1));
                    $(this).children().removeAttr("onclick");
                });
            }else{
                showErrorMessage(resp, true);
                $("#payment_status").val(0);
                $("#fade_normal").css("display","none");
                $("#fade_error").css("display","block");
                $("#payment_verify_button").show();
                $("#verify-loader-img").hide();
                $("#payment_header").html("UNABLE TO VERIFY");
            }
        }
    });

    return false;
}

function checkURL(value) {
    var expression = /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i;
    var expr_with_http = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/i;
    if(expression.test(value) || expr_with_http.test(value)){
        return 1;
    }
    else {
        return 0;
    }
//^(http:\/\/www.|https:\/\/www.|ftp:\/\/www.|www.){1}[0-9A-Za-z\.\-]*\.[0-9A-Za-z\.\-]*$/
//var regex = new RegExp(expression);
}

function redirectToPaypal(){
    window.location.href = "/employer_payment/make_payment?payment_type=paypal_express";
}

function jsonError(msg_json){
    var error_str = "";
    var json_error = eval(msg_json);
    for (var i=0;i < json_error.length ;i++ ){
        error_str += unescapeStr(json_error[i].msg) + "<br/>";
    }
    $("#error-list").html(error_str);
}

function unescapeStr(str){
    str = decodeURIComponent(str);
    str = unescape(str.replace(/\+/g, " "));
    return str;
}

function validateHasError(element) {
    if($("#"+element.id).parent().hasClass("input-text-error") || $("#"+element.id).parent().hasClass("input-text-error-empty"))
        return true;
    else
        return false;
}

function validateEmpBasicInfoError(current_element) {
	
    if(crack_for_IE==true) {
        crack_for_IE = false;
        return;
    }
	
    var firstName = document.getElementById('first_name');
    var lastName = document.getElementById('last_name');
    var email = document.getElementById('email');
    var password = document.getElementById('password');
    var rePassword = document.getElementById('confirm_password');
    var errorBox = document.getElementById('error_msg');
    var tc = document.getElementById('privacyText').checked;
    var error_element = document.getElementById('error_element');

    if(current_element==firstName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(password) && !validateHasError(rePassword) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }
	
    if(current_element==lastName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(password) && !validateHasError(rePassword) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
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
            if(error_element.value=="email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-unactive");
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
                        if(error_element.value=="password" || error_element.value=="repassword" || error_element.value=="") {
                            errorBox.innerHTML="";
                            error_element.value="";
                        }
                    }
                    else {
                        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+rePassword.id).parent().addClass("input-text-error");
                        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $("#"+password.id).parent().addClass("input-text-active");
                        if(error_element.value=="password" || error_element.value=="") {
                            errorBox.innerHTML = "Passwords do not match. Please try again.";
                            error_element.value="password";
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
    validateEmpBasicInfo();
}

function validateEmpBasicInfoCorporateError(current_element) {

    if(crack_for_IE==true) {
        crack_for_IE = false;
        return;
    }

    var firstName = document.getElementById('first_name_corp');
    var lastName = document.getElementById('last_name_corp');
    var email = document.getElementById('email_corp');
    var company = document.getElementById('company_corp');
    var contact = document.getElementById('contact_corp');
    var errorBox = document.getElementById('error_msg_corp');
    var tc = document.getElementById('privacyText_corp').checked;
    var error_element = document.getElementById('error_element_corp');

    if(current_element==firstName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(company) && !validateHasError(contact) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    }

    if(current_element==lastName) {
        if(!validateHasError(firstName) && !validateHasError(lastName) && !validateHasError(email) && !validateHasError(company) && !validateHasError(contact) && tc) {
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
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
            if(error_element.value=="email" || error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
            $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+email.id).parent().addClass("input-text-unactive");
        }
    }
    
    validateEmpBasicInfoCorporate();
}


function validateEmpBasicInfo() {
    var firstName = document.getElementById('first_name');
    var lastName = document.getElementById('last_name');
    var email = document.getElementById('email');
    var password = document.getElementById('password');
    var rePassword = document.getElementById('confirm_password');
    var pincode = document.getElementById('job_seeker_zip_code');
    var errorBox = document.getElementById('error_msg');
    var tc = document.getElementById('privacyText').checked;
    var error_element = document.getElementById('error_element');
	
    if(validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(email) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value))
    {
        //$("#snr_button").removeAttr("disabled","disabled");
        $("#snr_button").css({
            backgroundPosition: "-151px -222px",
            cursor: "default"
        });
        $("#snr_button").unbind().click(function() {
            validateEmpNewOnInactiveButtonClickSnR();
        });

        if(tc){
            var button = $('#basic_button');
            var button2 = $('#snr_button');
		    
            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }
                    
            //$("#basic_button").removeAttr("disabled","disabled");
            $("#basic_button").css({
                backgroundPosition: "-150px 0",
                cursor: "pointer"
            });
            $("#basic_button").unbind().click(function(){
                set_employer_save_type('payment');
                $("#new_employer").submit();
            });
            $("#snr_button").unbind().click(function() {
                set_employer_save_type('save_return');
                resetPlaceHolder();
                $("#new_employer").submit();
            });
            $("#save_type").val('payment');
        }
        else {
            var button = document.getElementById('basic_button');
            var button2 = document.getElementById('snr_button');
            $("#snr_button").unbind().click(function() {
                set_employer_save_type('save_return');
                resetPlaceHolder();
                $("#new_employer").submit();
            });
            //$("#basic_button").attr("disabled","disabled");
            $("#basic_button").unbind().click(function(){
                validateEmpNewOnInactiveButtonClick();
            });
            $("#basic_button").css({
                backgroundPosition: "-150px 0",
                cursor: "default"
            });
            $("#save_type").val('save_return');
        }
    }
    else if(validateNotEmpty(email) && validateEmail(email.value) && validateNotEmpty(password) && validateNotEmpty(rePassword) && password.value==rePassword.value && validatePassword(password.value)) {
        $("#snr_button").unbind().click(function() {
            set_employer_save_type('save_return');
            resetPlaceHolder();
            $("#new_employer").submit();
        });
        //$("#snr_button").removeAttr("disabled","disabled");
        $("#snr_button").css({
            backgroundPosition: "-151px -222px",
            cursor: "pointer"
        });
        //$("#basic_button").attr("disabled","disabled");
        $("#basic_button").css({
            backgroundPosition: "-150px 0",
            cursor: "default"
        });
        $("#basic_button").unbind().click(function(){
            validateEmpNewOnInactiveButtonClick();
        });
        $("#save_type").val('save_return');
    }
    else{
        var button = document.getElementById('basic_button');
        var button2 = document.getElementById('snr_button');
        $("#snr_button").unbind().click(function() {
            validateEmpNewOnInactiveButtonClickSnR();
        });
        //$("#snr_button").attr("disabled","disabled");
        $("#snr_button").css({
            backgroundPosition: "-151px -222px",
            cursor: "default"
        });
        //$("#basic_button").attr("disabled","disabled");
        $("#basic_button").unbind().click(function(){
            validateEmpNewOnInactiveButtonClick();
        });
        $("#basic_button").css({
            backgroundPosition: "-150px 0",
            cursor: "default"
        });
    //$("#save_type").val('payment');

    }

}

function validateEmpNewOnInactiveButtonClickCorporate() {
    var firstName = document.getElementById('first_name_corp');
    var lastName = document.getElementById('last_name_corp');
    var email = document.getElementById('email_corp');
    var company = document.getElementById('company_corp');
    var contact = document.getElementById('contact_corp');
    var errorBox = document.getElementById('error_msg_corp');
    var tc = document.getElementById('privacyText_corp').checked;


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

    if(!validateNotEmpty(company)) {
        $("#"+company.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+company.id).parent().addClass("input-text-error-empty");
    }

    if(!validateNotEmpty(contact)) {
        $("#"+contact.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+contact.id).parent().addClass("input-text-error-empty");
    }
    else if(!validateEmail(email.value)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error");
    }

    
    if(!tc){
        $("#privacyText_corp").prev().css("background-position","0px -100px")
    }

    errorBox.innerHTML="Please complete the areas highlighted in red.";

}

function validateEmpBasicInfoCorporate() {
    var firstName = document.getElementById('first_name_corp');
    var lastName = document.getElementById('last_name_corp');
    var email = document.getElementById('email_corp');
    var company = document.getElementById('company_corp');
    var contact = document.getElementById('contact_corp');
    var errorBox = document.getElementById('error_msg_corp');
    var tc = document.getElementById('privacyText_corp').checked;
    var error_element = document.getElementById('error_element_corp');

    if(validateNotEmpty(firstName) && validateNotEmpty(lastName) && validateNotEmpty(email) && validateEmail(email.value) && validateNotEmpty(contact) && validateNotEmpty(company))
    {
        if(tc){
            var button = $('#basic_button_corp');

            if(error_element.value=="") {
                errorBox.innerHTML="";
                error_element.value="";
            }

            //$("#basic_button").removeAttr("disabled","disabled");
            $("#basic_button_corp").css({
                backgroundPosition: "-150px 0",
                cursor: "pointer"
            });
            $("#basic_button_corp").unbind().click(function(){
                //set_employer_save_type('payment');
                $("#new_employer_corporate").submit();
            });
            
        //$("#save_type").val('payment');
        }
        else {
            var button = document.getElementById('basic_button_corp');
            
            $("#basic_button_corp").unbind().click(function(){
                validateEmpNewOnInactiveButtonClickCorporate();
            });
            $("#basic_button_corp").css({
                backgroundPosition: "-150px 0",
                cursor: "default"
            });
        //$("#save_type").val('save_return');
        }
    }
    else
    {
        var button = document.getElementById('basic_button_corp');
        
        $("#basic_button_corp").unbind().click(function(){
            validateEmpNewOnInactiveButtonClickCorporate();
        });
        $("#basic_button_corp").css({
            backgroundPosition: "-150px 0",
            cursor: "default"
        });
    //$("#save_type").val('payment');

    }

}


function validatePasswordOnKeyUp(password) {
    var value = $(password).val();
    var error_element = document.getElementById('error_element');

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

// Check for a valid email address, value to be checked must be passed as a parameter
function validateEmail(value) {
    if (/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i.test(value)){
        return true;
    }
    return false;
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

function validatePassword(value) {
    var regex = /^[a-z0-9]+$/i;
    if(regex.test(value) && value.length > 5)
        return true;
    return false;
}

function category_existed(from_popup){
    $("#selected-cat-id").val("0");
    footerOnOpeningPopup();
    $("#error-action-button").show();
    if (from_popup == "1")
        $("#action-button").html("<input type='button' id='error-action-button' class='retry-button-active' onclick='return focusAddCatInput();' />");
    else
        $("#action-button").html("<input type='button' id='error-action-button' class='retry-button-active' onclick='hideDashboardWarningPopup();' />");

    setContentWarningPopup("ALERT", "This category already exists. Please enter another name.");
    //$("#error-action-button").hide();
    $("#dashboard-warning").show();
    //if position popup is there
    $("#add-new-posotion").hide();
    showNormalShadow();
    centralizePopup();
}

function focusAddCatInput(){
    //$("#add_group_field").focus();
    hideDashboardWarningPopup();
    loadCategories();
}


function category_not_existed(){
    window.location.reload();
}

function add_category_from_popup(id){
    if(isNaN(id) || parseInt(id, 10) < 0){
        window.location.reload();
    }else
        window.location.href = "/position_profile/new_employer_profile?cat_id=" + id;
}

function checkExistingCat(){
    var selected_cat = $("#selected-cat-id").val();
    if(selected_cat != "0"){
        $('#parent_id').val('0');
        window.location.href = "/position_profile/new_employer_profile?cat_id=" + selected_cat+"&selected="+$('#parent_id').val();
        return false;
    }else{
        if ($('#new-category-name').val().trim() == ""){
            $('#new-category-name').parent().addClass('error');
            return false;
        }
        else
            return true;
    }

}

function removeError(){
    $('#new-category-name').parent().removeClass('error');
    if ($('#new-category-name').val().trim() == "")
        $('#new-category-name').caretToStart();
}
/*__________________Functions for dashboard_________________________________________*/
/*function for logout popup*/
function show_employer_account_box(e){
    $(".employer-acc-box").slideDown();
    $('#fade_normal_status_signout').show();
    footerOnOpeningPopup();
}
function show_normal_screen_signout(){
    $('.employer-acc-box').hide();
    $('#fade_normal_status_signout').hide();
    footerOnClosingPopup();

}
/*function for career seeker tooltip*/
function show_career_seeker_box(e){
    $(".employer-acc-box1").toggle();
}

function _openCareerSeekerBox(){
    var _leftoffset = $('#career-seeker_id').offset().left;
    var _topoffset = $('#career-seeker_id').offset().top;
    var _height = $(".career-seeker-id-box").height();
    var _width =  $(".career-seeker-id-box").width();
    $('#carrer_id_popup').show();
    $('#fade_normal_status').show();

    $('#career-seeker-id-box').css({
        left:_leftoffset-150,
        top:_topoffset+25
    });
    footerOnOpeningPopup();
// $('#carrer_id_popup').css({left:_left,top:_top});
//var _left = _offset.left;
//var _top = _offset.top;
/*var _left = (_offset.left/2);
		var _top = _offset.top;
		_left = _left-(_left/4);

		$('#carrer_id_popup').show();
		$('#fade_normal_status').show();
		$('#carrer_id_popup').css({left:_left,top:_top})
                $('#carrer_id_popup').css({top:_top});
                
		$(".employer-acc-box").hide();*/
}
function show_normal_screen(){

    $('#cc_billing_popup').hide();
    $('#fade_normal_status').hide();

}
function show_normal_dashboard_screen(){
    $('#carrer_id_popup').hide();
    $('#emp_advanced_popup').hide();
    $('#career-seeker-ID').show();
    $('.career-seeker-text-box-id').hide();
    $('#add-x-ref-button').hide();
    $('#fade_normal_status').hide();
    $("#dashboard-warning").hide();
    $("#error-action-button").hide();
    $("#xref_error_popup").hide();
    $("#fade_error").hide();
    $("#dashboard-warning").hide();
    $("#fade_normal").hide();
    $('#emp_detailed_view').hide();
    $('#one_click_payment_position_popup').hide();
    $('#login_error').hide();
    $("#emp_detailed_view").hide();
    $("#cc_billing_popup").hide();
    $("#save-popup").hide();
    footerOnClosingPopup();
    changeCareerSeekerNameParentClass();
}
function changeCareerSeekerNameParentClass(){
    if($('#career_seeker_name').parent().hasClass('active-input'))
    {
        $('#career_seeker_name').parent().removeClass('active-input');
        $('#career_seeker_name').val($('#career_seeker_name_placeholder').val());
        $('#career_seeker_name').parent().addClass('input-text');
    }
}

function category_add_open(){
    $('#add_grp_box').toggle();
}

function _openNotificationBox(){
    $("#content_notification_box .content .notifications").css("height", "205px");
    $('#content_notification_box').show();
    $('#fade_normal_status_notification').show();
    footerOnOpeningPopup();
}
function show_normal_screen_notification(){
    $('#content_notification_box').hide();
    $('#fade_normal_status_notification').hide();
    $("#catageory_position_popup").hide();
    footerOnClosingPopup();

}
function onload_open_group_section(){
    if (currently_viewed_job_id != "0"){
        var ele = $("#group_job_" + currently_viewed_job_id).parent().parent().prev();
        ele = $(ele).find(".group-row .group-row-name span.show-content")
        var grp_sec = $(ele).attr("data-group-id");
        $("#group_section_" + grp_sec).show().prev().addClass("group-row-bg-selected");
        $(ele).addClass('down');
    }
}

function editCat(name,id){
    var input = "<input type='text' value='" + name + "' name='cat_name' />";
    $("#hidden-cate-input-"+id).html(input);
    $("#category-head-"+id).hide();
}
var folders_dragged_flag = false;
var folders_position_dragged_flag = false;
var emp_left_menu_event = {
    apply: function(){
        this.toggle_group_event();
        //this.group_drag();
        //this.job_section_drag();
        this.edit_name();
        this.toggle_job_delete_icon();
        this.toggle_group_delete_icon();
    },
    toggle_job_delete_icon : function(){
        $(".group-section-job").mouseenter(function(){
            $(this).children(".left-menu-job-delete").children("a").show();
            $(this).children(".left-menu-job-dupliacte").children("a").show();
        }).mouseleave(function(){
            $(this).children(".left-menu-job-delete").children("a").hide();
            $(this).children(".left-menu-job-dupliacte").children("a").hide();
        });

    },
    toggle_group_delete_icon: function(){
        $(".group-row-bg").mouseenter(function(){
            if($(this).find("input.edit-group-name").parent().css("display") == "none")
                $(this).find(".group-row-drag").show();
        }).mouseleave(function(){
            $(this).find(".group-row-drag").hide();
        });
    },
    save_success: function(grp_id){
        var text = $("#group_row_" + grp_id).find("input.edit-group-name").first().val();
        text = truncate(text, 20);
        //$("#group_row_" + grp_id).find("input.edit-group-name").hide();
        //$("#group_row_" + grp_id).find("span.landing-value").html(text).show();
        $(".group-row-name span").toggle();
        $(".category-group-name").toggle();
        $(".edit-group-name").toggle();
        $("#group_row_" + grp_id).find("input.edit-group-name").hide();
        $("#group_row_" + grp_id).find("span.landing-value").html(text).show();

    },
    save_fail: function(json){
        var json_error = eval(json);
        var error_str = "";
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "\n";
        }
    },
    edit_name: function(){
        $(".edit-group-name").blur(function(){
            return false;
        });

    },
    toggle_group_event: function(){
        $(".group-row-bg").each(function(){
            $(this).click(function(e){
                var element = $(this).find('.show-content');
                var grp_sec = $(element).attr("data-group-id");
                if(!folders_dragged_flag) {
                    if($("#group_section_" + grp_sec).is(':visible') == true){
                        $("#group_section_" + grp_sec).slideUp('fast').prev().removeClass("group-row-bg-selected");
                        $(element).removeClass('down');
                    } else {
                        $("#group_section_" + grp_sec).slideDown('fast').prev().addClass("group-row-bg-selected");
                        $(element).addClass('down');
                    }
                }
                folders_dragged_flag = false;
                e.stopPropagation();
            });
            $(this).find('.group-row-drag').click(function(e){
                e.stopPropagation();
            });
            $(this).find('.landing-value').disableTextSelect();
            $(this).find('.landing-value').unbind().click(function(e){
                e.stopPropagation();
            });
            $(this).find('.landing-value').disableTextSelect();
            $(this).find('.landing-value').dblclick(function(e){
                $('.group-row-bg').find('.edit-group-name').each(function(e){
                    if($(this).parent().css('display') != "none"){
                        $(this).parent().prev().attr('data-folder-name', $(this).val());
                    }
                });
                $(".group-row-drag").hide();
                var id = $(this).parent().find('.show-content').attr('data-group-id');
                enable_category_edit(id);
                e.stopPropagation();
            });
        });
    },
    group_drag: function(){
        $("#company-group-list-section").sortable({
            placeholder: "sort_group_hover",
            axis: "y",
            handle: ".group-row-bg",
            stop: function(event,ui){
                emp_left_menu_event.sort_group_ajax($("#company-group-list-section").sortable('serialize'));
                folders_dragged_flag = true;
                setTimeout(function(){
                    folders_dragged_flag = false;
                },100);
            }
        });
    },
    job_section_drag: function(){
        $(".group-section").each(function(){
            var temp_id = $(this).attr("id");
            $("#" + temp_id).sortable({
                placeholder: "group-section-job-hover",
                axis: "y",
                stop: function(e2, ui2){
                    var new_cat_id = $("#new_category").val();
                    var current_item = $("#current_item").val();
                    var next_item = $("#next_item").val();
                    var destination_box_jobs = $("#destination_box_jobs").val();
                    emp_left_menu_event.sort_group_job_ajax($("#" + temp_id).sortable('serialize') + "&company_group_id=" + new_cat_id + "&job_id=" + current_item+"&next_item="+ next_item + "&box_jobs="+destination_box_jobs);
                    folders_position_dragged_flag = true
                    setTimeout(function(){
                        folders_position_dragged_flag = false;
                    },100);
                },
                update: function(e, ui) {
                    //to get the id of the dragged element
                    var current_item = $(ui.item).find(".left-menu-job a").attr("job_id");
                    $('#current_item').val(current_item);
                    var cat_id = $(e.target).attr("id");
                    cat_id = cat_id.replace("group_section_drag_", "");
                    $("#new_category").val(cat_id);
                    //very next element to the dropped element
                    var nex_item=$("#group_job_"+current_item).next().attr("id");
                    $("#next_item").val(nex_item);
                    var job_ids = "";
                    $("#group_section_drag_" + cat_id + " .group-section-job").each(function(){
                        var id = $(this).find(".left-menu-job").children().attr("job_id");
                        job_ids = job_ids + id + ","
                    });
                    $("#destination_box_jobs").val(job_ids);
                }

            });
        });
    },
    sort_group_ajax: function(sort_list){
        $.ajax({
            url: '/ajax/sort_group_ajax',
            cache: false,
            data: sort_list,
            success: function(){
                
            }
        });
    },
    sort_group_job_ajax: function(sort_list){
        sort_list = sort_list
        $.ajax({
            url: '/ajax/sort_group_job_ajax',
            cache: false,
            data: sort_list,
            success: function(data){
            }
        });
    },
    delete_action: function(group_id,current_job_id,current_cat_id){
        showDashboardWarning(group_id, 1,current_job_id,current_cat_id);
    }

}

var delete_job_v2 = {
    init: function(job_id,current_job_id){
        showDashboardWarning(job_id, 0,current_job_id);
    }
}

function deletePosition(job_id,current_job_id){
    showBlockShadow();
    $.ajax({
        url: '/position_profile/delete_job',
        data: "job_id=" + job_id + "&parent_id=" + $("#parent_id").val(),
        cache: false,
        success: function(){
            hideBlockShadow();
            hideDashboardWarningPopup();
            if(current_job_id == job_id) {
                showBlockShadow();
                window.location.href = "/employer_account/index/?selected="+$('#parent_id').val();
            }
            else {
                if($("#group_job_"+job_id).find('.active-image').hasClass('red')) {
                    $("#count_red").html($("#count_red").html()-1);
                }
                if($("#group_job_"+job_id).find('.active-image').hasClass('green')) {
                    $("#count_green").html($("#count_green").html()-1);
                }
                if($("#group_job_"+job_id).find('.active-image').hasClass('yellow')) {
                    $("#count_yellow").html($("#count_yellow").html()-1);
                }
                $("#group_job_"+job_id).remove();
            }
            //$("#active_inactive").html(data);
            //$("#update_categories").html(data);
            if($('#jid').val() == job_id){
                window.location.href = "/employer_account/index/?selected="+$('#parent_id').val();
            }
            return false;
        }
    });
}

function deleteGroup(group_id,current_job_id,current_cat_id){
    showBlockShadow();
    var red=0;
    var green=0;
    var yellow=0;
    $.ajax({
        url: '/position_profile/delete_group',
        data: "group_id=" + group_id + "&parent_id=" + $("#parent_id").val(),
        cache: false,
        success: function(){
            if(current_cat_id==group_id) {
                showBlockShadow();
                window.location.href = "/employer_account/index/?selected="+$('#parent_id').val();
            }
            var temp = $("#group_job_"+current_job_id).parent().attr('id');
            if(temp){
                id = temp.split("_");
                if(id[3]==group_id) {
                    showBlockShadow();
                    window.location.href = "/employer_account/index/?selected="+$('#parent_id').val();
                }
            }
            $("#group_section_drag_"+group_id).children().each(function(){
                if($(this).find("div.active-image").hasClass('red')) {
                    //console.log($(this).find("div.active-image").attr('class'));
                    red++;
                }
                else if($(this).find("div.active-image").hasClass('green')) {
                    //console.log($(this).find("div.active-image").attr('class'));
                    green++;
                }
                else{
                    yellow++;
                }
            });
            //console.log(green);
            //console.log(red);
            
            var g = $("#count_green").html();
            var r = $("#count_red").html();
            var y = $("#count_yellow").html();
            g = g - green;
            r = r - red;
            y = y - yellow;
            $("#count_green").html(g);
            $("#count_red").html(r);
            $("#count_yellow").html(y);
            
            $("#sort_group_"+group_id).remove();
            hideBlockShadow();
            hideDashboardWarningPopup();
            //$("#update_categories").html(data);
            //$("#active_inactive").html(data);
            return false;
        }
    });
}


function openTabOnLoad(id){
    $("#group_job_" + id).parent().parent().show();
    $("#group_job_" + id).parent().parent().prev().addClass("group-row-bg-selected");
    $("#group_job_" + id).parent().parent().prev().find("span.show-content").addClass("down");
    $("#group_job_" + id).css("background","#e1e8ed");
//$("#group_job_" + id).find(".left-menu-job-delete a").show();
}

function enableXrefButton(obj){
    if($(obj).val().length > 0){
        //$("#add-x-ref-button").removeAttr("disabled","disabled");
        $("#add-x-ref-button").removeClass("add-x-ref-button");
        $("#add-x-ref-button").addClass("add-x-ref-button_active");
    }else{
        //$("#add-x-ref-button").attr("disabled","disabled");
        $("#add-x-ref-button").addClass("add-x-ref-button");
        $("#add-x-ref-button").removeClass("add-x-ref-button_active");

    }

}

var emp_left_menu = {
    search: function(){
        var url = "/position_profile/candidate_pool?job_id=" + $("#seeker_search_job_id").val() + "&seeker_id=" + $("#enter_seekerid").val();
        window.location.href= url;
        return false;
    }
}

var add_group = {
    fail: function(data){
    //$('#add_grp_loader').hide();
    },
    success: function(){
        window.location.reload();
    }
}

function _openOneClickPaymentBox(seeker_id, job_id){
    if(document.getElementById("fade_normal")) {
        footerOnOpeningPopup();
        $.ajax({
            url: '/purchase_profile_payment/index',
            beforeSend: function() {
                showBlockShadow();
            },
            data: "seeker_id=" + seeker_id + "&job_id=" + job_id,
            cache: false,
            success: function(){
                hideBlockShadow();
            }
        });
    }
}

function _openOneClickPaymentBox_exclude_payment(seeker_id, job_id){
    if(document.getElementById("fade_normal")) {
        $.ajax({
            url: '/purchase_profile_payment/exclude_payment',
            beforeSend: function() {
                showBlockShadow();
            },
            data: "seeker_id=" + seeker_id + "&job_id=" + job_id,
            cache: false,
            success: function(){
                hideBlockShadow();
            }
        });
    }
}

function _close_OneClickPayment_box(){
    footerOnClosingPopup();
    $("#pay_pass").val('');
    document.getElementById('pay_pass').onblur();
    document.getElementById("confirm_button").className = "poition_enter_button rfloat";
    //document.getElementById("confirm_button").disabled = "disabled";
    $('#one_click_payment_position_popup').hide();
    $('#fade_normal').hide();
    footerOnClosingPopup();
}
var last_id = 0;
function loadNotifications(){
    last_id = 0;
    $.get("/employer_account/load_notifications", function(resp){
        $("#content_notification_box").html(resp);
        removeButton();
        $(".viewAll").click(function(e){
            expandNotification();
            var scrollM = $(".notifications").scrollTop();
            var scrollT = $(".notifications").scrollTop();
            var id = fetch_last_notification_id();
            $(".notifications").unbind("scroll").scroll(function(){
                showNotificationRows(scrollT,scrollM,id,3);
            });
            e.stopPropagation();
        });

        if($("ul#notification_rows li").length > 5){
            $("#viewAll").css('visibility', 'visible');
        }
        else{
            $("#viewAll").css('visibility', 'hidden');
        }
              
    });
        
}
function removeButton() {
    $('.notifications ul li').hover(function(){
        $('a.remove',this).css('display','block')
    },function(){
        $('a.remove',this).css('display','none')
    });
}
function fetch_last_notification_id() {
    var id_temp = $("#notification_rows li").last().attr('id');
    id_temp = id_temp.split('_');
    var id = id_temp[1];
    return id;
}
function resetNotificationPopup()
{
    $("#content_notification_box .content .notifications").css({
        'height':'',
        'overflow-y':''
    });
    //$('#viewAll').show();
    $.ajax({
        url: '/employer_account/reset_notifications',
        cache: false,
        success: function(){
            $(".notification_number_dashboard").html("0");
        }
    })
}

function expandNotification(){
    $("#content_notification_box .content .notifications").css({
        'height':'500px',
        'overflow-y':'auto',
        'margin-right':'15px'
    });
    $('#viewAll').css('visibility', 'hidden');
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
            url: '/employer_account/load_notifications',
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

function resizeTable() {
    var wid = [31, 106, 72, 80, 115, 88, 43, 30, 111];
    var i = 0;
    if($("table#list").height()>$("#table_block").height()){
        $('table#list').attr('width', 675);
        $('table#list').find('th').each(function(){
            $(this).attr('width',wid[i]);
            i = i+1;
        })
    }
}

function sortDashboardTables(sort,order, filter, pos, from){
    hideRefreshLink();
    $("#table_block .loader").removeClass("hidden");
    $("#list").addClass("hidden");
    var url = "/employer_account/get_profile_visits";
        
    $.ajax({
        url: url,
        data: "sort=" + sort + "&order=" + order + "&filter=" + filter + "&pos=" + pos + "&from=" + from,
        cache: false,
        success: function(resp){
            //$("#search_result_arr").val('-1');
            $("#table_block .loader").addClass("hidden");
            $("#list").removeClass("hidden");
            if ( from == "table_data" )
                $(".table-container").html(resp);
            else
                $("#table-container-dashboard").html(resp);
            if ($("#search_result_arr").val() != '-1'){
                var  array_id = new Array();
                temp = $("#search_result_arr").val();
                array_id = temp.split(",");
                $('tr').each(function(){
                    if ($(this).attr('id') != undefined){
                        var id = $(this).attr('id').split('_')[2];
                        if (id == ""){
                            $('#error_msg_empty_table').show();
                            return false;
                        }
                        else{
                            $('#error_msg_empty_table').hide();
                            if (!(array_id.has(id))){
                                $(this).addClass('filter');
                            }
                            else{
                                $(this).removeClass('filter');
                            }
                        }
                    }
                });
            }
            	
            scrollT = $("#table_block").scrollTop();
            scrollM = $("#table_block").scrollTop();
                
            $("#table_block").unbind("scroll").scroll(function () {
                sortDashboardTablesRows(sort,order,scrollT,scrollM,10,5,filter, pos);
            });
            var wid = [31, 101, 63, 81, 110, 84, 45, 57, 94];
            var i = 0;
            if($("table#list").height()>$("#table_block").height()){
                $('table#list').attr('width', 666);
                $('table#list').find('th').each(function(){
                    $(this).attr('width',wid[i]);
                    i = i+1;
                })
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','0px');
                });
            }
		
        }
    });
       
       

    return false;
}

function sortDashboardTablesRows(sort,order,scrollT,scrollM,start,limit,filter, pos){
    
    var url = "/employer_account/get_profile_visits";
    
    if($("#table_block").scrollTop()<scrollT) {
    //No need to fire
    }
    else if($("#table_block").scrollTop()<=scrollM) {
    //No need to fire
    }
    else {
        $("#rows_loader").show();
        scrollM_old = scrollM;
        scrollT_old = scrollT;
        
        scrollM = $("#table_block").scrollTop();
        scrollT = $("#table_block").scrollTop();

        $("#table_block").unbind("scroll");
	
		     
        $.ajax({
            url: url,
            data: "sort=" + sort + "&order=" + order + "&start=" + start + "&limit=" + limit + "&scroll=true" + "&filter=" + filter + "&pos=" + pos,
            cache: false,
            success: function(resp){
                $("#rows_loader").hide();
                $("#table_block .loader").addClass("hidden");
                $("#list").removeClass("hidden");
                $("#list tbody").append(resp);
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("#table_block").unbind("scroll").scroll(function () {
                    sortDashboardTablesRows(sort,order,scrollT,scrollM,start+limit,limit,filter, pos);
                });
            },
            error: function() {
                $("#table_block").unbind("scroll").scroll(function () { 
                    sortDashboardTablesRows(sort,order,scrollT,scrollM_old,start,limit,filter, pos);
                });  
            }
        });
    }
    
}

function sortCandidatePoolTables(sort, order, filter, from){
    hideRefreshLink();
    var job_id = $("#job_id").val();
    var activity = $("#activity").val();
    $("#table_block .loader").removeClass("hidden");
    $("#list").addClass("hidden");
    var url = "/position_profile/get_candidate_pool?sort=" + sort + "&order=" + order + "&id=" + job_id + "&activity=" + activity;
        
    $.ajax({
        url: url,
        data: "sort=" + sort + "&order=" + order + "&filter=" + filter + "&from=" + from,
        cache: false,
        success: function(resp){
            //$("#search_result_arr").val('-1');
            $("#table_block .loader").addClass("hidden");
            $("#list").removeClass("hidden");
            if ( from == "table_data" )
                $(".table-container-content").html(resp);
            else
                $("#table-container-candidate").html(resp);
            if ($("#search_result_arr").val() != '-1'){
                var  array_id = new Array();
                temp = $("#search_result_arr").val();
                array_id = temp.split(",");
                $('tr').each(function(){
                    if ($(this).attr('id') != undefined){
                        var id = $(this).attr('id').split('_')[2];
                        if (id == ""){
                            $('#error_msg_empty_table').show();
                            return false;
                        }
                        else{
                            $('#error_msg_empty_table').hide();
                            if (!(array_id.has(id))){
                                $(this).addClass('filter');
                            }
                            else{
                                $(this).removeClass('filter');
                            }
                        }
                    }
                });
            }
		
            scrollT = $("#table_block").scrollTop();
            scrollM = $("#table_block").scrollTop();
                
            $("#table_block").unbind("scroll").scroll(function () {
                sortCandidatePoolTablesRows(sort,order,scrollT,scrollM,10,5,filter);
            });
		
            var wid = [41, 80, 91, 107, 108, 49, 51, 116];
            var i = 0;
            if($("table#list").height()>$("#table_block").height()){
                $('table#list').attr('width', 660);
                $('table#list').find('th').each(function(){
                    $(this).attr('width',wid[i]);
                    i = i+1;
                })
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','20px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','20px');
                });
            }

        }
    });
	
    return false;
}

function sortCandidatePoolTablesRows(sort,order,scrollT,scrollM,start,limit,filter){
    
    var url = "/position_profile/get_candidate_pool";
    var job_id = $("#job_id").val();
    var activity = $("#activity").val();
	
    if($("#table_block").scrollTop()<scrollT) {
    //No need to fire
    }
    else if($("#table_block").scrollTop()<=scrollM) {
    //No need to fire
    }
    else {
        $("#rows_loader").show();
        scrollM_old = scrollM;
        scrollT_old = scrollT;
        
        scrollM = $("#table_block").scrollTop();
        scrollT = $("#table_block").scrollTop();
        $("#table_block").unbind("scroll");
	
		     
        $.ajax({
            url: url,
            data: "sort=" + sort + "&order=" + order + "&start=" + start + "&limit=" + limit + "&scroll=true" + "&id=" + job_id + "&activity=" + activity + "&filter=" + filter,
            cache: false,
            success: function(resp){
                $("#rows_loader").hide();
                $("#table_block .loader").addClass("hidden");
                $("#list").removeClass("hidden");
                $("#list tbody").append(resp);
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','20px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','20px');
                });
                $("#table_block").unbind("scroll").scroll(function () {
                    sortCandidatePoolTablesRows(sort,order,scrollT,scrollM,start+limit,limit,filter);
                });
            },
            error: function() {
                $("#table_block").unbind("scroll").scroll(function () { 
                    sortCandidatePoolTablesRows(sort,order,scrollT,scrollM_old,start,limit,filter);
                });  
            }
        });
    }
    
}


function sortXrefTables(sort,order,pos){
    hideRefreshLink();
    pos = pos || -1;
    var cs_id = $("#cs_id").val();
    var job_id = $("#job_id").val();
    var activity = $("#activity").val();
    //alert(activity);
    $("#table_block .loader").removeClass("hidden");
    $("#list").addClass("hidden");
        
    var url = "/position_profile/get_xref_data";
        
    $.ajax({
        url: url,
        data: "sort=" + sort + "&order=" + order + "&id=" + job_id + "&activity=" + activity + "&cs_id=" + cs_id + "&pos=" + pos,
        cache: false,
        success: function(resp){
            $("#table_block .loader").addClass("hidden");
            $("#list").removeClass("hidden");
            $("#table-container-xref").html(resp);
		
            scrollT = $("#table_block").scrollTop();
            scrollM = $("#table_block").scrollTop();
                
            $("#table_block").unbind("scroll").scroll(function () {
                sortXrefTablesRows(sort,order,scrollT,scrollM,10,5,pos);
            });
		
            var wid = [46, 48, 160, 72, 83, 92, 59, 102];
            var i = 0;
            if($("table#list").height()>$("#table_block").height()){
                $('table#list').attr('width', 662);
                $('table#list').find('th').each(function(){
                    $(this).attr('width',wid[i]);
                    i = i+1;
                })
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','0px');
                });
            }
            if(activity != ""){
                $("div.employer-chart-label").removeClass("active");
                switch(activity){
                    case "position_preview":
                        $("#preview_chart").addClass("active");
                        break;
                    case "position_detail":
                        $("#detail_chart").addClass("active");
                        break;
                    case "interested":
                        $("#interested_chart").addClass("active");
                        break;
                    case "wild_card":
                        $("#wild_chart").addClass("active");
                        break;
                }
            }
		
        }
    });
	
    return false;
}

function sortXrefTablesRows(sort,order,scrollT,scrollM,start,limit,pos){
    
    var url = "/position_profile/get_xref_data";
    
    var cs_id = $("#cs_id").val();
    var job_id = $("#job_id").val();
    var activity = $("#activity").val();
	
    if($("#table_block").scrollTop()<scrollT) {
    //No need to fire
    }
    else if($("#table_block").scrollTop()<=scrollM) {
    //No need to fire
    }
    else {
        $("#rows_loader").show();
        scrollM_old = scrollM;
        scrollT_old = scrollT;
        
        scrollM = $("#table_block").scrollTop();
        scrollT = $("#table_block").scrollTop();
        $("#table_block").unbind("scroll");
        
        $.ajax({
            url: url,
            data: "sort=" + sort + "&order=" + order + "&start=" + start + "&limit=" + limit + "&scroll=true" + "&id=" + job_id + "&activity=" + activity + "&cs_id=" + cs_id + "&pos=" + pos,
            cache: false,
            success: function(resp){
                $("#rows_loader").hide();
                $("#table_block .loader").addClass("hidden");
                $("#list").removeClass("hidden");
                $("#list tbody").append(resp);
                $("a.profile-days-left").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("a.buy-profile-link").each(function(){
                    $(this).css('margin-left','0px');
                });
                $("#table_block").unbind("scroll").scroll(function () {
                    sortXrefTablesRows(sort,order,scrollT,scrollM,start+limit,limit,pos);
                });
            },
            error: function() {
                $("#table_block").unbind("scroll").scroll(function () { 
                    sortXrefTablesRows(sort,order,scrollT,scrollM_old,start,limit,pos);
                });  
            }
        });
    }
    
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



function activate_one_click(checkout) {
    if(document.getElementById("pay_name") && document.getElementById("pay_pass")) {
        email = document.getElementById("pay_name").value;
        password = document.getElementById("pay_pass").value;
        pass_element = document.getElementById("pay_pass");
        button = document.getElementById("confirm_button");
        if(validateEmail(email) && validateNotEmptyPassword(pass_element)) {
            if (checkout){
                button.className="btn-Confirm-active rfloat"
            //button.disabled="";
            }
            else{
                button.className="poition_enter_button_active rfloat"
            //button.disabled="";
            }
			

        }
        else {
            if (checkout){
                button.className="btn-Confirm rfloat"
            //button.disabled="disabled";
            }
            else{
                button.className="poition_enter_button rfloat"
            //button.disabled="disabled";
            }
			

        }
    }
}

function leftmenuBodyClick(){
    $(".add-text-edit").unbind('click').click(function(e){
        enable_category_edit();
        e.stopPropagation();
    });
    $(".edit-group-name").unbind('click').click(function(e){
        e.stopPropagation();
    });
    $("#add_group_field").unbind('click').click(function(e){
        e.stopPropagation();
    });
    $("#cat_add_label").unbind('click').click(function(e){
        e.stopPropagation();
    });
    $("#add_category_button").unbind('click').click(function(e){
        e.stopPropagation();
    });
    $("#pos_add_label").unbind('click').click(function(e){
        e.stopPropagation();
    });
    $("#pos_add_label2").unbind('click').click(function(e){
        $('.language-options').css('display','none');
        $('.fluency-options').css('display','none');
        $('.cert-list').css('display','none');
        $('.skill-dropdown').css('display','none');
        e.stopPropagation();
    });
}

function change_category_of_positions(category_id_1){
    if($('#parent_id').val()=="0") {
        var temp=$("#cat_ids").val();
        var  cat_id_array= new Array();
        cat_id_array = temp.split(",");
        $.each(cat_id_array,function(index,value){
            $("#group_section_drag_"+category_id_1+",#group_section_drag_"+value).sortable({
                connectWith: ".group-section"
            }).disableSelection();
        });
    }
}


var employer_click_payment = {
    authenticate_error: function(){
        $('#one_click_payment_position_popup').hide();
        hideNormalShadow();
        showErrorShadow();
        $("#login_error").show();
        addFocusButton('retry-button-active');
        centralizePopup();
        $("#retry-button-active").unbind("click").bind("click",function(){
            employer_click_payment.hideErrorLogin();


        })
    },
    hideErrorLogin: function(){
        hideErrorShadow();
        $("#login_error").hide();
        showNormalShadow();
        employer_click_payment.one_click_popup();
    },
    one_click_popup: function(){
        $('#one_click_payment_position_popup').show();
        $("#pay_pass").val('');
        document.getElementById('pay_pass').onblur();
        $("#pay_pass").parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error input-text-error-empty");
        $("#pay_pass").parent().addClass("input-text");
        document.getElementById("confirm_button").className = "poition_enter_button rfloat";
        $("#confirm_button").unbind('click').bind('click', function(){
            if(validateEmptyOneClickPayment()){
                                    
            }
            else{
                $("#one_click_form").submit();
            }
        })
        showNormalShadow();
        centralizePopup();
        BrowserDetect.init();
        if ( BrowserDetect.browser == "Explorer" )
        {
            //wiring to onkeydown event
            document.getElementById('pay_pass').attachEvent('onkeydown', function(e){
                editorEvents(document.getElementById('pay_pass'), e);
            });

        }

        else if ( BrowserDetect.browser == "Chrome" || BrowserDetect.browser == "Safari" ){
            document.getElementById('pay_pass').addEventListener('keydown', function(e){
                editorEvents(document.getElementById('pay_pass'), e);
            }, false);

        }
        addFocusTextField('pay_pass');
    },
    one_click_payment_success: function(seeker_id, job_id, emp_id){
        hideNormalShadow();
        $("#cc_billing_popup").empty();
        $('#one_click_payment_position_popup').hide();
        if ($("#page_action").val() == "index"){
            sortDashboardTables('pairing','desc', $("#filter_value").val(), $('#parent_id').val(), "table_data");
        }
        else if ($("#page_action").val() == "candidate_pool"){
            sortCandidatePoolTables('pairing','desc',$('#filter_value').val(), "table_data")
        }
        else if($("#page_action").val() == "xref"){
            sortXrefTables('active desc,','pairing desc')
        }
        _showSeekerPopup(seeker_id, job_id, emp_id);

    },
    credit_card_show: function(){
        $('#one_click_payment_position_popup').hide();
        $.ajax({
            url: '/purchase_profile_payment/show_credit_card',
            cache: false,
            beforeSend: function() {
                showBlockShadow();
            },
            success: function(){
                hideBlockShadow();
            }
        });
    },
    credit_card_payment: function(){
        $("#cc_billing_popup").show();
        $("#one_click_text").html('Please select a new one-click payment method.');
        centralizePopup();
        $("#purchase-profile-form")
        .bind("ajax:beforeSend", loading_purchase_profile_form)
        .bind("ajax:complete", loaded_purchase_profile_form)
        .bind("ajax:error", error_purchase_profile_form)
       
        $("#payment_verify_button").unbind('click').bind('click', function(){
    
		
		
            if(validateEmptyPayment()){
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
            else{
                $("#purchase-profile-form").submit();
            }
                                
                        
        });
    },
    credit_card_payment_emp: function(){
        showNormalShadow();
        $("#cc_billing_popup").show();
        centralizePopup();
        
        // create a convenient toggleLoading function
    
    
        $("#purchase-profile-form")
        .bind("ajax:beforeSend", loading_purchase_profile_form)
        .bind("ajax:complete", loaded_purchase_profile_form)
        .bind("ajax:error", error_purchase_profile_form)
  
        $("#payment_verify_button").unbind('click').bind('click', function(){
            if(validateEmptyPayment()){
                
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
            else{
                $("#purchase-profile-form").submit();
            }
        });
    }
}

var loading_purchase_profile_form = function(){
    $('#payment_header').text('CREDIT CARD BILLING INFORMATION');
    $('#verify-loader-img').show();
    $('#payment_verify_button').hide();
    paymentHandlerStart();
    showBlockShadow();
}

var loaded_purchase_profile_form = function(){
    paymentHandlerStop();
    hideBlockShadow();
}
var error_purchase_profile_form = function(){
    request.abort();
    paymentHandlerStop();
}

function hideDashboardWarningPopup() {
    $("#dashboard-warning").hide();
    $("#fade_normal").hide();
    $("#fade_error").hide();
    footerOnClosingPopup();
}

function oneClickpaymentHandlerStart() {

    $('#preview_card_select').click(function() {

        });
    document.getElementById('preview_card_select').onclick="function(){}";
    document.getElementById('oneclick-close').onclick="function() {}";
    $('#oneclick-close').click(function() {

        });
}
function oneClickpaymentHandlerStop() {
    $("#preview_card_select").bind("click", function() {
        employer_click_payment.credit_card_show();
    });

    $('#oneclick-close').click(function() {
        hideNormalShadow();
        $('#one_click_payment_position_popup').hide();
    //$('#fade_normal').hide;
    });

}

function _showSeekerPopup(seeker_id,job_id, emp_id){
    $.ajax(
    {
        url: '/employer_account/view_seeker_profile',
        data: 'seeker_id=' + seeker_id + '&job_id=' + job_id + '&emp_id=' + emp_id,
        beforeSend: function() {
            showBlockShadow();
        },
        cache: false,
        success : function(response) {
            hideBlockShadow();
            $("#emp_detailed_view").show();
            centralizePopup();
            footerOnOpeningPopup();
            $(".usVeteran").css('top',$("#seeker_full_name").position().top+"px");
        }
    });
}

function showDashboardWarning(id, is_group, current_job_id,current_cat_id){
    footerOnOpeningPopup();
    $("#error-action-button").show();
    var action = "";
    if(is_group == 2){
        $("#action-button").html("<input type='button' id='error-action-button' class='delete-button-active' />");
        setContentWarningPopup("ALERT", "Please Add a Folder first.");
        $("#error-action-button").hide();
    } else if(is_group == 1){
        action = "deleteGroup(" + id + ","+current_job_id+","+current_cat_id+")";
        $("#action-button").html("<input type='button' id='error-action-button' class='delete-button-active' onclick='return " + action +"'/>");
        setContentWarningPopup("ARE YOU SURE?", "If you delete this category, you will also delete all the positions contained within it.");
    } else {
        action = "deletePosition(" + id + ","+current_job_id+")";
        $("#action-button").html("<input type='button' id='error-action-button' class='delete-button-active' onclick='return " + action +"'/>");
        setContentWarningPopup("ARE YOU SURE ?", "If you delete this position, you will not be able to recover it.");
    }
    $("#dashboard-warning").show();
    $('#fade_normal').show();
    centralizePopup();
    addFocusButton('error-action-button');
}

function addNewCategory(obj, e){
    $("#selected-cat-id").val($(obj).attr("val"));
    if($(obj).attr("val") == '0'){
        hidePositionCustomSelectBox();
        $("#category_popup_form").show();
        $("#state-selector").hide();

        $("#add_category_button_from_popup").attr("disabled","disabled");
        $("#add_category_button_from_popup").removeClass("enter-button-active");
        $("#add_category_button_from_popup").addClass("enter-button");
        $("#new-category-name").val("Add a new Folder");
        $("#new-category-name").addClass("placeholder");
        $("#new-category-name").focus();
    }else{
        $("#temp-name").text($(obj).children().text());
        $("#new-category-name").val(""); //reset input
        
        $("#add_category_button_from_popup").removeAttr("disabled");
        $("#add_category_button_from_popup").removeClass("enter-button");
        $("#add_category_button_from_popup").addClass("enter-button-active");
        hidePositionCustomSelectBox();
    }
    
    BrowserDetect.init();
    if (BrowserDetect.browser != "Explorer"){
        e.stopPropagation();
    }
    else{
        window.event.cancelBubble = true;
    }
    return false;
}

function activeSubmitButtonOnPopup(obj){
    if($(obj).hasClass("placeholder") || $(obj).val() == ""){
        $("#add_category_button_from_popup").attr("disabled", "disabled");
        $("#add_category_button_from_popup").addClass("enter-button");
        $("#add_category_button_from_popup").removeClass("enter-button-active");
    }
    else{
        $("#add_category_button_from_popup").removeAttr("disabled");
        $("#add_category_button_from_popup").removeClass("enter-button");
        $("#add_category_button_from_popup").addClass("enter-button-active");
        $(obj).removeClass("placeholder");
    }

}
function showPositionCustomSelectBox(){
    $("#position_options").show();
    
/*			
			
			$('#position_options .option').children().each(function(){
                            if($(this).attr('selected')=='-1'){
                                $(this).removeClass('selected').attr('selected', '');
                            }
                        });
                        
                        $('#position_options .option').find('li').each(function(){
			    if($(this).children().attr('id')=="1"){
				$(this).addClass('selected').attr('selected', '-1');
			    }
			});
                        $('.option').scrollTop(0);
                        //DropDownHandler.time = System.currentTimeMillis();
                        DropDownHandler.t = new Date().getTime();
                        
                        $(document).unbind('keydown').bind('keydown', function(e){
                            DropDownHandler.func(e, document.getElementById('position_options'), 'postype_emp');
                        });
     */
}

function hidePositionCustomSelectBox(){
    $("#position_options").hide();
//$(document).unbind('keydown');
}

function showPositionOverviewCustomSelectBox(){
    $("#position_overview_options").show();
    
    $('#position_overview_options .option').children().each(function(){
        if($(this).attr('selected')=='selected'){
            $(this).removeClass('selected').removeAttr('selected');
        }
    });
                        
    $('#position_overview_options .option').find('li').each(function(){
        if($(this).children().attr('id')=="1"){
            $(this).addClass('selected').attr('selected', 'selected');
        }
    });
    $('.option').scrollTop(0);
    //DropDownHandler.time = System.currentTimeMillis();
    DropDownHandler.t = new Date().getTime();
                        
    $(document).unbind('keydown').bind('keydown', function(e){
        DropDownHandler.func(e, document.getElementById('position_overview_options'), 'postype_emp');
    });
//
}

function showNewRootCustomSelectBox(){
    $("#new_root_options").show();

    $('#new_root_options .option').children().each(function(){
        if($(this).attr('selected')=='selected'){
            $(this).removeClass('selected').removeAttr('selected');
        }
    });

    $('#new_root_options .option').find('li').each(function(){
        if($(this).children().attr('id')=="1"){
            $(this).addClass('selected').attr('selected', 'selected');
        }
    });
    $('.option').scrollTop(0);
    //DropDownHandler.time = System.currentTimeMillis();
    DropDownHandler.t = new Date().getTime();

    $(document).unbind('keydown').bind('keydown', function(e){
        DropDownHandler.func(e, document.getElementById('new_root_options'), 'postype_emp');
    });
//
}

function hidePositionOverviewCustomSelectBox(){
    $("#position_overview_options").hide();
    $(document).unbind('keydown');
}

function hideNewRootCustomSelectBox(){
    $("#new_root_options").hide();
    $(document).unbind('keydown');
}

function showCustomSelectBox(){
    $("#state_options").show();
}

function hideCustomSelectBox(){
    $("#state_options").hide();
//$("#category_popup_form").show();
}

function showAddNewCategoryPopup(){
    /*reset popup add new category form */
    $("#new-category-name").val(""); //reset input
    $("#new-category-name").addClass("placeholder");
    $("#state-selector").show();
    $("#category_popup_form").hide();
    /*reset popup add new category form */
    footerOnOpeningPopup();
    $("#add-new-posotion").show();
    $('#fade_normal').show();
    centralizePopup();
    addFocusButton('add_category_button_from_popup');
}

function _openCareerSeekerTextBox(){
    var _offset = $('#career-seeker_id').offset();
    var _left = _offset.left-127;
    var _top = _offset.top-6;
    $('#career-seeker-ID').hide();
    $('#cross_ref_box').css({
        left:_left+"px",
        top:_top+"px"
    });
    $('#cross_ref_box').show();
    $('#add-x-ref-button').show();
    $('#fade_normal_status').show();
    addFocusTextField('career_seeker_name');
    footerOnOpeningPopup();
}
function setContentWarningPopup(header, msg){
    $("#dashboard-warning label.popup-heading").html(header);
    $("#dashboard-warning label.free-text").html(msg);
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
            }
            else {
                $('#payment_card_type').val('master');
                $('#master_card').val('master');
                $("#payment_images").html("<li><a href='javascript:void(0);' title='Master Card'><img src='/assets/Mastercard_1.png' alt='Master Card' height='31' width='52' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
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
            }else  {
                $('#payment_card_type').val('visa');
                $('#master_card').val('visa');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa'><img src='/assets/Visa_1.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
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
            }else {
                $('#payment_card_type').val('american_express');
                $('#master_card').val('american_express');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\");'><img src='/assets/AmericanExpress_1.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
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
            }
            else {
                $('#payment_card_type').val('discover');
                $('#master_card').val('discover');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\");'><img src='/assets/Discover_1.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\");'><img src='/assets/Paypal_2.png' alt='Paypal' height='31' width='72' /></a></li>");
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
                $('#master_card').val('paypal');
                $("#payment_images").html("<li><a href='javascript:void(0)' title='Master Card' onclick='setImage(\"master\");'><img src='/assets/Mastercard_2.png' alt='Master Card' width='52' height='31' border='0' /></a></li><li><a href='javascript:void(0);' title='Visa' onclick='setImage(\"visa\");'><img src='/assets/Visa_2.png' alt='Visa Card' height='31' width='47' /></a></li><li><a href='javascript:void(0);' title='American Express' onclick='setImage(\"american_express\");'><img src='/assets/AmericanExpress_2.png' alt='American Express Card' height='31' width='30' /></a></li><li><a href='javascript:void(0);' title='Discover' onclick='setImage(\"discover\");'><img src='/assets/Discover_2.png' alt='Discover Card' height='31' width='46' /></a></li><li><a href='javascript:void(0);' title='Paypal' onclick='setImage(\"paypal\");'><img src='/assets/Paypal_1.png' alt='Paypal' height='31' width='72' /></a></li>");
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
    } else {
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

//Payment form validation
function validateCreditCard(){
    var credit_card = $("#card_num").val();
    var mm = $("#month").val();
    var year = $("#year").val();
    var cvv = $("#cvv").val();

    //replace all validations with proper conditions (reg exp)
    if(credit_card.length < 16 || parseInt(mm) > 12 || year < 2011 || isNaN(cvv)){
        $("#payment_verify_button").attr("disabled", "disabled");
        $("#payment_verify_button").css({
            backgroundPosition: "-60px -113px"
        });
        return false;
    }else{
        $("#payment_verify_button").removeAttr("disabled");
        $("#payment_verify_button").css({
            backgroundPosition: "-150px -113px"
        });
        $("#payment_error_msg").html("");
        return false;
    }
}

function validateCreditCardInfo() {
    card_num = document.getElementById('card_num');
    month = document.getElementById('month');
    year = document.getElementById('year');
    cvv = document.getElementById('cvv');
    fname = document.getElementById('fname');
    lname = document.getElementById('lname');
    company = document.getElementById('payment_company_name');
    billing_address_one = document.getElementById('billing_address_one');
    billing_address_two = document.getElementById('billing_address_two');
    billing_city = document.getElementById('billing_city');
    billing_state = document.getElementById('billing_state');
    billing_zip = document.getElementById('billing_zip');
    billing_area_code = document.getElementById('billing_area_code');
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

    if(validateNotEmpty(card_num) && validateNotEmpty(month)&& validateNotEmpty(year) && validateNotEmpty(cvv) && validateNotEmpty(fname)&& validateNotEmpty(lname) && validateNotEmpty(billing_address_one) && validateNotEmpty(billing_city) && validateRequired(billing_state.value) && validateNotEmpty(billing_zip) && validateNotEmpty(billing_area_code)&& validateNotEmpty(billing_telephone_number) && (billing_telephone_number.value.length == 7)  && (card_num.value.length == card_length) && (billing_zip.value.length >= 3) && (billing_area_code.value.length == 3) && (cvv.value.length == cvv_length) && payment_card_type.value != ''){
        button = document.getElementById('payment_verify_button');
        //button.disabled="";
        button.className="verify-button-active rfloat";

    }
    else{
        button = document.getElementById('payment_verify_button');
        //button.disabled="disabled";
        button.className="verify-button rfloat";
    }
}

// Function to check if a text field is empty or not, can be used through out the application, pass JS element as parameter


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

var check_payment_options = {
    show_error_message: function(){
        hideNormalShadow();
        showErrorShadow();
        $('#payment_header').text("UNABLE TO VERIFY");
        $("#paypal_error_msg").show();
        $("#paypal_error_msg").html('Please check your payment information and try again.');
        $('#verify-loader-img').hide();
        $('#payment_verify_button').show();
    }
}

function redirectToPaypal_job_seeker_payment(url){
    var url =$("#page_url").val();
    window.location.href = "/purchase_profile_payment/paypal_payment?url=" + url;
}
function _openPositionBox(){
    $('#dashboard_position_popup').show();
    $('#position_fade_normal_status').show();
}
function _close_dashboard_position_box(){
    $('#dashboard_position_popup').hide();
    $('#position_fade_normal_status').hide();
}

function _closeOverlay(){
    footerOnClosingPopup();
    hideNormalShadow();
    $("#emp_detailed_view").empty();
}

function checkKeyupForEnterAddFolder(e){
    var code = e.keyCode;
    if(code == 13){
        //console.log(group_add_validation());
        if (!group_add_validation()){
            $("#add_group_form").submit();
        }
        else{
            e.preventDefault();
        }
    }
}
var group_add = {
    open: function(){
        $("#add_grp_box").slideToggle('fast');
        $("#add_group_field").parent().removeClass("input-text-error-empty");
        if (!$("#add_group_field").parent().hasClass("active-input")){
            $("#add_group_field").parent().addClass("input-text");
        }
        $("#add_category_button").unbind('click').bind('click', function(){
            if (!group_add_validation()){
                $("#add_group_form").submit();
            }
            else{
                        
        }
        })

    }
}

function group_add_validation(){
    var flag = 1;
    if($("#add_group_field").val()=="" || $("#add_group_field").val()=="Folder Name"){
        $("#add_group_field").parent().removeClass("input-text input-text-active active-input");
        $("#add_group_field").parent().addClass("input-text-error-empty");
        flag = 0;
    }
    if(flag)
        return false;
    else
        return true;
}

function deleteNotification(id) {
    $.ajax({
        url: '/account/remove_notifications',
        data: "n_id="+id,
        cache: false,
        success:function(){
            _openNotificationBox();
        //updateNotificationCount();

        }
    });
}
function updateNotificationCount() {
	 
    $.ajax({
        url: '/employer_account/fetch_notifications_count',
        data: "",
        cache: false,
        success:function(html_data){
            $(".notification_number_dashboard").html(html_data);
        }
    });
	
}
function deleteDashboardNotification(id) {
    var start = fetch_last_notification_id();
    $.ajax({
        url: '/employer_account/delete_notifications?id='+id+'&start='+start,
        cache: false,
        beforeSend: function() {
            showBlockShadow();
        },
        success:function(data){
            hideBlockShadow();
            $("#noft_"+id).remove();
            $("#notification_rows").append(data);
            removeButton();
            if($("ul#notification_rows li").length > 5){
                if ($(".notifications").height() < 300){
                    $("#viewAll").css('visibility', 'visible');
                }
                else{
                    $("#viewAll").css('visibility', 'hidden');
                }
            }
            else{
                $("#viewAll").css('visibility', 'hidden');
            }
              
        //updateNotificationCount();
        }
    });
}

function activateAddButton(){
    $('#add_category_button').addClass("add_category_button_active");
    $('#add_category_button').removeClass("add_category_button");
    //$('.add_category_button').css("background", "url(/assets/employer_v2/btn_add.png) no-repeat scroll 0 50% transparent");
    $("#add_category_button").removeAttr("disabled");
//document.getElementById('add_category_button1').disabled="";
}

function inactivateAddButton(){
    if($("#add_group_field").val()=="" || $("#add_group_field").val()=="Category Name"){
        $('#add_category_button').removeClass("add_category_button_active");
        $('#add_category_button').addClass("add_category_button");
    //$('.add_category_button').css("background", "");
    //$('#add_category_button').attr("disabled","disabled");
    }
}
/*------------------------tooltip popup----------------------------*/
function open_xref_popup(){
    var _offset = $('a.labelRemaining').offset();
    var _height = $('#xref-tooltip').height();
    var _width =  $('#xref-tooltip').width();
    var _left = _offset.left-250;
    var _top = _offset.top-_height-5;
    $('#vet-tooltip').fadeOut();
    $('#xref-tooltip').fadeIn('slow');
    //$('#fade_normal_status_xref').show();
    $('#xref-tooltip').css({
        left:_left,
        top:_top
    })

    return false;
}
function close_xref_popup(){
    $('#xref-tooltip').fadeOut();
    //$('#fade_normal_status_xref').hide();
    return false;
}

function open_vet_popup(){
    var _offset = $('a.labelRemaining_vet').offset();
    var _height = $('#vet-tooltip').height();
    var _width =  $('#vet-tooltip').width();
    var _left = _offset.left-250;
    var _top = _offset.top-_height-5;
    $('#xref-tooltip').fadeOut();
    $('#vet-tooltip').fadeIn('slow');
    // $('#fade_normal_status_vet').show();
    $('#vet-tooltip').css({
        left:_left,
        top:_top
    })
    $("#vet-tooltip").css("width", "215px");
    return false;
}
function close_vet_popup(){
    $('#vet-tooltip').fadeOut();
    //$('#fade_normal_status_vet').hide();
    return false;
}
function open_hiringcompany_popup(){                
    $('#hiring-company-popup').show();
    $('#fade_normal_status_hiring-company').show();
    footerOnOpeningPopup();
    return false;
}
function close_hiringcompany_popup(){
    $('#hiring-company-popup').hide();
    $('#fade_normal_status_hiring-company').hide();
    footerOnClosingPopup();
    return false;
}
function open_position_information_popup(){                
    $('#position-information-popup').show();
    $('#fade_normal_status_position-information').show();
    footerOnOpeningPopup();
    return false;
}
function close_position_information_popup(){
    $('#position-information-popup').hide();
    $('#fade_normal_status_position-information').hide();
    footerOnClosingPopup();
    return false;
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

function hideErrorLogin_signin() {
    hideErrorShadow();
    $("#login_error").hide();
}
/*


function careerSeeker_popup(){
                var _offset = $('#carrer-seeker-id-hdng').offset();
                var _height = $('#carrer_id_popup').height();
                var _width =  $('#carrer_id_popup').width();
                var _left = _offset.left;
                var _top = _offset.top-_height;
                //$('#carrer_id_popup').show();
                //$('#fade_normal_status_vet').show();
                //$('#vet-tooltip').css({left:_left,top:_top})
                //$("#vet-tooltip").css("width", "550px");
                // $('#vet-tooltip').css("position","absolute");
                // $('#vet-tooltip').css("z-index","9999999999");
                return false;
}
function close_careerSeeker_popup(){
                $('#vet-tooltip').hide();
                $('#fade_normal_status_vet').hide();
                 return false;
}
 */

/*-----------------------------Show Delete Notification Image-------------------------------------*/

function showDeleteNotificationImage(notification_id)
{
    $("#remove-notification-img1-"+notification_id).hide();
    $("#remove-notification-img2-"+notification_id).show();
}
function hideDeleteNotificationImage(notification_id)
{
    $("#remove-notification-img1-"+notification_id).show();
    $("#remove-notification-img2-"+notification_id).hide();
}

function hideErrorLogin(){
    $("#pay_pass").val('');
    if(document.getElementById('pay_pass'))
        document.getElementById('pay_pass').onblur();
    if(document.getElementById("confirm_button"))
        document.getElementById("confirm_button").className = "poition_enter_button rfloat";
    hideErrorShadow();
    $("#gift_hilo_signin_failure").hide();
    $("#login_error").hide();
}

/*--------------------------Checking length of input category name----------------------------*/
function truncate(str, size){
    if(str.length > 20) {
        str = str.substring(0,size) + "...";
    }
    return str;
}

/*--------------------------Hide Input Field On Container Click--------------------------------------*/
function removeResetCompanyFormRedCross(){
    if($.trim($('#company_name').val())==""||$.trim($('#company_name').val())=="Company Name")
        $('.reset-form').hide();
}
var xref_box = {
    reload_xref_box: function(){
        var xref_val = $('#career_seeker_name').val();
        $.ajax({
            url: '/position_profile/xref_check',
            data: "xref_val=" + xref_val,
            cache: false,
            success: function(){

            }
        });
    },
    success_show: function(xref_val){
        window.location.href = "/position_profile/xref/" + xref_val+'?selected='+$('#parent_id').val();
    },
    failure_show: function(xref_val){
        $("#career_seeker_name").val("");
        blur_element(document.getElementById('career_seeker_name'));
        $("#fade_normal_status").hide();
        showErrorShadow();
        $('#cross_ref_box').hide();
        $('#add-x-ref-button').hide();
        $("#xref_error_popup").show();
        addFocusButton('ok-xref_error_popup');
        $('#career-seeker-ID').show();
        centralizePopup();
        footerOnOpeningPopup();
    },
    error_popup_close: function(){
        hideErrorShadow();
        footerOnClosingPopup();
        $("#xref_error_popup").hide();
        document.getElementById('add-x-ref-button').className = 'add-x-ref-button';
    //$('#add-x-ref-button').attr("disabled","disabled");
    },
    keyAction: function(e){
        var code = e.keyCode;
        if(code == 13){
            if ($("#add-x-ref-button").hasClass("add-x-ref-button_active")){
                enterXrefBox();

            }
        }

    },
    retry: function(){
        hideErrorShadow();
        $("#xref_error_popup").hide();
        $('#career-seeker-ID').hide();
        $('#cross_ref_box').show();
        $('#add-x-ref-button').show();
        document.getElementById('add-x-ref-button').className = 'add-x-ref-button';
        //$('#add-x-ref-button').attr("disabled","disabled");
        $('#fade_normal_status').show();
        setTimeout(function(){
            addFocusTextField('career_seeker_name');
        },200);
    }
}

/*---------------------------------Download Resume of Job seeker---------------------------------------*/
/*var birkman_report_employer = {
	request_pdf: function(job_seeker_id){
                $(".download-anchor").hide();
		$("#career_guide_loader").show();
		$.ajax({
		  url: '/employer_account/request_pdf',
                  data:'job_seeker_id='+job_seeker_id,
   		  cache: false,
		  success:function(){
                  }
		});
	},
	pending: function(){
		msg_box.show_error("[{msg: 'Birkman report is still under processing.'}]","Status");
	},
	download: function(job_seeker_id){
		window.location.href = "/employer_account/download_pdf?job_seeker_id="+job_seeker_id;
                $("#career_guide_loader").hide();
                $(".download-anchor").show();

	}
}
 */
function downloadResume(job_seeker_id){
    $(".download-anchor").hide();
    $("#career_guide_loader").show();
    $.ajax({
        url: '/employer_account/request_pdf',
        data:'job_seeker_id='+job_seeker_id,
        cache: false,
        success:function(){
            window.location.href = "/employer_account/download_pdf?job_seeker_id="+job_seeker_id;
            $("#career_guide_loader").hide();
            $(".download-anchor").show();
        }
    });
}



var posting = {
    common_share_task: function(posting_id, status){
        if (status == true){
            $('#url-share').show();
            $('#facebook-share').show();
            $('#twitter-share').show();
            $('#linkedin-share').show();
        }
        else {
            $.ajax({
                url: '/postings/common_share_task',
                data: "posting_id=" + posting_id,
                cache: false,
                success: function(){
                    //window.location.reload();
                    return false;
                }
            });

        }
    },

    hilo_share_task: function(posting_id,status,id){
        showBlockShadow();
        if (status == true){
            $('#url-share').show();
        }
        $.ajax({
            url: '/postings/hilo_share_task',
            data: "posting_id=" + posting_id + "&id=" + id + "&status=" + status,
            cache: false,
            success: function(data){
                if(data=="Done") {
                    window.location.reload();
                }
            }
        });

    },

    facebook_share_task: function(posting_id,platform_id,job_id){
        showBlockShadow();
        $.ajax({
            url: '/postings/facebook_share_task',
            data: "posting_id=" + posting_id,
            cache: false,
            success: function(){
                window.location.reload();
            },
            error: function (request, status, error) {
                window.location.reload();
            }
        });

    },

    twitter_share_task: function(posting_id,platform_id,job_id){
        showBlockShadow();
        $.ajax({
            url: '/postings/twitter_share_task',
            data: "posting_id=" + posting_id,
            cache: false,
            success: function(){
                window.location.reload();
            }
        });

    },

    linkedin_share_task: function(posting_id,platform_id,job_id){
        showBlockShadow();
        $.ajax({
            url: '/postings/linkedin_share_task',
            data: "posting_id=" + posting_id,
            cache: false,
            success: function(){
                window.location.reload();
            }
        });

    },

    url_share_task: function(posting_id){
        showBlockShadow();
        $.ajax({
            url: '/postings/url_share_task',
            data: "posting_id=" + posting_id,
            cache: false,
            success: function(){
                window.location.reload();
                return false;
            }
        });

    },

    share_task: function(posting_id,platform_id,job_id){
        showBlockShadow();
        share_job.share(posting_id,platform_id,job_id, "employer");
    },
    activate_share: function(posting_id, sharing_channel){
        $.ajax({
            url: '/postings/activate_share',
            data: 'posting_id=' + posting_id + '&sharing_channel=' + sharing_channel,
            cache: false,
            success: function(){
                switch (sharing_channel){
                    case 1:
                        $("#"+sharing_channel+"_post").html("Re-tweet it.");
                        break;
                    case 2:
                        $("#"+sharing_channel+"_post").html("Re-post to your<br /> company's Facebook wall.");
                        break;
                    case 3:
                        $("#"+sharing_channel+"_post").html("Re-post to your<br /> company's Linkedin page.");
                        break;
                }
                $("#"+sharing_channel+"_post_image").show();
            }
        });
    },
    activate_company_share: function(sharing_channel){
        $.ajax({
            url: '/company_postings/activate_share',
            data: 'sharing_channel=' + sharing_channel,
            cache: false,
            success: function(){
                switch (sharing_channel){
                    case 1:
                        $("#"+sharing_channel+"_post").html("Re-tweet it.");
                        break;
                    case 2:
                        $("#"+sharing_channel+"_post").html("Re-post to your<br /> company's Facebook wall.");
                        break;
                    case 3:
                        $("#"+sharing_channel+"_post").html("Re-post to your<br /> company's Linkedin page.");
                        break;
                }
                $("#"+sharing_channel+"_post_image").show();
            }
        });
    }
}

function showSuccessSharingMsg(msg){
    showSuccessShadow();
    $("#posting-success").show();
    addFocusButton('posting-success_button');
    $("#position_popup_select_box label").html(msg);
    $("#posting-success").focus();
}

var profile_blocks = {
    close_if_open: function(){
        $(".accordan").children().each(function(){
            if($(this).hasClass('open')){
                $(this).find('div.accordion-content').slideUp();
                $(this).find('div.accordion-content').empty();
                $(this).addClass('closed').removeClass('open');
                $(this).find('a').addClass('close').removeClass('open');
            }
        });
    },
    open_overview: function(cat_id){
        if($('#overview').parent().hasClass('closed')){
            var job_id = $('#jid').val();
            profile_blocks.close_if_open();
            showBlockShadow();
            $.ajax({
                url:'/position_profile/overview',
                data: 'jid='+job_id+'&cat_id='+cat_id,
                cache: false,
                success: function(data){
                    hideBlockShadow();
                    $('#overview').parent().find('div.accordion-content').html(data).slideDown();
                    $('#overview').parent().addClass('open').removeClass('closed');
                    $('#overview').find('a').addClass('open').removeClass('close');
                    placeholderReplace();
                    $("#whatWasClicked").val('');
                //assign and slidedown and change classes
                }
            })
        }
        else{
            $('#overview').parent().find('div.accordion-content').slideUp();
            $('#overview').parent().find('div.accordion-content').empty();
            $('#overview').parent().addClass('closed').removeClass('open');
            $('#overview').parent().find('a').addClass('close').removeClass('open');
        }
    },
    open_wrkenv: function(){
        if($('#work-env').parent().hasClass('closed')){
            showBlockShadow();
            var job_id = $('#jid').val();
            profile_blocks.close_if_open();
            $.ajax({
                url:'/position_profile/workenv',
                data: 'jid='+job_id,
                cache: false,
                success: function(data){
                    hideBlockShadow();
                    $('#work-env').parent().find('div.accordion-content').html(data).slideDown();
                    $('#work-env').parent().addClass('open').removeClass('closed');
                    $('#work-env').find('a').addClass('open').removeClass('close');
                    $("#whatWasClicked").val('');
                }
            })
        }
        else{
            $('#work-env').parent().find('div.accordion-content').slideUp();
            $('#work-env').parent().find('div.accordion-content').empty();
            $('#work-env').parent().addClass('closed').removeClass('open');
            $('#work-env').parent().find('a').addClass('close').removeClass('open');
        }
    },
    open_credentials: function(){
        if($('#credentials').parent().hasClass('closed')){
            var job_id = $('#jid').val();
            profile_blocks.close_if_open();
            showBlockShadow();
            $.ajax({
                url:'/position_profile/credentials_tab',
                data: 'jid='+job_id,
                cache: false,
                success: function(data){
                    $('#credentials').parent().find('div.accordion-content').html(data).slideDown();
                    $('#credentials').parent().addClass('open').removeClass('closed');
                    $('#credentials').find('a').addClass('open').removeClass('close');
                    $("#whatWasClicked").val('');
                    hideBlockShadow();
                }
            })
        }
        else{
            $('#credentials').parent().find('div.accordion-content').slideUp();
            $('#credentials').parent().find('div.accordion-content').empty();
            $('#credentials').parent().addClass('closed').removeClass('open');
            $('#credentials').parent().find('a').addClass('close').removeClass('open');
        }
    },
    open_preview: function(){
        if($('#preview').parent().hasClass('closed')){
            var job_id = $('#jid').val();
            profile_blocks.close_if_open();
            // Check is div is to be opened or not!
            if($("#preview").children('a').hasClass("clickable")) {
                showBlockShadow();
                $.ajax({
                    url:'/position_profile/preview_tab',
                    data: 'jid='+job_id,
                    cache: false,
                    success: function(data){
                        $('#preview').parent().find('div.accordion-content').html(data).slideDown();
                        $('#preview').parent().addClass('open').removeClass('closed');
                        $('#preview').find('a').addClass('open').removeClass('close');
                        $("#whatWasClicked").val('');
                        hideBlockShadow();
                    }
                });
            }
            else {
        // Do nothing :)
        }
        }
        else {
            $('#preview').parent().find('div.accordion-content').slideUp();
            $('#preview').parent().find('div.accordion-content').empty();
            $('#preview').parent().addClass('closed').removeClass('open');
            $('#preview').parent().find('a').addClass('close').removeClass('open');
        }
    },
    check_incomplete: function(){
        $(".accordion-heading").each(function(){
            if($(this).find('span').hasClass('incompleted')){
                $(this).click();
                return false;
            }
        });
    },
    toggle_block: function(){
        var flag = 0;
        var i = 0;
        var but;
        var clickedElement, previousElement;
        $(".accordan").children().each(function(){
            $(this).find('div.accordion-heading').click(function(){
                flag = 0;
                clickedElement = $(this).attr('id');
		
                if($(this).parent().hasClass('closed')){
                    if($(this).parent().prev().find('div.accordion-heading span').html() == "Completed" || $(this).attr('id') == "overview"){
                        $(".accordan").children().each(function(){
                            if($(this).hasClass('open')){
                                //this means li
                                //check here\
                                previousElement = $(this).find('div.accordion-heading').attr('id');
				
                                var arr = $('input[name^="check"]');

                                for(i = 0; i<arr.length; i++){
                                    if(arr[i].className == "btn-save active"){
                                        but=arr[i];
                                    }
                                }
                                if(but){
                                    $("#save-popup").show();
                                    footerOnOpeningPopup();
                                    centralizePopup();
                                    addFocusButton('save-button-failsafe');
                                    showErrorShadow();
                                    $("#save-button-failsafe").click(function(){
                                        //submit
                                        //pos_profile_work_role_ques.save();
                                        $("#"+but.id).click();
                                    });
                                    
                                    /*$("#save-close").click(function(){
                                        $("#save-popup").hide();
                                        hideErrorShadow();
                                        //dont save
                                        //code phat raha hain
                                        openTab(clickedElement, previousElement);
				    });*/
				    
                                    $("#save-close").click(function(){
                                        if(clickedElement=="overview"){
                                            closeTabPopup("overview");
                                        }
                                        else if(clickedElement=="work-env"){
                                            closeTabPopup("work-env");
                                        }
                                        else if(clickedElement=="credentials"){
                                            closeTabPopup("credentials");
                                        }
                                        else{
                                            closeTabPopup("preview");
                                        }
                                    })
                                    
                                    $("html, body").animate({
                                        scrollTop: 0
                                    }, "slow");
                                    flag = 100;
                                }
                                else{
                                    $(this).find('div.accordion-content').slideUp();
                                    $(this).addClass('closed').removeClass('open');
                                    $(this).find('a').addClass('close').removeClass('open');
                                    flag = 1;
                                }
				
                            }
                        /*
			    else if($(this).hasClass('open') && ($(this).find('div.accordion-heading span').html()=="Incomplete" || $(this).find('div.accordion-heading span').html()=="Not Available")){
				flag = 3;
			    }
                             */
                        })

                        if(flag == 0){
                            flag = 2;
                        }
                        if(flag == 1){
                            /*if($(this).attr('id')=="preview"){
                                footerOnOpeningPopup();
				postingPopup();
			    }
			    else
                             */
                            /***************************************/
                            if(clickedElement=="work-env") {
                                if($(this).find('span').attr('class')=="completed") {
                                    $("#new_work_role_env_form").hide();
                                    $("#summary_work_env_role").show();
                                }
                            }
                            /***************************************/
                            {
                                $(this).parent().find('div.accordion-content').slideDown();
                                $(this).parent().addClass('open').removeClass('closed');
                                $(this).find('a').addClass('open').removeClass('close');
                            }
                        }
                        if(flag == 2){ //since all are closed
                        /*if($(this).attr('id')=="preview"){
			        footerOnOpeningPopup();
				postingPopup();
			    }
			    else
                             */
                        {
				
                            /***************************************/
                            if(clickedElement=="work-env") {
                                if($(this).find('span').attr('class')=="completed") {
                                    $("#new_work_role_env_form").hide();
                                    $("#summary_work_env_role").show();
                                }
                            }
                            /***************************************/
                            $(this).parent().find('div.accordion-content').slideDown();
                            $(this).parent().addClass('open').removeClass('closed');
                            $(this).find('a').addClass('open').removeClass('close');
                        }
                        }

                        if(flag==100){}
                    }
                }
                else if($(this).parent().hasClass('open')){
                    $(this).parent().find('div.accordion-content').slideUp();
                    $(this).parent().addClass('closed').removeClass('open');
                    $(this).find('a').addClass('close').removeClass('open');
                }
            })
        })
    }
}

function closeTabPopup(param){    
    var url = document.URL + "";        
    var url = url.split("#");
    url = url[0];
    var url = url.split("modify_id=1");
    url = url[0].split("?");
    var url = url[0].split("?");
    
    if(url.length == 1){	    
        $("#save-close").attr("href", url[0] + "?target="+param);
    }
    else{	
        $("#save-close").attr("href", url[0] + "&target="+param);
    }
    return false;	
}

function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function openTab(clickedElement, previousElement, btn){ //div heading, div heading, btn  
    $("#"+previousElement).find('a').addClass('close').removeClass('open');
    $("#"+previousElement).parent().find('.accordion-content').slideUp();
    $("#"+previousElement).parent().addClass('closed').removeClass('open');
    
    $("#"+clickedElement).parent().addClass('open').removeClass('closed');
    $("#"+clickedElement).parent().find('.accordion-content').slideDown();
    $("#"+clickedElement).find('a').addClass('open').removeClass('close');
}

var prof_autocomplete = {
    create: function(){
        var options = {
            serviceUrl:'/ajax/get_proficiencies_for_employer' ,
            width:270,
            maxHeight:100
        };

        proficiency_autocomplete = $('#add_skill').autocomplete(options, "skills_click_autocomplete()", "skill-dropdown");
    }
}

var cert_autocomplete = {
    create: function(){
        var options = {
            serviceUrl:'/ajax/get_certificates' ,
            width:370,
            maxHeight:100
        };
        certificate_autocomplete = $('#add_cert_text').autocomplete(options, "certificate_click_autocomplete()", "cert-list");
    }
}
var text_in_cert_box = false;
var certificate_ev2 = {

    list_arr: [],
    list_flag_arr: [],
    initialize: function(cert_values, cert_required_flag){
        if(cert_values != "_jucert_" && cert_required_flag!=","){
            this.list_arr = unescape_str_new(cert_values).split("_jucert_");
            this.list_flag_arr = unescape_str(cert_required_flag).split(",");
            $("#validate-certificate").val("1");
        }
        this.list_arr.clean("");
        this.list_flag_arr.clean("");
        this.create_elements();
    },
    show: function(){
    },
    hide: function(){
    },
    add_to_list: function(value){
        if(!this.list_arr.has(value) && unescape_str_new(value) != jQuery.trim($("#add_cert_text_placeholder").val()))
        {
            this.list_arr.push(unescape_str_new(value));
            if($("#editing").val() != "") {
                $("#editing").val("");
            }
        }
    },
    add_another: function(value, flag){
        if(validateRequired($("#add_cert_text").val())) {
            if($("#validate-certificate").val()=="1"){
                if(!this.list_arr.has(value) && unescape_str_new(value) != jQuery.trim($("#add_cert_text_placeholder").val()) && value.trim()!="")
                {
                    this.list_arr.push(unescape_str_new(value));
                    this.list_flag_arr.push(flag);
                    if($("#editing").val() != "") {
                        $("#editing").val("");
                    }
                }
                this.list_arr.clean("");
                this.create_elements();
                text_in_cert_box = false;
            }
        } else {
            $("#add_cert_text").val('');
            $("#add_cert_text").blur();
        }
    },
    create_elements: function(edit, delete_row){
        if(edit != "edit"){
            if(delete_row != "delete"){
                $("#add_cert_text").val("Begin typing to access the database.");
                $("#add_cert_text").parent().removeClass("active-input input-text input-text-active");
                $("#add_cert_text").parent().addClass("input-text");
                $("#cert_required_flag_1").attr("checked", "checked");
                $("#cert_required_flag_2").attr("checked", "");
                $("#cert-flag").val("0");
                $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                $("#selected-lang-id").val("");
            }
        }
        var str = "";
        if($("#validate-certificate").val()=="1"){
            $("div#licensesAndCertifications-Div").html("");
            for(var i=0; i<this.list_arr.length; i++){
                str += "<div class='licenses_Certifications_container'><div class='top-curve'>&nbsp;</div><div class='content'><label onclick='certificate_ev2.edit_row("+i+")'><a style='cursor: default;' id='123' href='javascript:void(0);'>" + unescape_str_new(this.list_arr[i]) + " - " + ((unescape_str_new(this.list_flag_arr[i]) == "0") ? "Desired" : "Required") + "</a></label><a class='remove' title='remove' onclick='certificate_ev2.remove_row("+i+");hideCertificateInnerTextBox();' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div><div class='bottom-curve'>&nbsp;</div></div>";
            }
            $("div#licensesAndCertifications-Div").append(str);
            $("#licensesAndCertifications-Div").show();
            if(delete_row == "delete" && text_in_cert_box == false){
                $("#add_cert_text").val("");
                $("#add_cert_text").blur();
            }
            if(edit != "edit"){
                if(delete_row != "delete"){
                    $('#add_cert_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
                    $('#add_cert_text').val($('#add_cert_text_placeholder').val());
                }
            }
        }
    },
    edit_row: function(val){
        this.add_another($('#add_cert_text').val(), $('#cert-flag').val());
        for (var i = 0; i < this.list_arr.length; i++){
            if (val == i)
            {
                $("#add_cert_text").val(this.list_arr[i]);
                if(this.list_flag_arr[i]=="0"){
                    $("#cert-flag").val("0");
                    $("#cert_required_flag_2").attr("checked","");
                    $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                    $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                    $("#cert_required_flag_1").attr("checked","checked");
                }
                else{
                    $("#cert-flag").val("1");
                    $("#cert_required_flag_1").attr("checked","");
                    $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                    $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                    $("#cert_required_flag_2").attr("checked","checked");
                }
                $("#validate-certificate").val('1');
                $("#add_cert_text").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#add_cert_text").parent().addClass('active-input');
            }
        }
        this.remove_row(val,"edit");
    },
    remove_row: function(val,edit){
        var new_arr = [];
        var new_flag_arr = [];
        for(var i = 0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
                new_flag_arr.push(this.list_flag_arr[i]);
            }
        }
        this.list_arr = new_arr;
        this.list_flag_arr = new_flag_arr;
        $("#validate-certificate").val("1");
        this.create_elements(edit, "delete");
        $("#tab-1_hasThisFormBeenEdited").val(1);
    }

    
//    list_arr: [],
//    list_flag_arr: [],
//    initialize: function(cert_values, cert_required_flag){
//        if(cert_values != ""){
//            this.list_arr = unescape_str(cert_values).split("_jucert_");
//            this.list_flag_arr = unescape_str(cert_required_flag).split(",");
//            $("#degrees").show();
//            $("#add-skill-3").hide();
//        }
//        this.create_elements();
//    },
//    show: function(){
//        $("#cert_add_link").hide();
//        $("#cert_add_box").show();
//        $("#add_cert_text").focus();
//    },
//    hide: function(){
//        $("#cert_add_link").show();
//        $("#cert_add_box").hide();
//        $("#add_cert_text").val("");
//    },
//    add_to_list: function(value, flag){
//        $("#add_cert").val("Begin typing to access the database.");
//        $("#add_cert").parent().removeClass("active-input input-text input-text-active");
//        $("#add_cert").parent().addClass("input-text");
//        if(login_section_type == "employer") {
//            //$("#cert-button").attr("disabled","disabled");
//            document.getElementById('cert-button').className = "btn-add-active";
//            $("#cert_required_flag_1").attr("checked", "checked");
//            $("#cert_required_flag_2").attr("checked", "");
//            $("#cert-flag").val("0");
//            $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
//            $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
//            $("#selected-lang-id").val("");
//        }
//        if(this.list_arr.in_array(value,"insensitive") == -1)
//        {
//            /*
//			if(login_section_type == "employer" && $(".credential-row").length + 1 > 5){
//				$("#cert_error_div").show();
//			}
//			else{
//			*/
//            this.list_arr.push(unescape_str_new(value));
//            this.list_flag_arr.push(flag);
//            if($("#editing").val() != "") {
//                $("#editing").val("");
//            }
//            this.create_elements();
//        /*
//			}
//			*/
//        }
//    },
//    create_elements: function(edit, delete_row){
//
//        if(edit != "edit"){
//            if(delete_row!="delete"){
//                $("#add_cert").val("Begin typing to access the database.");
//                $("#add_cert").parent().removeClass("active-input input-text input-text-active");
//                $("#add_cert").parent().addClass("input-text");
//            //$("#certificate").hide();
//            //$('.add-button').show();
//            }
//            else{
//
//        }
//        }
//        $("#cert-table").html("");
//        for(var i=0;i<this.list_arr.length;i++){
//            var required_str = "";

//            var str = "<li><div class='top-curve'>&nbsp;</div><div class='cont'>";
//            str += "<label onclick='certificate_ev2.edit_row(" + i + ")' id ='123'>" +  unescape_str_new(this.list_arr[i]) + " - " + ((unescape_str_new(this.list_flag_arr[i]) == "0") ? "Desired" : "Required") + "</label>";
//            str += "<a href='javascript:void(0);' onclick='certificate_ev2.remove_row(" + i + ");' title='remove' class='remove'><img height='20' width='20' alt='Remove Skill' src='/assets/employer_v2/remove-skill.png'></a>";
//            str += "</div><div class='bottom-curve'>&nbsp;</div></li>";
//            str += required_str;
//            $("#cert-table").append(str);
//        /*
//			if (login_section_type == "employer"){
//			employer_mark_required_lang_and_certificates();
//			}
//			*/
//        }
//    },
//    remove_row: function(val){
//        if (login_section_type == "employer"){
//        //$("#cert_error_div").hide();
//        }
//        var new_arr = [];
//        var new_flag_arr = [];
//        for(var i =0; i < this.list_arr.length; i++){
//            if (val != i)
//            {
//                new_arr.push(this.list_arr[i]);
//                new_flag_arr.push(this.list_flag_arr[i]);
//            }
//        }
//        this.list_arr = new_arr;
//        this.list_flag_arr = new_flag_arr;
//        this.create_elements("edit", "delete");
//        if (login_section_type == "employer"){
//            if($(".credential-table li").length <= 5){
//                $("#cert-button").show();
//            }
//            //credential_enter();
//        }
//        var checked_arr = [];
//
//        $(".credential-cert-required-col").each(function(){
//            if($(this).find("img").first().attr("src").indexOf("btn-radio-small-active") > -1){
//                checked_arr.push("0");
//            }else if($(this).find("img").last().attr("src").indexOf("btn-radio-small-active") > -1) {
//                checked_arr.push("1");
//            }
//            else {
//
//        }
//        });
//        $("#required_certificates").val(checked_arr.join(","));
//        //delete any item
//        $("#tab-1_hasThisFormBeenEdited").val(1);
//    },
//    edit_row: function(val){
//        if($('.edit-show').is(':visible')==true) {
//            if ($("#cert-button").hasClass('edit-row')){
//                certbox_submit();
//            }
//        }
//
//        for (var i = 0; i < this.list_arr.length; i++){
//            if (val == i)
//            {
//                $("#add_cert").val(this.list_arr[i]);
//                if(this.list_flag_arr[i]=="0"){
//                    $("#cert-flag").val("0");
//                    $("#cert_required_flag_2").attr("checked","");
//                    $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
//                    $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
//                    $("#cert_required_flag_1").attr("checked","checked");
//                }
//                else{
//                    $("#cert-flag").val("1");
//                    $("#cert_required_flag_1").attr("checked","");
//                    $("#cert_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
//                    $("#cert_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
//                    $("#cert_required_flag_2").attr("checked","checked");
//                }
//                //$("#cert-button").attr("disabled","");
//                //$("#cert-button").removeClass("btn-add btn-add-active");
//                //$("#cert-button").addClass("btn-add-active");
//                $("#add_cert").parent().removeClass("input-text input-text-active active-input input-text-error");
//                $("#add_cert").parent().addClass('active-input');
//                document.getElementById('cert-button').className="btn-add-active edit-row edit-show";
//                ///////////////////////////////////////////////////////////////////////////////////////////////////////
//                $('#cert-button').click(function(){
//                    //if(document.getElementById('cert-button').disabled==false && $("#cert-button").hasClass("btn-add-active")){
//                        certbox_submit();
//                    //}
//                })
//            }
//        }
//        $('#certificate').html("<input type='hidden' name='editing' value='editing-cert' id='editing' />");
//        certificate_ev2.remove_row(val,"edit");
//    },
//    apply_click_event_for_required: function(){
//        $(".credential-cert-required > a").live("click",function(){
//            $(this).parent().siblings().find("img").attr("src","/assets/employer_v2/btn-radio-small-INactive.png");
//            $(this).children("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
//
//            var checked_arr = [];
//
//            $(".credential-cert-required-col").each(function(){
//                if($(this).find("img").first().attr("src").indexOf("btn-radio-small-active") > -1){
//                    checked_arr.push("0");
//                }else if($(this).find("img").last().attr("src").indexOf("btn-radio-small-active") > -1) {
//                    checked_arr.push("1");
//                }
//                else {
//
//            }
//            });
//            $("#required_certificates").val(checked_arr.join(","));
//
//        });
//    }
}

function certbox_submit(){
    if($("#add_cert").val().replace(/\s/g,"") == "")
    {
        return false;
    }
    if($("#add_cert").val().trim() != "Begin typing to access the database." && $("#add_cert").val().trim() !="") {
        $("#tab-1_hasThisFormBeenEdited").val(1);
        certificate_ev2.add_to_list($("#add_cert").val(), $("#cert-flag").val());
        if($(".credential-table li").length == 5){
            //$("#cert-button").attr("disabled","disabled");
            $("#cert-button").hide();
        }
        //credential_enter();
        return false;
    }
}

var skills_ev2 ={
    list_arr: [],
    list_arr2: [],
    initialize: function(skill_values){
        var temp;
        if(skill_values != ""){
            this.list_arr = unescape_str_new(skill_values).split("_juprof_");
            $("#skills").show();
            $("#add-skill-1").hide();
        }
        this.create_elements();
    },

    add_show_val: function(){
        if($("#add_skill").val().trim() != "Type to select from database or enter your own." && $("#add_skill").val().trim() !=""){
            $("#skill-button").removeAttr("disabled");
            document.getElementById('skill-button').className="btn-add-active";
            $("#skill-button").click(function(){
                if(document.getElementById('skill-button').disabled == false && $("#skill-button").hasClass("btn-add-active")) {
                    skills_ev2.skill_add_submit();
                }
            });
        }
    /*else{
            $("#skill-button").attr("disabled","disabled");
            document.getElementById('skill-button').className="btn-add";
        }*/
    },

    add_show: function(e){
        if($("#match-occured").val()=="occured" && $("#add_skill").val() != "Type to select from database or enter your own." && $(e).attr("id") != -1){
            $("#skill-button").attr("disabled","");
            document.getElementById('skill-button').className="btn-add-active";
            $("#skill-button").click(function(){
                if(document.getElementById('skill-button').disabled == false && $("#skill-button").hasClass("btn-add-active")) {
                    skills_ev2.skill_add_submit();
                }
            });
        }
    //$("#educationLevel span.education-default").attr("id",$(e).attr("id"));
    },
    add_show_skill: function(e){
        if($("#match-occured").val()=="occured" && $("#add_skill").val() != "Type to select from database or enter your own." && $(e).attr("id") != -1){
            $("#skill-button").attr("disabled","");
            document.getElementById('skill-button').className="btn-add-active";
            $("#skill-button").click(function(){
                if(document.getElementById('skill-button').disabled == false && $("#skill-button").hasClass("btn-add-active")) {
                    skills_ev2.skill_add_submit();
                }
            });
        }
    //$("#skillLevel span.skill-default").attr("id",$(e).attr("id"));
    },

    skill_add_submit: function(){
        if($("#add_skill").val().trim() != "Type to select from database or enter your own.") {
            skills_ev2.add_to_list($("#add_skill").val().trim());
            $("#tab-1_hasThisFormBeenEdited").val(1);
            if ($(".added-skills li").length == 5 ){
                $("#skill-button").hide();
            }
        //credential_enter();
        }
    },

    add_to_list: function(val){
        //var temp_arr = [];
        $("#add_skill").val("Type to select from database or enter your own.");
        $("#add_skill").parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#add_skill").parent().addClass("input-text");
        if(login_section_type == "employer"){
            //$("#skill-button").attr("disabled","disabled");
            document.getElementById('skill-button').className="btn-add-active";
        }

        if(this.list_arr.in_array(val,"insensitive") == -1){
            this.list_arr.push(val);
            this.create_elements();
        }
    },

    create_elements: function(edit, delete_row){
        if (edit != "edit"){
            if (delete_row!="delete"){
                $("#add_skill").val("Type to select from database or enter your own.");
                $("#add_skill").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#add_skill").parent().addClass("input-text");

                //$("#educationLevel span.education-default").text("Education Level");
                //$("#education-options div label.education-default").text("Education Level");
                //$(".education-default").removeClass("text-active");
                //$("#skillLevel span.skill-default").text("Skill Level");
                //$("#skill-options div label.skill-default").text("Skill Level");
                //$(".skill-default").removeClass("text-active");
                $("div#proficiencyOccurence").html("<input type='hidden' value='not-occured' id='match-occured' />");
            }
        }

        $("#skill-table").html("");
        var required_str = "";
        for(var i=0;i<this.list_arr.length;i++){
            var str = "<li><div class='top-curve'>&nbsp;</div><div class='cont'>";
            str += "<label class='label-accessDatabase' onclick='skills_ev2.edit_row(" + i + ")' id ='123'>" + unescape_str_new(this.list_arr[i]) + "</label>"
            str += "<a href='javascript:void(0);' onclick='skills_ev2.remove_row(" + i + ");' title='remove' class='remove'><img height='20' width='20' alt='Remove Skill' src='/assets/employer_v2/remove-skill.png'></a>";
            str += "</div><div class='bottom-curve'>&nbsp;</div></li>";
            str += required_str;
            $("#skill-table").append(str);
        }
    },

    remove_row: function(val,edit){
        var new_arr = [];
        var new_arr2 = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        if ($(".added-skills li").length <= 5 ){
            $("#skill-button").show();
        }
        $("#tab-1_hasThisFormBeenEdited").val(1);
        this.create_elements(edit,"delete");
    },

    edit_row: function(val){
        if($('.btn-add-active').is(':visible')==true) {
            if ($("#skill-button").hasClass('edit-row')){
                skills_ev2.skill_add_submit();
            }

        }
        var temp;
        for (var i = 0; i < this.list_arr.length; i++){

            if (val == i)
            {
                $("#add_skill").val(unescape_str_new(this.list_arr[i]));
                $("#add_skill").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#add_skill").parent().addClass("active-input");
                //$("#skill-button").attr("disabled","");
                document.getElementById('skill-button').className="btn-add-active edit-row";

                $("#skill-button").click(function(){
                    if(document.getElementById('skill-button').disabled == false && $("#skill-button").hasClass("btn-add-active")) {
                        skills_ev2.skill_add_submit();
                    }
                });
            }
        }
        skills_ev2.remove_row(val,"edit");
    }
}

function credential_enter(){
//    if ($(".lang-table li").length != 0 && $(".added-skills li").length != 0){
//        //$("#credential-enter").attr("disabled","");
//        //$("#credential-enter").removeClass("enter-button enter-button-active");
//        //$("#credential-enter").addClass("enter-button-active");
//        //$("#credential-submit").removeClass("btn-save btn-save-active");
//        //$("#credential-submit").addClass("btn-save-active");
//        document.getElementById('credential-submit').className="btn-save active";
//        document.getElementById('credential-submit').disabled="";
//        $("#field-edited").val(1);
//    }
//    else{
//        //$("#credential-enter").attr("disabled","disabled");
//        //$("#credential-enter").removeClass("enter-button enter-button-active");
//        //$("#credential-enter").addClass("enter-button");
//        //$("#credential-submit").removeClass("btn-save btn-save-active");
//        //$("#credential-submit").addClass("btn-save");
//        document.getElementById('credential-submit').className="btn-save";
//        document.getElementById('credential-submit').disabled="disabled";
//        $("#field-edited").val(0);
//    }

}

var language_ev2 ={
    //    list_arr: [],
    //    list_arr2: [], //to store lang id
    //    list_flag_arr: [],
    //    initialize: function(lang_values, lang_required_flag){
    //        var temp;
    //        if(lang_values != "" && lang_required_flag != ""){
    //            this.list_arr = unescape_str(lang_values).split(",");
    //            this.list_flag_arr = unescape_str(lang_required_flag).split(",")
    //            for(var i=0;i<this.list_arr.length;i++){
    //                temp = this.list_arr[i].split("__");
    //                this.list_arr2.push(temp[0]);
    //            }
    //            $("#languages").show();
    //            $("#add-skill-2").hide();
    //        }
    //        this.create_elements();
    //    },

    list_arr: [],
    list_arr2: [],
    list_flag_arr: [],
    initialize: function(lang_values, lang_required_flag){
        var temp;
        this.list_arr2 = [];
        if(lang_values != "" && lang_required_flag != ""){
            this.list_arr = unescape_str(lang_values).split(",");
            this.list_flag_arr = unescape_str(lang_required_flag).split(",")
            for(var i=0;i<this.list_arr.length;i++){
                temp = this.list_arr[i].split("__");
                this.list_arr2.push(temp[0]);
            }
            $("#validate-language").val("1");
        }
        this.create_elements();
    },

    show: function(){
        $("#language-add").hide();
        $("#language-selector-block").show();
    },

    add_show: function(e){
        if ($(e).attr("id") != "" &&  $("#fluency-selector .label-default-top").text() != "Level of Fluency"){
        //$("#lang-button").attr("disabled","");
        //document.getElementById("lang-button").className="btn-add-active";
        }
        $("#langauge-selector span.label-default").attr("id",$(e).attr("id"));
    },

    adv_conv: function(e){
        if ($(e).attr("id") == 2 ){
            // Send AJAX call
            $.ajax({
                url: '/position_profile/get_adv_pop_flag',
                cache: false,
                success: function(data) {
                    if(data == 'false'){
                        $("#fade_error").show();
                        $("#emp_advanced_popup").show();
                        addFocusButton('emp_advanced_popup_button');
                        footerOnOpeningPopup();
                        centralizePopup();

                        $(".checkbox-cont span.checkbox").unbind().click(function(){
                            language_ev2.adv_pop();
                        });
                        
                        $(".checkbox-cont label#adv-check-label").unbind().click(function(){
                            language_ev2.adv_pop();
                        });
                    }
                }
            });
        }

        if ($("#langauge-selector span.label-default").text() != "Language" &&  $(e).attr("id") != -1){
    }
    },
    adv_pop: function(e){
        $.ajax({
            url: '/position_profile/set_adv_pop_flag',
            cache: false
        });
    },
    close_pop: function(){
        $("#emp_advanced_popup").hide();
        $("#fade_error").hide();
        footerOnClosingPopup();
    },

    langbox_submit: function(){
        if($("#langauge-selector span.label-default").text().replace(/\s/g,"") == "") {
            return false;
        }
        if($("#fluency-selector .label-default-top").text()!="Level of Fluency" && $("#langauge-selector span.label-default").text()!="Language") {
            language_ev2.add_to_list($("#langauge-selector span.label-default").attr("id"), $("#fluency-selector .label-default-top").text(), $("#language-flag").val());
            $("#tab-1_hasThisFormBeenEdited").val(1);
            if ($(".lang-table li").length == 5 ){
                $("#lang-button").hide();
            }
            //credential_enter();
            return false;
        }
    },

    add_to_list: function(value1, value2, flag){
        var temp_arr = [];
        $("#langauge-selector").val("");
        $("#fluency-selector").val("");
        if(login_section_type == "employer"){
            document.getElementById("lang-button").className="btn-add-active";
            $("#lang_required_flag_1").attr("checked", "checked");
            $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
            $("#lang_required_flag_2").attr("checked", "");
            $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
            $("#language-flag").val("0");
            $("#selected-lang-id").val("");
        }
        if(value2 == "Advanced"){
            temp_arr = value1 + "__" + "a";
        }
        else if(value2 == "Conversational"){
            temp_arr = value1 + "__" + "c";
        }
        if(this.list_arr2.in_array(value1,"insensitive") == -1){
            this.list_arr2.push(value1);
            this.list_arr.push(temp_arr);
            this.list_flag_arr.push(flag);
            language_ev2.create_elements();
        }
    },
    add_another: function(value1, value2, flag){
        //console.log("value1:"+value1);
        var temp = "";
        if($("#validate-language").val()=="1"){
            if(value2 == "Advanced"){
                temp = value1 + "__" + "a";
            }
            else if(value2 == "Conversational"){
                temp = value1 + "__" + "c";
            }
            if(!this.list_arr2.has(value1) && !this.list_arr.has(temp))
            {
                //console.log("PUSHING");
                this.list_arr2.push(value1);
                this.list_arr.push(temp);
                //$("#language-remove").hide();
                this.list_flag_arr.push(flag);
            }
            this.list_arr.clean("");
            this.list_arr2.clean("");
            this.create_elements();
        }
    //console.log(this.list_arr);
    },
    //    create_elements: function(edit, delete_row){
    //        if (edit != "edit"){
    //            if(delete_row!="delete"){
    //                $("#langauge-selector span.label-default").text("Language");
    //                $("#fluency-selector .label-default-top").text("Level of Fluency");
    //                $("#fluency-selector div label.label-default").text("Level of Fluency");
    //                $(".language-options-content .label-default").text("Language");
    //                $("#fluency-selector .label-default-top").removeClass("text-active-red text-active-blue text-active");
    //                $("#langauge-selector .label-default").removeClass("text-active-red text-active-blue text-active");
    //                $(".language-options-content .label-default").removeClass("text-active-red text-active-blue text-active");
    //            }
    //        }
    //        var _temp;
    //        var temp;
    //        $("#lang-table").html("");
    //        var required_str = "";
    //        for(var i=0;i<this.list_arr.length;i++){
    //            var text;
    //            temp = this.list_arr[i].split("__");
    //            if (temp[1] == "a"){
    //                text = "Advanced";
    //            }
    //            else{
    //                text = "Conversational";
    //            }
    //            $(".language-options-content").find('li').each(function(){
    //                if($(this).children().attr('id') == temp[0]){
    //                    _temp = $(this).children().text();
    //                }
    //            //if ($("label",this).attr("id") == temp[0]){
    //            //_temp = $(this).text();
    //            //}
    //            });
    //
    //            var str = "<li><div class='top-curve'>&nbsp;</div><div class='cont'>";
    //            str += "<label class='label-language' onclick='language_ev2.edit_row(" + i + ")' id ='123'>" + _temp  + " - " + ((unescape_str(this.list_flag_arr[i]) == "0") ? "Desired" : "Required") + "</label>"
    //            if(text == "Advanced")
    //                str += "<label class='label-fluency text-active-red' onclick='language_ev2.edit_row(" + i + ")' id ='123'>"+ text +  "</label>";
    //            else
    //                str += "<label class='label-fluency text-active-blue' onclick='language_ev2.edit_row(" + i + ")' id ='123'>"+ text +  "</label>";
    //            str += "<a href='javascript:void(0);' onclick='language_ev2.remove_row(" + i + ");' title='remove' class='remove'><img height='20' width='20' alt='Remove Skill' src='/assets/employer_v2/remove-skill.png'></a>";
    //            str += "</div><div class='bottom-curve'>&nbsp;</div></li>";
    //            str += required_str;
    //            $("#lang-table").append(str);
    //        }
    //    },

    create_elements: function(edit, delete_row){
        if (edit != "edit"){
            if(delete_row!="delete"){
                $("#langauge-selector span.label-default").text("Language");
                $("#fluency-selector .label-default-top").text("Level of Fluency");
                $("#fluency-selector div label.label-default").text("Level of Fluency");
                $(".language-options-content .label-default").text("Language");
                $("#fluency-selector .label-default-top").removeClass("text-active-red text-active-blue text-active");
                $("#langauge-selector .label-default").removeClass("text-active-red text-active-blue text-active");
                $(".language-options-content .label-default").removeClass("text-active-red text-active-blue text-active");
                $("#fo").find("label").removeClass("text-active-red").removeClass("text-active-blue");
                $('#fluency-options-content label.label-default').removeClass("text-active-blue text-active-red");
                //added
                $("#lang_required_flag_1").attr("checked", "checked");
                $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                $("#lang_required_flag_2").attr("checked", "");
                $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                $("#language-flag").val("0");
                $("#selected-lang-id").val("");
            }
        }
        var temp;
        if($("#validate-language").val()=="1"){
            $("#langauges-Div").show();

            $("#langauges-Div").html("");
            for(var i=0;i<this.list_arr.length;i++){
                var text;
                temp = this.list_arr[i].split("__");
                if (temp[1] == "a"){
                    text = "Advanced";
                }
                else{
                    text = "Conversational";
                }
                //$("#language-options-content").find('li').each(function(){
                //    if($(this).children().attr('id') == temp[0]){
                //	_temp = $(this).children().text();
                //    }
                ////if ($("label",this).attr("id") == temp[0]){
                ////_temp = $(this).text();
                ////}
                //});

                var str = "<div class='langauges_container'><div class='top-curve'>&nbsp;</div><div class='content'>";
                str += "<label id='123' onclick='language_ev2.edit_row(" + i + ")' class='label-language'>" + temp[0] + " - " + ((unescape_str(this.list_flag_arr[i]) == "0") ? "Desired" : "Required") + "</label>";
                if(text == "Advanced")
                    str += "<label id='123' onclick='language_ev2.edit_row(" + i + ")' class='label-fluency text-active-red'>"+text+"</label>";
                else
                    str += "<label id='123' onclick='language_ev2.edit_row(" + i + ")' class='label-fluency text-active-blue'>"+text+"</label>";
                str += "<a class='remove' title='remove' onclick='language_ev2.remove_row(" + i + ");' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div><div class='bottom-curve'>&nbsp;</div></div>";
                $("div#langauges-Div").append(str);
                if (edit != "edit"){
                    if(delete_row!="delete"){
                        $('#validate-language').val('0');
                    }
                }

            }
        }

    },

    //    remove_row: function(val,edit){
    //        var new_arr = [];
    //        var new_arr2 = [];
    //        var new_flag_arr = [];
    //        for(var i = 0; i < this.list_arr.length; i++){
    //            if (val != i)
    //            {
    //                new_arr.push(this.list_arr[i]);
    //                new_flag_arr.push(this.list_flag_arr[i]);
    //            }
    //        }
    //        this.list_arr = new_arr;
    //        this.list_flag_arr = new_flag_arr;
    //        if ($(".lang-table li").length <= 5 ){
    //            $("#lang-button").show();
    //        }
    //
    //        for(var i =0; i < this.list_arr2.length; i++){
    //            if (val != i)
    //            {
    //                new_arr2.push(this.list_arr2[i]);
    //            }
    //        }
    //        this.list_arr2 = new_arr2;
    //        this.create_elements(edit, "delete");
    //        //Are you sure popup setting
    //        $("#tab-1_hasThisFormBeenEdited").val(1);
    //    },

    remove_row: function(val,edit){
        var new_arr = [];
        var new_arr2 = [];
        var new_flag_arr = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
                new_flag_arr.push(this.list_flag_arr[i]);
            }
        }
        this.list_arr = new_arr;
        this.list_flag_arr = new_flag_arr;
        for(var i = 0; i < this.list_arr2.length; i++){
            if (val != i)
            {
                new_arr2.push(this.list_arr2[i]);
            }
        }
        this.list_arr2 = new_arr2;
        //console.log(this.list_arr);
        $('#validate-language').val('1');
        this.create_elements(edit, "delete");
        $("#tab-1_hasThisFormBeenEdited").val(1);
    //credential_enter();
    },
    //    edit_row: function(val){
    //
    //        if($('.btn-add-active').is(':visible')==true) {
    //            if ($("#lang-button").hasClass('edit-row')){
    //                language_ev2.langbox_submit();
    //            }
    //
    //        }
    //        var temp;
    //        var _temp;
    //        for (var i = 0; i < this.list_arr.length; i++){
    //            if (val == i)
    //            {
    //                temp = this.list_arr[i].split("__");
    //                if (temp[1] == "a"){
    //                    text = "Advanced";
    //                }
    //                else{
    //                    text = "Conversational";
    //                }
    //                if(this.list_flag_arr[i]=="0"){
    //                    $("#language-flag").val("0");
    //                    $("#lang_required_flag_2").attr("checked","");
    //                    $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
    //                    $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
    //                    $("#lang_required_flag_1").attr("checked","checked");
    //                }
    //                else{
    //                    $("#language-flag").val("1");
    //                    $("#lang_required_flag_1").attr("checked","");
    //                    $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
    //                    $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
    //                    $("#lang_required_flag_2").attr("checked","checked");
    //                }
    //
    //                $(".language-options-content").find('li').each(function(){
    //                    if ($("label",this).attr("id") == temp[0]){
    //                        _temp = $(this).text();
    //                    }
    //                });
    //
    //                /*
    //			$("#language-selected").find('option').each(function(){
    //			    if($(this).attr('id') == temp[0]){
    //				_temp = $(this).text();
    //			    }
    //			})
    //			*/
    //                //$("#language-selected").val(_temp);
    //                //$("#fluency-selected").val(text);
    //
    //                $("#langauge-selector span.label-default").text(_temp);
    //                $("#fluency-selector .label-default-top").text(text);
    //
    //                $("#langauge-selector span.label-default").addClass('text-active');
    //                if($("#fluency-selector .label-default-top").text() == "Advanced"){
    //                    $("#fluency-selector .label-default-top").removeClass('text-active-blue');
    //                    $("#fluency-selector .label-default-top").addClass('text-active-red');
    //                }
    //                else{
    //                    $("#fluency-selector .label-default-top").removeClass('text-active-red');
    //                    $("#fluency-selector .label-default-top").addClass('text-active-blue');
    //                }
    //                $("#langauge-selector span.label-default").attr("id",temp[0]);
    //
    //                $("#selected-lang-id").val(temp[0]);
    //                //$("#langauge-selector span.label-default").attr("id",temp[0]);
    //                //$("#lang-button").attr("disabled","");
    //                document.getElementById("lang-button").className="btn-add-active edit-row";
    //
    //            //                        a=($("#"+ temp[1] + "_e").text());
    //            //                        b=($("#"+ temp[2] + "_s").text());
    //            }
    //        }
    //        language_ev2.remove_row(val,"edit");
    //    }

    edit_row: function(val){

        this.add_another($('#langauge-selector span.label-default').text(), $('#fluency-selector .label-default-top').text(), $('#language-flag').val());

        var temp;
        for (var i = 0; i < this.list_arr.length; i++){
            if (val == i)
            {
                $("#validate-language").val('1');

                temp = this.list_arr[i].split("__");
                if (temp[1] == "a"){
                    text = "Advanced";
                }
                else{
                    text = "Conversational";
                }

                if(this.list_flag_arr[i]=="0"){
                    $("#language-flag").val("0");
                    $("#lang_required_flag_2").attr("checked","");
                    $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                    $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                    $("#lang_required_flag_1").attr("checked","checked");
                }
                else{
                    $("#language-flag").val("1");
                    $("#lang_required_flag_1").attr("checked","");
                    $("#lang_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                    $("#lang_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                    $("#lang_required_flag_2").attr("checked","checked");
                }

                $("#langauge-selector span.label-default").text(temp[0]);
                $("#fluency-selector .label-default-top").text(text);

                $("#langauge-selector span.label-default").addClass('text-active');
                if($("#fluency-selector .label-default-top").text() == "Advanced"){
                    $("#fluency-selector .label-default-top").removeClass('text-active-blue');
                    $("#fluency-selector .label-default-top").addClass('text-active-red');
                }
                else{
                    $("#fluency-selector .label-default-top").removeClass('text-active-red');
                    $("#fluency-selector .label-default-top").addClass('text-active-blue');
                }
                $("#langauge-selector span.label-default").attr("id",temp[0]);
                $("#selected-lang-id").val(temp[0]);
            
            }
        }
        this.remove_row(val,"edit");
    //$("#language-remove").show();
    //alert($("#language-remove").css('display'));
    //$("#language-remove").css('display', 'block');

    }

}

var credential_save ={
    call: function(){
        
        showBlockShadow();

        var role_1 = $("#add_role1").val().trim();
        var role_2 = $("#add_role2").val().trim();
        var role_3 = $("#add_role3").val().trim();

        if(role_1 == "Role 1 (click to access)" || role_1 == ""){
            role_1 = "";
        }

        if(role_2 == "Role 2 (optional, click to access)" || role_2 == ""){
            role_2 = "";
        }

        if(role_3 == "Role 3 (optional, click to access)" || role_3 == ""){
            role_3 = "";
        }

        if(role_1=="" && (role_2!=""||role_3!="")){
            hideBlockShadow();
            $("#cert_err_msg").hide();
            $("#role_err_msg").show();
            $("#skill-cnt").addClass("error");
            return false;
        }
        
        var language1 = $('#langauge-selector').find('span').text().trim();
        var language2 = $('#fluency-selector .label-default-top').text().trim();

        if(language2=="Level of Fluency"){
            language2 = "";
        }
        else{
            if(language2 == "Conversational"){
                language2="c";
            }
            else{
                language2="a";
            }
        }

        if(language1=="Language"){
            language1 = "";
        }

        if((language1=="" || language2=="") && (language1!="" || language2!="")){
            hideBlockShadow();
            $("#cert_err_msg").hide();
            $("#language_err_msg").show();
            $("#lang-cnt").addClass("error");
            return false;
        }

        var degree = $('#add_deg_text').val();

        if(degree!="Begin typing to access the database." && degree!="" && $('#validate-degree').val()=="0"){
            hideBlockShadow();
            $("#cert_err_msg").hide();
            $("#degree_err_msg").show();
            $("#deg-cnt").addClass("error");
            return false;
        }
        
        /*This part of the code has been written for Roles section*/
        var role_arr;
        var role1;
        var role2;
        var role3;
        if($("#add_role1_placeholder").val()!="Role 1 (click to access)") {
            role1 = $("#add_role1_placeholder").val();
            role_arr = role1;
            if($("#add_role2_placeholder").val()!="Role 2 (optional, click to access)") {
                role2 = $("#add_role2_placeholder").val();
                role_arr = role_arr + "_roles_array_" + role2;
            }
            if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
                role3 = $("#add_role3_placeholder").val();
                role_arr = role_arr + "_roles_array_" + role3;
            }
        }
        $("#selected_roles").val(role_arr);
        /*Code for saving roles ends here*/

        var cert = $('#add_cert_text').val();
        if(!certificate_ev2.list_arr.has(cert) && $("#validate-certificate").val()=="1" && unescape_str_new(cert)!="" && unescape_str_new(cert) != jQuery.trim($("#add_cert_text_placeholder").val())){
            certificate_ev2.list_arr.push(cert);
            certificate_ev2.list_flag_arr.push($('#cert-flag').val());
        }
        var clg = $('#add_uni_text').val();
        if(!college_emp.list_arr.has(clg) && $("#validate-college").val()=="1" && unescape_str_new(clg) != "" && unescape_str_new(clg) != jQuery.trim($("#add_uni_text_placeholder").val())){
            college_emp.list_arr.push(clg);
        }
        
        //console.log(language_ev2.list_arr);
        if(!language_ev2.list_arr.has(language1+"__"+language2) && $("#validate-language").val()=="1" && !language_ev2.list_arr2.has(language1) && language1!="" && language2!=""){
            language_ev2.list_arr.push(language1+"__"+language2);
            language_ev2.list_arr2.push(language1);
            language_ev2.list_flag_arr.push($('#language-flag').val());
        }
        //console.log(language_ev2.list_arr);
        $("#certificate_param").val(certificate_ev2.list_arr.join("_jucert_"));
        $("#required_certificates").val(certificate_ev2.list_flag_arr.join(","));

        $("#selected_languages").val(language_ev2.list_arr.join(","));
        //console.log($("#selected_languages").val());
        $("#required_languages").val(language_ev2.list_flag_arr.join(","));

        if(degree!="Begin typing to access the database." && degree!=""){
            $("#degree_param").val(degree);
            $("#required_degree").val($("#degree-flag").val());
        }

        $("#selected_colleges").val(college_emp.list_arr.join("_ecolg_"));
        $("#credential_form").submit();
        $("input#tab-1_hasThisFormBeenEdited").val(0);
    }
}

function postingPopup(){
    showNormalShadow();
    footerOnOpeningPopup();
    $(".popup-loader").show();
    var job_id = $("#jid").val();
    $.ajax({
        url: '/position_profile/show_job_preview',
        cache: false,
        data: 'job_id='+job_id,
        success: function(){
            footerOnOpeningPopup();
            $(".popup-loader").hide();
            $("#position_overview").show();
            centralizePopup();
        }
    })

}

function postingDetails(){
    $('#position_overview').empty();
    $('#position_overview').hide();
    showNormalShadow();
    footerOnOpeningPopup();
    $(".popup-loader").show();
    var job_id = $("#jid").val();
    $.ajax({
        url: '/position_profile/show_job_details',
        cache: false,
        data: 'job_id='+job_id,
        success: function(){
            footerOnOpeningPopup();
            $(".popup-loader").hide();
            $("#position_details").show();
            showNormalShadow();
            centralizePopup();
            $('#overview-scroll-content').slimscroll({
                railVisible: true,
                allowPageScroll: true,
                height: '340px'
            });
        }
    })
}

//SLIDER -------------//
var clicked_basics= false;
var clicked_credentials= false;


var calculate_compensation = {
    slider_position: null,
    initialize: function(slider_pos){
        this.slider_position = slider_pos;
        this.fill_values();
    },
    call: function(event,ui){
        this.slider_position = ui.values;
        this.fill_values();
    },
    fill_values: function(){
        this.fill_compensation_range();
        this.fill_compensation_breakage();
    },
    fill_compensation_range: function(){
        var min = accounting.formatMoney(this.slider_position[0],"$",0);
        var max = accounting.formatMoney(this.slider_position[1],"$",0);
        if(accounting.unformat(max) == 300000)
            max = max + "+";
        $("#compensation-range").html(min+" - "+max);
    },
    fill_compensation_breakage: function(){
        var min = accounting.formatMoney(this.slider_position[0],"$",0);
        var max = accounting.formatMoney(this.slider_position[1],"$",0);
        var min_per_hour = accounting.formatMoney(accounting.unformat(min)/48/5/7);
        var max_per_hour = accounting.formatMoney(accounting.unformat(max)/48/5/7);
        if(accounting.unformat(max) == 300000) {
            max = max + "+";
            max_per_hour = max_per_hour + "+";
        }
        $("#comp11").html(min);
        $("#comp12").html(max);
        $("#comp21").html(min_per_hour);
        $("#comp22").html(max_per_hour);
    }
}

var mark_slider_values = {
    call: function(min, max){
        $("#slider").slider("values",[min,max]);
    }
}
var create_slider_alerts = {
    call: function(){
        $("#slider").slider({
            step: 1,
            min: 1,
            max: 3,
            stop: function(event,ui){
                $("#alert_threshhold_val").val(ui.value);
            }
        });
        //calculate_compensation.initialize(1);
        var slider_handle_arr = $(".ui-slider-handle");
        $(slider_handle_arr[0]).html("<img src='/assets/employer_v2/slider-small.png' width='60' height='20' />");
    }
}
var create_slider_roles_filter = {
    call: function(term){
        $("#slider_role").slider({
            step: 1,
            min: 1,
            max: 8,
            stop: function(event,ui){
                $("#role_sensitivity_val").val(ui.value);
                filterResults(term,$("#role_sort_val").val());
            }
        });
        var slider_handle_arr = $("#slider_role .ui-slider-handle");
        $(slider_handle_arr[0]).html("<img src='/assets/slider_handle_role.png' width='25' height='8' />");
    }
}
var create_slider = {
    call: function(){
        $("#slider").slider({
            range: true,
            min: 20000,
            max: 300000,
            step: 5000,
            values: [ 20000, 40000 ],
            slide: function(event,ui){
                $("#tab-1_hasThisFormBeenEdited").val("1");
                if(ui.values[0] > 200000) {
                    $("#salary-tooltip").fadeIn();
                    setTimeout(function(){
                        $("#salary-tooltip").fadeOut();
                    },5000);
                    return false;
                }
                calculate_compensation.call(event,ui);
            }
        });
        $("#slider > a").removeClass("ui-state-default ui-corner-all");
        calculate_compensation.initialize([ 20000, 40000 ]);
        var slider_handle_arr = $(".ui-slider-handle");
        $(slider_handle_arr[0]).html("<img style='margin-top: -5px;' src='/assets/employer_v2/slider-small-new.png' />");
        $(slider_handle_arr[1]).html("<img style='margin-top: -5px;' src='/assets/employer_v2/slider-small-new.png' />");
        
    }
}


function calculateChars(obj, max){
    var dest = "";
    var char_length = 0;
    if($(obj).is("textarea")){
        setMaxLength(obj, max);
        char_length = obj.value.length;
        dest = $(obj).parent().parent().parent().prev().find("span.character-remaining");
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
    dest.text("characters remaining: " + char_remaining);
    return;
}

function setMaxLength(obj, mlength){
    if (obj.getAttribute && obj.value.length>mlength)
        obj.value=obj.value.substring(0,mlength)
}

function toggleRadio(obj){
    if($(obj).is(':checked') == false){
        $(obj).prev().attr("checked","checked");
    }
    else{
        $(obj).prev().attr("checked","");
    }
    setRadioStatus();
    return false;
}

function setRadioStatus(){
    $("input['radio'].customize-radio").each(function() {
        $(this).hide();
        if($(this).is(':checked') == true){
            $(this).next().html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
        }else{
            $(this).next().html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
        }
    });
}

function employerProfileFormIsEdit(ev){
    var is_form_edit = $("#field-edited").val();
    if(is_form_edit == "1"){
        $("#save-popup").show();
        footerOnOpeningPopup();
        addFocusButton('save-button-failsafe');
        centralizePopup();
        showErrorShadow();     
        ev.stopPropagation()
    }
}

function validatePositionPreview(current_element){
    //START: Validation for company website starts here, highlights missing and error fields
    var website_1 = document.getElementById('website_1');
    var website_title_1 = document.getElementById('website_title_1');
    var website_2 = document.getElementById('website_2');
    var website_title_2 = document.getElementById('website_title_2');
    var website_3 = document.getElementById('website_3');
    var website_title_3 = document.getElementById('website_title_3');
    $("#overview_complete").val(1);

    if(validateNotEmpty(website_1)) {
        if(!validateNotEmpty(website_title_1)) {
            highlight_empty_fields(website_title_1);
            $("#overview_complete").val(0);
        }
        if(!checkURL(website_1.value)) {
            highlight_error_fields(website_1);
            $("#overview_complete").val(0);
        }
    }
    else {
        if(validateNotEmpty(website_title_1)) {
            highlight_empty_fields(website_1);
            $("#overview_complete").val(0);
        }
    }
	
    if(validateNotEmpty(website_2)) {
        if(!validateNotEmpty(website_title_2)) {
            highlight_empty_fields(website_title_2);
            $("#overview_complete").val(0);
        }
        if(!checkURL(website_2.value)) {
            highlight_error_fields(website_2);
            $("#overview_complete").val(0);
        }
    }
    else {
        if(validateNotEmpty(website_title_2)) {
            highlight_empty_fields(website_2);
            $("#overview_complete").val(0);
        }
    }
	
    if(validateNotEmpty(website_3)) {
        if(!validateNotEmpty(website_title_3)) {
            highlight_empty_fields(website_title_3);
            $("#overview_complete").val(0);
        }
        if(!checkURL(website_3.value)) {
            highlight_error_fields(website_3);
            $("#overview_complete").val(0);
        }
    }
    else {
        if(validateNotEmpty(website_title_3)) {
            highlight_empty_fields(website_3);
            $("#overview_complete").val(0);
        }
    }
    //END: Validation for company website starts here, highlights missing and error fields
    
    //START: Validation for hiring company
    var hiring_company = $("#hiring_company_true").is(':checked');
    if(!hiring_company) {
        var hiring_company_name = document.getElementById("hiring_company_name");
        if(!validateNotEmpty(hiring_company_name)) {
            highlight_empty_fields(hiring_company_name);
            $("#overview_complete").val(0);
        }
    }
    //END: Validation for hiring company

    //START: Validation for position information
    var remote_work = document.getElementsByName('remote_work')[1].checked;
    var name = document.getElementById('name');
    var position_type = $("#desired_employments").val();

    if(!validateNotEmpty(name)) {
        highlight_empty_fields(name);
        $("#overview_complete").val(0);
    }
    if(position_type==0) {
        // Red outline around dropdown, remember to remove it when drop down is selected.
        $(".position-info #position-type-selector .state-slector").addClass("error");
        $("#overview_complete").val(0);
    }
    if(!remote_work) {
        var street_address = document.getElementById('company_street_one');
        var company_city = document.getElementById('company_city');
        var company_state = document.getElementById('company_state');
        var company_country = document.getElementById('company_country');
          
        if(!validateNotEmpty(street_address)) {
            highlight_empty_fields(street_address);
            $("#overview_complete").val(0);
        }
        if(!validateNotEmpty(company_city)) {
            highlight_empty_fields(company_city);
            $("#overview_complete").val(0);
        }
        if(!validateNotEmpty(company_state)) {
            highlight_empty_fields(company_state);
            $("#overview_complete").val(0);
        }
        if(!validateNotEmpty(company_country)) {
            highlight_empty_fields(company_country);
            $("#overview_complete").val(0);
        }
    }
    //END: Validation for position information
    
    //START: Validation for reponsibilities
    var resp_1 = document.getElementById('resp_1');
    if(!validateNotEmpty(resp_1)) {
        highlight_empty_fields(resp_1);
        $("#overview_complete").val(0);
    }
    //STOP: Validation for reponsibilities
    
    //START: Validation for position preview
    if($("#overview-text").hasClass("placeholder") || $("#overview-text").val().trim() == "") {
        $("#overview-text").parent().parent().parent().parent().addClass("error");
        $("#overview_complete").val(0);
    }
    //STOP: Validation for position preview

    //START: Validation for position preview
    //if($("#summary").hasClass("placeholder") || $("#summary").val().trim() == "") {
    //    $("#summary").parent().parent().parent().parent().addClass("error");
    //    $("#overview_complete").val(0);
    //}
    //STOP: Validation for position preview
    if(!current_element){
        if ($("#attachmentpresent").val() == "true"){
            $('.attachment_title').each(function() {
                var attachment_title = document.getElementById($(this).attr('id'));
                if(!validateNotEmpty(attachment_title)) {
                    highlight_empty_fields($(this));
                    $("#overview_complete").val(0);
                }
            })
        }
    }
}

function validatePositionPreviewOnBlur(current_element){
    var company_city = document.getElementById('company_city');
    var website_1 = document.getElementById('website_1');
    var website_2 = document.getElementById('website_2');
    var website_3 = document.getElementById('website_3');

    if(company_city && current_element==company_city) {
        if($(".pac-container").css('display')=="block") {
            setTimeout(function(){
                if(validateNotEmpty(current_element)) {
                    if($("#dropdown_check_flag").val() == "0") {
                        highlight_error_fields(current_element);
                        $("#pi_error_msg").html('Select a city from the list.');
                    } else {
                        $(company_city).parent().removeClass("input-text input-text-active active-input input-text-error");
                        $(company_city).parent().addClass("active-input");
                        $("#pi_error_msg").html('');
                    }
                } else {
                    reset_fields(current_element);
                    $("#pi_error_msg").html('');
                }
            }, 1000);
        }
        else {
            if(validateNotEmpty(current_element)) {
                if($("#dropdown_check_flag").val() == "0") {
                    highlight_error_fields(current_element);
                    $("#pi_error_msg").html('Select a city from the list.');
                }
                else {
                    removeErrorBorder(current_element);
                    $("#pi_error_msg").html('');
                }
            }
            else {
                reset_fields(current_element);
                $("#pi_error_msg").html('');
            }
        }
    }
    if(current_element==website_1 || current_element==website_2 || current_element==website_3) {
        if(validateNotEmpty(current_element)) {
            if(!checkURL(current_element.value)) {
                highlight_error_fields(current_element);
                $("#web_err_msg").html('Invalid website address.');
            } else {
                removeErrorBorder(current_element);
                $("#web_err_msg").html('');
            }
        }
        else {
            reset_fields(current_element);
            $("#web_err_msg").html('');
        }
    }
}

function highlight_empty_fields(field) {
    $(field).parent().removeClass("input-text input-text-active active-input input-text-error");
    $(field).parent().addClass("input-text-error-empty");
}

function highlight_error_fields(field) {
    $(field).parent().removeClass("input-text input-text-active active-input input-text-error");
    $(field).parent().addClass("input-text-error");
}
function reset_fields(field) {
    $(field).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
    $(field).parent().addClass("input-text-unactive");
}
function removeErrorBorder(field) {
    $(field).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
    $(field).parent().addClass("input-text-active");
}

function checkDropDown(){
    var company_street_one_err = getInputFieldStatus($("#company_street_one"));
    var company_zip_err = getInputFieldStatus($("#company_zip"));
    var company_state_err = getInputFieldStatus($("#company_state"));
    var company_country_err = getInputFieldStatus($("#company_country"));
    var company_city_err = getInputFieldStatus($("#company_city"));
    radio = document.getElementsByName('remote_work');
    if (radio[1].checked == true){
        return false;
    }
    else if (company_street_one_err || company_state_err || company_country_err || company_city_err || $("#dropdown_check_flag").val() == "0"){
        return true;
    }
    else {
        return false;
    }

}

function attachment_valid(){
    if ($("#attachmentpresent").val() == "true"){
        if ($("#attachment_title").val() != "" && $("#attachment_title").val() != $("#attachment_title_placeholder").val()){
            return false;
        }
        else{
            return true;
        }
    }
    else{
        return false;
    }
}

function setSurePopupSaveEvent(evnt){
    $("#sure-popup-save-event").val(evnt);
}

function setSurePopupEvent(){
    var cross_event = $("#sure-popup-cross-event").val();
    var save_event = $("#sure-popup-save-event").val();
    if (cross_event == "" || cross_event == "#"){
        cross_event = "show_normal_dashboard_screen()";
        cross_event = "#"
    }
    $("#save-close").attr("href", cross_event);
    $("#save-button-failsafe").click(function(){
        if($("#" + save_event).is("form")){
            pos_profile_work_role_ques.save();
        }else{
            $("#" + save_event).click();
        }
    })

}

function getInputFieldStatus(id){
    //id.parent().hasClass("input-text-active") ||  || id.val() != ""
    if(id.parent().hasClass("input-text") || id.parent().hasClass("input-text-unactive")){
        return true; // no error
    }
    else{
        return false; //error
    }
}

function validateIdealWorkEnvironment(){
    var final_arr_work=[];
    var final_arr_role=[];
    var error_flag_work = false;
    var error_flag_role = false;

    $(".role-radio-slider").each(function(){
        var img_arr = $(this).find("img");
        var local_err = true;
        for(var j=0;j < img_arr.length;j++){
            if ($(img_arr[j]).attr("src").indexOf("btn-radio-small-active") > -1){
                local_err = false;
                break;
            }
        }
        if (local_err == true){
            error_flag_work = true;
        }
    });
    $(".work-radio-slider").each(function(){
        var img_arr = $(this).find("img");
        var local_err = true;

        for(var j=0;j < img_arr.length;j++){
            if ($(img_arr[j]).attr("src").indexOf("btn-radio-small-active") > -1){
                local_err = false;
                break;

            }

        }
        if (local_err == true){
            error_flag_work = true;
        }
    });
    
    /*if(error_flag_role == true){
        $("#work_role_ideal_questions").attr("disabled","disabled");
        $("#work_role_ideal_questions").removeClass("active");
        return true;
    }else */
    if(error_flag_work == true){
        $("#work_role_env_questions").attr("disabled","disabled");
        $("#work_role_env_questions").removeClass("active");
        return true;
    }else{
        $("#work_role_ideal_questions").removeAttr("disabled","disabled");
        $("#work_role_ideal_questions").addClass("active");
        $("#work_role_env_questions").removeAttr("disabled","disabled");
        $("#work_role_env_questions").addClass("active");
    }
}

var save_employer_basics = {
    call: function(obj){
        showBlockShadow();
        $("ul.daily-repo li").each(function(){
            if($(this).children().hasClass("input-text-error-empty") || $(this).children().hasClass("input-text")){
                $(this).find("input[type=text]").val("");
            }
        });

        $("ul.comp-web-cls li").each(function(){
            if($(this).children().hasClass("input-text") || $(this).children().hasClass("input-text-error-empty")){
                $(this).find("input[type=text]").val("");
            }
        });
        if($("#hiring_company_name").parent().hasClass("input-text") || $("#hiring_company_name").parent().hasClass("input-text-error-empty")){
            $("#hiring_company_name").val('');
        }

        if ($("#company_street_one").parent().hasClass("input-text") || $("#company_street_one").parent().hasClass("input-text-error-empty")){
            $("#company_street_one").val('');
        }

        if ($("#company_country").parent().hasClass("input-text") || $("#company_country").parent().hasClass("input-text")){
            $("#company_country").val('');
        }

        if ($("#company_city").parent().hasClass("input-text") || $("#company_city").parent().hasClass("input-text-error-empty")){
            $("#company_city").val('');
        }

        if ($("#company_state").parent().hasClass("input-text") || $("#company_state").parent().hasClass("input-text-error-empty")){
            $("#company_state").val('');
        }

        if ($("#company_country").parent().hasClass("input-text") || $("#company_state").parent().hasClass("input-text-error-empty")){
            $("#company_country").val('');
        }

        if ($("#company_zip").parent().hasClass("input-text") || $("#company_zip").parent().hasClass("input-text-error-empty")){
            $("#company_zip").val('');
        }

        $('.attachment_title').each(function() {
            if ($(this).parent().hasClass("input-text") || $(this).parent().hasClass("input-text-error-empty")){
                $(this).val('');
            }
        })
        $("#company_city").removeAttr("placeholder");
        
        $("#compensation_value_min").val($("#slider").slider("values")[0]/1000);
        $("#compensation_value_max").val($("#slider").slider("values")[1]/1000);
        $("#desired_paidtime_value").val(paidtime_arr[parseInt($("#paidtime_slider").slider("value"),10)]);
        $("#desired_commute_value").val(commute_arr[parseInt($("#commute_slider").slider("value"),10)]);
        validate_pairing_basics.fill_employment_field();

        var role_1 = $("#add_role1").val().trim();
        var role_2 = $("#add_role2").val().trim();
        var role_3 = $("#add_role3").val().trim();

        if(role_1 == "Role 1 (click to access)" || role_1 == ""){
            role_1 = "";
        }

        if(role_2 == "Role 2 (optional, click to access)" || role_2 == ""){
            role_2 = "";
        }

        if(role_3 == "Role 3 (optional, click to access)" || role_3 == ""){
            role_3 = "";
        }

        var language1 = $('#langauge-selector').find('span').text().trim();
        var language2 = $('#fluency-selector .label-default-top').text().trim();

        if(language2=="Level of Fluency"){
            language2 = "";
        }
        else{
            if(language2 == "Conversational"){
                language2="c";
            }
            else{
                language2="a";
            }
        }

        if(language1=="Language"){
            language1 = "";
        }

        var degree = $('#add_deg_text').val();

        /*This part of the code has been written for Roles section*/
        var role_arr;
        var role1;
        var role2;
        var role3;
        if($("#add_role1_placeholder").val()!="Role 1 (click to access)") {
            role1 = $("#add_role1_placeholder").val();
            role_arr = role1;
            if($("#add_role2_placeholder").val()!="Role 2 (optional, click to access)") {
                role2 = $("#add_role2_placeholder").val();
                role_arr = role_arr + "_roles_array_" + role2;
            }
            if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
                role3 = $("#add_role3_placeholder").val();
                role_arr = role_arr + "_roles_array_" + role3;
            }
        }
        $("#selected_roles").val(role_arr);
        /*Code for saving roles ends here*/

        var cert = $('#add_cert_text').val();
        if(!certificate_ev2.list_arr.has(cert) && $("#validate-certificate").val()=="1" && unescape_str_new(cert)!="" && unescape_str_new(cert) != jQuery.trim($("#add_cert_text_placeholder").val())){
            certificate_ev2.list_arr.push(cert);
            certificate_ev2.list_flag_arr.push($('#cert-flag').val());
        }
        var clg = $('#add_uni_text').val();
        if(!college_emp.list_arr.has(clg) && $("#validate-college").val()=="1" && unescape_str_new(clg) != "" && unescape_str_new(clg) != jQuery.trim($("#add_uni_text_placeholder").val())){
            college_emp.list_arr.push(clg);
        }

        if(!language_ev2.list_arr.has(language1+"__"+language2) && $("#validate-language").val()=="1" && !language_ev2.list_arr2.has(language1) && language1!="" && language2!=""){
            language_ev2.list_arr.push(language1+"__"+language2);
            language_ev2.list_arr2.push(language1);
            language_ev2.list_flag_arr.push($('#language-flag').val());
        }
        $("#certificate_param").val(certificate_ev2.list_arr.join("_jucert_"));
        $("#required_certificates").val(certificate_ev2.list_flag_arr.join(","));
        $("#selected_languages").val(language_ev2.list_arr.join(","));
        $("#required_languages").val(language_ev2.list_flag_arr.join(","));

        if(degree!="Begin typing to access the database." && degree!=""){
            $("#degree_param").val(degree);
            $("#required_degree").val($("#degree-flag").val());
        }

        $("#selected_colleges").val(college_emp.list_arr.join("_ecolg_"));

        this.submit_form(obj);

        $("ul.daily-repo li").each(function(){
            if($(this).children().hasClass("input-text-error-empty") || $(this).children().hasClass("input-text")){
                $(this).find("input[type=text]").val($(this).find("input[type=hidden]").val());
            }
        });

        $("ul.comp-web-cls li").each(function(){
            if($(this).children().hasClass("input-text") || $(this).children().hasClass("input-text-error-empty")){
                $(this).find("input[type=text]").val($(this).find("input[type=hidden]").val());
            }
        });
        if($("#hiring_company_name").parent().hasClass("input-text") || $("#hiring_company_name").parent().hasClass("input-text-error-empty")){
            $("#hiring_company_name").val($("#hiring_company_name_placeholder").val());
        }

        if ($("#company_street_one").parent().hasClass("input-text") || $("#company_street_one").parent().hasClass("input-text-error-empty")){
            $("#company_street_one").val($("#company_street_one_placeholder").val());
        }

        if ($("#company_country").parent().hasClass("input-text") || $("#company_country").parent().hasClass("input-text-error-empty")){
            $("#company_country").val($("#company_country_placeholder").val());
        }

        if ($("#company_city").parent().hasClass("input-text") || $("#company_city").parent().hasClass("input-text-error-empty")){
            $("#company_city").val($("#company_city_placeholder").val());
        }

        if ($("#company_state").parent().hasClass("input-text") || $("#company_state").parent().hasClass("input-text-error-empty")){
            $("#company_state").val($("#company_state_placeholder").val());
        }

        if ($("#company_country").parent().hasClass("input-text") || $("#company_state").parent().hasClass("input-text-error-empty")){
            $("#company_country").val($("#company_country_placeholder").val());
        }

        if ($("#company_zip").parent().hasClass("input-text") || $("#company_zip").parent().hasClass("input-text-error-empty")){
            $("#company_zip").val($("#company_zip_placeholder").val());
        }

        $('.attachment_title').each(function() {
            if ($(this).parent().hasClass("input-text") || $(this).parent().hasClass("input-text-error-empty")){
                $(this).val($("input.attachment_title_placeholder:first").val());
            }
        });
        return false;
    },
    validate_before_save: function(obj, save_flag) {
        $("#error-message").html("");
        $("#error-message").removeClass("fatal");
        var role_1 = $("#add_role1").val().trim();
        var role_2 = $("#add_role2").val().trim();
        var role_3 = $("#add_role3").val().trim();
        var language1 = $('#langauge-selector').find('span').text().trim();
        var language2 = $('#fluency-selector .label-default-top').text().trim();
        var degree = $('#add_deg_text').val();

        if(role_1 == "Role 1 (click to access)" || role_1 == ""){
            role_1 = "";
        }

        if(role_2 == "Role 2 (optional, click to access)" || role_2 == ""){
            role_2 = "";
        }

        if(role_3 == "Role 3 (optional, click to access)" || role_3 == ""){
            role_3 = "";
        }


        if (language2=="Level of Fluency"){
            language2 = "";
        } else {
            if(language2 == "Conversational"){
                language2="c";
            } else {
                language2="a";
            }
        }

        if(language1=="Language"){
            language1 = "";
        }
        if(role_1 == "" && role_2 == "" && role_3 == ""){
            $("#skill-cnt").addClass("error");
        }
        if($("#langauges-Div").children().length == 0 && language1 == "" && language2 == "" ) {
            $("#lang-cnt").addClass("error");
        }

        if(!validateNotEmpty(document.getElementById('name'))) {
            $("#error-message").html("ERROR<br />Please enter a Position Title.");
            $("#error-message").addClass("fatal");
            validatePositionPreview();
            return false;
        }
        else if($("#company_city").parent().hasClass("input-text-error")) {
            $("#error-message").html("ERROR<br />Please select a city from the list.");
            $("#error-message").addClass("fatal");
            validatePositionPreview();
            return false;
        } else if($("#website_1").parent().hasClass("input-text-error") || $("#website_2").parent().hasClass("input-text-error") || $("#website_3").parent().hasClass("input-text-error")) {
            $("#error-message").html("ERROR<br />Please a valid website address.");
            $("#error-message").addClass("fatal");
            validatePositionPreview();
            return false;
        } else if(role_1=="" && (role_2!=""||role_3!="")){
            $("#error-message").html("ERROR<br />Role 1 is mandetory.");
            $("#error-message").addClass("fatal");
            $("#skill-cnt").addClass("error");
            validatePositionPreview();
            return false;
        } else if ((language1=="" || language2=="") && (language1!="" || language2!="")){
            $("#error-message").html("ERROR<br />Langauge fluency is mandetory.");
            $("#error-message").addClass("fatal");
            $("#lang-cnt").addClass("error");
            validatePositionPreview();
            return false;
        } else if (degree!="Begin typing to access the database." && degree!="" && $('#validate-degree').val()=="0"){
            $("#error-message").html("ERROR<br />Degree is mandetory.");
            $("#error-message").addClass("fatal");
            $("#deg-cnt").addClass("error");
            validatePositionPreview();
            return false;
        } else {
            validatePositionPreview();
            $("#tab-1_hasThisFormBeenEdited").val(0);
            if($("#overview_complete").val()==0 && save_flag) {
                $("#error-message").html("SAVED<br />Incomplete<br />fields are<br />shown in red.<br />");
            }
            if(save_flag)
                save_employer_basics.call(obj);
            return false;
        }
    },
    submit_form: function(obj){
        $('#position-overview').submit();
    },
    validate: function(){
        var email_regex = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z0-9.-]{2,4}$/;
        var num_regex = /^\d+$/;
        var position_ok=true;
        var email_ok=false;
        var city_ok=true;
        var zipcode_ok=false;
        var company_ok=true;
        var err_arr = [];
        var respo = $(".responsibility .company-information ul.daily-repo input"); //each loop
        var error = true;
        var resp_error = false;

        if ($("#name").val() == ""){
            error = false;
            err_arr.push("Please provide a Position Title.");
        }

        if ($("#name").val().match(num_regex)){
            position_ok=false;
        }

        if (position_ok==false){
            error = false;
            err_arr.push("Position title can not be numeric.");
        }

        if ($("#company_name").val() == ""){
            error = false;
            err_arr.push("Please provide a Company Name.");
        }

        if ($("#company_name").val().match(num_regex)){
            company_ok=false;
        }

        if (company_ok==false){
            error = false;
            err_arr.push("Company Name can not be numeric.");
        }


        if ($("#company_group_id").val() == ""){
            error = false;
            err_arr.push("Please provide a Category.");
        }

        if ($("#company_street_one").val() == ""){
            error = false;
            err_arr.push("Please provide a Street Address.");
        }

        /*Company city is removed according to new layout
         *if ($("#company_city").val() == ""){
			error = false;
			err_arr.push("{'key' : 'company_city', 'msg' : 'Please provide a City.'}");
		}

		if ($("#company_city").val().match(num_regex)){
			city_ok=false;
		}

		if (city_ok==false){
			error = false;
			err_arr.push("{'key' : 'name', 'msg' : 'City name can not be numeric.'}");
		}*/

        if ($("#company_zip").val() == ""){
            error = false;
            err_arr.push("Please provide a Zip Code.");
        }

        if ($("#company_zip").val().match(num_regex)){
            zipcode_ok=true;
        }

        if (zipcode_ok==false){
            error = false;
            err_arr.push("Zip Code cannot contain characters.");
        }

        //                respo.each(function(){
        //                    if($(this).find("div.active-input").html() == null){
        //                        resp_error = false;
        //                    }
        //                });
        //
        //                if(resp_error == true){
        //                       error = false;
        //                       err_arr.push("Please provide atleast 1 Daily Responsibilty.");
        //                }
        //

        var employment_arr = $("#desired_employments").val();
        error = true;
        if(employment_arr != "0"){
            error = false;
        }
        //		for(var i=0; i < employment_arr.length; i++){
        //			if (employment_arr[i].checked == true){
        //				error = false;
        //				break;
        //			}
        //		}

        if(error){
            err_arr.push("Please select atleast one Desired Employment.");
        }

        if ($("#company_website").val() == ""){
            error = false;
            err_arr.push("Please provide a Company Website.");
        }

        if ( checkURL($("#company_website").val()) == 1){
            email_ok = true;
        }
        if(email_ok==false){
            error = false;
            err_arr.push("Please provide valid Email format for Company website.");
        }

        if ($("#owner_ship_type_id").val() == ""){
            error = false;
            err_arr.push("Please provide an Ownership.");
        }

        if ($("#summary").val() == ""){
            error = false;
            err_arr.push("Please provide a Position Description.");
        }



        if (err_arr.length > 0)	{
            // msg_box.show_error("[" + err_arr.join(",") + "]");
            showErrorPopup(err_arr.join("<br/>"));
            return false;
        }

        return true;
    }
}

function showErrorPopup(error_msg){
    $("#action-button").html("<input type='button' id='error-action-button' style='margin-left:150px;' class='retry-button-active' onclick='return hideDashboardWarningPopup();' />");
    setContentWarningPopup("OOPS!", error_msg);
    //$("#error-action-button").hide();
    $("#dashboard-warning").show();
    $('#fade_error').show();
    //showNormalShadow();
    centralizePopup();
}

var validate_pairing_basics = {
    call: function(save_type_val){
        var employment_arr = $("#desired_employments").val();
        error = true;
        if(employment_arr != "0"){
            error = false;
        }
        //		var employment_arr = document.getElementsByName("desired_employments[]");
        //		var error = true;
        //		for(var i=0; i < employment_arr.length; i++){
        //			if (employment_arr[i].checked == true){
        //				error = false;
        //				break;
        //			}
        //		}

        if(save_type_val == "credentials" && error == true)
        {
            msg_box.show_error("[{'key' : 'desired_employment', 'msg' : 'Please select atleast one Desired Employment.'}]");
            return false;
        }

        var location_arr = document.getElementsByName("desired_locations");
        var error = true;
        for(var i=0; i < location_arr.length; i++){
            if (location_arr[i].checked == true){
                error = false;
                break;
            }
        }

        if(save_type_val == "credentials" && error == true)
        {
            msg_box.show_error("[{'key' : 'desired_location', 'msg' : 'Please select atleast one Desired Location.'}]");
            return false;
        }


        $("#save_type").val(save_type_val);
        $("#compensation_value_min").val($("#slider").slider("values")[0]/1000);
        $("#compensation_value_max").val($("#slider").slider("values")[1]/1000);
        /*
		$("#desired_paidtime_value").val(paidtime_arr[parseInt($("#paidtime_slider").slider("value"),10)]);
		$("#desired_commute_value").val(commute_arr[parseInt($("#commute_slider").slider("value"),10)]);
         */

        this.fill_employment_field();
        this.fill_location_field();
        $("#basic_form").submit();
    },
    fill_employment_field: function(){
        error = true;
        if(employment_arr != "0"){
            error = false;
        }
        var employment_arr = $("#desired_employments").val();
        var id_arr = [];
        id_arr.push(employment_arr); //[]
        //		for (var i=0;i < employment_arr.length ; i++){
        //			if(employment_arr[i].checked == true){
        //				id_arr.push(employment_arr[i].value);
        //			}
        //		}
        $("#desired_employment_ids").val(id_arr.join(","));
                
    },
    fill_location_field: function(){
        var location_arr = document.getElementsByName("desired_locations");
        for (var i=0;i < location_arr.length ; i++){
            if(location_arr[i].checked == true){
                $("#desired_location_ids").val(location_arr[i].value);
                break;
            }
        }

    }
}

/* --------WORK ENVIRONMENT FORM-------*/
var pos_profile_work_role_ques={
    final_arr_work: [],
    final_arr_role: [],

    check_workenv_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/employer_v2/btn-radio-small-inactive.png");
        });
        $(e).children("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
        //validateIdealWorkEnvironment();
        setSurePopupSaveEvent("new_work_role_env_form");
    },
    check_role_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/employer_v2/btn-radio-small-inactive.png");
        });
        $(e).children("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
        //validateIdealWorkEnvironment();
        setSurePopupSaveEvent("new_work_role_env_form");
    },

    save: function(obj,save_flag){
        this.final_arr_work=[];
        this.final_arr_role=[];
        var error_flag_work = false;
        var error_flag_role = false;
        $(".env-ques-color-err").removeClass("env-ques-color-err");
        $(".role-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;
            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("btn-radio-small-active") > -1){
                    pos_profile_work_role_ques.final_arr_role.push($(img_arr[j]).parent().attr("data-val"));
                    local_err = false;
                    break;
                }
            }
            if (local_err == true){
                error_flag_role = true;
                $(this).addClass("env-ques-color-err");
            }
        });
        $(".work-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;

            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("btn-radio-small-active") > -1){
                    pos_profile_work_role_ques.final_arr_work.push($(img_arr[j]).parent().attr("data-val"));
                    local_err = false;
                    break;
                }
            }
            if (local_err == true){
                error_flag_work = true;
                $(this).addClass("env-ques-color-err");
            }
        });
        $("input#tab-2_hasThisFormBeenEdited").val(0);
        if(error_flag_role==true || error_flag_work==true){
            if(error_flag_role == true) {
                $("input#tab2_workenv_role").val(0);
                $("#role_block").addClass("error");

            } else {
                $("input#tab2_workenv_role").val(2);
                $("#role_block").removeClass("error");
            }
            if(error_flag_work == true) {
                $("input#tab2_workenv_work").val(0);
                $("#we_block").addClass("error");
            } else {
                $("input#tab2_workenv_work").val(2);
                $("#we_block").removeClass("error");
            }
            if(save_flag)
                this.submit_form();
            return false;
        }
        else{
            $("input#tab2_workenv_role").val(1);
            $("input#tab2_workenv_work").val(1);
            if(save_flag)
                this.submit_form();
            $(obj).attr("disabled","disabled");
            return false;
        }
    },

    submit_form: function(){
        $("#slider_values_work").val(this.final_arr_work.join(","));
        $("#slider_values_role").val(this.final_arr_role.join(","));
        $("#question_loader_role_work").show();
        $('#new_work_role_env_form').submit();

    },
    onload_work_role_questions: function(){
        var selected_vals_work = $("#slider_values_work").val().split(",");
        $(".work-radio-slider").each(function(index){
            $(this).find("a").each(function(){
                if($(this).attr("data-val") == selected_vals_work[index]){
                    $(this).find("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
                }
            });
        });

        var selected_vals_role = $("#slider_values_role").val().split(",");
        $(".role-radio-slider").each(function(index){
            $(this).find("a").each(function(){
                if($(this).attr("data-val") == selected_vals_role[index]){
                    $(this).find("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
                }
            });
        });


    }
}
var role_ques = {
    call: function(job_id){
        lighty.fadeBG(true);
        lighty.fade_div_layer(75,800);

        $.ajax({
            url: '/ajax/role_question',
            data: "job_id=" + job_id,
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    },
    update_image: function(job_id){
        lighty.close_fade_bg();
        $.ajax({
            url: '/ajax/update_role_image',
            data: "job_id=" + job_id,
            cache: false,
            success:function(data){
                var img_path = "/assets/" + data;
                $("#role_img").attr("src",img_path);
            }
        });
    },
    mark_check_onload: function(ques_id,val){
        var ele_arr = document.getElementsByName("ques_" + ques_id);
        for(var i=0;i < ele_arr.length;i++){
            if (ele_arr[i].value == val){
                ele_arr[i].checked = true;
            }
        }
    }
}


var validate_role_ques = function(){
    for(var i=0; i < 10; i++){
        var radio_name = $(".radio_grp_" +  i ).first().attr("name");
        if($("input[name='" + radio_name + "']:checked").val() == undefined){
            msg_box.show_error("[{msg: 'Check mark all the questions.'}]");
            return false;
        }
    }
}

var workenv = {
    call: function(job_id){
        lighty.fadeBG(true);
        lighty.fade_div_layer(75,800);

        $.ajax({
            url: '/ajax/work_question',
            data: "job_id=" + job_id,
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    },
    update_image: function(job_id){
        lighty.close_fade_bg();
        $.ajax({
            url: '/ajax/update_workenv_image',
            data: "job_id=" + job_id,
            cache: false,
            success:function(data){
                var img_path = "/assets/" + data;
                $("#workenv_img").attr("src",img_path);
            }
        });
    },
    mark_check_onload: function(ques_id,val){
        var ele_arr = document.getElementsByName("ques_" + ques_id);
        for(var i=0;i < ele_arr.length;i++){
            if (ele_arr[i].value == val){
                ele_arr[i].checked = true;
            }
        }
    }
}

var pos_profile_work_ques = {
    final_arr: [],
    check_workenv_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/employer_v2/btn-radio-small-inactive.png");
        });
        $(e).children("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
    },
    save: function(){

        this.final_arr = [];
        var err_flag = false;

        $(".env-ques-color-err").removeClass("env-ques-color-err");
        $(".work-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;

            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("filled_workenv_img") > -1){
                    pos_profile_work_ques.final_arr.push($(img_arr[j]).parent().attr("data-val"));
                    local_err = false;
                    break;
                }
            }
            if (local_err == true){
                err_flag = true;
                $(this).addClass("env-ques-color-err");
            }
        });

        if (err_flag == true){
            msg_box.show_error("[{msg: 'You must answer all of the questions.'}]");
            return false;

        }
        else{
            this.submit_form();
        }
    },
    submit_form: function(){
        $("#slider_values").val(this.final_arr.join(","));
        $("#question_loader").show();
        $('#work_evn_form').submit();

    },
    onload: function(){
        var selected_vals = $("#slider_values").val().split(",");
        $(".work-radio-slider").each(function(index){
            $(this).find("a").each(function(){
                if($(this).attr("data-val") == selected_vals[index]){
                    $(this).find("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
                }
            });
        });
    }
}


var employer_profile = {
    overview_sumit_form: function(){
        $(".profile_overview_content").hide();
        $(".profile_work_role_env_content").show();
    },

    work_env_role_modify: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/position_profile/workenv',
            data: "jid=" + job_id + "&modify=" + 1,
            cache: false,
            success: function() {
                hideBlockShadow();
            }
        });

    },

    credential_open: function(){
        $(".profile_overview_content").hide();
        $(".profile_work_role_env_content").hide();
        $(".profile_credentials_content").show();

        $('#profile_credentials_tab span.tab_overview').addClass('expand');
        $("#profile_credentials_tab").addClass('tab_deactive');
        $('#profile_work_env_role_tab span.tab_overview').removeClass('expand');

    }

}


var pos_profile_role_ques = {
    final_arr: [],
    check_role_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/employer_v2/btn-radio-small-inactive.png");
        });
        $(e).children("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
    },
    save: function(){
        this.final_arr = [];
        var err_flag = false;
        $(".env-ques-color-err").removeClass("env-ques-color-err");
        $(".role-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;
            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("filled_workenv_img") > -1){
                    pos_profile_role_ques.final_arr.push($(img_arr[j]).parent().attr("data-val"));
                    local_err = false;
                    break;
                }
            }
            if (local_err == true){
                err_flag = true;
                $(this).addClass("env-ques-color-err");
            }
        });

        if (err_flag == true){
            msg_box.show_error("[{msg: 'You must answer all of the questions.'}]");
            return false;
        }
        else{
            this.submit_form();
        }
    },
    submit_form: function(){
        $("#slider_values_role").val(this.final_arr.join(","));
        $("#question_loader_role").show();
        $('#new_work_role_env_form').submit();
    },
    onload: function(){

        var selected_vals = $("#slider_values").val().split(",");
        $(".role-radio-slider").each(function(index){
            $(this).find("a").each(function(){
                if($(this).attr("data-val") == selected_vals[index]){
                    $(this).find("img").attr("src","/assets/employer_v2/btn-radio-small-active.png");
                }
            });
        });
    }
}
function footerOnOpeningPopup()
{
    $('.lblftrclr').css('color','#fff');
}
function footerOnClosingPopup()
{
    $('.lblftrclr').css('color','#000066');
}

function showHelpPopup(){
    $('#beta_help_access').show();
    showNormalShadow();
    centralizePopup();
    $("html, body").animate({
        scrollTop: 0
    }, "slow");
    footerOnOpeningPopup();
}
function showHelpPopup2(){
    $('#beta_help_access_2').show();
    showNormalShadow();
    centralizePopup();
    $("html, body").animate({
        scrollTop: 0
    }, "slow");
    footerOnOpeningPopup();
}
function checkLastModified(obj){
    $(".discription ul li.last-change-active").each(function(){
        $(this).removeClass("last-change-active");
    })
    var current_line = $(obj).parent().parent().parent().attr("id");
    $("#work_modify").val(current_line);
}

/*------------------------Career Seeker Id Validation in X-ref Input box-----------------------------------*/
function checkXrefCSID()
{
    var csId = $("#career_seeker_name").val();
    var subFirstStr = csId.substring(0, 2);
    var subNextStr = csId.substring(2, csId.length);
    var flag=true;
    if(subFirstStr.toLowerCase() != "cs" )
        flag = false;
    else
    {
        if( !isNaN(subNextStr)){
            flag = true;
        }
        else{
            flag= false;
        }
    }
    return flag;
}

function enterXrefBox()
{
    var career_seeker_name = document.getElementById("career_seeker_name");
    if(!validateNotEmpty(career_seeker_name)){
        $("#"+career_seeker_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+career_seeker_name.id).parent().addClass("input-text-error-empty");
        $("#"+career_seeker_name.id).blur();
        return false;
    }
    
    if (checkXrefCSID()==true)
        xref_box.reload_xref_box();
    else if(checkXrefCSID()==false)
        xref_box.failure_show();
}

function editorEvents(elmnt, evt){
    var keyCode = evt.keyCode ? evt.keyCode : evt.charCode;
    var keyCodeChar = String.fromCharCode(keyCode).toLowerCase();
                
    if (evt.type=='keydown' && evt.ctrlKey)
    {
        type_element(elmnt, evt);
        evt.returnValue = false;
                    
    }
    return true;
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
		
		
}
function write_time2(set_year,set_month,set_day,set_hour,set_min,set_sec) {
		
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
    document.getElementById("days_2").innerHTML = String(days);
    document.getElementById("hours_2").innerHTML = String(hours);
    document.getElementById("minutes_2").innerHTML = String(minutes);
    document.getElementById("seconds_2").innerHTML = String(sec);
		
		
}


function showActivateJobPopup() {
    var preview_class = $("#preview span").attr('class');
    if(preview_class=="completed") {
	
    }
    else {
        bindChannelManagerOnComplete();
        footerOnOpeningPopup();
        // Change Status from Incomplete to complete
        $("#preview span").attr('class','completed');
        $("#preview span").html('Completed');
	
        // Open popup for job activation
        $("#job_activation_popup").show();
        addFocusButton('acivate-job');
        $("#acivate-job").click(function() {
            navigateUrl('/postings/index/'+$("#jid").val()+'/?selected='+$('#parent_id').val());
        });
        showSuccessShadow();
        centralizePopup();
        // Close preview tab
        $(".preview-tab").find('div.accordion-content').slideUp();
        $(".preview-tab").addClass('closed').removeClass('open');
        $(".preview-tab").find('a').addClass('close').removeClass('open');
    }
}

function hideActivateJobPopup() {
    hideSuccessShadow();
    $("#job_activation_popup").hide();
}

function stopWelcomePlayerEmp(frame_id, func, args){
    /*func: playVideo, pauseVideo, stopVideo, ... Full list at:
     * http://code.google.com/apis/youtube/js_api_reference.html#Overview */
    if(!document.getElementById(frame_id)) return;
    args = args || [];
    /*Searches the document for the IFRAME with id=frame_id*/
    playerId = $('#'+frame_id).children().attr('id');
    playerName = $('#'+frame_id).children().attr('name');
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

// See 950
function validateEmpNewOnInactiveButtonClick() {
    var firstName = document.getElementById('first_name');
    var lastName = document.getElementById('last_name');
    var email = document.getElementById('email');
    var password = document.getElementById('password');
    var rePassword = document.getElementById('confirm_password');
    var tc = document.getElementById('privacyText').checked;
    var errorBox = document.getElementById('error_msg');
    
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
    if(!tc){
        $("#privacyText").prev().css("background-position","0px -100px")
    }
		
    errorBox.innerHTML="Please complete the areas highlighted in red.";
    
}
function validateEmpNewOnInactiveButtonClickSnR() {
    var firstName = document.getElementById('first_name');
    var lastName = document.getElementById('last_name');
    var email = document.getElementById('email');
    var password = document.getElementById('password');
    var rePassword = document.getElementById('confirm_password');
    var tc = document.getElementById('privacyText').checked;
    var errorBox = document.getElementById('error_msg');

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
    else if(!validatePassword(password.value) || password.value!=rePassword.value) {
        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+password.id).parent().addClass("input-text-error");
    }
    
    if(!validateNotEmpty(rePassword)) {
        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+rePassword.id).parent().addClass("input-text-error-empty");
    }
    errorBox.innerHTML="Please complete the areas highlighted in red.";
}

function validateEmpOnInactiveButtonClick() {
    var company_name = document.getElementById('company_name');
    var company_address = document.getElementById('company_suite');
    var zip_code = document.getElementById('zip_code');
    var area_code = document.getElementById('area_code');
    var telephone_number = document.getElementById('telephone_number');
    var website = document.getElementById('website');
    var city = document.getElementById('city');
    var state = document.getElementById('state');
    var country = document.getElementById('country');
    var dropdown_check_flag = document.getElementById('dropdown_check_flag').value;
    var error_element = document.getElementById('error_element');
    
    if(!validateNotEmpty(company_name)) {
        $("#"+company_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+company_name.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(company_address)) {
        $("#"+company_address.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+company_address.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(city)) {
        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+city.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(state)) {
        $("#"+state.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+state.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(country)) {
        $("#"+country.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+country.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(zip_code)) {
        $("#"+zip_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+zip_code.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(area_code)) {
        $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+area_code.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(telephone_number)) {
        $("#"+telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+telephone_number.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
    
    if(!validateNotEmpty(website)) {
        $("#"+website.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+website.id).parent().addClass("input-text-error-empty");
        $("#error_msg").html("Please complete the areas highlighted in red.");
    }
}

function unbindKeydown(){
    $(document).unbind('keydown');
}

function showActivePositions() {
    if(document.getElementById("fade_normal_status_notification")) {
        footerOnOpeningPopup();
        $('#fade_normal_status_notification').show();
        $("#catageory_position_popup").slideDown();
        $("#green_middle").show();
        $("#red_middle").hide();
        $("#yellow_middle").hide();
        $(".catageory_position-tooltip_leftarrow img").css('margin-top',$(".group-row-cnt.green").offset().top-88);
        $(".catageory_position-tooltip").css('left','256px');
        $(".catageory_position-tooltip").css('top',$(".tab-content-area-left").offset().top-20);
        $(".catageory_position_middle").height($("#tab-content").height()-65);
        $("#green_middle .notifications-emp").height($("#tab-content").height()-105);
        $(".green-square-status").find('a').text($("#count_green").text());
    }
}
function showInternalPositions() {
    if(document.getElementById("fade_normal_status_notification")) {
        footerOnOpeningPopup();
        $('#fade_normal_status_notification').show();
        $("#catageory_position_popup").slideDown();
        $("#red_middle").hide();
        $("#green_middle").hide();
        $("#yellow_middle").show();
        $(".catageory_position-tooltip_leftarrow img").css('margin-top',$(".group-row-cnt.yellow").offset().top-88);
        $(".catageory_position-tooltip").css('left','256px');
        $(".catageory_position-tooltip").css('top',$(".tab-content-area-left").offset().top-20);
        $(".catageory_position_middle").height($("#tab-content").height()-65);
        $("#red_middle .notifications-emp").height($("#tab-content").height()-105);
        $(".yellow-square-status").find('a').text($("#count_yellow").text());
    }
}

function showInactivePositions() {
    if(document.getElementById("fade_normal_status_notification")) {
        footerOnOpeningPopup();
        $('#fade_normal_status_notification').show();
        $("#catageory_position_popup").slideDown();
        $("#red_middle").show();
        $("#green_middle").hide();
        $("#yellow_middle").hide();
        $(".catageory_position-tooltip_leftarrow img").css('margin-top',$(".group-row-cnt.red").offset().top-88);
        $(".catageory_position-tooltip").css('left','256px');
        $(".catageory_position-tooltip").css('top',$(".tab-content-area-left").offset().top-20);
        $(".catageory_position_middle").height($("#tab-content").height()-65);
        $("#red_middle .notifications-emp").height($("#tab-content").height()-105);
        $(".red-square-status").find('a').text($("#count_red").text());
    }
}

var attachmentTitleArray = new Array();

function submitAttachment(){
    $(".attachment_title").each(function(){
        attachmentTitleArray.push($(this).val());
    });
    showBlockShadow();
    $('#job_attachment_form').attr('target', 'upload_frame'); 
    document.forms["job_attachment_form"].submit();
    $("a#add-attachment").hide();
    $("div#uploading-attachment").show();
    $('#job_attachment_form').removeAttr("target");
}

function submitCsv(){
    $('#add_csv').attr('target', 'upload_frame_csv');
    //document.forms["add_csv"].submit();
    $("#add_csv").submit();
    $('#add_csv').removeAttr("target");
//hideIEPopupCSV();
}

function assignJobID(id){
    $("#jobid").val(id);
    $("#job_id").val(id);
}

function toggleAttachmentFlag(){

    if($(".attachment-cls").children().length > 0){
        $("#attachmentpresent").val("true");
    }
    else{
        $("#attachmentpresent").val("false");
    }
    /*
    if($("#attachmentpresent").val()=="true"){
        $("#attachmentpresent").val("false");
    }
    else{
        $("#attachmentpresent").val("true");
    }
    */
}

function uploadFailure(){
    $('#attachment-error').show();
    centralizePopup();
    $('#fade_error').show();
    if(document.getElementById("job_attachment_form")) {
        document.getElementById("job_attachment_form").reset();
    }
    BrowserDetect.init();
    if (BrowserDetect.browser == "Safari"){
        $("#job_attachment_attachment").remove();
        $("#job_attachment_form").append('<input id="job_attachment_attachment" type="file" onchange="submitAttachment();" name="job_attachment[attachment]">');
    }
}

function hideIEPopupAttachment(){
    $("#file_upload_ie").empty();
    $("#file_upload_ie").hide();
    $("#fade_normal").hide();
    footerOnClosingPopup();
}

function hideIEPopupCSV(){
    $("#csv_upload_ie").empty();
    $("#csv_upload_ie").hide();
    $("#fade_normal").hide();
    footerOnClosingPopup();
}

function delete_attachment(job_attachment_id){
    //var id = $("#jobid").val();
    var id = job_attachment_id;
    $.ajax({
        url: '/position_profile/delete_attachment',
        cache: 'false',
        data: 'id='+id,
        success: function(res){
            $("#attachment-content").html(res);
            toggleAttachmentFlag();
            validatePositionPreview();
            $(".attachment-block-btn").css("margin-top","0px");
        }
    });
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

function checkKeyupForEnter_PurchasePayment(e){
    var code = e.keyCode;
    if(code == 13){
        if(validateEmptyPayment()){

            $("#paypal_error_msg").show();
            $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
            var payment_card_type = document.getElementById('payment_card_type');
            if (payment_card_type.value == ''){
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please select one payment option.");
            }
        }
        else{
            $("#purchase-profile-form").submit();
        }
    }
}

function checkEnterForForm(e, buttonID, formID, classname){
    var code = e.keyCode;
    if(code == 13){
        if ($("#"+buttonID).hasClass(classname)){
            var email = $("#"+formID+" .email").val();
            var password = $("#"+formID+" .password").val();
            flag = 1;
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

function increaseButtonHeight(){
    $(".attachment-block-btn").css("margin-top", "36px");
}

function active_tab_1to3(div_id) {
    $("#"+div_id+" span").removeClass("incompleted");
    $("#"+div_id+" span").addClass("completed");
    $("#"+div_id+" span").text("Completed");
}
function deactive_tab_1to3(div_id) {
    $("#"+div_id+" span").addClass("incompleted");
    $("#"+div_id+" span").removeClass("completed");
    $("#"+div_id+" span").text("Incomplete");
}
function active_tab_4() {
    $("#preview a").css('color','#000078');
    $("#preview a").addClass('clickable');
}
function deactive_tab_4() {
    $("#preview a").css('color','#6666AE');
    $("#preview a").removeClass('clickable');
    $("#preview span").addClass("incompleted");
    $("#preview span").removeClass("completed");
    $("#preview span").text("Incomplete");
}
function complete_tab_4() {
    $("#preview a").css('color','#000078');
    $("#preview a").addClass('clickable');
    $("#preview span").addClass("completed");
    $("#preview span").removeClass("incompleted");
    $("#preview span").text("Complete");
}

function areYouSure(whatWasClicked) {
    if($("#tab-1_hasThisFormBeenEdited").val()==1 ||  $("#tab-2_hasThisFormBeenEdited").val()==1 ||  $("#tab-1_hasThisFormBeenEdited").val()==1) {
        var whatIsToBeSaved;
        $(".accordan").children('li').each(function(){
            if($(this).hasClass("open")) {
                whatIsToBeSaved = $(this).find('.accordion-heading').attr('id');
            }
        });
        $("#whatWasClicked").val(whatWasClicked);
        showAreYouSurePopup();
        if(whatIsToBeSaved=="overview") {
            $("#save-button-failsafe").unbind().click(function(){
                $("#new_employer_job_submit").click();
                hideAreYouSurePopup();
            });
            $("#continue-button-failsafe").unbind().click(function(){
                openWhatWasClicked(whatWasClicked);
            });
        }
        
        if(whatIsToBeSaved=="work-env") {
            $("#save-button-failsafe").unbind().click(function(){
                $("#work_role_env_questions").click();
                hideAreYouSurePopup();
                openWhatWasClicked(whatWasClicked);
            });
            $("#continue-button-failsafe").unbind().click(function(){
                openWhatWasClicked(whatWasClicked);
            });
        }

        if(whatIsToBeSaved=="credentials") {
            $("#save-button-failsafe").unbind().click(function(){
                $("#credential-submit").click();
                hideAreYouSurePopup();
            });
            $("#continue-button-failsafe").unbind().click(function(){
                openWhatWasClicked(whatWasClicked);
            });
        }

        if(whatIsToBeSaved=="preview") {
            $("#save-button-failsafe").unbind().click(function(){
                hideAreYouSurePopup();
                openWhatWasClicked(whatWasClicked);
            });
            $("#continue-button-failsafe").unbind().click(function(){
                openWhatWasClicked(whatWasClicked);
            });
        }
        $("#save-popup #save-close").unbind().click(function(){
            $("#save-popup").hide();
            $("#fade_error").hide();
        });
        $(document).bind("keypress", function (e) {
            if (e.keyCode == 27) {
                if($("#save-popup").is(':visible')) {
                    $("#save-popup").hide();
                    $("#fade_error").hide();
                }
            }
        });

        $(window).keydown(function(e) {
            if (e.keyCode == 27) {
                if($("#save-popup").is(':visible')) {
                    $("#save-popup").hide();
                    $("#fade_error").hide();
                }
            }
        });
        return false;
    } else {
        return true;
    }
}

function openWhatWasClicked(whatWasClicked) {
    $("#save-popup").hide();
    $("#fade_error").hide();
    $("#tab-1_hasThisFormBeenEdited").val(0);
    $("#tab-2_hasThisFormBeenEdited").val(0);
    $("#tab-1_hasThisFormBeenEdited").val(0);
    $("#whatWasClicked").val("");
    
    if(whatWasClicked=="tab-1") {
        $("#overview").click();
    }
    if(whatWasClicked=="emp-select"){
        $("#outer_pos").click();
    }
    if(whatWasClicked=="tab-2") {
        $("#work-env").click();
    }
    if(whatWasClicked=="tab-3") {
        $("#credentials").click();
    }
    if(whatWasClicked=="tab-4") {
        $("#preview").click();
    }
    if(whatWasClicked=="home-logo") {
        window.location.href='/employer_account';
    }
    if(whatWasClicked=="signup") {
        show_employer_account_box();
    }
    if(whatWasClicked=="candidate-tab") {
        navigateUrl('/position_profile/candidate_pool/'+$("#jid").val());
    }
    if(whatWasClicked=="position-tab") {
        navigateUrl('/position_profile/new_employer_profile/'+$("#jid").val());
    }
    if(whatWasClicked=="channel-tab") {
        navigateUrl('/postings/index/'+$("#jid").val());
    }
    if(whatWasClicked=="position-profile-lm") {
        navigateUrl('/position_profile/new_employer_profile/'+$("#clicked-job-for-are-you-sure").val());
    }
    if(whatWasClicked=="add-position-to") {
        navigateUrl('/position_profile/new_employer_profile?cat_id='+$("#clicked-job-for-are-you-sure").val()+'&selected=0');
    }
    if(whatWasClicked=="candidate-pool-lm") {
        navigateUrl('/position_profile/candidate_pool/'+$("#clicked-job-for-are-you-sure").val()+'?selected='+$('#parent_id').val());
    }
    if(whatWasClicked=="xref-link") {
        $("#career-seeker-ID").click();
    }
    if(whatWasClicked=="add-position") {
        loadCategories();
    }


}

function showAreYouSurePopup() {
    $("#save-popup").show();
    showErrorShadow();
    footerOnOpeningPopup();
    addFocusButton('save-button-failsafe');
}
function hideAreYouSurePopup() {
    $("#save-popup").hide();
    hideErrorShadow();
    footerOnClosingPopup();
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

function validateTel(){
    var billing_telephone_number = document.getElementById("billing_telephone_number");
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

function validateZip(){
    var billing_zip = document.getElementById("billing_zip");
    if(billing_zip.value.length>2) {
        $("#"+billing_zip.id).parent().removeClass("input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-active");
    }

}

function disableValidateDegree(){
    $("#validate-degree").val("0");
}

function disableValidateCertificate(){
    $('#validate-certificate').val('0');
}

function disableValidateCollege(){
    $('#validate-college').val('0');
}

var uni_autocomplete = {

    create: function(){
        var options = {
            serviceUrl:'/ajax/get_universities' ,
            width:370,
            maxHeight:100
        };

        certificate_autocomplete = $('#add_uni_text').autocomplete(options,"college_click_autocomplete()","college-university-list");
    }
}

var degree_autocomplete = {
    create: function(){
        var options = {
            serviceUrl:'/ajax/get_degrees' ,
            width:370,
            maxHeight:100
        };

        certificate_autocomplete = $('#add_deg_text').autocomplete(options,"degree_click_autocomplete()","degree-list");
    }
}

function collegeTypeEnter(key){
    if(key.keyCode == 13){
        text_in_college_box = true;
        $('#add_uni_text').val($('#college-inner-text').val());
        $('.college-university-list').css('display','none');
        $('.collegeUniversity-autoComplete-txt').hide();
        $('.collegeUniversity-autoComplete-txt').html("Other (enter your own)");
        $('#college-textbox').val('0');
        $("#validate-college").val('1');
        $("#tab-1_hasThisFormBeenEdited").val('1');
        $('#add_uni_text').parent().removeClass('input-text-active').addClass('active-input');

    }

}

function certificateTypeEnter(key){
    if(key.keyCode == 13){
        text_in_cert_box = true;
        $('#add_cert_text').val($('#certificate-inner-text').val());
        $('.cert-list').css('display','none');
        $('.collegeUniversity-autoComplete-txt').hide();
        $('.collegeUniversity-autoComplete-txt').html("Other (enter your own)");
        $('#certificate-textbox').val('0');
        $("#validate-certificate").val('1');
        $("#tab-1_hasThisFormBeenEdited").val('1');
        $('#add_cert_text').parent().removeClass('input-text-active').addClass('active-input');

    }
}

function changeToTextBoxCollege(e){
    var val = $('#college-inner-text').val();
    if(!val){
        val = "";
    }
    $('#college-textbox').val('1');
    $('#add_uni_text').parent().removeClass('active-input').addClass('input-text-active');
    $('#college-univ-textbox').html("<input type='text' id='college-inner-text' onkeyup='collegeTypeEnter(event);' value='"+val+"'/>");
    $('#college-inner-text').focus();
    BrowserDetect.init();
    if (BrowserDetect.browser != "Explorer"){
        e.stopPropagation();
    }
    else{
        window.event.cancelBubble = true;
    }

}

function changeToTextBoxCertificate(e){
    var val = $('#certificate-inner-text').val();
    if(!val){
        val = "";
    }
    $('#certificate-textbox').val('1');
    $('#add_cert_text').parent().removeClass('active-input').addClass('input-text-active');
    $('#cert-dd-textbox').html("<input type='text' id='certificate-inner-text' onkeyup='certificateTypeEnter(event);' value='"+val+"'/>");
    $('#certificate-inner-text').focus();
    BrowserDetect.init();
    if (BrowserDetect.browser != "Explorer"){
        e.stopPropagation();
    }
    else{
        window.event.cancelBubble = true;
    }
}

function college_click_autocomplete(){
    text_in_college_box = true;
    $('#college-textbox').val('0');
    $("#validate-college").val('1');
    $('.collegeUniversity-autoComplete-txt').hide();
    $('#add_uni_text').parent().removeClass('input-text-active').addClass('active-input');
    $("#tab-1_hasThisFormBeenEdited").val('1');
        

}

function certificate_click_autocomplete(){
    text_in_cert_box = true;
    $('#certificate-textbox').val('0');
    $("#validate-certificate").val('1');
    $('.collegeUniversity-autoComplete-txt').hide();
    $('#add_cert_text').parent().removeClass('input-text-active').addClass('active-input');
    $("#tab-1_hasThisFormBeenEdited").val('1');
        


}

function degree_click_autocomplete(){
    $("#validate-degree").val('1');
    $("#tab-1_hasThisFormBeenEdited").val('1');
    $('#add_deg_text').parent().removeClass('input-text-active').addClass('active-input');
}
var text_in_college_box = false;
var college_emp = {
    list_arr: [],
    initialize: function(college_values){
        if(college_values != ""){
            this.list_arr = unescape_str_new(college_values).split("_ecolg_");
            $("#validate-college").val("1");
        }
        this.create_elements();

    },
    show: function(){
    },
    hide: function(){
    },
    add_to_list: function(value){
        if(!this.list_arr.has(value) && unescape_str_new(value) != jQuery.trim($("#add_uni_text_placeholder").val()))
        {
            this.list_arr.push(unescape_str_new(value));
            if($("#editing").val() != "") {
                $("#editing").val("");
            }
        }
    },
    add_another: function(value){
        if(validateRequired($("#add_uni_text").val())) {
            if($("#validate-college").val()=="1"){
                if(!this.list_arr.has(value) && unescape_str_new(value) != jQuery.trim($("#add_uni_text_placeholder").val()) && value.trim()!="")
                {
                    this.list_arr.push(unescape_str_new(value));
                    if($("#editing").val() != "") {
                        $("#editing").val("");
                    }

                }
                this.list_arr.clean("");
                this.create_elements();
                text_in_college_box = false;
            }
        } else {
            $("#add_uni_text").val('');
            $("#add_uni_text").blur();
        }
    },
    create_elements: function(edit, delete_row){
        if(edit != "edit"){
            if(delete_row != "delete"){
                $("#add_uni_text").val("Begin typing to access database.");
                $("#add_uni_text").parent().removeClass("active-input input-text input-text-active");
                $("#add_uni_text").parent().addClass("input-text");
            }
        }
        var str = "";
        if($("#validate-college").val()=="1"){
            $("div#collegeAndUniversities-Div").html("");
            for(var i=0; i<this.list_arr.length; i++){
                str += "<div class='inner_collegeAndUniversities_div'><div class='top-curve'>&nbsp;</div><div class='cont'><label id='123' onclick='college_emp.edit_row("+i+")' class='label-accessDatabase'>"+unescape_str_new(this.list_arr[i])+"</label><a class='remove' onclick='college_emp.remove_row("+i+");hideCollegeInnerTextBox();' title='remove' href='javascript:void(0);'><img width='20' height='20' src='/assets/employer_v2/remove-skill.png' alt='Remove Skill' /></a></div><div class='bottom-curve'>&nbsp;</div></div>";
            }
            $("div#collegeAndUniversities-Div").append(str);
            $("#collegeAndUniversities-Div").show();
            if(delete_row == "delete" && text_in_college_box == false){
                $("#add_uni_text").val("");
                $("#add_uni_text").blur();
            }
            if(edit != "edit"){
                if(delete_row != "delete"){
                    $('#add_uni_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
                    $('#add_uni_text').val($('#add_uni_text_placeholder').val());
                }
            }
        }
    },
    edit_row: function(val){

        this.add_another($('#add_uni_text').val());
        for (var i = 0; i < this.list_arr.length; i++){
            if (val == i)
            {
                $("#add_uni_text").val(this.list_arr[i]);
                $("#validate-college").val('1');
                $("#add_uni_text").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#add_uni_text").parent().addClass('active-input');
            }
        }
        this.remove_row(val,"edit");
    },
    remove_row: function(val,edit){
        var new_arr = [];
        for(var i=0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        $("#validate-college").val("1");
        this.create_elements(edit, "delete");
        $("#tab-1_hasThisFormBeenEdited").val(1);
    }

}

var degree_emp = {
    initialize: function(degree_value, degree_flag){
        //console.log(degree_value);
        //console.log(degree_flag);

        if(degree_value!=""){
            $('#add_deg_text').val(degree_value);
            $("#add_deg_text").parent().removeClass("active-input input-text input-text-active");
            $("#add_deg_text").parent().addClass("active-input");

            if(degree_flag=="0"){
                $("#degree-flag").val("0");
                $("#degree_required_flag_2").attr("checked","");
                $("#degree_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                $("#degree_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                $("#degree_required_flag_1").attr("checked","checked");
            }
            else{
                $("#degree-flag").val("1");
                $("#degree_required_flag_1").attr("checked","");
                $("#degree_required_flag_1").html('<img src="/assets/employer_v2/btn-radio-inactive.png"/>');
                $("#degree_required_flag_2").html('<img src="/assets/employer_v2/btn-radio-active.png"/>');
                $("#degree_required_flag_2").attr("checked","checked");
            }

            $("#validate-degree").val("1");
        }
    }
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

function resetSelectRolesPopup(open_flag) {
    $("div#or_browser_button").css("cursor","default");
    $(".role-search-count").hide();
    $(".role-search-filter").hide();
    $(".role-search-filter").removeClass('open').addClass('close');
    $(".role-filter-content").hide();
    $("#roles_list .explore_select_heading").css('height','38px');
    $("#career_desiredrole_middle3").css('height','379px');
    
    $("#role_reset_button").hide();
    $("ul#careerPath").hide();
    $("ul#roleDescription").hide();
    $("div#desiredRoleDescription").hide();
    $("#search_shadow_path").hide();
    $("#search_shadow_cluster").hide();
    $("div#duplicateRoleErrorMsg").hide();
    $("#careerPathRole").hide();
    $("#exploreRolDescription").hide();
    $('.career_desiredrole_left').css('display', 'none');
    $('.career_path_left').css('display', 'none');
    $("ul#career_clusters").hide();
    $(".career_cluster_middle .explore_select_heading").addClass('init');
    $(".career_cluster_middle").addClass('init');
    $("#search_roles").val('');
    $("#searchRoleClicked").val(0);
    $.ajax({
        url: '/pairing_profile/open_role_explorer',
        data: "career_cluster=",
        cache: false,
        success: function(data) {
            hideBlockShadow();
            $("ul#career_clusters").show();
            //$("div#credentials_exploreSelectDesiredRole").css('display', 'block');
            $("ul#career_clusters").html(data);
            $("div#duplicateRoleErrorMsg").hide();
            $(".career_cluster_middle ul li").unbind().click(function(){
                $(".highlightCls").removeClass("highlightCls");
                $(this).addClass("highlightCls");
                return false;
            });
            $("div#credentials_exploreSelectDesiredRole").slideDown();
            var _topoffset_init = $('#career_clusters li:first').offset().top - parseInt($(window).scrollTop());
            ;
            $(".career_path_left").css("top",_topoffset_init-5+"px");
            $("ul#career_clusters").hide();
            $(".career_cluster_middle .explore_select_heading").addClass('init');
            $(".career_cluster_middle").addClass('init');
            $("#search_roles").focus();
            $(".career_cluster_middle .explore_select_heading").click(function(){
                $("ul#career_clusters").show();
                $(".career_cluster_middle .explore_select_heading").removeClass('init');
                $(".career_cluster_middle").removeClass('init');
                $(".career_cluster_middle .explore_select_heading").unbind();
            })
            if(open_flag) {
                $(".career_cluster_middle .explore_select_heading").click();
            }

            $('#fade_normal_dark').unbind();
            $(document).unbind('keypress');
            $(window).unbind('keydown');
        }
    });
}

function showSelectRolesPopup(add_role, current_item) {
    $("div#or_browser_button").css("cursor","default");
    $(".role-search-count").hide();
    $(".role-search-filter").hide();
    $(".role-search-filter").removeClass('open').addClass('close');
    $(".role-filter-content").hide();
    $("#roles_list .explore_select_heading").css('height','38px');
    $("#career_desiredrole_middle3").css('height','379px');
    
    footerOnOpeningPopup();
    $("#fade_normal_dark").show();
    $("#add_role1").blur();
    $("#add_role2").blur();
    $("#add_role3").blur();
    $('#role_reset_button').hide();
    showBlockShadow();
    var clickedRoleField;
    var flag = false;
    if(add_role=="add_role1") {
        $("input#populate_role_field").val(1);
        clickedRoleField = $("input#add_role1_placeholder").val();
        if($("input#add_role1").val()=="Role 1 (click to access)") {
            hideCareerPathAndDesiredRole(current_item);
            flag = true;
        }
    }
    else if(add_role=="add_role2") {
        $("input#populate_role_field").val(2);
        clickedRoleField = $("input#add_role2_placeholder").val();
        if($("input#add_role2").val()=="Role 2 (optional, click to access)") {
            hideCareerPathAndDesiredRole(current_item);
            flag = true;
        }
    } else if(add_role=="add_role3") {
        $("input#populate_role_field").val(3);
        clickedRoleField = $("input#add_role3_placeholder").val();
        if($("input#add_role3").val()=="Role 3 (optional, click to access)") {
            hideCareerPathAndDesiredRole(current_item);
            flag = true;
        }
    }
    $.ajax({
        url: '/pairing_profile/open_role_explorer',
        data: "career_cluster=" + clickedRoleField,
        cache: false,
        success: function(data) {
            hideBlockShadow();
            $("ul#career_clusters").show();
            //$("div#credentials_exploreSelectDesiredRole").css('display', 'block');
            $("ul#career_clusters").html(data);
            $("div#duplicateRoleErrorMsg").hide();
            $(".career_cluster_middle ul li").unbind().click(function(){
                $(".highlightCls").removeClass("highlightCls");
                $(this).addClass("highlightCls");
                return false;
            });
            $("div#credentials_exploreSelectDesiredRole").slideDown();
            var _topoffset_init = $('#career_clusters li:first').offset().top - parseInt($(window).scrollTop());
            ;
            $(".career_path_left").css("top",_topoffset_init-5+"px");
            if(flag) {
                $("ul#career_clusters").hide();
                $(".career_cluster_middle .explore_select_heading").addClass('init');
                $(".career_cluster_middle").addClass('init');
                $("#search_roles").focus();
                $(".career_cluster_middle .explore_select_heading").click(function(){
                    $("ul#career_clusters").show();
                    $(".career_cluster_middle .explore_select_heading").removeClass('init');
                    $(".career_cluster_middle").removeClass('init');
                    $(".career_cluster_middle .explore_select_heading").unbind();
                })
            }
            else {
                $(".career_cluster_middle .explore_select_heading").removeClass('init');
                $(".career_cluster_middle").removeClass('init');
                $(".career_cluster_middle .explore_select_heading").unbind();
            }
        //End
        }
    });
}

function hideCareerPathAndDesiredRole(current_item) {
    $("ul#careerPath").hide();
    $("ul#roleDescription").hide();
    $("div#desiredRoleDescription").hide();
    $(current_item).addClass('input-text-active');
}

function getCareerPaths(career_cluster, optional_code) {
    $.ajax({
        url: '/pairing_profile/career_paths',
        data: "career_cluster=" + career_cluster + "&code=" + optional_code,
        cache: false,
        success: function(data) {
            if($("ul#careerPath").is(':visible')==false) {
                $("ul#careerPath").show();
            }
            $("ul#careerPath").html(data);
            $("div#desiredRoleDescription").hide();
            if(optional_code == undefined) {
                $("div#exploreRolDescription").hide();
            }
            $("ul#roleDescription").empty();
            $("ul#roleDescription").hide();
            $("div#duplicateRoleErrorMsg").hide();
            //Code for when user click on the already selected role
            var _leftoffset = $('.highlightCls').offset().left;
            var _topoffset = $('.highlightCls').offset().top - parseInt($(window).scrollTop());
            var heightCareerCluster = $('.career_cluster_middle').height();
            if($("ul#career_clusters li").hasClass("highlightCls")) {
                $(".career_path_left").css("left",_leftoffset+275+"px");
                $(".career_path_left_initial").css("display","none");
                $(".career_path_middle").css("height",heightCareerCluster+"px");
            }
            $('div.career_desiredrole_middle').css('height', 'auto');
            $('.career_desiredrole_left').css('display', 'none');
            $("div#careerPathRole").slideDown('slow');
            if($(".career_path_left").css('top')=="0px"){
                var _topoffset_init = $('#career_clusters li:first').offset().top - parseInt($(window).scrollTop());
                ;
                $(".career_path_left").css("top",_topoffset_init-5+"px");
            }
            $(".career_path_left").show();
            $(".career_path_left").animate({
                top:_topoffset-5+"px"
            },1000);
            var _topoffset_init_role = $('#careerPath li:first').offset().top - parseInt($(window).scrollTop());
            $(".career_desiredrole_left").css("top",_topoffset_init_role-5+"px");
            $(".career_path_middle .explore_select_heading").removeClass('init');
            $(".career_path_middle").removeClass('init');
        }
    });
}

function getDesiredRoles(career_cluster, pathway, ele2) {
    var _leftoffset = 0;
    var _topoffset = 0;
    $.ajax({
        url: '/pairing_profile/desired_roles',
        data: "career_cluster=" + career_cluster + "&pathway=" + pathway,
        cache: false,
        success: function(data) {
            $("ul#roleDescription").html(data);
            if($(".career_desiredrole_left").css('top')=="0px"){
                var _topoffset_init = $('#careerPath li:first').offset().top - parseInt($(window).scrollTop());
                ;
                $(".career_desiredrole_left").css("top",_topoffset_init-5+"px");
            }
            //$(".highlightCls_path").removeClass("highlightCls_path");
            if(ele2!="optional") {
                var pathParent = $("ul#careerPath");
                pathParent.children().each(function() {
                    $(this).removeClass('background_career_cluster highlightCls_path');
                });
                $(ele2).addClass("highlightCls_path");
                _leftoffset = $('.highlightCls_path').offset().left;
                _topoffset = $('.highlightCls_path').offset().top - parseInt($(window).scrollTop());
                $(".career_desiredrole_left").css("left",_leftoffset+242+"px");
            } else {
                $(".career_desiredrole_left_initial").css("display","block");
                $(".career_desiredrole_left").css("display","none");
                //Code for when user click on the already selected role
                if($("ul#careerPath li").hasClass("highlightCls_path")) {
                    _leftoffset = $('.highlightCls_path').offset().left;
                    _topoffset = $('.highlightCls_path').offset().top - parseInt($(window).scrollTop());
                    $(".career_desiredrole_left").css("left",_leftoffset+242+"px");
                }
            }
            $(".career_desiredrole_left_initial").css("display","none");
            //$(".career_desiredrole_left").css("display","block");
            var heightCareerPath = $('.career_path_middle').height()-45;
            $('.career_desiredrole_middle').css("height","379px");
            if($("div#desiredRoleDescription").is(':visible') == true) {
                $("div#desiredRoleDescription").hide();
            }
            if($("div#exploreRolDescription").is(':visible')==false) {
                $("div#exploreRolDescription").slideDown('slow');
            }
            if($("ul#roleDescription").is(':visible')==false) {
                $("ul#roleDescription").show();
            }
            $("div#duplicateRoleErrorMsg").hide();
            $("div#exploreRolDescription").slideDown('slow');
            $(".career_desiredrole_left").show();
            $(".career_desiredrole_left").animate({
                top:_topoffset-5+"px"
            },1000);
        }
    });
}

function rolesMoreInfo(code, ele1, optional) {
    $.ajax({
        url: '/pairing_profile/role_description',
        data: "career_code=" + code,
        cache: false,
        success: function(data) {
            $("div#exploreRolDescription").hide();
            $("div.role-search-count").hide();
            if($("div#desiredRoleDescription").is(':visible') == false) {
                $("div#desiredRoleDescription").show();
                $("div#desiredRoleDescription").html(data);

            }
            //Career Paths selection and arrow placement code
            var _secHeight = $(".headingTxt_roleDesc").height()+26;
            var _btnHeight = $(".headingTxtSmall_rightRoleDesc").height();
            var _btnPadding = (_secHeight - _btnHeight)/2;
            //$(".headingTxtSmall_rightRoleDesc").css('margin-top',_btnPadding);
            if(optional != "search") {
                if($(".highlightCls_path").offset()!=undefined) {
                    $(ele1).addClass("highlightCls_desiredrole");
                    var _leftoffset = $('.highlightCls_path').offset().left;
                    var _topoffset = $('.highlightCls_path').offset().top - parseInt($(window).scrollTop());
                    ;
                    $(".career_desiredrole_left").css("top",_topoffset-5+"px");
                    $(".career_desiredrole_left").css("left",_leftoffset+242+"px");
                }
                $(".highlightCls_desiredrole").removeClass("highlightCls_desiredrole");
                var heightCareerPath = $('.career_path_middle').height()-45;
                $(".career_desiredrole_left").css("display","block");
                $(".career_desiredrole_left_initial").css("display","none");
            }
            $("#career_desiredrole_middle2").css("height",(424-$(".headingTxt_roleDesc").parent().height())+"px");
        //End
        }
    });
}

function finalizeRole(code, title) {
    if($("input#add_role1_placeholder").val()==code || $("input#add_role2_placeholder").val()==code || $("input#add_role3_placeholder").val()==code) {
        $("div#duplicateRoleErrorMsg").show();
        $(function() {
            $(document).bind("keyup", function (e) {
                if (e.which == 27) {
                    $("div#desiredRoleDescription").hide();
                    $("div#exploreRolDescription").show();
                    $("div#duplicateRoleErrorMsg").hide();
                    if($("input#searchRoleClicked").val()=="1") {
                        $("div.role-search-count").show();
                    }
                }
            });
        });
    }
    else {
        $("#search_shadow_cluster").css("display","none");
        $("#search_shadow_path").css("display","none");
        $("#search_shadow_path_arrow").css("display","none");
        $("div#exploreRolDescription").css("display","block");

        if($("input#populate_role_field").val()==1) {
            $("input#add_role1").val(title);
            $("input#add_role1_placeholder").val(code);
            $("input#add_role1").addClass("text-active");
            $("div#removeRole1Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole1Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
        }
        if($("input#populate_role_field").val()==2) {
            $("input#add_role2").val(title);
            $("input#add_role2_placeholder").val(code);
            $("input#add_role2").addClass("text-active");
            $("div#removeRole2Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole2Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
        }
        if($("input#populate_role_field").val()==3) {
            $("input#add_role3").val(title);
            $("input#add_role3_placeholder").val(code);
            $("input#add_role3").addClass("text-active");
            $("div#removeRole3Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole3Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
        }
        $("#tab-1_hasThisFormBeenEdited").val("1");
        handleEmptyCase();
        hideNormalShadow();
        footerOnClosingPopup();
        $("#fade_normal_dark").hide();
        $('#fade_normal_dark').unbind();
        //$(document).unbind('keyup');
        if($("input#search_roles").val() != "") {
            clearSearchResults();
        }
    }
}

function cancelRoleSelection(){
    footerOnClosingPopup();
    handleEmptyCase();
    $("#fade_normal_dark").hide();

    if($("input#search_roles").val() != "") {
        clearSearchResults();
    }
    $("#search_shadow_cluster").css('display', 'none');
    $("#search_shadow_path").css('display', 'none');
    $("#search_shadow_path_arrow").css('display', 'none');
    $("#exploreRolDescription").css('display', 'block');
    
    $('#fade_normal_dark').unbind();
    $(document).unbind('keypress');
    $(window).unbind('keydown');
}

function handleEmptyCase() {
    $("input#populate_role_field").val("");
    $("#searchRoleClicked").val(0);
    $("div#desiredRoleDescription").empty();
    $("div#desiredRoleDescription").hide();
    $("ul#roleDescription").empty();
    $("ul#roleDescription").hide();
    $("ul#careerPath").empty();
    $("ul#careerPath").hide();
    $("div#duplicateRoleErrorMsg").hide();
    $('.career_path_left').css('display', 'none');
    $('.career_desiredrole_left').css('display', 'none');
    $('.career_path_middle').css('height', 'auto');
    $('div.career_desiredrole_middle').css('height', 'auto');
    $('div#credentials_exploreSelectDesiredRole').css('display', 'none');
    $(".career_desiredrole_left_initial").css('display', 'block');
    $(".career_path_left_initial").css('display', 'block');
    $('#fade_normal').unbind();
}

function clearSearchResults() {
    $("input#search_roles").val("");
    $("div#exploreRolDescription").show();
    $("ul#career_cluster").empty();
}

function autoSelectClusterAndPath(code) {
    $.ajax({
        url: '/pairing_profile/auto_select_cluster_and_path',
        data: "career_code=" + code,
        cache: false,
        success: function() {
        }
    });
}
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

function clearRole1Contents() {
    $("#tab-1_hasThisFormBeenEdited").val(1);
    if($("#add_role2_placeholder").val()=="Role 2 (optional, click to access)" && $("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
        if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
            $("#add_role1_placeholder").val($("#add_role3_placeholder").val());
            $("#add_role1").val($("#add_role3").val());
            $("#add_role1").addClass("text-active");

            $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
            $("#add_role3").val("Role 3 (optional, click to access)");
            $("#add_role3").removeClass("text-active");
        } else {
            $("#add_role1_placeholder").val("Role 1 (click to access)");
            $("#add_role1").val("Role 1 (click to access)");
            $("#add_role1").removeClass("text-active");
            $("input#selected_role_1").val(0);
        }
        $("div#removeRole3Contents").empty();
    } else {
        if($("#add_role2_placeholder").val()!="Role 2 (optional, click to access)") {
            $("#add_role1_placeholder").val($("#add_role2_placeholder").val());
            $("#add_role1").val($("#add_role2").val());
            $("#add_role1").addClass("text-active");

            $("#add_role2_placeholder").val("Role 2 (optional, click to access)");
            $("#add_role2").val("Role 2 (optional, click to access)");
            $("#add_role2").removeClass("text-active");
        }else {
            $("#add_role1_placeholder").val("Role 1 (click to access)");
            $("#add_role1").val("Role 1 (click to access)");
            $("#add_role1").removeClass("text-active");
        }

        if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
            update_role2_field();
        }
        if($("#add_role1_placeholder").val()=="Role 1 (click to access)") {
            $("div#removeRole1Contents").empty();
        }
        if($("#add_role2_placeholder").val()=="Role 2 (optional, click to access)") {
            $("div#removeRole2Contents").empty();
        }
        if($("#add_role3_placeholder").val()=="Role 3 (optional, click to access)") {
            $("div#removeRole3Contents").empty();
        }
    }
}

function clearRole2Contents() {
    $("#tab-1_hasThisFormBeenEdited").val(1);
    var hide_cross_Role2_image = '';
    if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
        update_role2_field();
        hide_cross_Role2_image = 1;
    }else  {
        $("#add_role2_placeholder").val("Role 2 (optional, click to access)");
        $("#add_role2").val("Role 2 (optional, click to access)");
        $("#add_role2").removeClass("text-active");
        hide_cross_Role2_image = 0;
    }
    if(hide_cross_Role2_image == 0) {
        $("div#removeRole2Contents").empty();
    }
    $("div#removeRole3Contents").empty();
}

function clearRole3Contents() {
    $("#tab-1_hasThisFormBeenEdited").val(1);
    $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
    $("#add_role3").val("Role 3 (optional, click to access)");
    $("#add_role3").removeClass("text-active");

    $("div#removeRole3Contents").empty();
}

function update_role2_field() {
    $("#add_role2_placeholder").val($("#add_role3_placeholder").val());
    $("#add_role2").val($("#add_role3").val());
    $("#add_role2").addClass("text-active");

    $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
    $("#add_role3").val("Role 3 (optional, click to access)");
    $("#add_role3").removeClass("text-active");
}

function update_role2_education_field(){
    $("div.educationLevelRole2 span.education-default").text($("div.educationLevelRole3 span.education-default").text());
    $("div.educationLevelRole2 span.education-default").addClass("text-active");

    $("div.educationLevelRole3 span.education-default").text("Education Level");
    $("div.educationLevelRole3 span.education-default").removeClass("text-active");
}

function update_role2_experience_field() {
    $("div.skillLevelRole2 span.skill-default").text($("div.skillLevelRole3 span.skill-default").text());
    $("div.skillLevelRole2 span.skill-default").addClass("text-active");

    $("div.skillLevelRole3 span.skill-default").text("Experience Level");
    $("div.skillLevelRole3 span.skill-default").removeClass("text-active");
}

function hideCollegeInnerTextBox(){
    $('.college-university-list').css('display','none');
    $('#college-univ-textbox').hide();
    $('#college-univ-textbox').html("Other (enter your own)");
    $('#college-textbox').val('0');
}

function hideCertificateInnerTextBox(){
    $('.cert-list').css('display','none');
    $('#cert-dd-textbox').hide();
    $('#cert-dd-textbox').html("Other (enter your own)");
    $('#certificate-textbox').val('0');

}
function openLoginBox() {
    $("#fade_normal_status").show();
    $("#sign-in-box").show();
    $('#login_form_submit').show();
    $('#forgot_pass').show();
    $("#fade_normal_status").click(function(){
        if(!$("#loader-img").is(':visible'))
            closeLoginBox();
    });
    $('#login_name').val('');
    $('#login_name').blur();
    $("#header .hil-info-link-section .info-links a").addClass('white');
    $('#login_name').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_name').parent().addClass('input-text');
    $('#login_pass').parent().removeClass('input-text input-text-active active-input input-text-error input-text-error-empty');
    $('#login_pass').parent().addClass('input-text');
    changeInputType(document.getElementById("login_pass"),"text","");
    $('#login_pass').val('Password');
    $('#login_form_submit').removeClass('enter-button-active');
    $('#login_form_submit').addClass('enter-button');
    $("#login_form_submit").unbind('click').bind('click', function(){
        inactiveSignInButton();
    });
    addFocusTextField('login_name');
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

var login_status = {
    before_call: function(){
        $('#login_form_submit').hide();
        $('#forgot_pass').hide();
        $('#loader-img').show();

    },
    after_complete: function(status){
        $('#loader-img').hide();
        if(status){
            window.location.reload();
        }
        else {
            hideLoginBox();
            showErrorLogin();
            addFocusButton('retry_button_signi_in');

        }
    },
    after_complete_signin: function(status){
        $('#loader-img').hide();
        if(status){
            window.location.reload();
        }
        else {
            $(".info-links").children().removeClass('white');
            $("#sign-in-box").hide();
            $("#fade_normal_status").hide();
            showErrorShadow();
            $("#login_error").show();
            addFocusButton('retry-button-active');
            $("#sign_in_close").unbind().bind('click', function(){
                hideErrorLogin_signin();
            });
            $("#retry_button_signi_in").unbind().bind('click', function(){
                setTimeout(function(){
                    $("#login_error").hide();
                    hideErrorShadow();
                    openLoginBox();
                },200);
            });
            centralizePopup();
            addFocusButton('retry_button_signi_in');
        }
    }
}

function closeLoginBox() {
    $("#fade_normal_status").hide();
    $("#header .hil-info-link-section .info-links a").removeClass('white');
    $("#sign-in-box").hide();
}
function openAccountTab() {
    $(".employer-acc-box").toggle();
    $('#fade_normal_status_signout').show();
    $('#fade_normal_status_signout').click(function(){
        clsoeAccountTab();
    });
    $.ajax({
        url:"/ajax/employer_account",
        type: "POST",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
        },
        success: function(data){
            $("#employer-acccount-box").html(data);
            $("#employer-acccount-box").show();
            hideBlockShadow();
            $(".alerts-type").children().each(function(){
                if ($(this).find('span.checkbox').next().val() == $("#alert_method_val").val()){
                    Custom.check($(this).find('span.checkbox'));
                }
            });
            $(".eeo_options").children().each(function(){
                if ($(this).find('span.checkbox').next().val() == $("#graphical_content_flag").val()){
                    Custom.check($(this).find('span.checkbox'));
                }
            });
            var index_val = $("#alert_threshhold_val").val();
            $("#slider").slider("value",(index_val));

            $(".alerts-type span.checkbox").unbind().click(function(){
                $(".alerts-type").children().each(function(){
                    if ($(this).find('span.checkbox').css("background-position")=="0px -50px"){
                        Custom.check($(this).find('span.checkbox'));
                    }
                });
                Custom.check($(this));
                $("#alert_method_val").val($(this).next().val());
                document.getElementById('alert_update_button').className = 'update-button-active rfloat';
            });

            $(".eeo_options span.checkbox").unbind().click(function(){
                $(".eeo_options").children().each(function(){
                    if ($(this).find('span.checkbox').css("background-position")=="0px -50px"){
                        Custom.check($(this).find('span.checkbox'));
                    }
                });
                Custom.check($(this));
                $("#graphical_content_flag").val($(this).next().val());
                document.getElementById('eeo_form_submit').className = 'update-button-active rfloat';
            });

            $(".alerts-type label.lbl").unbind().click(function(){
                $(".alerts-type").children().each(function(){
                    if ($(this).find('span.checkbox').css("background-position")=="0px -50px"){
                        Custom.check($(this).find('span.checkbox'));
                    }
                });
                Custom.check($(this).prev().prev());
                $("#alert_method_val").val($(this).prev().val());
                document.getElementById('alert_update_button').className = 'update-button-active rfloat';
            });

            $(".eeo_options label.lbl").unbind().click(function(){
                $(".eeo_options").children().each(function(){
                    if ($(this).find('span.checkbox').css("background-position")=="0px -50px"){
                        Custom.check($(this).find('span.checkbox'));
                    }
                });
                Custom.check($(this).prev().prev());
                $("#graphical_content_flag").val($(this).prev().val());
                document.getElementById('eeo_form_submit').className = 'update-button-active rfloat';
            });
        }
    });
}

function openUserAdminTab() {
    $(".employer-acc-box").hide();
    closeDropDownOfUsers();
    $('#fade_normal_status_signout').show();
    $('#fade_normal_status_signout').click(function(){
        closeUserAdminTab();
    });
    $.ajax({
        url:"/ajax/user_admin",
        type: "POST",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
            footerOnOpeningPopup();
        },
        success: function(data){
            $("#user-admin-box").html(data);
            $("#user-admin-box").show();
            hideBlockShadow();
            // This function is to be called whenever the values of the caluculations change
            reAjustWidthForCalculationBlock();
            
        }
    });
    
}
function openReassignTab() {
    $(".employer-acc-box").hide();
    closeDropDownOfUsers();
    $('#fade_normal_status_signout').show();
    $('#fade_normal_status_signout').click(function(){
        closeUserAdminTab();
    });
    $.ajax({
        url:"/ajax/user_admin",
        type: "POST",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
            footerOnOpeningPopup();
        },
        success: function(){
            $("#user-admin-box").show();
            openPositionAssignTab();
            $(".user-admin-box .account-middle-content").empty();
        }
    });
    
}

function closeUserAdminTab() {
    $('#fade_normal_status_signout').unbind();
    $('#fade_normal_status_signout').hide();
    $("#user-admin-box").empty();
    $("#user-admin-box").hide();
}
function clsoeAccountTab() {
    $('#fade_normal_status_signout').unbind();
    $('#fade_normal_status_signout').hide();
    $("#employer-acccount-box").hide();
}

jQuery(function($) {
    // create a convenient toggleLoading function
    var loading_login = function(){
        login_status.before_call();
    }

    $("#login_form")
    .bind("ajax:beforeSend", loading_login)

});

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
    addFocusTextField('email_id_email');
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

function validateForgotPassEmail(element){
    email = element.value;
    button = document.getElementById('submit_button');
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {

        button.className="enter-button-active";
        //$("#email_id_email").parent().removeClass("input-text-error").addClass("active-input");
        //button.disabled="";
        return true;
    }
    else {
        button.className="enter-button";
        //button.disabled="true";
        return false;
    }

}

// Processing of Forgot password code on the landing page
var forgot_password= {

    error_msg: function(){
        hideForgotPassword();
        showForgotPasswordError();
    },

    success_msg: function(){
        hideForgotPassword();
        showForgotPasswordSuccess();
    }

}

var reset_password=  {
    success_msg: function(){
        showForgotPasswordSuccessWindow();
        hideForgotPasswordResetWindow();
    },
    error_msg: function(){
        hideForgotPasswordResetWindow();
        showForgotPasswordResetError();
    }
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
    }
}

function showForgotPasswordSuccess() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_success_bridge").show();
        $("#forgot_password_success").show();
        centralizePopup();
        addFocusButton('forgot_password_success_button');
    }
    else {
        showSuccessShadow();
        $("#forgot_password_success").show();
        centralizePopup();
        addFocusButton('forgot_password_success_button');
    }

}

function showForgotPasswordError() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        $("#fade_error_warning").show();
        $("#forgot_password_error").show();
        centralizePopup();
        addFocusButton('forgot_password_error_button');
    }
    else {
        showErrorShadow();
        $("#forgot_password_error").show();
        centralizePopup();
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

function showForgotPassword() {
    if($("#bridge_user_response").val()=="bridge" || $("#bridge_user_response").val()=="no" || $("#bridge_user_response").val()=="yes"){
        //showNormalShadow();
        $("#fade_normal_second").show();
        hideLoginBox();
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
        addFocusTextField('email_id_email');
    }
    else {
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
        addFocusTextField('email_id_email');
    }

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
}

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

function showPaymentHistory() {
    $.ajax({
        url: "/ajax/payment_history_emp",
        beforeSend: function() {
            showBlockShadow();
        },
        cache: false
    });
    $("#fade_normal_acc").click(function(){
        hidePaymentHistory();
    });
    centralizePopup();
}

function hidePaymentHistory() {
    $("#fade_normal_acc").unbind();
    $("#fade_normal_acc").hide();
    $("#credit_history_popup").hide();
}

function checkChangePasswordActivationAccountInfo() {
    first_name = document.getElementById('first_name');
    last_name = document.getElementById('last_name');
    email = document.getElementById('email');

    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    oldpassword = document.getElementById('old_password');
    errorBox = document.getElementById('error_msg');
    errorLock = document.getElementById('err-msg-lock').value;
    flag = false;

    if(!validateNotEmpty(first_name)) {
        $("#"+first_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+first_name.id).parent().addClass("input-text-error-empty");
        flag = true;
    }
    if(!validateNotEmpty(last_name)) {
        $("#"+last_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+last_name.id).parent().addClass("input-text-error-empty");
        flag = true;
    }
    if(!validateNotEmpty(email)) {
        $("#"+email.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+email.id).parent().addClass("input-text-error-empty");
        flag = true;
    }
    if(validateNotEmpty(oldpassword) || validateNotEmpty(password) || validateNotEmpty(rePassword)) {
        if(!validateNotEmpty(oldpassword)) {
            $("#"+oldpassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+oldpassword.id).parent().addClass("input-text-error-empty");
            flag = true;
        }
        if(!validateNotEmpty(password)) {
            $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+password.id).parent().addClass("input-text-error-empty");
            flag = true;
        }
        if(!validateNotEmpty(rePassword)) {
            $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error");
            $("#"+rePassword.id).parent().addClass("input-text-error-empty");
            flag = true;
        }
    } else {
        $("#"+oldpassword.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
        $("#"+oldpassword.id).parent().addClass("input-text");

        $("#"+rePassword.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
        $("#"+rePassword.id).parent().addClass("input-text");

        $("#"+password.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
        $("#"+password.id).parent().addClass("input-text");
    }
    if(flag) {
        errorBox.innerHTML="Please complete the areas highlighted in red.";
    } else {
        if(errorLock=="")
            errorBox.innerHTML="";
        if(validateEmail(email.value)) {
            $("input#edit_password").val(0);
            if(validateNotEmpty(oldpassword) && validateNotEmpty(password) && validateNotEmpty(rePassword)) {
                if(validatePassword(password.value) && password.value==rePassword.value) {
                    $("input#edit_password").val(1);
                    $("div#error_msg").empty();
                    $("#employer_account_info").submit();
                }
            } else {
                $("div#error_msg").empty();
                $("#employer_account_info").submit();
            }
        }
    }
}

function checkActivationAccountInfoOnKey() {
    first_name = document.getElementById('first_name');
    last_name = document.getElementById('last_name');
    email = document.getElementById('email');
    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    oldpassword = document.getElementById('old_password');
    errorBox = document.getElementById('error_msg');
    errorLock = document.getElementById('err-msg-lock').value;
    flag = false;
    
    if(!validateNotEmpty(first_name)) {
        flag = true;
    }
    if(!validateNotEmpty(last_name)) {
        flag = true;
    }
    if(!validateNotEmpty(email)) {
        flag = true;
    }
    if(validateNotEmpty(oldpassword) || validateNotEmpty(password) || validateNotEmpty(rePassword)) {
        if(!validateNotEmpty(oldpassword)) {
            flag = true;
        }
        if(!validateNotEmpty(password)) {
            flag = true;
        }
        if(!validateNotEmpty(rePassword)) {
            flag = true;
        }
    }
    if(flag == false){
        if(errorLock=="")
            errorBox.innerHTML="";
    }
}
function accInfoValidate(el) {
    if(crack_for_IE==true) {
        crack_for_IE = false;
        return;
    }
    first_name = document.getElementById('first_name');
    last_name = document.getElementById('last_name');
    email = document.getElementById('email');

    password = document.getElementById('new_password');
    rePassword = document.getElementById('confirm_password');
    oldpassword = document.getElementById('old_password');
    errorBox = document.getElementById('error_msg');
    error_element = document.getElementById('err-msg-lock');

    if(el==email) {
        if(validateNotEmpty(el)) {
            if(validateEmail(el.value)) {
                $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
                $("#"+el.id).parent().addClass("input-text-active");
                if(error_element.value=="email") {
                    errorBox.innerHTML="";
                    error_element.value="";
                }
            }
            else {
                $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
                $("#"+el.id).parent().addClass("input-text-error");
                if(error_element.value=="") {
                    errorBox.innerHTML="Please enter a valid email address.";
                    error_element.value="email";
                }
            }
        } else {
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-active");
            if(error_element.value=="email") {
                errorBox.innerHTML="";
                error_element.value="";
            }
        }
    } else if(el==password && (($("#"+password.id).parent().hasClass("active-input")) || ($("#"+password.id).parent().hasClass("input-text-active")) || ($("#"+password.id).parent().hasClass("input-text-error")) )) {
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
                            error_element.value="password";
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
    } else if(el==rePassword && (($("#"+rePassword.id).parent().hasClass("active-input")) || ($("#"+rePassword.id).parent().hasClass("input-text-active")) || ($("#"+rePassword.id).parent().hasClass("input-text-error")) )) {
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
                if(errorBox.innerHTML=="Passwords do not match. Please try again.") {
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
}

function submitAccountFormonEnterButton(e) {
    var code = e.keyCode;
    if(code == 13){
        $('#update_account_info').click();
    }
    if(code == 13)
        return;
}

function changeName(first_name, last_name) {
    $("div#dashboard-header div#career-seeker_id ul li a span").text(first_name + " " + last_name);
}

function validateCompanyDetails(){
    var company_name = document.getElementById('company_name');
    var company_address = document.getElementById('company_suite');
    var area_code = document.getElementById('area_code');
    var telephone_number = document.getElementById('telephone_number');
    var website = document.getElementById('website');
    var city = document.getElementById('city');
    var state = document.getElementById('state');
    var country = document.getElementById('country');
    var dropdown_check_flag = document.getElementById('dropdown_check_flag_account').value;

    if(validateNotEmpty(company_address) && validateNotEmpty(company_name) && validateNotEmpty(city) && validateNotEmpty(state) && validateNotEmpty(country) && validateNotEmpty(area_code) && validateNotEmpty(telephone_number) && validateNotEmpty(website) && dropdown_check_flag == 1) {
        if(!$(company_name).parent().hasClass("input-text-error") && (!validateNotEmpty(website) || checkURL(website.value)==1)) {
            $("#account_error_msg").html('');
            $("#updateCompany").unbind().click(function(){
                $('#submit_type').val(0);
                $("#company-profile").submit();
            });
        }
        else {
            $("#updateCompany").unbind().click(function(){
                validateEmpOnInactiveButtonClickForAccount();
            });
        }
    }
    else {
        $("#updateCompany").unbind().click(function(){
            validateEmpOnInactiveButtonClickForAccount();
        });
    }
}

function validateEmpOnInactiveButtonClickForAccount() {
    var company_name = document.getElementById('company_name');
    var company_address = document.getElementById('company_suite');
    var area_code = document.getElementById('area_code');
    var telephone_number = document.getElementById('telephone_number');
    var website = document.getElementById('website');
    var city = document.getElementById('city');
    var state = document.getElementById('state');
    var country = document.getElementById('country');

    if(!validateNotEmpty(company_name)) {
        $("#"+company_name.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+company_name.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(company_address)) {
        $("#"+company_address.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+company_address.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(city)) {
        $("#"+city.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+city.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(state)) {
        $("#"+state.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+state.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(country)) {
        $("#"+country.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+country.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(area_code)) {
        $("#"+area_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+area_code.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(telephone_number)) {
        $("#"+telephone_number.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+telephone_number.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }

    if(!validateNotEmpty(website)) {
        $("#"+website.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+website.id).parent().addClass("input-text-error-empty");
        $("#account_error_msg").html("Please complete the areas highlighted in red.");
    }
}

function validateCompInfoAcc() {
    var error_element = document.getElementById('error_element');
    if($("#city_validation_flag").val()==1) {
        $("#city_validation_flag").val(0);
        return;
    }

    if(document.getElementById('dropdown_check_flag_account').value!=1) {
        $("#city").parent().removeClass("active-input");
        $("#city").parent().addClass("input-text-error");

        if(error_element.value=="" || error_element.value=="city") {
            $("#account_error_msg").html("Please select a location from the list.");
            error_element.value="city";
        }
    }
    else {
        $("#city").parent().removeClass("input-text-error");
        if(error_element.value=="" || error_element.value=="city") {
            $("#account_error_msg").html("");
            error_element.value="";
        }
    }
}

function websiteFieldErrorAcc(obj){
    var error_element = document.getElementById('error_element');
    var website = $(obj).val();

    if(validateNotEmpty(obj)) {
        if(checkURL(website) == 0){
            $(obj).parent().removeClass("input-text");
            $(obj).parent().addClass("input-text-error");
            if(error_element.value=="" || error_element.value=="website") {
                $("#account_error_msg").html("Please enter a valid URL");
                error_element.value="website";
            }

        }
        else{
            $(obj).parent().addClass("input-text-active");
            $(obj).parent().removeClass("input-text-error");
            if(error_element.value=="" || error_element.value=="website") {
                $("#account_error_msg").html("");
                error_element.value="";
            }
        }
    }
    else {
        $(obj).parent().addClass("input-text-unactive");
        $(obj).parent().removeClass("input-text-error");
        if(error_element.value=="" || error_element.value=="website") {
            $("#error_msg").html("");
            error_element.value="";
        }
    }
    validateCompanyDetails();
}

function submitCompanyFormonEnterButton(e) {
    var code = e.keyCode;
    if(code == 13){
        var error_element = document.getElementById('error_element');
        $.ajax({
            url:"/employer_payment/search_company?name=" + $('#company_name').val(),
            type: "GET",
            cache: false,
            async: false,
            beforeSend: function() {
                if(error_element.value=="" || error_element.value=="company_name") {
                    $("#account_error_msg").html("");
                    $("#processing_msg").html("Processing Company Name... Please wait!");
                }
            },
            success: function(data){
                $("#processing_msg").html("");
                if(data=="Company doesn't exist") {
                    $("#fill_up_company").html("<input type='hidden' value='0' id='company_exists' name='company_exists' />");
                    if(error_element.value=="" || error_element.value=="company_name") {
                        $("#account_error_msg").html("");
                        error_element.value="";
                    }
                    $("#company_name").parent().removeClass("active-input input-text-active input-text-error");
                    $("#company_name").parent().addClass("input-text-active");
                    $("#account_success_msg").html('Company details has been updated.');
                    $("#account_error_msg").html('');
                    $("#updateCompany").click();
                //validateCompanyForm();
                }
                else if(data=="Company exists") {
                    $("#fill_up_company").html("<input type='hidden' value='1' id='company_exists' name='company_exists' />");
                    $("#before_validate").removeClass("hidden");
                    $("#after_validate").addClass("hidden");
                    if(error_element.value=="" || error_element.value=="company_name") {
                        $("#account_error_msg").html("Company name already exists");
                        $("#account_success_msg").html('');
                        error_element.value="company_name";
                    }
                    $("#company_name").parent().removeClass("active-input input-text-active");
                    $("#company_name").parent().addClass("input-text-error");
                    return false;
                //validateCompanyForm();
                }
            }
        });
    }
}

function inactive_payment_box(job_id) {
    showNormalShadow();
    footerOnOpeningPopup();
    $("#inactive_payment_popup").show();
    addFocusButton('inactive_acivate_job');
    centralizePopup();
    $("#inactive_acivate_job").click(function() {
        navigateUrl('/postings/index/'+job_id);
    });
}

function hide_inactive_payment_box() {
    hideNormalShadow();
    footerOnClosingPopup();
    $("#inactive_payment_popup").hide();
}

function showCorpUser() {
    $("#new_employer_corporate").show();
    $("#button_corp").show();
    $("#new_employer").hide();
    $("#button_free").hide();

    $("#new_employer_corporate .free_user input").attr("checked","checked");
    Custom.check($("#new_employer_corporate .account-type .free_user span.checkbox"));
    $("#new_employer_corporate .corp_user input").removeAttr("checked");
    Custom.check($("#new_employer_corporate .account-type .corp_user span.checkbox"));
}
function showFreeUser() {
    $("#new_employer_corporate").hide();
    $("#button_corp").hide();
    $("#new_employer").show();
    $("#button_free").show();

    $("#new_employer .free_user input").removeAttr("checked");
    Custom.check($("#new_employer .account-type .free_user span.checkbox"));
    $("#new_employer .corp_user input").attr("checked","checked");
    Custom.check($("#new_employer .account-type .corp_user span.checkbox"));
}

function openDropDownOfUsers(){
    if($(".edit-group-name").parent().css("display")!="none" && $(".edit-group-name").parent().css("display")!=undefined){
        return;
    }
    if($('.user-list').is(':visible')) {
        closeDropDownOfUsers();
    }
    else {
        showBlockShadow();
        $.ajax({
            url: '/ajax/fetch_children',
            cache: false,
            success: function(data){
                hideBlockShadow();
                $("#fade_normal_left_menu_dd").show();
                $(".emp-leftmenu-dropdown span.name-cnt").addClass('arrow-up');
                $(".user-list").slideDown();
                footerOnOpeningPopup();
                if(data!=""){
                    $("ul#children").html(data);
                    $("ul#children li:last").addClass("last");
                    $("#my_positions").removeClass('no-border');
                }else{
                    $("ul#children").empty();
                    $("#my_positions").addClass('no-border');
                }
                // Function to take care of double lines while scrolling
                $("ul#children").scroll(function(){
                    $("ul#children li").each(function(){
                        $(this).removeClass('no-border-scroll');
                        if($("ul#children").offset().top - $(this).offset().top > 22) {
                            $(this).addClass('no-border-scroll');
                        }
                    });
                })
                
            }
        });
    }
}



function fetch_employer_position_direct(id){
    closeDropDownOfUsers();
    if(document.URL.split("/")[3].split("?")[0] != "employer_account"){
        window.location.href = "/employer_account?selected="+id;
    }
    $.ajax({
        url: '/ajax/fetch_employer_position',
        data: 'id=' + id,
        cache: false,
        success: function(){
            $("#parent_id").val(id);
            //

            $(".filter_type").children().each(function(){
                if ($(this).find('span.checkbox').css("background-position")=="0px -50px"){
                    Custom.check($(this).find('span.checkbox'));
                }
            });

            Custom.check($("span.checkbox:first"));
            $("#filter_value").val($("span.checkbox:first").next().val());
        }
    });
}

function closeDropDownOfUsers(){
    $("#fade_normal_left_menu_dd").hide();
    $(".emp-leftmenu-dropdown span.name-cnt").removeClass('arrow-up');
    $(".user-list").hide();
    footerOnClosingPopup();
}

function addNewUserBlock() {
    $.ajax({
        url: '/ajax/add_new_user',
        cache: false,
        success: function(data){
            // Find which column to add it to
            var col = 0;
            var count = new Array();
            var add_to_col;
            var flag = false;
            $('.user-rows').each(function(){
                count[col] = 0;
                $(this).find('.user-box').each(function(){
                    count[col]++;
                    if($(this).hasClass('new')) {
                        flag = true;
                    }
                });
                col++;
            })
            if(count[0]==count[1] && count[1]==count[2]) {
                add_to_col = 1;
            }
            else if(count[0]==count[1]) {
                add_to_col = 3;
            } else {
                add_to_col = 2;
            }
            if(!flag) {
                $('.user-admin-box .content .user-rows:nth-child('+add_to_col+')').append(data);
                bindUserBoxes();
            }
        }
    });
}

function getEmptyPosition(){
    var col = 0;
    var count = new Array();
    var add_to_col;
    $('.user-rows').each(function(){
        count[col] = 0;
        $(this).find('.user-box').each(function(){
            count[col]++;
        });
        col++;
    })
    if(count[0]==count[1] && count[1]==count[2]) {
        add_to_col = 1;
    } else if(count[0]==count[1]) {
        add_to_col = 3;
    } else {
        add_to_col = 2;
    }
    return add_to_col;
}

function bindUserBoxes() {
    $(".user-box .top").unbind().click(function(){
        if($(this).parent().hasClass('open')) {
            $(this).parent().removeClass('open');
            $(this).parent().addClass('close');
            $(this).next().slideUp();
        } else {
            $(this).parent().removeClass('close');
            $(this).parent().addClass('open');
            $(this).next().slideDown();
        }
        checkStatusOfUserBoxs();
    });
}

function populateUserFolders(element, dd) {
    $.ajax({
        url:"/ajax/populate_user_folders",
        cache: false,
        data: "emp="+element.attr('emp_id')+"&dd="+dd,
        beforeSend: function() {
            showBlockShadow();
        },
        success: function(data){
            element.parent().parent().parent().parent().parent().find('.user-box.folder-list').remove();
            element.parent().parent().parent().parent().parent().find('.folder-box').each(function(){
                $(this).remove();
            });
            element.parent().parent().parent().parent().parent().find('.user-box.drop-down').hide();
            // Close the User List Dropdown
            element.parent().parent().parent().parent().parent().find('.user-box.drop-down .top').each(function(){
                $(this).parent().removeClass('open');
                $(this).parent().addClass('close');
                $(this).parent().next().hide();
            });
            element.parent().parent().parent().parent().parent().append(data);
            checkStatusOfUserBoxsTab2();
            hideBlockShadow();
            element.parent().parent().parent().parent().parent().children('.user-box.folder-list.open').find('span.user-name').text(element.text());
            element.parent().parent().parent().parent().parent().children('.user-box.folder-list.open').find('input[type=hidden]').val(element.attr('emp_id'));
            $(".user-list.dropdown ul").each(function(){
                $(this).children().each(function(){
                    $(this).removeClass("last");
                    if($(this).attr("emp_id") == element.attr("emp_id")){
                        $(this).hide();
                    }
                });
            });
            $(".user-list.dropdown ul").each(function(){
                var arr = new Array();
                $(this).children().each(function(){
                    if($(this).css('display')=="list-item" || $(this).css('display')=="block")
                        arr.push($(this));
                })
                if(arr.length > 0)
                    arr[arr.length-1].addClass("last");

            });

            //Drag Drop
            tab2Drag.categoryDrag();
            tab2Drag.categoryDrop();
            tab2Drag.positionDrag();
            tab2Drag.positionDrop();

        }
    });
}

var user_admin_tab2_folder_drag = false;
var tab2Drag = {
    dragFlag: false,
    categoryDrag: function(){
        $('.sort-tab2-list .folder-box').draggable("destroy").draggable({
            start: function(event, ui){
                this.dragFlag = false;
                user_admin_tab2_folder_drag = true;
            },
            stop: function(event, ui){
                if(this.dragFlag == false){
                    $(this).css('top','');
                    $(this).css('left','');
                    
                }
            }
            
        });
    },

    positionDrag: function(){
        $('.folder-box ul li').draggable("destroy").draggable({
            start: function(event, ui){
                this.dragFlag = false;
            },
            stop: function(event, ui){
                if(this.dragFlag == false){
                    $(this).css('top','');
                    $(this).css('left','');
                }
            }
        });
    },

    categoryDrop: function(){
        $('.user-rows').droppable("destroy").droppable({
            over: function(event, ui){
                if($(ui.draggable).hasClass('folder-box') && $(this).find('.user-box.folder-list.open').is(':visible')){
                    $(this).addClass('drop-hover');
                }
            },
            out: function(event, ui){
                if($(ui.draggable).hasClass('folder-box')){
                    $(this).removeClass('drop-hover');
                }
            },
            drop: function(event, ui){
                //for category
                $(this).removeClass('drop-hover');
                if($(ui.draggable).hasClass('folder-box')){
                    if($(ui.draggable).parent().parent().attr('id') == $(this).attr('id')){
                        //return back to pre-init state
                        this.dragFlag = false;

                    }
                    else{
                        if($(this).find('.folder-list').length > 0){
                            //send ajax for category
                            //
                            $(ui.draggable).hide();
                            //
                            var ele = $(this);
                            var category_id = $(ui.draggable).attr('id').split("_")[1];
                            var new_emp_id = $(this).find('.folder-list').find('input[type=hidden]').val();
                            var job_ids = [];
                            $(ui.draggable).find('li').each(function(){
                                job_ids.push($(this).attr('id').split("_")[1]);
                            });

                            if(document.URL.split("/")[4])
                                var action_name = document.URL.split("/")[4].split("?")[0];
                            var controller_name = document.URL.split("/")[3].split("?")[0];
                            if(action_name == 'xref'){
                                var cs_id = document.URL.split("/")[5].split("?")[0];
                            }
                            showBlockShadow();
                            $.ajax({
                                url: '/ajax/category_reassign',
                                cache: false,
                                data: 'cat_id='+category_id+'&new_emp_id='+new_emp_id+'&job_ids='+job_ids.join(',')+'&sel='+$('#parent_id').val()+'&cs_id=' + cs_id + "&action_name=" + action_name + "&controller_name=" + controller_name,
                                success: function(){
                                    
                                    if(done == 1){
                                        this.dragFlag = true;
                                        //append
                                        ele.find('.sort-tab2-list').append($(ui.draggable));
                                        $(ui.draggable).css('top','');
                                        $(ui.draggable).css('left','');
                                        hideBlockShadow();
                                        //
                                        $(ui.draggable).show();
                                    //
                                    }
                                    
                                    
                                    else if(category_deleted == 1)
                                        $(ui.draggable).remove();
                                    
                                }
                            });
                        }
                    }
                }
            }
        });
    },

    positionDrop: function(){
        $('.sort-tab2-list .folder-box').droppable("destroy").droppable({
            over: function(event, ui){
                if(!$(ui.draggable).hasClass('folder-box')){
                    if($(this).hasClass('close')){
                        $(this).find('.top').click();
                    }
                }
            },
            hoverClass: "drop-hover",
            drop: function(event, ui){
                if(!$(ui.draggable).hasClass('folder-box')){

                    if($(ui.draggable).parent().parent().parent().parent().attr('id') == $(this).attr('id')){
                        this.dragFlag = false;
                    }
                    else{
                        $(ui.draggable).hide();
                        //send ajax for position
                        var ele = $(this);
                        var new_cat_id = $(this).attr('id').split("_")[1];
                        var new_emp_id = $(this).parent().parent().find('.folder-list').find('input[type=hidden]').val();
                        var job_id = $(ui.draggable).attr('id').split("_")[1];

                        if(document.URL.split("/")[4])
                            var action_name = document.URL.split("/")[4].split("?")[0];
                        var controller_name = document.URL.split("/")[3].split("?")[0];
                        if(action_name == 'xref'){
                            var cs_id = document.URL.split("/")[5].split("?")[0];
                        }
                        
                        showBlockShadow();
                        $.ajax({
                            url: '/ajax/position_reassign',
                            cache: false,
                            data: 'new_cat_id='+new_cat_id+'&new_emp_id='+new_emp_id+'&job_id='+job_id+'&sel='+$('#parent_id').val()+'&cs_id=' + cs_id + "&action_name=" + action_name + "&controller_name=" + controller_name,
                            success: function(){
                                
                                if(done == 1){
                                    this.dragFlag = true;
                                    //append
                                    ele.find('ul').append($(ui.draggable));
                                    $(ui.draggable).css('top','');
                                    $(ui.draggable).css('left','');
                                    hideBlockShadow();
                                    $(ui.draggable).show();
                                    if($("#company_group_id"))
                                        $("#company_group_id").val(new_cat_id);
                                    if(document.getElementById('overview')){
                                        document.getElementById('overview').onclick = function(){
                                            var areYouSureResp = areYouSure('tab-1');
                                            if(areYouSureResp == false) {
                                                return false;
                                            }
                                            profile_blocks.open_overview(new_cat_id);
                                        }
                                    }
                                }
                               
                                else{
                                    
                                    if(job_deleted == 1)
                                        $(ui.draggable).remove();
                                    

                                    
                                    if(category_deleted == 1){
                                        $(ui.draggable).show();
                                        ele.remove();

                                    }
                                    
                                }
                                
                            }
                        });

                        
                        
                    }
                }
            }
        });
    }
}

function rebindFolderBoxes(element){
    $("#"+element.attr('id')+" .top").unbind().click(function(){
        if($(this).parent().hasClass('open')) {
            console.log("close");
            $(this).parent().removeClass('open');
            $(this).parent().addClass('close');
            $(this).next().slideUp();
        }
        else {
            console.log("open");
            $(this).parent().removeClass('close');
            $(this).parent().addClass('open');
            $(this).next().slideDown();
        }
    });
}

function bindFolderBoxes() {
    $(".folder-box .top").unbind().click(function(){
        if(user_admin_tab2_folder_drag) {
            user_admin_tab2_folder_drag = false;
            return false;
        }
        if($(this).parent().hasClass('open')) {
            $(this).parent().removeClass('open');
            $(this).parent().addClass('close');
            $(this).next().slideUp();
        } else {
            $(this).parent().removeClass('close');
            $(this).parent().addClass('open');
            $(this).next().slideDown();
        }
        checkStatusOfUserBoxsTab2();
    });
    $(".folder-box.new .top").unbind();
    $('.user-box.folder-list .top').unbind().click(function(){
        $(this).parent().parent().find('.folder-box').each(function(){
            $(this).remove();
        });
        $(this).parent().parent().find('.sort-tab2-list').remove();
        $(this).parent().parent().find('.user-box.drop-down').show();

        var emp_id = $(this).find('input[type=hidden]').val();
        
        $(".user-list.dropdown ul").each(function(){
            $(this).children().each(function(){
                $(this).removeClass("last");
                if($(this).attr('emp_id') == emp_id){
                    $(this).css('display', 'block');
                }
            //alert($(this).css('display'));
            })
        });
        
        $(".user-list.dropdown ul").each(function(){
            var arr = new Array();
            $(this).children().each(function(){
                if($(this).css('display')=="list-item" || $(this).css('display')=="block")
                    arr.push($(this));
            })
            if(arr.length > 0)
                arr[arr.length-1].addClass("last");
            
        });
        
        $(this).parent().remove();
        checkStatusOfUserBoxsTab2();
    });
    $('.user-box.folder-list .plus').unbind().click(function(){
        var element = $(this);
        showBlockShadow();
        $.ajax({
            url:"/ajax/add_new_folder",
            cache: false,
            success: function(data){
                hideBlockShadow();
                element.parent().parent().parent().next().append(data);
                $('#add_folder').focus();
                $('#add_folder').unbind().blur(function(){
                    if(validateNotEmpty(document.getElementById('add_folder'))) {
                        var folder_name = $('#add_folder').val();
                        // START - Send AJAX Call to create this new folder in the database
                        showBlockShadow();
                        var ele = $(this).parent().parent().parent().parent();
                        $.ajax({
                            url: '/ajax/add_group',
                            type: 'POST',
                            cache: false,
                            data: "emp="+$("#add_folder").parent().parent().parent().parent().parent().parent().find('div.folder-list').find('input[type=hidden]').val()+"&name="+folder_name+"&sel="+$("#parent_id").val(),
                            success: function(){
                                hideBlockShadow();
                                //$(this).parent().parent().parent().parent().attr("id", "category_"+category_id);
                                ele.attr('id', 'category_'+category_id);
                            },
                            beforeSend: function(){
                                if(folder_name == ""){
                                    return false;
                                }
                            }
                        });

                        // END - Send AJAX Call to create this new folder in the database
                        
                        $(this).parent().parent().parent().parent().removeClass('new');
                        $(this).parent().parent().html(folder_name);
                        bindFolderBoxes();
                        //Drag Drop
                        tab2Drag.categoryDrag();
                        tab2Drag.categoryDrop();
                        tab2Drag.positionDrag();
                        tab2Drag.positionDrop();
                        
                    }
                    else {
                        $('.folder-box.new').remove();
                    }
                });
            }
        });
    });
}
function bindUserBoxesTab2() {
    $(".user-box.drop-down .top").unbind().click(function(){
        if($(this).parent().hasClass('open')) {
            $(this).parent().removeClass('open');
            $(this).parent().addClass('close');
            $(this).parent().next().slideUp();
        } else {
            $('.user-list.dropdown').each(function(){
                $(this).prev().removeClass('open');
                $(this).prev().addClass('close');
                $(this).slideUp();
            });
            //
            var flag = 0;
            $(this).parent().next().find('ul').children().each(function(){
                if($(this).css('display')=="list-item" || $(this).css('display')=="block"){
                    flag = 1;
                }
            });
            if(flag == 1){
                $(this).parent().removeClass('close');
                $(this).parent().addClass('open');
                $(this).parent().next().slideDown();
            }
        }
    });
}

function openPositionAssignTab() {
    $('#fade_normal_status_signout').show();
    $('#fade_normal_status_signout').click(function(){
        closeUserAdminTab();
    });
    $.ajax({
        url:"/ajax/user_admin_tab2",
        type: "POST",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
            footerOnOpeningPopup();
        },
        success: function(data){
            $("#user-admin-box").html(data);
            $("#user-admin-box").show();
            hideBlockShadow();
            
        }
    });
}
function openTeamMapTab(type) {
    $('#fade_normal_status_signout').show();
    $('#fade_normal_status_signout').click(function(){
        closeUserAdminTab();
    });
    $.ajax({
        url:"/ajax/user_admin_tab3",
        type: "POST",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
            footerOnOpeningPopup();
        },
        success: function(data){
            $("#user-admin-box").html(data);
            $("#user-admin-box").show();
            hideBlockShadow();
            if(type=='exit-fullscreen') {
                $('#fade_white').empty();
                $('#fade_white').hide();
            }

        }
    });
}

function expandAllTab1(element){
    element = $(element);
    if(element.hasClass('expand')) {
        $('.user-box').removeClass('close').addClass('open');
        $('.user-box .slide').show();
    }
    else {
        $('.user-box').removeClass('open').addClass('close');
        $('.user-box .slide').hide();
    }
    expandAll(element);
}

function checkStatusOfUserBoxs() {
    var allOpen = true;
    var allClosed = true;
    $('.user-box').each(function(){
        if($(this).hasClass('open')) {
            allClosed = false;
        }else {
            allOpen = false;
        }
    });
    if(allOpen) {
        $(".expand-all span").html('Collapse All');
        $(".expand-all span").removeClass('expand').addClass('collapse');
    }
    else if(allClosed) {
        $(".expand-all span").html('Expand All');
        $(".expand-all span").removeClass('collapse').addClass('expand');
    } else {
        $(".expand-all span").html('Expand All');
        $(".expand-all span").removeClass('collapse').addClass('expand');
    }
}
function checkStatusOfUserBoxsTab2() {
    var allOpen = true;
    var allClosed = true;
    var userSelected = false;
    $('.user-rows').each(function(){
        if($(this).find('.user-box.drop-down').is(':hidden')){
            userSelected = true;
        }
    });
    if(userSelected) {
        $('.expand-all span').css('visibility','visible');
        $('.user-rows').each(function(){
            $(this).find('.folder-box').each(function(){
                if($(this).hasClass('open')) {
                    allClosed = false;
                } else {
                    allOpen = false;
                }
            })
        });
        if(allOpen) {
            $(".expand-all span").html('Collapse All');
            $(".expand-all span").removeClass('expand').addClass('collapse');
        }
        else if(allClosed) {
            $(".expand-all span").html('Expand All');
            $(".expand-all span").removeClass('collapse').addClass('expand');
        }
        else {
            $(".expand-all span").html('Expand All');
            $(".expand-all span").removeClass('collapse').addClass('expand');
        }
    }
    else {
        $('.expand-all span').css('visibility','hidden');
    }
}

function expandAllTab2(element){
    element = $(element);
    if(element.hasClass('expand')) {
        $('.folder-box').removeClass('close').addClass('open');
        $('.folder-box .slide').show();
    } else {
        $('.folder-box').removeClass('open').addClass('close');
        $('.folder-box .slide').hide();
    }
    expandAll(element);
}

function expandAllTab3(element){
    element = $(element);
    if(element.hasClass('expand')) {
        $('div.node').each(function(){
            if(!$(this).hasClass('empty')) {
                if($(this).hasClass('s-resize')) {
                    $(this).click();
                }
            }
        });
    }else {
        $('div.node').each(function(){
            if(!$(this).hasClass('empty')) {
                if($(this).hasClass("n-resize")) {
                    $(this).click();
                }
            }
        });
    }
    expandAll(element);
    checkStatusOfTeamMap();
}
function checkStatusOfTeamMap() {
    var allOpen = true;
    var allClosed = true;
    $('div:visible.node').each(function(){
        if(!$(this).hasClass('empty')) {
            if($(this).hasClass("n-resize")) {
                allClosed = false;
            } else if($(this).hasClass('s-resize')) {
                allOpen = false;
            }
        }
    });
    $('div:hidden.node').each(function(){
        if(!$(this).hasClass('empty')) {
            if($(this).hasClass("n-resize")) {
                allOpen = false;
            } else if($(this).hasClass('s-resize')) {
                allOpen = false;
            }
        }
    });
    if(allOpen) {
        $(".expand-all span").html('Collapse All');
        $(".expand-all span").removeClass('expand').addClass('collapse');
    }
    else if(allClosed) {
        $(".expand-all span").html('Expand All');
        $(".expand-all span").removeClass('collapse').addClass('expand');
    }
    else {
        $(".expand-all span").html('Expand All');
        $(".expand-all span").removeClass('collapse').addClass('expand');
    }
    $('#chart .node span').each(function(){
        $(this).disableTextSelect();
    });
}

function expandAll(element) {
    if(element.hasClass('expand')) {
        element.html('Collapse All');
        element.removeClass('expand').addClass('collapse');
    } else {
        element.html('Expand All');
        element.removeClass('collapse').addClass('expand');
    }
}

function reAjustWidthForCalculationBlock() {
    var min_width;
    var width;
    var flag = false;
    var new_min_width;
    $('.calculation-content .item-value').each(function(){
        min_width = $(this).css('min-width');
        width = $(this).width();
        if(min_width!=width+"px") {
            flag = true;
            new_min_width = width+10;
        }
    });
    if(flag) {
        $('.calculation-content .item-value').each(function(){
            $(this).css('min-width',new_min_width+"px");
        });
    }
}

function openTeamMapFullScreen() {
    $('#fade_white').show();
    $.ajax({
        url:"/ajax/team_map_fullscreen",
        cache: false,
        beforeSend: function() {
            showBlockShadow();
        },
        success: function(data){
            $('#fade_white').html(data);
            removeArrowFromEmptyNodes();
            hideBlockShadow();
        }
    });
    
}
function closeTeamMapFullScreen() {
    openTeamMapTab('exit-fullscreen');
    $('body').removeAttr('style');
}
function removeArrowFromEmptyNodes() {
    $('.jOrgChart .node').each(function(){
        if($(this).hasClass('n-resize')) {
            $(this).removeClass('empty');
        } else if($(this).hasClass('s-resize')){
            $(this).removeClass('empty');
        }
        else {
            $(this).addClass('empty');
        }
    });
}
function recolorTree() {
    $('.org-map li').each(function(){
        if(!$(this).hasClass('me-node')) {
            $(this).removeClass('even');
            $(this).removeClass('odd');
            if($(this).parent().parent().hasClass('odd')) {
                $(this).addClass('even');
            }
            else if($(this).parent().parent().hasClass('even')) {
                $(this).addClass('odd');
            } else if($(this).parent().parent().hasClass('me-node')) {
                $(this).addClass('even');
            }
        }
    });
}
var updateTeamMapAjax;
function updateTeamMap(source,target){
    source = source.split('_');
    source = source[2];
    target = target.split('_');
    target = target[2];
    var current_team_tree_ids = $("#current_team_tree_ids").val();
    if(updateTeamMapAjax)
        updateTeamMapAjax.abort();
    updateTeamMapAjax = $.ajax({
        url:"/ajax/update_team_map",
        type: "POST",
        data: "source_id="+source+"&target_id="+target+"&current_team_tree_ids="+current_team_tree_ids,
        cache: false,
        beforeSend: function() {
            showBlockShadow();
        },
        success: function(data){
            hideBlockShadow();
        }
    });
}

function limit_empty_and_crossed_check(obj, user_id){
    showBlockShadow();
    $('#fade_normal_status_signout').unbind();
    document.getElementById('fade_normal_status_signout').onclick = "";
    if (obj.parentNode.className == 'customized-inner-input input-text-unactive' || obj.parentNode.className == 'customized-inner-input input-text-active' || obj.parentNode.className == 'customized-inner-input input-text-error'){
        if (obj.value == '$' || obj.value == ''){
            obj.parentNode.className = "customized-inner-input input-text-error-empty";
            $('#fade_normal_status_signout').click(function(){
                closeUserAdminTab();
            });
            setTimeout(function(){
                hideBlockShadow();
            }, 500);
        }
        else{
            var error_id;
            $('.user-box').each(function(){
                if($(this).hasClass('error')){
                    error_id = $(this).attr('id').split('_')[2];
                }
            });
            $.ajax({
                url: '/ajax/limit_crossed_check',
                data: "user_id=" + user_id + "&amount=" + obj.value + "&error_id=" + error_id,
                cache: false,
                success: function(){
                    hideBlockShadow();
                }
            });
        }
    }
    else{
        $('#fade_normal_status_signout').click(function(){
            closeUserAdminTab();
        });
        hideBlockShadow();
    }
}

function checkForEnter(user_id, e){
    var code = e.keyCode;
    if(code == 13){
        $("#limit_"+user_id).blur();
    }
}

function suspendUser(user_id){
    $("#fade_error_warning").show();
    $("#suspend_warning").show();
    centralizePopup();
    addFocusButton('suspend_button');
    $("#suspend_button").unbind().bind('click', function(){
        showBlockShadow();
        $.ajax({
            url: '/ajax/suspend_user',
            data: 'user_id=' + user_id,
            cahce: false,
            success: function(){
                hideBlockShadow();
                $("#suspend_warning").hide();
                $("#fade_error_warning").hide();
                $("#user_suspend_"+user_id).removeClass('usr-suspend-button').addClass('usr-reinstate-button');
                $("#user_box_"+user_id+" #suspend_image").removeClass('green-dot').addClass('yellow-dot');
                document.getElementById("user_suspend_"+user_id).onclick = "";
                $("#user_suspend_"+user_id).unbind().bind('click', function(){
                    reinstateUser(user_id);
                });
                var arr = new Array();
                arr = $("#spending_form_"+user_id).find('.middle').children();
                $(arr[0]).addClass('disabled');
                $(arr[1]).children().addClass('disabled');
                $(arr[1]).children().find('a').each(function(){
                    if($(this).attr('selected') == 'selected'){
                        $(this).html('<img src="/assets/employer_v2/btn-radio-active-disabled.png" height="21" />');
                    }
                    else{
                        $(this).html('<img src="/assets/employer_v2/btn-radio-disabled.png" height="21" />');
                    }
                    $(this).parent().next().children().last().addClass('active');
                });
                if (!($(arr[2]).hasClass('button-container'))){
                    $(arr[2]).addClass('disabled');
                }
                $(arr[3]).children().addClass('disabled');
                
                $(arr[3]).children().find('a').each(function(){
                    //alert($(this).attr('class'));
                    if($(this).attr('selected') == 'selected'){
                        $(this).html('<img src="/assets/employer_v2/btn-radio-active-disabled.png" height="21" />');
                    }
                    else{
                        $(this).html('<img src="/assets/employer_v2/btn-radio-disabled.png" height="21" />');
                    }
                });
                $("#spending_form_"+user_id+" .options-container a").unbind();
                $("#spending_form_"+user_id+" .limit").attr("disabled", 'disabled');
            }
        });
    });
    
}

function reinstateUser(user_id){
    showBlockShadow();
    $.ajax({
        url: '/ajax/reinstate_user',
        data: 'user_id=' + user_id,
        cache: false,
        success: function(){
            hideBlockShadow();
            $("#user_suspend_"+user_id).removeClass('usr-reinstate-button').addClass('usr-suspend-button');
            $("#user_box_"+user_id+" #suspend_image").removeClass('yellow-dot').addClass('green-dot');
            document.getElementById("user_suspend_"+user_id).onclick = "";
            $("#user_suspend_"+user_id).unbind().bind('click', function(){
                suspendUser(user_id);
            });
            var arr = new Array();
            arr = $("#spending_form_"+user_id).find('.middle').children();
            $(arr[0]).removeClass('disabled');
            $(arr[1]).children().removeClass('disabled');
            $(arr[1]).children().find('a').each(function(){
                if($(this).attr('selected') == 'selected'){
                    $(this).html('<img src="/assets/employer_v2/btn-radio-active.png" height="21" />');
                }
                else{
                    $(this).html('<img src="/assets/employer_v2/btn-radio-inactive.png" height="21" />');
                }
                if($(this).index()!=0 && $(this).attr('selected') == 'selected') {
                    $("#spending_form_"+user_id+" .limit").removeAttr("disabled");
                    $(arr[2]).removeClass('disabled');
                    $(arr[3]).children().removeClass('disabled');
                    $(arr[3]).children().find('a').each(function(){
                        //alert($(this).attr('class'));
                        if($(this).attr('selected') == 'selected'){
                            $(this).html('<img src="/assets/employer_v2/btn-radio-active.png" height="21" />');
                        }
                        else{
                            $(this).html('<img src="/assets/employer_v2/btn-radio-inactive.png" height="21" />');
                        }
                    });
                }
                $(this).parent().next().children().last().removeClass('active');
            });
            all_atag_bindings();
        }
    });
}

if(!Array.prototype.indexOf){
    Array.prototype.indexOf= function(what, i){
        i= i || 0;
        var L= this.length;
        while(i< L){
            if(this[i]=== what) return i;
            ++i;
        }
        return -1;
    }
}

Array.prototype.remove= function(){
    var what, a= arguments, L= a.length, ax;
    while(L && this.length){
        what= a[--L];
        while((ax= this.indexOf(what))!= -1){
            this.splice(ax, 1);
        }
    }
    return this;
}

function deleteUser(user_id){
    $("#fade_error_warning").show();
    $("#delete_warning").show();
    centralizePopup();
    addFocusButton('delete_warning_button');
    $("#delete_warning_button").unbind().bind('click', function(){
        showBlockShadow();
        var row_items = new Array();
        var row = 0;
        
        $(".user-rows").each(function(){
            row_items[row] = new Array();
            $(this).find(".user-box").each(function(){
                row_items[row].push($(this).attr('id'));
            });
            row++;
        });

        var max_size = Math.max(row_items[0].length,row_items[1].length,row_items[2].length);
        var seq_order = new Array();
        for(var i = 0; i < max_size; i++) {
            if(row_items[0][i]) {
                seq_order.push(row_items[0][i]);
            }
            if(row_items[1][i]) {
                seq_order.push(row_items[1][i]);
            }
            if(row_items[2][i]) {
                seq_order.push(row_items[2][i]);
            }
        }

        seq_order.remove('user_box_'+user_id);
        
        $.ajax({
            url: '/ajax/delete_user',
            data: 'user_id=' + user_id,
            cache: false,
            success: function(){
                hideBlockShadow();
                if ($("#parent_id").val() == user_id){
                    $("#all_positions").click();
                }
                
                $("#user_box_"+user_id).remove();
                for(i = 0; i < seq_order.length; i++) {
                    if(i%3 == 0) {
                        $("#"+seq_order[i]).appendTo('.user-rows:eq(0)');
                    }
                    if(i%3 == 1) {
                        $("#"+seq_order[i]).appendTo('.user-rows:eq(1)');
                    }
                    if(i%3 == 2) {
                        $("#"+seq_order[i]).appendTo('.user-rows:eq(2)');
                    }
                }
                $.ajax({
                    url: '/ajax/add_deleted_children',
                    data: 'children_ids=' + children_ids,
                    cahce: false,
                    type: 'POST',
                    success: function(){
                        $("#delete_warning").hide();
                        $("#fade_error_warning").hide();
                    }
                });
            }
        });
    });
}

function all_atag_bindings(){
    $(".options-container a").click(function(){
        if($(this).parent().hasClass('disabled') || $(this).parent().parent().hasClass('disabled')) {
            return false;
        }
        $(this).parent().find('a').each(function(){
            $(this).html('<img src="/assets/employer_v2/btn-radio-inactive.png" height="21" />');
            $(this).removeAttr('selected');
        });
        $(this).html('<img src="/assets/employer_v2/btn-radio-active.png" height="21" />');
        $(this).attr('selected','selected');
    });

    $(".options-container.spending-limit a").click(function(){
        if($(this).index()==0) {
            $(this).parents('.middle').find('.options-container.monthly-renew a').each(function(){
                $(this).html('<img src="/assets/employer_v2/btn-radio-disabled.png" height="21" />');
            });
            $(this).parents('.middle').find('.options-container.monthly-renew').parent().prev().addClass('disabled');
            $(this).parents('.middle').find('.options-container.monthly-renew').addClass('disabled');
            var emp_id = $(this).parent().parent().parent().parent().prev().val();
            $.ajax({
                url: '/employer/set_spending_limit_no',
                data: 'set=' + 0 + '&emp_id=' + emp_id,
                cache: false,
                success: function(){
                    $('#fade_normal_status_signout').click(function(){
                        closeUserAdminTab();
                    });
                    hideBlockShadow();
                }
            });
        }
        if($(this).index()==0) {
            $(this).parent().next().children().removeClass('input-text-active input-text-unactive input-text-error-empty').addClass('input-text');
            $(this).parent().next().children().children().each(function(){
                if ($(this).hasClass('limit')){
                    $(this).val('');
                    $(this).blur();
                    $(this).attr("disabled", 'disabled');
                    $(this).parent().next().addClass('active');
                }
            });
        }
        else{
            $('input.limit',$(this).parent().next()).removeAttr('disabled');
            $(this).parent().next().children().last().removeClass('active');
            $(this).parent().next().children().children().each(function(){
                if ($(this).hasClass('limit')){
                    if (!($(this).parent().parent().parent().hasClass('disabled'))){
                        $(this).focus();
                    }
                }
            });
        //$('input.limit',$(this).parent().next()).focus();
        //$(this).parent().next().children().removeClass('input-text input-text-active').addClass('input-text-unactive');
        }

    });
    $(".options-container.monthly-renew a").click(function(){
        if($(this).parent().hasClass('disabled')) {
            return false;
        }
        var emp_id = $(this).parent().parent().parent().prev().val();
        if($(this).index()==0) {
            $.ajax({
                url: '/employer/set_monthly_auto_renew',
                data: 'set=' + 0 + '&emp_id=' + emp_id,
                cache: false,
                success: function(){

                }
            });
        }
        else{
            $.ajax({
                url: '/employer/set_monthly_auto_renew',
                data: 'set=' + 1 + '&emp_id=' + emp_id,
                cache: false,
                success: function(){

                }
            });
        }
    });
}

function validateNewUserForm() {
    $("#new_user_error_message").html("");
    var flag = true;
    $("#create_new_user").find("input[type=text]").each(function(){
        if($(this).parent().hasClass("input-text") || $(this).parent().hasClass("input-text-error-empty")) {
            $(this).parent().removeClass("input-text input-text-error-empty").addClass("input-text-error-empty");
            $("#new_user_error_message").html("Incomplete User Information.");
            flag = false;
        }
    });
    if(!flag) {
        return false;
    }
    flag = true;
    if(!validateEmail($("#create_new_user #employer_email").val())) {
        $("#create_new_user #employer_email").parent().removeClass('active-input input-text-active').addClass('input-text-error');
        $("#new_user_error_message").html("Invalid Email Address.");
        flag = false;
    }
    if(!flag) {
        return false;
    }
    return true;
}

function validateNewUserFormOnBlur(current_element) {
    var flag;
    var email_element = document.getElementById('employer_email');
    if($("#new_user_error_message").html()!="Invalid Email Address." && $("#new_user_error_message").html()!="Email Address is not available.") {
        flag = true;
        $("#create_new_user").find("input[type=text]").each(function(){
            if($(this).parent().hasClass("input-text-error-empty")) {
                flag = false;
            }
        });
        if(flag) {
            $("#new_user_error_message").html("");
        }
    }
    if(email_element == current_element) {
        if(validateNotEmpty(email_element)) {
            if(!validateEmail($("#create_new_user #employer_email").val())) {
                $("#create_new_user #employer_email").parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-error');
                $("#new_user_error_message").html("Invalid Email Address.");
            } else {
                $("#create_new_user #employer_email").parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-active');
                if($("#new_user_error_message").html()=="Invalid Email Address." || $("#new_user_error_message").html()=="Email Address is not available.") {
                    $("#new_user_error_message").html("");
                }
            }
        } else {
            $("#create_new_user #employer_email").parent()
            .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
            .addClass('input-text-unactive');
            if($("#new_user_error_message").html()=="Invalid Email Address." || $("#new_user_error_message").html()=="Email Address is not available.") {
                $("#new_user_error_message").html("");
            }
        }
        
    }
}

function enterHandlingForNewUser(e) {
    var code = e.keyCode;
    if(code == 13){
        $(".create-new-user-button").click();
    }
}
function dashboardChartsSelect(){
    $("a.summary-tab").unbind('click').bind("click", function(){
        $("a.summary-tab").removeClass("summary-open-tab").addClass("summary-close-tab");
        $(".employer-chart-holder").css("visibility","hidden");
        $(this).addClass("summary-open-tab").removeClass("summary-close-tab");
        $("#" + $(this).attr("data-section")).css("visibility","visible");

        $(".legend-right").css("visibility","hidden");
        $("#" + $(this).attr("data-section") + "_legend").css("visibility","visible");
        $("span.chart-header").addClass("hidden");
        $("#" + $(this).attr("data-section") + "_heading").removeClass("hidden");

    });
}

function close_job_reassign_deleted(){
    if(document.URL.split("/")[4])
        var action_name = document.URL.split("/")[4].split("?")[0];
    var controller_name = document.URL.split("/")[3].split("?")[0];
    if(action_name == 'xref'){
        var cs_id = document.URL.split("/")[5].split("?")[0];
    }

    showBlockShadow();
    $.ajax({
        url: '/ajax/refresh_left_menu',
        cache: false,
        data: 'sel='+$('#parent_id').val()+'&cs_id=' + cs_id + "&action_name=" + action_name + "&controller_name=" + controller_name,
        success: function(){
            $("#job_reassign_deleted").hide();
            $('#fade_error').css('z-index', '1001');
            hideErrorShadow();
            hideBlockShadow();
            replaceJobText();
        }
    });
}

function close_category_reassign_deleted(){
    if(document.URL.split("/")[4])
        var action_name = document.URL.split("/")[4].split("?")[0];
    var controller_name = document.URL.split("/")[3].split("?")[0];
    if(action_name == 'xref'){
        var cs_id = document.URL.split("/")[5].split("?")[0];
    }

    showBlockShadow();
    $.ajax({
        url: '/ajax/refresh_left_menu',
        cache: false,
        data: 'sel='+$('#parent_id').val()+'&cs_id=' + cs_id + "&action_name=" + action_name + "&controller_name=" + controller_name,
        success: function(){
            $("#category_reassign_deleted").hide();
            $('#fade_error').css('z-index', '1001');
            hideErrorShadow();
            hideBlockShadow();
            replaceFolderText();

        }
    });
}

function replaceFolderText(){
    $("#folder-free-text").text("The folder does not exist in the system.");
}

function replaceJobText(){
    $("#job-free-text").text("The position does not exist in the system.");
}

function closeJobDeleted(){
    $("#job_deleted").hide();
    hideErrorShadow();
    footerOnClosingPopup();
}

function closeOutdatedTeamMap(){
    $("#outdated_team_map").hide();
    hideErrorShadow();
    $('#fade_error').css('z-index', '1001');
}

function closeAcccessDenied(){
    $("#permission_denied").hide();
    hideErrorShadow();
    footerOnClosingPopup();
}

function clsFolderDeleted(){
    $("#folder_deleted").hide();
    hideErrorShadow();
    footerOnClosingPopup();
}

function viewCoverLetter( job_id, job_seeker_id ) {
    $.ajax({
        url: '/ajax/view_cover_note',
        cache: false,
        data: {
            job_id: job_id,
            job_seeker_id: job_seeker_id
        },
        success: function(data){
            $('body').append(data);
            $("#cover_letter_box").show();
            $("#fade_normal_status_skill-tooltip").show();
            centralizePopup();
        }
    });
}

function closeCoverLetter() {
    if($("#emp_detailed_view").is(":visible")) {
        $("#fade_normal_status_skill-tooltip").hide();
    } else {
        hideNormalShadow();
        footerOnClosingPopup();
    }
    $("#cover_letter_box").remove();
}

function saveSearchKeyword(){
    if (searchAjax){
        $.ajax({
            type: 'POST',
            url:'/ajax/save_employer_search',
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

            },
            success: function(){
                hideBlockShadow();
                $('#save_search').show();
                $('#save_button_emp').hide();
                $('#saved_search_popup').hide();
                hideNormalShadow();
                footerOnClosingPopup();
                searchAjax = true;
            }

        })
    }
}

function handleEnterSaveSearch(e){
    if(e.keyCode == 13){
        saveSearchKeyword();
    }
}

function copyToTextBox(e){
    $('#search').parent().removeClass('input-text-error-empty input-text-error').addClass('input-text');
    document.getElementById('search').value = e.childNodes[0].getAttribute("keyword");
    $('#saved_search_list, #saved_search_list .options-content').hide();
    $("#search").parent().removeClass('input-text').addClass('active-input');
    $("#save_show_emp").val('0');
    $('#save_button_emp').hide();
}

function deleteSavedSearch(e, ev){
    $.ajax({
        type: 'POST',
        url: '/ajax/delete_saved_search_employer',
        cache:false,
        data: 'saved_id='+e.getAttribute('id'),
        success: function(){
            if (e.parentNode.parentNode.childNodes.length-1 == 0){
                $('#search_arrow').hide();
                $('#saved_search_list, #saved_search_list .options-content').hide();
            }
            e.parentNode.parentNode.removeChild(e.parentNode);
        }
    });
    ev.stopPropagation();
    
}

function setShowSave(){
    $("#save_show_emp").val('1');
}

function showSavedSearchContainer(e){
    $('#saved_search_list, #saved_search_list .options-content').show();
    $('#saved_search_list .options').children().each(function(){
        $(this).removeClass('selected');
    });
    $('#saved_search_list .options').scrollTop();
    e.stopPropagation();
}

function saveButtonClick(){
    showNormalShadow();
    $('#search_name').val('');
    $('#search_name').blur();
    $('#search_name').parent().removeClass('input-text-error-empty').addClass('input-text');
    $('#saved_search_popup').show();
    addFocusTextField('search_name');
    centralizePopup();
    footerOnOpeningPopup();
}

function resetURL(){
    $.ajax({
        type: 'POST',
        url: '/ajax/reset_ics_url',
        cache: false,
        beforeSend: function(){
            showBlockShadow();
        },
        success: function(data){
            $("#ics-url").val(data);
            hideBlockShadow();
        }
    });
}

function validate_blur_search(){
    var obj = document.getElementById('search');
    if (!(validateNotEmpty(obj))){
        $(obj).parent().removeClass('input-text-error').addClass('input-text-active');
        $(obj).val('');
    }
}

function saveDomainNames(){
    $.ajax({
        type: 'POST',
        url: '/employer_account/save_domain_name',
        cache: false,
        data: 'domain_name='+$("#domain_name").val().trim(),
        success: function(){
            hideBlockShadow();
        },
        beforeSend: function(){
            if($("#domain_name").val().trim() == $("#domain_name_placeholder").val() || $("#domain_name").val().trim() == ""){
                $("#domain_name").parent().removeClass('input-text-active active-input input-text').addClass('input-text-error-empty');
                return false;
            }
            showBlockShadow();
        }
    });
}

function inviteEmail(){
    $.ajax({
        type: 'POST',
        url: '/employer_account/invite',
        cache: false,
        data: 'invite_email='+$("#invi_email").val().trim(),
        success: function(){
            hideBlockShadow();
        //$("#invi_email").val("");
        //$("#invi_email").blur();
        },
        beforeSend: function(){
            if($("#invi_email").val().trim() == $("#invi_email_placeholder").val() || $("#invi_email").val().trim() == ""){
                $("#invi_email").parent().removeClass('input-text-active active-input input-text').addClass('input-text-error-empty');
                return false;
            }
            showBlockShadow();
        }
    });
}
var addNewFolderFlag = 0;
function addNewFolder(){
    /*
    if($('#parent_id').val()!="0"){
        addNewFolderFlag = 1;
        $('#my_positions').click();
    //setTimeout('addFolder()', 2000);
    } else{
        addFolder();
    }
         */
    addFolder();
}

function addFolder(){
    $.ajax({
        url: '/employer_account/add_folder_div',
        cache: false,
        beforeSend: function(){
            showBlockShadow();
        },
        success: function(data){
            $("#company-group-list-section").append(data);
            $("#new_folder_div").show();
            $("#company-group-list-section").sortable("disable");
            $("#company-group-list-section").addClass("disable");
            $(".group-row-bg").each(function(){
                $(this).find('.landing-value').unbind();
            });
            $('#folder_name').focus();
            $('#folder_name').blur(function(){
                if($('#folder_name').val().trim() != ""){
                    //$('#add_folder_form').submit();
                    saveFolder();
                }
                else{
                    $('#new_folder_div').remove();
                    $("#company-group-list-section").sortable("enable");
                    $("#company-group-list-section").removeClass("disable");
                    //emp_left_menu_event.toggle_group_event();
                    $(".group-row-bg").each(function(){
                        $(this).find('.landing-value').disableTextSelect();
                        $(this).find('.landing-value').unbind().click(function(e){
                            e.stopPropagation();
                        });
                        $(this).find('.landing-value').disableTextSelect();
                        $(this).find('.landing-value').dblclick(function(e){
                            $('.group-row-bg').find('.edit-group-name').each(function(e){
                                if($(this).parent().css('display') != "none"){
                                    $(this).parent().prev().attr('data-folder-name', $(this).val());
                                }
                            });
                            $(".group-row-drag").hide();
                            var id = $(this).parent().find('.show-content').attr('data-group-id');
                            enable_category_edit(id);
                            e.stopPropagation();
                        });
                    });
                }
            });
            if(document.getElementById('company-group-list-section')){
                document.getElementById('company-group-list-section').scrollTop = 99999999;
            }
            hideBlockShadow();
        }
    });
    
}

function saveFolder(){
    $.ajax({
        type: 'POST',
        url: '/position_profile/add_group',
        cache: false,
        data: 'add_group_field='+encodeURIComponent($('#folder_name').val().trim()),
        success: function(){
            hideBlockShadow();
            addFolderFlag = 1;
        },
        beforeSend: function(){
            /*
            if($('#folder_name').val().trim().replace(/[^\w\s]/gi, '') == ""){
                return false;
            }
                 */
            showBlockShadow();
        }
    });
}

function invitationEnter(e){
    if(e.keyCode == 13){
        //$('#add_folder_form').submit();
        if($('#invi_email').val().trim() != ""){
            inviteEmail();
        }
    }
}

function domainEnter(e){
    if(e.keyCode == 13){
        if($("#domain_name").val().trim() != ""){
            saveDomainNames();
        }
    }
}
var stop_folder_edit_form_submit = false;
function addFolderEnter(e){
    var keyCode = e.keyCode ? e.keyCode : e.charCode;
    if(keyCode == 13){
        //$('#add_folder_form').submit();
        if($('#folder_name').val().trim() != ""){
            stop_folder_edit_form_submit = true;
            console.log('ENTER');
            console.log(stop_folder_edit_form_submit);
            //saveFolder();
            $('#folder_name').blur();
            e.preventDefault();
        }
    }
    addFolderFlag = 0;
}

function emptyTextBox(ele){
    var e = $("#"+ele.id);
    if(e.parent().hasClass('input-text-error')){
        if(e.val() == ""){
            e.parent().removeClass('input-text-error').addClass('input-text');
            e.val(e.prev().val());
        }
    }

}

function openHelpPopup(id) {
    if(id == "eeo_help") {
        $("#fade_normal_acc").show();
        $('#'+id).show();
        centralizePopup();
        $("#fade_normal_acc").click(function(){
            closeHelpPopup(id);
        });
        return;
    }
    $('#'+id).show();
    centralizePopup();
    showNormalShadow();
    footerOnOpeningPopup();
}

function closeHelpPopup(id) {
    if(id == "eeo_help") {
        $("#fade_normal_acc").hide();
        $('#'+id).hide();
        return;
    }
    $('#'+id).hide();
    hideNormalShadow();
    footerOnClosingPopup();
}

function removeErrorPositionProfile(el){
    $('#'+el.id).parent().parent().parent().parent().removeClass('error');
    if (el.value.trim() == ""){
        var charcters;
        $('#'+el.id).caretToStart();
        $('#'+el.id).removeClass('filled-input');
        $('#'+el.id).addClass('placeholder');
        el.value = $('#'+el.id).attr('placeholder');
    //dest = $(el).parent().parent().parent().prev().find("span.character-remaining");
    //if (el.id == "overview-text"){
    //    charcters = 300;
    //}
    //else if (el.id == "summary"){
    //    charcters = 550;
    //}
    //dest.text("characters remaining: "+charcters);
    }
}

var employer_delete = {
    showDeleteConfirmationPopup: function(){
        showBlockShadow();
        $.ajax({
            url: '/ajax/delete_confirmation_employer',
            cache: false,
            success: function(){
                hideBlockShadow();
            }
        });
    },
    hideDeleteConfirmationPopup: function(){
        $('#delete_confirmation_popup').hide();
        $('#fade_error_warning').hide();
    },
    continueDeleteConfirmationPopupNo: function(){
        $.ajax({
            url: '/ajax/continue_delete_confirmation_employer',
            cache: false,
            data: "set_field=no",
            success: function(){

            }
        });
    },
    continueDeleteConfirmationPopupYes: function(){
        if ($('#delete_confirmation_popup_selected_emp').val() == "0"){
            $('#new_root_name').parent().addClass('error');
        }
        else{
            $.ajax({
                url: '/ajax/continue_delete_confirmation_employer',
                cache: false,
                data: "set_field=yes"+"&nominated_emp_id="+$('#delete_confirmation_popup_selected_emp').val(),
                success: function(){

                }
            });
        }
    }
}

function closeJobSeekerDeletedPopup(){
    window.location.reload();
}

function add_folder_reassign_check_enter(e){
    if(e.keyCode == 13){
        $("#add_folder").blur();
    }
}

function dashboardRefreshHandler(){
    $("#search").val();
    $("#search").blur();
    sortDashboardTables('pairing','desc', $("#filter_value").val(), $('#parent_id').val(), 'table_data');
    hideRefreshLink();
}

function poolRefreshHandler(){
    if($("#profile_chart").hasClass("active") || $("#wild_chart").hasClass("active") || $("#interested_chart").hasClass("active") || $("#detail_chart").hasClass("active") || $("#preview_chart").hasClass("active")){
        window.location.reload();
    }
    else{
        $("#search").val();
        $("#search").blur();
        sortCandidatePoolTables('pairing','desc', $("#filter_value").val(), 'table_data');
    }
    hideRefreshLink();
}

function xrefRefreshHandler(){
    window.location.reload();
}

function hideRefreshLink(){
    if($("#refresh_link")){
        $("#refresh_link").children().unbind();
        $("#refresh_link").hide();
    }
}

function duplicatePosition(job_id,current_job_flag) {
    showBlockShadow();
    $.ajax({
        url: '/ajax/duplicate_job',
        type: "POST",
        cache: false,
        data: "job_id="+job_id+"&parent_id="+$('#parent_id').val()+"&current_job_flag="+current_job_flag
    });
}