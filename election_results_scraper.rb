require 'nokogiri'
require 'open-uri'
require 'csv'

class ElectionResultsScraper

  @url = "https://en.wikipedia.org/wiki/2016_United_States_presidential_election"
  @url2 = "https://en.wikipedia.org/wiki/2012_United_States_presidential_election"
  @url3 = "https://en.wikipedia.org/wiki/1988_United_States_presidential_election"
  # @other = "https://en.wikipedia.org/w/index.php?title=Template:State_results_of_the_2016_U.S._presidential_election"
  @parsed_page = Nokogiri::HTML(open(@url3))
  table_numbers = { 2016 => 14, 2012 => 6, 2008 => 7, 2004 => 5, 2000 => 5, 1996 => 6, 1992 => 7, 1988 => 7}

   output = @parsed_page.css(".wikitable")[table_numbers[1988]].css("tbody").css("tr").css("td").children.map(&:text)


  print(output, "\n\n")
  # print @parsed_page

  CSV.open("1988results.csv", "wb") do |csv|
    csv << %w(state R_votes D_votes EVs)
    j = 0
    56.times do       # 56 from 50 states, plus Washington DC, plus 2 Maine congressional districts, and 3 Nebraska ones
      row = []
      until output[j][0] =~ /[A-Z]/ && (output[j][1] =~ /[a-z]/ || output[j][1] == ".")
        j += 1                                                  # For handling a variable number of citations/blank spaces
        break if output[j].nil?                                 # per row. Skips each one, leaving j at next state's name
      end
      break if output[j].nil?     # TODO: simplify breaks
      row << output[j].delete(',').chomp
      until output[j + 1] =~ /,/         # For handling a variable number of elements between state name and vote numbers
        j += 1                           # due to additional details provided for states that split their electoral votes
      end                                # by congressional district, specifically Maine and Nebraska
      row << output[j + 1].delete(',').chomp  # order of dem/rep votes should be consistent, regardless of wikitable's order,
      row << output[j + 4].delete(',').chomp  # automatically determine by checking header?
      row << (output[j + 3].chomp!='–' ? output[j + 3].chomp : output[j + 6].chomp)
      csv << row    # TODO: stop using hyphen for check, too many variations that look the same but are treated different
      j += 22  # 22 works for all years, with the sole exception (currently) of 1988 which 17 can be used for instead
      # puts "_______________\n"
      break if output[j].nil?
    end
  end


  # print "test"
end