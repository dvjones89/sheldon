# Another dotfile/config manager. Bazinga!
class Sheldon
  require 'fileutils'

  # Takes multiple 'config_' files and builds a master 'config' file
  # dir = the directory (relative to ~) that should be built.
    # Defaults to current working dir.

    @logo = '💥'.encode('utf-8') + ' '

    def self.build(dir)
      dir = File.basename(Dir.getwd) if dir.nil?
      home_directory = File.expand_path('~')
      target_dir = File.join(home_directory, dir)
      buffer = ''
      Dir.entries(target_dir).each do |file_name|
        if file_name.include?('config_')
          file_path = File.join(target_dir, file_name)
          content = File.read(file_path)
          buffer += content + "\n"
        end
      end
      master_config = File.join(target_dir, 'config')
      File.open(master_config, 'w') { |f| f.write(buffer) }
      puts @logo + 'Sheldon' + @logo + " Built #{dir}"
    end

    def self.link(root)
      root = File.basename(Dir.getwd) if root.nil?
      sheldon_data_dir = ENV['SHELDON_DATA_DIR'] || '~/dev/sheldon'

      sheldon_path = File.join(sheldon_data_dir, root)
      
      Dir.entries(sheldon_path).each do |config_file|
        next if config_file == '.' || config_file == '..'
        config_path = File.join(sheldon_path, config_file)
        if File.directory?(config_path)
          test(File.join(root, config_file))
        else
          target_path = File.join(Dir.pwd, '..', root, config_file)
          unless File.exist?(target_path)
            print "Symlink #{File.join(root, config_file)} (y/n) ? "
            answer = STDIN.gets.chomp
            if answer.downcase == 'y'
              FileUtils.ln_s(config_path, target_path, force: true)
            end
          end
        end
      end

      puts @logo + 'Sheldon' + @logo + ' Linking Complete'
    end

  # This is the entry point when Sheldon is called from command-line.
  # Here we route the user's request to the correct method, or complain.
  method = ARGV[0]
  case method
  when 'build'
    build(ARGV[1])
  when 'link'
    link(ARGV[1])
  else
    puts "I may be a genius but even I don't know how to do that!"
  end
end