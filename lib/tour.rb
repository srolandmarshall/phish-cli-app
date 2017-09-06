require_relative '../config/environment.rb'

class Tour

  @@all = []
  attr_accessor :name, :year, :num_shows, :link, :shows

  TOURS_PAGE ||= "http://phish.net/tour"

  def initialize(name="",link="",year="",num_shows=0,shows=[])
    @name = name
    @year = year
    @num_shows = num_shows
    @shows = shows
    @link = "http://phish.net#{link}"
    @@all << self
  end

  def self.find_by_name(name)
    self.all.each do |tour|
      return tour if tour.name == name
    end
    nil
  end

  def display_tour
    puts self.name.upcase
    i = 1
    #use this for the display multiple shows, should be inherited by both classes but gonna make it work first
    self.shows.each do |show|
      puts "#{i}. #{show.date}, #{show.city}"
      i+=1
    end
    puts "*** TOUR END ***"
  end

  def add_show(show)
    @shows << show
  end

  def self.all
    @@all
  end

  def self.tours_after(year)
    @@all.select {|tour| tour.year.to_i > year}
  end

  def self.tours_between(year_one,year_two)
    @@all.select {|tour| (tour.year.to_i <= year_two) && (tour.year.to_i >= year_one)}
  end

end
