require "fileutils"

class Sheldon
  VERSION = "6.2.0".freeze
  attr_reader :brain, :builder

  def initialize(sheldon_data_dir)
    unless Dir.exist?(sheldon_data_dir)
      raise MissingDataDirectoryException, "Directory #{sheldon_data_dir} does not exist."
    end

    @brain = Brain.new(sheldon_data_dir)
    @builder = Builder.new
  end

  def build(abs_learn_path)
    builder.build(abs_learn_path)
  end

  def forget(recall_cue)
    brain.forget(recall_cue)
  end

  def learn(recall_cue, abs_learn_path)
    brain.learn(recall_cue, abs_learn_path)
  end

  def list_cues
    brain.list_cues
  end

  def recall(recall_cue, opts={})
    brain.recall(recall_cue, opts)
  end

  def setup!
    brain.memory.save!
  end

  def recalled?(recall_cue)
    brain.recalled?(recall_cue)
  end

end
