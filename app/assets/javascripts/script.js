$(document).ready(function(){

	$(".enter-site img").click(function(){
	var Year=$(".input3").val(),
	country = $(".country").val(),
	date=$(".input2").val(),
	Month=$(".input1").val(),
	currentYear=2013,
	getAge= currentYear - Year,
	error1="Please enter a date of birth",
	error2="You must be over 18+ to use this site";
	
	if(Year=="" || date=="" || date>31 || Month=="" || Month>12 ){
		$(".input1,.input2,.input3").css({'color':'#DF9204'});
		$(".error").fadeIn().html(error1);
	}else if(getAge<18){
		$(".enter-site3").css({'display':'none'});
		$(".enter-site").css({'display':'block'});
		$(".error").fadeIn().html(error2);
	}else{
	
		$(".enter-site3").css({'display':'block'});
		$(".enter-site").css({'display':'none'});
		$(".error").fadeOut();
		$(".error").html("");

		// Add country & age to register form
		$("form#register").append('<input type="hidden" name="month" value="'+ Month +'">');
		$("form#register").append('<input type="hidden" name="day" 	value="'+  date +'">');
		$("form#register").append('<input type="hidden" name="year"  value="'+ Year +'">');
		$("form#register").append('<input type="hidden" name="country" value="'+ country +'">');
		
		
	}

});

var a = document.getElementById("a"),
    b = document.getElementById("b"),
    c = document.getElementById("c");

a.onkeyup = function() {
    if (this.value.length === parseInt(this.attributes["maxlength"].value)) {
        b.focus();
    }
}

b.onkeyup = function() {
    if (this.value.length === parseInt(this.attributes["maxlength"].value)) {
        c.focus();
    }
}
	$(".enter-site3").click(function(){

		$("#DOB").hide();
		$("#register").fadeIn();
		$(".enter-site3").html('<div class="submit-form">Register</div>');
	});

	// Submit register form
	$(document).on('click', '.submit-form', function(){

		if ($("input[name='agreement'").is(':checked')) {
			$("#register").submit();
		} else {
			alert("You need to accept our terms before your can register");
		}
		
	});

$(".input1").focus(function(){
	$(".input1[placeholder]").css({"color" : "#000"});
	$(".input1").removeClass('bba');
	$(".input1").addClass('abb');
});
$(".input2").focus(function(){
	$(".input2[placeholder]").css({"color" : "#000"});
	$(".input2").removeClass('bba');
	$(".input2").addClass('abb');
});
$(".input3").focus(function(){
	$(".input3[placeholder]").css({"color" : "#000"});
	$(".input3").removeClass('bba');
	$(".input3").addClass('abb');
});
	
$(".input1").blur(function(){
	$(".input1[placeholder]").css({"color" : "#949493"});
	$(".input1").removeClass('abb');
	$(".input1").addClass('bba');
});

$(".input2").blur(function(){
	$(".input2[placeholder]").css({"color" : "#949493"});
	$(".input2").removeClass('abb');
	$(".input2").addClass('bba');
});
$(".input3").blur(function(){
	$(".input3[placeholder]").css({"color" : "#949493"});
	$(".input3").removeClass('abb');
	$(".input3").addClass('bba');
});


});

//