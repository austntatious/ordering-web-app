class AccountTransactionsController < ApplicationController
  def index
    @account_transactions = current_user.account_transactions.reorder('created_at DESC').page(params[:page]).per(10)
  end
end
