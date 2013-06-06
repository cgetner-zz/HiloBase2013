var DropDownHandler = {
    word: '',
    t: 0,
    func: function(key, ele, dropdownType){
        var len, i=0;
        var arr = new Array();
        var w;
        
        if(key.keyCode>=65 && key.keyCode<=90){
            
            timeOfOccurence = new Date().getTime();
            w = String.fromCharCode(key.which).toLowerCase();
            if(timeOfOccurence-this.t<1000){
                this.word += w;
            }
            else{
                this.word=w;
            }
            this.t = timeOfOccurence;
            len = this.word.length;
            $("#"+ele.id+" .option").children().each(function(){
                str = $(this).find('label').text().toLowerCase();
                find = str.substring(0, len).toLowerCase();
                if(DropDownHandler.word == find){
                    arr[i++] = $(this).find('label').attr('id').split("_")[0];
                }
            });
            //alert(arr);
            if(arr.length!=0) {
                
                var oneWasSelected = -1;
                var e = 0;
                for(e = 0; e < arr.length; e++){
                    
                    
                    $("#"+ele.id+" .option").children().each(function(){
                        
                        if($(this).find('label').attr('id').split("_")[0]==arr[e]){
                            if($(this).attr('selected')=='selected'){
                                oneWasSelected = e;
                                return false;
                            }
                            
                        }
                    });
                /*
                    if($("#"+ele.id+" .option #"+arr[e]).parent().attr('selected')=='-1') {
                        oneWasSelected = e;
                        break;
                    }
                    */
                }
                //alert(oneWasSelected);
                //alert(arr.length-1);
                if(oneWasSelected!=-1) {
                    
                    //$("#"+ele.id+" .option #"+arr[oneWasSelected]).parent().attr('selected','').removeClass('selected');
                    $("#"+ele.id+" .option").children().each(function(){
                        
                        if($(this).find('label').attr('id').split("_")[0]==arr[oneWasSelected]){
                            $(this).removeAttr('selected').removeClass('selected');
                        }
                    });
                    if(oneWasSelected < arr.length-1) {
                        //$("#"+ele.id+" .option #"+arr[oneWasSelected+1]).parent().attr('selected','-1').addClass('selected');
                        $("#"+ele.id+" .option").children().each(function(){
                        
                            if($(this).find('label').attr('id').split("_")[0]==arr[oneWasSelected+1]){
                                $(this).attr('selected','selected').addClass('selected');
                            }
                        });
                        e = oneWasSelected +1;
                    }
                    else {
                        //$("#"+ele.id+" .option #"+arr[0]).parent().attr('selected','-1').addClass('selected');
                        $("#"+ele.id+" .option").children().each(function(){
                        
                            if($(this).find('label').attr('id').split("_")[0]==arr[0]){
                                $(this).attr('selected','selected').addClass('selected');
                            }
                        });
                        e = 0;
                    }
                }
                else{
                    
                    $("#"+ele.id+" .option").children().each(function(){
                        if($(this).attr('selected')=='selected'){
                            $(this).removeAttr('selected').removeClass('selected');
                        }
                    });
                    
                    $("#"+ele.id+" .option").children().each(function(){
                        if($(this).find('label').attr('id').split("_")[0] == arr[0]){
                            $(this).addClass('selected').attr('selected','selected');
                            return false;
                        }
                    });
                    //$("#"+ele.id+" .option #"+arr[0]).parent().addClass('selected').attr('selected','-1');
                    e = 0;
                }
                /*if(dropdownType != "fluency_emp" && dropdownType != "fluency_cs"){*/
                /*if(hasVerticalScroll(ele)){*/
                    
                //alert(arr[e]);
                var offset;
                $("#"+ele.id+" .option").children().each(function(){
                        
                    if($(this).find('label').attr('id').split("_")[0]==arr[e]){
                        //alert("200");
                        offset = $(this).position().top;
                    }
                });
                //offset = $("#"+ele.id+" .option #"+arr[e]).parent().position().top;
                //alert('1');
                var upperBound = $('#'+ele.id+' .option').scrollTop();
                //alert('2');
                var elementHeight = $('#'+ele.id+' .option li').height()+4;
                //alert('3');
                var lowerBound = $('#'+ele.id+' .option').height();
                    
                //console.log(offset);
                //console.log(upperBound);
                //console.log(elementHeight);
                //console.log(lowerBound);
                if(offset+elementHeight>lowerBound) {
                    //alert('1');
                    $("#"+ele.id+" .option").animate({
                        scrollTop: upperBound+(offset-lowerBound)+10
                    }, 1000);
                }
                else if(offset<30) {
                    //alert('2');
                    $("#"+ele.id+" .option").animate({
                        scrollTop: upperBound+(offset)-30
                    }, 1000);
                }
                
            }
        }
        else if(key.keyCode == 38){
            //move up
            $("#"+ele.id+" .option").children().each(function(){
                if($(this).attr('selected')=='selected'){
                    ////alert('2');
                    $(this).removeAttr('selected').removeClass('selected');
                    if($(this).children().attr('id').split("_")[0]>"1"){
                        if($(this).prev()){
                            
                            var activeItem, upperBound, lowerBound, offsetTop;
                            var elementHeight = $('#'+ele.id+' .option li').height()+4;
                            $(this).prev().attr('selected', 'selected').addClass('selected');
                            
                            activeItem=$(this).prev();
                            
                            upperBound = $('#'+ele.id+' .option').scrollTop();
                            //console.log("Upper Bound: "+upperBound);
                            
                            offsetTop = $(this).prev().position().top;
                            //console.log("Offset Top: "+offsetTop);
                            
                            lowerBound = $('#'+ele.id+' .option').height();
                            //console.log("Lower Bound: "+lowerBound);
                            
                            /*if(offsetTop<upperBound+elementHeight){*/
                            if(offsetTop<30){
                                //$('#'+ele.id+' .option').scrollTop(upperBound+offsetTop);
                                $('#'+ele.id+' .option').scrollTop(upperBound+offsetTop-lowerBound);
                            }
                            /*
                            else if(offsetTop>lowerBound){
                                $('#'+ele.id+' .option').scrollTop(offsetTop+19);
                            }
                            */
                            key.stopImmediatePropagation();
                            key.preventDefault();
                            return false;
                            
                        }
                    }
                    else{
                        $(this).attr('selected', 'selected').addClass('selected');
                        key.stopImmediatePropagation();
                        key.preventDefault();
                        return false;
                           
                    }
                    
                }
                    
                    
            })
        }
        else if(key.keyCode == 40){
           
            $("#"+ele.id+" .option").children().each(function(){
                if($(this).attr('selected')=='selected'){
                    $(this).removeAttr('selected').removeClass('selected');
                    
                    if($(this).children().attr('id').split("_")[0]<$("#"+ele.id+" .option li").length){
                        if($(this).next()){
                            var activeItem, upperBound, lowerBound, offsetTop;
                            var elementHeight = $('#'+ele.id+' .option li').height()+4;
                            $(this).next().attr('selected', 'selected').addClass('selected');
                            activeItem=$(this).next();
                            
                            upperBound = $('#'+ele.id+' .option').scrollTop();
                            //console.log("Upper Bound: "+upperBound);
                            
                            offsetTop = $(this).next().position().top;
                            //console.log("Offset Top: "+offsetTop);
                            
                            lowerBound = $('#'+ele.id+' .option').height();
                            //console.log("Lower Bound: "+lowerBound);
                            /*
                            if(offsetTop<upperBound){
                                $('#'+ele.id+' .option').scrollTop(offsetTop);
                            }
                            */
                            if(offsetTop+elementHeight>lowerBound){
                                //$('#'+ele.id+' .option').scrollTop(upperBound+elementHeight);
                                $('#'+ele.id+' .option').scrollTop(upperBound+(offsetTop-lowerBound));
                            }
                            
                            key.stopImmediatePropagation();
                            key.preventDefault();
                            return false;
                        }
                        
                    }
                    else{
                        $(this).attr('selected', 'selected').addClass('selected');
                        key.stopImmediatePropagation();
                        key.preventDefault();
                        return false;
                        
                    }
                }
                    
                    
            })
        }
        else if(key.keyCode == 9){
            $(document).unbind('keydown');
            if(dropdownType == 'state'){
                $('.state-options').css('display','none');
            }
            else if(dropdownType == 'language_emp'){
                
            }
            else if(dropdownType == 'fluency_emp'){
		
                
            }
            else if(dropdownType == "postype_emp"){
                
            }
            else if(dropdownType == "language_cs"){
                //$('.language-options').hide();
                $('[tabindex=14]').blur();
                $('[tabindex=15]').focus();
            }
            else if(dropdownType == "fluency_cs"){
                $('.fluency-options').hide();
                $('[tabindex=15]').blur();
            }
            else if(dropdownType == "edulevel"){
                $('.education-options').hide();
            }
            else if(dropdownType == "skilevel"){
                $('.skill-options').hide();
            }
            else if(dropdownType == "degree_cs"){
                //$('.degree-options').hide();
                $('[tabindex=10]').blur();
                $('[tabindex=11]').focus();
            }
            else if(dropdownType == "options_cs"){
                $('#options-selector-content').hide();
                $('[tabindex=11]').blur();
                $('[tabindex=12]').focus();
            }
            else if(dropdownType == "edulevel1"){
                $('[tabindex=2]').blur();
                $('[tabindex=3]').focus();
            }
            else if(dropdownType == "edulevel2"){
                $('[tabindex=5]').blur();
                $('[tabindex=6]').focus();
            }
            else if(dropdownType == "edulevel3"){
                $('[tabindex=8]').blur();
                $('[tabindex=9]').focus();
            }
            else if(dropdownType == "explevel1"){
                $('[tabindex=3]').blur();
            }
            else if(dropdownType == "explevel2"){
                $('[tabindex=6]').blur();
            }
            else if(dropdownType == "explevel3"){
                $('[tabindex=9]').blur();
                $('[tabindex=10]').focus();
            }
            key.stopImmediatePropagation();
            key.preventDefault();
        }
        else if(key.keyCode == 13){
            if(dropdownType == 'state'){
                //alert('1');
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        $(this).find('label').click();
                    //var elementID = $(this).find('label').attr('id');
                    //document.getElementById(elementID).click();
                    }
                })
            }
            else if(dropdownType == 'language_emp'){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        var _labelVale = $(this).find('label').html();
                        $('.language-slector .label-default').text(_labelVale);
                        $('.language-slector .label-default-top').text(_labelVale);
                        $('.language-slector .label-default').addClass("text-active");
                        $('.language-slector .label-default-top').addClass("text-active");
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        //$("#language-remove").show();
                    }
                })
            }
            else if(dropdownType == 'fluency_emp'){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        var _labelVale = $(this).find('label').html();
                        //$('.fluency-selector .label-default').text(_labelVale);
                        $('.fluency-selector .label-default-top').text(_labelVale);
                        if(_labelVale=="Conversational") {
                            $('.fluency-selector .label-default-top').removeClass("text-active-blue text-active-red");
                            $('.fluency-selector .label-default-top').addClass("text-active-blue");
                        }
                        else if(_labelVale=="Advanced") {
                            $('.fluency-selector .label-default-top').removeClass("text-active-blue text-active-red");
                            $('.fluency-selector .label-default-top').addClass("text-active-red");
                        }
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        //$("#language-remove").show();
                    }
                })
            }
            else if(dropdownType == "postype_emp"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "language_cs"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        var _labelVale = $(this).find('label').html();
                        $('.language-slector .label-default').text(_labelVale);
                        $('.language-slector .label-default-top').text(_labelVale);
                        $('.language-slector .label-default').addClass("text-active");
                        $('.language-slector .label-default-top').addClass("text-active");
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        $("#language-remove").show();
                        
                    }
                })
            }
            else if(dropdownType == "degree_cs"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        var _labelVale = $(this).find('label').html();
                        $('.degree-slector .label-default').text(_labelVale);
                        $('.degree-slector .label-default-top').text(_labelVale);
                        $('.degree-slector .label-default').addClass("text-active");
                        $('.degree-slector .label-default-top').addClass("text-active");
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        $("#degree-remove").show();
                    }
                })
            }
            else if(dropdownType == "fluency_cs"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        var _labelVale = $(this).find('label').html();
                        $('#fluency-selector .label-default').text(_labelVale);
                        $('#fluency-selector .label-default-top').text(_labelVale);
                        if(_labelVale=="Conversational") {
                            $('#fluency-selector .label-default-top').removeClass("text-active-blue text-active-red");
                            $('#fluency-selector .label-default-top').addClass("text-active-blue");
                        }
                        else if(_labelVale=="Advanced") {
                            $('#fluency-selector .label-default-top').removeClass("text-active-blue text-active-red");
                            $('#fluency-selector .label-default-top').addClass("text-active-red");
                        }
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        $("#language-remove").show();
                        
                    }
                })
            }
            else if(dropdownType == "options_cs"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        var _labelVale = $(this).find('label').html();
                        $('#options-selector .label-default').text(_labelVale);
                        $('#options-selector .label-default-top').text(_labelVale);
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        $("#degree-remove").show();
                        
                    }
                })
            }
            else if(dropdownType == "edulevel1"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "edulevel2"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "edulevel3"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "explevel1"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "explevel2"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "explevel3"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //var _labelVale = $(this).find('label').html();
                        //$('.educationLevel .education-default').text(_labelVale);
                        //$(".education-default").addClass("text-active");
                        //var elementID = $(this).find('label').attr('id').split("_")[0];
                        $(this).find('label').click();
                        
                    }
                })
            }
            else if(dropdownType == "skilevel"){
                $('#'+ele.id+' .option').children().each(function(){
                    if($(this).attr('selected')=="selected"){
                        //alert('2');
                        var _labelVale = $(this).find('label').html();
                        $('.skillLevel .skill-default').text(_labelVale);
                        $(".skill-default").addClass("text-active");
                        var elementID = $(this).find('label').attr('id').split("_")[0];
                        //document.getElementById(elementID).click();
                        $(this).find('label').click();
                        
                    }
                })
            }
            key.stopImmediatePropagation();
            key.preventDefault();
            
        }
        else{
            key.stopImmediatePropagation();
            key.preventDefault();
        }
    }
}

function hasVerticalScroll(element){
    return element.clientHeight < element.scrollHeight;
}