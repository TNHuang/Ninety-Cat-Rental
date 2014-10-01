class SessionsController < ApplicationController
  before_filter :redirect_to_cat_index_if_signed_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name],
                                     params[:user][:password])
    if @user.nil?
      flash[:errors] = "Incorrect login or password!"
      @user = User.new(user_name: params[:user][:user_name])
      render :new
    else
      login!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
