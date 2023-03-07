Rails.application.routes.draw do
  get '/', to: 'home#home'
  post '/', to: 'home#home'
  get '/logIn', to: 'auth#logIn'
  post '/logIn', to: 'auth#logIn'
  get '/signUp', to: 'auth#signUp'
  post '/signUp', to: 'auth#signUp'
  get '/addApartment', to: 'departments#addApartment'
  post '/addApartment', to: 'departments#addApartment'
  get '/apartmentsView', to: 'departments#apartmentsView'
  get '/details', to: 'departments#details'
  get '/logOut', to: 'auth#logOut'
  get '/search', to: 'departments#search'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
