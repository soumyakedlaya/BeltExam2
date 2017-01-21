class LendersController < ApplicationController
  before_action :require_login, except: [:create]
  before_action :require_correct_user, only: [:show, :transaction]

  def create
    @lender = Lender.new(lender_params)
    # binding.pry
    if !@lender.valid?
      initialize_flash
      flash[:lender_reg_errors] << @lender.errors.full_messages
      # binding.pry
      redirect_to "/"
    else
      @lender.save
      session[:lender_id] = @lender.id
      # binding.pry
      redirect_to "/online_lending/lender/#{@lender.id}"
    end
  end

  def show
    # binding.pry
    @borrowers = Borrower.all
    @lender = current_user
    @displayloans = Lender.find(current_user.id).transactions
  end

  def transaction
    @borrower = Borrower.find(params[:borrower_id])
    amount = params[:moneyraised].to_i
    if amount <= current_user.money
      transaction = Transaction.create(lender: current_user, borrower:@borrower, amount: amount)
      if @borrower.moneyraised == nil
        updated_moneyraised_amt = amount
        updated_money_amt = @borrower.money - amount
        @borrower.update(moneyraised: updated_moneyraised_amt, money: updated_money_amt )
      else
        updated_moneyraised_amt = @borrower.moneyraised + amount
        updated_money_amt = @borrower.money - amount
        @borrower.update(moneyraised: updated_moneyraised_amt, money: updated_money_amt)
      end
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
