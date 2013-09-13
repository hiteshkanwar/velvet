$(document).ready(function(){

	// Check age restrictions
	$(".enter-site img").click(function(){
	
		var input3  = $(".input3").val();
		var input2  = $(".input2").val();
		var input1  = $(".input1").val();
		var country = $(".country").val();
		var res=2013-input3;

		// Validate entries
		if(input1=="" || input3=="" || input2=="" ){

			alert("Please complete form");
			$(".enter-site").css({'display':'block'});

			$(".enter-site3").css({'display':'none'});
				
		}else if(res<18 ){
			alert("You must be over 18+ to use this site");
			$(".enter-site3").css({'display':'none'});
			$(".enter-site").css({'display':'block'});
			}else{
			$(".enter-site3").css({'display':'block'});
			$(".enter-site").css({'display':'none'});

			// Add country & age to register form
			$("form#register").append('<input type="hidden" name="month" value="'+ input1 +'">');
			$("form#register").append('<input type="hidden" name="day" 	value="'+ input2 +'">');
			$("form#register").append('<input type="hidden" name="year"  value="'+ input3 +'">');
			$("form#register").append('<input type="hidden" name="country" value="'+ country +'">');
			
			return false;
		}
	});

	$(".enter-site3").click(function(){
		$(".first").hide();
		$(".second").show();
		$(".enter-site3").html('<div class="submit-form">Submit</div>');
		
	});

	// Submit register form
	$(document).on('click', '.submit-form', function(){
		$("#register").submit();
	});


});