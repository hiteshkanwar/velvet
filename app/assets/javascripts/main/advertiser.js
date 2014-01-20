var VL = VL || {};
VL = (function($, window, document, Velvet){
  Velvet.advertiser = {
    initStripe : function(stripePublisher){
      var response = StripeCheckout.open({
        key:         stripePublisher,
        address:     false,
        currency:    'usd',
        name:        'All Pack',
        description: 'Buy ads',
        panelLabel:  'Purchase ad spot ',
        token:       Velvet.advertiser.addToken
      });
    },
    addToken : function(response){
      $("#stripe_card_token_field").val(response.id);
      $(".buyAd").val("Done");
      // Velvet.advertiser.submitAdvertiser()
    },
    submitAdvertiser : function(){
      $("#advertiser_form")[0].submit();
    },
    initAdvertiser : function(stripePublisher){
      $("#advertiser_form").validate({
         errorClass: "invalid",
         errorPlacement: function(error, element) {
          element.siblings('.errordiv').html(error)
        }
        
      });
      Velvet.advertiser.activateForm(stripePublisher);
    },
    activateForm : function(stripePublisher){
      $("#advertiser_form").on("submit",function(e){
        if($("#advertiser_form").valid() && $("#stripe_card_token_field").val()!=""){
          Velvet.advertiser.submitAdvertiser()
          // Velvet.advertiser.initStripe(stripePublisher);
        }
        else if($("#stripe_card_token_field").val()=="")
        {
           Velvet.advertiser.initStripe(stripePublisher);
        }
        return false
      })
    }

  }
return Velvet;
})(jQuery, this, this.document, VL);
