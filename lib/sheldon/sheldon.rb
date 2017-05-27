require "fileutils"

class Sheldon
  VERSION = "0.4.0".freeze
  attr_reader :brain, :builder

  def initialize(sheldon_data_dir, opts = {})
    unless Dir.exists?(sheldon_data_dir)
      raise MissingDataDirectoryException, "The data directory (#{sheldon_data_dir}) doesn't exist. Please create the directory or set an alternative using the $SHELDON_DATA_DIR environment variable."
    end

    @brain = opts[:brain] || Brain.new(sheldon_data_dir)
    @builder = opts[:builder] || Builder.new
  end

  def build(abs_learn_path)
    builder.build(abs_learn_path)
  end

  def learn(recall_cue, abs_learn_path)
    raise "recall cue cannot be empty." if recall_cue.strip.empty?
    if brain.has_cue?(recall_cue)
      raise "This cue has already been used."
    else
      brain.learn(recall_cue, abs_learn_path)
    end
  end

  def recall(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.recall(recall_cue)
  end

  def forget(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.forget(recall_cue)
  end

  def list_cues
    brain.list_cues
  end

  def recalled?(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.recalled?(recall_cue)
  end

end
