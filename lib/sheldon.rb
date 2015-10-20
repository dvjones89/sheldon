require 'fileutils'
require 'pathname'
require 'yaml/store'
require_relative 'sheldon/helpers'

class Sheldon
  
  include Helpers

  def learn(rel_learn_path)
    abs_learn_path = File.join(Dir.pwd, rel_learn_path)
    basename = File.basename(rel_learn_path)

    database = load_db 
  
    print("Friendly Name For File/Folder: ")
    friendly_name = STDIN.gets.chomp

    database.transaction do
      if friendly_name == '' || database[friendly_name]
        puts "Name not specified or already in use. Please try again."
        abort
      else
        abs_brain_path = File.join(locate_brain, friendly_name)
        FileUtils.mkdir_p(abs_brain_path)
        FileUtils.mv(abs_learn_path, abs_brain_path)
        FileUtils.ln_s(File.join(abs_brain_path, basename), abs_learn_path)
        database[friendly_name] = {file_path: remove_home(abs_learn_path)}
      end
    end

  end

  def list
    database = load_db
    database.transaction do
      database.roots.each { |friendly_name| puts friendly_name }
    end
  end

  def link(friendly_name)
    database = load_db
    database.transaction do
      data = database[friendly_name]
      if data
        FileUtils.ln_s(add_home(data[:brain_path]), add_home(data[:file_path]))
      else
        puts "Unable to find entry '#{friendly_name}'"
      end
    end
  end
end
