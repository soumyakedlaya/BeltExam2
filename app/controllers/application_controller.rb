#all methods available for entire app
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #prevent user from visiting a page without logging in
  # if no user in session, redirect to root route
  def require_login
    if session[:lender_id]
      # binding.pry
      redirect_to '/' if session[:lender_id] == nil
    end
    if session[:borrower_id]
      redirect to '/' if session[:borrower_id] == nil
    end
  end

  #confirm if current user is the user who completes various actions in the app
  #if the users don't match, redirect to root route
  def require_correct_user
    if session[:lender_id]
      user = Lender.find(session[:lender_id])
    end
    if session[:borrower_id]
      user =  Borrower.find(session[:borrower_id])
      # binding.pry - adds a breakpoint to debug in console
    end
    # binding.pry
    redirect_to "/" if current_user != user || current_user == nil
  end

#initialze various flash error messages
  def initialize_flash
    if !flash[:lender_reg_errors]
      flash[:lender_reg_errors] = []
    end
    if !flash[:borrower_reg_errors]
      flash[:borrower_reg_errors] = []
    end


    if !flash[:login_errors]
      flash[:login_errors] = []
    end

    if !flash[:errors]
      flash[:errors] = []
    end

    if !flash[:transac_errors]
      flash[:transac_errors] = []
    end
  end

#set current user. Finds user with session[:id] in db
  def current_user
    if session[:lender_id]
      return Lender.find(session[:lender_id])
    end
    if session[:borrower_id]
      return Borrower.find(session[:borrower_id])
    end
  end

  helper_method :current_user
end
