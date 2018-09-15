require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	mount Sidekiq::Web => '/sidekiq'

	root 'lists#index'
	get 'my' => 'lists#my'
   
end
