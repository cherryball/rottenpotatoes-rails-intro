class MoviesController < ApplicationController

  attr_reader :hilite_column
  attr_accessor :ratings

  def initialize
    @all_ratings = Movie.all_ratings;
    @ratings = Hash.new
    @all_ratings.each { |r| @ratings[r] = 1 }
    super
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by_column, :ratings)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @hilite_column = ''
    filter_by_ratings = params[:ratings].nil? ? '' : params[:ratings].keys
    @ratings = params[:ratings] unless params.nil? || params[:ratings].nil?
    @movies = filter_by_ratings.nil?  || filter_by_ratings.empty? ? Movie.all : Movie.where( 'rating'=> filter_by_ratings )
    if params[:sort_by_column] == 'title'
      @movies = Movie.order('title asc')
      @hilite_column = 'title_header'
      flash[:notice] = "Sort by Title"
    elsif params[:sort_by_column] == 'release_date'
      @movies = Movie.order('release_date asc')
      @hilite_column = 'release_date_header'
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
  
  def all_ratings
    @all_ratings
  end

end
