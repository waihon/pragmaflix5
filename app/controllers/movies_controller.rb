class MoviesController < ApplicationController
  def index
    @movies = Movie.released
  end

  def show
    @movie = Movie.find(params[:id])
    @review = @movie.reviews.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      flash[:notice] = "Movie successfully updated!"
      redirect_to @movie   # or movie_url(@movie)
    else
      render :edit
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new
    end
  end

  def create_review
    @movie = Movie.find(params[:id])
    @review = @movie.reviews.build(review_params)
    if @review.save
      flash[:notice] = "Thanks for your review!"
      @review = Review.new
    end
    render action: :show
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, alert: "Movie successfully deleted!"
  end

private

  def movie_params
    params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross,
      :cast, :director, :duration, :image)
  end

  def review_params
    params.require(:review).permit(:name, :stars, :comment)
  end
end
