require "rails_helper"

describe "A movie" do
  it "is a flop if the total gross is less than $50M and it's not a cult classic" do
    # Arrange
    movie = Movie.new(total_gross: 49_999_999.99)

    # Assert
    expect(movie.flop?).to eq(true)
  end

  it "is a flop if the total gross is blank and it's not a cult classic" do
    # Arrange
    movie = Movie.new

    # Assert
    expect(movie.flop?).to eq(true)
  end

  it "is not a flop if the total gross exceeds $50M" do
    # Arrange
    movie = Movie.new(total_gross: 50_000_000.00)

    # Assert
    expect(movie.flop?).to eq(false)
  end

  it "is not a flop if it is a cult classic even though its total gross is less $50M" do
    # Arrange
    movie = Movie.create(movie_attributes(total_gross: 49_999_999.99))

    51.times do
      movie.reviews.create(review_attributes(stars: 4))
    end

    # Assert
    expect(movie.flop?).to eq(false)
  end

  it "has a custom query that returns movies released in the past and not movies released in the future" do
    # Arrange
    movie1 = Movie.create(movie_attributes(released_on: 1.day.ago))
    movie2 = Movie.create(movie_attributes(released_on: 1.day.from_now))

    # Assert
    expect(Movie.released).to include(movie1)
    expect(Movie.released).not_to include(movie2)
  end

  it "has a custom query that return released movies ordered with the most recently-released movie first" do
    # Arrange
    movie1 = Movie.create(movie_attributes(released_on: 1.year.ago))
    movie2 = Movie.create(movie_attributes(released_on: 1.month.ago))
    movie3 = Movie.create(movie_attributes(released_on: 1.week.ago))
    movie4 = Movie.create(movie_attributes(released_on: 1.day.ago))

    # Assert
    expect(Movie.released).to eq([movie4, movie3, movie2, movie1])
  end

  it "is released when the released on date is in the past" do
    movie = Movie.create(movie_attributes(released_on: 3.months.ago))

    expect(Movie.released).to include(movie)
  end

  it "is not released when the released on date is in the future" do
    movie = Movie.create(movie_attributes(released_on: 3.months.from_now))

    expect(Movie.released).not_to include(movie)
  end

  it "returns released movies order with the most recently-released movie first" do
    movie1 = Movie.create(movie_attributes(released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(released_on: 1.months.ago))

    expect(Movie.released).to eq([movie3, movie2, movie1])
  end

  it "requires a title" do
    movie = Movie.new(title: "")

    movie.valid?  # populate errors

    expect(movie.errors[:title].any?).to eq(true)
  end


  it "requires a description" do
    movie = Movie.new(description: "")

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it "requires a released on date" do
    movie = Movie.new(released_on: "")

    movie.valid?

    expect(movie.errors[:released_on].any?).to eq(true)
  end

  it "requires a duration" do
    movie = Movie.new(duration: "")

    movie.valid?

    expect(movie.errors[:duration].any?).to eq(true)
  end

  it "requires a description over 24 characters" do
    movie = Movie.new(description: "X" * 24)

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it "accepts a $0 total gross" do
    movie = Movie.new(total_gross: 0.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "accepts a positive total gross" do
    movie = Movie.new(total_gross: 10000000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it "rejects a negative total gross" do
    movie = Movie.new(total_gross: -10_000_000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(true)
  end

  it "accepts properly formatted image file names" do
    file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(false)
    end
  end

  it "rejects improperly formatted image file names" do
    file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(true)
    end
  end

  it "accepts any rating that is in an approved list" do
    ratings = %w[G PG PG-13 R NC-17]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(false)
    end
  end

  it "rejects any rating that is not in the approved list" do
    ratings = %w[R-13 R-16 R-18 R-21]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(true)
    end
  end

  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)

    expect(movie.valid?).to eq(true)
  end

  it "has many reviews" do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it "deletes associated reviews" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes)

    expect {
      movie.destroy
    }.to change(Review, :count).by(-1)
  end

  it "calculates the average number of review stars" do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes(stars: 1))
    movie.reviews.create(review_attributes(stars: 3))
    movie.reviews.create(review_attributes(stars: 5))

    expect(movie.average_stars).to eq(3)
  end

  it "is a cult classic if it has more than 50 reviews and the average review is 4 stars or better" do
    movie = Movie.create(movie_attributes)

    51.times do
      movie.reviews.create(review_attributes(stars: 4))
    end

    expect(movie.cult?).to eq(true)
  end

  it "is not a cult classic if it has 50 reviews or less even though the average reveiw is 4 stars or better" do
    movie = Movie.create(movie_attributes)

    50.times do
      movie.reviews.create(review_attributes(stars: 4))
    end

    expect(movie.cult?).to eq(false)
  end

  it "is not a cult classic if its average review is less than 4 stars even though it has more than 50 reviews" do
    movie = Movie.create(movie_attributes)

    50.times do
      movie.reviews.create(review_attributes(stars: 4))
    end
    movie.reviews.create(review_attributes(stars: 3))

    expect(movie.cult?).to eq(false)
  end

  it "returns cult classics with 51 or more reviews and their average review is 4 stars or better" do
    movie1 = Movie.create(movie_attributes(total_gross: 49_999_999))
    51.times do
      movie1.reviews.create(review_attributes(stars: 4))
    end

    movie2 = Movie.create(movie_attributes(total_gross: 49_999_999))
    50.times do
      movie2.reviews.create(review_attributes(stars: 4))
    end
    movie2.reviews.create(review_attributes(stars: 3))

    expect(Movie.cults).to include(movie1)
    expect(Movie.cults).not_to include(movie2)
  end

  it "return flop movies with total gross less than $50M and it's not a cult classic" do
    movie1 = Movie.create(movie_attributes(total_gross: 49_999_999))
    movie1.reviews.create(review_attributes(stars: 3))

    movie2 = Movie.create(movie_attributes(total_gross: 49_999_999))
    51.times do
      movie2.reviews.create(review_attributes(stars: 4))
    end

    expect(Movie.flops).to include(movie1)
    expect(Movie.flops).not_to include(movie2)
  end
end
