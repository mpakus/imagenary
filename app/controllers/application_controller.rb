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
end
