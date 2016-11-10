require "rails_helper"

describe "A movie" do
  it "is a flop if the total gross is less than $50M" do
    # Arrange
    movie = Movie.new(total_gross: 49_999_999.99)

    # Assert
    expect(movie.flop?).to eq(true)
  end

  it "is a flop if the total gross is blank" do
    # Arrange
    movie = Movie.new

    # Assert
    expect(movie.flop?).to eq(true)
  end

  it "is not a flop if the gotal gross exceeds $50M" do
    # Arrange
    movie = Movie.new(total_gross: 50_000_000.00)

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

  it "return released movies order with the most recently-released movie first" do
    movie1 = Movie.create(movie_attributes(released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(released_on: 1.months.ago))

    expect(Movie.released).to eq([movie3, movie2, movie1])
  end
end
