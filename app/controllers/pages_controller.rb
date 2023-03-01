class PagesController < ApplicationController
  def home
    @session = session[:email].empty?
    puts session[:email]
    render 'pages/home'
  end

  def signUp
    strong_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^\-&\*])(?=.{8,})/   
    if request.post?
      email = params[:email].to_s
      password = params[:password].to_s
      type = params[:userType].to_s
      if password.match(strong_regex)
        if ActiveRecord::Base.connection.execute("SELECT Email FROM Users WHERE Email = '#{email}'").empty?
           ActiveRecord::Base.connection.execute("INSERT INTO Users (Email, password, userType) VALUES ('#{email}', '#{password}', '#{type}')")            
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
      render "pages/signUp"
    end
    
  end

  def logIn 
    if request.post?
      email = params[:email].to_s
      session[:email] = email
      userType = ActiveRecord::Base.connection.execute("SELECT userType FROM Users WHERE Email = '#{email}'")[0]['userType']
      session[:userType] = userType
      password = params[:password].to_s
      if ActiveRecord::Base.connection.execute("SELECT Email FROM Users WHERE Email = '#{email}'").empty?
        redirect_to "/logIn?message=The+email+is+not+used+please+sign+up."
        return
      else
        if ActiveRecord::Base.connection.execute("SELECT password FROM Users WHERE Email = '#{email}'")[0]['password'] != password
          redirect_to "/logIn?message=incorrect+password."
          return
        end
        if userType == 1
          redirect_to "/addApartment"
          return
        else
          redirect_to "/apartmentsView"
          return
        end
      end
    end
    render 'pages/logIn'
  end
  
  def addApartment
    pictureNames = []
    if request.post?
      price = params[:price].to_s
      status = params[:apartmentStatus].to_s
      numOfRooms = params[:numOfRooms].to_i
      numOfBathroom = params[:numOfBathroom].to_i
      area = params[:area].to_i
      location = params[:location].to_s
      contactNum = params[:contactNum].to_s
      description = params[:description].to_s
      apartmentPicture = params[:apartmentPictures].to_a
      picture = params[:apartmentPicture]
      puts apartmentPicture
      apartmentPicture.each do |pic|
        savePath = Rails.root.join('app', 'assets', 'images',pic.original_filename)
        File.open(savePath, 'wb') do |file|
          file.write(pic.read)
        end
        pictureNames.push(pic.original_filename)
      end
      File.open(Rails.root.join('app', 'assets', 'images',picture.original_filename), 'wb') do |file|
        file.write(picture.read)
      end
      session[:picture]  = picture.original_filename
      ActiveRecord::Base.connection.execute("INSERT INTO Apartments (email, status, price, numOfRooms, numOfBathrooms, area, location, contacts, description, picture) VALUES ('#{session[:email]}', '#{status}', '#{price}', #{numOfRooms}, #{numOfBathroom}, #{area}, '#{location}', '#{contactNum}', '#{description}', '#{pictureNames}')")
      redirect_to "/apartmentsView"
      return
    end
    render 'pages/addApartment'
  end


  def apartmentsView
    @hidden = session[:userType] == 1
    if @hidden
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE Email = '#{session[:email]}'")
    else
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments")
    end
    render 'pages/apartmentsView'
  end

  def details
    apartmentID = params[:apartmentID].to_i
    @apartment = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE apartmentID = #{apartmentID}")[0]
    @picturesNames = @apartment['picture'].delete('[]" ').split(',')
    render 'pages/details'
  end

  def logOut
    session[:email] = ""
    session[:userType] = nil
    redirect_to '/'
    return
  end
end
