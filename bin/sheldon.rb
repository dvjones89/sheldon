# Another dotfile/config manager. Bazinga!
class Sheldon
  require 'fileutils'

    def self.announce(message)
      logo = '💥'.encode('utf-8') + ' '
      puts logo + "Sheldon" + logo + " #{message}"
    end

    # Get the directory from which Sheldon reads his intelligence (AKA Data Directory)
    # Read from environment variable SHELDON_DATA_DIR or falls back to ~/sheldon
    def self.brains
      ENV['SHELDON_DATA_DIR'] || '~/sheldon'
    end

    # Finds all 'config_' files in a directory and compiles them to a single master 'config' file that can then easily be sourced.
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

    # Takes the user's working directory and looks for a matching entry in Sheldon's data directory.
    # If a matching entry exists, offer to symlink files within that directory (and sub-folders) to your local file-system.
    def self.link(root)
      root = File.basename(Dir.getwd) if root.nil? # Root of tree traversal. Defaults to user's working directory
      sheldon_data_dir = brains # Where do we search for matching config files

      sheldon_path = File.join(sheldon_data_dir, root)

      # Abort linking if the sheldon data dir doesn't contain an entry for the user's working dir
      if !File.exists?(sheldon_path)
        puts "I don't have any files for the #{root} directory, I'm afraid."
        exit
      end

      # Otherwise, iterate over the contents of the matching data directory, exploring directories as they're encountered (depth-first traversal)
      Dir.entries(sheldon_path).each do |config_file|
        next if config_file == '.' || config_file == '..'
        config_path = File.join(sheldon_path, config_file)
        if File.directory?(config_path)
          link(File.join(root, config_file)) # Recursive call to explore the directory we've just found
        else
          target_path = File.join(Dir.pwd, '..', root, config_file)
          unless File.symlink?(target_path) && File.exists?(File.readlink(target_path)) # An existing (unbroken) symlink suggests Sheldon has already done his thing.
            print "Symlink #{File.join(root, config_file)} (y/n) ? "
            answer = STDIN.gets.chomp
            if answer.downcase == 'y'
              FileUtils.ln_s(config_path, target_path, force: true)
            end
          end
        end
      end

      # Linking is complete when we've traversed up and down the tree, returning back to the root (the user's working dir)
      announce 'Linking Complete' if root == File.basename(Dir.getwd)
    end

  # This is the entry point when Sheldon is called from command-line.
  # Here we route the user's request to the correct method, or complain.
  method = ARGV[0]
  case method
  when 'build'
    build(ARGV[1])
  when 'link'
    link(ARGV[1])
  when 'brains'
    announce brains
  else
    puts "I may be a genius but even I don't know how to do that!"
  end
end