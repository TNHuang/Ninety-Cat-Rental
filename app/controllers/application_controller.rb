class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  # before_filter :validate_csrf_token

  helper_method :current_user, :signed_in?, :my_csrf_token
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

  def login!(user)
    # @user = current_user
    user.reset_session_token!
    self.session[:session_token] = user.session_token
  end

  #redirect to cat index when user already log in?
  def redirect_to_cat_index_if_signed_in
    redirect_to cats_url if signed_in?
  end

  def redirect_to_login_if_not_signed_in
    redirect_to new_session_url unless signed_in?
  end

  # CSRF
  # def my_csrf_token
 #    self.session[:_my_csrf_token] ||= SecureRandom::urlsafe_base64
 #  end

  # def validate_csrf_token
 #    return if self.request.method == "GET"
 #    return if self.session[:_my_csrf_token] == self.params[:_my_csrf_token]
 #    raise "CSRF ATTACK!!!"
 #  end

end
