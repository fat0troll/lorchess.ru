# -*- coding: utf-8 -*-
module Jekyll
  class ReviewsGenerator < Generator
    safe true
    priority :low

    # Russian locale
    include I18nFilter

    # Generates the reviews file
    def generate(site)
      @buffer = ''

      # Create the destination folder if necessary
      reviews_dest = File.join(site.dest, 'reviews')
      FileUtils.mkdir_p(reviews_dest) unless File.directory?(reviews_dest)

      # Write the contents of reviews file
      File.open(File.join(reviews_dest, 'index.html'), 'w') do |f|
        generate_header
        generate_content site
        f.write @buffer
        f.close
      end

      # Add the reviews file, so it won't be cleaned
      site.pages << Page.new(site, site.dest, 'reviews', 'index.html')
    end

    # Add the YAML header
    def generate_header
      @buffer += "---\nlayout: page\n---\n"
    end

    # Add a string containing the review entries
    def generate_content(site)
      # Creates a hash mapping paths to tournaments
      tournaments = site.data['tournaments']
      path = tournaments.map do |entry|
        entry['events'].map { |trn| entry['year'].to_s + "/" + trn['dir'].sub(/\/$/, '') }
      end.flatten
      trn = tournaments.map { |entry| entry['events'] }.flatten
      @trn_hash = Hash[ path.zip(trn) ]

      # Creates review entries
      site.posts.reverse_each do |post|
        review_entry(site, post) unless post.data['pgn'].nil?
      end
    end

    # Creates a review entry from the given post
    def review_entry(site, post)
      # Adds the link to post
      @buffer += "\n<p class=\"lead\" style=\"margin-bottom:0\">"
      @buffer += "<a href=\"#{site.baseurl}#{post.url}\">#{post.title}</a>"
      @buffer += "</p>\n"

      @buffer += "<dl class=\"dl-horizontal\">\n"

      # Adds the date of post
      post_date = localize(post.date, "%d %B %Y")
      @buffer += "<dt>Дата:</dt><dd>#{post_date}</dd>\n"

      pgn = post.data['pgn']
      if pgn =~ /^\//
        none, year, tournament, basename = pgn.split '/'
      else
        year, tournament, basename = pgn.split '/'
      end

      # Adds the tournament of the game
      trn = @trn_hash[ year + "/" + tournament ]
      trn_link = "<a href=\"" + trn['url'] + "\">" + trn['title'] + "</a>"
      @buffer += "<dt>Турнир:</dt><dd>#{trn_link}</dd>\n"

      # Adds the game info
      white, black  = basename[11..-1].sub(/-with-comments\.pgn$/, '').split('-vs-')
      white_link    = "<a href=\"https://www.linux.org.ru/people/#{white}/profile\">#{white}</a>"
      black_link    = "<a href=\"https://www.linux.org.ru/people/#{black}/profile\">#{black}</a>"
      game_date_str = basename[0..9]
      game_date     = localize(Time.parse(game_date_str), "%d %b %Y")
      @buffer += "<dt>Игра:</dt><dd>#{white_link} vs. #{black_link} (#{game_date})</dd>\n"

      @buffer += "</dl>\n"
    end
  end
end
