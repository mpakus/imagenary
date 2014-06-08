class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_access_headers

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

  private

  ERR_CODES = {
      200 => 'Photo uploaded',
      210 => 'Photo deleted',
      220 => 'Photo updated',
      404 => 'Error, wrong user token',
      500 => 'Error, empty token or file'
  }

  def set_status(code)
    @status = {code: code, msg: ERR_CODES[code], type: :error}
  end

  def set_user
    if params[:token]
      @user = User.where(token: params[:token]).first
    else
      @user = current_user
    end
  end

  ##
  # Set CORS headers it gives everyone access to everything
  def set_access_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

end
