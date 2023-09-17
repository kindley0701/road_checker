class Public::CustomersController < ApplicationController
  def show
    @customer = Customer.find(params[:id])
    @diaries = @customer.drive_diaries
  end
end
