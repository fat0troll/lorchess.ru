# -*- coding: utf-8 -*-
module Jekyll
  class ReviewsGenerator < Generator
    safe true
    priority :low

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
      site.posts.reverse_each do |post|
        review_entry(site, post) unless post.data['pgn'].nil?
      end
    end

    # Creates a review entry from the given post
    def review_entry(site, post)
      # Creates the link to post
      @buffer += "\n<p class=\"lead\" style=\"margin-bottom:0\">"
      @buffer += "<a href=\"#{site.baseurl}#{post.url}\">#{post.title}</a>"
      @buffer += "</p>\n"

      @buffer += "<dl class=\"dl-horizontal\">\n"

      # Creates the date of post
      post_date = post.date.strftime("%d %B %Y")
      @buffer += "<dt>Дата:</dt><dd>#{post_date}</dd>\n"

      pgn = post.data['pgn']
      if pgn =~ /^\//
        none, year, tournament, basename = pgn.split '/'
      else
        year, tournament, basename = pgn.split '/'
      end

      # Finds the tournament that the game was played in
      catch :trn_found do
        site.data['tournaments'].each do |entry|
          entry['events'].each do |trn|
            # Remove the trailing slash from the tournament directory if needed
            if entry['year'] == year.to_i && trn['dir'].sub(/\/$/, '') == tournament
              trn_link = "<a href=\"" + trn['url'] + "\">" + trn['title'] + "</a>"
              @buffer += "<dt>Турнир:</dt><dd>#{trn_link}</dd>\n"
              throw :trn_found
            end
          end
        end
      end

      # Creates the game info
      white, black  = basename[11..-1].sub(/-with-comments\.pgn$/, '').split('-vs-')
      white_link    = "<a href=\"https://www.linux.org.ru/people/#{white}/profile\">#{white}</a>"
      black_link    = "<a href=\"https://www.linux.org.ru/people/#{black}/profile\">#{black}</a>"
      game_date_str = basename[0..9]
      game_date     = Time.parse(game_date_str).strftime("%d %b %Y")
      @buffer += "<dt>Игра:</dt><dd>#{white_link} vs. #{black_link} (#{game_date})</dd>\n"

      @buffer += "</dl>\n"
    end
  end
end
