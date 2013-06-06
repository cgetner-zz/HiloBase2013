var contact_info = {
    slide: function(){
        if($("#contact-info-box").css("display") == "none"){
            $("#contact-info-box").slideDown();	
        }else{
            hide_edit();	
            $("#contact-info-box").slideUp();	
        }
    }
}



var video_url = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(250,530);	
        var id_str = "iframe_id_" + new Date().getTime();	
        var iframe_obj = "<iframe id='" + id_str + "' allowTransparency='true' style='height:250px;width:550px;margin:0px;padding:0px;' frameborder='0' scrolling='no' src='/my_introduction/video_url'></iframe>";
        $("#fade_layer_div").html(iframe_obj);
    },
    success: function(url){
        window.location.reload();
    }
}


var edit_info = function(){
    if($("#intro-_edit_link").html() == "Edit"){
        show_edit();
    }else{
        hide_edit();
    }
}

var show_edit = function(){
    $("#contact-info-show").hide();
    $("#contact-info-edit").show();
    $("#intro-_edit_link").html("Close");
}
var hide_edit = function(){
    $("#contact-info-show").show();
    $("#contact-info-edit").hide();	
    $("#intro-_edit_link").html("Edit");
}




var edit_summary = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(150,530);	

        $.ajax({
            url: '/my_introduction/edit_summary',
            cache: false,
            success: function(data) {
                $("#fade_layer_div").html(data)
            }
        });	
    }
}


var resume = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(250,530);	
        var id_str = "iframe_id_" + new Date().getTime();	
        var iframe_obj = "<iframe id='" + id_str + "' allowTransparency='true' style='height:210px;width:550px;margin:0px;padding:0px;' frameborder='0' scrolling='no' src='/my_introduction/new_resume'></iframe>";
        $("#fade_layer_div").html(iframe_obj);
    },
    success: function(){
        lighty.close_fade_bg();
        $.ajax({
            url: '/my_introduction/reload_resume',
            cache: false,
            success: function(data) {
			
            }
        });	
    },
    remove: function(){
        if(confirm("Are you sure you want to delete the resume?")){
            $.ajax({
                url: '/my_introduction/delete_resume',
                cache: false
            });	
        }
    }
}




var contact_email_menu = {
    apply: function(){
        $(".contactemail-title-menu").each(function(){
            $(this).qtip({
                content:  unescape_str($(this).attr('data-email')), // Set the tooltip content to the current corner
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
        });
    }
}








var intro_arr = ["introduction","records","references","links","samples","awards"]
var moveto = function(tab){
    var ele_arr = $(".intro-section");	
    var top = 0;
    for(var i =0;i < ele_arr.length;i++){
        if (intro_arr[i] == tab){
            break;
        }
        top += $(ele_arr[i]).height();
    }	
    $("body").attr("scrollTop",top);
}


var contact_info = {
    open: function(){
        lighty.fadeBG(true);
        lighty.fade_div_layer(150,530);	
        $.ajax({
            url: '/my_introduction/open_contact_info',
            cache: false,
            success: function(data){
                $("#fade_layer_div").html(data);
            }
        });		
    }
}



var open_photo_edit = {
    toggle: function(){
        $("#myint-contact-form").hide();
        $("#myint-photo-form").toggle();

    }
	
}

var open_contact_edit = {
    toggle: function(){
        $("#myint-photo-form").hide();
        $("#myint-contact-form").toggle();
    },
    close: function(){
        $("#myint-contact-form").slideUp();
    }
}


var delete_photo = function(){
    if(confirm("Are you sure you want to delete the photo?")){
        window.location.href = "/my_introduction/delete_photo";
    }
}

var open_resume = {
    toggle: function(){
        $("#myint-resume-form").toggle();
    }
}


var delete_resume = function(){
    if(confirm("Are you sure you want to delete the resume?")){
        window.location.href = "/my_introduction/delete_resume";
    }
}

var open_video_edit = {
    toggle: function(){
        $("#myint-video-form").toggle();	
    },
    reload: function(){
        window.location.reload();
    }
}

var open_summary_edit = {
    toggle: function(){
        $("#myint-summary-form").toggle();	
    },
    reload: function(){
        window.location.reload();
    }
}