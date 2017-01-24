class LenderSessionsController < ApplicationController
  def index
    #renders views/lender_sessions/index.html.erb automatically
  end

# find user in lender db using email input from login form
#if passwords match, login and set session[:id] to that user's id
#if password mismatch, flash error messages, redirect to login page
  def create
    lender = Lender.find_by_email(params[:Email])
    if lender && lender.authenticate(params[:Password])
      session[:lender_id] = lender.id
      redirect_to "/online_lending/lender/#{lender.id}"
    else
      initialize_flash
      flash[:login_errors] << "Invalid email and password combination"
      redirect_to "/online_lending/lender/login"
    end
  end

#when logout button is clicked, set session[:id] to nil and redirect to root route
  def destroy
    session[:lender_id] = nil
    redirect_to "/"
  end

end
