require "rails_helper"

describe "Creating a new review" do
  it "saves the review" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    click_link "Write Review"

    expect(current_path).to eq(new_movie_review_path(movie))

    fill_in "Name", with: "Roger Ebert"
    choose "review_stars_3"

    fill_in "Comment", with: "I laughed, I cried, I spilled my popcorn!"

    click_button "Post Review"

    expect(current_path).to eq(movie_reviews_path(movie))

    expect(page).to have_text("Thanks for your review!")
  end

  it "does not save the review if it's invalid" do
    movie = Movie.create(movie_attributes)

    visit new_movie_review_url(movie)

    expect {
      click_button "Post Review"
    }.not_to change(Review, :count)

    expect(page).to have_text("error")
  end

  it "allows cancellation" do
    movie = Movie.create(movie_attributes)

    visit new_movie_review_url(movie)

    expect(page).to have_link("Cancel")

    click_link "Cancel"

    expect(current_path).to eq(movie_path(movie))
  end
end

describe "Creating a new review from a movie show page" do
  it "saves the review" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    fill_in "Name", with: "Roger Ebert"
    choose "review_stars_3"
    fill_in "Comment", with: "I laughed, I cried, I spilled my popcorn!"

    expect {
      click_button "Post Review"
    }.to change(Review, :count).by(1)

    expect(current_path).to eq(create_review_movie_path(movie))

    expect(page).to have_text("Thanks for your review!")
  end

  it "does not save the review if it's invalid" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    expect {
      click_button "Post Review"
    }.not_to change(Review, :count)

    expect(page).to have_text("error")
  end

  it "does not allow canncellation" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)

    expect(page).not_to have_link("Cancel")
  end
end
