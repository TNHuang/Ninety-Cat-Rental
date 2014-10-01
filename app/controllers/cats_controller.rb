class CatsController < ApplicationController

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_attrs = [:birth_date, :color, :sex, :description]

    # @rental_requests = CatRentalRequest.select(:start_date, :end_date)
    #                                    .order(:start_date)
    #                                    .where("cat_id = ?", @cat.id)

    # @cat.cat_rental_requests.select(:start_date, :end_date).order(:start_date)

    render :show
  end

  def new
    @cat = Cat.new

    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat.errors.full_messages
      # render @cat.errors.full_messages, status: :unprocessable_entity
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])

    render :edit
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)

      redirect_to cat_url(@cat)
    else
      flash[:errors] = @cat.errors.full_messages

      render :edit
    end
  end


  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :sex, :color, :description)
  end
end
