class SessionsController < ApplicationController
  # before_filter :redirect_to_cat_index_if_signed_in

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(username: params[:user][:user_name],
              unencrypted_password: params[:user][:password])
    if @user.nil?
      flash[:errors] << @user.errors.full_messages
      render:new
    else
      login_user!
      redirect_to cats_url
    end
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
