class PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @photos = Photo.order('created_at DESC').all
  end

  def show
    @photo = Photo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def create
    unless params[:token].blank? && params[:photo].blank?
      # check user via token
      @user = User.where(token: params[:token]).first
      if @user.nil?
        @status = {code: 404, msg: 'Error, wrong user token'}
      else
        # upload
        @photo = Photo.new(photo_params)
        @user.photos << @photo
        @status = {code: 200, msg: 'Photo uploaded'}
        session[:user_id] = @user.id # keep session for html version
      end
    else
      @status = {code: 500, msg: 'Error, empty token or file'}
    end
    respond_to do |format|
      format.html {
        if @user.nil? || @photo.nil?
          return redirect_to upload_photos_path, alert: @status[:msg]
        else
          return redirect_to upload_photos_path, notice: @status[:msg]
        end
      }
      format.json { render 'create', type: :jbuilder }
    end
  end

  def upload
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  private

  def photo_params
    {comment: params[:comment], image: params[:photo], latitude: params[:latitude], longitude: params[:longitude]}
    # @todo: parse hash-tags in comments
  end

end
