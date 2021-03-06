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
    
    # Redirect if new params (sort or filters)
    #(change session to new params)
    if (params[:ratings] and (params[:ratings] != session[:ratings]))
      if (params[:ratings]) 
        session[:ratings] = params[:ratings]
      end
      
      flash.keep
      redirect_to movies_path(ratings: params[:ratings])
    end
    
    if (params[:sortBy] and (params[:sortBy] != session[:sortBy]))
      if (params[:sortBy])
        session[:sortBy] = params[:sortBy]
      end
      
      flash.keep
      redirect_to movies_path(sortBy: params[:sortBy])
    end
    
    # Filter based on ratings
    if session[:ratings]
      @movies = Movie.where(rating: session[:ratings].keys)
      
      session[:ratings].keys.each do |rating|
        @ratingChecked[rating] = true
      end
    else
      @movies = Movie.all
      @all_ratings.each do |rating|
        @ratingChecked[rating] = true
      end
    end
    
    #Sort by title or date
    if session[:sortBy] == "title"
      @movies = @movies.order(:title)
      @titleHighlight = "hilite"
    elsif session[:sortBy] == "date"
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
