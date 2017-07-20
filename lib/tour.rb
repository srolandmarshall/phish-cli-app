require 'open-uri'
require 'pry'
require 'nokogiri'

class Tour

  @@all = []
  attr_accessor :name, :year, :shows, :link

  def initialize(name="",link="",year="",shows=0)
    @name = name
    @year = year
    @shows = shows
    @link = link
    @@all << self
  end

  def self.all
    @@all
  end

end
