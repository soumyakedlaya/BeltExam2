class BorrowerSessionsController < ApplicationController

  def index
    #renders views/borrower_sessions/index.html.erb automatically
  end

  # find user in borrower db using email input from login form
  #if passwords match, login and set session[:id] to that user's id
  #if password mismatch, flash error messages, redirect to login page
  def create
    borrower = Borrower.find_by_email(params[:Email])
    if borrower && borrower.authenticate(params[:Password])
      session[:borrower_id] = borrower.id
      # binding.pry
      redirect_to "/online_lending/borrower/#{borrower.id}"
    else
      initialize_flash
      flash[:login_errors] << "Invalid email and password combination"
      redirect_to "/online_lending/borrower/login"
    end
  end

#when logout button is clicked, set session[:id] to nil and redirect to root route
  def destroy
    session[:borrower_id] = nil
    # binding.pry
    redirect_to "/"
  end

end
