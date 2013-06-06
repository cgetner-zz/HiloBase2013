/* Textarea */ 
var crack_for_IE = false;

/* Textarea */
// JavaScript Document
var placeholder;
var placeholderArr = new Array();
function focus_element(val) {
    el = val;
    if(el.className.match(/password/)=="password") {
        if(el.type=="text") {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-unactive");
            $("#"+el.id).caretToStart();
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-active");
        }
    }
    else {
        if($("#"+el.id).parent().hasClass("input-text-error")) {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-error");
        }
        else if ($("#"+el.id).parent().hasClass("input-text")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-unactive");
            $("#"+el.id).caretToStart();
        }		
        else if($("#"+el.id).parent().hasClass("input-text-error-empty")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-unactive");
            $("#"+el.id).caretToStart();
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-active");
        }
    }
}
function focus_element_ta(val) {
    el = val;
    if($("#"+el.id).parent().parent().hasClass("input-text-error")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
        $("#"+el.id).parent().parent().addClass("input-text-error");
    }
    else if ($("#"+el.id).parent().parent().hasClass("input-text")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
        $("#"+el.id).parent().parent().addClass("input-text-unactive");
        $("#"+el.id).caretToStart();
    }
    else if($("#"+el.id).parent().parent().hasClass("input-text-error-empty-ta")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty-ta");
        $("#"+el.id).parent().parent().addClass("input-text-unactive");
        $("#"+el.id).caretToStart();
    }
    else {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error-empty-ta");
        $("#"+el.id).parent().parent().addClass("input-text-active");
    }

          
	
}

function focus_element_spend_limit(val){
    el = val;

    if($("#"+el.id).parent().hasClass("input-text-error")) {
        $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
        $("#"+el.id).parent().addClass("input-text-error");
    }
    else if ($("#"+el.id).parent().hasClass("input-text-error-empty")) {
        $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
        $("#"+el.id).parent().addClass("input-text-active");
    }
    else if ($("#"+el.id).parent().hasClass("input-text")) {
        $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
        $("#"+el.id).parent().addClass("input-text-active");
    //$("#"+el.id).caretToStart();
    }
    else if ($("#"+el.id).parent().hasClass("input-text-unactive")) {
        $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
        $("#"+el.id).parent().addClass("input-text-unactive");
    //$("#"+el.id).caretToStart();
    }
    else {
        $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
        $("#"+el.id).parent().addClass("input-text-active");
    }

}

function focus_element_youtube(val) {
    el = val;
	
    if(el.className.match(/password/)=="password") {
        if(el.type=="text") {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-unactive");
        //$("#"+el.id).caretToStart();
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-active");
        }
    }
    else {
        if($("#"+el.id).parent().hasClass("input-text-error")) {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-error");
        }
        else if ($("#"+el.id).parent().hasClass("input-text-error-empty")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-unactive");
        }
        else if ($("#"+el.id).parent().hasClass("input-text")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-unactive");
        //$("#"+el.id).caretToStart();
        }
        else if ($("#"+el.id).parent().hasClass("input-text-unactive")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-unactive");
        //$("#"+el.id).caretToStart();
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error");
            $("#"+el.id).parent().addClass("input-text-active");
        }
    }
}
function blur_element(val) {
    el = val;
    placeholder_id = el.id+"_placeholder";
    if(document.getElementById('error_msg')) {
    //errorBox = document.getElementById('error_msg').innerHTML="";
    }
    if(document.getElementById(placeholder_id)) {
        placeholder=document.getElementById(placeholder_id).value;
    }
    else {
        placeholder="";
    }
    if(el.className.match(/password/)=="password") {
        if(el.value=="") {
            el = changeInputType(el,"text",placeholder);
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text");
        }
        else if($("#"+el.id).parent().hasClass("input-text-unactive")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text");
        }
        else if($("#"+el.id).parent().hasClass("input-text-error")) {
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text-error");
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-active input-text-unactive active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("active-input");
        }
        return el;
    }
    else {
        if($("#"+el.id).parent().hasClass("input-text-error")) {
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text-error");
			
        }
        else if($("#"+el.id).parent().hasClass("input-text-error-empty")) {
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text-error-empty");
            el.value=placeholder;
        }
        else if($("#"+el.id).parent().hasClass("input-text")) {
            el.value=placeholder;
            $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text");
        }
        else if($("#"+el.id).parent().hasClass("input-text-unactive")) {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().addClass("input-text");
            el.value=placeholder;
        }
        else {
            if(el.value=="" || el.value == placeholder) {
                el.value=placeholder;
                $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
                $("#"+el.id).parent().addClass("input-text");
            }
            else {
                $("#"+el.id).parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
                $("#"+el.id).parent().addClass("active-input");
            }
        }
		
    }
	
}

function blur_element_ta(val) {
    el = val;
    placeholder_id = el.id+"_placeholder";
    if(document.getElementById('error_msg')) {
    //errorBox = document.getElementById('error_msg').innerHTML="";
    }
    if(document.getElementById(placeholder_id)) {
        placeholder=document.getElementById(placeholder_id).value;
    }
    else {
        placeholder="";
    }

    if($("#"+el.id).parent().parent().hasClass("input-text-error")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
        $("#"+el.id).parent().parent().addClass("input-text-error");
    }
    else if($("#"+el.id).parent().parent().hasClass("input-text")) {
        el.value=placeholder;
        $("#"+el.id).parent().parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
        $("#"+el.id).parent().parent().addClass("input-text");
    }
    else if($("#"+el.id).parent().parent().hasClass("input-text-unactive")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-active-dropdown");
        $("#"+el.id).parent().parent().addClass("input-text");
        el.value=placeholder;
    }
    else {
        if(el.value=="") {
            el.value=placeholder;
            $("#"+el.id).parent().parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().parent().addClass("input-text");
        }
        else {
            $("#"+el.id).parent().parent().removeClass("input-text input-text-active active-input input-text-error input-text-active-dropdown");
            $("#"+el.id).parent().parent().addClass("active-input");
        }
    }
	
}

function type_element(el,event) {
    if($("#"+el.id).parent().hasClass("input-text-unactive") || $("#"+el.id).parent().hasClass("input-text-error-empty")) {
        if(el.className.match(/password/)=="password") {
            if(el.type=="text") {
                if (BrowserDetect.browser == "Explorer" || BrowserDetect.browser == "Firefox"){
                    var unicode=event.keyCode? event.keyCode : event.charCode;
                }
				
                if(unicode!=9 || !(BrowserDetect.browser == "Explorer" || BrowserDetect.browser == "Firefox")){
                    el = changeInputType(el,"password","");
                    el.focus();
                    $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
                    $("#"+el.id).parent().addClass("input-text-active");
                    if (BrowserDetect.browser == "Explorer") {
                        crack_for_IE = true;
                    }
                    if (BrowserDetect.browser == "Explorer" || BrowserDetect.browser == "Firefox"){
					
                        unicode=event.keyCode? event.keyCode : event.charCode;
					
						
                        //alert(unicode);
                        var justForIE = String.fromCharCode(unicode);
                        //alert(justForIE);
					
                        /* JFS-843 */
                        if(BrowserDetect.browser == "Explorer"){
                            if(unicode!="17" && unicode!=9)
                                el.value=justForIE;
                        }
                        else{
                            //alert(unicode);
                            if(unicode!="118" && unicode!=9)
                                el.value=justForIE;
                        }
                    }
                    $("#"+el.id).caretToEnd();
                }
				
            }
                        
        }
        else {
            $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error input-text-error-empty");
            $("#"+el.id).parent().addClass("input-text-active");
            $("#"+el.id).val("");
        }
		
    }
}

function type_element_ta(el,event) {
    if($("#"+el.id).parent().parent().hasClass("input-text-unactive")) {
        $("#"+el.id).parent().parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
        $("#"+el.id).parent().parent().addClass("input-text-active");
        $("#"+el.id).val("");
    }
	
}


function type_element_youtube(el) {
    if($("#"+el.id).parent().hasClass("input-text-unactive")) {
        $("#"+el.id).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
        $("#"+el.id).parent().addClass("input-text-active");
    }
}
function changeInputType(oldObject, oType, value) {	
    newObject = document.createElement('input');
    newObject.type = oType;
    if(oldObject.size) newObject.size = oldObject.size;
    if(oldObject.value) newObject.value = oldObject.value;
    if(oldObject.name) newObject.name = oldObject.name;
    if(oldObject.id) newObject.id = oldObject.id;
    if(oldObject.className) newObject.className = oldObject.className;
    newObject.value = value;
    if(oldObject.onblur) newObject.onblur = oldObject.onblur;
    if(oldObject.onfocus) newObject.onfocus = oldObject.onfocus;
    if(oldObject.onkeyup) newObject.onkeyup = oldObject.onkeyup;
    if(oldObject.onkeydown) newObject.onkeydown = oldObject.onkeydown;
    if(oldObject.tabIndex) newObject.tabIndex = oldObject.tabIndex;
    if(oldObject.onkeypress) newObject.onkeypress = oldObject.onkeypress;
    if(oldObject.maxLength>0) newObject.maxLength = oldObject.maxLength;
    if (oldObject.parentNode != null)
        oldObject.parentNode.replaceChild(newObject,oldObject);
    return newObject;
}

$('document').ready(function(){
    $("body").on("paste", ".customized-input input.password", function(){
        if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
                el = document.getElementById(this.id);
                if(this.type=="text") {
                    setTimeout(function() {
                        el = changeInputType(el,"password",el.value);
                        el.focus();
                    }, 10);

                }
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".customized-inner-input input.password", function(){
        if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
                el = document.getElementById(this.id);
                if(this.type=="text") {
                    setTimeout(function() {
                        el = changeInputType(el,"password",el.value);
                        el.focus();
                    }, 10);

                }
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".customized-inner-input input", function(){
        if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".customized-input input", function(){
        if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".customized-textarea textarea", function(){
        if($(this).parent().parent().hasClass("input-text-unactive")) {
                $(this).parent().parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().parent().addClass("input-text-active");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".textarea-container textarea", function(){
        if($(this).hasClass("placeholder")) {
                $(this).removeClass("placeholder");
                $(this).addClass("filled-input");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".input-field-select-type input", function(){
        if($(this).hasClass("placeholder")) {
                $(this).removeClass("placeholder");
                $(this).addClass("filled-input");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
    $("body").on("paste", ".textbox textarea", function(){
        if($(this).parent().hasClass("input-text-unactive")) {
                $(this).parent().removeClass("input-text input-text-unactive input-text-active active-input input-text-error");
                $(this).parent().addClass("input-text-active");
                $(this).val('');
                var id = $(this).attr('id');
                setTimeout(function(){
                  document.getElementById(id).onkeyup();
                },100);
            }
    });
});