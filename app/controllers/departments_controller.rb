class DepartmentsController < ApplicationController
  #page for landlords and users to add new apartments
  def addApartment
    pictureNames = []
    if request.post?
      #get data of apartment from html page
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
      #Save pictures in the assets file to appear in the apartment view and details pages.
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
      #Insert new apartment data into the database with the apartment ID and email of the landlord who added it.
      ActiveRecord::Base.connection.execute("INSERT INTO Apartments (email, status, price, numOfRooms, numOfBathrooms, area, location, contacts, description, picture) VALUES ('#{session[:email]}', '#{status}', '#{price}', #{numOfRooms}, #{numOfBathroom}, #{area}, '#{location}', '#{contactNum}', '#{description}', '#{pictureNames}')")
      redirect_to "/apartmentsView"
      return
    end
    render 'departments/addApartment'
  end


  def apartmentsView
    #bool var to check if user is landlord or customer for the add apartment button to appear in the page.
    @hidden = session[:userType] == 1
    #If the landlord appears only with his apartment from the database, if the customer appears with all apartments in the database
    if @hidden
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE Email = '#{session[:email]}'")
    else
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments")
    end
    render 'departments/apartmentsView'
  end

  #page to show all the details of the apartment the customer is interested in, with a slider for apartment pictures.
  def details
    #get apartment ID of apartment the customer choose from url
    apartmentID = params[:apartmentID].to_i
    @apartment = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE apartmentID = #{apartmentID}")[0]
    @picturesNames = @apartment['picture'].delete('[]" ').split(',')
    render 'departments/details'
  end

  def search
    #When the user returns to the home page after logging in, he can search in the apartment for specific data. 
    filter = params[:filter].to_s
    searchValue = params[:search].to_s
    if filter == '*'
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE area LIKE '#{searchValue}';")
      @apartments | ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE location LIKE '#{searchValue}';")
      @apartments | ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE numOfRooms LIKE '#{searchValue}';")
      @apartments | ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE numOfBathrooms LIKE '#{searchValue}';")
      @apartments | ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE price LIKE '#{searchValue}';")
    else
      @apartments = ActiveRecord::Base.connection.execute("SELECT * FROM Apartments WHERE #{filter} = '#{searchValue}'")
    end
    render 'departments/search'
  end
end
