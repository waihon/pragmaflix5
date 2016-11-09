require "rails_helper"

describe "Deleting a movie" do
  it "destroys the movie and how the movie listing without the deleted movie" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Act
    visit movie_path(movie)

    click_link "Delete"

    # Assert
    expect(current_path).to eq(movies_path)
    expect(page).not_to have_text(movie.title)
  end
end
