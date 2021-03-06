class PhotosController < ApplicationController
  before_action :authenticate_user!

  def create
    @photo = Photo.new
    @photo.user = current_user
    @photo.image = params[:file]
    if @photo.image.blank?
      render json: { ok: false }, status: 400 and return
    end
    
    if @photo.save
      render json: { ok: true, url: @photo.image.url }
    else
      render json: { ok: false }
    end
  end
end
