require "rails_helper"

describe "Navigating movies" do
  it "allows navigation from the detail page to the listing page" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Act
    visit movie_url(movie)

    click_link "All Movies"

    # Assert
    expect(current_path).to eq(movies_path)
  end

  it "allows navigation from the listing page to the detail page" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Act
    visit movies_url

    click_link movie.title

    # Assert
    expect(current_path).to eq(movie_path(movie))

  end
end
