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
var senders_name;
var senders_email;
var recievers_name;
var recievers_email;
var personal_msg;
var normal_timeout = 10000;

Array.prototype.clear = function() {
    this.splice(0, this.length);
};

function downloadPaymentCSV(){
    $.ajax({
        url: "/ajax/download_payment_history",
        beforeSend: function() {
            showBlockShadow();
        },
        cache: false
    });
}

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

var load_intro_popup = {
    show: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,563);	
        $("#intro_popup").css("left",$("#fade_layer_div").css("left"));
        $("#intro_popup").css("top",$("#fade_layer_div").css("top"));
        $("#intro_popup").show();
    },
    hide: function(){
        $("#intro_popup").hide();
        lighty.fadeBG(false);
    }
}

var current_login_div = null;

function show_email_popup()
{
    $('#email-popup').show();
    $('#coderequest_email').focus();
	
}

function show_login(click_on,e){

    if(click_on == "code"){
        if (current_login_div == "code")
        {
            $("#login-div").hide();
            current_login_div = null;

        }else{
            if($("#loginbox-topimg").attr("src").indexOf("home") > -1){
                $("#loginbox-topimg").attr("src","/assets/home_loginbox_up_left.png");
            }
            else{
                $("#loginbox-topimg").attr("src","/assets/loginbox_up_left.png");	
            }
            $(".jobcode-section").show();
            $("#login-div").show();
            current_login_div = click_on;
        }
		
    }else{
        if (current_login_div == "signin")
        {
            $("#login-div").hide();
            current_login_div = null;

        }else{
            if($("#loginbox-topimg").attr("src").indexOf("home") > -1){
                $("#loginbox-topimg").attr("src","/assets/home_loginbox_up.png");
            }else{
                $("#loginbox-topimg").attr("src","/assets/loginbox_up.png");	
            }
            $(".jobcode-section").hide();
            $("#login-div").show();
            current_login_div = click_on;
        }
    }
    stopping_propagation(e);
}







var pricing_page = {
    call: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,450);
        $.ajax({
            url: '/home/privacy',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data)
            }
        });
    }
}

var lighty  ={
    fadeBG: function(cond){
        if(cond)
        {
            var divele = document.createElement("div");
            divele.style.position="absolute";
            divele.id="faded_div";
            divele.style.top="0px";
            divele.style.left="0px";
            divele.style.height= $(document).height() +'px';
            divele.style.width=document.body.scrollWidth+"px";
            divele.style.zIndex = 800;
            divele.style.backgroundColor="#000000"; //lighty
            if(navigator.appName.indexOf("Netscape")!=-1 && parseInt(navigator.appVersion)>=5)
                divele.style.opacity = 0.8;
            else if (navigator.appName.indexOf("Microsoft")!= -1 && parseInt(navigator.appVersion)>=4)
                divele.style.filter="alpha(opacity=80)";
            document.body.appendChild(divele);
            this.toggle_embed_tags(false);
        }
        else
        {
            if(document.getElementById('faded_div')) {
                document.body.removeChild(document.getElementById('faded_div'));
            }
        }
    },
    close_fade_bg: function(){
        $('#fade_layer_div').remove();
        this.fadeBG(false);      
        this.toggle_embed_tags(true);
    },
    toggle_embed_tags: function(show){
        if(show){
        //$(".video-embed").show();	
        }else{
    //$(".video-embed").hide();
    }
    },
    fade_div_layer: function(top_adjustment,width){
        var brow_width = document.body.scrollWidth;
        divele = document.createElement("div");
        divele.id=  "fade_layer_div";
        divele.style.position="absolute";
        divele.style.top = (this.browser_top_position() + parseInt(top_adjustment)) + 'px';
        divele.style.width = width + 'px';
        half_width = parseInt(width)/2;
        half_brower = parseInt(brow_width)/2;
        new_left = half_brower - half_width;
        divele.style.left = new_left+'px';
        document.body.appendChild(divele);       
        divele.style.zIndex = 2002;
    //$("#" + divele.id).HTML("<div style='padding:2px;text-align:center;'></div>");
    },
    browser_top_position:function(){
        var ie=document.all && !window.opera
        standardbody=(document.compatMode=="CSS1Compat")? document.documentElement : document.body //create reference to common "body" across doctypes
        scroll_top=(ie)? standardbody.scrollTop : window.pageYOffset
        return scroll_top;
    //alert($("body").scrollTop())
    //return $("body").scrollTop();
    }
}





var reload_page = function(){
    window.location.reload();
}


function toggle_payment_type(checked_type){
    var ele_arr = document.getElementsByName("payment_type[]");
    for(var i =0 ;i< ele_arr.length;i++){
        if(ele_arr[i].value == ("paypal_" + checked_type)){
            ele_arr[i].checked = true;
        }else{
            ele_arr[i].checked = false;
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
            if(document.getElementById("#retry_button_signi_in")){
                addFocusButton('retry_button_signi_in');
            }
            else{
                $('.login_retry_button').focus();
            }
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
            if(document.getElementById("#retry_button_signi_in")){
                addFocusButton('retry_button_signi_in');
            //console.log("aaaaaa");
            }
            else{
                $('.login_retry_button').focus();
            }
            $("#sign_in_close").unbind().bind('click', function(){
                hideErrorLogin_signin();
                $(".footer-links .hilo").removeClass('white');
            });
            $("#retry_button_signi_in").unbind().bind('click', function(){
                $(".footer-links .hilo").removeClass('white');
                setTimeout(function(){
                    $("#login_error").hide();
                    hideErrorShadow();
                    openLoginBox();
                },250);
            });
            centralizePopup();
            addFocusButton('retry_button_signi_in');
        }
    }
}

function hideErrorLogin_signin() {
    hideErrorShadow();
    $("#login_error").hide();
}


var login_page = {
    before_call: function(){
        $('#login-loader').show();
    },
    after_complete: function(status){
        $('#loader-loader').hide();
        if(status){
            window.location.href = "/account/opportunities";
        }else{
            msg_box.show_error("[{msg: 'Your email and password do not match.'}]");
        }
    }
}

function set_save_type(type){
    $(".default-msg").each(function(){
        if ($(this).val() == $(this).attr('default_msg')){
            $(this).val('');
        }
    });
    $("#save_type").val(type);
}

function set_employer_save_type(type){
    $("#save_type").val(type);
}



var follow_company = {
    call: function(company_id,action_type,job_id){
        //beta_trial_msg();
        //return false;
        var sort = "";
        var order="";
        showBlockShadow();
        $.ajax({
            url: '/account/follow_company',
            data: "company_id=" + company_id + "&action_type=" + action_type,
            cache: false,
            success: function(count) {
                hideBlockShadow();
                //$("#following_cnt").html(count);
                $(".following").html(count);
                if($(".following").parent().parent().hasClass('active')){
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
                    fetch_jobs.call('following',sort,order);
                }
                if(action_type=="follow"){
                    $("li#follow input").removeClass("follow-button");
                    $("li#follow input").addClass("following-button");
                    $('.following-button').attr('onclick','');
                    $(".following-button").unbind("click").bind("click",function(){
                        follow_company.call(company_id, "unfollow", job_id);
                    })
                }
                else{
                    $("li#follow input").removeClass("following-button");
                    $("li#follow input").addClass("follow-button");
                    $(".follow-button").attr('onclick','');
                    $.ajax({
                        url: '/account/bind_follow_button',
                        data: 'jobid='+job_id,
                        cache: false,
                        success: function(resp){
                            switch(resp){
                                case "1":
                                    $(".follow-button").unbind("click").bind("click",function(){
                                        follow_company.show_pop(company_id, "follow", job_id, $("#company_name_id").val(), $("#hiring_company_name_id").val());
                                    });
                                    break;
                                case "0":
                                    $(".follow-button").unbind("click").bind("click",function(){
                                        follow_company.call(company_id, "follow", job_id);
                                    });
                                    break;
                            }
                        }
                    });


                }
            }
        });

    //lighty.close_fade_bg();
    },

    show_pop: function(company_id, action_type, job_id, company_name, hiring_company_name){

        $.ajax({
            url: '/account/following_check_popup',
            cache: false,
            success: function(res){
                switch(res){
                    case "1":
                        //$('div.black_overlay').hide();
                        $("#fade_error_warning").show();
                        $("#hiring_company_name").html(hiring_company_name);
                        $(".user_company_name").html(company_name);
                        $("#following_confirmation").show();
                        centralizePopup();
                        addFocusButton('following_confirmation_button');
                        $('#following_confirmation').css('z-index','1006');
                        Custom.init();
                        if($("#follow-check").is(':checked')==true){
                            Custom.check(".checkbox-cont span.checkbox");
                            $("#follow-check").removeAttr("checked");
                        }
                        $(".checkbox-cont span.checkbox").unbind("click").bind("click", function(){
                            follow_company.check();

                        });
                        $(".checkbox-cont label#follow-check-label").unbind("click").bind("click", function(){
                            follow_company.check();
                        });
                        $("#comp_id").val(company_id);
                        $("#jobID").val(job_id);
                        break;

                    case "0":
                        $("#hiring_company_name").html(hiring_company_name);
                        $(".user_company_name").html(company_name);
                        follow_company.call(company_id, action_type, job_id);
                        break;
                }
            }
        })

    },

    check: function(){

        if($("#follow-check").is(':checked')==true){
            $.ajax({
                url: '/account/set_js_follow_check',
                data: 'set=true',
                cache: false,
                success: function(){

                }
            });
        }
        else{
            $.ajax({
                url: '/account/set_js_follow_check',
                data: 'set=false',
                cache: false,
                success: function(){

                }
            });
        }

    },

    close_pop: function(){
        $("#fade_error_warning").hide();
        $("#following_confirmation").hide();
        document.getElementById('following_confirmation_button').blur();
        showNormalShadow();
    }
}

var add_to_watchlist = {
    call: function(job_id, action_type){
        var sort="";
        var order="";
        showBlockShadow();
        $.ajax({
            url: '/account/watchlist',
            data: "job_id="+job_id+"&action_type="+action_type,
            cache: false,
            success: function(count){
                hideBlockShadow();
                $(".watchlist").html(count);
                if($(".watchlist").parent().parent().hasClass('active')){
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
                    fetch_jobs.call('watchlist',sort,order);
                }

                if(action_type=="add"){
                    $("li#watchlist input").removeClass("watchlist-button");
                    $("li#watchlist input").addClass("in-watchlist-button");
                    //document.getElementsByClassName('in-watchlist-button')[0].setAttribute('onclick','');
                    $('.in-watchlist-button').attr('onclick','');
                    $(".in-watchlist-button").unbind("click").bind("click",function(){
                        add_to_watchlist.call(job_id, "remove");
                    })
                }
                else{
                    $("li#watchlist input").removeClass("in-watchlist-button");
                    $("li#watchlist input").addClass("watchlist-button");
                    //document.getElementsByClassName('watchlist-button')[0].setAttribute('onclick','');
                    $('.watchlist-button').attr('onclick','');
                    $(".watchlist-button").unbind("click").bind("click",function(){
                        add_to_watchlist.call(job_id, "add");
                    })
                }
            }
        })
    }
}


/*var follow_job = {
	call: function(job_id){
		follow = $("#follow_" + job_id).attr("checked") ? 1 : 0;
		$.ajax({
			url: '/account/follow_job',
			  data: "job_id=" + job_id + "&follow=" + follow,
     		  cache: false,
			  success: function() {
					if (follow == 1){
						following_count = following_count + 1;
					}else{
						following_count = following_count - 1;
					}
					$("#following_cnt").html(following_count);
			  }
		});
	}
}*/

var back_to_job = function(job_id){
    $.ajax({
        url: '/account/show_job',
        data: "job_id=" + job_id,	
        cache: false,
        success: function(data) {
            timer_left_panel_adjust();
        }
    });
		
}

var show_interest = {
    call: function(job_id,from_comparison_view){
        beta_trial_msg();
        return false;

        var param_str = "job_id=" + job_id + "&pay_for=interest";
        if (from_comparison_view){
            param_str += "&from_view='comparison_view'";
        }
        $.ajax({
            url: '/job_payment/index',
            data: param_str,
            cache: false,
            success: function(data) {
                $("#detailed_comparison").html(data);
            }
        });
    }
}

var wild_card = {
    call: function(job_id,from_comparison_view){
        beta_trial_msg();
        return false;

        var param_str = "job_id=" + job_id + "&pay_for=wild";
        if (from_comparison_view){
            param_str += "&from_view='comparison_view'";
        }
        $.ajax({
            url: '/job_payment/index',
            data: param_str,
            cache: false,
            success: function(data) {
                $("#detailed_comparison").html(data);
            }
        });
    }
}

var beta_trial_msg = function(){
    msg_box.show_error("[{msg: 'This link is not currently active during the Beta trial period.'}]","Beta trial");
}

var hide_comparison_button = function(pay_for){
    lighty.close_fade_bg();
    if(pay_for == "wild"){
        $("#det-comp-wildcard").html("<img src='/assets/wild_card_disabled.jpg'/>");
    }else if(pay_for == "interest"){
        $("#det-comp-interest").html("<img src='/assets/indicate_interest_disabled.jpg'/>");
    }
}

function alter_activity_link_to_ajax(){

    $("ul.activity-list li").each(function(){
        $(this).click(function(){
            $(".small-blocks").each(function() {
                $(this).removeClass("active");
            });
            $(this).parent().parent().parent().parent().addClass("active");

            var url_arr = $(this).attr('href').split("/");
            fetch_jobs.call(url_arr[url_arr.length - 1],"fit","desc");
            return false;
        });
    });
    $("#my_hilo_heading").click(function(){
        $("#hilo_delay_refresh_cnt").hide();
        $(".small-blocks").each(function() {
            $(this).removeClass("active");
        });
        $(this).parent().parent().parent().addClass('active');
        fetch_jobs.call("inbox","fit","desc");
        return false;
    });
}

var active_area = "";

var fetch_jobs = {
    call: function(param,sort,order){
        this.ajax(param,sort,order);
        updateSideMenuCount();

    },
    apply_active_class: function(param){

        $("ul.activity-list li").each(function(){
            if(param!="dashboard") {
                $(this).attr('onclick','');
            }
            $(this).removeClass("active");
        });
        $("." + param).parent().parent().addClass("active");
        active_area = $('.activity-list').find('li.active a').attr('title');
        if(!active_area)
            active_area="Hilo";

    },
    ajax: function(job_type,sort,order){
        $(".loader").show();
        $("#list").empty();
        $("#table_block").unbind("scroll");
        $("#rows_loader").hide();
        active_area = "";
        
        $.ajax({
            url: '/account/get_jobs',
            data: "job_type=" + job_type + "&sort=" + sort + "&order=" + order,
            cache: false,
            beforeSend: function(){
                $("#list").empty();
                hideRefreshLink();
            },
            success:function(html_data){
                //resetSearchChanges();
                fetch_jobs.apply_active_class(job_type);

                $("#ajax").html(html_data);

                $("#hilo_delay_refresh").click(function(){
                    $("#hilo_delay_refresh_cnt").hide();
                    $(".small-blocks").each(function() {
                        $(this).removeClass("active");
                    });
                    $(this).parent().parent().parent().addClass('active');
                    fetch_jobs.call("inbox","fit","desc");
                    return false;
                });
                //
                var arr = new Array();
                //alert($("#search_result_arr").val());
                if($("#search_result_arr").val() != "-1"){
                    var search_arr_val = $("#search_result_arr").val();
                    var search_arr = search_arr_val.split(",");
                    for (var i=0; i< search_arr.length; i++){
                        arr.push(search_arr[i]);
                    }
                    if ($('#list').children().children().length == 0){
                        $('#error_msg_empty_table').show();
                    }
                    $('tr').each(function(){
                        if ($(this).attr('id') != undefined){
                            var id = $(this).attr('id').split('_')[2];
                            $('#error_msg_empty_table').hide();
                            if (!arr.has(id)){
                                $(this).addClass('filter');
                            }
                        }
                    });
                }
                //
                $(".search-container").show();
                $('.status-block').click(function(e){
                    var _position = $(this).offset()
                    var _positionLeft = _position.left-232;
                    var _positionTop = _position.top+18;
                    $("#fade_normal_status").show();
                    $('.status-details').css({
                        'left':_positionLeft,
                        'top':_positionTop,
                        'display':'block'
                    });
                    e.stopPropagation();
                });
                $(".loader").hide();
                $("#list").show();
                $('.status-details').click(function(e) {
                    e.stopPropagation();
                });
                //resizeTable();
                scrollT = $("#table_block").scrollTop();
                scrollM = $("#table_block").scrollTop();
                $("#table_block").unbind("scroll").scroll(function () {
                    fetch_jobs.ajax_rows(job_type,sort,order,scrollT,scrollM,10,5);
                });
            }
        });
    },
    ajax_rows: function(job_type,sort,order,scrollT,scrollM,start,limit){
        //updateSideMenuCount();
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
                url: '/account/get_jobs',
                data: "job_type=" + job_type + "&sort=" + sort + "&order=" + order + "&scroll=true" + "&start=" + start + "&limit=" + limit,
                cache: false,
                success:function(html_data){
                    var check_active_area = $('.activity-list').find('li.active a').attr('title');
                    if(!check_active_area)
                        check_active_area="Hilo";
                    
                    $("#rows_loader").hide();

                    if(check_active_area==active_area)
                        $("#list tbody").append(html_data);

                    $('.status-block').click(function(e){
                        var _position = $(this).offset()
                        var _positionLeft = _position.left-232;
                        var _positionTop = _position.top+18;
                        $("#fade_normal_status").show();
                        $('.status-details').css({
                            'left':_positionLeft,
                            'top':_positionTop,
                            'display':'block'
                        });
                        e.stopPropagation();
                    });
                    $('.status-details').click(function(e) {
                        e.stopPropagation();
                    });
                    job_row_view.init();
                    $("#table_block").unbind("scroll").scroll(function () {
                        fetch_jobs.ajax_rows(job_type,sort,order,scrollT,scrollM,start+limit,limit);
                    });
                },
                error: function() {
                    $("#rows_loader").hide();
                    $("#table_block").unbind("scroll").scroll(function () {
                        fetch_jobs.ajax_rows(job_type,sort,order,scrollT,scrollM_old,start,limit);
                    });
                }
            });
        }

    },
    header_label: function(param){
        var str = "";
        switch(param){
            case "new" :
                str = "New:";
                break;
            case "employer_view" :
                str = "Employers purchased access to your Introduction page to consider you for the following positions:";
                break;
            case "following" :
                str = "Active posts for the companies you are following:";
                break;
            case "expired" :
                str = "Expired Jobs:";
                break;
            case "active" :
                str = "All Active Posts:";
                break;
            case "considering" :
                str = "Jobs you are considering:";
                break;
            case "interested" :
                str = "Jobs you are interested in:"
                break;
            case "wild_card" :
                str = "Wild card posts:"
                break;
            case "archived" :
                str = "Archived posts:"
                break;
        }
        $("#job_type_header").html(str);
    }
}

var enter_jobcode_event = function(){
    $("#enter_job_code").focus(function(){
        if($("#enter_job_code").val() == "Enter Career Code"){
            $("#enter_job_code").val("");
        }
    });

    $("#enter_job_code").blur(function(){
        if($("#enter_job_code").val() == ""){
            $("#enter_job_code").val("Enter Career Code");
        }
    });
}

var career_code = {
    show_err_msg: function(){
        $("#career_code_popup").hide();
        hideNormalShadow();
        $("#career_code_error").show();
        centralizePopup();
        showErrorShadow();
        addFocusButton('career_code_error_button');
    },
    show_preview_success_msg: function(job_id, wasThisRead){
        $('#career_code_popup').hide();
        //showNormalShadow();
        //$('#position_overview').show();
        if(wasThisRead == "true") {
            $("#job_row_"+job_id).children().each(function(){
                if($(this).hasClass("checked")){
                    $(this).removeClass("checked");
                    $(this).html("&nbsp;");
                }
            })
            var count = $(".history").html();
            count = parseInt(count);
            $(".history").html(count+1);
        }
        if($(".history").parent().parent().hasClass('active')){
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
            fetch_jobs.call('history',sort,order);
        }

        showNormalShadow();
        $("#position_overview").show();
        centralizePopup();
    },
    show_details_success_msg: function(){
        $('#career_code_popup').hide();
        showNormalShadow();
        $('#position_details').show();
    }
}

var tc = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(40,550);
        $.ajax({
            url: '/home/t_and_c',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    },
    close: function(){
        lighty.close_fade_bg();
    }
}

var privacy = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(40,550);
        $.ajax({
            url: '/home/privacy',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    },
    close: function(){
        lighty.close_fade_bg();
    }
}

var close_frame = function(){
    parent.lighty.close_fade_bg();
}

var preview = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(60,750);
        var id_str = "iframe_id_" + new Date().getTime();
        var iframe_obj = "<iframe id='" + id_str + "' allowTransparency='true' style='height:578px;width:768px;margin:0px;padding:0px;' frameborder='0' scrolling='no' src='/my_introduction/preview'></iframe>";
        $("#fade_layer_div").html(iframe_obj);
    }
}


var download_file = function(file){
    window.location.href = file;
}



var active_job_link = {
    init:function(){
        if ($("#job_active").val() == "true" || $("#job_active").val() == "1"){
            $("#active_job").removeClass("inactive-job").addClass("active-job");
            $("#active_job").html("Active>>");
        }else{
            $("#active_job").removeClass("active-job").addClass("inactive-job");
            $("#active_job").html("Inactive>>");
        }
        this.apply_menu();
    },
    apply_menu: function(){
        var menu_content = this.menu_content();
        try{
            $("#active_job").qtip("destroy");
        }catch(e){}

        $("#active_job").qtip({
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
                tip: true, // Give it a speech bubble tip with automatic corner detection
                name: 'blue' // Style it according to the preset 'cream' style
            }
        });

    },
    menu_content: function(){
        var active_link = "";
        if ($("#job_active").val() == "true" || $("#job_active").val() == "1"){
            active_link = "<a href='javascript:void(0);' style='text-decoration:underline;' onclick='active_job_link.change_status(0)'>Inactivate Job</a>";
        }else{
            active_link = "<a href='javascript:void(0);' style='text-decoration:underline;' onclick='active_job_link.change_status(1)'>Activate Job</a>";
        }
        return active_link;
    },
    change_status: function(status){
        $("#job_active").val(status);
        active_job_link.init();
    }

}

var toggle_job_codes = function(group_section_id,ele){
    if($(ele).children("img").attr("src").indexOf("arrow_down") > -1){
        $(ele).children("img").attr("src","/assets/arrow_right.png");
    }else{
        $(ele).children("img").attr("src","/assets/arrow_down.png");
    }
    $("#group_section_" + group_section_id).toggle();
}

var toggle_group_section = function(group_section_id,ele){
    if (group_section_id == 'all'){
        if($(ele).parent().parent().find("img").attr("src").indexOf("arrow_down") > -1){
            $(ele).parent().parent().find("img").attr("src","/assets/arrow_right.png");
        }else{
            $(ele).parent().parent().find("img").attr("src","/assets/arrow_down.png");
        }
        $("#company-group-list-section").toggle();
    }else{
        var group_section_row = "#group_row_" + group_section_id;

        if($(group_section_row + " .pos-left-img").find("img").attr("src").indexOf("arrow_down") > -1){
            $(group_section_row + " .pos-left-img").find("img").attr("src","/assets/arrow_right.png");
        }else{
            $(group_section_row + " .pos-left-img").find("img").attr("src","/assets/arrow_down.png");
        }
        $("#group_section_" + group_section_id).toggle();
    }
}



var preview_job = {
    call: function(job_id){
        lighty.fadeBG(true);
        lighty.fade_div_layer(150,698);


        $.ajax({
            url: '/position_organizer/perview_job',
            data: "job_id=" + job_id,
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data)
            }
        });
    }
}

var birkman_report = {
    request_pdf: function(e){
        hideNotification();
        $("#account_popup").hide();
        showNormalShadow();
        $(".popup-loader").show();
        $.ajax({
            url: '/account/request_pdf',
            cache: false,
            timeout: normal_timeout,
            success:function(){
                //$("#career_guide_loader").hide();
                hideNormalShadow();
                $(".popup-loader").hide();
            },
            error: function() {
                $("#account_popup").hide();
                hideNormalShadow();
                $(".popup-loader").hide();
                showPdfAjaxError();
            }

        });

    },
    pending: function(){
        //msg_box.show_error("[{msg: 'Birkman report is still under processing.'}]","Status");
        showPDFDowloadError();
        centralizePopup();
    },
    download: function(){
        if (arguments.length > 0){
            $("#guide_size_box").html(arguments[0]);
        }
        window.location.href = "/account/download_pdf";
    }
}

var group_name_autocomplete = function(){
    var options = {
        serviceUrl:'/ajax/get_group_names' ,
        width:220,
        maxHeight:100
    };

    cert_autocomplete = $('#group_name').autocomplete(options);
}


var home_share = {
    authenticate: function(){
        FB.Connect.requireSession(function(){
            home_share.fb_stream_permission();
        },function(){});
    },
    fb_stream_permission: function(){
        FB.Connect.showPermissionDialog('publish_stream', function(accepted) {
            if(accepted == "publish_stream"){
                home_share.send_fb_stream();
            }
        } );
    },
    send_fb_stream: function(){
        $.ajax({
            url: '/home/send_fb_stream',
            cache: false,
            success: function(data){
                msg_box.show_error("[{msg: 'Hilo shared on facebook'}]","Success");
            }
        });
    }
}

var show_work_image_msg = {
    large: function(img_msg){
        var img_type = img_msg.split(".")[0];
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        this.call_ajax(img_type);
    },
    small: function(img_type){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        this.call_ajax(img_type);
    },
    call_ajax: function(img_type){
        $.ajax({
            url: '/ajax/work_image_color_desc',
            data: "img_msg=" + img_type,
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}

////////////////
var show_role_image_msg = {
    large: function(img_msg){
        var img_type = img_msg.split(".")[0];
        lighty.fadeBG(true);
        lighty.fade_div_layer(10,750);
        this.call_ajax(img_type);
    },
    small: function(img_type){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        this.call_ajax(img_type);
    },
    call_ajax: function(img_type){
        $.ajax({
            url: '/ajax/role_image_color_desc',
            data: "img_msg=" + img_type,
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}

var birkman_msg = {
    init: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url: '/ajax/birkman_msg',
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}

var work_birkman_msg = {
    init: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url: '/ajax/work_birkman_msg',
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}

var role_birkman_msg = {
    init: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url: '/ajax/role_birkman_msg',
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}


var adjustBasicJobTypeHeight =  function(){
    if($.browser.safari){
//$(".basics-block3-content").css("height",155);
}
}


var gift = {
    show: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url: '/gift/show',
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    },
    err_on_payment: function(msg){
        $('#gift_submit').attr('disabled',false);
        $('#gift_loader_img').hide();
        msg_box.show_error(msg);
    },
    success_msg: function(msg){
        lighty.close_fade_bg();
        msg_box.show_error("[{msg: '" + msg + "'}]","Success");
    }
}

// Processing of beta access code on the landing page
var access_code=  {
    err_on_sending_email: function(msg){
        $('#beta_access').hide();
        $('#cant_find_promo').hide();
        $('#fade_normal').hide();
        showErrorBeta();
    },
    success_msg: function(){
        $('#beta_access').hide();
        $('#cant_find_promo').hide();
        $('#fade_normal').hide();
        showSuccessBeta();
        $("#beta_success_enter").focus();
    },
    set_success: function(){
        $("#beta_success_head").html("SUCCESS!");
        $("#beta_success_body").html("A new promotional code<br /> has been sent to your email.");
        document.getElementById('beta_success_enter').onclick="";
        $("#beta_success_enter").click(function(){
            $("#beta_success").hide();
            hideSuccessShadow();
            ppComplete();
            document.getElementById('coderequest_email').value="";
            document.getElementById('coderequest_email').onblur();
            document.getElementById('beta_button').className = "enter-button";
        })
        document.getElementById('beta_success_close').onclick="";
        $("#beta_success_close").click(function(){
            $("#beta_success").hide();
            hideSuccessShadow();
            ppComplete();
            document.getElementById('coderequest_email').value="";
            document.getElementById('coderequest_email').onblur();
            document.getElementById('beta_button').className = "enter-button";
        })
    },
    set_retry: function(){
        document.getElementById('beta_access_error_retry').onclick="";
        $("#beta_access_error_retry").click(function(){
            $("#beta_error").hide();
            hideErrorShadow();
            showNormalShadow();
            $('#cant_find_promo').show();
            centralizePopup();
            document.getElementById('coderequest_email').value="";
            document.getElementById('coderequest_email').onblur();
            document.getElementById('beta_button').className = "enter-button";
        })
        document.getElementById('beta_access_error_close').onclick="";
        $("#beta_access_error_close").click(function(){
            $("#beta_error").hide();
            hideErrorShadow();
            ppComplete();
            document.getElementById('coderequest_email').value="";
            document.getElementById('coderequest_email').onblur();
            document.getElementById('beta_button').className = "enter-button";
        })


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

var testimonial = {
    remove: function(id){
        if(confirm("Are you sure you want to delete?")){
            $.ajax({
                url: '/admin/testimonials/remove/' + id,

                cache: false
            });
        }
    },
    show: function(id,e){
        var what = $(e).attr("checked")	? "1" : "0"
        $.ajax({
            url: '/admin/testimonials/show',
            data: "id=" + id	+ "&what=" + what,
            cache: false
        });
    },
    view: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url: '/ajax/view_testimonials',
            cache: false,
            success: function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }
}





var payment_msg_box  ={
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
        var err_element = $(payment_msg_box.div_content());
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
        var str ='<div class="error-outer-box" style="display:none;"><div style="position:relative;"><div><img src="/assets/midsize-bordertop.png"/></div><div class="error-inner-box"><div class="error-content"><div class="error-header">' + payment_msg_box.header_msg + '</div><div id="error-list"><div class="error-border" ></div></div><div  class="error-ok"><div class="pos-left" style="margin-right: 5px;"><a href="javascript:void(0);" onclick="check_payment_options.submit_payment_form();" class="button-a buttton_65X23">Ok</a></div><div class="pos-left"><a href="javascript:void(0);" onclick="msg_box.close_error(event);" class="button-a buttton_65X23">Cancel</a></div><br class="clear"/></div><br class="clear"/></div></div><div ><img src="/assets/midsize-borderbottom.png"/></div></div></div>';
        return str;
    },
    close_error: function(event){
        $(".error-outer-box").remove();
        event.stopPropagation();
    }
}




var seeker_register_pay_option = function(type){
    payment_option.open(type);
    if (type == "promocode_form"){
        $("#activate_account_btn").html("Activate Your Account");
    }else{
        msg_box.show_error("[{msg: 'This feature not available in this beta relase. Please click on redeem.'}]", "Notice");
        return false;
        $("#promotional_code").val('');
        $("#activate_account_btn").html("Activate Your Account $" + seeker_registration_cost);
    }
}

var payment_option = {
    open: function(type){
        payment_view.toggle(type);
        $("#pay_form_submit").slideDown();
    }
}


var job_payment_option = {
    open: function(type){
        payment_view.toggle(type);
        $("#job_pay_payment_button").slideDown();
    }
}


var gift_payment_option = {
    open: function(type){
        payment_view.toggle(type);
        $("#gift_payment_button").slideDown();
    }
}






var hide_job_view_load = function(){
    $("#pay_loader_img").hide();
}
var job_view_pay = {
    details: function(job_id,pay_for){
        var ele_arr = document.getElementsByName("transaction_type[]");
        var transaction_type = "";
        for(var i=0;i < ele_arr.length;i++){
            if(ele_arr[i].checked == true){
                transaction_type = ele_arr[i].value;
            }
        }

        $("#pay_loader_img").show();
        var str_params = "job_id=" + job_id + "&pay_for=" + pay_for + "&transaction_type=" + transaction_type + "&promotional_code=" + $("#promotional_code").val() + "&payment_type=" + $("#payment_type").val() + "&past_promo_code=" + $("#past_promo_code").val();
        $.ajax({
            url:"/job_payment/payment_details",
            cache: false,
            data: str_params,
            success: function(){
            }
        });
    },
    show_message: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]");
    },
    success_msg: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]","Success");
    },
    msg_json: function(msg){
        msg_box.show_error(msg);
    },
    submit_form: function(){
        $("#job_view_pay_form").submit();
        payview_msg_box.close_error();
        $("#pay_loader_img").show();
    },
    confirm: function(msg){
        payview_msg_box.show_error("[{msg: '" + msg + "'}]","Confirm");
    }
}




var gift_pay = {
    details: function(job_id,pay_for){
        var ele_arr = document.getElementsByName("transaction_type[]");
        var transaction_type = "";
        for(var i=0;i < ele_arr.length;i++){
            if(ele_arr[i].checked == true){
                transaction_type = ele_arr[i].value;
            }
        }


        $("#pay_loader_img").show();
        var str_params = "transaction_type=" + transaction_type +  "&payment_type=" + $("#payment_type").val();
        $.ajax({
            url:"/gift/payment_details",
            cache: false,
            data: str_params,
            success: function(){
            }
        });
    },
    show_message: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]");
    },
    success_msg: function(msg){
        msg_box.show_error("[{msg: '" + msg + "'}]","Success");
    },
    msg_json: function(msg){
        msg_box.show_error(msg);
    },
    submit_form: function(){
        $("#gift_pay_form").submit();
        payview_msg_box.close_error();
        $("#pay_loader_img").show();
    },
    confirm: function(msg){
        payview_msg_box.show_error("[{msg: '" + msg + "'}]","Confirm");
    },
    close_form: function(){
        lighty.close_fade_bg();
    }
}


var disable_form_on_complete_registration = function(){
    $(".pay-left").find("input").attr("disabled",true);
    $("#select_payment_msg").hide();
    $("#pre-payment-div").fadeOut(2000,function(){
        $("#post-payment-div").show();
    });

}

///////
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

var job_row_view = {
    init: function(){
        $(".table-content table#list tr").each(function(){
            var job_id = $(this).attr("id").split("_")[2];
            if($(this).attr("data-consider") == "yes"){
                $(this).unbind("click").bind("click",function(){
                    if($(this).hasClass('filter')) {
                        return false;
                    }
                    job_detail_view.show(job_id, "");
                });
            }else{
                $(this).unbind("click").bind("click",function(){
                    if($(this).hasClass('filter')) {
                        return false;
                    }
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

var show_job = {
    via_share: false,
    call: function(job_id){
        read_before = true;
        this.via_share = false;
        if (arguments.length > 1){
            this.via_share = true;
        }
        // Needs to be considered later
        /*if(!this.via_share){
                                    if ($("#job_row_" + job_id).attr("class").indexOf("unread") > -1){
                                                read_before = false;
                                                $("#job_row_" + job_id).removeClass("unread");
                                                $("#job_row_" + + job_id + " > .opp-col-dot").html("&nbsp;");
                                    }
                        }*/
        showNormalShadow();
        $(".popup-loader").show();
        var ajax_var = $.ajax({
            url: '/account/show_job',
            timeout: normal_timeout,
            data: "job_id=" + job_id,
            cache: false,
            error: function() {
                $(".popup-loader").hide();
                ajax_var.abort();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                $(".popup-loader").hide();
                // Needs to be considered later
                /*
                                      if(!show_job.via_share){
                                                                  if(read_before == false){
                                                                              new_count = new_count - 1;
                                                                              $(".inbox").html(new_count);
                                                                  }
                                                      }
                 */
                //timer_left_panel_adjust();
                $("#job_row_"+job_id).children().each(function(){
                    if($(this).hasClass("checked")){
                        $(this).removeClass("checked");
                        $(this).find('img').remove();
                        var count = $(".inbox").html();
                        $(".inbox").html(count-1);
                        count = $(".history").html();
                        count = parseInt(count);
                        $(".history").html(count+1);
                    }

                });

                $("#position_overview").show();
                centralizePopup();
            }
        });
    },
    inactive: function(){
        hideBlockShadow();
        $('div.black_overlay').hide();
        $("#fade_error").show();
        $('div#job_inactive_error').show();
        $('label.job_expiry_warning').html("THIS JOB IS CURRENTLY INACTIVE!");
        $('div.popup-upper-block-positionPrevew').css('z-index','1004');
        centralizePopup();
        addFocusButton('continue');
    //window.setTimeout('location.reload()', 3000);
    }
}

var jobcodelogin_submit = function(){
    /*
        if($("#career_code").val()==""){
		return false;
	}
     */
    var career_code = document.getElementById('career_code');
    if(!validateNotEmpty(career_code)){

        $("#"+career_code.id).parent().removeClass("input-text input-text-active active-input input-text-error");
        $("#"+career_code.id).parent().addClass("input-text-error-empty");

    }
    else{
        return enterCareerCode();
    }
//show_job_with_code($("#career_code").val());
}

//----------------------------validations for career seeker code-------------------------
function checkCarrerHLIDOnKeyPress(e)
{
    var code = e.keyCode;
    if(code == 13){
        // if (!$("#code_button").attr("disabled"))
        if ($("#code_button").hasClass("enter-button-active"))
            enterCareerCode();

    }
}
function checkCarrerHLID()
{
    var hlId = $("#career_code").val();
    var subFirstStr = hlId.substring(0, 2);
    var subNextStr = hlId.substring(2, hlId.length);
    var flag=true;
    if(subFirstStr.toLowerCase() != "hl" )
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

function enterCareerCode()
{
    if (checkCarrerHLID()==true) {
        show_job_with_code($("#career_code").val());
        return true;
    }
    else if(checkCarrerHLID()==false) {
        career_code.show_err_msg();
        return false;
    }
    return false;

}


var show_job_with_code = function(job_code){
    //lighty.fadeBG(true);
    //lighty.fade_div_layer(150,750);

    var ajax_var = $.ajax({
        url: '/account/show_job_for_code',
        data: "job_code=" + job_code,
        cache: false,
        timeout: normal_timeout,
        error: function() {
            //enableForm(document.getElementById('career_code_form'));
            hideNormalShadow();
            showErrorShadow();
            $(".popup-loader").hide();
            ajax_var.abort();
            showAjaxErrorPopup();

        },
        success: function() {
            $('#loader_img3').hide();
            //enableForm(document.getElementById('career_code_form'));
            $(".popup-loader").hide();
            centralizePopup();
        //showNormalShadow();


        },
        beforeSend: function() {
            $('#loader_img3').show();
            $('#code_button').hide();
        }


    });
}

var show_job_one_click = {
    via_share: false,
    call: function(job_id,card_type){
        read_before = true;
        this.via_share = false;
        if (arguments.length > 1){
            this.via_share = true;
        }
        showNormalShadow();
        $(".popup-loader").show();
        var ajax_var = $.ajax({
            url: '/account/show_job',
            data: "job_id=" + job_id,
            timeout: normal_timeout,
            error: function() {
                $(".popup-loader").hide();
                ajax_var.abort();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            cache: false,
            success: function(data) {
                showNormalShadow();
                $(".popup-loader").hide();
                $("#position_overview").show();
                centralizePopup();
                $('.white_content .popup-upper-block-positionPrevew .popup-bottom').css('display','none');
                $("#oneClick-payment").show();
                document.getElementById('pay_pass').focus();
                $("#pay_method").val(card_type);

                $("#confirm_button").unbind('click').bind('click', function(){

                    if(validateEmptyOneClickPayment()){

                    }
                    else{
                        $("#one_click_form").submit();
                    }


                });
            }
        });
    }

}

function updateCredit(data){
    $(".creadit-label span").html(data);
}

var job_detail_view = {
    show: function(job_id, pay_for) {
        hideErrorShadow();
        showNormalShadow();
        $("#fade_error_warning").hide();
        $("#fade_normal_warning").hide();

        $("#cc_billing_popup").empty();
        $("#cc_billing_popup").hide();
        clearInterval(timer);
        $("#position_overview").hide();
        $("#position_overview").empty();
        $("#fade_normal_warning").hide();
        $('#complete_purchase_one_click').hide();
        $(".popup-loader").show();
        if(pay_for == "consider" || pay_for == "consider_excluded"){
            var count = $(".considering").html();
            count = parseInt(count);
            $(".considering").html(count+1);
            $("#job_row_"+job_id).find('img.deactivated-yellow').attr('width','16');
            $("#job_row_"+job_id).find('img.deactivated-yellow').attr('height','16');
            $("#job_row_"+job_id).find('img.deactivated-yellow').attr('alt','Yellow');
            $("#job_row_"+job_id).find('img.deactivated-yellow').attr('src','/assets/yellow-bullet.png?1323171809');
            //$("#job_row_"+job_id).find('img.deactivated-yellow').html("<img width='16' height='16' class='active-yellow' src='/assets/yellow-bullet.png?1323171809' alt='Yellow'>");
            $("#job_row_"+job_id).find('img.deactivated-yellow').addClass('active-yellow').removeClass('deactivated-yellow');
        }
        //$("#job_listing").slideUp();
        //$("#detailed_comparison").html("Loading...").slideDown();
        var ajax_var = $.ajax({
            url:"/account/detail_comparison",
            cache: false,
            data: "job_id=" + job_id,
            timeout: normal_timeout,
            error: function() {
                $("#position_overview").hide();
                $("#position_overview").empty();
                $(".popup-loader").hide();
                ajax_var.abort();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function(){
                //timer_left_panel_adjust();
                //stopAjax();
                hideBlockShadow();
                $(".popup-loader").hide();
                showNormalShadow();
                $("#position_details").show();
                centralizePopup();
                $('#overview-scroll-content').slimscroll({
                    railVisible: true,
                    allowPageScroll: true,
                    height: '340px'
                });
            }
        });
    },
    close: function(){
        //lighty.close_fade_bg();
        //$("#detailed_comparison").slideUp();
        //$(".detail-view-highlighted-row").removeClass("detail-view-highlighted-row");
        clearInterval(timer);
        hideNormalShadow();
        $('#position_details').empty();
    }
}

var job_detail_view_one_click = {
    show: function(job_id, card_type){
        hideErrorShadow();
        showNormalShadow();

        $(".popup-loader").show();
        //$("#job_listing").slideUp();
        //$("#detailed_comparison").html("Loading...").slideDown();
        var ajax_var = $.ajax({
            url:"/account/detail_comparison",
            cache: false,
            data: "job_id=" + job_id,
            timeout: normal_timeout,
            error: function() {
                $(".popup-loader").hide();
                ajax_var.abort();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function(resp){
                $(".popup-loader").hide();
                //timer_left_panel_adjust();
                $("#position_overview").empty();
                //stopAjax();
                $("#position_details").show();
                centralizePopup();
                $('.popup-detailed-container .popup-bottom').css('display','none');
                $("#oneClick-payment").show();
                $("#pay_method").val(card_type);
                document.getElementById('pay_pass').focus();

                $("#confirm_button").unbind('click').bind('click', function(){

                    if(validateEmptyOneClickPayment()){

                    }
                    else{
                        $("#one_click_form").submit();
                    }


                });
            }
        });
    },
    close: function(){
        //lighty.close_fade_bg();
        //$("#detailed_comparison").slideUp();
        //$(".detail-view-highlighted-row").removeClass("detail-view-highlighted-row");
        hideNormalShadow();
        $('#position_details').empty();
    }
}


var ownership_event = {
    init: function(){
        $(".pos-prof-ownership-icon a").live("click",function(){
            ownership_event.clear_all_selection();
            $(this).children("img").attr("src","/assets/employer/blue_selected_circle.png");
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
        $(".pos-prof-ownership-icon a img").attr("src","/assets/hollow_workenv_img.png");
    }
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


var state_ev2 ={
    add_show: function(e){
        $("#state-selector span.label-default").attr("id",$(e).attr("id"));
    }
}

function showAboutHilo() {
    $('div#about-hilo').show();
    showNormalShadow();
    centralizePopup();
}
$(document).ready(function(){
    $("#aboutAbout").addClass("active");
});
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

function hideAboutHiloPopup() {
    $('div#about-hilo').hide();
    hideNormalShadow();
}




var load_map_script = function(){
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://maps.google.com/maps/api/js?sensor=false&callback=render_map";
    document.body.appendChild(script);
}

var codeAddress = function(address_string) {
    address_string = "Delhi,delhi,110064";
    var address = unescape_str(address_string);
}

var mark_job_considered_on_list = function(job_id){
    $("#job_row_" + job_id).attr("data-consider", "yes");
}

var archive_job = {
    current_job_id: null,
    init: function(job_id){
        beta_trial_msg();
        return false;
        this.current_job_id = job_id;
        $.ajax({
            url:"/account/archive_job",
            cache: false,
            data: "job_id=" + job_id,
            success: function(msg){
                job_detail_view.close();
                archive_job.increment_archive_cnt();
                $("#job_row_" + archive_job.current_job_id).remove();
            }
        });
    },
    increment_archive_cnt: function(){
        cnt = parseInt($("#archived_cnt").html(), 10) + 1;
        $("#archived_cnt").html(cnt);
    }
}

var remove_alert = function(ele,alert_id){
    $(ele).parentsUntil(".alert-row").parent().remove();
    $.ajax({
        url:"/account/remove_alert",
        cache: false,
        data: "alert_id=" + alert_id
    });
}




//
//var share_hilo = {
//    share: function(platform_id){
//        showBlockShadow();
//        var url = $("#page_url_job").val();
//        $.ajax({
//            url: '/share_hilo/share',
//            data: "platform_id=" + platform_id + "&url=" + url,
//            cache: false,
//            success:function(){
//
//            },
//            error:function (xhr, ajaxOptions, thrownError){
//                window.location.reload();
//            }
//        });
//    },
//    gift_share: function(platform_id, gift_share){
//        showBlockShadow();
//        var url = $("#page_url_job").val();
//        $.ajax({
//            url: '/share_hilo/share',
//            data: "platform_id=" + platform_id + "&url=" + url + "&gift_share=" + gift_share,
//            cache: false,
//            success:function(){
//
//            }
//        });
//    },
//    about_share: function(platform_id, gift_share){
//        showBlockShadow();
//        var url = $("#page_url_job").val();
//        $.ajax({
//            url: '/share_hilo/share',
//            data: "platform_id=" + platform_id + "&url=" + url + "&about_share=" + gift_share,
//            cache: false,
//            success:function(){
//
//            }
//        });
//    },
//    error_msg: function(msg){
//        showErrorShadow();
//        $("#posting-success-hilo-job-seeker").show();
//        $("#success_sharing_msg").html(msg);
//        centralizePopup();
//    },
//    success_msg: function(msg){
//        hideBlockShadow();
//        showSuccessShadow();
//        $("#posting-success-hilo-job-seeker").show();
//        $("#success_sharing_msg").html(msg);
//        centralizePopup();
//    },
//    success_msg_gift: function(msg){
//        hideBlockShadow();
//        $('div.black_overlay').hide();
//        $("#fade_success_sharing").show();
//        $("#posting-success-job-seeker").show();
//        $("#sharing_msg").html(msg);
//        $('div.popup-upper-block-positionPrevew').css('z-index','1004');
//        centralizePopup();
//
//    },
//    request_fb_login: function(){
//        FB.Connect.requireSession(function(){
//            share_hilo.fb_status_permission();
//        },function(){});
//        hideFBBlockShadow();
//
//    },
//    fb_login: function(){
//        FB.login(function(response) {
//            if (response.authResponse) {
//                //console.log('Welcome!  Fetching your information.... ');
//                $.ajax({
//                    url: '/share_hilo/send_fb_status',
//                    cache: false
//                });
//            } else {
//                //console.log('User cancelled login or did not fully authorize.');
//                hideBlockShadow();
//            }
//        },
//        {
//            scope: 'publish_stream' // I need this for publishing to Timeline
//        });
//    },
//    skip_exception: function(){
//        hideBlockShadow();
//    },
//    fb_status_permission: function(){
//        FB.Connect.showPermissionDialog('status_update', function(accepted) {
//            if(accepted == "status_update,publish_stream"){
//                share_hilo.send_fb_status();
//            }
//        } );
//
//    },
//    send_fb_status: function(){
//        $.ajax({
//            url: '/share_hilo/send_fb_status',
//            cache: false
//        });
//    },
//    logout_fb: function(){
//        FB.Connect.logout();
//    },
//    open_linkedin_login : function(authorize_url){
//        window.open(authorize_url);
//    },
//    open_twitter_login : function(authorize_url){
//        window.open(authorize_url);
//    }
//}

//function showSuccessHiloSharingMsg(msg){
//    showSuccessShadow();
//    $("#posting-success-hilo-job-seeker").show();
//    $("#success_sharing_msg").html(msg);
//    centralizePopup();
//
//}


var left_menu_career_seeker_search = function(){
    $("#enter_seekerid").focus(function(){
        $(this).removeClass("text-field-label");
        $(this).val("");
    });


    $("#enter_seekerid").focusout(function(){
        if($(this).val() == ""){
            $(this).val("Career Seeker ID");
            $(this).addClass("text-field-label");
        }
    });
}






var left_activity_menu_hover_effect = function(){
    $(".activity-menu-row").each(function(){
        $(this).mouseenter(function(){
            $(".activity-menu-row").removeClass("activity-menu-row-hover");
            $(this).addClass("activity-menu-row-hover");
        });

        $(this).mouseleave(function(){
            $(".activity-menu-row").removeClass("activity-menu-row-hover");
        });
    });
}

var apply_calendar = function(){
    $(".jqcal").each(function(){
        $(this).datepicker({
            showOn: 'button',
            buttonImage: '/assets/calendar.jpg',
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd "
        });
    });
}


var submit_report_pdf = function(){
    document.forms["pdf_download"].submit();
}

var submit_report_csv = function(){
    document.forms["csv_download"].submit();
}

var make_job_active = function(job_id){
    $.ajax({
        url: '/position_profile/make_job_active',
        cache: false,
        data: "id=" + job_id,
        success: function(data) {
            msg_box.show_error("[{msg: 'Done'}]","Success");
        }
    });
}



var all_color = {
    show: function(){
        $(".pairing-all-color-hide").hide();
        $(".pairing-all-color-show").show();
        // this section is for account pairing
        $("#pairing_tab_box").hide();
        $("#top_tab_cover").show();
    },
    hide: function(){
        $(".pairing-all-color-hide").show();
        $(".pairing-all-color-show").hide();
        // this section is for account pairing
        $("#pairing_tab_box").show();
        $("#top_tab_cover").hide();
    }
}

var all_color_employer = {
    init: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,750);
        $.ajax({
            url:'/ajax/all_color_employer',
            cache: false,
            success:function(data){
                $("#fade_layer_div").html(data);
            }
        });
    }

}

var show_pairing_color_desc = function(color, txt, user_type,env){
    $.ajax({
        url: '/ajax/get_pairing_color',
        cache: false,
        data: "color=" + color + "&txt=" + txt + "&user_type=" + user_type + "&env=" + env + "&curr_controller=" + $("#current_controller").val() + "&curr_action=" + $("#current_action").val(),
        success: function(data) {
            $("#pairing-color-content").html(data);
            pairing_color_toggle.show();
        }
    });
}

var pairing_color_toggle = {
    show: function(){
        $(".pairing-color-hide").hide();
        $(".pairing-color-content").show();
    },
    hide: function(){
        $(".pairing-color-hide").show();
        $(".pairing-color-content").hide();
    }
}



var my_acc_change_pwd = {
    err_msg: function(msg){
        $("#change_pwd_loader").hide();
        msg_box.show_error(msg);
    },
    success_msg: function(msg){
        $("#change_pwd_loader").hide();
        msg_box.show_error(msg, "Success");
        $("#old_password").val('');
        $("#new_password").val('');
        $("#confirm_password").val('');
    }
}

var my_acc_info = {
    err_msg: function(msg){
        $("#personal_loader").hide();
        msg_box.show_error(msg);
    },
    success_msg: function(msg){
        $("#personal_loader").hide();
        msg_box.show_error(msg, "Success");
    }
}

var push_test_submission = function(){
    $.ajax({
        url: '/ajax/push_birkman_test_submission',
        cache: false,
        success: function() {
        //window.location.href = "/account";
        }
    });
}

var push_birkman_pdf_download = function(){
    $.ajax({
        url: '/ajax/push_birkman_pdf_download',
        cache: false,
        success: function() {
		
        }
    });
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

var click_payment = {
    one_click_payment: function(pay_for){
        if (pay_for == "wild" || pay_for == "interest"){
            $('.detiled_content').css('top','0');
            $('.popup-detailed-container .popup-bottom').css('display','none');
            $("#loader-img").hide();
            $("#confirm_button").show();
            $("#confirm_button").removeClass('btn-Confirm-active').addClass('btn-Confirm');
            $("#oneClick-payment").show();
            document.getElementById("pay_pass").focus();
        }
        else{
            $('.white_content .popup-upper-block-positionPrevew .popup-bottom').css('display','none');
            $("#confirm_button").removeClass('btn-Confirm-active').addClass('btn-Confirm');
            $("#oneClick-payment").show();
            document.getElementById("pay_pass").focus();

        }
        $("#confirm_button").unbind('click').bind('click', function(){

            if(validateEmptyOneClickPayment()){

            }
            else{
                $("#one_click_form").submit();
            }


        });
    },
    credit_card_payment: function(){
        //stopAjax();
        clearInterval(timer);
        showBlockShadow();
        //$("#position_overview").empty();
        //$("#position_details").empty();
        $('#fade_normal_warning').show();
        $("#cc_billing_popup").show();
        $("#cc_billing_popup").css('z-index','1006');
        centralizePopup();
        hideBlockShadow();
        $("#payment_verify_button").unbind('click').bind('click', function(){
            if(validateEmptyPayment()){
                $('#payment_header').text("UNABLE TO VERIFY");
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
            else{
                $("#job_payment_form").submit();
            }
        });
    },
    credit_card_show: function(pay_for){
        if (pay_for == "wild" || pay_for == "interest"){
            $('.detiled_content').css('top','8%');
            $('.popup-detailed-container .popup-bottom').show();
        }
        else{
            $('.white_content .popup-upper-block-positionPrevew .popup-bottom').show();
        }
        $("#pay_pass").val('');
        $("#oneClick-payment").hide();
        $("#fade_normal_warning").show();
        $.ajax({
            url: '/job_payment/show_credit_card',
            cache: false,
            success: function(){
                //$("#change_payment").val("1");
                $('.detiled_content').css('top','8%');
                $('.popup-detailed-container .popup-bottom').show();
                $('.white_content .popup-upper-block-positionPrevew .popup-bottom').show();
                $("#pay_pass").val('');
                if(document.getElementById('pay_pass'))
                    document.getElementById('pay_pass').onblur();
                
                $("#payment_verify_button").unbind('click').bind('click', function(){
                    if(validateEmptyPayment()){
                        $('#payment_header').text("UNABLE TO VERIFY");
                        $("#paypal_error_msg").show();
                        $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                        var payment_card_type = document.getElementById('payment_card_type');
                        if (payment_card_type.value == ''){
                            $("#paypal_error_msg").show();
                            $("#paypal_error_msg").html("Please select one payment option.");
                            
                        }
                    }
                    else{
                        $("#job_payment_form").submit();
                    }
                });
            }
        });
    },
    credit_card_payment_no_one_click: function(total_amount, credit_value){
        //stopAjax();
        clearInterval(timer);
        showBlockShadow();
        $("#cc_billing_popup").show();
        $("#cc_billing_popup").css('z-index','1006');
        $("#summary_click_payment").show();
        $("#credit_amount").text("$"+credit_value);
        $("#paid_amount").text("$"+(total_amount));
        centralizePopup();
        hideBlockShadow();
        $("#payment_verify_button").unbind('click').bind('click', function(){
            if(validateEmptyPayment()){
                $('#payment_header').text("UNABLE TO VERIFY");
                $("#paypal_error_msg").show();
                $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                var payment_card_type = document.getElementById('payment_card_type');
                if (payment_card_type.value == ''){
                    $("#paypal_error_msg").show();
                    $("#paypal_error_msg").html("Please select one payment option.");
                }
            }
            else{
                $("#job_payment_form").submit();
            }
        });
    },
    one_click_payment_credit: function(value, pay_for){
        if (pay_for == "wild" || pay_for == "interest"){
            $('.detiled_content').css('top','0');
            $('.popup-detailed-container .popup-bottom').css('display','none');
            $("#oneClick-payment").show();
            $("#pay_method").val(value);
            document.getElementById("pay_pass").focus();

        }else{
            $('.white_content .popup-upper-block-positionPrevew .popup-bottom').css('display','none');
            $("#oneClick-payment").show();
            $("#pay_method").val(value);
            document.getElementById("pay_pass").focus();
        }
        $("#confirm_button").unbind('click').bind('click', function(){

            if(validateEmptyOneClickPayment()){

            }
            else{
                $("#one_click_form").submit();
            }


        });
    },
    authenticate_error: function(pay_for, job_id, card_type){
        hideNormalShadow();
        hideBlockShadow();
        clearInterval(timer);
        $("#position_overview").empty();
        $("#position_details").empty();
        showErrorShadow();
        $("#login_error").show();
        centralizePopup();
        addFocusButton('retry-button-active');
        $("#retry-button-active").unbind("click").bind("click",function(){
            click_payment.hideErrorLogin();
            if (pay_for == "wild" || pay_for == "interest"){
                job_detail_view_one_click.show(job_id,card_type);
            }else{
                show_job_one_click.call(job_id,card_type);
            }
        })

    },
    hideErrorLogin: function(){
        hideErrorShadow();
        $("#login_error").hide();
        showNormalShadow();
    }

}

var consider_job = {

    call: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/index',
            data: "job_id=" + job_id + "&pay_for=consider",
            cache: false,
            error: function() {
                hideBlockShadow();
                $("#position_overview").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                hideBlockShadow();
            }
        });
    },
    exclude_payment: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/exclude_payment',
            data: "job_id=" + job_id + "&pay_for=consider_excluded",
            cache: false,
            error: function() {
                hideBlockShadow();
                $("#position_overview").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                hideBlockShadow();
            }
        });
    },
    check: function(job_id, exclude_payment) {
        showBlockShadow();
        $.ajax({
            url: '/job_payment/check_job_expiry',
            data: "job_id=" + job_id + "&pay_for=consider",
            cache: false,
            success: function(data) {
                if(data.split('_')[0] == "job") {
                    if (exclude_payment != 1){
                        consider_job.call(job_id);
                    }
                    else{
                        consider_job.exclude_payment(job_id);
                    }
                } else if(data.split('_')[0] == "success") {
                    hideBlockShadow();
                    $('div.black_overlay').hide();
                    $("#fade_error_warning").show();
                    $('div#job_expiry_error').show();
                    $('label.job_expiry_warning').html("POSTING EXPIRES IN " + data.split('_')[1] + "!");
                    $('input#job_id_value').val(job_id);
                    $('input#pay_for').val("consider");
                    $('div.popup-upper-block-positionPrevew').css('z-index','1004');
                    centralizePopup();
                    addFocusButton('job_expiry_error_continue');
                }
                else{
                    

            }
            },
            error: function() {
                hideBlockShadow();
                $("#position_overview").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            }
        });
    }
}

var interest_job = {

    call: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/index',
            data: "job_id=" + job_id + "&pay_for=interest",
            error: function() {
                hideBlockShadow();
                $("#position_details").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            cache: false,
            success: function() {
                hideBlockShadow();
            }
        });
    },
    exclude_payment: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/exclude_payment',
            data: "job_id=" + job_id + "&pay_for=interest_excluded",
            cache: false,
            error: function() {
                hideBlockShadow();
                $("#position_details").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                hideBlockShadow();
            }
        });
    },
    check: function(job_id, exclude_payment) {
        showBlockShadow();
        $.ajax({
            url: '/job_payment/check_job_expiry',
            data: "job_id=" + job_id + "&pay_for=interest",
            cache: false,
            success: function(data) {
                if(data.split('_')[0] == "job"){
                    if (exclude_payment != 1){
                        interest_job.call(job_id);
                    }
                    else{
                        interest_job.exclude_payment(job_id);
                    }
                } else if(data.split('_')[0] == "success"){
                    hideBlockShadow();
                    $('div.black_overlay').hide();
                    $("#fade_error_warning").show();
                    $('div#job_expiry_error').show();
                    $('label.job_expiry_warning').html("POSTING EXPIRES IN " + data.split('_')[1] + "!");
                    $('input#job_id_value').val(job_id);
                    $('input#pay_for').val("interest");
                    $('div.popup-upper-block-positionPrevew').css('z-index','1004');
                    centralizePopup();
                    addFocusButton('job_expiry_error_continue');
                }
                else{
                    
            }
            },
            error: function() {
                hideBlockShadow();
                $("#position_overview").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            }
        });
    }
}

var wildcard_job = {

    call: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/index',
            data: "job_id=" + job_id + "&pay_for=wild",
            cache: false,
            error: function() {
                hideBlockShadow();
                $("#position_details").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                hideBlockShadow();
            }
        });
    },
    exclude_payment: function(job_id){
        showBlockShadow();
        $.ajax({
            url: '/job_payment/exclude_payment',
            data: "job_id=" + job_id + "&pay_for=wild_excluded",
            cache: false,
            error: function() {
                hideBlockShadow();
                $("#position_details").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            },
            success: function() {
                hideBlockShadow();
            }
        });
    },
    check: function(job_id, exclude_payment) {
        showBlockShadow();
        $.ajax({
            url: '/job_payment/check_job_expiry',
            data: "job_id=" + job_id + "&pay_for=wild",
            cache: false,
            success: function(data) {
                if(data == "job_is_valid") {
                    if (exclude_payment != 1){
                        wildcard_job.call(job_id);
                    }
                    else{
                        wildcard_job.exclude_payment(job_id);
                    }
                } else if (data != "") {
                    hideBlockShadow();
                    $('div.black_overlay').hide();
                    $("#fade_error_warning").show();
                    $('div#job_expiry_error').show();
                    $('label.job_expiry_warning').html("POSTING EXPIRES IN " + data + "!");
                    $('input#job_id_value').val(job_id);
                    $('input#pay_for').val("wild");
                    $('div.popup-upper-block-positionPrevew').css('z-index','1004');
                    centralizePopup();
                    addFocusButton('job_expiry_error_continue');
                }
            },
            error: function() {
                hideBlockShadow();
                $("#position_overview").empty();
                hideNormalShadow();
                showAjaxErrorPopup();
            }
        });
    }
}

var profile = {
    display: function(){
        $('.profile-breadcrumb').children().each(function(){
            var step = $(this).children().attr("title");
            $(this).unbind("click").bind("click", function(){
                var areYouSureResp = areYouSure(step);
                if(areYouSureResp == false) {
                    return false;
                }
                $('.profile-breadcrumb').children().each(function(){
                    $(this).removeClass("active");
                })
                $(this).addClass("active");

                $.ajax({
                    url: '/account/profile_tabs',
                    cache: false,
                    timeout: normal_timeout,
                    beforeSend: function (){
                        showBlockShadow();
                        $(".loader").show();
                        $("#ajax").empty();
                    },
                    error: function() {
                        $(".loader").hide();
                    },
                    data: "step="+step,
                    success: function(){
                        //$(".loader").hide();
                        //set_video();
                        hideBlockShadow();
                    }
                });
            })

        })
    },

    credentials_loader: function(){
        $('#loader_credential').hide();
        $('#credential-save').show();
        if(!validateRequired($("#add_uni_text").val())) {
            $("#add_uni_text").val('');
            $("#add_uni_text").blur();
            $('#college-remove').hide();
        }
        if(!validateRequired($("#add_cert_text").val())) {
            $("#add_cert_text").val('');
            $("#add_cert_text").blur();
            $('#certificate-remove').hide();
        }
    },

    basics_loader: function(){
        $('#loader_basic').hide();
        $('#next_button').show();
        $("#next_button").removeClass("active");
    },
    basics_button: function(){
        $("#next_button").unbind();
    }
}

function hideProfileLoader() {
    $('.loader').hide();
    $('.customized-inner-input input').each(function() {
        $(this).bind('paste',null,function(){
            if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
            }
        });
    });
}

function disableButton(){
    //document.getElementById('update1').disabled = "disabled";
    document.getElementById('update1').className = "update-button-active rfloat";
    $("#update1").unbind().click(function(){

        });
}

function disableUpdateButton(){
    $('.rfloat').removeClass('update-button-active').addClass('update-button');
}

function changeStatus() {
    $("#checkLoad").val("false");
}

function persistDetails(area_code, phone_one, contact_email, preferred, armed_forces, summary, purpose, flag, error){

    summary = summary.replace(/(\r\n)|(\n)/g, "~~~");
    summary = summary.replace(/'/g, " ");
    $.ajax({
        type: 'POST',
        url: '/account/persist_values',
        cache: 'false',
        data: 'area_code='+area_code+'&phone_one='+phone_one+'&contact_email='+contact_email+'&preferred='+preferred+'&armed_forces='+armed_forces+'&summary='+summary+'&flag='+flag+'&error='+error,
        success: function(data){
            if(purpose == "resume"){
                setTimeout(function(){
                    document.forms["js-resume"].submit();
                }, 100);
            }
            else if(purpose == "photo"){
                document.forms["js-photo"].submit();
            }
        }

    })
}

function persistValues(url){
    /*
         var flag;
         var error="";
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
		var summary = $('#summary').val();
                summary = summary.replace(/(\r\n)|(\n)/g, "~~~");
                summary = summary.replace(/'/g, " ");
	}
	else {
		var summary = "";
	}
         var preferred = $("#pref_one").attr("checked")==true?"first":"second";
         var armed_forces = $("#yes").attr("checked")==true?true:false;
             */
    //persistDetails(area_code, phone_one, contact_email, preferred, armed_forces, summary, "resume");
    $.ajax({
        type: 'POST',
        url: '/account/save_video_url',
        cache: false,
        data: '&url='+url,
        success: function(){

        }
    })
}

function closeShareLoginPopup(){
    $.ajax({
        url:'/home/closeSharing',
        cache: false,
        success: function(){
            hideNormalShadow();
            $('#sharing_external_login').hide();
        }
    });

}

function closeErrorShareLoginPopup(){
    $.ajax({
        url:'/home/closeSharing',
        cache: false,
        success: function(){
            hideErrorShadow();
            $('#sharing_login_error').hide();
        }
    });
}

function shareLoginError(){
    hideNormalShadow();
    showErrorShadow();
    $('#sharing_external_login').hide();
    $("#sharing_login_error").show();
    centralizePopup();
    $("#retry_button").unbind("click").bind("click", function(){
        $("#sharing_login_error").hide();
        hideErrorShadow();
        showNormalShadow();
        $('#sharing_external_login').show();
        $('#share_login_name').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#share_login_name').parent().addClass('input-text');
        $('#share_login_pass').parent().removeClass('input-text input-text-active active-input input-text-error');
        $('#share_login_pass').parent().addClass('input-text');
        $('#share_login_name').val('Email');
        changeInputType(document.getElementById("share_login_pass"),"text","");
        $('#share_login_pass').val('Hilo Password');
        document.getElementById("share_login_form_submit").className = "enter-button rfloat";
        document.getElementById("share_login_form_submit").disabled="true"
        centralizePopup();
    })
}

function shareSignup(){
    hideNormalShadow();
    $('#sharing_external_login').hide();
    showBetaPopup();
}

function editorEvents(elmnt, evt){
    var keyCode = evt.keyCode ? evt.keyCode : evt.charCode;
    var keyCodeChar = String.fromCharCode(keyCode).toLowerCase();

    if (evt.type=='keydown' && evt.ctrlKey)
    {
        //alert(elmnt);
        type_element(elmnt, evt);
        evt.returnValue = false;

    }
    return true;
}

function abc(){
    alert("Hello");
}

function ppComplete(){
    //alert("11111");
    //alert(document.getElementById('pairing-profile-completed-id'));
    if(document.getElementById('pairing-profile-completed-id')){
        showNormalShadow();
        $("#pairing-profile-completed-id").show();
        centralizePopup();
        addFocusButton('pairing-profile-completed-id_button');
    //$('#pairing-profile-completed-id_button').focus();
    }
}

function basicFormSubmit(){
    document.forms["basic_form"].submit();

}

function closePPComplete(){
    hideNormalShadow();
    $("#pairing-profile-completed-id").hide();
}

function qComplete(){
    showNormalShadow();
    $("#questionnaire-completed-id").show();
    centralizePopup();
    $("#continue").focus();
    if(document.getElementById("work_env")){
        $("#continue").click(function(){
            birkman_test.save_work_env();
        });

    }
    else if(document.getElementById("test_three")){
        $("#continue").click(function(){
            birkman_test.save_test_three();
        });
    }

}

function closeQComplete(){
    hideNormalShadow();
    $("#questionnaire-completed-id").hide();
}

var cant_find_promo = {
    show_pop_up:function(){
        closePPComplete();
        showNormalShadow();
        $("#cant_find_promo").show();
        $("#coderequest_email").parent().removeClass("input-text-error input-text-error-empty");
        $("#coderequest_email").parent().addClass("input-text");
        $("#coderequest_email").val("Email");
        $("#beta_button").unbind('click').bind('click', function(){
            if(!validateEmptyBetaAccess()){
                $("#cant_find_promo_form").submit();
            }
        })
        centralizePopup();
    },
    close_pop_up: function(){
        $('#cant_find_promo').hide();
        hideNormalShadow();
        ppComplete();
        document.getElementById('coderequest_email').value="";
        document.getElementById('coderequest_email').onblur();
        document.getElementById('beta_button').className = "enter-button";
    }
}

// Calls a wibndow.open and uses url as params, also opens popup in center of window
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

function showFollowingConfirmation(){

}

function checkEnterGiftBilling(e){
    var code = e.keyCode;
    if(code == 13){
        if ($("#gifts_payment_verify_button").hasClass("buy-gift-button-active")){
            $('#form_gift_payment').submit();
        }

    }
}


function testing_for_assets(){
    alert("foo");
}

var complete_purchase ={
    no_one_click_close :function(){
        $("#continue-button-active_no_one_click").hide();
        $("#verify-loader-img_no_one_click").show();
        $.ajax({
            url: '/job_payment/complete_purchase_no_one_click',
            cache: false,
            success: function(data){
                $("#complete_purchase_no_one_click ").hide();
            }
        });
    },
    one_click_close :function(){
        showBlockShadow();
        $("#continue-button-active_one_click").hide();
        $("#verify-loader-img_one_click").show();
        $.ajax({
            url: '/job_payment/complete_purchase_one_click',
            cache: false,
            success: function(data){
                
            }
        });
    },
    credit_card_show: function(){
        total_amount = $("#total_amount_one_click").val();
        credit_value = $("#credit_amount_one_click").val();
        $("#complete_purchase_one_click").hide();
        $.ajax({
            url: '/job_payment/show_credit_card',
            cache: false,
            success: function(){
                //$("#change_payment").val("1");
                $("#summary_click_payment").show();
                $("#credit_amount").text("$"+credit_value);
                $("#paid_amount").text("$"+(total_amount));
                
                $("#payment_verify_button").unbind('click').bind('click', function(){
                    if(validateEmptyPayment()){
                        $('#payment_header').text("UNABLE TO VERIFY");
                        $("#paypal_error_msg").show();
                        $("#paypal_error_msg").html("Please complete the areas highlighted in red.");
                        var payment_card_type = document.getElementById('payment_card_type');
                        if (payment_card_type.value == ''){
                            $("#paypal_error_msg").show();
                            $("#paypal_error_msg").html("Please select one payment option.");
                        }
                    }
                    else{
                        $("#job_payment_form").submit();
                    }
                });
            }
        });
    }
}

function placeholderReplace(){
    $('[placeholder]').keydown(function() {
        var input = $(this);
        if (input.val() == input.attr('placeholder')) {
            input.val('');
            // change class from placeholder to something else
            input.removeClass('placeholder');
            input.addClass('filled-input');
            input.parent().parent().parent().parent().removeClass("error");
        }
    }).blur(function() {
        var input = $(this);
        if (input.val() == ''){ // || input.val() == input.attr('placeholder')) {
            // change class from placeholder to something else
            input.addClass('placeholder');
            input.removeClass('filled-input');
            input.val(input.attr('placeholder'));
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

function addFocusTextField(id){
    document.getElementById(id).focus();
}

function addFocusButton(id){
    $('#'+id).focus();
}

