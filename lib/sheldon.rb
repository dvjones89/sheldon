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
    recall_cue = STDIN.gets.chomp

    database.transaction do
      if recall_cue == '' || database[recall_cue]
        puts "Name not specified or already in use. Please try again."
        abort
      else
        Brain.new.learn(recall_cue, abs_learn_path)
        Brain.new.recall(recall_cue, abs_learn_path)
        # FileUtils.ln_s(source, destination)
        database[recall_cue] = {file_path: remove_home(abs_learn_path)}
      end
    end

  end

  def list
    database = load_db
    database.transaction do
      database.roots.each { |recall_cue| puts recall_cue }
    end
  end

  def link(recall_cue)
    database = load_db
    database.transaction do
      data = database[recall_cue]
      if data
        synapse = find_synapse(recall_cue, data[:file_path])
        FileUtils.ln_s(synapse, add_home(data[:file_path]))
      else
        puts "Unable to find entry '#{recall_cue}'"
      end
    end
  end
end
