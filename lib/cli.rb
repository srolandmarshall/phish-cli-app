require_relative '../config/environment.rb'

class CommandLineInterface

  HELP_DIALOG = "This is the help dialog.\n\nKEYWORD: Use\n\nHELP: This dialog\nTOUR: Search by tour"
  PROMPT_DIALOG = "Type \'help\' to get a list of commands."
  command_in = false
  scraper = Scraper.new

  def initialize
    greeting
  end

  def greeting
    puts "Welcome to G-YEM, the Phish Gem."
    puts PROMPT_DIALOG
    command(gets.chomp)
  end

  def command(string)
    puts HELP_DIALOG if string.downcase == "help"
    search_by_tour if string.downcase == "tour"
    stops if string.downcase == "stop"
    command(gets.chomp)
  end

  def tour_year(year)
    year_tours = Tour.all.select {|tour| tour.year.include?(year)}
    puts "Tours from #{year}" if year_tours != []
    i = 0
    year_tours.each do |tour|
        i+=1
        puts "#{i}.#{tour.name}"
    end
    puts "Type the number of the tour you want to explore, or type \'back\' to go back:"
    explore = gets.chomp
    Scraper.scrape_tour(Tour.find_by_name(year_tours[explore.to_i-1].name)) if explore.to_i < year_tours.length

    binding.pry
    puts "There were no tours this year, please try again." if year_tours == []
    tour_by_year if year_tours == []
  end

  def tour_by_year
    puts "Enter the year you'd like to explore, or type \n'back\' if you want to go back to the main menu:"
    year = gets.chomp
    tour_year(year)
    intro if year == "back"
  end

  def search_by_tour
    puts "BY TOUR"
    puts "How would you like to proceed?"
    puts "1. By Tour Name"
    puts "2. By Year"
    input = gets.chomp.to_i
    tour_by_year if input == 2
    tour_by_name if input == 1
    puts "Invalid input, try again."
    search_by_tour
  end

end
