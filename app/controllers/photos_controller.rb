class PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    limit     = params[:limit] || 10
    from      = params[:from] || nil
    direction = params[:direction] || nil
    @photos   = Photo.find_flex(from, direction, limit)
    @status   = {code: 200, msg: 'OK'}
  end

  def show
    @photo = Photo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    show_404
  end

  def create
    if params[:token].blank? || params[:photo].blank?
      @status = {code: 500, msg: 'Error, empty token or file'}
    else
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
