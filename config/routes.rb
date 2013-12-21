Velvet::Application.routes.draw do

  root :to => 'dashboard#index', :constraints => lambda{|req| !req.session[:email].blank?}
  root :to => 'landing#index'

  
  match '/login',     :to => 'landing#login'
  match '/register',  :to => 'landing#register'
  match '/logout',    :to => 'landing#logout'
  match '/forgot',    :to => 'landing#forgot'
  match '/confirm_forgot',    :to => 'landing#confirm_forgot'

  # Static pages

   match '/privacy',     :to => 'landing#privacy'
   match '/about',     :to => 'landing#about'
   match '/terms',     :to => 'landing#terms'

  #resources :profile, :path=>''
  match "/post/create", :to => 'post#create'
  match "/post/comment", :to => 'post#comment'

  # Search
  # match "/dashboard/search", :to => 'dashboard#search'
  ### match ':username/dashboard/:action', :controller => 'dashboard'
  match '/activity', :to => 'dashboard#activity'

  match '/discover', :to => 'dashboard#discover'
  match '/search', :to => 'dashboard#search'
  match '/search/:q', :to => 'dashboard#search'

  #--
  # Feed notification
  #--
  
  match '/notification', :to => 'dashboard#notification'

  resources :messages do
    collection do
      get 'sent'
      get 'trash'
      get 'search_receivers'
    end
    member do
      get 'move_to_trash'
      get 'undelete'
    end
  end

  match '/landing/:action/:id', :controller => 'landing'
  match ':username', :controller => 'profile', :action => 'show'
  match ':username/:action', :controller => 'profile'
  match ':username/:action/:id', :controller => 'profile'
  match ':username/messages/:action',:controller=>"messages"
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
