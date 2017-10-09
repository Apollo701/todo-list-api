Rails.application.routes.draw do
  post '/login' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  defaults format: :json do
    resources :todos, only: [:create, :update, :destroy]
    resources :users, only: [:create, :show, :update, :destroy]
  end
end
