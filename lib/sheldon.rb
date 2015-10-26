require "fileutils"
require_relative "sheldon/brain"

class Sheldon

  def learn(recall_cue, rel_learn_path)
    abs_learn_path = File.join(Dir.pwd, rel_learn_path)

    if brain.has_cue?(recall_cue)
      raise "This cue has already been used. Please provide another."
    else
      brain.learn(recall_cue, abs_learn_path)
      brain.recall(recall_cue)
    end
  end

  def recall(recall_cue)
    raise "Cue '#{recall_cue}' could not be found." unless brain.has_cue?(recall_cue)
    brain.recall(recall_cue)
  end

  private

  def brain
    sheldon_data_dir = File.expand_path("~/sheldon2")
    @brain ||= Brain.new(sheldon_data_dir)
  end

end
