# USAGE
# Navigate to directory where symlinks are to be created (e.g ~/ssh)
# Run 'sheldon <collection-name>' for example 'sheldon ssh'
# For each file in the directory "config/ssh" you'll be given the option to symlink

require 'FileUtils'

target_path = Dir.pwd
target_dir = ARGV[0] || Dir.getwd
puts target_dir
collection_dir = File.expand_path("../../#{target_dir}",__FILE__)

# Dir.entries(collection_dir).each do |entry|
#   source_path =  File.join(collection_dir,entry)
#   if File.file?(source_path)
#     puts "Symlink #{entry}?"
#     answer = STDIN.gets.chomp
#     if answer.downcase == "y"
#       FileUtils.ln_s(source_path, target_path, :force=>true)
#     end
#   end
# end