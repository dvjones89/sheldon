require 'fileutils'
require_relative 'sheldon/brain'

class Sheldon

  def test(recall_cue)
    puts brain.memory.has_cue?(recall_cue)
  end

  def learn(rel_learn_path)
    abs_learn_path = File.join(Dir.pwd, rel_learn_path)
  
    print("Friendly Name For File/Folder: ")
    recall_cue = STDIN.gets.chomp

    if brain.memory.has_cue?(recall_cue)
      raise "This cue has already been used. Please provide another."
    else
      brain.learn(recall_cue, abs_learn_path)
    end

  end

  private
    def brain
      sheldon_data_dir = File.expand_path("~/sheldon2")
      @brain ||= Brain.new(sheldon_data_dir)
    end

end
