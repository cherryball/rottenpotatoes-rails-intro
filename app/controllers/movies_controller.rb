class MoviesController < ApplicationController

  attr_reader :hilite_column
  attr_accessor :ratings
  attr_accessor :msg

  def initialize
    @all_ratings = Movie.all_ratings;
    @ratings = init_ratings
    super
  end
  
  def init_ratings
      @ratings = Hash.new
      @all_ratings.each { |r| @ratings[r] = 1 }
      return @ratings
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
   # filter_by_ratings = params[:ratings].nil? ? session[:ratings] : params[:ratings].keys
    @ratings = params[:ratings].nil? || params[:ratings].empty? ? session[:ratings] : params[:ratings]
    @ratings = init_ratings if @ratings.nil? || @ratings.empty?

  #  @ratings = params[:ratings].nil?  ? session[:ratings] : params[:ratings]
  #  @movies = filter_by_ratings.nil?  || filter_by_ratings.empty? ? Movie.all : Movie.where( 'rating'=> filter_by_ratings )
  # @movies = @ratings.nil? || @ratings.empty? ? Movie.all : Movie.where( 'rating'=> @ratings.keys )
    sort_by_column = params[:sort_by_column].nil? || params[:sort_by_column].empty? ? session[:sort_by_column] : params[:sort_by_column]
    if 'title' == sort_by_column
      @movies = @ratings.nil? || @ratings.empty? ? Movie.all.order('title asc') : Movie.where( 'rating'=> @ratings.keys ).order('title asc')
      @hilite_column = 'title_header'
      flash[:notice] = "Sort by Title S:#{session[:ratings]} R:#{@ratings} SC:#{session[:sort_by_column]} -p: #{params[:sort_by_column]}"
    elsif 'release_date' == sort_by_column
      @movies = @ratings.nil? || @ratings.empty? ? Movie.all.order('release_date asc') : Movie.where( 'rating'=> @ratings.keys ).order('release_date asc')
      @hilite_column = 'release_date_header'
      flash[:notice] = "Sort by Release Date"
    else
      @movies = @ratings.nil? || @ratings.empty? ? Movie.all : Movie.where( 'rating'=> @ratings.keys )
    end
    session[:sort_by_column] = params[:sort_by_column] unless params[:sort_by_column].nil?
    session[:ratings] = @ratings
    @msg = "ratings param = #{params[:ratings]} session ratings: #{session[:ratings]} Using rating: #{@ratings} param sort #{params[:sort_by_column]} session sort #{sort_by_column}"
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
