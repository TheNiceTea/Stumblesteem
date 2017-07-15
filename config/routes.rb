Rails.application.routes.draw do
  devise_for :users
	resources :posts do
		member do
			get "like", to: "posts#upvote"
		end
	end

	root 'posts#index'
	get '/go', to: 'posts#random'
end
