require 'open-uri'
require 'pry'
require 'nokogiri'
require_relative './tour.rb'

class Scraper
  TOUR_PAGE = "http://phish.net/tour"
  page = Nokogiri::HTML(open(TOUR_PAGE))
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
