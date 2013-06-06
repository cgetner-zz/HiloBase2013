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
            $(this).children("img").attr("src","/assets/hollow_workenv_img.png");
        });
        $(e).children("img").attr("src","/assets/filled_workenv_img.png");
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
			
        }else{
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
                    $(this).find("img").attr("src","/assets/filled_workenv_img.png");
                }
            });
        });
    }
}



var pos_profile_role_ques = {
    final_arr: [],
    check_role_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/hollow_workenv_img.png");
        });
        $(e).children("img").attr("src","/assets/filled_workenv_img.png");
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
        }else{
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
                    $(this).find("img").attr("src","/assets/filled_workenv_img.png");
                }
            });
        });
    }
}

//
var pos_profile_work_role_ques={
	
    final_arr_work: [],
    final_arr_role: [],
	
    check_workenv_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/hollow_workenv_img.png");
        });
        $(e).children("img").attr("src","/assets/employer/blue_selected_circle.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
    },
    check_role_img: function(e){
        $(e).parent().parent().find("a").each(function(){
            $(this).children("img").attr("src","/assets/hollow_workenv_img.png");
        });
        $(e).children("img").attr("src","/assets/employer/blue_selected_circle.png");
        $(e).parent().parent().removeClass("env-ques-color-err");
    },
	
    save: function(){
        this.final_arr_work=[];
        this.final_arr_role=[];
        var error_flag_work = false;
        var error_flag_role = false;
		
        $(".env-ques-color-err").removeClass("env-ques-color-err");
        $(".role-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;
            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("blue_selected_circle") > -1){
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
                if ($(img_arr[j]).attr("src").indexOf("blue_selected_circle") > -1){
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

        if(error_flag_role==true || error_flag_work==true){
            msg_box.show_error("[{msg: 'You must answer all of the questions.'}]");		
            return false;
        }
        else{
            this.submit_form();
        }		
    },
    save_guest_employer: function(){
        this.final_arr_work=[];
        this.final_arr_role=[];
        var error_flag_work = false;

        $(".env-ques-color-err").removeClass("env-ques-color-err");
        $(".work-radio-slider").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;

            for(var j=0;j < img_arr.length;j++){
                if ($(img_arr[j]).attr("src").indexOf("blue_selected_circle") > -1){
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

        if(error_flag_work==true){
            //msg_box.show_error("[{msg: 'You must answer all of the questions.'}]");
            $(".question-set-box").addClass('error');
            $(".question-error-message").show();
            return false;
        }
        else{
            this.submit_form();
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
                    $(this).find("img").attr("src","/assets/employer/blue_selected_circle.png");
                }
            });
        });
		
        var selected_vals_role = $("#slider_values_role").val().split(",");
        $(".role-radio-slider").each(function(index){
            $(this).find("a").each(function(){
                if($(this).attr("data-val") == selected_vals_role[index]){
                    $(this).find("img").attr("src","/assets/employer/blue_selected_circle.png");
                }
            });
        });
		
		
    }	
}

///
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
///

var workenv_slider = {
    create: function(){
        $(".workenv_slider").slider({
            step: 1,
            min: 0,
            max: 10
        });
        $(".workenv_slider > a").removeClass("ui-state-default ui-corner-all");
        $(".ui-slider-handle").each(function(){
            $(this).html("<img src='/assets/work_env_slider.jpg'/>");
        });

    // $('.workenv_slider > a').addClass("ui-state-hover").removeClass("ui-state-hover");
    //$('.ui-slider-handle').addClass("ui-state-hover").removeClass("ui-state-hover");
    }
}



var birkmanid_popup = {
    init: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(75,810);	

        $.ajax({
            url: '/questionnaire/old_birkmanid_help',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    }
}

var validate_prev_birkman_id = function(){
    if($("#prev_birkman_id").val().replace(/\s/g,"") == ""){
        return false;
    }
    return true;
}

///

var birkman_test = {
    final_arr: [],
    flag_show_next: 1,
    first_choice: 0,
    second_choice: 0,
    flag_show_next: 0,
    show_msg_two: function(){
        $("#msg_one_link").hide();
        $("#ques-msg-one").hide();
        $("#ques-msg-two").show();
        $("#msg_two_link").show();
    },
    submit_citizenship_form: function(){
        $("#question_loader").show();
        $('#citizenship_form').submit();
    },
    check_workenv_img: function(e){
        $(e).parent().parent().find("img").each(function(){
            $(this).attr("src","/assets/hollow_workenv_img.png");
        });
        $(e).children("img").attr("src","/assets/filled_workenv_img.png");
        $(e).parent().parent().parent().removeClass("env-ques-color-err");
    },
    show_next: function(recall){
        if(recall!=true) {
            setTimeout(function(){birkman_test.show_next(true)},50);
            return;
        }

        var allActive = 0;
        $(".question-set").each(function(){
            $(this).find('.workenv-options').children().children().each(function() {
                if($(this).hasClass('active')) {
                    allActive++;
                }
            });
        })
        if (allActive==5){
            //document.getElementById("work_env").disabled = "";
            document.getElementById("work_env").className = "next-button-active complete rfloat";
            $(".question-set-box").removeClass('error');
            $(".question-error-message").hide();
        } else {
            document.getElementById("work_env").className = "next-button-active rfloat";
        }
    },
    show_next_hilo_search: function(recall){
        if(recall!=true) {
            setTimeout(function(){birkman_test.show_next_hilo_search(true)},50);
            return;
        }

        var allActive = 0;
        $(".question-set").each(function(){
            $(this).find('.workenv-options').children().children().each(function() {
                if($(this).hasClass('active')) {
                    allActive++;
                }
            });
        })
        if (allActive==10){
            //document.getElementById("work_env").disabled = "";
            $("#work_role_env_questions").addClass("complete");
            $(".question-set-box").removeClass('error');
            $(".question-error-message").hide();
        } else {
            $("#work_role_env_questions").removeClass("complete");
        }
    },
    save_work_env: function(){
        this.final_arr = [];
        $("#work_env").attr("disabled", "disabled");
        var flag;
        $(".workenv-options").each(function(){
            flag = false;
            $(this).children().each(function(){
                if ($(this).children().hasClass('active')){
                    birkman_test.final_arr.push($(this).children().attr('data-val'));
                    flag = true;
                }
            });
            if(flag==false)
                birkman_test.final_arr.push('');
                        
        });
        this.submit_form();
    },
    showSetTwoIntroductaryPopup: function() {
        showSetTwoIntroductaryPopup();
    },
    showSetThreeIntroductaryPopup: function() {
        showSetThreeIntroductaryPopup();
    },
    showSetFourIntroductaryPopup: function() {
        showSetFourIntroductaryPopup();
    },
    submit_form: function(){
        $("#work_env_values").val(this.final_arr.join(","));
        $('#work_evn_form').submit();
    },
    save_test_one: function(){
        this.final_arr = [];
        $("#test_one").attr("disabled", "disabled");
        var flag;
        $(".test_one_ul").each(function(){
            flag = false;
            $(this).children().each(function(){
                $(this).find('div').children().each(function(){
                    if ($(this).hasClass('active')){
                        birkman_test.final_arr.push($(this).attr('data-val'));
                        flag = true;
                    }
                });
            });
            if(flag==false)
                birkman_test.final_arr.push('');
                        
        });
	    
        this.submit_test_one();
    },
    submit_test_one: function(){
        $("#test_response").val(this.final_arr.join(","));
        $('#test_form').submit();
    },
    show_next_test_one: function(question_size,recall){
        if(recall!=true) {
            setTimeout(function(){birkman_test.show_next_test_one(question_size,true)},50);
            return;
        }
        var allActive = 0;
	    
        $(".test_one_ul").each(function(){
            $(this).find(".options").children().each(function(){
                if($(this).hasClass('active')) {
                    allActive++;
                }
            });
        });
        if (allActive==question_size){
            //document.getElementById("test_one").disabled = "";
            document.getElementById("test_one").className = "next-button-active complete rfloat";
            $(".question-set-box").removeClass('error');
            $(".question-error-message").hide();
        } else {
            document.getElementById("test_one").className = "next-button-active rfloat";
        }
    },
    save_test_two: function(){
        this.final_arr = [];
        $("#test_two").attr("disabled", "disabled");
        $(".test_two_ul").each(function(){
            flag = false;
            $(this).children().each(function(){
                $(this).find('div').children().each(function(){
                    if ($(this).hasClass('active')){
                        birkman_test.final_arr.push($(this).attr('data-val'));
                        flag = true;
                    }
                });
            });
            if(flag==false)
                birkman_test.final_arr.push('');
        })
        this.submit_test_two();
    },
	
    submit_test_two: function(){
        $("#test_response").val(this.final_arr.join(","));
        $('#test_form').submit();
    },
	
    show_next_test_two: function(question_size,recall){
        if(recall!=true) {
            setTimeout(function(){birkman_test.show_next_test_two(question_size,true)},50);
            return;
        }

        var allActive = 0;
	    
        $(".test_two_ul").each(function(){
            $(this).find(".options").children().each(function(){
                if($(this).hasClass('active')) {
                    allActive++;
                }
            });
        });
		
        if (allActive==question_size){
            //document.getElementById("test_two").disabled = "";
            //document.getElementById("test_two").className = "next-button-active rfloat";
            document.getElementById("test_two").className = "next-button-active complete rfloat";
            $(".question-set-box").removeClass('error');
            $(".question-error-message").hide();
        } else {
            document.getElementById("test_two").className = "next-button-active rfloat";
        }
    },
    test_three_click: function(e) {
		
        var ans = new Array(4);
        var i = 1;
        var j = 1;
        var flag = 0;
        var r = 0;
        var c = 0;

        $(".choices").each(function() {
            j = 1;
            ans[i] = new Array(2);
            $(this).children().each(function() {
                if($(this).hasClass('active')) {
                    ans[i][j] = 1;
                }
                else {
                    ans[i][j] = 0;
                }
                j++;
            })
            i++;
        })
		
        row = $(e).parent().attr('id');
        col = $(e).attr('id');

        for(i=1;i<5;i++) {
            for(j=1;j<3;j++) {
                if(ans[i][j] == 1)
                {
                    if(j == col){
                        ans[i][j] = 0;
                        r = i;
                        flag++;
                    }
                    if(i == row){
                        ans[i][j] = 0;
                        c = j;
                        flag++;
                    }
                }
            }
        }
		
        if(flag == 2)
        {
            ans[r][c] = 1;
        }

        ans[row][col] = 1;

        for(i=1;i<5;i++) {
            for(j=1;j<3;j++) {
                if(ans[i][j] == 1)
                {
                    $('.choices').each(function(){
                        if($(this).attr('id')==i){
                            $(this).children().each(function(){
                                if($(this).attr('id')==j){
                                    $(this).addClass('active');
                                }
                            });
                        }
                    });
                }
                else{
                    $('.choices').each(function(){
                        if($(this).attr('id')==i){
                            $(this).children().each(function(){
                                if($(this).attr('id')==j){
                                    $(this).removeClass('active');
                                }
                            })
                        }
                    });
                }
            }
        }
    },
    show_next_test_three: function(e){
		
        birkman_test.flag_show_next = 1;
        $(".test_three_ul").each(function(){
            $(this).children().each(function(){
                $(this).find('div').children().each(function(){
                    if ($(this).hasClass('active')){
                        birkman_test.flag_show_next += 1;
                    }
                })
				
            })
        });
        if (birkman_test.flag_show_next > 2){
            //document.getElementById("test_three").disabled = "";
            //document.getElementById("test_three").className = "next-button-active rfloat";
            document.getElementById("test_three").className = "next-button-active complete rfloat";
            $(".question-set-box").removeClass('error');
            $(".question-error-message").hide();
        } else {
            document.getElementById("test_three").className = "next-button-active rfloat";
        }
    },
	
    save_test_three: function(){
        this.final_arr = [];
        $("#test_three").attr("disabled", "disabled");	
        flag_fc = false;
        flag_sc = false;
		  
        $(".test_three_ul").each(function(){
            $(this).children().each(function(){
                $(this).find('div').children().each(function(){
                    if ($(this).hasClass('active')){
                        if($(this).attr('title')=="First Choice") {
                            flag_fc = true;
                            birkman_test.first_choice = $(this).attr('data-val');
                        }
                        else if($(this).attr('title')=="Second Choice") {
                            flag_sc = true;
                            birkman_test.second_choice = $(this).attr('data-val');
                        }
                    }
                })
            })
        })
        if(flag_fc==false)
            birkman_test.first_choice = '';
        if(flag_sc==false)
            birkman_test.second_choice = '';
        this.submit_test_three();
    },
	
    submit_test_three: function(){
        $("#test_response").val(this.first_choice + "__" + this.second_choice);
        $('#test_form').submit();
    }

}

var birkman_test_one = {
    final_arr: [],
    mark_ans: function(val,e){
        var img_arr = $(e).parent().parent().find("img");
        $(e).parent().parent().parent().removeClass("env-ques-color-err");
        $(img_arr[1]).attr("src","/assets/null.png");
        if (val == "true"){
            $(img_arr[0]).attr("src","/assets/true.png");
            $(img_arr[2]).attr("src","/assets/hollow_workenv_img.png");
        }else{
            $(img_arr[0]).attr("src","/assets/hollow_workenv_img.png");
            $(img_arr[2]).attr("src","/assets/false.png");
        }
    },
    save_test: function(){
        this.final_arr = [];
        var err_flag = false;
        $(".env-ques-color").parent().removeClass("env-ques-color");
        $(".ques-testone-band").each(function(){
            var img_arr = $(this).find("img");
            var local_err = true;
            if ($(img_arr[0]).attr("src").indexOf("true.png") > -1){
                birkman_test_one.final_arr.push("true");
                local_err = false;
            }

            if ($(img_arr[2]).attr("src").indexOf("false.png") > -1){
                birkman_test_one.final_arr.push("false");
                local_err = false;
            }
			
            if(local_err == true){
                err_flag = true;
                $(this).parent().addClass("env-ques-color-err");	
            }
        });
		
        if (err_flag == true){
            msg_box.show_error("[{msg: 'You must answer all of the questions.'}]");		
            return false;
        }else{
            this.submit_form();
        }

    },
    submit_form: function(){
        $("#test_response").val(this.final_arr.join(","));
        $("#question_loader").show();
        $('#test_form').submit();
    }
}


var birkman_test_three = {
    odd_arr:  ["choice-img-1","choice-img-3","choice-img-5","choice-img-7"],
    even_arr: ["choice-img-2","choice-img-4","choice-img-6","choice-img-8"],
    save_test: function(){
        var odd_error = true;
        var odd_selected = null;
        for(var j=0;j < this.odd_arr.length; j++){
            var img_name = $("." + this.odd_arr[j]).attr("src");
            if (img_name == "/assets/neutral.png"){
                odd_error = false;
                odd_selected = this.odd_arr[j];
                break;
            }
        }
		
        var even_error = true;				
        var even_selected = null;
        for(var j=0;j < this.even_arr.length; j++){
            var img_name = $("." +  this.even_arr[j]).attr("src");
            if (img_name == "/assets/neutral.png"){
                even_error = false;
                even_selected = this.even_arr[j];
                break;
            }
        }

        if(even_error || odd_error){
            msg_box.show_error("[{msg: 'Select both first choice and second choice'}]");		
        }else{
            $("#test_response").val(odd_selected + "__" + even_selected);
            $("#question_loader").show();
            $('#test_form').submit();
        }
    },
    chk_img: function(choice,e){
        var class_name = $(e).children("img:first").attr("class");
        if(birkman_test_three.odd_arr.in_array(class_name,"insensitive") > -1){
            for(var j=0;j <= birkman_test_three.odd_arr.length;j++){
                $("." + birkman_test_three.odd_arr[j]).attr("src","/assets/hollow_workenv_img.png");
            }
			
            var class_num = parseInt(class_name.split("-")[2], 10);
            var adjacent_num = class_num + 1;
            var next_num = adjacent_num + 2;

            if($(".choice-img-" + adjacent_num).attr("src") == "/assets/neutral.png"){
                if (next_num > 8){
                    for(var k=0;k < birkman_test_three.even_arr.length; k++){
                        $("." + birkman_test_three.even_arr[k]).attr("src","/assets/hollow_workenv_img.png");
                    }
                    $(".choice-img-2").attr("src","/assets/neutral.png");
                }else{
                    for(var k=0;k < birkman_test_three.even_arr.length; k++){
                        $("." + birkman_test_three.even_arr[k]).attr("src","/assets/hollow_workenv_img.png");
                    }	
                    $(".choice-img-" + next_num).attr("src","/assets/neutral.png");
                }
            }
        }

        if(birkman_test_three.even_arr.in_array(class_name,"insensitive") > -1){
            for(var j=0;j <= birkman_test_three.odd_arr.length;j++){
                $("." + birkman_test_three.even_arr[j]).attr("src","/assets/hollow_workenv_img.png");
            }	

            var class_num = parseInt(class_name.split("-")[2], 10);
            var adjacent_num = class_num - 1;
            var next_num = adjacent_num + 2;
            if($(".choice-img-" + adjacent_num).attr("src") == "/assets/neutral.png"){
                if (next_num > 7){
                    for(var k=0;k < birkman_test_three.even_arr.length; k++){
                        $("." + birkman_test_three.odd_arr[k]).attr("src","/assets/hollow_workenv_img.png");
                    }
                    $(".choice-img-1").attr("src","/assets/neutral.png");
                }else{
                    for(var k=0;k < birkman_test_three.odd_arr.length; k++){
                        $("." + birkman_test_three.odd_arr[k]).attr("src","/assets/hollow_workenv_img.png");
                    }	
                    $(".choice-img-" + next_num).attr("src","/assets/neutral.png");
                }
            }
        }

        $(e).children("img:first").attr("src","/assets/neutral.png");

    }
}



var employer_profile = {
    overview_sumit_form: function(){
        $(".profile_overview_content").hide();
        $(".profile_work_role_env_content").show();
    },
	
    work_env_role_modify: function(job_id){
        $.ajax({
            url: '/position_profile/work_env_role_modify',
            data: "job_id=" + job_id + "&modify=" + 1,
            cache: false,
            success: function() {	
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

/*
var birkman = {
	open_questionnaire: function(){
		lighty.fadeBG(true);
		lighty.fade_div_layer(35,800);	

		var id_str = "iframe_id_" + new Date().getTime();	
		
		var iframe_obj =  "<div class='birkman-container'><div style='position:absolute;top:-21;left:-21'><a href='javascript:void(0);' onclick='birkman.close_window();'><img src='/assets/lightbox-cross.png'/></a></div>";
		 iframe_obj += "<iframe id='" + id_str + "' allowTransparency='true' style='height:500px;width:830px;margin:0px;padding:0px;'  src='/questionnaire/open_questionnaire' frameborder='0'></iframe>";

		 iframe_obj += "</div>";

		$("#fade_layer_div").html(iframe_obj);
	},
	close_window: function(){
		lighty.close_fade_bg();
		$("#begin_questionnaire_button > img").attr("src","/assets/resume_questionnaire.png");
		$("#begin_questionnaire_button").hide();
		$("#check_birkman_status").show();
		this.call_remote();
	},
	call_remote: function(){
		$("#begin_questionnaire_button").hide();	
		$("#check_birkman_status").show();

		$.ajax({
		  url: '/questionnaire/check_status',
   		  cache: false,
		  success: function(data) {
				if(data == "true"){
						reload_page();
					//$("#questionnaire_button").hide();
					//$("#questionnaire_success").show();
					//$("#questionnaire_next_button").show();
				}else{
					$("#questionnaire_button").show();
					$("#questionnaire_success").hide();
					
					$("#check_birkman_status").hide();
					$("#begin_questionnaire_button").show();
				}	
		  }
		});
	}
}
*/



/*
	var work_ques_slider = {
	save :function(){
		var slider_values = [];
		$(".workenv_slider").each(function(i,e){
			if(slider_direction_arr[i] == "POS"){
				slider_values.push($(this).slider("value"));
			}else{
				slider_values.push(10 - $(this).slider("value"));
			}
		});

		$("#slider_values").val(slider_values.join(","));
	},
	onload: function(){
		if($("#slider_values").val() !=''){
			var slider_values = $("#slider_values").val().split(",");	
			$(".workenv_slider").each(function(i,e){
				if(slider_direction_arr[i] == "POS"){
					$(this).slider("value",slider_values[i]);
				}else{
					$(this).slider("value",(10 - slider_values[i]));
				}
			});
		}
	}
}
*/

/*
var role_ques_slider = {
	create: function(){
		$(".workrole_slider").slider({step: 1,min:0,max:4});
		$(".workrole_slider > a").removeClass("ui-state-default ui-corner-all");
		$(".ui-slider-handle").each(function(){
			$(this).html("<img src='/assets/work_env_slider.jpg'/>");
		});

		// $('.workenv_slider > a').addClass("ui-state-hover").removeClass("ui-state-hover");
		$('.ui-slider-handle').addClass("ui-state-hover").removeClass("ui-state-hover");
	},	
	save :function(){
		var slider_values = [];
		$(".workrole_slider").each(function(i,e){
			slider_values.push($(this).slider("value"));
		});

		$("#slider_values").val(slider_values.join(","));
	},
	onload: function(){
		if($("#slider_values").val() !=''){
				var slider_values = $("#slider_values").val().split(",");	
				$(".workrole_slider").each(function(i,e){
				$(this).slider("value",slider_values[i]);
			});
		}
	}
}
//137460817
*/