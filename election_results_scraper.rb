require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/wiki/2012_United_States_presidential_election"
  # @other = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url))

  output = @parsed_page.css(".wikitable")[14].css("tbody").css("tr").css("td").children.map(&:text)     # 2016
  # output = @parsed_page.css(".wikitable")[6].css("tbody").css("tr").css("td").children.map(&:text)        # 2012

  print output
  # print @parsed_page

  puts
  # j = 2
  j = 0
  56.times do |i|     # 56 from 50 states, plus Washington DC, plus 2 Maine congressional districts, and 3 Nebraska ones
    puts output[j]
    until output[j + 1][0] =~ /[0-9]/  # For handling variable number of 'td's between state name and vote numbers
      j += 1                        # due to additional details provided for states that split their electoral votes
    end                             # by congressional district, specifically Maine and Nebraska
    puts output[j + 1]
    puts output[j + 3]
    puts output[j + 4]
    puts output[j + 6]
    # j += 22     # 2012
    j += 23       # 2016
    break if output[j].nil?
    while output[j][0] == "[" || output[j][0] == "\n" # For handling a variable number of citations per row
      j += 1                                       # skips each one, then skips newline, leaving j at start of next row
      break if output[j].nil?
    end
    puts "_______________\n"
  end

  # print "test"
end