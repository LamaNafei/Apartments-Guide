class HomeController < ApplicationController
    def home    #main page
        #test if we have an open session already or not, for appearing log in and sign up, or logout
        @session = session[:email] == nil || session[:email].empty?
        #get search data (work just when users log in)
        @filter = params[:filter].to_s
        @searchValue = params[:search].to_s
        render 'home/home'
    end    
end
