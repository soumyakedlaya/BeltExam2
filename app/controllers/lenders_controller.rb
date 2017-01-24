class LendersController < ApplicationController
  before_action :require_login, except: [:create]
  before_action :require_correct_user, only: [:show, :transaction]

#create new lender in db
  def create
    @lender = Lender.new(lender_params)
    #if invalid, initialize flash errors, push specific errors to be displayed on page, redirect to root route
    if !@lender.valid?
      initialize_flash
      flash[:lender_reg_errors] << @lender.errors.full_messages
      redirect_to "/"

    #if user input for all fields in lender registration form are valid, save in db, redirect to user's page via routes
    else
      @lender.save
      session[:lender_id] = @lender.id
      # binding.pry
      redirect_to "/online_lending/lender/#{@lender.id}"
    end
  end

  #query db for various info needed to display on page
  def show
    #renders views/lenders/show.html.erb automatically
    @borrowers = Borrower.all
    @lender = current_user
    @displayloans = Lender.find(current_user.id).transactions
  end

# when lender user clicks lend on form, find the borrower's user id in db
#create entry in Transaction model with borrower_id, lender_id and $amount IF amount is less than lender's account balance
#if amount is greater than lender's acct balance, flash error message and do not save in db
  def transaction
    @borrower = Borrower.find(params[:borrower_id])
    amount = params[:moneyraised].to_i
    if amount <= current_user.money
      transaction = Transaction.create(lender: current_user, borrower:@borrower, amount: amount)
      if @borrower.moneyraised == nil
        # if borrower's money raised = 0, update amt of money raised in db with amt the lender lends, update amt of money needed
        updated_moneyraised_amt = amount
        updated_money_amt = @borrower.money - amount
        @borrower.update(moneyraised: updated_moneyraised_amt, money: updated_money_amt )
      else
        # if borrower has already raised money, update amt of money raised, update amt of money needed
        updated_moneyraised_amt = @borrower.moneyraised + amount
        updated_money_amt = @borrower.money - amount
        @borrower.update(moneyraised: updated_moneyraised_amt, money: updated_money_amt)
      end
      #update lender's accout balance
      updated_acctbal = current_user.money - amount
      current_user.update(money: updated_acctbal)
    elsif current_user.money == 0
      initialize_flash
      flash[:transac_errors] << "You can no longer lend money since your account balance is 0"
    else
      initialize_flash
      flash[:transac_errors] << "Not enough money in your account. Please select a lower amount"
    end
    redirect_to "/online_lending/lender/#{current_user.id}"
  end

  private
  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
  end
end
