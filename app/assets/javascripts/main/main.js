
jQuery(document).ready(function(){
  var callAjax = function(){
    jQuery.ajax({
      method:'post',
      url:'/messages/message_count_update'
    });
  }
  setInterval(callAjax,5000);
});

//send image via message convertation

$(document).ready(function(){
  $("#message_submit").click(function () { 
    var body_data = $("#message_text").val();
    var body_present=$("#file").val();
           
    if (body_present != "")
    {
      
      var data = new FormData();
      jQuery.each($('#file')[0].files, function(i, file) {
      data.append('file-'+i, file);
      data.append('body',body_data)
      data.append('receiver_id',receiver_id)
      data.append('parent_id',parent_id)
        });
      $("#file").val("");
      $.ajax({
          type: "POST",
          url: "/messages",
          data:  data ,
          cache: false,
          contentType: false,
          processData: false,
          enctype: 'multipart/form-data',
          beforeSend: function() {
              $("#loading-image").show();
           },
           success: function(msg) {
              $("#loading-image").hide();
           }
         
          
      });
      return false;
    }
    else
      {
        
        var body= $("#message_text").val();
        $.ajax({
            type: "POST",
            url: "/messages",
            data:  {body: body ,receiver_id: receiver_id,parent_id: parent_id }
           });
        return false;
      }
  });
});


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
  if($( ".sear-ch" ).length){
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
  }
  });

 // Fetch new posts
 $(document).on("click", "a#fetch", function(event){
      event.preventDefault();

      $.ajax({ url: "/notification?fetch=1",
        success: function(data){
            
            //Update your dashboard
            console.log("success: "+data);
            $("div.right-section").html(data);
            $(".feed").html('');
            
          }, 
        dataType: "html"

      });
      
  });

 // Show upload button
 $(document).on("click", ".write-tip", function(event){

  $('input[type="file"]').fadeIn( "slow" );
  $('input[value="Tip"]').css({
      'margin-left' : '15px',
      'height' : '30px',
  });


 });



$(document).on("keyup", "#tip", function(event){
  var max = 170;
  var len = $(this).val().length;
  var cha = max - len;
  console.log(len);
  $('#charNum').text(cha + ' characters left');
  

 });

$(document).on("click", "#tip", function(event){
  if (localStorage.funmoji != 'null' && localStorage.funmoji != undefined) {

    var text = $('#tip').val();
    var code = localStorage.funmoji;
    $.ajax({
      type: "POST",
       url: '/post/funmoji_post?post_data='+text+' '+code
     });
    $("#tip").val(text+' '+code)
    localStorage.funmoji = 'null'

  }


 });

// Confirm delete
$(document).on("click", ".delete", function(event){
 
  console.log("delete");
  return confirm("Are you sure you want to delete this tip ?");

 
});

// Confirm retip
$(document).on("click", ".re-tip", function(event){
  
  console.log("re-tip");
  return false;

});


// $(document).ready(function(){
//   $("#reply").submit(function() {
    
//     $.ajax({
//       type: "POST",
//        url: "/post/comment",
//        data:$('#reply').serialize()
//      });
//       return false;
//    });  
//  });


$(document).ready(function(){
  $("#uploadbutton").click(function () { 
    var body_data = $("#tip").val();
    var body_present=$("#file").val();
    if (body_present != "")
    {
      
      var data = new FormData();
      jQuery.each($('#file')[0].files, function(i, file) {
      data.append('file-'+i, file);
      data.append('body',body_data)
        });
      $("#file").val("");
      $.ajax({
          type: "POST",
          url: "/post/create",
          data:  data ,
          cache: false,
          contentType: false,
          processData: false,
          enctype: 'multipart/form-data'
         
          
      });
      return false;
    }
    else
      {
        
        var body= $("#tip").val();
        $.ajax({
            type: "POST",
            url: "/post/create",
            data:  {body: body }
           });
        return false;
      }
  });
});



$(document).ready(function(){
  $(".retip1").click(function(){
    var id = this.id
   
    $.ajax({
      type: "POST",
      url: "/post/repost"+"/"+id,
      data:$('#reply').serialize()
    });
    return false;
  });  
});


$(document).ready(function(){
  $(".reply123").click(function () { 
    var post_co_id= $(this).attr("id")
    var body_data1 = $("#"+post_co_id).attr("name");
    var id = $("#"+post_co_id).attr("posts");
    var body_data = $("#"+body_data1).val();
    var body_present=$("#file_"+id).val();
    if (body_present != "")
    {
     
      var data = new FormData();
      jQuery.each($('#file_'+id)[0].files, function(i, file) {
      data.append('file-'+i, file);
      data.append('body',body_data)
      data.append('id',id)
        });
      $("#file_"+id).val("");
     
      $.ajax({
          type: "POST",
          url: "/post/comment",
          data:  data ,
          cache: false,
          contentType: false,
          processData: false,
          enctype: 'multipart/form-data'
         
          
      });
      return false;
    }
    else
      {
          $.ajax({
            type: "POST",
            url: "/post/comment",
            data:  {body: body_data ,id: id }
           });
        return false;
      }
  });
});
