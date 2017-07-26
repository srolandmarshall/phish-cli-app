require_relative '../config/environment.rb'

class Setlist

  attr_accessor :set1, :set2, :set3, :set4, :encore, :date, :show

  def initialize(set1=[], set2=[], set3=[], set4=[], encore=[], date="", show=Show.new)
    @set1 = set1
    @set2 = set2
    @set3 = set3
    @set4 = set4
    @date = date
    @show = show
  end

  def display

  end

end
