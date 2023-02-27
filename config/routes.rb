Rails.application.routes.draw do
  get '/', to: 'pages#home'
  get '/logIn', to: 'pages#logIn'
  post '/logIn', to: 'pages#logIn'
  get '/signUp', to: 'pages#signUp'
  post '/signUp', to: 'pages#signUp'
  get '/addApartment', to: 'pages#addApartment'
  post '/addApartment', to: 'pages#addApartment'
  get '/apartmentsView', to: 'pages#apartmentsView'
  get '/details', to: 'pages#details'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
