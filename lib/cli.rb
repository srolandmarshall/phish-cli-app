require_relative '../config/environment.rb'

class CommandLineInterface

  Scraper.new
  binding.pry
  puts "Welcome to G-YEM, the Phish Gem.\nType \'help\' to get a list of commands."

end
