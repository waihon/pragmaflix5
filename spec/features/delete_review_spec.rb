require "rails_helper"

describe "Deleting a review" do
  it "destroys the review and show the reviews listing" do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.create(review_attributes)

    visit movie_reviews_path(movie, review)
    click_link "Delete"

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).not_to have_text(review.name)
    expect(page).to have_text("Review successfully deleted!")
  end
end
