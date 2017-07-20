require_relative '../config/environment.rb'

class Scraper
  TOURS_PAGE = "http://phish.net/tour/"
  SONGS_PAGE = "http://phish.net/song/"

  def self.scrape_tours
    page = Nokogiri::HTML(open(TOURS_PAGE))
    cells = page.css("td")
    i=0
    while i < cells.length
      name = cells[i].text
      link = cells[i].css("a").first["href"]
      year = cells[i+1]
      shows = cells[i+2].text.split(" ")[0].to_i
      Tour.new(name,link,year,shows)
      i+=3
    end
    binding.pry
  end

  def self.scrape_songs
    page = Nokogiri::HTML(open(SONGS_PAGE))
    cells = page.css("td")
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

end
