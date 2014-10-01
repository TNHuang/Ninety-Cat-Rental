class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  #helper methods allow view to call these functions

  def current_user
    return nil if self.session[:session_token].nil?
    @current_user ||= User.find_by_session_token(self.session[:session_token])
  end

  def signed_in?
    !!current_user
  end

  def log_out!
    @user = current_user
    session[:session_token] = nil
    @user.reset_session_token!
  end

  def login_user!
    @user = current_user
    @user.reset_session_token!
    self.session[:session_token] = @user.session_token
  end

  #redirect to cat index when user already log in?
  def redirect_to_cat_index_if_signed_in
    redirect_to cats_url if signed_in?
  end
end
