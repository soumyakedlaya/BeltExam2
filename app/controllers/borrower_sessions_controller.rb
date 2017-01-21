class BorrowerSessionsController < ApplicationController

  def index
  end
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

  def destroy
    # binding.pry
    session[:borrower_id] = nil
    # binding.pry
    redirect_to "/"
  end

end
