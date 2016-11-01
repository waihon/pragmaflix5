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
end
