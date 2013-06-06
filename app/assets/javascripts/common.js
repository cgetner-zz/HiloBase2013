/**
 * handling event propagation stopping for different browsers
*/ 
var stopping_propagation = function(e){
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
}

var body_load_function = function(){
    //hide_popup_on_body_click();
    adjustSafarilh();
    //column_height_adjust();
    date_auto_format.init();
}

function showBlockShadow(){
    hideRefreshLink();
    $("#fade_block").show();
//    $("#moving-dots").Loadingdotdotdot({
//        "speed": 400,
//        "maxDots": 3,
//        "word": "Loading "
//    });
//    $("#moving-dots span").css({'position':'relative','width':'60px','text-align':'left','display':'inline-block'});
}

function hideBlockShadow(){
    $("#fade_block").hide();
//    $("#moving-dots").Loadingdotdotdot("Stop");
}

function hideFBBlockShadow(){
    $("#fb_dialog_cancel_button").unbind("click").bind("click",function(){
        hideBlockShadow();
    });
    $("#fb_popup_blocked_cancel").unbind("click").bind("click", function(){
        hideBlockShadow();
    });
    $("#fb_popup_blocked_connect").mouseup(function(){
        hideBlockShadow();
    });
}

var date_auto_format = {
    init: function(){
        $(".date-auto-format").live("keyup",function(e){
            date_auto_format.format($(this),e);
        });

        $(".date-auto-format").live("blur",function(){
            date_auto_format.remove_last_hyphen($(this));
        });
    },
    format: function(ele,e){
        if(e.which == 8){
            return false;
        }
        var str = "";
        var val = new String($(ele).val().replace(/\-/g, ""));
        for (var x=0; x < val.length; x++){
            str += val.charAt(x);	
					
            if(x<7)
            {
                if ((x + 1) % 3 == 0){
                    str += "-";
                }
            }
            /* To change the format of Phone to (3-3-4) */
            else 
            {
                if(x==9){
                    break;
                }
            }	
        }
        $(ele).val(str);	
    },
    remove_last_hyphen: function(ele){
        var str_val = new String($(ele).val());
        if (str_val.charAt(str_val.length - 1) == "-"){
            str_val = str_val.substring(0,(str_val.length - 1))
        }
        $(ele).val(str_val);
    }
}


/**
 * for adding event to all the menus with class 'body-click-hide' to 
 * close out when user clicks anywhere on the browser other than the 
 * menu itself
*/

var hide_popup_on_body_click = function() {
    $('body').click(function(e) {
        //Hide the menus if visible
        $(".body-click-hide").each(function() {

            if ( $(e.target).parents("div.body-click-hide").size() < 1 && $(this).is(':visible') == true) {
                $(this).hide();
                current_login_div = null;
            }
        });
    });
}


var adjustSafarilh = function(){
    if($.browser.safari){
        $('.safari-lh').each(function(){
            var lh =  parseInt($(this).css("line-height"),10) + 1 + 'px';
            $(this).css("line-height",lh);
        });
    }	
}



var column_height_adjust = function(){
    $(window).scroll(function(){
        adjust_left_panel_height();
    });	
    adjust_left_panel_height();
}

var timer_left_panel_adjust = function(){
    setTimeout("adjust_left_panel_height()", 200);
}

var adjust_left_panel_height = function(){

    if($(".right-menu-adjust").first().height() > $(".left-menu-adjust").first().height()){
        var new_height = $(".right-menu-adjust").first().height() + 10;
        $(".left-menu-adjust").first().height(new_height);
    }
}


var unescape_str = function(str){
    str = decodeURIComponent(str);
    str = unescape(str.replace(/\+/g, " "));			
    return str;
}

var unescape_str_new = function(str){
    //str = decodeURIComponent(str);
    return str;
}

var msg_box  ={
    header_msg: "OOPS!",
    show_error: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        var error_str ="";
        var json_error = eval(msg_json);
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "<br/>";
        }
        $("#error-list").html(error_str);
        return false;
    },
    create_box: function(){
        $("#light_normal_error").remove();	
        $(this.div_content);
        var err_element = $(msg_box.div_content());
        $("body").append(err_element);
        $('#light_normal_error').css('display','block');
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_error").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_error" class="white_content"><div class="popup-upper-block"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="home-popup-error"><p class="lfloat">'+msg_box.header_msg+'<br><span id="error-list"></span></p><a href="javascript:_closeSignInFailure()" class="green-btn-active rfloat retry"><span>Retry >></span></a></div><a href="javascript:void(0)" class="close" onClick="_closeSignInFailure2()">Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_error").remove();	
        event.stopPropagation();
    }
	
}

var fp_error_box  ={
    header_msg: "OOPS!",
    show_error: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        var error_str ="";
        var json_error = eval(msg_json);
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "<br/>";
        }
        $("#error-list").html(error_str);
        return false;
    },
    create_box: function(){
        $("#light_normal_error").remove();	
        $(this.div_content);
        var err_element = $(fp_error_box.div_content());
        $("body").append(err_element);
        $('#forgot_password').hide();
        $('#light_normal_error').css('display','block');
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_error").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_error" class="white_content"><div class="popup-upper-block"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="home-popup-error"><p class="lfloat">'+fp_error_box.header_msg+'<br><span id="error-list"></span></p><a href="javascript:_closeErrorBox();_forgotPassword();" class="green-btn-active rfloat retry"><span>Retry >></span></a></div><a href="javascript:void(0)" class="close" onClick="_closeErrorBox();">Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_error").remove();	
        event.stopPropagation();
    }
	
}

var fp_success_box  ={
    header_msg: "SUCCESS!",
    show_msg: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        return false;
    },
    create_box: function(){
        $("#light_normal_success").remove();	
        $(this.div_content);
        var err_element = $(fp_success_box.div_content());
        $("body").append(err_element);
        $('#forgot_password').hide();
        $('#light_normal_success').show();
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_success").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_success" class="white_content"><div class="popup-upper-block"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="home-popup-error"><p class="lfloat">'+fp_success_box.header_msg+'<br><span id="error-list">A link to reset your password has been sent to your email.</span></p><a href="javascript:_closeSucessOverlay();" class="green-btn-active rfloat retry"><span>Enter >></span></a></div><a href="javascript:_closeSucessOverlay();" class="close" >Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_success").remove();	
        event.stopPropagation();
    }
	
}

var beta_error_box  ={
    header_msg: "OOPS!",
    show_error: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        var error_str ="";
        var json_error = eval(msg_json);
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "<br/>";
        }
        $("#error-list").html(error_str);
        return false;
    },
    create_box: function(){
        $("#light_normal_error").remove();	
        $(this.div_content);
        var err_element = $(beta_error_box.div_content());
        $("body").append(err_element);
        $('#light_normal_error').css('display','block');
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_error").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_error" class="white_content"><div class="popup-upper-block"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="home-popup-error"><p class="lfloat">'+msg_box.header_msg+'<br><span id="error-list"></span></p><a href="javascript:_closeErrorBox();_normalOverlay();" class="green-btn-active rfloat retry"><span>Retry >></span></a></div><a href="javascript:void(0)" class="close" onClick="_closeErrorBox();">Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_error").remove();	
        event.stopPropagation();
    }
	
}

var beta_success_box  ={
    header_msg: "BETA ACCESS GRANTED!",
    show_msg: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
		
        return false;
    },
    create_box: function(){
        $("#light_normal_success").remove();	
        $(this.div_content);
        var err_element = $(beta_success_box.div_content());
        $("body").append(err_element);
        $('#light_normal_success').show();
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_success").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_success" class="white_content"><div class="popup-upper-block"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="home-popup-error"><p class="lfloat">'+beta_success_box.header_msg+'<br><span id="error-list">Check your email for your unique beta access code.</span></p><a href="/job_seeker/new" class="green-btn-active rfloat retry"><span>Enter >></span></a></div><a href="/job_seeker/new" class="close" >Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_success").remove();	
        event.stopPropagation();
    }
}

Array.prototype.in_array = function(p_val) {
    var position = -1;
    for(var i = 0, l = this.length; i < l; i++) {
        if (arguments.length > 1)
        {
            if(this[i].toLowerCase() == p_val.toLowerCase()) {
                position = i;	
                return position;
            }
        }else{
            if(this[i] == p_val) {
                position = i;	
                return position;
            }
        }
    }
    return position;
}

var msg_box_check_payment  ={	
    show_error: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        var error_str ="";
        var json_error = eval(msg_json);
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "<br/>";
        }
        $("#error-list").html(error_str);
        return false;
    },
    create_box: function(){
        $("#light_normal_error").remove();	
        $(this.div_content);
        var err_element = $(msg_box_check_payment.div_content());
        $("body").append(err_element);
        $('#light_normal_error').css('display','block');
        $(".home-popup-error").show();
        $(".home-popup-error").focus();
        $("#fade_error").show();
    },
    div_content: function(){
        var str = '<div id="light_normal_error" class="white_content"><div class="popup-siteActivation"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="gradient-content"><div class="popup-header-container"><label class="popup-heading">CODE NOT RECOGNIZED</label></div><div class="payment-options"><div class="home-popup-error"><p class="lfloat"><span id="error-list"></span></p><a href="javascript:void(0)" onclick="_closeSignInFailure();_applyPromoCode();" class="green-btn-active rfloat retry"><span>Retry >></span></a></div><a href="javascript:void(0)" class="close" onClick="_closeSignInFailure2()">Close</a></div></div></div></div>';
        return str;
    },
    close_error: function(event){
        $("#light_normal_error").remove();	
        event.stopPropagation();
    }
	
}


var finish_payment = {
    show_finish_popup: function(card_type){
        var header_msg = "";
        if (card_type == "master" || card_type == "visa" || card_type == "american_express" || card_type == "discover"){
            header_msg = "CREDIT CARD BILLING INFORMATION";
        }
        else {
            header_msg = "SIGN IN TO PAYPAL";
        }
        this.create_box(header_msg);
        var error_str ="";		
        return false;
    },
    create_box: function(header_msg){
        $("#cc_billing_popup").remove();	
        $(this.div_content);
        var err_element = $(finish_payment.div_content(header_msg));
        $("body").append(err_element);
        $('#cc_billing_popup').css('display','block');		
    },
    div_content: function(header_msg){
        var str = "";
        if (card_type == "master" || card_type == "visa" || card_type == "american_express" || card_type == "discover"){
            str = '<div id="cc_billing_popup" class="white_content"><input type="hidden" value="" name="payment_type" id="payment_type"/><div class="popup-siteActivation"><span class="popup-top">&nbsp;</span><div class="popup-content"><div class="gradient-content"><div class="popup-header-container"><label class="popup-heading">"+header_msg+"</label></div><ul class="payment-options"><li><a href="javascript:void(0);" title="Master Card"><img src="/assets/master-card.png" alt="Master Card" height="25" width="42" /></a></li><li><a href="javascript:void(0);" title="Visa"><img src="/assets/visa-card.png" alt="Visa Card" height="25" width="40" /></a></li><li><a href="javascript:void(0);" title="American Express"><img src="/assets/americanExpress-cardd.png" alt="American Express" height="25" width="25" /></a></li><li><a href="javascript:void(0)" title="Discover"><img src="/assets/discover-card.png" alt="Discover" width="40" height="25" border="0" /></a></li><li><a href="javascript:void(0);" title="PayPal" class="payPal"><img src="/assets/paypal.png" alt="Pay Pal" height="15" width="56" /></a></li></ul><div class="credit-card-info"><input id="card_num" type="text" name="card_num" class="text-credit-card active" value="Credit Card Number" /><input id="month" type="text" name="month" class="text-month" value="mm" /><img src="/assets/seperator-MMYY.png" height="33" width="10" class="mmyySeperator" /><input id="year" type="text" name="year" class="text-year" value="YYYY" /><input id="cvv" type="text" name="cvv" class="text-securityCode" value="Security Code" /></div><div class="personal-info"><ul class="payment-options"><li><input id="fname" type="text" name="fname" value="First Name" class="text-fname margin-R-22px" /><input id="lname" type="text" name="lname" value="Last Name" class="text-lname" /></li><li><%=text_field_tag :billing_address_one,@payment.billing_address_one, :placeholder => "Billing Address" ,:class=>"text-billingAddress"%></li><li><%=text_field_tag :billing_address_two,@payment.billing_address_two, :placeholder => "Apt., suite, bldg." ,:class=>"text-billingAddress"%></li><li><%=text_field_tag :billing_city,@payment.billing_city, :placeholder => "City" ,:class=>"text-city"%><%=select_tag("billing_state", options_for_select(State.find(:all).map {|s| [s.name]}.unshift(["State",""]),@payment.billing_state),:class=>"reg-field-text reg-field-select") %><%=text_field_tag :billing_zip,@payment.billing_zip, :placeholder => "Zip Code" ,:class=>"text-zip"%></li><li class="lastChild"><%=text_field_tag :billing_area_code, "", :placeholder => "(Area Code)" ,:class=>"text-areaCode"%><%=text_field_tag :billing_telephone_number, "", :placeholder => "Telephone" ,:class=>"text-telephone"%><input type="submit" value="FINISH >>" /></li></ul></div></div><a href="javascript:void(0)" class="close" onClick="_closeCCBillingInfo()">Close</a></div><span class="popup-bottom">&nbsp;</span></div></div></div></div>';
        }
        else{
            str = '<div id="paypal_popup" class="white_content"><div class="popup-siteActivation"><span class="popup-top">&nbsp;</span><div class="popup-content">		<div class="gradient-content"><div class="popup-header-container"><label class="popup-heading">SIGN IN TO PAYPAL</label></div><ul class="payment-options"><li><a href="javascript:void(0);" title="Master Card"><img src="/assets/master-card.png" alt="Master Card" height="25" width="42" /></a></li><li><a href="javascript:void(0);" title="Visa"><img src="/assets/visa-card.png" alt="Visa Card" height="25" width="40" /></a></li><li><a href="javascript:void(0);" title="American Express"><img src="/assets/americanExpress-cardd.png" alt="American Express" height="25" width="25" /></a></li><li><a href="javascript:void(0)" title="Discover" onclick="_openCCBillingInfo()"><img src="/assets/discover-card.png" alt="Discover" width="40" height="25" border="0" /></a></li><li><a href="javascript:void(0);" title="PayPal" class="payPal"><img src="/assets/paypal.png" alt="Pay Pal" height="15" width="56" /></a></li></ul><div class="paypal-info"><ul><li><input type="text" value="PayPal Username" class="paypal-email active" /><input type="password" value="PayPal Password" class="paypal-password" /></li><li><input type="image" src="images/signIn-payPal.png" class="signInpal"  /></li></ul></div></div><a href="javascript:void(0)" class="close" onClick="_closePaypalPopup()">Close</a></div><span class="popup-bottom">&nbsp;</span></div></div>';
        }
        return str;
    },
    close_error: function(event){
        $("#cc_billing_popup").remove();	
        event.stopPropagation();
    }
}


var check_payment_options = {
    init: function(){
        var str_params = this.param_str();
        $("#payment_loader").show();
        $.ajax({
            url:"/payment/check_payment_options",
            cache: false,
            data: str_params,
            success: function(){
                $("#payment_loader").hide();
            }
        });
    },
    param_str: function(){
        var str_params = "promotional_code=" + $("#promotional_code").val();
        str_params += "&payment_type=" + $("#payment_type").val();	 
        return str_params;
    },
    submit_payment_form: function(){
        $("#new_payment").submit();
    },
    show_confirmed_code_msg: function(){
        $('#get_promo_code_popup').hide();
        $('#fade_normal').hide();
        showSuccessShadow();
        $("#code_confirmed_popup").show();
        centralizePopup();
    },
    show_message: function(msg){
        msg_box_check_payment.show_error("[{msg: '" + msg + "'}]");		
    },
    show_error_message: function(){
        hideNormalShadow();
        showErrorShadow();
        $('#payment_header').text("UNABLE TO VERIFY");
        $("#paypal_error_msg").show();
        $("#paypal_error_msg").html('Please check your payment information and try again.');
        $('#verify-loader-img').hide();
        $('#payment_verify_button').show();
    },
    payment_success_message: function(){
        $('#cc_billing_popup label.popup-heading').text("CREDIT CARD PAYMENT VERIFIED!");
        $('div.error-message-container').hide();
        $('#verify-loader-img').hide();
        $('div#fade_error').hide();
        $('div#fade_normal').hide();
        $('div#fade_success').show();
        $("#cc_completed_msg").show();
        $("#payment_verify_button").hide();
        $("#finish-button-success").show();
    },
    confirm_message: function(msg){
        payment_msg_box.show_error("[{msg: '" + msg + "'}]","Confirm");		
    },
    error_message_csv2: function() {
        $("#jw_player").hide();
        $("#fade_normal").hide();
        $("#fade_error").show();
        $('#get_promo_code_popup').hide();
        $("#code_error_popup").show();
        centralizePopup();
        addFocusButton('code_error_popup_button');
    },
	
    success_message_csv2: function() {
        $("#jw_player").hide();
        $("#fade_success").show();
        $("code_confirmed_popup").show();
        centralizePopup();
        addFocusButton('code_confirmed');
    }
	
}

payment_all_by_promo_code = function(){
    $("#payment_by_promo").hide();
    $("#payment-loader-img").show();
    $.ajax({
        url:"/payment/make_payment",
        cache: false,
        data: "payment_type=promo",
        success: function(){
            payment_pro_express_promo();
            
        }
    });

}

payment_after_full_discount = function(){
    $("#payment_by_express").hide();
    $("#payment-loader-img").show();
    $.ajax({
        url: "/payment/credit_create_after_full_discount",
        cache:false,
        success: function(){
            payment_pro_express_promo();
        }
    });
}

payment_pro_express_promo = function(){
    $("#payment_by_express").hide();
    $("#payment-loader-img").show();
    $.ajax({
        url: "/payment/set_completion_step",
        cache: false,
        success: function(){
            push_test_submission();
        }
    })
}

var disable_payment_field_options = function(){
    $("#paypal_payment_option").find("input").attr("disabled", true).val("");
    $("#paypal_payment_option").find("select").attr("disabled",true)
}

var enable_payment_field_options = function(){
    $("#paypal_payment_option").find("input").removeAttr("disabled"); 
    $("#paypal_payment_option").find("select").removeAttr("disabled"); 
    $(".payment_type_option").first().val("paypal_pro");
    $(".payment_type_option").last().val("paypal_express");
}

var toggle_payment_option = function(type){
    var ele_arr = document.getElementsByName("transaction_type[]");
    for(var i =0; i < ele_arr.length;i++){
        if (ele_arr[i].value != type){
            ele_arr[i].checked = false;
        }

        if (ele_arr[i].value == 'new'){
            if (ele_arr[i].checked == true){
                enable_payment_field_options();
            }else{
                disable_payment_field_options();
            }
        }
    }	

    if(type == 'new'){
        $("#paypal_payment_option").slideDown();
    }else{
        $("#paypal_payment_option").slideUp();
    }

    timer_left_panel_adjust();
}

var payment_view = {
    toggle: function(type){
        if(type == "paypal_express"){
            $("#carddetails_form").slideUp();
            $("#promocode_form").slideUp();
            $("#express_form").slideDown();

            $("#payment_type").val("paypal_express");
        }else if(type == "paypal_pro"){
            $("#promocode_form").slideUp();
            $("#express_form").slideUp();
            $("#carddetails_form").slideDown();
            $("#payment_type").val("paypal_pro");
        }else if(type == "promocode_form"){
            $("#express_form").slideUp();
            $("#carddetails_form").slideUp();
            $("#promocode_form").slideDown();
        }
		
        this.change_img(type);
    },
    change_img: function(type){
        $(".payment-opt-box").each(function(index){
            var img = $(this).find("img").first();
            var unselected = $(img).attr("src").replace("_selected","");
            $(img).attr("src", unselected);
			
            var selected_arr = unselected.split(".");
            selected_arr[0] = selected_arr[0] + "_selected";
            if (type == "paypal_pro" && index == 0){
				
                $(img).attr("src", selected_arr.join("."));	
            }
            if (type == "paypal_express" && index == 1){
                $(img).attr("src", selected_arr.join("."));
            }
            if (type == "promocode_form" && index == 2){
                $(img).attr("src", selected_arr.join("."));
            }
        });
    }
}


var payview_msg_box  ={
    header_msg: "Oops!",
    show_error: function(msg_json){
        if (arguments.length > 1){
            this.header_msg = arguments[1]
        }
        this.create_box();
        var error_str ="";
        var json_error = eval(msg_json);
        for (var i=0;i < json_error.length ;i++ )
        {
            error_str += unescape_str(json_error[i].msg) + "<br/>";
        }
        $("#error-list").html(error_str);
        $(".error-outer-box").show('slow');
        $(".error-outer-box").focus();
        return false;
    },
    create_box: function(){
        $(".error-outer-box").remove();	
        $(this.div_content);
        var err_element = $(payview_msg_box.div_content());
        $("body").append(err_element);
        var brow_width = document.body.scrollWidth;
        var width = 400;
        half_width = parseInt(width)/2;
        half_brower = parseInt(brow_width)/2;
        new_left = half_brower - half_width - 50;
        var top_pos = $("body").scrollTop() + 270;
        $(".error-outer-box").css("top", top_pos + "px");
        $(".error-outer-box").css("left", (new_left + "px"));
    },
    div_content: function(){
        var str ='<div class="error-outer-box" style="display:none;"><div><img src="/assets/midsize-bordertop.png"/></div><div class="error-inner-box"><div class="error-content"><div class="error-header">' + payview_msg_box.header_msg + '</div><div id="error-list"><div class="error-border" ></div></div><div  class="error-ok"><div class="pos-left" style="margin-right: 5px;">	<a href="javascript:void(0);" onclick="job_view_pay.submit_form();" class="button-a buttton_65X23">Ok</a></div>		<div class="pos-left" >	<a href="javascript:void(0);" onclick="payview_msg_box.close_error(event);" class="button-a buttton_65X23">Cancel</a></div><br class="clear"/></div><br class="clear"/></div></div><div ><img src="/assets/midsize-borderbottom.png"/></div></div></div>';
        return str;
    },
    close_error: function(event){
        $(".error-outer-box").remove();	
        if (typeof(event) != "undefined")
        {
            event.stopPropagation();
        }
    }
}
function job_seeker_email(job_id, share_platform_id)
{
    $.ajax({
			
        url: '/ajax/job_seeker_email',
        data: "job_id=" + job_id + "&platform_id=" + share_platform_id,
        cache: false,
        success:function(){
        }
    });	
	
	
}

var share_job = {
    menu_html: "",
    apply_menu: function(){
        share_job.menu_html = $("#share_option_menu_content").html();
        $("#share_option_menu_content").html("");
        $(".org-col_share > img").each(function(){
            var job_id = $(this).attr("id").split("_")[2];
            var menu_content = share_job.menu_content(job_id);	
            $(this).qtip({
                content:  menu_content, // Set the tooltip content to the current corner
                position: {
                    corner: {
                        tooltip: 'bottomRight', // Use the corner...
                        target: 'rightMiddle' // ...and opposite corner
                    }
                },
                show: {
                    when: "click", // Don't specify a show event
                    ready: false // Show the tooltip when ready
                },
                hide: {
                    fixed: true, 
                    delay: 1000
                }, // Don't specify a hide event
                style: {
                    background: '#F1F5F8',
                    color: '#000078',
                    border: {
                        width: 5,
                        radius: 5,
                        color: '#C3D3DF'
                    },
                    padding: 10, 
                    textAlign: 'left',
                    //  tip: true, // Give it a speech bubble tip with automatic corner detection
                    name: 'blue' // Style it according to the preset 'cream' style
                }
            });
        });	
    },
    menu_content: function(job_id){
        str = this.menu_html.replace(/__jobId__/g,job_id);
        return str;
    },
    share: function(platform_id,job_id){

        $.ajax({

            url: '/share_job/share',
            data: "job_id=" + job_id + "&platform_id=" + platform_id,
            cache: false,
            success:function(){

            }
        });
    },
    share_job_job_seeker: function(platform_id, job_id){
        showBlockShadow();
        var url = $("#page_url_job").val();
        $.ajax({

            url: '/share_job/share',
            data: "job_id=" + job_id + "&platform_id=" + platform_id + "&url=" + url,
            cache: false,
            success:function(){

            }
        });
    },
    error_msg: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]");
    },
    success_msg: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]","Success");
    },
    success_msg_emp: function(msg){
        window.location.reload();
    },
    success_msg_js: function(msg){
        hideBlockShadow();
        $('div.black_overlay').hide();
        $("#fade_success_sharing").show();
        $("#posting-success-job-seeker").show();
        $("#sharing_msg").html(msg);
        $('div.popup-upper-block-positionPrevew').css('z-index','1004');
        centralizePopup();
        addFocusButton('posting-success-job-seeker_button');
    },
    job_not_active: function(msg){
        hideBlockShadow();
        $('div.black_overlay').hide();
        $("#fade_error_warning").show();
        $("#posting_job_not_active_job_seeker").show();
        $("#job_not_active_sharing_msg").html(msg);
        $('div.popup-upper-block-positionPrevew').css('z-index','1004');
        centralizePopup();
        addFocusButton('posting_job_not_active_job_seeker_button');
    },
    request_fb_login: function(){
        FB.Connect.requireSession(function(){
            share_job.fb_status_permission();
        },function(){});
        hideFBBlockShadow();
    },
    fb_login: function(){
        FB.login(function(response) {
            if (response.authResponse) {
                //console.log('Welcome!  Fetching your information.... ');
                $.ajax({
                    url: '/share_job/send_fb_status',
                    cache: false
                });
            } else {
                //console.log('User cancelled login or did not fully authorize.');
                hideBlockShadow();
            }
        },
        {
            scope: 'publish_stream' // I need this for publishing to Timeline
        });
    },
    skip_exception: function(){
        hideBlockShadow();
    },
    fb_status_permission: function(){
        FB.Connect.showPermissionDialog('status_update', function(accepted) {
            if(accepted == "status_update,publish_stream"){
                share_job.send_fb_status();
            }
        } );
    },
    send_fb_status: function(){
        $.ajax({
            url: '/share_job/send_fb_status',
            cache: false
        });
    },
    logout_fb: function(){
        FB.Connect.logout();
    },
    open_linkedin_login : function(authorize_url){
        window.open(authorize_url);
    },
    open_twitter_login : function(authorize_url){
        window.open(authorize_url);
    },
    sharer_log: function(job_id, platform_id, job_seeker_id){
        $.ajax({
            url: '/ajax/capture_log',
            data: 'job_id='+ job_id +'&platform_id=' + platform_id + "&job_seeker_id=" + job_seeker_id,
            cache: false,
            success: function(){
              
            }
        })
    }
}

function showSuccessSharingJSMsg(msg){
    $('div.black_overlay').hide();
    $("#fade_success_sharing").show();
    $("#posting-success-job-seeker").show();
    $("#sharing_msg").html(msg);
    $('div.popup-upper-block-positionPrevew').css('z-index','1004');
    centralizePopup();
    addFocusButton('posting-success-job-seeker_button');
}

function hideSuccessSharing() {
    showNormalShadow();
    $('div#posting-success-job-seeker').hide();
    $("#fade_success_sharing").hide();
}

function hideJobNotActiveSharing(){
    showNormalShadow();
    $("#posting_job_not_active_job_seeker").hide();
    $("#fade_error_warning").hide();
}

var employer_signout_link = function(){
    $("#employer_name_link").qtip({
        content:  $("#employer_account_pop"), // Set the tooltip content to the current corner
        position: {
            corner: {
                tooltip: 'topMiddle', // Use the corner...
                target: 'centertMiddle' // ...and opposite corner
            }
        },
        show: {
            when: "click", // Don't specify a show event
            ready: false // Show the tooltip when ready
        },
        hide: {
            fixed: true, 
            delay: 1000
        }, // Don't specify a hide event
        style: {
            background: '#356A9A',
            color: '#ffffff',
            border: {
                width: 5,
                radius: 5,
                color: '#356A9A'
            },
            padding: 10, 
            textAlign: 'left',
            tip: true, // Give it a speech bubble tip with automatic corner detection
            name: 'blue' // Style it according to the preset 'cream' style
        }
    });

}
var pairingvalue_job_seeker = function(){
    $.ajax({
        url: '/pairing_logic/pairing_value_job_seeker1',
        cache: false,
        success: function(){
            window.location.href = "/account"
        }
    });

}

var pairingvalue_job = function(){
    $.ajax({
        url: '/pairing_logic/pairing_value_job' ,
        cache: false,
        success: function(data){

        }
    });
}

var BrowserDetect = {
    init: function () {
        this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
        this.version = this.searchVersion(navigator.userAgent)
        || this.searchVersion(navigator.appVersion)
        || "an unknown version";
        this.OS = this.searchString(this.dataOS) || "an unknown OS";
    },
    searchString: function (data) {
        for (var i=0;i<data.length;i++)	{
            var dataString = data[i].string;
            var dataProp = data[i].prop;
            this.versionSearchString = data[i].versionSearch || data[i].identity;
            if (dataString) {
                if (dataString.indexOf(data[i].subString) != -1)
                    return data[i].identity;
            }
            else if (dataProp)
                return data[i].identity;
        }
    },
    searchVersion: function (dataString) {
        var index = dataString.indexOf(this.versionSearchString);
        if (index == -1) return;
        return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
    },
    dataBrowser: [
    {
        string: navigator.userAgent,
        subString: "Chrome",
        identity: "Chrome"
    },
    {
        string: navigator.userAgent,
        subString: "OmniWeb",
        versionSearch: "OmniWeb/",
        identity: "OmniWeb"
    },
    {
        string: navigator.vendor,
        subString: "Apple",
        identity: "Safari",
        versionSearch: "Version"
    },
    {
        prop: window.opera,
        identity: "Opera"
    },
    {
        string: navigator.vendor,
        subString: "iCab",
        identity: "iCab"
    },
    {
        string: navigator.vendor,
        subString: "KDE",
        identity: "Konqueror"
    },
    {
        string: navigator.userAgent,
        subString: "Firefox",
        identity: "Firefox"
    },
    {
        string: navigator.vendor,
        subString: "Camino",
        identity: "Camino"
    },
    {		// for newer Netscapes (6+)
        string: navigator.userAgent,
        subString: "Netscape",
        identity: "Netscape"
    },
    {
        string: navigator.userAgent,
        subString: "MSIE",
        identity: "Explorer",
        versionSearch: "MSIE"
    },
    {
        string: navigator.userAgent,
        subString: "Gecko",
        identity: "Mozilla",
        versionSearch: "rv"
    },
    { 		// for older Netscapes (4-)
        string: navigator.userAgent,
        subString: "Mozilla",
        identity: "Netscape",
        versionSearch: "Mozilla"
    }
    ],
    dataOS : [
    {
        string: navigator.platform,
        subString: "Win",
        identity: "Windows"
    },
    {
        string: navigator.platform,
        subString: "Mac",
        identity: "Mac"
    },
    {
        string: navigator.userAgent,
        subString: "iPhone",
        identity: "iPhone/iPod"
    },
    {
        string: navigator.platform,
        subString: "Linux",
        identity: "Linux"
    }
    ]

};
BrowserDetect.init();
if (BrowserDetect.browser == "Firefox" && BrowserDetect.version < "3.6"){
    window.location.href="/error.html";
}

if (BrowserDetect.browser == "Explorer" && BrowserDetect.version < "8"){	
    window.location.href="/error.html";
	
}

if (BrowserDetect.browser == "Safari" && BrowserDetect.version < "5"){	
    window.location.href="/error.html";
}

function showSuccessSharingJSMsg(msg){
    $('div.black_overlay').hide();
    $("#fade_success_sharing").show();
    $("#posting-success-job-seeker").show();
    $("#sharing_msg").html(msg);
    $('div.popup-upper-block-positionPrevew').css('z-index','1004');
    centralizePopup();
    addFocusButton('posting-success-job-seeker_button');
}

function hideSuccessSharing() {
    showNormalShadow();
    $('div#posting-success-job-seeker').hide();
    $("#fade_success_sharing").hide();
}
