class MoviesController < ApplicationController

  def show
    #session[:filter] = params[:filter]
    #session[:ratings] = params[:ratings]
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    #redirect_to movies_path({:filter => session[:filter], :ratings => session[:ratings]}) if (params[:filter].blank? && session[:filter].present?) || (params[:ratings].blank? && session[:ratings].present?) 
    
    #temp = session[:params]

    #redirect_to movies_path({:filter => temp[:filter], :ratings => temp[:ratings]}) if (params[:filter].blank? && temp[:filter].present?) || (params[:ratings].blank? && temp[:ratings].present?)

    #params[:filter] = temp[:filter] if params[:filter].nil?
    #params[:ratings] = temp[:ratings] if params[:ratings].nil?

    #session[:params] = {:filter => params[:filter], :ratings => params[:ratings]}
    #params = session[:params]
    if (params[:filter].blank? && session[:filter].present?) && (params[:ratings].blank? && session[:ratings].present?)
      redirect_to movies_path(:filter => session[:filter], :ratings => session[:ratings])
    end
    
    params[:filter] = session[:filter] if params[:filter].nil?
    params[:ratings] = session[:ratings] if params[:ratings].nil?
    
    session[:filter] = params[:filter]
    session[:ratings] = params[:ratings]
    @all_ratings = Movie.all_ratings()
    @ratings_to_show = Movie.filtered_ratings(params[:ratings])
    if @ratings_to_show != []
      new_ratings = @ratings_to_show
    else
      new_ratings = @all_ratings
    end
    @sort = params[:filter]
    if @sort == "movie_filter"
      @movies = Movie.sort_by_movie(new_ratings)
    elsif @sort == "date_filter"
      @movies = Movie.sort_by_date(new_ratings)
    else
      @movies = Movie.with_ratings(new_ratings)
    end  
    
#     if @ratings_to_show != []
#       @movies = Movie.with_ratings(@ratings_to_show)
#     else
#       @movies = Movie.with_ratings(@all_ratings)
#     end
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
