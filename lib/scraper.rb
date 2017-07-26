require_relative '../config/environment.rb'

class Scraper
  TOURS_PAGE ||= "http://phish.net/tour"
  SONGS_PAGE ||= "http://phish.net/song/?"
  SHOWS_PAGE ||= "http://phish.net/setlists/?"

  def self.scrape_tours
    page = Nokogiri::HTML(open(TOURS_PAGE))
    cells = page.css("table").first.css("td")
    i=0
    while i < cells.length
      name = cells[i].text
      link = cells[i].css("a").first["href"]
      year = cells[i+1]
      shows = cells[i+2].text.split(" ")[0].to_i
      Tour.new(name,link,year,shows)
      i+=3
    end
  end

  def self.scrape_songs
    page = Nokogiri::HTML(open(SONGS_PAGE))
    cells = page.css("td")
    i=0
    while i < cells.length
      if cells[i+2].text.to_i != 0
        name = cells[i].text
        link = cells[i].css("a")[0]["href"]
        original_artist = cells[i+1].text
        times =  cells[i+2].text.to_i
        debut = cells[i+3].text
        last = cells[i+4].text
        gap = cells[i+5].text.to_i
        Song.new(name,link,original_artist,times,debut,last,gap) # replace with find or create later
      end
      i+=6
    end
  end

  def self.scrape_show(page)
    binding.pry
  end

  def self.scrape_shows

    Tour.all.each do |tour|
      links = []
      tour_page = Nokogiri::HTML(open(tour.link))
      tour_page.css("a").each {|link| links << link["href"] if link["href"] =~ /setlists\/phish/}
      links.each do |link|
        show_page = Nokogiri::HTML(open("http://phish.net/#{link}"))
        scrape_show(show_page)
      end
    end
  end

  self.scrape_tours
  self.scrape_shows


end
