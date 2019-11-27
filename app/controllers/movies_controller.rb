class MoviesController < ApplicationController
  def index
    if params.include?(:query)
      @movies = search_movies
    else
      @movies = Movie.all
    end
  end

  private

  def search_movies
    query = params[:query]

    # 1. ActiveRecord: Postgre fulltext search
    sql = " \
      movies.title @@ :query \
      OR movies.syllabus @@ :query \
      OR directors.first_name @@ :query \
      OR directors.last_name @@ :query \
      "
    Movie.joins(:director).where(sql, query: "%#{query}%")

    # 2a. pg_search: scope
    # Movie.search_by_title_and_syllabus(query)

    # 2b. pg_search: multisearch
    # CAUTION: results will not all be Movie objects!
    # View file must take this into account...
    # PgSearch.multisearch(query).map { |result| result.searchable }

    # 3. ElasticSearch:
    # Movie.search(query)
  end
end
