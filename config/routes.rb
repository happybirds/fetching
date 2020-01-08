require 'sidekiq/web'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	mount Sidekiq::Web => '/sidekiq'

	root 'lists#index'

	get '/dictionary' => 'lists#dictionary'
	get '/save_dir' => 'lists#save_dir'


	get '/olf' => 'lists#olf'
	get '/save_olf' => 'lists#save_olf'

	get '/collfe' => 'lists#collfe'
	get '/save_collfe' => 'lists#save_collfe'	

	get '/fk' => 'lists#fk'
	get '/save_fk' => 'lists#save_fk'	


end
