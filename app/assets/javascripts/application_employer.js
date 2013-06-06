// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// ...
//= require jquery
//= require jquery_ujs
//= require jquery-ui

// Calls a wibndow.open and uses url as params, also opens popup in center of window
var senders_name;
var senders_email;
var recievers_name;
var recievers_email;
var personal_msg;

//var label_id = new Array();
//var label_value = new Array();

function clickOutside(e){
    var flag = 0;
    if($('#'+e.id).is(':visible')){
        if($("#checkout_billing_close").is(':visible')){
            if($("#checkout_billing_close").css('z-index') > $('#'+e.id).css('z-index')){
                gift_hilo.hideCheckoutBillingClose();
                flag = 1;
            }
        }
    }
    
    if(!flag){
        if($('#'+e.id).is(':visible')){
            if($("#add-new-posotion").is(':visible')){
                if($("#add-new-posotion").css('z-index') > $('#'+e.id).css('z-index')){
                    $('#add-new-posotion').hide();
                    hideDashboardWarningPopup();
                    flag = 1;
                }
            }
        }
    }

    if(!flag){
        if($('#'+e.id).is(':visible')){
            if($("#saved_search_popup").is(':visible')){
                if($("#saved_search_popup").css('z-index') > $('#'+e.id).css('z-index')){
                    $('#saved_search_popup').hide();
                    hideNormalShadow();
                    footerOnClosingPopup();
                    flag = 1;
                }
            }
        }
    }

    if(!flag){
        if($('#'+e.id).is(':visible')){
            if($("#emp_advanced_popup").is(':visible')){
                if($("#emp_advanced_popup").css('z-index') > $('#'+e.id).css('z-index')){
                    language_ev2.close_pop();
                    footerOnClosingPopup();
                    flag = 1;
                }
            }
        }
    }

    if(!flag){
        if($('#'+e.id).is(':visible')){
            if($("#cover_letter_box").is(':visible')){
                if($("#cover_letter_box").css('z-index') > $('#'+e.id).css('z-index')){
                    $('#cover_letter_box').hide();
                    closeCoverLetter();
                    flag = 1;
                }
            }
        }
    }
    
    if(!flag){
        if($('#'+e.id).is(':visible')){
            $('.white_content').each(function(){
                if($(this).is(':visible')){
                    //console.log($(this).css('z-index'));
                    if($(this).css('z-index') > $('#'+e.id).css('z-index')){
                        //console.log("true");
                        $(this).find('a.close').click();
                        $(this).find('a.position_close_oneclick').click();
                        flag = 1;
                    }
                }
            })
        }
    }
    if(!flag){
        if($('#'+e.id).is(':visible')){
            $('label.popup-heading').each(function(){
                if($(this).parent().parent().parent().parent().parent().is(':visible')){
                    //console.log($(this).css('z-index'));
                    if($(this).parent().parent().parent().parent().parent().css('z-index') > $('#'+e.id).css('z-index')){
                        //console.log("true");
                        $(this).parent().parent().parent().parent().parent().find('a').each(function(){
                            if($(this).text() == "Close"){
                                $(this).click();
                                flag = 1;
                            }
                        });

                    }
                }
            })
        }
    }
    if(!flag){
        if($('#'+e.id).is(':visible')){
            $('.detiled_content').each(function(){
                if($(this).is(':visible')){
                    //console.log($(this).css('z-index'));
                    if($(this).css('z-index') > $('#'+e.id).css('z-index')){
                        //console.log("true");
                        $(this).find('a.close').click();
                        flag = 1;
                    }
                }
            })
        }
    }
    if(!flag){
        if($('#'+e.id).is(':visible')){
            $('.help_popup').each(function(){
                if($(this).parent().is(':visible')){
                    if($(this).parent().css('z-index') > $('#'+e.id).css('z-index')){
                        $(this).parent().find('a').each(function(){
                            if($(this).text() == "Close"){
                                $(this).click();
                                flag = 1;
                            }
                        });
                    }
                }
            });
        }
    }
    if(!flag){
        if($('#'+e.id).is(':visible')){
            if($('#one_click_payment_position_popup').is(':visible')){
                if($('#one_click_payment_position_popup').css('z-index') > $('#'+e.id).css('z-index')){
                    $('#one_click_payment_position_popup').find('a').each(function(){
                        if($(this).text() == "Close"){
                            $(this).click();
                            flag = 1;
                        }
                    });
                }
            }
            
        }
    }
    
}
    
function popup(url)
{
    var width;
    var height;
    //half the screen width minus half the new window width (plus 5 pixel borders).
    width = (window.screen.width/2) - (75 + 10);
    //half the screen height minus half the new window height (plus title and status bars).
    height = (window.screen.height/2) - (100 + 50);
    var left   = (screen.width  - width)/2;
    var top    = (screen.height - height)/2;
    var params = 'width=640, height=320';
    params += ', top='+top+', left='+left;
    params += ', directories=no';
    params += ', location=no';
    params += ', menubar=no';
    params += ', resizable=yes';
    params += ', scrollbars=yes';
    params += ', status=no';
    params += ', toolbar=no';
    newwin=window.open(url,'windowname5', params);
    if (window.focus) {
        newwin.focus()
    }
    return false;
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

var job_row_view = {
    init: function(){
        $(".opp-row").each(function(){
            var job_id = $(this).attr("id").split("_")[2];
            if($(this).attr("data-consider") == "yes"){
                $(this).find("a").unbind("click").bind("click",function(){
                    //job_row_view.row_change_color(job_id);
                    job_detail_view.show(job_id);
                });
            }else{
                $(this).find("a").unbind("click").bind("click",function(){
                    //job_row_view.row_change_color(job_id);
                    show_job.call(job_id);
                });
            }
        });
    },
    row_change_color: function(job_id){
        $("div[id^=job_row_]").removeClass("detail-view-highlighted-row");
        $("#job_row_" + job_id).addClass("detail-view-highlighted-row");
    }
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

function hideAboutHiloPopup() {
    $('div#about-hilo').hide();
    hideNormalShadow();
}

function showCoreValues() {
    $("#aboutAbout").addClass("deactive");
    $("#aboutCoreValues").removeClass("deactive").addClass("active");
    $("#aboutTeam").addClass("deactive");
    $("#aboutLab").addClass("deactive");
    $("#aboutPress").addClass("deactive");
    $("#aboutContact").addClass("deactive");
    $("div#about-corevalues").show();
    $("div#about-about").hide();
    $("div#about-team").hide();
    $("div#about-lab").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

function showTeam() {
    $("#aboutAbout").addClass("deactive");
    $("#aboutCoreValues").addClass("deactive");
    $("#aboutTeam").removeClass("deactive").addClass("active");
    $("#aboutLab").addClass("deactive");
    $("#aboutPress").addClass("deactive");
    $("#aboutContact").addClass("deactive");
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
    $("#aboutAbout").addClass("deactive");
    $("#aboutCoreValues").addClass("deactive");
    $("#aboutTeam").addClass("deactive");
    $("#aboutLab").removeClass("deactive").addClass("active");
    $("#aboutPress").addClass("deactive");
    $("#aboutContact").addClass("deactive");
    $("div#about-lab").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-team").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

function showPress() {
    $("#aboutAbout").addClass("deactive");
    $("#aboutCoreValues").addClass("deactive");
    $("#aboutTeam").addClass("deactive");
    $("#aboutLab").addClass("deactive");
    $("#aboutPress").removeClass("deactive").addClass("active");
    $("#aboutContact").addClass("deactive");
    $("div#about-press").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-lab").hide();
    $("div#about-team").hide();
    $("div#about-contact").hide();
}

function showContact() {
    $("#aboutAbout").addClass("deactive");
    $("#aboutCoreValues").addClass("deactive");
    $("#aboutTeam").addClass("deactive");
    $("#aboutLab").addClass("deactive");
    $("#aboutPress").addClass("deactive");
    $("#aboutContact").removeClass("deactive").addClass("active");
    $("div#about-contact").show();
    $("div#about-about").hide();
    $("div#about-corevalues").hide();
    $("div#about-lab").hide();
    $("div#about-team").hide();
    $("div#about-press").hide();
}

function set_employer_save_type(type){
    $("#save_type").val(type);
}

var add_more_responsibility = {
    init: function(){
        this.add_more_link();
        this.hide_add_more_link();
    },
    add: function(){
        var html_str =  "<div class='responsibility-field'><input type='text' name='responsiblities[]' class='input-field-style'/></div>";
        $("#responsibility-box").append(html_str);
        this.hide_add_more_link();
    },
    hide_add_more_link: function(){
        if($(".responsibility-field").length >= 5){
            $("#add_responsibility_link").hide();
        }
    },
    add_more_link : function(){
        $(".responsibility-field:first").append("<a href='javascript:void(0);' onclick='add_more_responsibility.add();' id='add_responsibility_link' class='addMore'>Add more</a>");
    }
}

var ownership_event = {
    init: function(){
        $(".pos-prof-ownership-icon a").live("click",function(){
            ownership_event.clear_all_selection();
            $(this).children("img").attr("src","/images/employer/blue_selected_circle.png");
            $("#owner_ship_type_id").val($(this).attr("data-ownership-id"));
            if($(this).attr("data-ownership-id") == "3"){
                $("#ticker-box").show();
            }else{
                $("#ticker-box").hide();
                $("#ticker_value").val("");
            }
        });
    },
    clear_all_selection: function(){
        $(".pos-prof-ownership-icon a img").attr("src","/images/hollow_workenv_img.png");
    }
}

var adjustBasicJobTypeHeight =  function(){
    if($.browser.safari){
//$(".basics-block3-content").css("height",155);
}
}

function showAbout() {
    $("#aboutAbout").removeClass("deactive").addClass("active");
    $("#aboutCoreValues").addClass("deactive");
    $("#aboutTeam").addClass("deactive");
    $("#aboutLab").addClass("deactive");
    $("#aboutPress").addClass("deactive");
    $("#aboutContact").addClass("deactive");

    $("div#about-about").show();
    $("div#about-corevalues").hide();
    $("div#about-team").hide();
    $("div#about-lab").hide();
    $("div#about-press").hide();
    $("div#about-contact").hide();
}

var jobcodelogin_submit = function(){
    if($("#job_code_login").val()==""){
        return false;
    }
    show_job_with_code($("#job_code_login").val());
}

var show_job_with_code = function(job_code){
    lighty.fadeBG(true);
    lighty.fade_div_layer(150,750);
    $.ajax({
        url: '/account/show_job_for_code',
        data: "job_code=" + job_code,
        cache: false,
        success: function(data) {
            $("#fade_layer_div").html(data);
        }
    });
}
function checkEnterGiftBilling(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#gifts_payment_verify_button").hasClass("buy-gift-button-active")){
            $('#form_gift_payment').submit();
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
        $('.popup-bottom').css({
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
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                $("#gift_cc_billing_popup #payment_header").html("UNABLE TO VERIFY");
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
        $('#payment_header').html("UNABLE TO VERIFY");
        $('#gift_cc_billing_popup #payment_header').html("UNABLE TO VERIFY");
        $("#paypal_error_msg").show();
        $("#paypal_error_msg").html("Please check your payment information and try again.");
        showErrorShadow();
        centralizePopup();
    },
    checkout_billing_info: function(){
        hideBlockShadow();
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
        hideErrorShadow();
        $("#login_error").hide();
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

var click_gift_hilo = {
    gift_hilo: function(session_exist){
        showGiftHiloPopup(session_exist);

    },
    gift_hilo_show: function(){
        showBlockShadow();
        $.ajax({
            url: '/ajax/show_gift_hilo',
            cache: false,
            success: function(){
                hideBlockShadow();
            }
        });
    },
    gift_hilo_hide: function(){
        hideGiftHiloPopup();
    }
}

/********* Gift Hilo *********/
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
function validateNotEmpty_ta(element) {
    if(($("#"+element.id).parent().parent().hasClass("active-input") || $("#"+element.id).parent().parent().hasClass("input-text-active") || $("#"+element.id).parent().parent().hasClass("input-text-error") ) && validateRequired(element.value)) {
        return true;
    }
    else {
        return false;
    }
}

function checkEnterCheckoutBilling(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#gifts_payment_verify_button").hasClass("buy-gift-button-active")){
            $('#chechout_billing_form').submit();
        }

    }
}

/********* Gift Hilo *********/

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

    if(validateNotEmpty(remail) && validateNotEmpty(v_reEmail) && validateEmail(remail.value) && validateEmail(v_reEmail.value) && remail.value==v_reEmail.value && errorBox.innerHTML==""){
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
    hideBlockShadow();
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
        }

    });
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

    if(validateNotEmpty(card_num) && validateNotEmpty(month)&& validateNotEmpty(year) && validateNotEmpty(cvv) && validateNotEmpty(fname)&& validateNotEmpty(lname) && validateNotEmpty(billing_address_one) && validateNotEmpty(billing_city) && validateNotEmpty(billing_zip) && validateNotEmpty(billing_area_code)&& validateNotEmpty(billing_telephone_number)  && validateRequired(billing_state.value)  && (billing_telephone_number.value.length == 7)  && (card_num.value.length == card_length) && (billing_zip.value.length >= 3) && (billing_area_code.value.length == 3) && (cvv.value.length == cvv_length) && payment_card_type.value != ''){
        //alert("Done");
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

function redirectToPaypal_gifthilo(){
    url = $("#page_url_job").val();
    showBlockShadow();
    window.location.href = "/gift/gift_hilo_payment?payment_type=paypal_express&url=" + url;


}

function checkHiloCredentialsEntered(current_element) {
    username_gift = document.getElementById('username_gift');
    password_gift = document.getElementById('password_gift');

    if(validateNotEmpty(username_gift) && validateNotEmpty(password_gift)) {
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


// Calls a wibndow.open and uses url as params, also opens popup in center of window

function setCardTypeGift(card_type) {
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
    } else if(card_type=="visa") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='visa' id='visa' />");
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
    } else if(card_type == "american_express") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='american_express' id='american_express' />");
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
    } else if(card_type == "discover") {
        $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='discover' id='paypal' />");
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
                $('#card_entry_form_gift').html("<input type='hidden' name='card_type' value='paypal' id='paypal' />");
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
    }
    $('#cvv_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#cvv_gift').parent().addClass('input-text');
    changeInputType(document.getElementById("cvv_gift"),"text","");
    $('#cvv_gift').val('Security Code');

    $('#card_num_gift').parent().removeClass('input-text input-text-active active-input input-text-error');
    $('#card_num_gift').parent().addClass('input-text');
    $('#card_num_gift').val('Credit Card Number');

    validateGiftCreditCardInfo();
    addFocusTextField('username_gift');
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
        //                //setCardTypeGift('master');
        //                $("#senders_name_pay").val($('#senders_name').val());
        //                $("#senders_email_pay").val($('#senders_email').val());
        //                $("#recievers_name_pay").val($('#recipients_name').val());
        //                $("#recievers_email_pay").val($('#recipients_email').val());
        //                $("#personal_msg_pay").val($('#personal_msg').val());
        //                //$("#gifts_payment_verify_button").show();
        }

    });
}

function showGiftHiloPopup(session_exist) {
    showNormalShadow();
    $('#gift_hilo_popup').show();
    centralizePopup();
    if (session_exist == 'false')
        addFocusTextField('senders_name');
    else
        addFocusTextField('recipients_name');
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

function validateTelGift(){
    var billing_telephone_number = document.getElementById("billing_telephone_number_gift");
    if(billing_telephone_number.value.length==7) {
        $("#"+billing_telephone_number.id).parent().removeClass("input-text-error");
        $("#"+billing_telephone_number.id).parent().addClass("input-text-active");
    }
}

function validateAreaCodeGift(){
    var billing_area_code = document.getElementById("billing_area_code_gift");
    if(billing_area_code.value.length==3) {
        $("#"+billing_area_code.id).parent().removeClass("input-text-error");
        $("#"+billing_area_code.id).parent().addClass("input-text-active");
    }
}

function validateZipGift(){
    var billing_zip = document.getElementById("billing_zip_gift");
    if(billing_zip.value.length>2) {
        $("#"+billing_zip.id).parent().removeClass("input-text-error");
        $("#"+billing_zip.id).parent().addClass("input-text-active");
    }

}

var load_map_script = function(){
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://maps.google.com/maps/api/js?sensor=false&callback=render_map";
    document.body.appendChild(script);
}

var geocoder;
var map;

var render_map = function(){
    geocoder = new google.maps.Geocoder();
    var myLatlng = new google.maps.LatLng(lat,longi);
    var myOptions = {
        zoom: 8,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControlOptions: false
    }
    map = new google.maps.Map(document.getElementById("map_container"), myOptions);




    var marker = new google.maps.Marker({
        map: map,
        position: myLatlng
    });


}

var consider_job = {
    call: function(job_id){
        $.ajax({
            url: '/job_payment/index',
            data: "job_id=" + job_id + "&pay_for=consider",
            cache: false,
            success: function(data) {
                $("#detailed_comparison").html(data);
            }
        });
    }
}

function addFocusTextField(id){
    document.getElementById(id).focus();
}

function addFocusButton(id){
    $('#'+id).focus();
}