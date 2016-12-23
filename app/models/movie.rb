class Movie < ApplicationRecord
  HIT = 300_000_000
  FLOP = 50_000_000

  has_many :reviews, dependent: :destroy

  has_attached_file :image, styles: {
    small: "90x133>",
    thumb: "50x50>"
  }

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  # Validates that the actual content type of the image file, regardless of
  # the file name extension, is a JPEG or PNG file.
  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { less_than: 1.megabyte }

  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS }

  def self.released
    where("released_on <= ?", Time.now).order(released_on: :desc)
  end

  def self.hits
    where("total_gross >= ?", HIT).order(total_gross: :desc)
  end

  def self.flops
    #where("total_gross < ?", FLOP).order(total_gross: :asc).merge(not_cults)
    where("total_gross < ?", FLOP).merge(not_cults).order(total_gross: :asc)
  end

  def self.cults
    joins(:reviews).group("movies.id").having("count(movie_id) > 50").having("avg(stars) >= 4.0")
  end

  def self.not_cults
    where.not(id: cults)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end

  def flop?
    (total_gross.blank? || total_gross < FLOP) && !cult?
  end

  def average_stars
    reviews.average(:stars)
  end

  def recent_reviews
    reviews.order("created_at desc").limit(2)
  end

  def cult?
    reviews.count > 50 && average_stars >= 4.0
  end
end
