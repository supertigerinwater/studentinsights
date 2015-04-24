after :schools, :x2, :attendance do
  puts "STAR:"
  healey_math_05_path = "#{Rails.root}/data/star_healey_math_05.csv"
  healey_reading_05_path = "#{Rails.root}/data/star_healey_reading_05.csv"

  if File.exist? healey_math_05_path
    puts "   Importing STAR math data..."
    importer = StarImporter.new(healey_math_05_path, Time.new(2015), "math").import
    puts "      #{StarResult.all.size} STAR Math results."
  else
    puts "   No STAR data file found."
  end

  if File.exist? healey_reading_05_path
    puts "   Importing STAR reading data..."
    importer = StarImporter.new(healey_reading_05_path, Time.new(2015), "reading").import
    puts "      #{StarResult.all.size} STAR Reading results."
  else
    puts "   No STAR data file found."
  end
end