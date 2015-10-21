require 'fileutils'
require 'pathname'
require 'yaml/store'
require_relative 'sheldon/helpers'
require_relative 'sheldon/brain'

class Sheldon
  
  include Helpers

  def learn(rel_learn_path)
    abs_learn_path = File.join(Dir.pwd, rel_learn_path)
    database = load_db 
  
    print("Friendly Name For File/Folder: ")
    friendly_name = STDIN.gets.chomp

    database.transaction do
      if friendly_name == '' || database[friendly_name]
        puts "Name not specified or already in use. Please try again."
        abort
      else
        Brain.new.learn(friendly_name, abs_learn_path)
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
        synapse = find_synapse(friendly_name, data[:file_path])
        FileUtils.ln_s(synapse, add_home(data[:file_path]))
      else
        puts "Unable to find entry '#{friendly_name}'"
      end
    end
  end
end
