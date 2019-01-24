class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]
  
  def index 
    if params[:artist_id]
      @albums = Artist.find(params[:artist_id]).albums
    else 
      @albums = Album.all
    end
    render json: @albums
  end 

  def show 
    render json: @album
  end 
  def create 
    @album = Album.create(album_params)
    render json: @album
  end 
  def update 
    @album.update_attributes(album_params)
    render json: @album 
  end 
  def destroy 
    @album.destroy 
    render json: {message: "Success"}
  end 

  private 
  def set_album 
    @album = Album.find(params[:id])
  end 
  def album_params 
    params.require(:album).permit(:name, :release_year, :artist_id)
  end
end
