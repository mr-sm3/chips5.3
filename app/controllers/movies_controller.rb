class MoviesController < ApplicationController

  def show
    #session[:filter] = params[:filter]
    #session[:ratings] = params[:ratings]
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    
    # will render app/views/movies/show.<extension> by default
  end

  def index
    

    filter = params[:filter] || session[:filter]
    ratings = params[:ratings] || session[:ratings]
    
    @all_ratings = Movie.all_ratings()
    if ratings.blank?
      @ratings_to_show = Movie.filtered_ratings(Hash[@all_ratings.collect { | item| [ item, 1] } ])
    else
      @ratings_to_show = Movie.filtered_ratings(ratings)
    end
    
    if @ratings_to_show != []
      new_ratings = @ratings_to_show
    else
      new_ratings = @all_ratings
    end
    @sort = filter
    if @sort == "movie_filter"
      @movies = Movie.sort_by_movie(new_ratings)
    elsif @sort == "date_filter"
      @movies = Movie.sort_by_date(new_ratings)
    else
      @movies = Movie.with_ratings(new_ratings)
    end  
    
    if params[:filter] != session[:filter] or params[:ratings] != session[:ratings]
      session[:filter] = filter
      session[:ratings] = ratings
      redirect_to :filter => filter, :ratings => ratings and return
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
