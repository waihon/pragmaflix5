require "rails_helper"

describe "Editing a movie" do

  it "updates the movie and shows the movie's updated details" do
    # Arrange
    movie = Movie.create(movie_attributes)

    # Act
    visit movie_url(movie)

    click_link "Edit"

    # Assert
    expect(current_path).to eq(edit_movie_path(movie))

    expect(find_field("Title").value).to eq(movie.title)
  end
end
