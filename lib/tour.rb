require_relative '../config/environment.rb'

class Tour

  @@all = []
  attr_accessor :name, :year, :num_shows, :link, :shows

  def initialize(name="",link="",year="",num_shows=0,shows=[])
    @name = name
    @year = year
    @num_shows = num_shows
    @link = link
    @@all << self
  end

  def self.all
    @@all
  end

end
