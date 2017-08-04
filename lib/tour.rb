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

  def add_show(show)
    @shows << show
  end

  def self.all
    @@all
  end

end
