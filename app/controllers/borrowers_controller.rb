class BorrowersController < ApplicationController
  before_action :require_login, only: [:show]
  before_action :require_correct_user, only: [:show]

  #create new lender in db
  def create
    @borrower = Borrower.new(borrower_params)
    #if invalid, initialize flash errors, push specific errors to be displayed on page, redirect to root route
    if !@borrower.valid?
      initialize_flash
      flash[:borrower_reg_errors] << @borrower.errors.full_messages
      # binding.pry
      redirect_to "/"

    #if user input for all fields in borrower registration form are valid, save in db, redirect to user's page via routes
    else
      @borrower.save
      session[:borrower_id] = @borrower.id
      # binding.pry
      redirect_to "/online_lending/borrower/#{@borrower.id}"
    end
  end

  #query db for various info needed to display on page
  def show
    #renders views/borrowers/show.html.erb automatically
    @borrower = Borrower.find(params[:id])
  end

  private
  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :purpose, :description, :money)
  end
end
