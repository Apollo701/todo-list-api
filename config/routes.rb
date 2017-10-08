Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  defaults format: :json do
    resources :todos, only: [:create, :update, :destroy]
  end

  scope format: true, constraints: { format: :json } do
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
  end
end
