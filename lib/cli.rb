require_relative '../config/environment.rb'

class CommandLineInterface

  HELP_DIALOG = "This is the help dialog.\n\nKEYWORD: Use\n\nHELP: This dialog\nTOUR: Search by tour"
  PROMPT_DIALOG = "Type \'help\' to get a list of commands."
  command_in = false

  def self.command(string)
    puts HELP_DIALOG if string.downcase == "help"
    search_by_tour if string.downcase == "tour"
    stops if string.downcase == "stop"
    command(gets.chomp)
  end

  def self.search_by_tour
    puts "BY TOUR"
    puts "How would you like to proceed?"
    puts "1. By Tour Name"
    puts "2. By Year"
    input = gets.chomp.to_i
    tour_by_year if input == 1
    tour_by_name if input == 2
    puts "Invalid input, try again!"
    search_by_tour
  end

  Scraper.new
  while !command_in
    puts "Welcome to G-YEM, the Phish Gem."
    puts PROMPT_DIALOG
    command(gets.chomp)
  end

end
