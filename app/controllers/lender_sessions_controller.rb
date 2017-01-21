class LenderSessionsController < ApplicationController
  def index
  end

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

  def destroy
    session[:lender_id] = nil
    redirect_to "/"
  end

end
