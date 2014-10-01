class UsersController < ApplicationController
  before_filter :redirect_to_cat_index_if_signed_in

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] << @user.errors.full_messages
      render :new
    end
  end


  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
