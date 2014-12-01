class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @DB_TITLE = 'title'
    @DB_RELEASE_DATE = 'release_date'

    @sortStr = ""
    if session[:sort] != nil and params[:sort] == nil
      @sortStr = "need to refresh SORT (#{session[:sort]})"
    end

    @all_ratings = Movie.all_ratings

    if params[:sort] == @DB_TITLE || params[:sort] == @DB_RELEASE_DATE
      @sortBy = params[:sort] # || 'title'
      session[:sort] = params[:sort]
    end
    
    sortOrder = @sortBy || @DB_TITLE
    sortOrderStr = sortOrder + " asc"

    if session["first"] == nil
      session["first"] = 0
      ratings = @all_ratings # check all ratings boxes on first page visit
    else
      ratings = params[:ratings].keys if params[:ratings] != nil
    end
    @ratingSel = ratings || []
    if ratings
      @movies = Movie.find(:all, :order => sortOrderStr , :conditions => {:rating => ratings })
    else
      @movies = Movie.find(:all, :order => sortOrderStr)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
