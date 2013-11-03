# USAGE
# Navigate to directory where symlinks are to be created (e.g ~/.ssh)
# Sheldon will try to symlink configs from a subdirectory with the same name as your current directory.
# If the directories don't match, tell Sheldon where to find the configs:'sheldon .ssh2'

# For each config in the source directory, you'll be given the option to symlink to your current location.

require 'fileutils'

# Get the user's current directory - This will be the target of any symlinks we create
target_path = Dir.pwd

# Determine which sheldon directory to read configs from
# This defaults to the name of the user's current directory but can be overwritten with first arg
sheldon_dir = ARGV[0] || dirname = File.basename(Dir.getwd)
sheldon_path = File.expand_path("../../#{sheldon_dir}",__FILE__)

Dir.entries(sheldon_path).each do |config_file|
  config_path =  File.join(sheldon_path,config_file)
  if File.file?(config_path)
    puts "Symlink #{config_file}?"
    answer = STDIN.gets.chomp
    if answer.downcase == "y"
      FileUtils.ln_s(config_path, target_path, :force=>true)
    end
  end
end