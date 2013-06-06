jQuery(function($) {
    var loading_employer_account = function(){
        if(!validateEmployerEmail(document.getElementById('employer_email'))) {
            $("label#intro_error").html("Email format is incorrect.");
            return false;
        }
        $('span#loader_password').show();
        $('input#validateEmployerRegForm').hide();
    }
    var loaded_employer_account = function(){
        $('span#loader_password').hide();
        $('input#validateEmployerRegForm').show();
    }
    $("#new_employer_form")
    .bind("ajax:beforeSend", loading_employer_account)
    .bind("ajax:complete", loaded_employer_account)
});

function grantPrivilegedStatus(element,registration_cost) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];
    var error = document.getElementById('error_message');
    var credit_value = document.getElementById('credit_'+company_id);
    var fee_discount = document.getElementById('fee_'+company_id);
    
    // Reset all other field except for the current row
    error.innerHTML = "";
    $(".boxes").each(function(){
        if(this!=credit_value && this!=fee_discount) {
            $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $(this).parent().addClass("input-text");
            var id = $(this).attr("id");
            $(this).val($("#"+id+"_placeholder").val());
        }
    });

    // Basic validations for the values
    if(!validateNotEmpty(credit_value) && !validateNotEmpty(fee_discount)) {
        error.innerHTML = "Please enter a credit value and/or discount on registration fee.";
        hightlightOnEmptyError(credit_value);
        hightlightOnEmptyError(fee_discount);
        return false;
    }

    // Action to be performed if basic validations are true
    if(validateNotEmpty(credit_value) || validateNotEmpty(fee_discount)) {
        if(fee_discount.value>registration_cost) {
            error.innerHTML = "Discount on registration fee can not be greater that the registation cost ($"+registration_cost+")";
            hightlightOnError(fee_discount);
            return false;
        }
        showBlockShadow();
        if(!validateNotEmpty(credit_value)) {
            credit_value.value = 0;
        }
        if(!validateNotEmpty(fee_discount)) {
            fee_discount.value = 0;
        }
        // AJAX call to add company to privilaged list
        $.ajax({
            url: "/admin/home/add_to_privileged_list",
            type: "POST",
            error: function() {
                hideBlockShadow();
            },
            cache: false,
            data: "company_id="+company_id+"&credit_value="+credit_value.value+"&fee_discount="+fee_discount.value
        });
    }
}

function revokPrivilegedStatus(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];
    
    // AJAX call to remove company from privilaged list
    showBlockShadow()
    $.ajax({
        url: "/admin/home/remove_from_privileged_list",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function grantRightStatus(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];

    // AJAX call to remove company from privilaged list
    showBlockShadow()
    $.ajax({
        url: "/admin/home/grant_right_authentication",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function revokeRightStatus(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];

    // AJAX call to remove company from privilaged list
    showBlockShadow()
    $.ajax({
        url: "/admin/home/revoke_right_authentication",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function revokEDAStatus(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];

    // AJAX call to remove company from privilaged list
    showBlockShadow()
    $.ajax({
        url: "/admin/home/revoke_email_domain_authentication",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function grantEDAStatus(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];

    // AJAX call to remove company from privilaged list
    showBlockShadow()
    $.ajax({
        url: "/admin/home/grant_email_domain_authentication",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function showPrivilegedHistory(element) {
    var temp = $(element).attr('id').split("_");
    var company_id = temp[1];
    
    showBlockShadow()
    $.ajax({
        url: "/admin/home/privileged_list_history",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "company_id="+company_id
    });
}

function hightlightOnEmptyError(element) {
    $(element).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
    $(element).parent().addClass("input-text-error-empty");
}

function hightlightOnError(element) {
    $(element).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
    $(element).parent().addClass("input-text-error");
}

function markAsPaid(element) {
    var temp = $(element).attr('id').split("_");
    var id = temp[1];

    showBlockShadow()
    $.ajax({
        url: "/admin/home/mark_as_paid",
        type: "POST",
        error: function() {
            hideBlockShadow();
        },
        cache: false,
        data: "id="+id
    });
}

function validateEmployerEmail(element){
    email = element.value;
    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
        return true;
    }
    else {
        return false;
    }
}

function validateAddAdminForm() {
    var first_name_element = document.getElementById('administrator_first_name');
    var last_name_element = document.getElementById('administrator_last_name');
    var email_element = document.getElementById('administrator_email');
    var access_level_1 = document.getElementById('access-level-1').checked;
    var access_level_2 = document.getElementById('access-level-2').checked;
    var access_level_3 = document.getElementById('access-level-3').checked;
    var access_level_4 = document.getElementById('access-level-4').checked;
    var flag = true;

    if(!validateNotEmpty(first_name_element)) {
        $(first_name_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!validateNotEmpty(last_name_element)) {
        $(last_name_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!validateNotEmpty(email_element)) {
        $(email_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!(access_level_1 || access_level_2 || access_level_3 || access_level_4)) {
        $(".account-type span.checkbox").each(function(){
            $(this).css("background-position","0pt -100px");
            $(this).addClass('error');
        });
        flag = false;
    }
    if(flag) {
        if(!validateEmail(email_element.value)) {
            return false;
        }
        $("#new_admin_intro_error").html("");
    } else {
        if(!flag){
            $("#new_admin_intro_error").html("Please complete the areas highlighted in red.");
        }
    }
    return flag;
}

function validateAddAdminFormOnBlur(element) {
    var email_element = document.getElementById('administrator_email');
    var flag = true;
    $("#new_admin_success").html("");
    $("#new_admin_success").hide();
    
    $("#new_admin_form input[type=text]").each(function(){
        if($(this).parent().hasClass('input-text-error-empty')) {
            flag = false;
        }
    });
    $(".account-type span.checkbox").each(function(){
        if($(this).hasClass('error')) {
            flag = false;
        }
    });
    if(flag && $("#new_admin_intro_error").html()=="Please complete the areas highlighted in red.") {
        $("#new_admin_intro_error").html("");
    }
    if( element == email_element ) {
        if(validateNotEmpty(email_element)) {
            if(!validateEmail(email_element.value)) {
                $(email_element).parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-error');
                $("#new_admin_intro_error").html("Invalid Email Address.");
            } else {
                $(email_element).parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-active');
                if($("#new_admin_intro_error").html()=="Invalid Email Address." || $("#new_admin_intro_error").html()=="Email Address is not available.") {
                    $("#new_admin_intro_error").html("");
                }
            }
        } else {
            $(email_element).parent()
            .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
            .addClass('input-text-unactive');
            if($("#new_admin_intro_error").html()=="Invalid Email Address." || $("#new_admin_intro_error").html()=="Email Address is not available.") {
                $("#new_admin_intro_error").html("");
            }
        }
    }
}

function validateAddRootUserForm() {
    var first_name_element = document.getElementById('employer_first_name');
    var last_name_element = document.getElementById('employer_last_name');
    var email_element = document.getElementById('employer_email');
    var company_name_element = document.getElementById('company_name');
    var flag = true;

    if(!validateNotEmpty(first_name_element)) {
        $(first_name_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!validateNotEmpty(last_name_element)) {
        $(last_name_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!validateNotEmpty(email_element)) {
        $(email_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(!validateNotEmpty(company_name_element)) {
        $(company_name_element).parent().removeClass('input-text').addClass('input-text-error-empty');
        flag = false;
    }
    if(flag) {
        if(!validateEmail(email_element.value)) {
            return false;
        }
        $("#intro_error").html("");
    } else {
        if(!flag){
            $("#intro_error").html("Please complete the areas highlighted in red.");
        }
    }
    return flag;
}

function validateAddRootUserOnBlur(element) {
    var email_element = document.getElementById('employer_email');
    var company_name_element = document.getElementById('company_name');
    var flag = true;
    $("#success-message").html("");
    $("#success-message").hide();

    $("#new_employer_form input[type=text]").each(function(){
        if($(this).parent().hasClass('input-text-error-empty')) {
            flag = false;
        }
    });
    if(flag && $("#intro_error").html()=="Please complete the areas highlighted in red.") {
        $("#intro_error").html("");
    }
    if( element == email_element ) {
        if(validateNotEmpty(email_element)) {
            if(!validateEmail(email_element.value)) {
                $(email_element).parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-error');
                $("#intro_error").html("Invalid Email Address.");
            } else {
                $(email_element).parent()
                .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
                .addClass('input-text-active');
                if($("#intro_error").html()=="Invalid Email Address." || $("#intro_error").html()=="Email Address is not available.") {
                    $("#intro_error").html("");
                }
            }
        } else {
            $(email_element).parent()
            .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
            .addClass('input-text-unactive');
            if($("#intro_error").html()=="Invalid Email Address." || $("#intro_error").html()=="Email Address is not available.") {
                $("#intro_error").html("");
            }
        }
    }
    if( element == company_name_element ) {
        if($(company_name_element).parent().hasClass('input-text-error')) {
            $(company_name_element).parent()
            .removeClass('input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty')
            .addClass('input-text-active');
        }
        if($("#intro_error").html()=="Company already exists.") {
            $("#intro_error").html("");
        }
    }
}

function admin_employer_delete_cancel(emp_id){
    showBlockShadow();
    $.ajax({
        url: '/admin/home/admin_employer_delete_cancel',
        type: "POST",
        data: 'id='+emp_id
    });
}

function admin_employer_delete(emp_id){
    showNormalShadow();
    $.ajax({
        url: '/admin/home/admin_employer_delete',
        type: "POST",
        data: 'id='+emp_id
    });
}

function admin_job_seeker_delete_cancel(cs_id){
    showBlockShadow();
    $.ajax({
        url: '/admin/home/admin_job_seeker_delete_cancel',
        type: "POST",
        data: 'id='+cs_id
    });
}

function admin_job_seeker_delete(cs_id){
    showNormalShadow();
    $.ajax({
        url: '/admin/home/admin_job_seeker_delete',
        type: "POST",
        data: 'id='+cs_id
    });
}

function delete_employer(emp_id){
    showBlockShadow();
    $.ajax({
        url: '/admin/home/delete_employer',
        type: "POST",
        cache: false,
        data: 'id='+emp_id
    });
}

function delete_job_seeker(cs_id){
    showBlockShadow();
    $.ajax({
        url: '/admin/home/delete_job_seeker',
        type: "POST",
        cache: false,
        data: 'id='+cs_id
    });
}
