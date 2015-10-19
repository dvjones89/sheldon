require 'fileutils'
require 'pathname'
require 'yaml/store'
require_relative 'sheldon/helpers'

class Sheldon
  
  include Helpers

  def learn(path_to_learn)
    database = load_db 
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
        database[friendly_name] = {file_path: remove_home(abs_learn_path), brain_path: remove_home(abs_brain_path)}
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
