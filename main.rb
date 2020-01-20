require 'csv'

table = CSV.parse(File.read("2016results.csv"), converters: :numeric, headers: true)
puts("\nDem total votes: #{table.by_col["D_votes"].sum}")
puts("Rep total votes: #{table.by_col["R_votes"].sum}")

dem_EVs, rep_EVs = 0, 0
table.each do |row|
  dem_EVs += row["EVs"] if row["D_votes"] > row["R_votes"]
  rep_EVs += row["EVs"] if row["R_votes"] > row["D_votes"]
end

puts("\nDem electoral votes: #{dem_EVs}")
puts("Rep electoral votes: #{rep_EVs}")
puts("Winner is the #{(dem_EVs>rep_EVs)?"Democrat":"Republican"}")