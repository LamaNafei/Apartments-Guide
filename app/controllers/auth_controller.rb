class AuthController < ApplicationController
    #sign-up page to create a new account
    def signUp
        #password condition
        strong_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^\-&\*])(?=.{8,})/   
        #check if the page method is "post".
        if request.post?
          #get data from html page  
          email = params[:email].to_s
          password = params[:password].to_s
          type = params[:userType].to_s
          #test password condition and email wasn't used
          if password.match(strong_regex)
            if ActiveRecord::Base.connection.execute("SELECT Email FROM Users WHERE Email = '#{email}'").empty?
               ActiveRecord::Base.connection.execute("INSERT INTO Users (Email, password, userType) VALUES ('#{email}', '#{password}', '#{type}')")            
               #If everything is in order, redirect to the log in page to log in. 
               redirect_to '/logIn', notice: 'Your account has been created successfully!'
               return
            else
              redirect_to "/signUp?message=The+email+is+already+used."
              return
            end
          else
            redirect_to "/signUp?message=The+password+is+weak.+Please+try+again+with+a+password+that+is+at+least+8+characters+long,+includes+at+least+one+uppercase+letter,+one+lowercase+letter,+one+digit,+and+one+special+character."
            return
          end
        else
          render "auth/signUp"
        end
        
      end
    
      def logIn 
        #check if page method is post or get
        if request.post?
          #get data from the HTML page and check it
          email = params[:email].to_s
          session[:email] = email
          userType = ActiveRecord::Base.connection.execute("SELECT userType FROM Users WHERE Email = '#{email}'")[0]['userType']
          session[:userType] = userType
          password = params[:password].to_s
          #check email is existing and password is right
          if ActiveRecord::Base.connection.execute("SELECT Email FROM Users WHERE Email = '#{email}'").empty?
            redirect_to "/logIn?message=The+email+is+not+used+please+sign+up."
            return
          else
            if ActiveRecord::Base.connection.execute("SELECT password FROM Users WHERE Email = '#{email}'")[0]['password'] != password
              redirect_to "/logIn?message=incorrect+password."
              return
            end
            #check user is a landlord or customer to redirect him to the right page
            if userType == 1
              redirect_to "/addApartment"
              return
            else
              redirect_to "/apartmentsView"
              return
            end
          end
        end
        render 'auth/logIn'
    end 

    def logOut
        #method to end the session and clear the data
        session[:email] = ""
        session[:userType] = nil
        redirect_to '/'
        return
    end   
end
