class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    # binding.pry
    if session[:lender_id]
      # binding.pry
      redirect_to '/' if session[:lender_id] == nil
    end
    if session[:borrower_id]
      # binding.pry
      redirect to '/' if session[:borrower_id] == nil
    end
  end

  def require_correct_user
    # binding.pry
    if session[:lender_id]
      user = Lender.find(session[:lender_id])
    end
    if session[:borrower_id]
      user =  Borrower.find(session[:borrower_id])
      # binding.pry
    end
    # binding.pry
    redirect_to "/" if current_user != user || current_user == nil
  end

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
    # if !flash[:duplicate_errors]
    #   flash[:duplicate_errors] = []
    # end
    if !flash[:transac_errors]
      flash[:transac_errors] = []
    end
  end

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
