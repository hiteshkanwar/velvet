var VL = VL || {};
VL = (function($, window, document, Velvet){

  Velvet.message = {
    handleDropdown : function(userName){
      $("#profile_dropdown").on("change",function(){
        var url = $(this).val()
        if(url=="message")
          window.location = userName+"/messages/new"
      })
    }
  };
  return Velvet;
})(jQuery, this, this.document, VL);


