var VL = VL || {};
VL = (function($, window, document, Velvet){

  Velvet.message = {
    handleDropdown : function(userName){
      $("#profile_dropdown").on("change",function(){
        var url = $(this).val()
        if(url=="message")
          window.location = "/messages/new"
      })
    },
    receiverSearch : function(){
      $(".receiver-search" ).autocomplete({
        source: function( request, response ) {
          $.ajax({

            type: "GET",
            url: "/messages/search_receivers",
            data: {'q': request.term, 'source':'autocomplete' },
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(data) {
             response(data);
             
             

           }
         });
        },
        select: function(event, ui) {
          $( "#receiver_id" ).val( ui.item.id );
          $("#user_profile_image").attr("src",ui.item.user_avatar)
        }
      });
    },
    validateReceiver : function(){
      $("#new_message").on("submit",function(e){

        if($("#receiver_id").val() == ""){
          alert("Please select receiver");
          return false;
        }
        if($("#message_text").val() == "" ){
          alert("Message is empty");
          return false;
        }
      })
    }
  };
  return Velvet;
})(jQuery, this, this.document, VL);


