class CatsController < ApplicationController

  before_filter :redirect_to_login_if_not_signed_in

  before_filter :is_owner?, only: [:edit, :update]

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
    @cat.user_id = current_user.id

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

  def is_owner?
    @cat = Cat.find(params[:id])
    if @cat.user_id != current_user.id
      flash[:errors] = "sorry not your cat :<"
      redirect_to cats_url
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :sex, :color, :description)
  end
end
