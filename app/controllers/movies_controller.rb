class MoviesController < ApplicationController


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def update_ratings_in_session(ratings)
      session[:ratings].clear unless session[:ratings] == nil
      ratings.each do |r|
        session[:ratings][r] = "1"
      end
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
@paramStr = ""
#=begin
@paramStr = params[:ratings]
    doRedirect = false

    if params[:sort] == nil
      doRedirect = session[:sort] != nil 
        #@sortStr = "sort=#{session[:sort]}"
    else
      session[:sort] = params[:sort]
    end
  
    if params[:ratings] == nil
      doRedirect = true
=begin
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
=end
    else
      session[:ratings] = params[:ratings]
    end

    if doRedirect #@sortStr or @ratingsStr
      @filterStr  = "#{movies_path}?#{ratings_str()}"
      @filterStr += "&sort=#{session[:sort]}" if session[:sort] != nil
      redirect_to @filterStr 
    end
#=end
    @movies = Movie.all
@ratingSel = []

      if params[:sort] == @DB_TITLE || params[:sort] == @DB_RELEASE_DATE
        @sortBy = params[:sort]
      end
      sortOrder = @sortBy || @DB_TITLE
      sortOrderStr = sortOrder + " asc"

      ratings = params[:ratings].keys if params[:ratings] != nil
      @ratingSel = ratings || []
      if ratings
        @movies = Movie.find(:all, :order => sortOrderStr , :conditions => {:rating => ratings })
      else
        @movies = Movie.find(:all, :order => sortOrderStr)
      end

=begin
    if session[:ratings] == nil
      session[:ratings] = Hash.new
      @all_ratings.each do |r|
        session[:ratings][r] = "1"
      end
      @filterStr = "new filter: #{session[:ratings]}"
      redirect_to '/movies?ratings[R]=1&ratings[PG-13]=1'
      #redirect_to movie_path + '?sort=title'#, session[:ratings]
      #@filterStr = movie_path
    else

      if session[:ratings] != nil and (params[:ratings] == nil or params[:ratings].keys == nil)
        #@filterStr = "#{session[:ratings]}"

      end

      if @sortStr or @filterStr
        @sortStr = "redirect ?#{@sortStr}&#{@filterStr}"
      end

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
        session[:ratings] = params[:ratings]
      else
        @movies = Movie.find(:all, :order => sortOrderStr)
      end
    end # session[:ratings] == nil
      #@filterStr = movies_path + "#{params[:ratings]}"
      @filterStr = ">>#{params[:sort]}<<"
=end
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
