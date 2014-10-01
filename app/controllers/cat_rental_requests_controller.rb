class CatRentalRequestsController < ApplicationController

  #
  # def index
  #   @cats = Cat.all
  #
  #   render :index
  # end
  #
  # def show
  #   @cat = Cat.find(params[:id])
  #   @cat_attrs = [:birth_date, :color, :sex, :description]
  #   render :show
  # end

  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat = Cat.find(cat_rental_request_params[:cat_id])
    if @cat_rental_request.save
      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat_rental_request.errors.full_messages
      # render @cat.errors.full_messages, status: :unprocessable_entity
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve!
    @current_cat = @cat_rental_request.cat
    redirect_to cat_url(@current_cat)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny!

    @current_cat = @cat_rental_request.cat
    redirect_to cat_url(@current_cat)
  end

  def pending_all
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat = @cat_rental_request.cat
    @cat.cat_rental_requests.each do |req|
      req.update(status: "PENDING")
    end

    redirect_to cat_url(@cat)
  end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
