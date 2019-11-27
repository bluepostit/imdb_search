class MoviesController < ApplicationController
  def index
    if params.include?(:query)
      sql = " \
        movies.title @@ :query \
        OR movies.syllabus @@ :query \
        OR directors.first_name @@ :query \
        OR directors.last_name @@ :query \
        "
      @movies = Movie.joins(:director).where(sql, query: "%#{params[:query]}%")
    else
      @movies = Movie.all
    end
  end
end
