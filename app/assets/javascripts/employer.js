var emp_left_menu_event = {
	apply: function(){
		this.toggle_group_event();
		this.group_drag();
		this.job_section_drag();
		this.edit_name();
		this.toggle_job_delete_icon();
	},
	toggle_job_delete_icon : function(){
		$(".group-section-job").mouseenter(function(){
			$(this).children(".left-menu-job-delete").children("a").show();
		}).mouseleave(function(){
			$(this).children(".left-menu-job-delete").children("a").hide();
		});	
		
	},
	save_success: function(grp_id){
		var text = $("#group_row_" + grp_id).find("input.edit-group-name").first().val();
		$("#group_row_" + grp_id).find("input.edit-group-name").hide();
		$("#group_row_" + grp_id).find("span").html(text).show();
	},
	save_fail: function(json){
		var json_error = eval(json);
		var error_str = "";
		for (var i=0;i < json_error.length ;i++ )
		{
			error_str += unescape_str(json_error[i].msg) + "\n";
		}
		//alert(error_str);
	},
	edit_name: function(){
		$(".group-row-name").find("span").click(function(){
			$(this).hide();
			$(this).next().val($(this).html());
			$(this).next().show().focus();
			$(".jobs_group").hide();
		});

		$(".edit-group-name").blur(function(){
			$(this).hide();
			$(this).prev().show();
			$(".jobs_group").show();
		});
	},
	toggle_group_event: function(){


		//$(".group-row-bg").children(".group-row").children(".group-row-arrow").children("a").each(function(){
                $(".group-row-bg .group-row-name .show-content").each(function(){
			$(this).click(function(){
				var grp_sec = $(this).attr("data-group-id");

				if($("#group_section_" + grp_sec).is(':visible') == true){
					$("#group_section_" + grp_sec).slideUp('fast').prev().removeClass("group-row-bg-selected");
					//$(this).children("img").attr("src","/assets/employer_v2/group-row-open.png");
					$(this).removeClass('down');
				}else{
					$("#group_section_" + grp_sec).slideDown('slow').prev().addClass("group-row-bg-selected");
					//$(this).children("img").attr("src","/assets/employer_v2/group-row-close.png");
					$(this).addClass('down');
				}
			});
		});

	},
	group_drag: function(){
		$("#company-group-list-section").sortable({
				handle: ".group-row-bg",
				stop: function(event,ui){
					emp_left_menu_event.sort_group_ajax($("#company-group-list-section").sortable('serialize'));
					//alert($("#company-group-list-section").sortable('serialize'));
				}
		});
		$(".group-row-bg").mouseenter(function(){
			$(this).find(".group-row-drag").show();
		}).mouseleave(function(){
			$(this).find(".group-row-drag").hide();
		});
	},
	job_section_drag: function(){
		$(".group-section").each(function(){
				var temp_id = $(this).attr("id");
				$("#" + temp_id).sortable({
					stop: function(){
						emp_left_menu_event.sort_group_job_ajax($("#" + temp_id).sortable('serialize'));
						//alert($("#" + temp_id).sortable('serialize'));
					}
				});
		});
	},
	sort_group_ajax: function(sort_list){
		
		$.ajax({
		  url: '/ajax/sort_group_ajax',
   		  cache: false,
		  data: sort_list
		});
	},
	sort_group_job_ajax: function(sort_list){
		$.ajax({
		  url: '/ajax/sort_group_job_ajax',
   		  cache: false,
		  data: sort_list
		});	
	},
	delete_action: function(group_id){
		if (confirm("If you delete this Category all Positions within it will be deleted too. Are you sure you want to delete this Category?"))
		{
				$.ajax({
				  url: '/position_profile/delete_group',
				  data: "group_id=" + group_id,	
				  cache: false,
				  success: function(data){
					//window.location.reload();
                                        hideDashboardWarningPopup();
					$("#update_categories").html(data);
                                        return false;
				  }
				});
		}
	}

}

var delete_job = {
	init: function(job_id){
		if (confirm("Are you sure you want to delete this Job?"))
		{
				$.ajax({
				  url: '/position_profile/delete_job',
				  data: "job_id=" + job_id,	
				  cache: false,
				  success: function(data){
					window.location.reload();
					return false;
				  }
				});
		}
	}
}
var group_add = {
	open: function(){
		$("#add_grp_box").slideToggle('fast');
	}
}



/*
var emp_left_menu_event = {
	apply: function(){
		this.toggle_group_event();
		this.delete_group_event();
	},
	toggle_group_event: function(){
		$("div[id^=group_row] .pos-left-img a, div[id^=group_row] .pos-right-txt a").live("click", function(){
			toggle_group_section($(this).attr("data-grp-id"));
		});	
	},
	delete_group_event: function(){
		$("#company-group-list-section > .left-menu-row").mouseenter(function(){
			$(this).children("div[id^=group_row_]").find(".pos-right-txt > img").show();
		});

		$("#company-group-list-section > .left-menu-row").mouseleave(function(){
			$(this).children("div[id^=group_row_]").find(".pos-right-txt > img").hide();
		});

		$(".delete_group_icon").live("click",function(){
			var grp_id = $(this).parent().parent().attr("id").split("_")[2];
			emp_left_menu_event.delete_action(grp_id);
		});
	},
	delete_action: function(group_id){
		if (confirm("Are you sure you want to delete?"))
		{
				$.ajax({
				  url: '/position_profile/delete_group',
				  data: "group_id=" + group_id,	
				  cache: false,
				  success: function(data){
					window.location.reload();
					return false;
				  }
				});
		}
	}
}
*/

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
               hide: { fixed: true, delay: 1000 }, // Don't specify a hide event
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
/*
var onload_toggle_group_section = function(){
	$(".pos-prof-current-box").each(function(){
			toggle_group_section($(this).parent().parent().attr("id").split("_")[2]);
	});
}
*/
function show_notification_box(e){
	$(".notification-box").toggle();
	$(".employer-acc-box").hide();
	stopping_propagation(e);
}

function show_employer_account_box(e){
	$(".employer-acc-box").toggle();
	$(".notification-box").hide();
	stopping_propagation(e);
}


function bottom_logo_click(e){
	$(".hilo_help_pop").show();
	stopping_propagation(e);
}

function about_hilo_bottom_logo_click(){
  $("#terms-tab").hide();
  $("#privacy-tab").hide();
  $("#contact-tab").hide();
  $("#about-hilo-tab").show();
  $("#terms_button").removeClass("about-hilo-btn-selected");
  $("#privacy_button").removeClass("about-hilo-btn-selected");
  $("#about_hilo_button").addClass("about-hilo-btn-selected");
}

function terms_bottom_logo_click(){
  $("#about-hilo-tab").hide();
  $("#privacy-tab").hide();
  $("#contact-tab").hide();  
  $("#terms-tab").show();
  $("#about_hilo_button").removeClass("about-hilo-btn-selected");
  $("#privacy_button").removeClass("about-hilo-btn-selected");
  $("#contact_button").removeClass("about-hilo-btn-selected");
  $("#terms_button").addClass("about-hilo-btn-selected");
}

function privacy_bottom_logo_click(){
  $("#about-hilo-tab").hide();  
  $("#terms-tab").hide();
  $("#contact-tab").hide();
  $("#privacy-tab").show();
  $("#about_hilo_button").removeClass("about-hilo-btn-selected");
  $("#terms_button").removeClass("about-hilo-btn-selected");
  $("#contact_button").removeClass("about-hilo-btn-selected");
  $("#privacy_button").addClass("about-hilo-btn-selected");
}

function contact_bottom_logo_click(){
  $("#about-hilo-tab").hide();  
  $("#terms-tab").hide();
  $("#privacy-tab").hide();
  $("#contact-tab").show();
  $("#about_hilo_button").removeClass("about-hilo-btn-selected");
  $("#terms_button").removeClass("about-hilo-btn-selected");
  $("#privacy_button").removeClass("about-hilo-btn-selected");
  $("#contact_button").addClass("about-hilo-btn-selected");

}

function onload_open_group_section(){
  
	if (currently_viewed_job_id != "0"){
		var ele = $("#group_job_" + currently_viewed_job_id).parent().parent().prev();
		$(ele).children(".group-row-arrow").children("a").trigger("click");
    
	}
}



var xref_buy = {
	init: function(){
		$("#buy_link").find("a").first().bind("click", function(){
			if($(this).hasClass("profile-days-left")){
				seeker_intro.load(xref_seeker_id);			
			}else{
				purchase_profile.call(xref_seeker_id);
			}		
		});
	}
}

var purchase_profile = {
	init: function(){
		$(".pool-row").each(function(){
			var seeker_id = $(this).attr("data-seeker-id");
			$(this).find("a").live("click",function(){
				if($(this).parentsUntil(".pool-row").parent().find(".buy-profile-link").length > 0){
					purchase_profile.call(seeker_id);
				}else{
					seeker_intro.load(seeker_id);
				}
			});
		});
	},
	call: function(seeker_id){
		$("#purchase_profile_payment_box").html("Loading...").show();	
		$.ajax({
		  url: '/purchase_profile_payment/index',
		  data: "seeker_id=" + seeker_id + "&pay_for=purchase_profile",	
		  cache: false,
		  success: function(data) {
			$("#purchase_profile_payment_box").html(data).show();
			timer_left_panel_adjust();
		  }
		});
	},
	close: function(){
		$("#purchase_profile_payment_box").html("").show();
	}
}


var seeker_intro ={
	load: function(seeker_id){
		$("#purchase_profile_payment_box").html("Loading...").show();	
		$.ajax({
		  url: '/position_profile/seeker_profile',
		  data: "seeker_id=" + seeker_id + "&job_id=" + $("#job_id").val(),	
		  cache: false,
		  success: function(data) {
			$("#purchase_profile_payment_box").html(data).show();
			timer_left_panel_adjust();
		  }
		});
	}
}



var purchase_profile_pay = {
	details: function(seeker_id,pay_for){
		var ele_arr = document.getElementsByName("transaction_type[]");
		var transaction_type = "";
		for(var i=0;i < ele_arr.length;i++){
			if(ele_arr[i].checked == true){
				transaction_type = ele_arr[i].value;
			}
		}
		
		$("#pay_loader_img").show();
		var str_params = "seeker_id=" + seeker_id + "&pay_for=" + pay_for + "&transaction_type=" + transaction_type + "&promotional_code=" + $("#promotional_code").val() + "&payment_type=" + $("#payment_type").val() + "&past_promo_code=" + $("#past_promo_code").val();
		$.ajax({
			url:"/purchase_profile_payment/payment_details",
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
	load_seeker_profile: function(seeker_id){
		$(".pool-row").each(function(){
			if($(this).attr("data-seeker-id") == seeker_id){
				var new_link = "<a href='javascript:void(0);'>31 days left</a>";
				$(this).find(".buy-profile-link").parent().html(new_link);
			}
		});
		seeker_intro.load(seeker_id);	
	},
	msg_json: function(msg){
		msg_box.show_error(msg);		
	},
	submit_form: function(){
		$("#purchase_profile_pay_form").submit();
		payview_msg_box.close_error();
		$("#pay_loader_img").show();
	},
	confirm: function(msg){
		payview_msg_box.show_error("[{msg: '" + msg + "'}]","Confirm");	
	},
	hide_pay_load:  function(){
		$("#pay_loader_img").hide();
	},
	reload: function(){
		window.location.reload();
		return false;
	}
}



var purchase_profile_payment_option = {
	open: function(type){
		payment_view.toggle(type);
		$("#purchase_profile_pay_button").slideDown();
	}
}

var hide_employer_alert = function(employer_alert_id){
	$("#employer_alert_" + employer_alert_id).remove();
	$.ajax({
			url:"/position_profile/mark_emp_alert_unread",
			cache: false,
			data: "employer_alert_id=" + employer_alert_id,
			success: function(){
				var val = parseInt($("#notification_cnt").html(),10);
				$("#notification_cnt").html(val - 1);
			}
		});

}

var emp_acc_info = {
	err_msg: function(msg){
		message_box.show_error(msg);
	},
	success_msg: function(msg){	
		message_box.show_error(msg, "Success");
	}
}

var message_box  ={
	header_msg: "Oops!",
	show_error: function(msg_json){
		if (arguments.length > 1){
			this.header_msg = arguments[1]
		}
		else {
			this.header_msg = "Oops!"
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
		var err_element = $(message_box.div_content());
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
		var str ='<div class="error-outer-box" style="display:none;"><div style="position:relative;"><div><img src="/assets/midsize-bordertop.png"/></div><div class="error-inner-box"><div class="error-content"><div class="error-header">' + message_box.header_msg + '</div><div id="error-list"><div class="error-border" ></div></div><div  class="error-ok"><a href="javascript:void(0);" onclick="msg_box.close_error(event);" class="button-a buttton_65X23">Ok</a></div><br class="clear"/></div></div><div ><img src="/assets/midsize-borderbottom.png"/></div></div></div>';
		return str;
	},
	close_error: function(event){
		$(".error-outer-box").remove();	
		event.stopPropagation();
	}
}
var send_feedback=  {
	success_msg: function(){
		$('#feedback-all').hide();
		$('#feedback-thank-msg').show();
	}
	
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
	
	hilo_share_task: function(posting_id, status, id){
		if (status == true){
			$('#url-share').show();
		}
		$.ajax({
			url: '/postings/hilo_share_task',
			data: "posting_id=" + posting_id + "&id=" + id + "&status=" + status,
			cache: false,
			success: function(){
					window.location.reload();
			}
		});

	},
	
	facebook_share_task: function(posting_id,platform_id,job_id){
		$.ajax({
			url: '/postings/facebook_share_task',
			data: "posting_id=" + posting_id,
			cache: false,
			success: function(){
				
				if (platform_id && job_id){
			share_job.share(platform_id,job_id);
		}
		else{
		window.location.reload();}
			}	
		});	
	
	},
	
	twitter_share_task: function(posting_id,platform_id,job_id){
		$.ajax({
			url: '/postings/twitter_share_task',
			data: "posting_id=" + posting_id,
			cache: false,
			success: function(){
				if (platform_id && job_id){
			share_job.share(platform_id,job_id);
		}
		else{
		window.location.reload();}
			}	
		});	
	
	},
	
	linkedin_share_task: function(posting_id,platform_id,job_id){
		$.ajax({
			url: '/postings/linkedin_share_task',
			data: "posting_id=" + posting_id,
			cache: false,
			success: function(){
				if (platform_id && job_id){
			share_job.share(platform_id,job_id);
		}
		else{
		window.location.reload();}
			}	
		});	
	
	},
	
	url_share_task: function(posting_id){
		$.ajax({
			url: '/postings/url_share_task',
			data: "posting_id=" + posting_id,
			cache: false,
			success: function(){
				window.location.reload();
				return false;
			}	
		});	
	
	}
	
	
}

var select_work_experience = function(exp_id){
	
	$("#workexp_value").val(exp_id);
	$(".exp-box1").each (function(){
		$(this).children("a").each(function(){
		$(this).addClass("anyWorkExpBtn");
		$(this).removeClass("anyWorkExpBtn_enabled");
		
		if( $(this).attr("id") == ("exp_link_" + exp_id)){
				 $(this).addClass("anyWorkExpBtn_enabled");
				 $(this).removeClass("anyWorkExpBtn");
				 $("#workexp_value").val(exp_id);
			 }
	});
	
	});
	$(".exp-box").each (function(){
		$(this).children("a").each(function(){
		$(this).addClass("WorkExpBtn_disabled");
		$(this).removeClass("WorkExpBtn_blue");
		
		if( $(this).attr("id") == ("exp_link_" + exp_id)){
				 $(this).addClass("WorkExpBtn_blue");
				 $(this).removeClass("WorkExpBtn_disabled");
				 $("#workexp_value").val(exp_id);
			 }
	});
	
	});
	
	
}

var select_highest_education = function(degree_id){
	$("#selected_degrees_id").val(degree_id);
	$(".exp-box").each(function(){
		$(this).children("a").each(function(){
			 $(this).addClass("degree-tab");
			 $(this).removeClass("degree-tab-selected");
			 if( $(this).attr("id") == ("degree_link_" + degree_id)){
				 $(this).addClass("degree-tab-selected");
				 $(this).removeClass("degree-tab");
				 $("#selected_degrees_id").val(degree_id);
			 }
	    });
	});
}

var employer_about_hilo = {
	open: function(){
		lighty.fadeBG(true);
		lighty.fade_div_layer(40,725);
		$.ajax({
			  url: '/ajax/employer_about_hilo',
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

var employer_contact = {
	open: function(){
		lighty.fadeBG(true);
		lighty.fade_div_layer(40,725);
		$.ajax({
			  url: '/ajax/employer_contact',
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

var employer_terms_use = {
	open: function(){
		lighty.fadeBG(true);
		lighty.fade_div_layer(40,725);
		$.ajax({
			  url: '/ajax/employer_terms_use',
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

var employer_privacy = {
	open: function(){
		lighty.fadeBG(true);
		lighty.fade_div_layer(40,725);
		$.ajax({
			  url: '/ajax/employer_privacy',
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