module MoviesHelper
  def format_total_gross(movie)
    if movie.flop?
      content_tag(:strong, "Flop!")
    else
      number_to_currency(movie.total_gross)
    end
  end

  def image_for(movie)
    if movie.image_file_name.blank?
      image_tag("placeholder.png", height: 150)
    else
      image_tag(movie.image_file_name, height: 150)
    end
  end

  def format_average_stars(movie)
    if movie.average_stars.nil?
      content_tag(:strong, "No reviews")
    else
      #pluralize(number_with_precision(movie.average_stars, precision: 1), "star")
      # Round to nearsest, e.g. 3.49 => 3, 3.50 => 4
      "*" * movie.average_stars.round
    end
  end
end
