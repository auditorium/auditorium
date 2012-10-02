Auditorium::Application.routes.draw do
  get "admins/index"

  mathjax 'mathjax'
  
  resources :email_settings

  get "ajax/courses"
  get "ajax/lectures"

  match 'intro', :to => 'landing_page#index'
  match 'home', :to => 'home#index'
  match 'permission_denied', :to => 'applications#permission_denied', :as => :permission_denied

  resources :notifications
  
  resources :faculties
  
  controller :search do
    get 'search' => :index, as: :search
  end

  controller :users do
    get 'users' => :index, as: :ranking
    get 'users/moderation' => 'users#moderation', :as => :users_moderation
    match 'users/:id/confirm' => 'users#confirm'
    delete  "users/:id/delete",      :to => "users#destroy", :as => :destroy_user_account
  end

  post 'notifications/mark_all_as_read' => 'notifications#mark_all_as_read', :as => :mark_all_as_read

  devise_for :users, :controllers => { :confirmations => "users/confirmations", :sessions => "users/sessions", :registrations => "users/registrations" }

  resources :courses
  match 'courses/:id/manage_users', :to => 'courses#manage_users'
 # match 'courses/search', :to => 'courses#search'
  match 'courses/:id/following', :to => 'courses#following'
  match 'courses/:id/approve', :to => 'courses#approve', :as => :approve_course
  match 'courses/:id/maintainer_request', :to => 'courses#maintainer_request', :as => :maintainer_request
  
  match 'posts/:id/rate', :to => 'posts#rate', :as => :rate_post
  match 'posts/:id/answered', :to => 'posts#answered', :as => :answered_post
  match 'posts/:parent_id/answering', :to => 'posts#answering'
  match 'posts/:parent_id/commenting', :to => 'posts#commenting'

  resources :reports

  match '/reports/:id/mark_read', :to => 'reports#mark_read', :as => 'mark_report_as_read'

  resources :course_memberships
  match "my_courses", :to => "course_memberships#index"
  
  resources :chairs

  resources :posts do
    get :autocomplete_courses_name, :on => :collection
  end

  resources :reports

  resources :periods

  resources :terms

  resources :institutes

  resources :events

  resources :lectures
# run "rake db:jexam_sync" instead of GETting an url
#  resources :jexamwebservice

  root to: "landing_page#index"

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
  # match ':controller(/:action(/:id))(.:format)'
end
