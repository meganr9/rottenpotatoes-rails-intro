class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.getRatings()
    @ratingChecked = Hash.new
    if params["ratings"]
      @movies = Movie.where(rating: params["ratings"].keys)
      
      params["ratings"].keys.each do |rating|
        @ratingChecked[rating] = true
      end
    else
      @movies = Movie.all
      @all_ratings.each do |rating|
        @ratingChecked[rating] = true
      end
    end
    
    if params[:sortBy] == "title"
      @movies = @movies.order(:title)
      @titleHighlight = "hilite"
    elsif params[:sortBy] == "date"
      @movies = @movies.order(:release_date)
      @dateHighlight = "hilite"
      
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
