require_relative '../config/environment.rb'

class CommandLineInterface

  HELP_DIALOG = "This is the help dialog.\n\nKEYWORD: Use\n\nHELP: This dialog\nTOUR: Search by tour"
  PROMPT_DIALOG = "Type \'help\' to get a list of commands."
  command_in = false
  scraper = Scraper.new

  def intro
    puts "Welcome to G-YEM, the Phish Gem."
    puts PROMPT_DIALOG
    command(gets.chomp)
  end

  def initialize
    intro
  end

  def command(string)
    puts HELP_DIALOG if string.downcase == "help"
    search_by_tour if string.downcase == "tour"
    stops if string.downcase == "stop"
    command(gets.chomp)
  end

  def pick_tour(tour)
    tour.display_tour
    puts "Choose the number of the show you'd like to select."
    choice = gets.chomp
    if choice.to_i <= tour.shows.length
      tour.shows[choice.to_i-1].display_show
    else
      puts "Invalid show, try again"
      pick_tour(tour)
    end
  end

  def tour_year(year)
    year_tours = Tour.all.select {|tour| tour.year.include?(year)}
    if year_tours != []
      puts "Tours from #{year}"
      i = 0
      year_tours.each do |tour|
        i+=1
        puts "#{i}.#{tour.name}"
      end
      puts "Type the number of the tour you want to explore, or type \'back\' to go back:"
      entry = false
      while !entry
      explore = gets.chomp
        if (explore.to_i <= year_tours.length)&&(explore.to_i > 0)
          pick_tour(Scraper.scrape_tour(Tour.find_by_name(year_tours[explore.to_i-1].name))
          entry = true
        else
          puts "Invalid Entry, try again."
        end
      end
    end
    puts "There were no tours this year, please try again." if year_tours == []
    tour_by_year if year_tours == []
  end

  def tour_by_year
    puts "Enter the year you'd like to explore, or type \n'back\' if you want to go back to the main menu:"
    year = gets.chomp
    if (year != "")&&(year.to_i > 1982)&&(year.to_i < 2018)#eventually turn this into check for the current year FUTURE PROOFING
      tour_year(year)
    elsif year == "back"
      intro
    else
      puts "Invalid year, try again."
    end
  end

  def search_by_tour
    puts "BY TOUR"
    puts "How would you like to proceed?"
    puts "1. By Tour Name"
    puts "2. By Year"
    input = gets.chomp.to_i
    tour_by_name if input == 1
    tour_by_year if input == 2
    intro if input == "back"
    puts "Invalid input, try again."
    search_by_tour
  end

end
