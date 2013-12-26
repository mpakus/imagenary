class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ##
  # Error pages show_403 show_404 etc...
  [404, 500].each do |num|
    define_method :"show_#{num}" do
      render file: "#{Rails.root}/public/404.html", status: 404, layout: false
    end
  end

  def user_logined?
    unless user_signed_in?
      redirect_to signin_users_path, notice: 'Please, sign in first'
      return false
    end
    true
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_signed_in?
    !current_user.nil?
  end
  helper_method :user_signed_in?

end
