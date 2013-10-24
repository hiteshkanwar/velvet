jQuery(document).ready(function(){
     jQuery('#main_cat').click(function(){
  
     alert("sadada");
     });
     $('.target').change(function() {
  var value=$(this).val();
         doAjaxRequest(value);
});
     
     
});
function doAjaxRequest(val){
     // here is where the request will happen
     jQuery.ajax({
          url: ajax_url,
          data:{
               'action':'do_ajax',
               'fn':val,
               'count':10
               },
          success:function(data){
                 // our handler function will go here
                 // this part is very important!
                 // it's what happens with the JSON data
                 // after it is fetched via AJAX!
      $("#result").html(data)

                             },
          error: function(errorThrown){
               alert('error');
               console.log(errorThrown);
          }
 
     });
 
}