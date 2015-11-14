class MoviesController < ApplicationController

  attr_accessor :styles
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by_column)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @styles = { 'title_header' => '', 'release_date_header' => '' }
    if params[:sort_by_column].nil?
        @movies = Movie.all
    elsif params[:sort_by_column] == 'title'
      @movies = Movie.order('title asc')
      @styles['title_header'] = 'hilite'
      @styles['release_date_header'] = ''
      flash[:notice] = "Sort by Title"
    elsif params[:sort_by_column] == 'release_date'
      @movies = Movie.order('release_date asc')
      @styles['release_date_header'] = 'hilite'
      @styles['title_header'] = ''
      flash[:notice] = "Sort by Release Date"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
