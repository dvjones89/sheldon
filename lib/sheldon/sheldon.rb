require "fileutils"

class Sheldon
  VERSION = "0.2.7".freeze
  attr_reader :brain, :builder

  def initialize(sheldon_data_dir, opts = {})
    raise MissingDataDirectoryException unless Dir.exists?(sheldon_data_dir)
    @brain = opts[:brain] || Brain.new(sheldon_data_dir)
    @builder = opts[:builder] || Builder.new
  end

  def build(abs_learn_path)
    builder.build(abs_learn_path)
  end

  def learn(recall_cue, abs_learn_path)
    if brain.has_cue?(recall_cue)
      raise "This cue has already been used."
    else
      brain.learn(recall_cue, abs_learn_path)
    end
  end

  def list_cues
    brain.list_cues
  end

  def recalled?(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.recalled?(recall_cue)
  end

  def recall(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.recall(recall_cue)
  end

end
