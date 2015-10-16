# Another dotfile/config manager. Bazinga!
class Sheldon
  require 'fileutils'
  require 'pathname'
  require 'yaml/store'

    def self.announce(message)
      logo = '💥'.encode('utf-8') + ' '
      puts logo + "Sheldon" + logo + " #{message}"
    end

    # PUBLIC METHOD: Prints the absolute path where Sheldon searches for his intelligence.
    # Read from environment variable SHELDON_DATA_DIR or falls back to ~/sheldon
    def self.locate_brain
      relative_path = '~/sheldon2'
      # relative_path = ENV['SHELDON_DATA_DIR'] || '~/sheldon'
      Pathname(relative_path).expand_path # Deals with the use of ~ when referencing home directories
    end

    # # PUBLIC METHOD: Based on the user's current directory, prints the names of any config files that Sheldon could potentially link
    # def self.list
    #   config_files = configs_in_path(File.join(brains, File.basename(Dir.getwd)))
    #   if config_files.empty?
    #     announce "I don't have any linkable files for your directory, I'm afraid."
    #   else
    #     announce 'The following files are eligible for linking to your current directory. Run `sheldon link` to get started.'
    #     puts config_files
    #   end
    # end

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

    # # PRIVATE METHOD: Returns a list of files within a path, excluding files mentioned in config/.sheldonignore
    # def self.configs_in_path(path)
    #   return [] if !File.exists?(path)
    #   ignored_files = File.readlines(File.join(File.dirname(__FILE__), '../config/.sheldonignore')) # Files to be ignored are defined in config/.sheldonignore
    #   ignored_files.map!(&:strip) # Remove any \n characters that have been read from the .sheldonignore file
      
    #   Dir.entries(path).reject{ |config_file| ignored_files.include?(config_file)} # Return list of directory contents minus any files that are blacklisted in config/.sheldonignore
    # end

    # PUBLIC METHOD: Finds all 'config_' files in a directory and compiles them to a single master 'config' file that can then easily be sourced.
    def self.build(dir)
      dir = File.basename(Dir.getwd) if dir.nil?
      home_directory = File.expand_path('~')
      source_dir = File.join(home_directory, dir)
      buffer = ''
      Dir.entries(source_dir).each do |file_name|
        if file_name.include?('config_')
          file_path = File.join(source_dir, file_name)
          content = File.read(file_path)
          buffer += content + "\n"
        end
      end
      master_config = File.join(source_dir, 'config')
      File.open(master_config, 'w') { |f| f.write(buffer) }
      announce("Built #{dir}")
    end

    # PUBLIC METHOD: Takes the user's working directory and looks for a matching entry in Sheldon's data directory.
    # If a matching entry exists, offer to symlink files within that directory (and sub-folders) to your local file-system.
    # def self.link(root)
    #   root = File.basename(Dir.getwd) if root.nil? # Root of tree traversal. Defaults to user's working directory
    #   sheldon_data_dir = brains # Where do we search for matching config files

    #   sheldon_path = File.join(sheldon_data_dir, root) # Join the relevant subfolder(s) to the Sheldon data directory
    #   configs_in_path = configs_in_path(sheldon_path) # Retrieve a list of files found in the data directory (exclusing those blacklisted in config/.sheldonignore)
      
    #   if configs_in_path.empty?
    #     puts "I don't have any files for the #{root} directory, I'm afraid."
    #     exit
    #   end

    #   configs_in_path.each do |config_file|
    #     config_path = File.join(sheldon_path, config_file)
    #     if File.directory?(config_path)
    #       link(File.join(root, config_file)) # Recursive call to explore the directory we've just found
    #     else
    #       target_dir = File.join(Dir.pwd, '..', root)
    #       target_path = File.join(target_dir, config_file)
      
    #       unless File.symlink?(target_path) && File.exists?(File.readlink(target_path)) # An existing (unbroken) symlink suggests Sheldon has already done his thing.
    #         print "Symlink #{File.join(root, config_file)} (y/n) ? "
    #         answer = STDIN.gets.chomp
    #         if answer.downcase == 'y'
    #           FileUtils.mkdir_p(target_dir) if !Dir.exists?(target_dir) # If the target directory doesn't exist, create it, else our attempt to symlink will go horribly wrong
    #           FileUtils.ln_s(config_path, target_path, force: true)
    #         end
    #       end
    #     end
    #   end

    #   # Linking is complete when we've traversed up and down the tree, returning back to the root (the user's working dir)
    #   announce 'Linking Complete' if root == File.basename(Dir.getwd)
    # end

  # This is the entry point when Sheldon is called from command-line.
  # Here we route the user's request to the correct method, or complain.
  method = ARGV[0]
  brain = YAML::Store.new("/Users/dave/brain.yml")
  case method
  # when 'build'
    # build(ARGV[1])
  # when 'link'
    # link(ARGV[1])
  when 'learn'
    learn(ARGV[1])
  # when 'brains'
    # announce brains
  # when 'ls'
    # list
  else
    puts "I may be a genius but even I don't know how to do that!"
  end
end
