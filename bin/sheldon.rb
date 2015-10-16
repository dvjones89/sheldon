# Another dotfile/config manager. Bazinga!
class Sheldon
  require 'fileutils'
  require 'pathname'
  require 'yaml/store'

    # PUBLIC METHOD: Prints the absolute path where Sheldon searches for his intelligence.
    # Read from environment variable SHELDON_DATA_DIR or falls back to ~/sheldon
    def self.locate_brain
      relative_path = '~/sheldon2'
      # relative_path = ENV['SHELDON_DATA_DIR'] || '~/sheldon'
      Pathname(relative_path).expand_path # Deals with the use of ~ when referencing home directories
    end

    def self.learn(path_to_learn)
      database = YAML::Store.new(File.join(locate_brain, 'db.yaml')) 
      abs_learn_path = File.join(Dir.pwd, path_to_learn)
      rel_brain_path = Pathname(abs_learn_path).relative_path_from Pathname('~').expand_path
      abs_brain_path = File.join(locate_brain,rel_brain_path)

      print("Friendly Name For File/Folder: ")
      friendly_name = STDIN.gets.chomp

      database.transaction do
        if friendly_name == '' || database[friendly_name]
          puts "Name not specified or already in use. Please try again."
          abort
        else
          if File.file?(abs_learn_path)
            dest_path = File.dirname(abs_brain_path) # If we're learning about a file, just create and move to the parent director(ies)
          else
            dest_path = File.join(abs_brain_path, '..') # If we're learning about a directory, we want to create parent director(ies) and drop the new file at the leaf
          end

          FileUtils.mkdir_p(dest_path)
          FileUtils.mv(abs_learn_path, dest_path)
          FileUtils.ln_s(abs_brain_path, abs_learn_path)
          database[friendly_name] = {file_path: rebase_from_home(abs_learn_path), brain_path: rebase_from_home(abs_brain_path)}
        end
      end

    end

    def self.rebase_from_home(path)
      home_path = Pathname(File.expand_path('~'))
      Pathname(path).relative_path_from(home_path).to_s
    end

  

  method = ARGV[0]
  case method
  when 'learn'
    learn(ARGV[1])
  else
    puts "I may be a genius but even I don't know how to do that!"
  end
end
