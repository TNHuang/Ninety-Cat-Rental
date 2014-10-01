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

  # def edit
  #   @cat = Cat.find(params[:id])
  #
  #   render :edit
  # end
  #
  # def update
  #   @cat = Cat.find(params[:id])
  #
  #   if @cat.update(cat_params)
  #
  #     redirect_to cat_url(@cat)
  #   else
  #     flash[:errors] = @cat.errors.full_messages
  #
  #     render :edit
  #   end
  # end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
