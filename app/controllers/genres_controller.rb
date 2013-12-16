class GenresController < ApplicationController
  before_action :authenticate

  def index
    authorize! :read, Genre
    @genres = Genre.all
  end

  def show
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new genre_params
    respond_with @genre
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def genre_params
    params.require(:genre).permit(:title, :description)
  end
end
