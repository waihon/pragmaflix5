class Movie < ApplicationRecord
  def flop?
    total_gross.blank? || total_gross < 50_000_000.00
  end
end
