class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  def index 
    @artists = Artist.all 
    render json: @artists
  end 

  def show 
    render json: @artist
  end 

  def create 
    @artist = Artist.create(artist_params)
    render json: @artist
  end 

  def update 
    @artist.update_attributes(artist_params)
    render json: @artist
  end 

  def destroy 
    @artist.destroy 
    render json: {message: "success"}
  end 

  private
  def artist_params 
    params.require(:artist).permit(:name, :genre)
  end 
  def set_artist 
    @artist = Artist.find(params[:id])
  end
end
