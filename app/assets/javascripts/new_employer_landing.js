var playMonitor;
var rotateSwitchMonitor;
$(document).ready(function(){
    startMonitorSlider();
    startQuoteSlider();
    bindMonitorSlides();
});

function startMonitorSlider() {
    $(".main-container .monitor .bottom-one .navigation ul li a:first").addClass("active");
    // Initialize Monitor Slider
    var monitorWidth = $(".main-container .monitor .middle .slide").width();
    var slideSum = $(".main-container .monitor .middle .slide .slide-content li").size();
    var monitorReelWidth = monitorWidth * slideSum;
    $(".main-container .monitor .middle .slide .slide-content").css({
        'width' : monitorReelWidth
    });
    //Paging + Slider Function
    rotateMonitor = function(){
        var triggerID = $activeMonitor.attr("rel") - 1;
        var monitorPosition = triggerID * monitorWidth;
        $(".main-container .monitor .bottom-one .navigation ul li a").removeClass('active');
        $activeMonitor.addClass('active');
        //Slider Animation
        $(".main-container .monitor .middle .slide .slide-content").animate({
            left: -monitorPosition
        }, 1000 );
    };
    //Rotation + Timing Event
    rotateSwitchMonitor = function(){
        playMonitor = setInterval(function(){
            $activeMonitor = $('.main-container .monitor .bottom-one .navigation ul li a.active').parent().next().find('a');
            if ( $activeMonitor.length === 0) {
                $activeMonitor = $('.main-container .monitor .bottom-one .navigation ul li a:first');
            }
            rotateMonitor();
        }, 4000);
    };
    rotateSwitchMonitor();
    // On Hover
    $(".main-container .monitor .middle .slide .slide-content li").hover(function() {
        clearInterval(playMonitor);
    }, function() {
        rotateSwitchMonitor();
    });
    // On Click
    $(".main-container .monitor .bottom-one .navigation ul li a").click(function() {
        $activeMonitor = $(this);
        clearInterval(playMonitor);
        rotateMonitor();
        rotateSwitchMonitor();
        return false;
    });
}

function startQuoteSlider() {
    // Initialize Quotes Slider
    var quoteWidth = $(".main-container .quotes-container").width();
    var totalQuotes = $(".main-container .quotes-container .quote-content li").size();
    var quoteSliderWidth = totalQuotes * quoteWidth;
    // Adjust the slider to it's new size
    $(".main-container .quotes-container .quote-content").css({
        'width' : quoteSliderWidth
    });
    // Slider Function
    rotate = function(){
        var triggerID = $active.attr("rel") - 1;
        var sildeToPosition = triggerID * quoteWidth;
        $(".main-container .quotes-container .quote-content li").removeClass('active');
        $active.addClass('active');

        //Slider Animation
        $(".main-container .quotes-container .quote-content").animate({
            left: -sildeToPosition
        }, 1000 );
    };
    // Timing Event
    rotateSwitch = function(){
        play = setInterval(function(){ //Set timer - this will repeat itself every 3 seconds
            $active = $('.main-container .quotes-container .quote-content li.active').next();
            if ( $active.length === 0) {
                // If paging reaches the end, go back to the first
                $active = $('.main-container .quotes-container .quote-content li:first');
            }
            rotate();
        }, 4000);
    };
    rotateSwitch();
    //On Hover
    $(".main-container .quotes-container .quote-content li").hover(function() {
        clearInterval(play); //Stop the rotation
    }, function() {
        rotateSwitch(); //Resume rotation
    });
}

function bindMonitorSlides() {
    $(".main-container .monitor .slide-content li").unbind().click(function(){
        var slideID = parseInt($(this).index());
        switch(slideID) {
            case 0:
                openVideoPopup(1);
                break;
            case 1:
                openPDFPopup(5);
                break;
            case 2:
                openPDFPopup(4);
                break;
            default:
                hideNormalShadow();
        }
    });
}

function openVideoPopup(id) {
    $("#fade_normal_dark").show();
    $("#fade_normal_dark .popup-loader").show();
    showBlockShadow();
    $(".footer-links .hilo").addClass('white');
    clearInterval(playMonitor);
    $.ajax({
        url: "/ajax/elp_show_video?id="+id,
        cache: false,
        success: function(data){
            clearInterval(playMonitor);
            $('body').append(data);
            $("#our_latest_video").show();
            hideBlockShadow();
            centralizePopup();
            $("#fade_normal_dark").unbind().click(function(){
                $("#our_latest_video").remove();
                $("#fade_normal_dark").hide();
                $("#fade_normal_dark .popup-loader").hide();
                $(".footer-links .hilo").removeClass('white');
                clearInterval(playMonitor);
                rotateSwitchMonitor();
            });
        }
    })
}

function openPDFPopup(id) {
    $("#fade_normal_dark").show();
    showBlockShadow();
    $(".footer-links .hilo").addClass('white');
    clearInterval(playMonitor);
    $.ajax({
        url: "/ajax/elp_show_pdf?id="+id,
        cache: false,
        success: function(data){
            clearInterval(playMonitor);
            $('body').append(data);
            $("#our_latest_pdf").show();
            hideBlockShadow();
            centralizePopup();
            $("#fade_normal_dark").unbind().click(function(){
                $("#our_latest_pdf").remove();
                $("#fade_normal_dark").hide();
                $("#fade_normal_dark .popup-loader").hide();
                $(".footer-links .hilo").removeClass('white');
                clearInterval(playMonitor);
                rotateSwitchMonitor();
            });
        }
    })
}

function openImagePopup(id) {
    $("#fade_normal_dark").show();
    $("#"+id).show();
    centralizePopup();
    $(".footer-links .hilo").addClass('white');
    $("#fade_normal_dark").unbind().click(function(){
        $(".white_content").hide();
        $("#fade_normal_dark").hide();
        $("#fade_normal_dark").unbind();
        $(".footer-links .hilo").removeClass('white');
    });
}