=begin
 Filename: main.rb
 Directory: /Users/abruzzim/Documents/ga_wdi/projects/blog
 Author: Mario Abruzzi
 Date: 16-Dec-2013
 Desc: Week 03 - Day 01 - Demo
 Notes: Starts Sinatra listening on port 4567
=end

# Configure the load path so all dependencies
# in the Gemfile can be required. Only Gems from
# specified groups will be added.

require 'pry'
##require 'activerecord' # Signals error when uncommented. Why?
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

# Enable PSQL (debug) command logging.

ActiveRecord::Base.logger = Logger.new(STDOUT)

# Bundler: Ruby Dependency Manager
#
#  Bundler automatically discovers the Gemfile
#  and ensure that Ruby can find all of the
#  Gems, and their dependencies, in the Gemfile.

##require 'bundler/setup' # <-- Error when uncommented.

# Require all the Gems in the Gemfile.

##Bundler.require(:default) # <-- Error when uncommented.

# Configure the Database

require_relative 'config/database'

# Include Class Models

require_relative 'models/user'
require_relative 'models/post'
#require_relative 'specs/'
#require_relative 'views/registration'

# Enable Cookie-based Sessions

configure do
  enable :sessions
end

# Sinatra Default Route

get '/' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET Default (/) Route" 
  p "  %DEBUG-I-MAINRB, GET '/' Route Params Hash Keys", params.keys 
  p "  %DEBUG-I-MAINRB, GET '/' Route Params Hash Values", params.values 
  #p "%DEBUG-I-MAINRB, GET '/' Route Params Methods" 
  #  params.methods.each do |element|
  #    p "#{element}" 
  #  end 
  p "  %DEBUG-I-MAINRB, GET '/' Route Session Keys and Values" 
    session.keys.each do |key,value|
      p "Session key: #{key}; Session value: #{session[key]}" 
    end 
  #p "%DEBUG-I-MAINRB, GET '/' Route Session Methods" 
  #  session.methods.each do |element|
  #    p "#{element}" 
  #  end 
  @first_name = session[:first_name]
  p "  DEBUG @first_name value is: #{@first_name}"
  erb :home # Display navigation menu.
end

# Sinatra GET /user/register Route - Display User Registration Form Page

get '/user/register' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/user/register' Route"
  p "  %DEBUG-I-MAINRB, GET '/user/register' Route Params Hash Keys", params.keys
  p "  %DEBUG-I-MAINRB, GET '/user/register' Route Params Hash Values", params.values
  p "  %DEBUG-I-MAINRB, GET '/user/register' Route Session Keys & Values"
    p "  Session Hash START"
    session.keys.each do |key,value|
      p "Session key: #{key}, Value is: #{session[key]}"
    end
    p "  Session Hash END"
  # Call user registration form view.
  erb :registration
end

# Sinatra POST /user/create Route - Create New User Record

post '/user/create' do
  p "  %DEBUG-I-MAINRB, In Sinatra POST '/user/create' Route"
  p "  %DEBUG-I-MAINRB, POST '/user/create' Route Params Hash Keys", params.keys
  p "  %DEBUG-I-MAINRB, POST '/user/create' Route Params Hash Values", params.values
  p "  %DEBUG-I-MAINRB, POST '/user/create' Route Session Keys & Values"
    session.keys.each do |key,value|
      p "Session key: #{key}; Value is: #{session[key]}"
    end
  # User Object Constructor.
  user = User.new             # Create bare User object.
  user.fname = params[:fname] # Specify User first name attribute.
  user.lname = params[:lname] # Specify User last name attribute.
  user.uname = params[:uname] # Specify User username attribute.
  user.pword = params[:pword] # Specify User password attribute.
  user.bio   = params[:bio]   # Specify User biography attribute.
  user.save!                  # Insert User Object into Table

  # Redirect to Home Page.
  redirect '/'
end

# Sinatra Get /post/create Route - Display Post Form Page

get '/post/create' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/post/create' Route"
  p "  %DEBUG-I-MAINRB, GET '/post/create' Route Session Keys and Values" 
    session.keys.each do |key,value|
      p "Session key: #{key}; Session value: #{session[key]}" 
    end 
  @first_name = session[:first_name]
  @user_id    = session[:user_id]
  erb :createpost
end

# Sinatra POST /post/create Route - Create New Post Record

post '/post/create' do
  p "  %DEBUG-I-MAINRB, In Sinatra POST '/post/create' Route"
  p "  %DEBUG-I-MAINRB, POST '/post/create' Route Params Hash Keys", params.keys 
  p "  %DEBUG-I-MAINRB, POST '/post/create' Route Params Hash Values", params.values 
  # Post Object Constructor.
  post = Post.new
  post.title   = params[:title]
  post.body    = params[:body]
  post.user_id = params[:user_id]
  post.save!

  # Redirect to Home Page
  redirect '/'
end

# Sinatra GET /user/login - Display Login Form Page

get '/user/login' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/user/login' Route"
  erb :login
end

# Sinatra POST /user/login

post '/user/login' do
  p "  %DEBUG-I-MAINRB, In Sinatra POST '/user/login' Route"
  p "  %DEBUG-I-MAINRB, POST '/user/login' Route Params Hash Keys", params.keys
  p "  %DEBUG-I-MAINRB, POST '/user/login' Route Params Hash Values", params.values
  p "  %DEBUG-I-MAINRB, POST '/user/login' Route Session Keys & Values"
    session.keys.each do |key,value|
      p "Session key: #{key}; Value is: #{session[key]}"
    end

  # Set seesion variable if username exists in the 'users' table.
  #session[:username] = params[:uname] if User.where(uname: params[:uname]).exists?
  #p "  %DEBUG-I-MAINRB, POST '/user/login' session[:username] is: #{session[:username]}"

  if User.where(uname: params[:uname]).exists?
    p "#{params[:uname]} exists in the database."
    curr_user = User.find_by(uname: params[:uname]) # Ensure uname does not allow duplicates.
    session[:user_id]    = curr_user.id
    session[:username]   = curr_user.uname
    session[:first_name] = curr_user.fname
  else
    p "#{params[:uname]} does not exist in the database."
  end

  # Redirect to Home Page
  redirect '/'
end

# Sinatra GET /user/logout - Destroy the Session

get '/user/logout' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/user/logout' Route"
  p "  %DEBUG-I-MAINRB, Inspect GET '/user/logout' session object", session.inspect
  session.clear
  # Redirect to the Home Page
  redirect '/'
end

# Sinatra GET /user/listing

get '/user/listing' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/user/listing' Route"
  @userlist = User.all               # Get the ActiveRecord::Relation Object.
  p @userlist                        # Display ActiveRecord::Relation Object.
  @first_name = session[:first_name] # Define so that nav options display correctly.
  erb :showusers
end

# Sinatra GET /post/listing

get '/post/listing' do
  p "  %DEBUG-I-MAINRB, In Sinatra GET '/post/listing' Route"
  @postlist = Post.all               # Get the ActiveRecord::Relation Object.
  p @postlist                        # Display ActiveRecord::Relation Object.
  @first_name = session[:first_name] # Define so that nav options display correctly.
  erb :showposts
end

