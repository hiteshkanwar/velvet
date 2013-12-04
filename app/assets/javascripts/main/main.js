

//ADDING PLACEHOLDER FOR MAILCHUMP

jQuery(document).ready(function($){    
           $('#mc_mv_EMAIL').attr('placeholder', 'Email');
               $('#mc_mv_FNAME').attr('placeholder', 'Name');
});


//INITIALIZING NIVOSLIDER

jQuery(window).load(function(){
    jQuery(".nivoSlider br").each(function(){ // strip BR elements created by Wordpress
	   jQuery(this).remove();
	});
	jQuery('.nivoSlider').nivoSlider({
		effect:'fade', //Specify sets like: 'random,fold,fade,sliceDown'
		animSpeed:500, //Slide transition speed
		pauseTime:8000,
		directionNav:false, //Next & Prev
        controlNav:true,
        directionNavHide:true, //Only show on hover
		captionOpacity:1 //Universal caption opacity
        
	});
});




//custom js 
  $(document).ready(function(){
     $(".widget_nav_menu ul li a").append("<span>|</span>");



});



$(document).ready(function(){
  $("a#submitme").click(function(){
     $("#lead-form").submit();
  });
});







//INITIALIZING JCAROUSEL

function mycarousel_initCallback(carousel)
{
    // Disable autoscrolling if the user clicks the prev or next button.
    carousel.buttonNext.bind('click', function() {
        carousel.startAuto(0);
    });

    carousel.buttonPrev.bind('click', function() {
        carousel.startAuto(0);
    });

    // Pause autoscrolling if the user moves with the cursor over the clip.
    carousel.clip.hover(function() {
        carousel.stopAuto();
    }, function() {
        carousel.startAuto();
    });
};

jQuery(document).ready(function() {
    jQuery('#mycarousel').jcarousel({
        auto: 2,
        wrap: 'last',
        initCallback: mycarousel_initCallback
    });
    
   
    
});


//ADDING CUSTOM CLASSES
  
  $(document).ready(function(){
    
     $(".row .span7").addClass("content-pad");
    
	$('#wrap').fadeIn(500);
});




//ENABLING MODAL SYSTEM FROM BOOTSTRAPER JS


  $(document).ready(function(){
    
$('#lunch').click(function(){
$('#myModal').modal('toggle')
    
    $('#wp-submit').addClass('btn btn-primary');
    

});

});


//ENABLING BUTTONDROPDOWN SYSTEM FROM BOOTSTRAPER JS


 $(document).ready(function () {
          $('.dropdown-toggle').dropdown();
    }); 


    
//ENABLING TABS SYSTEM FROM BOOTSTRAPER JS    

 $(document).ready(function () {
    
$('#myTab a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');
});
}); 
    
//ENABLING POPOVER SYSTEM FROM BOOTSTRAPER JS and button looding effect

 $(document).ready(function () {
    
$('#popup').popover('toggle');
$('#specialbutton').click(function(){
$('#specialbutton').button('loading');
});
    }); 
    
 //ENABLING SLIDER SYSTEM FROM BOOTSTRAPER JS 
     $(document).ready(function () {
    $('#myCarousel').carousel();
    
      }); 
      
 //ENABLING AUTOCOMPLE TEXT SYSTEM FROM BOOTSTRAPER JS 
     $(document).ready(function () {
   $('.typeahead').typeahead();
    
      });      

 // Search autocomplete
 $(function() {
    $( ".sear-ch" ).autocomplete({

      source: function( request, response ) {
            $.ajax({

              type: "GET",
              url: "/search",
              data: {'q': request.term, 'source':'autocomplete' },
              contentType: "application/json; charset=utf-8",
              dataType: "json",
              success: function(data) {
                 response(data);
              }

            });
        }
      });

  });

 