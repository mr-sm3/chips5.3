class Movie < ActiveRecord::Base
  
  #gets keys from the hash if not empty
  def self.filtered_ratings(hash)
    if hash == nil
      return []
    else
      return hash.keys
    end
  end
  
  #returns a list of all ratings
  def self.all_ratings()
    return ["G", "PG", "PG-13", "R"]
  end
  
  #returns a list of movies with given ratings_list
  def self.with_ratings(ratings_list)
    if ratings_list == nil
      return Movie.all
    else
      return Movie.where(rating: ratings_list)
    end
  end
  
  #returns a list of movies with given ratings ordered by title
  def self.sort_by_movie(ratings_list)
    return Movie.where(rating: ratings_list).order(title: :asc)
  end
    
  #returns a list of movies with given ratings ordered by date
  def self.sort_by_date(ratings_list)
    return Movie.where(rating: ratings_list).order(release_date: :asc)
  end
end
