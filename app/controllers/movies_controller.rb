class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def ratings_str
    @ratingsStr = ""
    if session[:ratings] != nil
      session[:ratings].each do |r,v|
        @ratingsStr += "&" if @ratingsStr != ""
        @ratingsStr += "ratings[#{r}]=1"
      end
    else
      @all_ratings.each do |r|
        @ratingsStr += "&" if @ratingsStr != ""
        @ratingsStr += "ratings[#{r}]=1"
      end
    end
    @ratingsStr
  end

  def index
    @DB_TITLE = 'title'
    @DB_RELEASE_DATE = 'release_date'
    @all_ratings = Movie.all_ratings

    doRedirect = false

    if params[:sort] == nil
      doRedirect = session[:sort] != nil 
    else
      session[:sort] = params[:sort]
    end
  
    if params[:ratings] == nil
      doRedirect = true
    else
      session[:ratings] = params[:ratings]
    end

    if doRedirect
      str  = "#{movies_path}?#{ratings_str()}"
      str += "&sort=#{session[:sort]}" if session[:sort] != nil
      flash.keep
      redirect_to str 
    end


    if params[:sort] == @DB_TITLE || params[:sort] == @DB_RELEASE_DATE
      @sortBy = params[:sort]
    end
    sortOrder = @sortBy || @DB_TITLE
    sortOrderStr = sortOrder + " asc"

    ratings = params[:ratings].keys if params[:ratings] != nil
    @ratingSel = ratings || []
    if ratings
      @movies = Movie.find(:all, :order => sortOrderStr , :conditions => {:rating => ratings })
    else # should never get here!
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
