# Another dotfile/config manager. Bazinga!
class Sheldon

  # Takes multiple 'config_' files and builds a master 'config' file
  # dir = the directory (relative to ~) that should be built.
    # Defaults to current working dir.
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
    puts "Sheldon" + '💥'.encode('utf-8') + " Built #{dir}"
  end

  # Takes user's working dir and offers to symlink any known configs.
    # working dir can be overriden as first argument
  def self.link(dir)
    sheldon_dir = dir || File.basename(Dir.getwd)
    sheldon_path = File.expand_path("../../#{sheldon_dir}", __FILE__)

    Dir.entries(sheldon_path).each do |config_file|
      config_path = File.join(sheldon_path, config_file)
      if File.file?(config_path)

        print "Symlink #{config_file} (y/n) ? "
        answer = STDIN.gets.chomp
        if answer.downcase == 'y'
          FileUtils.ln_s(config_path, target_path, force: true)
        end
      end
    end
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