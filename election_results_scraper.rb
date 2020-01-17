require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url))

  output = @parsed_page.css(".wikitable")[14].css("tbody").css("tr").css("td").children.map(&:text)

  print output
  # print @parsed_page
  j = 0
  56.times do |i|     # 56 from 50 states, plus Washington DC, plus 2 Maine congressional districts, and 3 Nebraska ones
    puts output[j]
    until output[j + 2] =~ /[0-9]/  # For handling variable number of 'td's between state name and vote numbers
      j += 1                        # due to additional details provided for states that split their electoral votes
    end                             # by congressional district, specifically Maine and Nebraska
    puts output[j + 2]
    puts output[j + 4]
    puts output[j + 5]
    puts output[j + 7]
    j += 24
    while i!=55 && (output[j][0] == "[" || output[j][0] == "\n") # For handling a variable number of citations per row
      j += 1                                       # skips each one, then skips newline, leaving j at start of next row
    end
    puts "_______________\n"
  end

  # print "test"
end