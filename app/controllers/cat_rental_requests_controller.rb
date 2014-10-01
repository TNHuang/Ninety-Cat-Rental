class CatRentalRequestsController < ApplicationController
  before_filter :is_owner?, only: [:approve, :deny, :pending_all]

  def new
    @cat_rental_request = CatRentalRequest.new(:cat_id => params[:cat_id])
    @cats = Cat.all
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      @cat = Cat.find(cat_rental_request_params[:cat_id])
      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat_rental_request.errors.full_messages
      # render @cat.errors.full_messages, status: :unprocessable_entity
      @cats = Cat.all
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @current_cat = @cat_rental_request.cat

    unless @cat_rental_request.approve!
      flash[:errors] = "Cannot approved overlapping request"
    end

     redirect_to cat_url(@current_cat)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!

    @current_cat = @cat_rental_request.cat
    redirect_to cat_url(@current_cat)
  end

  def pending_all
    # @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat = Cat.find(params[:cat_id])
    @cat.cat_rental_requests.each do |req|
      req.update(status: "PENDING")
    end

    redirect_to cat_url(@cat)
  end


  def is_owner?
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat = @cat_rental_request.cat
    if @cat.user_id != current_user.id
      flash[:errors] = "sorry not your cat :<"
      redirect_to cat_url(@cat)
    end
  end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
