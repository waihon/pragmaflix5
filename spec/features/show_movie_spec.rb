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
end
