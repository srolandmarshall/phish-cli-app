require_relative '../config/environment.rb'

class Setlist

  @@all = []
  attr_accessor :set1, :set2, :set3, :set4, :encore, :show

  def initialize(set1=[], set2=[], set3=[], set4=[], encore=[], show=Show.new)
    @set1 = set1
    @set2 = set2
    @set3 = set3
    @set4 = set4
    @encore = encore
    @show = show
  end

  def display

  end

  def self.all
    @@all
  end

end
