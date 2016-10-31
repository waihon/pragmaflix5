require "rails_helper"

describe "Viewing an individual movie" do
  it "shows the movie's details" do
    # Arrange
    movie = Movie.create(movies_attributes(total_gross: 300_000_000.00))

    # Act
    #visit movie_url(movie)
    visit "http://example.com/movies/#{movie.id}"

    # Assert
    expect(page).to have_text(movie.title)
    expect(page).to have_text(movie.rating)
    expect(page).to have_text("$300,000,000.00")
    expect(page).to have_text(movie.description)
    expect(page).to have_text(movie.released_on)
  end
end
