Apb2::Application.routes.draw do

  # Resourceful Routes
  resources :sessions, :only => [:new, :create, :destroy]
  resources :users do
    resources :organizations, :controller => "user_organizations", :only => [:index]
  end
  resources :user_profiles
  
  # Sessions
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'

  # Pages
  match '/home', :to => 'pages#home'
  match '/aboutus', :to => 'pages#aboutus'
  match '/contactus', :to => 'pages#contactus'
  match '/non-profit_testimonials', :to => 'pages#org_testimonials'
  match '/volunteer_testimonials', :to => 'pages#vol_testimonials'
  match '/contactus', :to => 'pages#contactus'

  # Users
  match '/register', :to => 'users#new', :as => 'register'
  match '/verify/:id', :to => 'users#verify', :as => 'email_verification'
 
  # Volunteers (UserProfiles)
  match '/volunteers/new', :to => 'user_profiles#new', :as => 'new_volunteer'
  match '/matches', :to => "projects#matches", :as => 'project_matches'

  # Organizations & Projects
  match '/verify_organization/:id' => 'organizations#verify', :as => :organization_verify
  match '/verify_project/:id' => 'projects#verify', :as => :project_verify

  match '/organizations', :to => "organizations#index", :via => :get
  match '/organizations/new', :to => 'organizations#new', :as => 'new_organization'
  match '/organizations', :to => 'organizations#create', :via => :post
  match '/organizations', :to => 'organizations#update', :via => :put
  match '/organizations', :to => 'organizations#destroy', :via => :delete

  # scope "/:organization", :contraints => {:organization => /((?!volunteer|login|logout|register|home).)*/ } do
  scope "/:organization", do
    scope "/:project" do
      match '/' => "projects#show", :via => :get, :as => 'organization_project'
      match '/' => "projects#update", :via => :put
      match '/' => "projects#destroy", :via => :delete
      match '/edit' => "projects#edit", :via => :get, :as => 'edit_organization_project'
    end
    match '/' => 'organizations#show', :via => :get, :as => 'organization'
    match '/edit' => 'organizations#edit', :via => :get, :as => 'edit_organization'
    match '/projects' => "projects#create", :via => :post
    match '/projects/new' => "projects#new", :via => :get, :as => 'new_organization_project'
  end



  root :to => 'pages#home'
    


  # /sample-organization
  # /sample-organization/projects/new
  # /sample-organization/sample-project
  # /sample-organization/sample-project/edit
  # /sample-organization/sample-project/delete




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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
