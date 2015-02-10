Rails.application.routes.draw do
  resources :comments

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :blogs do
    resources :comments
    member do
      get '/update/(:status)', to: 'blogs#update_blog_status'
      post :add_comment
      put :rename
    end
    collection do
      put :destroy_multiple
    end
    # get 'search/(:params)', on: :collection
  end

  # You can have the root of your site routed with "root"
  root 'blogs#index'
end
