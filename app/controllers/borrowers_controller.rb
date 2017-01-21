class BorrowersController < ApplicationController
  before_action :require_login, only: [:show]
  before_action :require_correct_user, only: [:show]

  def create
    @borrower = Borrower.new(borrower_params)
    # binding.pry
    if !@borrower.valid?
      initialize_flash
      flash[:borrower_reg_errors] << @borrower.errors.full_messages
      # binding.pry
      redirect_to "/"
    else
      @borrower.save
      session[:borrower_id] = @borrower.id
      # binding.pry
      redirect_to "/online_lending/borrower/#{@borrower.id}"
    end
  end

  def show
    # binding.pry
    @borrower = Borrower.find(params[:id])
  end

  private
  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :purpose, :description, :money)
  end
end
