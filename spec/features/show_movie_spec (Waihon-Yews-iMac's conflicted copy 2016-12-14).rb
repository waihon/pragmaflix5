require "rails_helper"

describe "Viewing an individual movie" do
  it "shows the movie's details" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Act
    visit movie_url(movie)

    # Assert
    expect(page).to have_text(movie.title)
    expect(page).to have_text(movie.rating)
    expect(page).to have_text(movie.description)
    expect(page).to have_text(movie.released_on)
    expect(page).to have_text(movie.cast)
    expect(page).to have_text(movie.director)
    expect(page).to have_text(movie.duration)
    expect(page).to have_selector("img[src$='#{movie.image_file_name}']")
  end

  it "shows the total gross if the total gross exceeds $50M" do
    # Arrange
    movie = Movie.create(movie_attributes(total_gross: 50_000_000.00))

    # Act
    visit movie_url(movie)

    # Assert
    expect(page).to have_text("$50,000,000.00")
  end

  it "shows 'Flop!' if the total gross is less than $50M" do
    # Arrange
    movie = Movie.create(movie_attributes(total_gross: 49_999_999.99))

    # Act
    visit movie_url(movie)

    # Assert
    expect(page).to have_text("Flop!")
  end

  it "shows the number of reviews posted" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes(stars: 1))
    movie.reviews.create(review_attributes(stars: 3))
    movie.reviews.create(review_attributes(stars: 5))

    visit movie_url(movie)

    expect(page).to have_text("3 reviews")
  end

  it "shows the average number of stars if the movie have one or more reviews" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes(stars:1))
    movie.reviews.create(review_attributes(stars:3))
    movie.reviews.create(review_attributes(stars:5))

    visit movie_url(movie)

    expect(page).to have_text("3.0 stars")
  end

  it "shows 'No reviews' if the movie doesn't have any reviwes" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    expect(page).to have_text("No reviews")
  end
end
