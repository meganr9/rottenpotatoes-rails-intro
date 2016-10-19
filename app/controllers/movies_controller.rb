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
    if params["ratings"] or session["ratings"]
      if (params["ratings"]) 
        session["ratings"] = params["ratings"]
      end
      
      @movies = Movie.where(rating: session["ratings"].keys)
      
      session["ratings"].keys.each do |rating|
        @ratingChecked[rating] = true
      end
      
    else
      @movies = Movie.all
      @all_ratings.each do |rating|
        @ratingChecked[rating] = true
      end
    end
    
    if params[:sortBy] == "title" or session[:sortBy] == "title"
      @movies = @movies.order(:title)
      @titleHighlight = "hilite"
      session[:sortBy] = "title"
    elsif params[:sortBy] == "date" or session[:sortBy] == "date"
      @movies = @movies.order(:release_date)
      @dateHighlight = "hilite"
      session[:sortBy] = "date"
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
