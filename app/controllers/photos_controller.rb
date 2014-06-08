class PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_photo, only: [:destroy, :show, :edit]
  before_action :set_user,  only: [:destroy, :edit, :create]

  def index
    limit     = params[:limit]     || 10
    from      = params[:from]      || nil
    direction = params[:direction] || nil
    @photos   = Photo.find_flex(from, direction, limit)
    @status   = {code: 200, msg: 'OK'}
  end

  def edit
    unless user_signed_in? || @photo.nil? || @photo.owner?(current_user)
      return show_500
    end
  end

  def destroy
    unless @photo.nil? || @photo.owner?(@user)
      return show_500
    else
      @photo.destroy
      set_status(210)
    end
    respond_to do |format|
      format.html { redirect_to root_path, notice: @status[:msg] }
      format.json { render 'status', type: :jbuilder }
    end
  end

  def new
    @photo = Photo.new
  end

  def show
    render layout: false if params[:ajax] || request.xhr?
  rescue ActiveRecord::RecordNotFound
    show_404
  end

  def create
    if params[:token].blank? || params[:photo].blank?
      set_status(500)
    else
      # check user via token
      if @user.nil?
        set_status(404)
      else
        # upload
        @photo = Photo.new(photo_params)
        @user.photos << @photo
        set_status(200)
        session[:user_id] = @user.id # keep session for html version
      end
    end
    respond_to do |format|
      format.html {
        if @user.nil? || @photo.nil?
          redirect_to new_photo_path, alert: @status[:msg]
        else
          redirect_to new_photo_path, notice: @status[:msg]
        end
      }
      format.json { render 'create', type: :jbuilder }
    end
  end

  def upload
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def select; end

  private

  def photo_params
    {comment: params[:comment], image: params[:photo], latitude: params[:latitude], longitude: params[:longitude]}
    # @todo: parse hash-tags in comments
  end

  def set_photo
    @photo = Photo.find(params[:id])
  end

end
