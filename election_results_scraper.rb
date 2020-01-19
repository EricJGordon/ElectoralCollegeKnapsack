require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/wiki/2012_United_States_presidential_election"
  @url3 = "https://en.wikipedia.org/wiki/2000_United_States_presidential_election"
  # @other = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url3))

  #  output = @parsed_page.css(".wikitable")[14].css("tbody").css("tr").css("td").children.map(&:text)     # 2016
  #  output = @parsed_page.css(".wikitable")[6].css("tbody").css("tr").css("td").children.map(&:text)        # 2012
  # output = @parsed_page.css(".wikitable")[7].css("tbody").css("tr").css("td").children.map(&:text)        # 2008
  # output = @parsed_page.css(".wikitable")[5].css("tbody").css("tr").css("td").children.map(&:text)        # 2004
  output = @parsed_page.css(".wikitable")[5].css("tbody").css("tr").css("td").children.map(&:text)        # 2000

  print(output, "\n\n")
  # print @parsed_page

  j = 0
  56.times do |i|     # 56 from 50 states, plus Washington DC, plus 2 Maine congressional districts, and 3 Nebraska ones
    until output[j][0] =~ /[A-Z]/ && output[j][1] =~ /[a-z]/  # For handling a variable number of citations/blank spaces
      j += 1                                                  # per row. Skips each one, leaving j at next state's name
      break if output[j].nil?
    end
    puts output[j]
    until output[j + 1] =~ /,/         # For handling a variable number of elements between state name and vote numbers
      j += 1                           # due to additional details provided for states that split their electoral votes
    end                                # by congressional district, specifically Maine and Nebraska
    puts output[j + 1]
    puts output[j + 3]
    puts output[j + 4]
    puts output[j + 6]
      j += 22
    puts "_______________\n"
    break if output[j].nil?
  end

  # print "test"
end