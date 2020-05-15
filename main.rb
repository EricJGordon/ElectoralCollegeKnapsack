require 'csv'

year = "2016"
table = CSV.parse(File.read("#{year}results.csv"), converters: :numeric, headers: true)
dem_votes = table.by_col["D_votes"].sum
rep_votes = table.by_col["R_votes"].sum
two_party_votes = dem_votes + rep_votes
puts("\nDem total votes: #{dem_votes}")
puts("Rep total votes: #{rep_votes}")
puts "(currently double counting Maine and Nebraska)"

states = Array.new

dem_EVs, rep_EVs = 0, 0
table.each do |row|
  dem_EVs += row["EVs"] if row["D_votes"] > row["R_votes"]
  rep_EVs += row["EVs"] if row["R_votes"] > row["D_votes"]

  states << {name: row["state"], weight: row["EVs"], value: (row["D_votes"]+row["R_votes"]) / 2 + 1}
end

puts("\nDem electoral votes: #{dem_EVs}")
puts("Rep electoral votes: #{rep_EVs}")
puts("The #{(dem_EVs>rep_EVs)?"Democrat":"Republican"} wins")

def knapsack(items, weight)
  chosen = Array.new
  0.upto(items.size) do |i|
    0.upto(weight) do |w|
      if i == 0 || w == 0
        @solved[i][w] = 0
      elsif items[i - 1][:weight] <= w
        @solved[i][w] = [@solved[i - 1][w], @solved[i - 1][w - items[i - 1][:weight]] + items[i - 1][:value]].max
      else
        @solved[i][w] = @solved[i - 1][w];
      end
    end
  end
  items.length.downto(0) do |i|
    if @solved[i][weight] != @solved[i - 1][weight]
        weight -= items[i - 1][:weight]
    chosen << items[i - 1]
    end
  end
  chosen
end

@solved = Array.new(states.size + 1) {Array.new(269)}

#puts states
ans = knapsack(states, 268)
puts("\nOutput: ", ans)
max_EVs_while_losing = ans.reduce(0) {|sum, x| sum + x[:weight]}
puts("\nElectoral Votes gained by winning the above states:  #{max_EVs_while_losing}")
puts("Votes needed to scrape a plurality in all of the those states:  #{ans.reduce(0) {|sum, x| sum + x[:value]}}")
min_votes = states.reduce(0) {|sum, x| sum + x[:value]} - ans.reduce(0) {|sum, x| sum + x[:value]}
puts("Comparable number of votes in the states that make up the remaining #{538 - max_EVs_while_losing} Electoral Votes: #{min_votes}")
min_percent = (min_votes.to_f/(two_party_votes)*100).round(2)
puts("As a percentage of the total (two-party) vote share, that would be #{min_percent}% ")
puts("i.e. using #{year} turnout figures, you'd only need #{min_percent}% of the total number of votes in order to win the Electoral College")
puts("(assuming that those votes were as strategically/fortuitously distributed as possible)")
puts("\nThe states and votes that comprise that most efficient Electoral College win: ",  (states.to_a - ans.to_a).map { |s| "#{s[:value]} votes in #{s[:name]}" })

winner_votes = (dem_EVs > rep_EVs)? "D_votes" : "R_votes"
loser_votes = (dem_EVs < rep_EVs)? "D_votes" : "R_votes"

puts
lost_states = Array.new

table.each do |row|
  if row[loser_votes] < row[winner_votes]
    lost_states << {name: row["state"], weight: row["EVs"], value: row[winner_votes] - row[loser_votes] + 1}
  end
end

lost_states.sort_by { |state| state[:value]}.each {|s| puts s}

def complementary_knapsack(items, weight)
  # find the least value of items that can exceed a given weight
  # achieved by finding the most value of items without exceeding (total weight - original weight), and then choose everything else
  # i.e. solving the corresponding knapsack problem, and then taking the inverse of the resulting set
  items - knapsack(items, items.reduce(0) {|sum, x| sum + x[:weight]} - weight )
end

puts "\n#{270 - [rep_EVs, dem_EVs].min} EVs needed"
flips = complementary_knapsack(lost_states, 270 - [rep_EVs, dem_EVs].min).each {|s| puts s}
puts "#{flips.reduce(0) {|sum, x| sum + x[:weight]}} EVs,  #{flips.reduce(0) {|sum, x| sum + x[:value]}} votes"