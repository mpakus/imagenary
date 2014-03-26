class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def auth
    unless params[:email].blank? || params[:password].blank?
      @user = User.where(email: params[:email]).first
      if @user && @user.authenticated?(params[:password])
        session[:user_id] = @user.id
      else
        @user = nil
      end
    end
    respond_to do |format|
      format.html {
        if @user.nil?
          return redirect_to signin_users_path, alert: 'Error, wrong email or password.'
        else
          return redirect_to root_path, notice: 'Nice to see you again.'
        end
      }
      format.json { render 'auth', type: :jbuilder }
    end
  end

  def signup
    @user = User.new
  end

  def signin;end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to photos_path, notice: "Welcome to Imagenary"
    else
      render :signup
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Thank you, see you soon!'
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
