require 'FileUtils'

target_dir = Dir.pwd
collection_dir = File.expand_path("../../#{ARGV[0]}",__FILE__)

Dir.entries(collection_dir).each do |entry|
  source_path =  File.join(collection_dir,entry)
  if File.file?(source_path)
    puts "Symlink #{entry}?"
    answer = STDIN.gets.chomp
    if answer.downcase == "y"
      FileUtils.ln_s(source_path, target_dir)
    end
  end
end