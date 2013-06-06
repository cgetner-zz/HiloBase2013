var clicked_basics= false;
var clicked_credentials= false;

Array.prototype.has = function(value) {
    var i;
    for (var i = 0, loopCnt = this.length; i < loopCnt; i++) {
        if (this[i] == value) {
            return true;
        }
    }
    return false;

};

Array.prototype.clean = function(deleteValue) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == deleteValue) {
            this.splice(i, 1);
            i--;
        }
    }
    return this;
};


var calculate_compensation = {
    slider_position: null,
    initialize: function(slider_pos){
        this.slider_position = slider_pos;
        this.fill_values();
    },
    call: function(event,ui){
		
        this.slider_position = ui.values;
        this.fill_values();
        validateBasic();
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

var create_slider = {
    call: function(){
        $("#slider").slider({
            range: true,
            min: 20000,
            max: 300000,
            step: 5000,
            values: [ 20000, 40000 ],
            slide: function(event,ui){
                if(ui.values[0] > 200001) {
                    $("#salary-tooltip").fadeIn();
                    setTimeout(function(){
                        $("#salary-tooltip").fadeOut();
                    },5000);
                    return false;
                } else {
                    $("#salary-tooltip").hide();
                }
                calculate_compensation.call(event,ui);
            }
        });
		
        $("#slider > a").removeClass("ui-state-default ui-corner-all");
        calculate_compensation.initialize([ 20000, 40000 ]);
        var slider_handle_arr = $(".ui-slider-handle");
        $(slider_handle_arr[0]).html("<img src='/assets/employer_v2/slider-small-new.png' />");
        $(slider_handle_arr[1]).html("<img src='/assets/employer_v2/slider-small-new.png' />");
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
                document.getElementById('alert_update_button').className = 'update-button-active rfloat';
            //calculate_compensation.call(event,ui);
                
            }
        });
        //calculate_compensation.initialize(1);
        var slider_handle_arr = $(".ui-slider-handle");
        $(slider_handle_arr[0]).html("<img src='/assets/slider_handle_new.png' width='60' height='20' />");
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
        var slider_handle_arr = $(".ui-slider-handle");
        $(slider_handle_arr[0]).html("<img src='/assets/slider_handle_role.png' width='25' height='8' />");
    }
}
var validate_pairing_basics_csv2 = {
    call: function(save_type_val){
		
        $("#save_type").val(save_type_val);
        $("#compensation_value_min").val($("#slider").slider("values")[0]/1000);
        $("#compensation_value_max").val($("#slider").slider("values")[1]/1000);
        var employment_arr = document.getElementsByName("desired_employments[]");
        this.fill_employment_field();
        this.fill_location_field();
        if(save_type_val == "update"){
            if($('#next_button').hasClass('active')){
                $('#next_button').hide();
                $('#loader_basic').show();
                $('#basic_form').submit();
            }
        }	
        else if(save_type_val == "save_return") {
            $("#basic_form").submit();
        }
        else{
            ppComplete();
        }
    },
    fill_employment_field: function(){
        var employment_arr = document.getElementsByName("desired_employments[]");
        var id_arr = [];
        for (var i=0;i < employment_arr.length ; i++){
            if(employment_arr[i].checked == true){
                id_arr.push(employment_arr[i].value);
            }
        }
        $("#desired_employment_ids").val(id_arr.join(","));
    },
    fill_location_field: function(){
        var location_arr = document.getElementsByName("desired_locations");
        for (var i=0;i < location_arr.length ; i++){
            if(location_arr[i].checked == true){
                $("#desired_location_ids").val(location_arr[i].value);
                break;
            }
            else {
                $("#desired_location_ids").val("");
                if($("#cs_city").parent().hasClass("input-text")) {
                    $("#desired_city").val("")
                }
                else {
                    $("#desired_location_ids").val(1);
                    $("#desired_city").val($("#cs_city").val());
                }
            }
        }
		
    }
}
var validate_pairing_basics = {
    call: function(save_type_val){
        var employment_arr = document.getElementsByName("desired_employments[]");
        var error = true;
        for(var i=0; i < employment_arr.length; i++){
            if (employment_arr[i].checked == true){
                error = false;
                break;
            }
        }

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
        var employment_arr = document.getElementsByName("desired_employments[]");
        var id_arr = [];
        for (var i=0;i < employment_arr.length ; i++){
            if(employment_arr[i].checked == true){
                id_arr.push(employment_arr[i].value);
            }
        }
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

var mark_slider_values = {
    call: function(min, max){
        $("#slider").slider("values",[min,max]);
    }
}


var mark_workexp_slider =  function(workexp_val){
    var index_val =	workexp_arr.in_array(workexp_val);
    if (index_val != -1 )
    {
        $("#workexp_slider").slider("value",(index_val));
    }
}

function certbox_submit(){
    if($("#add_cert_text").val().replace(/\s/g,"") == "")
    {
        return false;
    }
    certificate.add_to_list($("#add_cert_text").val());
    if (login_section_type == "job_seeker"){
        if($(".credential-table li").length == 5){
            document.getElementById('certificate-add-button').disabled = true;
            $("#certificate-add-button").hide();
        }
    //credential_enter();
    }
    return false;
}

var certificate = {
    list_arr: [],
    initialize: function(cert_values){
        if(cert_values != "_jucert_"){
            this.list_arr = unescape_str_new(cert_values).split("_jucert_");
            //$("#certificate-add").hide();
            //$("#certificate-selector-block").show();
            //$("#cert-table").css("display:block");
            $("#validate-certificate").val("1");
        }
        this.list_arr.clean("");
        this.create_elements();
    },
    show: function(){
        $("#cert_add_link").hide();	
        $("#cert_add_box").show();
        $("#add_cert_text").focus();
    },
    hide: function(){
        $("#cert_add_link").show();	
        $("#cert_add_box").hide();	
        $("#add_cert_text").val("");
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
    add_another: function(value){
        if(validateRequired($("#add_cert_text").val())) {
            if($("#validate-certificate").val()=="1"){
                if(!this.list_arr.has(value) && unescape_str_new(value) != jQuery.trim($("#add_cert_text_placeholder").val()) && value.trim()!="")
                {
                    this.list_arr.push(unescape_str_new(value));
                    if($("#editing").val() != "") {
                        $("#editing").val("");
                    }

                }
                this.list_arr.clean("");
                this.create_elements();
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
            }
            else{
				
        }
        }
        var str = "";
        if($("#validate-certificate").val()=="1"){
            $("div#licensesAndCertifications-Div").html("");
            for(var i=0; i<this.list_arr.length; i++){
                str += "<div class='licenses_Certifications_container'><div class='top-curve'>&nbsp;</div><div class='content'><label onclick='active_inactive_buttons();certificate.edit_row("+i+")'><a style='cursor: default;' id='123' href='javascript:void(0);'>"+unescape_str_new(this.list_arr[i])+"</a></label><a class='remove' title='remove' onclick='active_inactive_buttons();certificate.remove_row("+i+");hideCertificateInnerTextBox();' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div></div>";
            }
            //$('#cert-table').show();
            $("div#licensesAndCertifications-Div").append(str);
            $("#licensesAndCertifications-Div").show();
            if(edit != "edit"){
                if(delete_row != "delete"){
                    //$("#validate-certificate").val('0');
                    $('#add_cert_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
                    $('#add_cert_text').val($('#add_cert_text_placeholder').val());
                }
            }
        }
        if(edit != "edit"){
            $("#validate-certificate").val("0");
        }
    },
    edit_row: function(val){
        //        if($('.edit-show').is(':visible')==true) {
        //            if ($("#certificate-add-button").hasClass('edit-row')){
        //                certbox_submit();
        //            }
        //
        //        }
        this.add_another($('#add_cert_text').val());
        for (var i = 0; i < this.list_arr.length; i++){
            if (val == i)
            {
                $("#add_cert_text").val(this.list_arr[i]);
                $("#validate-certificate").val('1');
                $("#add_cert_text").parent().removeClass("input-text input-text-active active-input input-text-error");
                $("#add_cert_text").parent().addClass('active-input');
            }
        }
        $('#certificate').html("<input type='hidden' name='editing' value='editing-cert' id='editing' />");
        certificate.remove_row(val,"edit");
        $("#certificate-remove").show();
    },
    remove_row: function(val,edit){
        var new_arr = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        //console.log(this.list_arr);
        $("#validate-certificate").val("1");
        this.create_elements(edit, "delete");

        //this.list_arr.push(unescape_str_new(val));

        if (login_section_type == "job_seeker"){
    //credential_enter();
    }

    },
    
    apply_click_event_for_required: function(){
        $(".credential-cert-required > a").live("click",function(){
            $(this).parent().siblings().find("img").attr("src","/assets/hollow_workenv_img.png");
            $(this).children("img").attr("src","/assets/employer/blue_selected_circle.png");
			
            var checked_arr = [];
		
            $(".credential-cert-required-col").each(function(){
                if($(this).find("img").first().attr("src").indexOf("blue_selected_circle") > -1){
                    checked_arr.push("0");
                }
                else if($(this).find("img").last().attr("src").indexOf("blue_selected_circle") > -1) {
                    checked_arr.push("1");
                }
                else {
				
            }
            });	
            $("#required_certificates").val(checked_arr.join(","));
	
        });
    }
}



var emp_cert_autocomplete = {
    create: function(){
        var options = { 
            serviceUrl:'/ajax/get_certificates_for_employer' ,
            width:370,
            maxHeight:100
        };

        certificate_autocomplete = $('#add_cert_text').autocomplete(options);
    }
}

var cert_autocomplete = {
    create: function(){
        var options = { 
            serviceUrl:'/ajax/get_certificates' ,
            width:370,
            maxHeight:100
        };

        certificate_autocomplete = $('#add_cert_text').autocomplete(options,"certificate_click_autocomplete()","cert-list");
    }
}

// calls ajax for university DB 
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

function employer_profbox_submit(){
    if($("#add_prof_text").val().replace(/\s/g,"") == "")
    {
        return false;
    }
    employer_proficiency.add_to_list($("#add_prof_text").val());
    return false;
}

function profbox_submit(){
    if($("#add_prof_text").val().replace(/\s/g,"") == "")
    {
        return false;
    }
    proficiency.add_to_list($("#add_prof_text").val());
    return false;
}

var pop_proficiency = {
    list_arr: [],
    initialize: function(prof_values){
        if(prof_values != ""){
            this.list_arr = unescape_str(prof_values).split(",");
        }
        this.create_html();
    },
    select : function(){
        var ele_arr = document.getElementsByName("pop_proficiency_select[]");
        pop_proficiency.list_arr = [];
        for (var i=0;i < ele_arr.length ;i++ ){
            if(ele_arr[i].checked){
                pop_proficiency.list_arr.push($(ele_arr[i]).val());				
            }
        }
        this.create_html();
        lighty.close_fade_bg();
    },
    create_html: function(){
        $("#prof-table").empty();
        for(var i=0;i<this.list_arr.length;i++){
            var str = "<div class='credential-row'>";
            str += "<div style='float:left;'>" +	(i + 1) + ". " + unescape_str(this.list_arr[i].split("_juprof_")[1]) + "</div>";
            str += "<div class='cert-cross' ><a href='javascript:void(0);' onclick='pop_proficiency.remove_row(" + i + ");' title='remove'>x</a></div>";
            str += "<br class='clear'/></div>";
            $("#prof-table").append(str);
        }
    },
    remove_row: function(val){
        var new_arr = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        this.create_html();
    },
    popselect: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,514);
        $.ajax({
            url: '/ajax/list_proficiencies',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data);
            }
        });
    }
}

var employer_proficiency = {
    list_arr: [],
    prof_arr: [],
    initialize: function(prof_values, emp_prof){
        if(prof_values != ""){
            this.list_arr = unescape_str(prof_values).split("_juprof_");
        }
        if(emp_prof != ""){
            this.prof_arr = unescape_str(emp_prof).split(",");
        }
        this.create_elements();
    },
    show: function(){
        $("#prof_add_link").hide();	
        $("#prof_add_box").show();
        $("#add_prof_text").focus();
    },
    hide: function(){
        $("#prof_add_link").show();	
        $("#prof_add_box").hide();	
        $("#add_prof_text").val("");
    },
	
    add_to_list: function(value){
        $("#add_prof_text").val("");
        $("#prof_error_div_add_invalid").hide();
        if(this.list_arr.in_array(value,"insensitive") == -1)
        {
            if(this.prof_arr.in_array(value,"insensitive") == -1)
            {
                $("#prof_error_div_add_invalid").show();
            }
            else {
                if(login_section_type == "employer" && $(".proficiency-row").length + 1 > 5){
				
                    $("#prof_error_div").show();
                }
                else{
                    this.list_arr.push(unescape_str(value));
                    this.create_elements();
                }
            }
        }
    },
    create_elements: function(){
        $("#prof-table").empty();
        if(login_section_type == "employer"){
            for(var i=0;i<this.list_arr.length;i++){
                var str = "<div class='proficiency-row'>";
                str += "<div style='float:left;'>" +	(i + 1) + ". " + unescape_str(this.list_arr[i]) + "</div>";
                str += "<div class='cert-cross' ><a href='javascript:void(0);' onclick='employer_proficiency.remove_row(" + i + ");' title='remove'>x</a></div>";
                str += "<br class='clear'/></div>";
                $("#prof-table").append(str);
            }
        }
        else {
            for(var i=0;i<this.list_arr.length;i++){
                var str = "<div class='credential-row'>";
                str += "<div style='float:left;'>" +	(i + 1) + ". " + unescape_str(this.list_arr[i]) + "</div>";
                str += "<div class='cert-cross' ><a href='javascript:void(0);' onclick='proficiency.remove_row(" + i + ");' title='remove'>x</a></div>";
                str += "<br class='clear'/></div>";
                $("#prof-table").append(str);
            }
        }
    },
    remove_row: function(val){
        if(login_section_type == "employer"){
            $("#prof_error_div").hide();
        }
        var new_arr = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        this.create_elements();
    }
}

var proficiency = {
    list_arr: [],
    initialize: function(prof_values){
        if(prof_values != ""){
            this.list_arr = unescape_str(prof_values).split("_juprof_");
        }
        this.create_elements();
    },
    show: function(){
        $("#prof_add_link").hide();	
        $("#prof_add_box").show();
        $("#add_prof_text").focus();
    },
    hide: function(){
        $("#prof_add_link").show();	
        $("#prof_add_box").hide();	
        $("#add_prof_text").val("");
    },
	
    add_to_list: function(value){
        $("#add_prof_text").val("");
        if(this.list_arr.in_array(value,"insensitive") == -1)
        {
            if(login_section_type == "employer" && $(".proficiency-row").length + 1 > 5){
				
                $("#prof_error_div").show();
            }
            else{
                this.list_arr.push(unescape_str(value));
                this.create_elements();
            }
        }
    },
    create_elements: function(){
        $("#prof-table").empty();
        if(login_section_type == "employer"){
            for(var i=0;i<this.list_arr.length;i++){
                var str = "<div class='proficiency-row'>";
                str += "<div style='float:left;'>" +	(i + 1) + ". " + unescape_str(this.list_arr[i]) + "</div>";
                str += "<div class='cert-cross' ><a href='javascript:void(0);' onclick='proficiency.remove_row(" + i + ");' title='remove'>x</a></div>";
                str += "<br class='clear'/></div>";
                $("#prof-table").append(str);
            }
        }
        else {
            for(var i=0;i<this.list_arr.length;i++){
                var str = "<div class='credential-row'>";
                str += "<div style='float:left;'>" +	(i + 1) + ". " + unescape_str(this.list_arr[i]) + "</div>";
                str += "<div class='cert-cross' ><a href='javascript:void(0);' onclick='proficiency.remove_row(" + i + ");' title='remove'>x</a></div>";
                str += "<br class='clear'/></div>";
                $("#prof-table").append(str);
            }
        }
    },
    remove_row: function(val){
        if(login_section_type == "employer"){
            $("#prof_error_div").hide();
        }
        var new_arr = [];
        for(var i =0; i < this.list_arr.length; i++){
            if (val != i)
            {
                new_arr.push(this.list_arr[i]);
            }
        }
        this.list_arr = new_arr;
        this.create_elements();
    }
}

var prof_autocomplete = {
    create: function(){
        var options = { 
            serviceUrl:'/ajax/get_proficiencies' ,
            width:270,
            maxHeight:100
        };

        proficiency_autocomplete = $('#add_prof_text').autocomplete(options, "skills_click_autocomplete()", "skill-dropdown");
    }
}

var college_autocomplete = {
    create: function(){
        var options = {
            serviceUrl: '/ajax/get_universities',
            width: 370,
            maxHeight: 100
        };

        colleges_autocomplete = $('#add_uni_text').autocomplete(options, "college_keyup_autocomplete()", "college-dropdown");
    }
}

var emp_prof_autocomplete = {
    create: function(){
        var options = { 
            serviceUrl:'/ajax/get_proficiencies_for_employer' ,
            width:270,
            maxHeight:100
        };

        proficiency_autocomplete = $('#add_prof_text').autocomplete(options);
    }
	
}

var select_highest_education = function(degree_id){
    $("#selected_degrees_id").val(degree_id);
    $(".degree-box").each(function(){
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

var sumbit_credential_page ={
    call: function(save_type){
        $("#certificate_param").val(certificate.list_arr.join("_jucert_"));
        $("#proficiency_param").val(proficiency.list_arr.join("_juprof_"));
        $("#workexp_value").val(workexp_arr[parseInt($("#workexp_slider").slider("value"),10)]);
        $("#save_type").val(save_type);
		
        //this.fill_degree_field();
        if(save_type == "save_n_return")
        {
            document.forms["credential_form"].submit();	
        }else{
            if(this.validate())
            {
                document.forms["credential_form"].submit();
            }
        }
    },
    fill_degree_field: function(){
    /*var degree_arr = document.getElementsByName("selected_degrees[]");
		var id_arr = [];
		for (var i=0;i < degree_arr.length ; i++){
			if(degree_arr[i].checked == true){
				id_arr.push(degree_arr[i].value);
			}
		}
		$("#selected_degrees_id").val(id_arr.join(","));*/
    },
    validate: function(){
        var error = true;
        var err_arr = [];
        var ele_arr = document.getElementsByName("selected_degrees[]");
        if ($("#selected_degrees_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'degree_earned', 'msg' : 'Please select atleast one Educational Accomplishments.'}");	
        }
		
		
        if (proficiency.list_arr.length < 1)
        {
            err_arr.push("{'key' : 'proficiency_required', 'msg' : 'Please enter atleast one proficiency.'}");	
        }
		
        if (err_arr.length > 0)
        {
            msg_box.show_error("[" + err_arr.join(",") + "]");
            return false;
        }
		
        return true;
    }
}


var workexp_slider = {
    create: function(workexp_max_val){
        $("#workexp_slider").slider({
            step: 1,
            min: 0,
            max: workexp_max_val
        });
        $("#workexp_slider > a").removeClass("ui-state-default ui-corner-all");
        var slider_handle_arr = $(".ui-slider-handle");
        if (slider_handle_arr.length > 1)
        {
            $(slider_handle_arr[1]).html("<img src='/assets/slider_handle_33.png' />");	
        }else{
            $(slider_handle_arr[0]).html("<img src='/assets/slider_handle_33.png' />");
        }
    }
}


var emp_select_lang_pop = {
    init:function(){
        this.apply_required_click_event();
    },
    done: function(){
        $("#lang-box").empty();	
        var html_str = "";
        $(".emp-lang-select").each(function(){
            if($(this).attr("checked") == true){
                html_str += "<div class='credential-lang-required-col'>";
                html_str += "<div class='credential-lang-required'><a href='javascript:void(0);'><img src='/assets/hollow_workenv_img.png' data-lang-id='" + $(this).val() + "'/></a></div>";
                html_str += "<div class='credential-lang-required'><a href='javascript:void(0);'><img src='/assets/neutral.png' data-lang-id='" + $(this).val() + "'/></a></div>";
                html_str += "<div class='clear-height'></div>";
                html_str += "</div>";
				
                html_str += "<div class='credential-lang-select'>";
                html_str += $(this).attr("data-lang-name");
				
                html_str += "</div><div class='clear-height'></div>";
                html_str += "<div class='emp-lang-row-sep'></div>";
            }
        });

        $("#lang-box").html(html_str);
        this.close();
    },
    apply_required_click_event: function(){
        $(".credential-lang-required > a").live("click",function(){
            $(this).parent().siblings().find("img").attr("src","/assets/hollow_workenv_img.png");
            $(this).children("img").attr("src","/assets/neutral.png");
        });
    },
    close: function(){
        lighty.fadeBG(false);
        $("#lang_popup").hide();
    },
    clear: function(){
        $(".emp-lang-select").attr("checked",false);
    }		
}

var lang_menu = {
    lang_id: null,
	
    apply: function(){
        $(".lang-val").click(function(){
            lang_menu.lang_id = $(this).attr("id").split("_")[2];	
            lang_menu.show_menu();
        });
    },
    show_menu: function(){
        var pos = $("#lang_link_" + this.lang_id).position();
        if($("#lang_link_" + this.lang_id).hasClass("advanced-lang") || $("#lang_link_" + this.lang_id).hasClass("conversational-lang")){
            $("#lang-type-popup-clear").show();
        }else{
            $("#lang-type-popup-clear").hide();	
        }
        var left_margin = $("#lang_link_" + this.lang_id).parent().width() + pos.left + 10;
        $("#lang_type_popup").css("top",pos.top - 16).css("left",left_margin).show();
    },
    menu_element: function(){
		
    },
    select_level: function(level){
        switch(level){
            case "conversational" :
                $("#lang_link_" + this.lang_id).removeClass("advanced-lang").addClass("conversational-lang");
                break;
            case "advanced" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").addClass("advanced-lang");	
                break;
            case "clear" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").removeClass("advanced-lang");	
                break;
        }	
        $("#lang_type_popup").hide();
    },
    select_level_emp: function(level){
		
        switch(level){
            case "desired" :
                $("#lang_link_" + this.lang_id).removeClass("advanced-lang").addClass("conversational-lang");
                break;
            case "advanced" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").addClass("advanced-lang");	
                break;
            case "clear" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").removeClass("advanced-lang");	
                break;
        }	
        $("#lang_type_popup").hide();
    }
}

var employer_select_lang_pop = {
    lang_id: null,
    l:'123',
    apply: function(){
		
        $(".des_req").click(function(){
            employer_select_lang_pop.lang_id = $(this).attr("id").split("_")[2];
        });
    },
    select_level_emp: function(ele, level){
        l = $(ele).attr("id").split("_")[2];
        switch(level){
            case "desired" :
                $(ele).find("img").attr("src","/assets/employer/blue_selected_circle.png");
                $("#desired_required_" + l).attr("src","/assets/employer/grey_unselected_circle.png");
                $("#required_" + l).attr("src","/assets/employer/grey_unselected_circle.png");
                //this.desired_required_check("desired", l);
                this.fill_selected_languages();
                break;
            case "required" :
                $(ele).find("img").attr("src","/assets/employer/blue_selected_circle.png");
                $("#desired_required_" + l).attr("src","/assets/employer/grey_unselected_circle.png");
                $("#desired_" + l).attr("src","/assets/employer/grey_unselected_circle.png");
                //this.desired_required_check("required", l);
                this.fill_selected_languages();
                break;
        }	
        $("#lang_type_popup").hide();
    },
    fill_selected_languages: function(){
        var checked_arr = [];
        var selected_arr = [];
        $(".langauge_skill_pgraph").each(function(){
            if($(this).find("img").first().attr("src").indexOf("blue_selected_circle") > -1){
                checked_arr.push("0");
            }else if($(this).find("img").last().attr("src").indexOf("blue_selected_circle") > -1){

                checked_arr.push("1");
            }
            else {
				
        }
        });
        $("#required_languages").val(checked_arr.join(","));
		
    },
    desired_required_check: function(value, lang){
        var lang_arr_emp = [];
        var lang_str = $("#selected_languages").val();
        var lang_arr = lang_str.split(",");
        for(var i=0;i<lang_arr.length;i++)
        {
            if(lang_arr[i] == ""){
                continue;
            }
            var lang_val = lang_arr[i].split("__");
           
            if(lang == i+1){
                if (lang_val[2]){
                    lang_val[2] = "";
                    if (value == "desired"){
                        lang_val[2] = "d";
                    }
                    if(value == "required") {
                        lang_val[2] = "r";
                    }
                }
                else {
                    if (value == "desired"){
                        lang_val[2] = "d";
                    }
                    if(value == "required") {
                        lang_val[2] = "r";
                    }
                }
            }
            if (lang_val[2]){
                var id_prof_val = lang_val[0] + "__" + lang_val[1] + "__" + lang_val[2];
            }
            else {
                var id_prof_val = lang_val[0] + "__" + lang_val[1];
               
            }
            lang_arr_emp.push(id_prof_val);
        }
        $("#selected_languages").val(lang_arr_emp.join(","));
    },
    open: function() {
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,563);	
        $("#lang_popup").css("left",$("#fade_layer_div").css("left"));
        $("#lang_popup").css("top",$("#fade_layer_div").css("top"));
        $("#lang_popup").show();
        $("#lang_error_div").hide();
        this.mark_check();
		
    },
    init_onload: function(){
        this.mark_check();
        this.create_html();
    },
    mark_check:function(){
        this.clear();
        var lang_str = $("#selected_languages").val();
        var lang_arr = lang_str.split(",");
        for(var i=0;i<lang_arr.length;i++)
        {
            if(lang_arr[i] == ""){
                continue;
            }	
            var lang_val = lang_arr[i].split("__");
            $("#lang_link_" + lang_val[0]).removeClass("advanced-lang").removeClass("conversational-lang");
            var class_name = "";
            if(lang_val[1] == "a"){
                class_name = "advanced-lang";
            }else if(lang_val[1] == "c"){
                class_name = "conversational-lang";
            }
            $("#lang_link_" + lang_val[0]).addClass(class_name);
        }
    },
    close: function(){
        lighty.fadeBG(false);
        $("#lang_popup").hide();
    },
    clear: function(){
        $(".lang-val").each(function(){
            $(this).removeClass("advanced-lang").removeClass("conversational-lang");
        });	
    },
    employer_clear: function(){
        $(".lang-val").each(function(){
            $(this).removeClass("advanced-lang").removeClass("conversational-lang");
        });	
        $("#required_languages").val("");
    },
    done: function(){
        var lang_arr = [];
        var name_arr = [];
		
        $(".lang-val").each(function(){
            if($(this).hasClass("conversational-lang")){
                var id_prof_val = $(this).attr("id").split("_")[2] + "__" + "c";
                lang_arr.push(id_prof_val);
                name_arr.push($(this).html());
            }

            if($(this).hasClass("advanced-lang")){
                var id_prof_val = $(this).attr("id").split("_")[2] + "__" + "a";
                lang_arr.push(id_prof_val);
                name_arr.push($(this).html());
            }
        });

		
        if (lang_arr.length > 5){
            $("#lang_error_div").show();
            return false;
        }else{
            $("#selected_languages").val(lang_arr.join(","));
            this.create_html();
            this.close();
        //this.select();
        }
    },
    select_on_open: function(){
        $(".lang-val").each(function(){
            $(this).removeClass("conversational-lang").removeClass("advanced-lang");
        });
        var selected_arr = $("#selected_languages").val().split(",");
        for (var i=0;i < selected_arr.length ;i++ ){
            if(selected_arr[i] == ""){
                continue;
            }
            var class_name = "";
            if(selected_arr[i].split("__")[1] == "a"){
                class_name = "advanced-lang";		
            }
            else{
                class_name = "conversational-lang";
            }
            $("lang_link_" + selected_arr[i][0]).addClass(class_name); 
        }

    },
    create_html: function(name_arr,lang_arr){
        var name_arr = [];
        var class_arr = [];
        var desired = 'desired';
        //$("#lang-box").html("");

        $(".lang-val").each(function(){
            if($(this).hasClass("conversational-lang")){
                name_arr.push($(this).html());
                class_arr.push("conversational-lang");
            }else if($(this).hasClass("advanced-lang")){
                name_arr.push($(this).html());
                class_arr.push("advanced-lang");
            }
        });
        for (var i=0;i < 5 ; i++){
            $("#lang-cell-" + (i + 1)).html("");
            $("#lang-cell-" + (i + 1)).hide();
        }
        for (var i=0;i < name_arr.length ; i++)
        {
            /*if((i % 3) == 0){
				$(".lang-row").last().append("<br class='clear'/>");
				$("#lang-box").append("<div class='lang-row'></div>");
			}
			//var lang_class = this.proficiency_color(lang_arr[i]);
			var req_str = "";
			if(login_section_type == 'employer'){
				req_str = "<input type='checkbox' name='required_languages[]' class='req-lang'/>&nbsp;";
			}
			$(".lang-row").last().append("<div class='lang-name " + class_arr[i] + " ' >" + req_str + name_arr[i] + "</div>");
			*/
            $("#lang-cell-" + (i + 1)).html("&nbsp;");
            $("#lang-cell-" + (i + 1)).show();
            $("#lang-cell-" + (i + 1)).append("<div class='lang-name " + class_arr[i] + " ' >" +  name_arr[i] + "</div>");
            $("#lang-cell-" + (i + 1)).append("<div class='langauge_skill_pgraph'><a href='javascript:void(0);' onclick='employer_select_lang_pop.select_level_emp(this,&#34;desired&#34;)' class='des_req' id='des_req_" + (i+1) + "'><img class='desiredImg_unselect' id='desired_" + (i+1) + "'src='/assets/employer/grey_unselected_circle.png'></a><div class='langauge_skill_desired'>Desired</div><img class='desiredImg_select' id='desired_required_" + (i+1) + "' src='/assets/employer/blue_selected_circle.png'><a href='javascript:void(0);' onclick='employer_select_lang_pop.select_level_emp(this,&#34;required&#34;)' class='des_req' id='des_req_" + (i+1) + "'><img class='requiredImg_unselect' id='required_" + (i+1) + "'src='/assets/employer/grey_unselected_circle.png'></a><div class='langauge_skill_Required'>Required</div></div>");
            employer_mark_required_lang_and_certificates();
			
        }
    //$(".lang-row").last().append("<br class='clear'/>");
    },
    select_level: function(level){
        lang_id = $(this).attr("id").split("_")[2];
        switch(level){
            case "desired" :
                $("#lang_link_" + this.lang_id).removeClass("advanced-lang").addClass("conversational-lang");
                break;
            case "advanced" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").addClass("advanced-lang");	
                break;
            case "clear" :
                $("#lang_link_" + this.lang_id).removeClass("conversational-lang").removeClass("advanced-lang");	
                break;
        }	
        $("#lang_type_popup").hide();
		
    },
    proficiency_color: function(val){
        if (val.indexOf("a") > -1){
            return "advanced-lang";
        }else{
            return "conversational-lang";
        }
    }
	
}

var select_lang_pop = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(80,563);	
        $("#lang_popup").css("left",$("#fade_layer_div").css("left"));
        $("#lang_popup").css("top",$("#fade_layer_div").css("top"));
        $("#lang_popup").show();
        $("#lang_error_div").hide();
        this.mark_check();

    },
    init_onload: function(){
        this.mark_check();
        this.create_html();
    },
    mark_check:function(){
        this.clear();
        var lang_str = $("#selected_languages").val();
        var lang_arr = lang_str.split(",");
        for(var i=0;i<lang_arr.length;i++)
        {
            if(lang_arr[i] == ""){
                continue;
            }	
            var lang_val = lang_arr[i].split("__");
            $("#lang_link_" + lang_val[0]).removeClass("advanced-lang").removeClass("conversational-lang");
            var class_name = "";
            if(lang_val[1] == "a"){
                class_name = "advanced-lang";
            }else if(lang_val[1] == "c"){
                class_name = "conversational-lang";
            }
            $("#lang_link_" + lang_val[0]).addClass(class_name);
        }
    },
    close: function(){
        lighty.fadeBG(false);
        $("#lang_popup").hide();
    },
    clear: function(){
        $(".lang-val").each(function(){
            $(this).removeClass("advanced-lang").removeClass("conversational-lang");				
        });	

    },
    done: function(){
        var lang_arr = [];
        var name_arr = [];
		
        $(".lang-val").each(function(){
            if($(this).hasClass("conversational-lang")){
                var id_prof_val = $(this).attr("id").split("_")[2] + "__" + "c";
                lang_arr.push(id_prof_val);
                name_arr.push($(this).html());
            }

            if($(this).hasClass("advanced-lang")){
                var id_prof_val = $(this).attr("id").split("_")[2] + "__" + "a";
                lang_arr.push(id_prof_val);
                name_arr.push($(this).html());
            }
        });

		
        if (lang_arr.length > 6){
            $("#lang_error_div").show();
            return false;
        }
        else{
            $("#selected_languages").val(lang_arr.join(","));
            this.create_html();
            this.close();
        //this.select();
        }
    },
    select_on_open: function(){
        $(".lang-val").each(function(){
            $(this).removeClass("conversational-lang").removeClass("advanced-lang");
        });
        var selected_arr = $("#selected_languages").val().split(",");
        for (var i=0;i < selected_arr.length ;i++ ){
            if(selected_arr[i] == ""){
                continue;
            }
            var class_name = "";
            if(selected_arr[i].split("__")[1] == "a"){
                class_name = "advanced-lang";		
            }else{
                class_name = "conversational-lang";
            }
            $("lang_link_" + selected_arr[i][0]).addClass(class_name); 
        }

    },
    create_html: function(name_arr,lang_arr){
        var name_arr = [];
        var class_arr = [];
        //$("#lang-box").html("");

        $(".lang-val").each(function(){
            if($(this).hasClass("conversational-lang")){
                name_arr.push($(this).html());
                class_arr.push("conversational-lang");
            }else if($(this).hasClass("advanced-lang")){
                name_arr.push($(this).html());
                class_arr.push("advanced-lang");
            }
        });
        for (var i=0;i < name_arr.length ; i++)
        {
            /*if((i % 3) == 0){
				$(".lang-row").last().append("<br class='clear'/>");
				$("#lang-box").append("<div class='lang-row'></div>");
			}
			//var lang_class = this.proficiency_color(lang_arr[i]);
			var req_str = "";
			if(login_section_type == 'employer'){
				req_str = "<input type='checkbox' name='required_languages[]' class='req-lang'/>&nbsp;";
			}
			$(".lang-row").last().append("<div class='lang-name " + class_arr[i] + " ' >" + req_str + name_arr[i] + "</div>");
			*/
            $("#lang-cell-" + (i + 1)).html("");
            $("#lang-cell-" + (i + 1)).append("<div class='lang-name " + class_arr[i] + " ' >" +  name_arr[i] + "</div>");
			
        }
    //$(".lang-row").last().append("<br class='clear'/>");
    },
    proficiency_color: function(val){
        if (val.indexOf("a") > -1){
            return "advanced-lang";
        }else{
            return "conversational-lang";
        }
    }
}

var chk_unchk_lang = function(ele){
    var ele_name = $(ele).attr("name");
    var ele_arr = document.getElementsByName(ele_name);
    for (var i = 0;i < ele_arr.length ;i++ )
    {
        if (ele_arr[i].value != $(ele).val())
        {
            ele_arr[i].checked = false;
        }
    }

}


var save_account_pairing = {
    call: function(){
        if(!this.validate()){
            return false;			
        }
        $("#certificate_param").val(certificate.list_arr.join("_jucert_"));
        $("#proficiency_param").val(proficiency.list_arr.join("_juprof_"));
        $("#workexp_value").val(workexp_arr[parseInt($("#workexp_slider").slider("value"),10)]);
        $("#compensation_value_min").val($("#slider").slider("values")[0]/1000);
        $("#compensation_value_max").val($("#slider").slider("values")[1]/1000);
        /*
		$("#desired_paidtime_value").val(paidtime_arr[parseInt($("#paidtime_slider").slider("value"),10)]);
		$("#desired_commute_value").val(commute_arr[parseInt($("#commute_slider").slider("value"),10)]);
		*/

        validate_pairing_basics.fill_employment_field();
        validate_pairing_basics.fill_location_field();
        sumbit_credential_page.fill_degree_field();

        return true;
    },
    validate: function(){
        err_arr = [];
        var error = true;
		
        if ($("#selected_degrees_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'degree_earned', 'msg' : 'Please select atleast one Educational Accomplishments.'}");	
        }
		
        if (proficiency.list_arr.length < 1){
            err_arr.push("{'key' : 'proficiency_required', 'msg' : 'Please enter atleast one proficiency.'}");	
        }

        var employment_arr = document.getElementsByName("desired_employments[]");
        error = true;
        for(var i=0; i < employment_arr.length; i++){
            if (employment_arr[i].checked == true){
                error = false;
                break;
            }
        }

        if(error){
            err_arr.push("{'key' : 'desired_employment', 'msg' : 'Please select atleast one Desired Employment.'}");
        }


        var location_arr = document.getElementsByName("desired_locations");
        error = true;
        for(var i=0; i < location_arr.length; i++){
            if (location_arr[i].checked == true){
                error = false;
                break;
            }
        }
        if(error){
            err_arr.push("{'key' : 'desired_location', 'msg' : 'Please select Desired Location.'}");
        }

        if (err_arr.length > 0)	{
            msg_box.show_error("[" + err_arr.join(",") + "]");
            return false;
        }

        return true;
    }
}






var save_employer_basics = {
    call: function(){
        if(!this.validate()){
            return false;			
        }
		
        $("#compensation_value_min").val($("#slider").slider("values")[0]/1000);
        $("#compensation_value_max").val($("#slider").slider("values")[1]/1000);
        $("#desired_paidtime_value").val(paidtime_arr[parseInt($("#paidtime_slider").slider("value"),10)]);
        $("#desired_commute_value").val(commute_arr[parseInt($("#commute_slider").slider("value"),10)]);
        validate_pairing_basics.fill_employment_field();
        var remote_work_arr = document.getElementsByName("remote_work");
        for(var i=0; i<remote_work_arr.length ; i++){
            if(remote_work_arr[i].checked == true){
                $("#remote_work").val(remote_work_arr[i].value);	
            }
        }
		
        //validate_pairing_basics.fill_location_field();
        return true;
    },
    validate: function(){
        var email_regex = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z0-9.-]{2,4}$/;
        var num_regex = /^\d+$/;
        var position_ok=true;
        var email_ok=false;
        var city_ok=true;
        var zipcode_ok=false;
        var company_ok=true;
        err_arr = [];
        var error = true;
		
        if ($("#name").val() == ""){
            error = false;
            err_arr.push("{'key' : 'name', 'msg' : 'Please provide a Position Title.'}");	
        }
		
        if ($("#name").val().match(num_regex)){
            position_ok=false;
        }
		
        if (position_ok==false){
            error = false;
            err_arr.push("{'key' : 'name', 'msg' : 'Position title can not be numeric.'}");	
        }
		
        if ($("#company_name").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_name', 'msg' : 'Please provide a Company Name.'}");	
        }
		
        if ($("#company_name").val().match(num_regex)){
            company_ok=false;
        }
		
        if (company_ok==false){
            error = false;
            err_arr.push("{'key' : 'name', 'msg' : 'Company Name can not be numeric.'}");	
        }
		
		
        if ($("#company_group_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_group_id', 'msg' : 'Please provide a Category.'}");	
        }
		
        if ($("#company_street_one").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_street_one', 'msg' : 'Please provide a Street Address.'}");	
        }
		
        if ($("#company_city").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_city', 'msg' : 'Please provide a City.'}");	
        }
		
        if ($("#company_city").val().match(num_regex)){
            city_ok=false;
        }
		
        if (city_ok==false){
            error = false;
            err_arr.push("{'key' : 'name', 'msg' : 'City name can not be numeric.'}");	
        }
		
        if ($("#company_zip").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_zip', 'msg' : 'Please provide a Zip Code.'}");	
        }
		
        if ($("#company_zip").val().match(num_regex)){
            zipcode_ok=true;
        }
		
        if (zipcode_ok==false){
            error = false;
            err_arr.push("{'key' : 'name', 'msg' : 'Zip Code cannot contain characters.'}");	
        }
		
		
        if ($(".responsibility-field input").val() == ""){
            error = false;
            err_arr.push("{'key' : 'responsibility', 'msg' : 'Please provide atleast 1 Daily Responsibilty.'}");	
        }
		
        var employment_arr = document.getElementsByName("desired_employments[]");
        error = true;
        for(var i=0; i < employment_arr.length; i++){
            if (employment_arr[i].checked == true){
                error = false;
                break;
            }
        }

        if(error){
            err_arr.push("{'key' : 'desired_employment', 'msg' : 'Please select atleast one Desired Employment.'}");
        }
		
        var remote_work_arr = document.getElementsByName("remote_work");
        error = true;
        for(var i=0; i < remote_work_arr.length; i++){
            if (remote_work_arr[i].checked == true){
                error = false;
                break;
            }
        }
        if (error){
            err_arr.push("{'key' : 'remote_work', 'msg' : 'Please select atleast one Remote Work option.'}");
        }
		
        if ($("#company_website").val() == ""){
            error = false;
            err_arr.push("{'key' : 'company_website', 'msg' : 'Please provide a Company Website.'}");	
        }
		
        if ( ($("#company_website").val()).match(email_regex) ){
            email_ok = true;
        }
        if(email_ok==false){
            error = false;
            err_arr.push("{'key' : 'company_website', 'msg' : 'Please provide valid Email format for Company website.'}");
        }
		
        if ($("#owner_ship_type_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'owner_ship_type_id', 'msg' : 'Please provide an Ownership.'}");	
        }
		
        if ($("#summary").val() == ""){
            error = false;
            err_arr.push("{'key' : 'summary', 'msg' : 'Please provide a Position Description.'}");	
        }
		
		
	
        if (err_arr.length > 0)	{
            msg_box.show_error("[" + err_arr.join(",") + "]");
            return false;
        }

        return true;
    }
}

function showErrorPopup(error_msg){
    $("#action-button").html("<input type='button' id='error-action-button' class='delete-button-active' />");
    setContentWarningPopup("OOPS!", error_msg);
    $("#error-action-button").hide();
    $("#dashboard-warning").show();
    $('#fade_error').show();
    //showNormalShadow();
    centralizePopup();    
}

var save_employer_credentials ={
    call: function(save_type){
        $("#certificate_param").val(certificate.list_arr.join("_jucert_"));
        $("#workexp_value").val(workexp_arr[parseInt($("#workexp_slider").slider("value"),10)]);
        this.fill_required_certificates();
        this.fill_selected_languages();
        this.fill_proficiencies();
        if(!this.validate()){
            return false;
        }

    },
    fill_proficiencies: function(){
        var arr = [];
        for (var i=0;i < pop_proficiency.list_arr.length ;i++ ){
            arr.push(pop_proficiency.list_arr[i].split("_juprof_")[0]);
        }
        $("#proficiency_param").val(arr.join("_juprof_"));
    },
    fill_required_certificates: function(){
        var checked_arr = [];
		
        $(".credential-cert-required-col").each(function(){
            if($(this).find("img").first().attr("src").indexOf("neutral") > -1){
                checked_arr.push("1");
            }else{
                checked_arr.push("0");
            }		
        });
        /*$(".req-certificate").each(function(){
			if($(this).attr("checked") == true){
				checked_arr.push("1");
			}else{
				checked_arr.push("0");
			}
		});	*/	
        $("#required_certificates").val(checked_arr.join(","));
    },
    fill_selected_languages: function(){
        var checked_arr = [];
        var selected_arr = [];
        $(".credential-lang-required-col").each(function(){
            if($(this).find("img").first().attr("src").indexOf("neutral") > -1){
                checked_arr.push("1");
            }else{

                checked_arr.push("0");
            }	
			
            selected_arr.push($(this).find("img").first().attr("data-lang-id") + "__c");
        });
        $("#required_languages").val(checked_arr.join(","));
        $("#selected_languages").val(selected_arr.join(","));
		
    },
    fill_required_languages: function(){
        var checked_arr = [];
        $(".req-lang").each(function(){
            if($(this).attr("checked") == true){
                checked_arr.push("1");
            }else{
                checked_arr.push("0");
            }
        });		
		
    },
    validate: function(){
        var error = true;
        var err_arr = [];
        if ($("#selected_degrees_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'degree_earned', 'msg' : 'Please select atleast one Educational Accomplishments.'}");	
        }
		
        if($("#selected_languages").val() == ""){
            error = false;
            err_arr.push("{'key' : 'language_req', 'msg' : 'Please select atleast one language.'}");	
        }
        if (pop_proficiency.list_arr.length < 1)
        {
            err_arr.push("{'key' : 'proficiency_required', 'msg' : 'Please enter atleast one proficiency.'}");	
        }
		
        if (err_arr.length > 0)
        {
            msg_box.show_error("[" + err_arr.join(",") + "]");
            return false;
        }
		
        return true;
    }
}

var employer_save_credentials={
    call: function(save_type){
        $("#certificate_param").val(certificate.list_arr.join("_jucert_"));
        $("#proficiency_param").val(employer_proficiency.list_arr.join("_juprof_"));
        //this.fill_required_certificates();
        //this.fill_selected_languages();
        //this.fill_proficiencies();
        if(!this.validate()){
            return false;
        }

    },
    validate: function(){
        var error = true;
        var err_arr = [];
        var ele_arr = document.getElementsByName("selected_degrees[]");
        if ($("#selected_degrees_id").val() == ""){
            error = false;
            err_arr.push("{'key' : 'degree_earned', 'msg' : 'Please select atleast one Educational Accomplishments.'}");	
        }
        if($("#selected_languages").val() == ""){
            error = false;
            err_arr.push("{'key' : 'language_req', 'msg' : 'Please select atleast one language.'}");	
        }
        else {
            var lang_str = $("#selected_languages").val();
            var lang_arr = lang_str.split(",");
            var checked_arr = [];
            var selected_arr = [];
            $(".langauge_skill_pgraph").each(function(){
                if($(this).find("img").first().attr("src").indexOf("blue_selected_circle") > -1){
                    checked_arr.push("0");
                }else if($(this).find("img").last().attr("src").indexOf("blue_selected_circle") > -1){
                    checked_arr.push("1");
                }
                else{
					
            }
            });
            if (lang_arr.length > checked_arr.length ){			
                err_arr.push("{'key' : 'select_language', 'msg' : 'Please provide desired or required for one of your selected language.'}");
            }
        }
        var checked_arr = [];
        $(".credential-cert-required-col").each(function(){
            if($(this).find("img").first().attr("src").indexOf("blue_selected_circle") > -1){
                checked_arr.push("0");
            }else if($(this).find("img").last().attr("src").indexOf("blue_selected_circle") > -1) {
                checked_arr.push("1");
            }
            else {
				
        }
        });
        if (($(".credential-row").length) > checked_arr.length ){			
            err_arr.push("{'key' : 'select_certificate', 'msg' : 'Please provide desired or required for one of your selected certifications and licenses.'}");
        }
		
		
        if (employer_proficiency.list_arr.length < 1)
        {
            err_arr.push("{'key' : 'proficiency_required', 'msg' : 'Please enter atleast one proficiency.'}");	
        }
		
		
        if (err_arr.length > 0)
        {
            msg_box.show_error("[" + err_arr.join(",") + "]");
            return false;
        }
		
		
        return true;
    },
	
    fill_proficiencies: function(){
        var arr = [];
        for (var i=0;i < pop_proficiency.list_arr.length ;i++ ){
            arr.push(pop_proficiency.list_arr[i].split("_juprof_")[0]);
        }
        $("#proficiency_param").val(arr.join("_juprof_"));
    }
	
}

var mark_required_lang_and_certificates = function(){
    var req_arr = $("#required_certificates").val().split(",");
    var ele_arr = document.getElementsByName("required_certificates[]");
    $(".credential-cert-required-col").each(function(index){
        if (req_arr[index] == "1"){
            $(this).find("img").first().attr("src","/assets/neutral.png");
            $(this).find("img").last().attr("src","/assets/hollow_workenv_img.png");
        }else{
            $(this).find("img").last().attr("src","/assets/neutral.png");
            $(this).find("img").first().attr("src","/assets/hollow_workenv_img.png");
        }
    });

    var temp_arr = $("#selected_languages").val().split(",");
    var selected_arr = [];

    for(var i=0;i<temp_arr.length;i++){
        selected_arr.push(temp_arr[i].split("__")[0]);
    }

    $(".emp-lang-select").each(function(){
        if(selected_arr.in_array($(this).val()) > -1){
            $(this).attr("checked",true);
        }
    });
	
    emp_select_lang_pop.done();
    var req_arr = $("#required_languages").val().split(",");
	
    $(".credential-lang-required-col").each(function(index){
        if (req_arr[index] == "1"){
            $(this).find("img").first().attr("src","/assets/neutral.png");
            $(this).find("img").last().attr("src","/assets/hollow_workenv_img.png");
        }
        else{
            $(this).find("img").last().attr("src","/assets/neutral.png");
            $(this).find("img").first().attr("src","/assets/hollow_workenv_img.png");
        }
    });

}

var employer_mark_required_lang_and_certificates = function (){
    var req_arr = $("#required_certificates").val().split(",");
    var ele_arr = document.getElementsByName("required_certificates[]");
    $(".credential-cert-required-col").each(function(index){
        var arr = $(this).find("img");
        if (req_arr[index] == "1"){
			
            $(arr[0]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[1]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[2]).attr("src","/assets/employer/blue_selected_circle.png");
        }else if(req_arr[index] == "0"){
            $(arr[0]).attr("src","/assets/employer/blue_selected_circle.png");
            $(arr[1]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[2]).attr("src","/assets/employer/grey_unselected_circle.png");
        }
    });
	
    var req_arr = $("#required_languages").val().split(",");
    $(".langauge_skill_pgraph").each(function(index){
        var arr = $(this).find("img");
        if (req_arr[index] == "1"){
			
            $(arr[0]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[1]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[2]).attr("src","/assets/employer/blue_selected_circle.png");
        }else if(req_arr[index] == "0"){
            $(arr[0]).attr("src","/assets/employer/blue_selected_circle.png");
            $(arr[1]).attr("src","/assets/employer/grey_unselected_circle.png");
            $(arr[2]).attr("src","/assets/employer/grey_unselected_circle.png");
        }
    });
	
}
var pairing_tab_after_save_load = function(notice){
    if (notice == "Basics saved"){
        account_pairing_tab.change_tabs(1);
    }

    if (notice == "Credentials saved"){
        account_pairing_tab.change_tabs(2);
    }
}

var account_pairing_tab = {
    onload: function(){
        $(".account_pairing_tab").each(function(index){
            $(this).click(function(){
                account_pairing_tab.change_tabs(index);		
            });
        });
        enable_pairing_save_button();
    },
    change_tabs: function(index_val){
        $(".acc-tabs > div.acc-box").removeClass("acc-box").addClass("acc-box-inactive");
        $(".dummy-acc-block > div.acc-box-dummy").addClass("tab-box-dummy-inactive");

        $(".acc-tabs > div.acc-box-inactive").each(function(index){
            if(index == index_val){
                $(this).removeClass("acc-box-inactive").addClass("acc-box");
                $(this).children(".acc-inactive-text").removeClass("acc-inactive-text").addClass("acc-active-text");
            }else{
                $(this).children(".acc-active-text").removeClass("acc-active-text").addClass("acc-inactive-text");
            }
        });

        $(".dummy-acc-block > div.tab-box-dummy-inactive").each(function(index){
            if(index == index_val){
                $(this).removeClass("tab-box-dummy-inactive");
            }
        });
        this.change_section(index_val);
    },
    change_section: function(index_val){
        if (index_val == 0){
            $("#pairing_personality_section").show();
            $("#pairing_basics_section").hide();
            $("#pairing_credentials_section").hide();
            $("#acc_pairing_submit").hide();		
            $("#pairing_section").val("personality");
        }
        else if(index_val == 1){
            $("#pairing_personality_section").hide();
            $("#pairing_basics_section").show();
            $("#pairing_credentials_section").hide();
			
            if (clicked_basics==true){	
                $("#acc_pairing_submit").show();
            }
			
            $("#pairing_section").val("basic");
        }
        else if(index_val == 2){
            $("#pairing_personality_section").hide();
            $("#pairing_basics_section").hide();
            $("#pairing_credentials_section").show();
            $("#acc_pairing_submit").hide();
            if (clicked_credentials==true){
                $("#acc_pairing_submit").show();
            }
			
            $("#pairing_section").val("personality");
            $("#pairing_section").val("credential");
        }
    }
}


var pairing_work_tab = {
    load: function(){
        pairing_work_tab.event();
    },
    event: function(){
        $(".pairing-work-tab").click(function(){
            $(".pairing-work-tab-active").removeClass("pairing-work-tab-active");
            pairing_work_tab.toggle($(this).attr("data-tab-type"));	
            $(this).addClass("pairing-work-tab-active");
        });
    },
    toggle: function(tab_type){
        if(tab_type == "work"){
            $("#birk_work_section").show();
            $("#birk_role_section").hide();
        }
        else{
            $("#birk_work_section").hide();
            $("#birk_role_section").show();
        }
    }
}
/* to enable Save button on clicking on Basics and Credentials page */
var enable_pairing_save_button = function(){
    $("#account_pairing_right_basics").click(function() {
        $("#acc_pairing_submit").show();
        clicked_basics=true;
    });

    $("#account_pairing_right_credentials").click(function() {
        $("#acc_pairing_submit").show();
        clicked_credentials=true;
    });
	
}

var degree_cs = {
    initialize: function(degree_value){
        //console.log(degree_value);
        var arr = [];
        arr = unescape_str(degree_value).split("__");
        if(arr[0]!=""){
            //console.log(11);
            $('#degree-selector').find('span').text(arr[0]).addClass('text-active');
            $("#degree-options-content").find('label.label-default').text(arr[0]).addClass("text-active");
            $('#selected_status').val(1);
            $("#degree-remove").show();
        }
        if(arr[1]!=""){
            //console.log(arr[1]);
            $('#options-selector .label-default-top').text(arr[1]).addClass('text-active');
            $("#options-selector-content").find("label.label-default").text(arr[1]).addClass("text-active");
            $('#selected_degree').val(1);
            $("#degree-remove").show();
        }
       
    }
}

var language_csv2 ={
    list_arr: [],
    list_arr2: [],   
    initialize: function(lang_values){
        var temp;
        this.list_arr2 = [];
        if(lang_values != ""){
            this.list_arr = unescape_str(lang_values).split(",");
            for(var i=0;i<this.list_arr.length;i++){
                temp = this.list_arr[i].split("__");
                this.list_arr2.push(temp[0]);
            }
            //$("#language-add").hide();
            //$("#language-selector-block").show();
            $("#validate-language").val("1");
            $('#selected_language_fluency').val(1);
            $('#selected_fluency').val(0);
            $('#selected_language_1').val(0);
            active_inactive_buttons();
        }
        this.create_elements();
        
    },

    show: function(){
    //$("#language-add").hide();
    //$("#language-selector-block").show();
    },

    add_show: function(e){
        if ($(e).attr("id") != "" &&  $("#fluency-selector .label-default-top").text() != "Level of Fluency"){
        //document.getElementById("language-add-button").disabled = false;
        //document.getElementById("language-add-button").className="add-button-active lfloat margin-L-10px margin-T--1px";
        }
        $("#langauge-selector span.label-default").attr("id",$(e).attr("id"));
    },

    adv_conv: function(e){
        if ($(e).attr("id") == 2 ){
            showBlockShadow();
            $.ajax({
                url: '/pairing_profile/get_adv_pop_flag',
                cache: false,
                success: function(data) {
                    hideBlockShadow();
                    if(data == 'false'){
                        $("#fade_error").show();
                        $("#advanced_popup").show();
                        centralizePopup();
                        $("#advanced_popup .enter-button-active").focus();
                        addFocusButton('advanced_popup_button');
                        $(".checkbox-cont span.checkbox").unbind().click(function(){
                            language_csv2.adv_pop();
                        });
                        $(".checkbox-cont label#adv-check-label").unbind().click(function(){
                            language_csv2.adv_pop();
                        });
                    }
                }
            });
        }
        if ($("#langauge-selector span.label-default").text() != "Language" &&  $(e).attr("id") != -1){
    //document.getElementById("language-add-button").disabled = false;
    //document.getElementById("language-add-button").className="add-button-active lfloat margin-L-10px margin-T--1px";
    }
    },
    adv_pop: function(e){
        $.ajax({
            url: '/pairing_profile/set_adv_pop_flag',
            cache: false
        });
    /*
	if (e == true){
//          $.ajax({
//		  url: '/pairing_profile/set_adv_pop_cookie',
//   		  cache: false,
//		  success: function(data) {
//		  }
//		});
        $("#adv-check").val(e);
          
        }
	*/
    // $("#adv-check").val(e);
	
    },
    close_pop: function(){
        $("#advanced_popup").hide();
        $("#fade_error").hide();
    },

    langbox_submit: function(){
        if($("#langauge-selector span.label-default").text().replace(/\s/g,"") == "")
        {
            return false;
        }
        language_csv2.add_to_list($("#langauge-selector span.label-default").attr("id"), $("#fluency-selector .label-default-top").text());
        if ($(".lang-table li").length == 5 ){
            $("#language-add-button").hide();
        }
        //credential_enter();
        return false;
    },

    add_to_list: function(value1, value2){
        var temp_arr = [];
        $("#langauge-selector").val("");
        $("#fluency-selector").val("");
        if(login_section_type == "job_seeker"){
            document.getElementById("language-add-button").disabled = true;
            document.getElementById("language-add-button").className="add-button lfloat margin-L-10px margin-T--1px";
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
            language_csv2.create_elements();
        }
    },
    add_another: function(value1, value2){
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
                $('#language-remove').hide();
                clear_hidden_lang_flu();
            }
            this.list_arr.clean("");
            this.list_arr2.clean("");
            this.create_elements();
        }
    //console.log(this.list_arr);
    },
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
                var conv = 666;
                var str = "<div class='langauges_container'><div class='top-curve'>&nbsp;</div><div class='content'>";
                str += "<label id='123' onclick='fluency_validate(" + conv + ");language_validate(" + conv + ");language_csv2.edit_row(" + i + ")' class='label-language'>"+temp[0]+"</label>";
                if(text == "Advanced")
                    str += "<label id='123' onclick='fluency_validate(" + conv + ");language_validate(" + conv + ");language_csv2.edit_row(" + i + ")' class='label-fluency text-active-red'>"+text+"</label>";
                else
                    str += "<label id='123' onclick='fluency_validate(" + conv + ");language_validate(" + conv + ");language_csv2.edit_row(" + i + ")' class='label-fluency text-active-blue'>"+text+"</label>";
                str += "<a class='remove' title='remove' onclick='language_csv2.remove_row("+i+");' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div></div>";
                $("div#langauges-Div").append(str);
                if (edit != "edit"){
                    if(delete_row!="delete"){
                        $('#validate-language').val('0');
                    }
                }
		
            }
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
        //this conditioon is used to handle the hidden value for selecterd lang when delted
        if(this.list_arr2.length == 1)
        {
            $('#selected_language_fluency').val(0);
               
        }
        for(var i =0; i < this.list_arr2.length; i++){
            if (val != i)
            {
                new_arr2.push(this.list_arr2[i]);
            }
        }
        this.list_arr2 = new_arr2;
        //console.log(this.list_arr);
        $('#validate-language').val('1');
	
        this.create_elements(edit, "delete");
        active_inactive_buttons();
    //credential_enter();
    },
    
    edit_row: function(val){
	
        //this.add_another(language_csv2.add_another($('#langauge-selector .label-default').text(), $('#fluency-selector .label-default-top').text()));
	
        add_languages();
		
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
                //$("#language-options-content").find('li').each(function(){
                //    if ($("label",this).attr("id") == temp[0]){
                //        _temp = $(this).text();
                //    }
                //});
                        
                        
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
                       
            //                        a=($("#"+ temp[1] + "_e").text());
            //                        b=($("#"+ temp[2] + "_s").text());
            }
        }
        language_csv2.remove_row(val,"edit");
        $("#language-remove").show();
    }
        
}

var certificate_csv2 ={
    show: function(){
        $("#certificate-add").hide();
        $("#certificate-selector-block").show();
        $("#cert-table").show();
	   
	   
    },

    add_show: function(){
        $("#add_cert_text").val();
    }
}

var top_skills ={
    show: function(){
        $("#skills-add").hide();
        $("#add-edit-skill").show();
    }
}

var credential_save ={
    call: function(save_type){
        if(save_type == "update"){
            flag = checkInactiveCredentialsSections();
            if(flag){
                return false;
            }
            ////////////////////////////////////////////////
            if(!($("#credential-save").hasClass('active'))){
                return false;
            }
        }
        /*This part of the code has been written for Roles section*/
        var role_arr;
        var role1;
        var role2;
        var role3;
        if($("#add_role1_placeholder").val()!="Role 1 (click to access)" && $("div.educationLevel span.education-default").text()!="Education Level" && $("div.skillLevel span.skill-default").text()!="Experience Level") {
            role1 = $("#add_role1_placeholder").val() + "_" + $("div.educationLevel span.education-default").text() + "_" + $("div.skillLevel span.skill-default").text();
            role_arr = role1;
            if($("#add_role2_placeholder").val()!="Role 2 (optional, click to access)" && $("div.educationLevelRole2 span.education-default").text()!="Education Level" && $("div.skillLevelRole2 span.skill-default").text()!="Experience Level") {
                role2 = $("#add_role2_placeholder").val() + "_" + $("div.educationLevelRole2 span.education-default").text() + "_" + $("div.skillLevelRole2 span.skill-default").text();
                role_arr = role_arr + "_roles_array_" + role2;
            }
            if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)" && $("div.educationLevelRole3 span.education-default").text()!="Education Level" && $("div.skillLevelRole3 span.skill-default").text()!="Experience Level") {
                role3 = $("#add_role3_placeholder").val() + "_" + $("div.educationLevelRole3 span.education-default").text() + "_" + $("div.skillLevelRole3 span.skill-default").text();
                role_arr = role_arr + "_roles_array_" + role3;
            }
        }
        $("#role_code").val(role_arr);
        /*Code for saving roles ends here*/
        var cert = $('#add_cert_text').val();
        if(!certificate.list_arr.has(cert) && $("#validate-certificate").val()=="1" && unescape_str_new(cert)!="" && unescape_str_new(cert) != jQuery.trim($("#add_cert_text_placeholder").val())){
            certificate.list_arr.push(cert);
        }
        var college = $('#add_uni_text').val();
        if(!college_cs.list_arr.has(college) && $("#validate-college").val()=="1" && unescape_str_new(college)!="" && unescape_str_new(college) != jQuery.trim($("#add_uni_text_placeholder").val())){
            college_cs.list_arr.push(college);
        }
        var language1 = $('#langauge-selector').find('span').text();
        var language2 = $('#fluency-selector .label-default-top').text();

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
        if(!language_csv2.list_arr.has(language1+"__"+language2) && $("#validate-language").val()=="1" && !language_csv2.list_arr2.has(language1) && language1!="" && language2!=""){
            language_csv2.list_arr.push(language1+"__"+language2);
            language_csv2.list_arr2.push(language1);
        }
        var degree1 = $('#degree-selector').find('span').text();
        var degree2 = $('#options-selector .label-default-top').text();
	
        if(degree1!="Degree"){
            $("#degree").val(degree1);
        }
	
        if(degree2!="Status"){
            $("#status").val(degree2);
        }
	
        $("#certificate_param").val(certificate.list_arr.join("_jucert_"));
        $("#selected_languages").val(language_csv2.list_arr.join(","));
        $("#universities").val(college_cs.list_arr.join("_cscolg_"));
	
        //$("#skills").val(skills_csv2.list_arr.join("_juskill_"));
        $("#save_type").val(save_type);
        //        $("#certification_dropdown").removeClass("input-text input-text-active");
        //        $("#certification_dropdown").addClass("input-text");
        if(save_type == "update"){
            $('#credential-save').hide();
            $('#loader_credential').show();
            //$('#credential-save').attr('disabled', 'disabled');
            $('#credential-save').removeClass("active");
            $('#credential_form').submit();

            if($("#validate-language").val()=="1"){
                language_csv2.list_arr.pop();
                language_csv2.list_arr2.pop();
            }

            if($("#validate-certificate").val()=="1"){
                certificate.list_arr.pop();
            }
            
            if($("#validate-college").val()=="1"){
                college_cs.list_arr.pop();
            }


        }
        else
            $("#credential_form").submit();
    }
}

function credential_enter(){
    
//    if ($(".lang-table li").length != 0 && $(".added-skills li").length != 0){
//        $("#credential-enter").removeClass("enter-button enter-button-active");
//        $("#credential-enter").addClass("enter-button-active");
//        $(".btn-save").addClass("active");
//        $(".btn-save").removeAttr("disabled");
//    }
//    else{
//        $("#credential-enter").removeClass("enter-button enter-button-active");
//        $("#credential-enter").addClass("enter-button");
//        $(".btn-save").removeClass("active");
//        $(".btn-save").attr("disabled","disabled");
//    }
    
}

function skill_help(){
    $("#fade_normal").show();
    $("#beta_access").show();
    centralizePopup();
}
function skill_help2(){
    $("#fade_normal").show();
    $("#beta_access2").show();
    centralizePopup();
}
function skill_help3(){
    $("#fade_normal").show();
    $("#beta_access3").show();
    centralizePopup();
}
function skill_help4(){
    $("#fade_normal").show();
    $("#beta_access4").show();
    centralizePopup();
}

function add_colleges(){
    if($("#validate-college").val()=="1"){
        var valTxt = $("#add_uni_text").val();
        $("#collegeAndUniversities-Div").show();
        $("<div class='add_autoCompleteDiv' style='margin-top:12px;' ><div class='addition-list-li-div'><div class='top'></div><div class='bottom'><div style='margin: 0 0 4px 10px;float:left;width:275px;overflow: auto;'><a class='label'  style='color:#7F7FBB; vertical-align: top;font-size:13px; font-weight:400; margin-top:3px; display:block; text-decoration:none;' href='javascript:void(0);'>"+valTxt+"</a></div><div style='float:right;margin-right: 2px;' class='remove-cnt'><a onclick='delete_add_autoComplete();' class='remove' style='vertical-align: top;float:right;' title='remove' href='javascript:void(0);'><img width='20' height='20' border='0' style='margin-top:1px;' src='/assets/employer_v2/remove-skill.png' alt='Remove'></a></div></div></div></div>").appendTo("div#collegeAndUniversities-Div");
        //$("#validate-college").val('0');
        $('#add_uni_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
        $('#add_uni_text').val($('#add_uni_text_placeholder').val());
    }
}

function add_licences_certificates(){
    if($("#validate-certificate").val()=="1"){
        var valTxt = $("#add_cert_text").val();
        $("#licensesAndCertifications-Div").show();
        $("<div class='licenses_Certifications_container'><div class='top-curve'>&nbsp;</div><div class='content'><label onclick='certificate.edit_row(0)'><a style='cursor: default;' id='123' href='javascript:void(0);'>"+valTxt+"</a></label><a class='remove' title='remove' onclick='certificate.remove_row(0);' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div><div class='bottom-curve'>&nbsp;</div></div>").appendTo("div#licensesAndCertifications-Div");
        //$("#validate-certificate").val('0');
        $('#add_cert_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
        $('#add_cert_text').val($('#add_cert_text_placeholder').val());
    }
}

function add_licences_certificates(){
    var valTxt = $("#add_cert_text").val();
    $("#licensesAndCertifications-Div").show();
    $("<div class='licenses_Certifications_container'><div class='top-curve'>&nbsp;</div><div class='content'><label onclick='certificate.edit_row(0)'><a style='cursor: default;' id='123' href='javascript:void(0);'>"+valTxt+"</a></label><a class='remove' title='remove' onclick='certificate.remove_row(0);' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div><div class='bottom-curve'>&nbsp;</div></div>").appendTo("div#licensesAndCertifications-Div");
}

//function add_languages(){
//    var langaugeTxt = $("#langauge-selector .label-default").text();
//    var fluencyTxt = $("#fluency-selector .label-default-top").text();
//    $("#langauges-Div").show();
//    $("<div class='langauges_container'><div class='top-curve'>&nbsp;</div><div class='content'><label id='123' onclick='' class='label-language'>"+langaugeTxt+"</label><label id='123' onclick='' class='label-fluency text-active-blue'>"+fluencyTxt+"</label><a class='remove' title='remove' onclick='language_csv2.remove_row(0);' href='javascript:void(0);'><img width='20' height='20' src='/assets/remove-skill.png' alt='Remove Skill'></a></div><div class='bottom-curve'>&nbsp;</div></div>").appendTo("div#langauges-Div");
//}

function delete_add_autoComplete(){
  
}

function add_certificates(){
    
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
            var _topoffset_init = $('#career_clusters li:first').offset().top;
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
    } else if(add_role=="add_role2") {
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
            var _topoffset_init = $('#career_clusters li:first').offset().top;
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
            } else {
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
            var _topoffset = $('.highlightCls').offset().top;
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
                var _topoffset_init = $('#career_clusters li:first').offset().top;
                $(".career_path_left").css("top",_topoffset_init-5+"px");
            }
            $(".career_path_left").show();
            $(".career_path_left").animate({
                top:_topoffset-5+"px"
            },1000);
            var _topoffset_init_role = $('#careerPath li:first').offset().top;
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
                var _topoffset_init = $('#careerPath li:first').offset().top;
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
                _topoffset = $('.highlightCls_path').offset().top;
                $(".career_desiredrole_left").css("left",_leftoffset+242+"px");
            } else {
                $(".career_desiredrole_left_initial").css("display","block");
                $(".career_desiredrole_left").css("display","none");
                //Code for when user click on the already selected role
                if($("ul#careerPath li").hasClass("highlightCls_path")) {
                    _leftoffset = $('.highlightCls_path').offset().left;
                    _topoffset = $('.highlightCls_path').offset().top;
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
                    var _topoffset = $('.highlightCls_path').offset().top;
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
    } else {
        $("#search_shadow_cluster").css("display","none");
        $("#search_shadow_path").css("display","none");
        $("#search_shadow_path_arrow").css("display","none");
        $("div#exploreRolDescription").css("display","block");

        if($("input#populate_role_field").val()==1) {
            $("input#add_role1").val(title);
            $("input#add_role1_placeholder").val(code);
            $("input#add_role1").addClass("text-active");
            $("div#removeRole1Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole1Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
            role_1_validate(title);
        }
        if($("input#populate_role_field").val()==2) {
            $("input#add_role2").val(title);
            $("input#add_role2_placeholder").val(code);
            $("input#add_role2").addClass("text-active");
            $("div#removeRole2Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole2Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
            role_2_validate(title);
        }
        if($("input#populate_role_field").val()==3) {
            $("input#add_role3").val(title);
            $("input#add_role3_placeholder").val(code);
            $("input#add_role3").addClass("text-active");
            $("div#removeRole3Contents").html("<a href='javascript:void(0)' class='remove' onclick='clearRole3Contents();'><img src='/assets/remove-skill.png' alt='Remove Role' width='20' height='20' /></a>");
            role_3_validate(title);
        }
        handleEmptyCase();
        hideNormalShadow();
        $("#fade_normal_dark").hide();
        $('#fade_normal_dark').unbind();
        //$(document).unbind('keyup');
        if($("input#search_roles").val() != "") {
            clearSearchResults();
        }
    }
}

function cancelRoleSelection(){
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

function clearRole1Contents() {
    if(($("#add_role2_placeholder").val()=="Role 2 (optional, click to access)" && $("div.educationLevelRole2 span.education-default").text()=="Education Level" && $("div.skillLevelRole2 span.skill-default").text()=="Experience Level") && ($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)" || $("div.educationLevelRole3 span.education-default").text()!="Education Level" || $("div.skillLevelRole3 span.skill-default").text()!="Experience Level")) {
        if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
            $("#add_role1_placeholder").val($("#add_role3_placeholder").val());
            $("#add_role1").val($("#add_role3").val());
            $("#add_role1").addClass("text-active");
            $("input#selected_role_1").val(1);

            $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
            $("#add_role3").val("Role 3 (optional, click to access)");
            $("#add_role3").removeClass("text-active");
            $("input#selected_role_3").val(0);
        } else {
            $("#add_role1_placeholder").val("Role 1 (click to access)");
            $("#add_role1").val("Role 1 (click to access)");
            $("#add_role1").removeClass("text-active");
            $("input#selected_role_1").val(0);
        }
        if($("div.educationLevelRole3 span.education-default").text()!="Education Level") {
            $("div.educationLevel .education-default").text($("div.educationLevelRole3 span.education-default").text());
            $("div.educationLevel .education-default").addClass("text-active");
            $("input#selected_education_1").val(1);

            $("div.educationLevelRole3 .education-default").text("Education Level");
            $("div.educationLevelRole3 .education-default").removeClass("text-active");
            $("input#selected_education_3").val(0);
        } else {
            $("div.educationLevel .education-default").text("Education Level");
            $("div.educationLevel .education-default").removeClass("text-active");
            $("input#selected_education_1").val(0);
        }
        if($("div.skillLevelRole3 span.skill-default").text()!="Experience Level") {
            $("div.skillLevel .skill-default").text($("div.skillLevelRole3 span.skill-default").text());
            $("div.skillLevel .skill-default").addClass("text-active");
            $("input#selected_experience_1").val(1);

            $("div.skillLevelRole3 .skill-default").text("Experience Level");
            $("div.skillLevelRole3 .skill-default").removeClass("text-active");
            $("input#selected_experience_3").val(0);
        } else {
            $("div.skillLevel .skill-default").text("Experience Level");
            $("div.skillLevel .skill-default").removeClass("text-active");
            $("input#selected_experience_1").val(0);
        }
        $("div#removeRole3Contents").empty();
    } else {
        if($("#add_role2_placeholder").val()!="Role 2 (optional, click to access)") {
            $("#add_role1_placeholder").val($("#add_role2_placeholder").val());
            $("#add_role1").val($("#add_role2").val());
            $("#add_role1").addClass("text-active");
            $("input#selected_role_1").val(1);

            $("#add_role2_placeholder").val("Role 2 (optional, click to access)");
            $("#add_role2").val("Role 2 (optional, click to access)");
            $("#add_role2").removeClass("text-active");
            $("input#selected_role_2").val(0);
        } else {
            $("#add_role1_placeholder").val("Role 1 (click to access)");
            $("#add_role1").val("Role 1 (click to access)");
            $("#add_role1").removeClass("text-active");
            $("input#selected_role_1").val(0);
        }

        if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
            update_role2_field();
        }

        if($("div.educationLevelRole2 span.education-default").text()!="Education Level") {
            $("div.educationLevel .education-default").text($("div.educationLevelRole2 span.education-default").text());
            $("div.educationLevel .education-default").addClass("text-active");
            $("input#selected_education_1").val(1);

            $("div.educationLevelRole2 .education-default").text("Education Level");
            $("div.educationLevelRole2 .education-default").removeClass("text-active");
            $("input#selected_education_2").val(0);
        } else {
            $("div.educationLevel .education-default").text("Education Level");
            $("div.educationLevel .education-default").removeClass("text-active");
            $("input#selected_education_1").val(0);
        }

        if($("div.educationLevelRole3 span.education-default").text()!="Education Level") {
            update_role2_education_field();
        }

        if($("div.skillLevelRole2 span.skill-default").text()!="Experience Level") {
            $("div.skillLevel .skill-default").text($("div.skillLevelRole2 span.skill-default").text());
            $("div.skillLevel .skill-default").addClass("text-active");
            $("input#selected_experience_1").val(1);

            $("div.skillLevelRole2 .skill-default").text("Experience Level");
            $("div.skillLevelRole2 .skill-default").removeClass("text-active");
            $("input#selected_experience_2").val(0);
        } else {
            $("div.skillLevel .skill-default").text("Experience Level");
            $("div.skillLevel .skill-default").removeClass("text-active");
            $("input#selected_experience_1").val(0);
        }

        if($("div.skillLevelRole3 span.skill-default").text()!="Experience Level") {
            update_role2_experience_field();
        }
        if($("#add_role1_placeholder").val()=="Role 1 (click to access)" && $("div.educationLevel span.education-default").text()=="Education Level" && $("div.skillLevel span.skill-default").text()=="Experience Level") {
            $("div#removeRole1Contents").empty();
        }
        if($("#add_role2_placeholder").val()=="Role 2 (optional, click to access)" && $("div.educationLevelRole2 span.education-default").text()=="Education Level" && $("div.skillLevelRole2 span.skill-default").text()=="Experience Level") {
            $("div#removeRole2Contents").empty();
        }
        if($("#add_role3_placeholder").val()=="Role 3 (optional, click to access)" && $("div.educationLevelRole3 span.education-default").text()=="Education Level" && $("div.skillLevelRole3 span.skill-default").text()=="Experience Level") {
            $("div#removeRole3Contents").empty();
        }
    }

    active_inactive_buttons();
}

function clearRole2Contents() {
    var hide_cross_Role2_image = '';
    var hide_cross_Edu2_image = '';
    var hide_cross_Exp2_image = '';

    if($("#add_role3_placeholder").val()!="Role 3 (optional, click to access)") {
        update_role2_field();
        hide_cross_Role2_image = 1;
    } else  {
        $("#add_role2_placeholder").val("Role 2 (optional, click to access)");
        $("#add_role2").val("Role 2 (optional, click to access)");
        $("#add_role2").removeClass("text-active");
        $("input#selected_role_2").val(0);
        hide_cross_Role2_image = 0;
    }

    if($("div.educationLevelRole3 span.education-default").text()!="Education Level") {
        update_role2_education_field();
        hide_cross_Edu2_image = 1;
    } else {
        $("div.educationLevelRole2 .education-default").text("Education Level");
        $("div.educationLevelRole2 .education-default").removeClass("text-active");
        $("input#selected_education_2").val(0);
        hide_cross_Edu2_image = 0;
    }

    if($("div.skillLevelRole3 span.skill-default").text()!="Experience Level") {
        update_role2_experience_field();
        hide_cross_Exp2_image = 1;
    } else {
        $("div.skillLevelRole2 .skill-default").text("Experience Level");
        $("div.skillLevelRole2 .skill-default").removeClass("text-active");
        $("input#selected_experience_2").val(0);
        hide_cross_Exp2_image = 0;
    }

    if(hide_cross_Role2_image == 0 && hide_cross_Edu2_image == 0 && hide_cross_Exp2_image == 0) {
        $("div#removeRole2Contents").empty();
    }
    $("div#removeRole3Contents").empty();
    active_inactive_buttons();
}

function clearRole3Contents() {
    $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
    $("#add_role3").val("Role 3 (optional, click to access)");
    $("#add_role3").removeClass("text-active");
    $("input#selected_role_3").val(0);

    $("div.educationLevelRole3 .education-default").text("Education Level");
    $("div.educationLevelRole3 .education-default").removeClass("text-active");
    $("input#selected_education_3").val(0);

    $("div.skillLevelRole3 .skill-default").text("Experience Level");
    $("div.skillLevelRole3 .skill-default").removeClass("text-active");
    $("input#selected_experience_3").val(0);

    $("div#removeRole3Contents").empty();
    active_inactive_buttons();
}

function update_role2_field() {
    $("#add_role2_placeholder").val($("#add_role3_placeholder").val());
    $("#add_role2").val($("#add_role3").val());
    $("#add_role2").addClass("text-active");
    $("input#selected_role_2").val(1);

    $("#add_role3_placeholder").val("Role 3 (optional, click to access)");
    $("#add_role3").val("Role 3 (optional, click to access)");
    $("#add_role3").removeClass("text-active");
    $("input#selected_role_3").val(0);
}

function update_role2_education_field(){
    $("div.educationLevelRole2 .education-default").text($("div.educationLevelRole3 span.education-default").text());
    $("div.educationLevelRole2 .education-default").addClass("text-active");
    $("input#selected_education_2").val(1);

    $("div.educationLevelRole3 .education-default").text("Education Level");
    $("div.educationLevelRole3 .education-default").removeClass("text-active");
    $("input#selected_education_3").val(0);
}

function update_role2_experience_field() {
    $("div.skillLevelRole2 .skill-default").text($("div.skillLevelRole3 span.skill-default").text());
    $("div.skillLevelRole2 .skill-default").addClass("text-active");
    $("input#selected_experience_2").val(1);

    $("div.skillLevelRole3 .skill-default").text("Experience Level");
    $("div.skillLevelRole3 .skill-default").removeClass("text-active");
    $("input#selected_experience_3").val(0);
}

function collegeTypeEnter(key){
    if(key.keyCode == 13){
        if(validateRequired($('#college-inner-text').val())) {
            $('#add_uni_text').val($('#college-inner-text').val());
            $("#college-remove").show();
            //college_cs.add_to_list($('#college-inner-text').val());
            $('.college-university-list').css('display','none');
            $('.collegeUniversity-autoComplete-txt').hide();
            $('.collegeUniversity-autoComplete-txt').html("Other (enter your own)");
            $('#college-textbox').val('0');
            $("#validate-college").val('1');
            $('#add_uni_text').parent().removeClass('input-text-active').addClass('active-input');
            active_inactive_buttons();
        }
    }

}

function certificateTypeEnter(key){
    if(key.keyCode == 13){
        if(validateRequired($('#certificate-inner-text').val())) {
            $('#add_cert_text').val($('#certificate-inner-text').val());
            $("#certificate-remove").show();
            //certificate.add_to_list($('#certificate-inner-text').val());
            $('.cert-list').css('display','none');
            $('.collegeUniversity-autoComplete-txt').hide();
            $('.collegeUniversity-autoComplete-txt').html("Other (enter your own)");
            $('#certificate-textbox').val('0');
            $("#validate-certificate").val('1');
            $('#add_cert_text').parent().removeClass('input-text-active').addClass('active-input');
            active_inactive_buttons();
        }
    }
}

function college_click_autocomplete(){
    $("#college-remove").show();
    $('#college-textbox').val('0');
    $("#validate-college").val('1');
    $('.collegeUniversity-autoComplete-txt').hide();
    $('#add_uni_text').parent().removeClass('input-text-active').addClass('active-input');
    active_inactive_buttons();
//college_cs.add_to_list($(e).attr('title'));
    
}

function certificate_click_autocomplete(){
    $("#certificate-remove").show();
    $('#certificate-textbox').val('0');
    $("#validate-certificate").val('1');
    $('.collegeUniversity-autoComplete-txt').hide();
    $('#add_cert_text').parent().removeClass('input-text-active').addClass('active-input');
    active_inactive_buttons();
//certificate.add_to_list($(e).attr('title'));
   
    
}

var college_cs = {
    list_arr: [],
    initialize: function(college_values){
        if(college_values != ""){
            this.list_arr = unescape_str_new(college_values).split("_cscolg_");
            //$("#certificate-add").hide();
            //$("#certificate-selector-block").show();
            //$("#cert-table").css("display:block");
            $("#validate-college").val("1");
        }
        this.create_elements();
        
    },
    show: function(){
    //$("#cert_add_link").hide();
    //$("#cert_add_box").show();
    //$("#add_uni_text").focus();
    },
    hide: function(){
    //$("#cert_add_link").show();
    //$("#cert_add_box").hide();
    //$("#add_uni_text").val("");
    },
    add_to_list: function(value){
        //        if(this.list_arr.has(value)){
        //            $("#add_uni_text").val($("#add_uni_text_placeholder").val());
        //            $("#add_uni_text").parent().removeClass("active-input input-text input-text-active");
        //            $("#add_uni_text").parent().addClass("input-text");
        //        }
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
            else{

        }
        }
        
        var str = "";
        if($("#validate-college").val()=="1"){
            $("div#collegeAndUniversities-Div").html("");
            for(var i=0; i<this.list_arr.length; i++){
                str += "<div class='add_autoCompleteDiv' style='margin-top:12px;' ><div class='addition-list-li-div'><div class='top'></div><div class='bottom'><div style='margin: 0 0 4px 10px;float:left;width:275px;overflow: auto;'><a class='label'  onclick='active_inactive_buttons();college_cs.edit_row("+i+");' style='color:#000066; vertical-align: top;font-size:13px; font-weight:400; margin-top:3px; display:block; text-decoration:none;' href='javascript:void(0);'>"+unescape_str_new(this.list_arr[i])+"</a></div><div style='float:right;margin-right: 2px; position: absolute; right: 114px;' class='remove-cnt'><a onclick='active_inactive_buttons();college_cs.remove_row("+i+");hideCollegeInnerTextBox();' class='remove' style='vertical-align: top;float:right;' title='remove' href='javascript:void(0);'><img width='20' height='20' border='0' style='margin-top:1px;' src='/assets/employer_v2/remove-skill.png' alt='Remove'></a></div></div></div></div>";
            }
            //$('#cert-table').show();
            $("div#collegeAndUniversities-Div").append(str);
            $("#collegeAndUniversities-Div").show();
            if(edit != "edit"){
                if(delete_row != "delete"){
                    //$("#validate-college").val('0');
                    $('#add_uni_text').parent().removeClass('input-text-active').removeClass('active-input').addClass('input-text');
                    $('#add_uni_text').val($('#add_uni_text_placeholder').val());
                }
            }
        }
        if(edit != "edit"){
            $("#validate-college").val("0");
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
        //$('#certificate').html("<input type='hidden' name='editing' value='editing-cert' id='editing' />");
        college_cs.remove_row(val,"edit");
        $("#college-remove").show();
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
        //this.list_arr.push(unescape_str_new(val));
        if (login_section_type == "job_seeker"){
    //credential_enter();
    }

    }

}

function disableValidateCertificate(){
    $('#validate-certificate').val('0');
}

function disableValidateCollege(){
    $('#validate-college').val('0');
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


























//////////////////////////////////////////////////////////////////////////////////////
///////////////**********CODE BELOW related to validation in save ////////////////////
////////////////////////////////////////////////////////////////////////////////////////
  
////////////////////**********************************////////////////////////
// checks the state of the button and toggles it, for validating the return button
////////////////////**********************************////////////////////////
function check_return_button_class() 
{
    if  ($('#credential_save_return').hasClass('saveReturnLater-button-active'))
    {
        //alert("wow");
        credential_save.call('save_n_return');
    }
}
  
////////////////////**********************************////////////////////////
// for degree
////////////////////**********************************////////////////////////
function degree_validate(name_of_label)
{  
    if(name_of_label != "Degree")
    {
        $('#selected_degree').val(1);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// for status          
////////////////////**********************************////////////////////////
function degree_status(name_of_label)
{  
    if(name_of_label == "Expected" || name_of_label == "Completed")
    {
        $('#selected_status').val(1);
    }
    else if(name_of_label != "Expected" || name_of_label != "Completed")
    {
        $('#selected_status').val(0);
    }
    active_inactive_buttons();
}  
  
////////////////////**********************************////////////////////////
//for language
////////////////////**********************************////////////////////////
function language_validate(name_of_label)
{  
    if (name_of_label != "Language")
    {
        $('#selected_language_1').val(1);
    }
    else if(name_of_label == "Language")
    {
        $('#selected_language_1').val(0);
    }
    active_inactive_buttons();
}
 
////////////////////**********************************////////////////////////
////////////////////**********************************////////////////////////
function fluency_validate(name_of_label)
{  //alert(name_of_label);
    if (name_of_label == "Conversational" || name_of_label == "Advanced" || name_of_label == 666)
    {
        $('#selected_fluency').val(1);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
////////////////////**********************************////////////////////////
function clear_hidden_lang_flu()
{
    $('#selected_language_fluency').val(1);
    $('#selected_fluency').val(0);
    $('#selected_language_1').val(0);
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// ROLE 1
function role_1_validate(name_of_label)
{  
    if (name_of_label != "Role 1 (click to access)")
    {
        $('#selected_role_1').val(1);
    }
    else if(name_of_label == "Role 1 (click to access)")
    {
        $('#selected_role_1').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Education level 1
////////////////////**********************************////////////////////////
function education_1_validate(name_of_label)
{  
    if (name_of_label != "       Education Level     ")
    {
        $('#selected_education_1').val(1);
    }
    else if(name_of_label == "       Education Level     ")
    {
        $('#selected_education_1').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Experience level 1
////////////////////**********************************////////////////////////
function experience_1_validate(name_of_label)
{  
    if (name_of_label != "       Experience Level     ")
    {
        $('#selected_experience_1').val(1);
    }
    else if(name_of_label == "       Experience Level     ")
    {
        $('#selected_experience_1').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// ROLE 2
////////////////////**********************************////////////////////////
function role_2_validate(name_of_label)
{  
    //alert(name_of_label);
    //alert(name_of_label != "Desired Role 2 (click to access)");
    if (name_of_label != "Role 2 (optional, click to access)")
    {
        $('#selected_role_2').val(1);
    }
    else if(name_of_label == "Role 2 (optional, click to access)")
    {
        $('#selected_role_2').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Education level 2
////////////////////**********************************////////////////////////
function education_2_validate(name_of_label)
{  
    if (name_of_label != "       Education Level     ")
    {
        $('#selected_education_2').val(1);
    }
    else if(name_of_label == "       Education Level     ")
    {
        $('#selected_education_2').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Experience level 1
////////////////////**********************************////////////////////////
function experience_2_validate(name_of_label)
{  
    if (name_of_label != "       Experience Level     ")
    {
        $('#selected_experience_2').val(1);
    }
    else if(name_of_label == "       Experience Level     ")
    {
        $('#selected_experience_2').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// ROLE 3
////////////////////**********************************////////////////////////
function role_3_validate(name_of_label)
{  
    if (name_of_label != "Role 3 (optional, click to access)")
    {
        $('#selected_role_3').val(1);
    }
    else if(name_of_label == "Role 3 (optional, click to access)")
    {
        $('#selected_role_3').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Education level 3
////////////////////**********************************////////////////////////
function education_3_validate(name_of_label)
{  
    if (name_of_label != "       Education Level     ")
    {
        $('#selected_education_3').val(1);
    }
    else if(name_of_label == "       Education Level     ")
    {
        $('#selected_education_3').val(0);
    }
    active_inactive_buttons();
}
  
////////////////////**********************************////////////////////////
// Experience level 3
////////////////////**********************************////////////////////////
function experience_3_validate(name_of_label)
{  
    if (name_of_label != "       Experience Level     ")
    {
        $('#selected_experience_3').val(1);
    }
    else if(name_of_label == "       Experience Level     ")
    {
        $('#selected_experience_3').val(0);
    }
    active_inactive_buttons();
}
  
/////////8******************VALIDATIONS check*********************/////////////
//this action enables diables both save and return and save button
////////////////////**********************************////////////////////////
function active_inactive_buttons()
{
    var validate_enter_button = "";
    var validate_return_button = "";
  
    //*********************************************************
    // check degree and status
    if ($('#selected_degree').val() == 1 & $('#selected_status').val() == 1)
    {

    }
    else if ($('#selected_degree').val() == 0 & $('#selected_status').val() == 0)
    {
        validate_enter_button = "failed";
    }
    else
    {
        validate_return_button = "failed";
        validate_enter_button = "failed";
    }
  
    //*********************************************************
    // check language and fluency, here we have 2 main cases and 1 sub case
    if ($('#selected_language_fluency').val() == 0)
    {
        if ($('#selected_language_1').val() == 1 & $('#selected_fluency').val() == 1)
        {

        }
        else if ($('#selected_language_1').val() == 0 & $('#selected_fluency').val() == 0)
        {
            validate_enter_button = "failed";
        }
        else
        {
            validate_return_button = "failed";
            validate_enter_button = "failed";
        }
    }
    else if($('#selected_language_fluency').val() == 1)
    {
        if ($('#selected_language_1').val() == 0 & $('#selected_fluency').val() == 0)
        {

        }
        else if ($('#selected_language_1').val() == 1 & $('#selected_fluency').val() == 1)
        {
        }
        else
        {
            validate_return_button = "failed";
            validate_enter_button = "failed";
        }
    }
  
    ////////////////////**********************************////////////////////////
    //check for roles 1 validation
    ////////////////////**********************************////////////////////////
    if($('#selected_role_1').val() == 1 & $('#selected_education_1').val() == 1 & $('#selected_experience_1').val() == 1)
    {

    }
    else if($('#selected_role_1').val() == 0 & $('#selected_education_1').val() == 0 & $('#selected_experience_1').val() == 0)
    {
        validate_enter_button = "failed";
    }
    else
    {
        validate_return_button = "failed";
        validate_enter_button = "failed";
    }
  
    ////////////////////**********************************////////////////////////
    //check for roles 2 validation
    ////////////////////**********************************////////////////////////
    if($('#selected_role_2').val() == 1 & $('#selected_education_2').val() == 1 & $('#selected_experience_2').val() == 1)
    {

    }
    else if($('#selected_role_2').val() == 0 & $('#selected_education_2').val() == 0 & $('#selected_experience_2').val() == 0)
    {

    }
    else
    {
        validate_return_button = "failed";
        validate_enter_button = "failed";
    }
  
    ////////////////////**********************************////////////////////////
    //check for roles 3 validation
    ////////////////////**********************************////////////////////////
    if($('#selected_role_3').val() == 1 & $('#selected_education_3').val() == 1 & $('#selected_experience_3').val() == 1)
    {

    }
    else if($('#selected_role_3').val() == 0 & $('#selected_education_3').val() == 0 & $('#selected_experience_3').val() == 0)
    {
    //alert("1-5=-15-5-1-1-5--1-15-15151");
    }
    else
    {
        //alert("1-6-16--16-16161-1-11-");
        validate_return_button = "failed";
        validate_enter_button = "failed";
    }
  
  
  
    //*********************************************************
    //for activating enter button
    if(validate_enter_button == "")
    {
        $(".btn-save").addClass("active");
    }
    else
    {
        $(".btn-save").removeClass("active");
    }
}

function checkInactiveCredentialsSections(){
    var flag = 0;
    var roleCheck = 0;
    $("div#role-container").removeClass("error");
    $("div#degree-container").removeClass("error");
    $("div#language-container").removeClass("error");
    $("#error_message").hide();
    if(!($("#selected_role_1").val()=="1" && $("#selected_education_1").val()=="1" && $("#selected_experience_1").val()=="1")){
        $("div#role-container").removeClass("activeBlock").addClass("error");
        $("#error_message").show();
        flag = 1;
    }
    else{
        roleCheck = 1;
    }
    if(roleCheck == 1){
        if($("#selected_role_2").val()=="1" || $("#selected_education_2").val()=="1" || $("#selected_experience_2").val()=="1"){
            if($("#selected_role_2").val()=="1" && $("#selected_education_2").val()=="1" && $("#selected_experience_2").val()=="1"){
                
            }
            else{
                $("div#role-container").removeClass("activeBlock").addClass("error");
                $("#error_message").show();
                flag = 1;
            }
        }
        if($("#selected_role_3").val()=="1" || $("#selected_education_3").val()=="1" || $("#selected_experience_3").val()=="1"){
            if($("#selected_role_3").val()=="1" && $("#selected_education_3").val()=="1" && $("#selected_experience_3").val()=="1"){

            }
            else{
                $("div#role-container").removeClass("activeBlock").addClass("error");
                $("#error_message").show();
                flag = 1;
            }
        }
    }

    if(!($("#selected_degree").val()=="1" && $("#selected_status").val()=="1")){
        $("div#degree-container").removeClass("activeBlock").addClass("error");
        $("#error_message").show();
        flag = 1;
    }

    if(!(($("#selected_language_1").val()=="1" && $("#selected_fluency").val()=="1") || ($("#selected_language_fluency").val()=="1"))){
        $("div#language-container").removeClass("activeBlock").addClass("error");
        $("#error_message").show();
        flag = 1;
    }

    if(($("#selected_language_1").val()=="1" && $("#selected_fluency").val()=="0") || ($("#selected_language_1").val()=="0" && $("#selected_fluency").val()=="1")){
        $("div#language-container").removeClass("activeBlock").addClass("error");
        $("#error_message").show();
        flag = 1;
    }

    return flag;
}

function checkErrorHighlights(){
    if($("div#role-container").hasClass("error") || $("div#degree-container").hasClass("error") || $("div#language-container").hasClass("error")){
        $("#error_message").show();
    }
    else{
        $("#error_message").hide();
    }
}
